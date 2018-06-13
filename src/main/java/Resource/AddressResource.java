package Resource;

import java.util.Random;

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

import Objects.Address;
import Objects.User;
import PdfGenerator.RetrieveAddressData;
import Services.AddressService;
import Services.ServiceProvider;
import Validation.BasicValidation;

@Path("/address")
public class AddressResource {
    private AddressService service = ServiceProvider.getAdressService();
    BasicValidation bs = new BasicValidation();

	    private JsonObjectBuilder buildJSON(Address a) {
	        JsonObjectBuilder job = Json.createObjectBuilder();

	        job.add("adressid", a.getAdressId())
	                .add("street", a.getStreet())
	                .add("number", a.getNumber())
	                .add("country", a.getCountry())
	                .add("postalcode", a.getPostalCode())
	        		.add("description", a.getDescription())
	        		.add("location", a.getLocation());

	        return job;
	    }
	    @GET
//	    @RolesAllowed({"beheerder","admin"})
	    @Produces("application/json")
	    public String getAccounts() {
	        JsonArrayBuilder jab = Json.createArrayBuilder();

	        for (Address a : service.getAllAdresses()) {
	            jab.add(buildJSON(a));
	        }

	        JsonArray array = jab.build();
	        return array.toString();
	    }
	    
	    @GET
	    @Path("/{id}")
//	    @RolesAllowed({"beheerder","admin","user"})
	    @Produces("application/json")
	    public String getAdressByID(@PathParam("id") int id) {
	        Address c = service.getAdressByID(id);
	        if(c != null) {
	            JsonArrayBuilder jab = Json.createArrayBuilder();
	            jab.add(buildJSON(c));
	            return jab.build().toString();
	        }
	        return Response.status(Response.Status.NOT_FOUND).toString();
	    }
	    
	    @POST
	    @Produces("application/json")
	    public Response addAddress(
	                               @FormParam("street") String street,
	                               @FormParam("number") int number,
	                               @FormParam("country") String country,
	                               @FormParam("postalcode") String postalcode,
	                               @FormParam("description") String description,
	                               @FormParam("location") String location){
	    	
	    	//if(bs.checkIfFilled(street) ==true){
	    	RetrieveAddressData data = new RetrieveAddressData();	        
	    	
	        Address newAdress = new Address(street, number, country, postalcode, description, location);
	        Address returnAdress = service.newAddress(newAdress);
	        if (returnAdress != null) {
	        	data.setAddressData(newAdress);	        
	            String a = buildJSON(returnAdress).build().toString();
	            return Response.ok(a).build();
	        } else {
	            return Response.status(Response.Status.BAD_REQUEST).build();
	        }
	    	
	    }	
	    
	    @PUT
	    @Produces("application/json")
	    @Path("/{id}")
	    public Response changeAddress(	@PathParam("id") int addressId,
	    		 						@FormParam("street") String street,
	    		 						@FormParam("number") int number,
	    		 						@FormParam("country") String country,
	    		 						@FormParam("postalcode") String postalcode,
	    		 						@FormParam("description") String description,
	    		 						@FormParam("location") String location){
	    	
	    	Address updatedAdress = new Address(addressId, street, number, country, postalcode, description, location);
	    	Address returnAdress = service.updateAddress(updatedAdress);
	        if (returnAdress != null) {
	            String a = buildJSON(returnAdress).build().toString();
	            return Response.ok(a).build();
	        } else {
	            return Response.status(Response.Status.BAD_REQUEST).build();
	        }
	    }
	    
	    @DELETE
	    @Produces("application/json")
	    @Path("/{id}")
	    public Response deleteAddress(	@PathParam("id") int addressId){
	    
	    	if (service.deleteAdress(addressId)){
	    		return Response.ok().build();
	    	} else {
	    		return Response.status(Response.Status.BAD_REQUEST).build();
	    	}
	    }
}