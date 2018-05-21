package Resource;

import java.security.Key;
import java.util.Calendar;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import DAOS.LoginDAO;
import Services.LoginService;
import Services.LoginServiceProvider;
import bundlePWABackend.bundlePWABackend.Login;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.impl.crypto.MacProvider;

@Path("/login")
public class LoginResource {
	final static public Key key = MacProvider.generateKey();
	@GET
	@Produces("application/json")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String getUserId(@HeaderParam("username") String username,
			  				@HeaderParam("password") String password){
		System.out.println(username+ password);
		
		LoginDAO dao = new LoginDAO();
		int id = dao.login(username, password);
		
		if(id == 0){throw new IllegalArgumentException("no user found");};
		
		JsonArrayBuilder jab = Json.createArrayBuilder();
		JsonObjectBuilder job =Json.createObjectBuilder();
		job.add("userid", id);
		jab.add(job);
		JsonArray array = jab.build();
		
		
		Calendar expiration = Calendar.getInstance();
		expiration.add(Calendar.MINUTE, 30);
		 
		String token = Jwts.builder()
				 .setSubject(username)
				 .claim("id", id)
				 .setExpiration(expiration.getTime())
				 .signWith(SignatureAlgorithm.HS512, key)
				 .compact();
		
		 return array.toString();
	}
}