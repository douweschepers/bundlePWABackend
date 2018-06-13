package PdfGenerator;

import Objects.Address;
import Objects.Loan;
import Objects.User;

public class RetrieveData {
	private User user;
	private Address adress;
	private Loan loan;
	public void setUserData(User userData){
		user = userData;
		System.out.println(userData.toString());
	}
	public User getUserData(){
		return user;
	}
	public void setAdresData(Address adressData){
		adress = adressData;
	}
	public Address getAdressData(){
		return adress;
	}
	public void setLoanData(Loan loanData){
		loan = loanData;
	}
	public Loan getLoanData(){
		return loan;
	}
}
