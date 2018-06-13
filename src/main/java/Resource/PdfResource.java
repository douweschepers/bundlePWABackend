package Resource;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;


@Path("/pdf")
public class PdfResource {
	@POST
	@Produces("application/json")
	public Response getPdfData(@FormParam("street") String street,
            				 @FormParam("number") String number,
            				 @FormParam("country") String country,
            				 @FormParam("postalcode") String postalcode,
            				 @FormParam("description") String adresDescription,
            				 @FormParam("location") String location,
							 
            				 @FormParam("usertype") String userType,
     						 @FormParam("firstname") String firstname,
                             @FormParam("lastname") String lastname,
                             @FormParam("phonenumber") String phonenumber,
                             @FormParam("password") String password,
     						 @FormParam("addressidfk") String addressIdFk,
     						 @FormParam("photo") String photo,
     						 @FormParam("dateofbirth") String dateOfBirth,
			 				 
     						 @FormParam("loantype") String loanType,
							 @FormParam("amount") String amount,
							 @FormParam("startdate") String startDate,
							 @FormParam("duration") String duration,
							 @FormParam("loandescription") String loanDescription,
							 @FormParam("useridfk") String userIdFk) throws IOException, DocumentException{
		File file = File.createTempFile("contract_" + userIdFk, ".pdf");
		
		PdfReader reader = new PdfReader(".\\test1.2.pdf");
		PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(new File(".\\"+file.getName()).getCanonicalFile()));
		AcroFields form = stamper.getAcroFields();
		form.setField("firstname",firstname );
		form.setField("lastname", lastname);
		form.setField("usertype", userType);
		form.setField("phone",phonenumber );
		form.setField("dateofbirth", dateOfBirth);
		form.setField("adressid", addressIdFk);
		form.setField("loantype",loanType );
		form.setField("amount", amount);
		form.setField("start", startDate);
		form.setField("duration",duration );
		form.setField("loandescription", loanDescription);
		
		stamper.setFormFlattening(true);
		stamper.close();
		reader.close();
		
		return Response.ok().build();
		
	}
}
