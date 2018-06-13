package Resource;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import Objects.Group;
import Objects.LoanGroup;
import Services.GroupService;
import Services.LoanGroupService;
import Services.ServiceProvider;

@Path("/group")
public class GroupResource {
	private GroupService service = ServiceProvider.getGroupService();
	
	private JsonObjectBuilder buildJSON(Group g){
		JsonObjectBuilder job =Json.createObjectBuilder();
		
		job.add("userid", g.getUserId());
		job.add("loanid", g.getLoanId());
		job.add("firstname", g.getFirstname());
		job.add("lastname", g.getLastname());
			
		return job;
			
	}
	
	@GET
	@Produces("application/json")
	public String getAllGroups(){
		JsonArrayBuilder jab = Json.createArrayBuilder();
		
		for(Group g : service.getAllGroups()){		
			JsonObjectBuilder job =Json.createObjectBuilder();
			job.add("groupid", g.getGroupId());
			job.add("loanofficerid", g.getLoanOfficerId());
			jab.add(job);
		}
		JsonArray array = jab.build();
		return array.toString();
	}
	
	@GET
	@Path("/{groupId}")
	@Produces("application/json")
	public String getGroupById(@PathParam("groupId") int groupId){
		JsonArrayBuilder jab = Json.createArrayBuilder();
		
		for (Group g: service.getGroupById(groupId)){
			jab.add(buildJSON(g));
		}
		JsonArray array = jab.build();
		return array.toString();
	}
	
	@POST
	@Path("/{loanOfficerId}")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String newGroup(@PathParam("loanOfficerId") int loanOfficerId){
		int groupId = service.newGroup(loanOfficerId);
		if (groupId != 0){
			return Integer.toString(groupId);
		} else {
			return Response.status(Response.Status.BAD_REQUEST).build().toString();
		}
	}
}
