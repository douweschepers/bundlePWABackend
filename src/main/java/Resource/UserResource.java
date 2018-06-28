package Resource;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.annotation.security.RolesAllowed;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.ws.rs.DELETE;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import Objects.User;
import Objects.UserLoanInformation;
import Objects.UserWithAddress;
import Services.LoanService;
import Services.ServiceProvider;
import Services.UserService;
import Validation.BasicValidation;

@Path("/user")
public class UserResource {
    private UserService service = ServiceProvider.getUserService();
    BasicValidation bs = new BasicValidation();

    
    private JsonObjectBuilder buildJSON(UserWithAddress user) {
        JsonObjectBuilder job = Json.createObjectBuilder();
        JsonObjectBuilder secondJob = Json.createObjectBuilder();
        JsonArrayBuilder secondJab = Json.createArrayBuilder();
        secondJob.add("adressid", user.getAddressId())
        	.add("street", user.getStreet())
        	.add("number", user.getNumber())
        	.add("country", user.getCountry())
        	.add("postalcode", user.getPostalCode())
        	.add("description", user.getDescription())
        	.add("location", user.getLocation());
        secondJab.add(secondJob);
        
        job.add("userid", user.getUserId());
        job.add("userType", user.getUserType());
        job.add("firstName", user.getFirstName());
        job.add("lastName", user.getLastname());
        job.add("phonenumber", user.getPhonenumber());
        job.add("status", user.getStatus());
        job.add("addressInformation",secondJab);
        job.add("photo", user.getPhoto());
        job.add("dateofbirth", user.getDateOfBirth().toString());
        job.add("username", user.getUsername());
        
        return job;
    }
    
//    @GET
//    @Path("/{id}/qrcode")
//    public Response getQRCode(@PathParam("id") int id,
//    						@Context SecurityContext context){
//    	User user = service.getAccountByID(id);
//    	
//    	if(user == null){
//    		return Response.status(Response.Status.NOT_FOUND).build();
//    	} else {
//    		if(user.getName().equals(context.getUserPrincipal().getName())){
//	    		String secretKey = user.getSecretKey();
//	    		String email = user.getEmail();
//	    		
//	    		return Response.ok().build();
//    		} else {
//    			return Response.status(Response.Status.FORBIDDEN).build();
//    		}
//    	}
//    	
//    }

    @GET
//    @RolesAllowed({"beheerder","admin"})
    @Produces("application/json")
    public String getAccounts() {
        JsonArrayBuilder jab = Json.createArrayBuilder();
        for (UserWithAddress u : service.getAllUsers()) {
            jab.add(buildJSON(u));
        }

        JsonArray array = jab.build();
        return array.toString();
    }

    @GET
    @Path("/{id}")
//    @RolesAllowed({"admin","user"})
    @Produces("application/json")
    public String getAccountByID(@PathParam("id") int id) {
        UserWithAddress user = service.getUserByID(id);
        LoanService loanService = ServiceProvider.getLoanService();
        if(user != null) {
        	JsonObjectBuilder job = Json.createObjectBuilder();
            JsonArrayBuilder jab = Json.createArrayBuilder();
            JsonArrayBuilder secondJab = Json.createArrayBuilder();
            
            job = buildJSON(user);
            List<UserLoanInformation> userList = service.getUserLoanInformation(user.getUserId());
            if (userList.isEmpty()){
            	JsonObjectBuilder secondJob = Json.createObjectBuilder();
            	secondJob.add("loanid", loanService.getLoanByUserId(id));
            	
            	secondJab.add(secondJob);
            } else{
            	for (UserLoanInformation u : userList) {
            		JsonObjectBuilder secondJob = Json.createObjectBuilder();
            		secondJob.add("loanofficerid", u.getLoanOfficerId());
            		secondJob.add("groupid", u.getGroupId());
            		secondJob.add("loanid", u.getLoanId());
             	
            		secondJab.add(secondJob);
            	}
            }
            job.add("loaninformation", secondJab);
            
            jab.add(job);
            return jab.build().toString();
        }
        return Response.status(Response.Status.NOT_FOUND).toString();
    }
    
    @GET
    @Path("/getgroupid/{id}")
    public int getGroupByUserId(@PathParam("id") int userId){
    	return service.getGroupByUserId(userId);
    }
    
    @POST
    @Produces("application/json")
    public Response addUser(@FormParam("firstname") String firstname,
                            @FormParam("lastname") String lastname,
                            @FormParam("phonenumber") int phonenumber,
                            @FormParam("password") String password,
    						@FormParam("addressidfk") int addressIdFk,
    						@FormParam("photo") String photo,

    						@FormParam("dateofbirth") String dateOfBirth) throws ParseException
    {
    	Response r =Response.status(Response.Status.BAD_REQUEST).build();
    	if(bs.checkIfFilledString(firstname) && bs.checkIfFilledString(lastname) && bs.checkIfFilledString(password)
    			&& bs.checkIfFilledInt(phonenumber) && bs.checkIfFilledInt(addressIdFk)){
    	java.util.Date utilDateOfBirth = new SimpleDateFormat("yyyy-MM-dd").parse(dateOfBirth);
		java.sql.Date sqlDateOfBirth = new java.sql.Date(utilDateOfBirth.getTime());
		String userType = "applicant"; 
		GeneratePasswordAndSalt generator = new GeneratePasswordAndSalt();
		String[] result = null;
		try {
			result = generator.generateStrongPasswordHash(password);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (InvalidKeySpecException e) {
			e.printStackTrace();
		}
		
		String status = "active";
		String salt = result[1];
		password = result[0];
		
		String username = firstname + " " + lastname;

        User newUser = new User(userType, firstname, lastname, phonenumber, password, salt, status, addressIdFk, photo, sqlDateOfBirth, username);
        UserWithAddress returnUser = service.newUser(newUser);
        if (returnUser != null) {
        	String a = buildJSON(returnUser).build().toString();
            r = Response.ok(a).build();
        } else {
            r =  Response.status(Response.Status.BAD_REQUEST).build();
        }
    	}
        return r;
    }

    @PUT
    @Path("/{id}")
//    @RolesAllowed({"beheerder","admin","user"})
    	public Response updateAccount(	@PathParam("id") int userId,
    									@FormParam("usertype") String userType,
    									@FormParam("firstname") String firstname,
    									@FormParam("lastname") String lastname,
    									@FormParam("phonenumber") int phonenumber,
    									@FormParam("status") String status,
    									@FormParam("addressidfk") int addressIdFk,
    									@FormParam("photo") String photo,
    									@FormParam("dateofbirth") String dateOfBirth,
    									@FormParam("username") String username) throws ParseException
    	{
    	java.util.Date utilDateOfBirth = new SimpleDateFormat("yyyy-MM-dd").parse(dateOfBirth);
    	java.sql.Date sqlDateOfBirth = new java.sql.Date(utilDateOfBirth.getTime());
    	
    	UserWithAddress user = service.getUserByID(userId);
    	
    	if (user != null) {
    		user.setUserType(userType);
    		user.setFirsName(firstname);
    		user.setLastname(lastname);
    		user.setPhonenumber(phonenumber);
    		user.setStatus(status);
    		user.setAddressId(addressIdFk);
    		user.setDateOfBirth(sqlDateOfBirth);
    		user.setUserName(username);
            UserWithAddress updatedUser = service.update(user);
        	String a = buildJSON(updatedUser).build().toString();
            return Response.ok(a).build();

    	}
            
         else {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }
    }

    @DELETE
    @Path("/{id}")
//    @RolesAllowed({"beheerder","admin"})
    public Response deleteUser (@PathParam("id") int userId) {
        if (service.deleteUser(userId)) {
            if (service.deleteUser(userId)) {
                return Response.ok().build();
            } else {
                return Response.status(Response.Status.CONFLICT).build();
            }
        } else {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
    }
}
