package DAOS;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;

import Objects.Loan;

public class loanDAO extends baseDAO {
	private String tablename = "public.loan";
	ResultSet dbResultSet = null;
	
	private List<Loan> selectLoan(ResultSet dbResultSet){
		List<Loan> resultslist = new ArrayList<Loan>();
					
		try {
			while (dbResultSet.next()) {
				int loanId = dbResultSet.getInt("loanid");
				String loanType = dbResultSet.getString("loantype");
				int amount = dbResultSet.getInt("amount");
				String status = dbResultSet.getString("status");
				Date startDate = dbResultSet.getDate("startdate");
				int duration = dbResultSet.getInt("duration");
				Date closingDate = dbResultSet.getDate("closingdate");
				int paidAmount = dbResultSet.getInt("paidamount");
				String contractPdf = dbResultSet.getString("contractpdf");
				String description = dbResultSet.getString("description");
				int userIdFk = dbResultSet.getInt("useridfk");
					
				Loan loan = new Loan(loanId, loanType, amount, status, startDate, duration, closingDate, paidAmount, contractPdf, description, userIdFk);
				resultslist.add(loan);
				}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return resultslist;
	}
	
	public List<Loan> getAllLoans() {
		String query = "select * from " + tablename;
		
		try (Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			dbResultSet = pstmt.executeQuery(query);
			
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		return selectLoan(dbResultSet);
	}
	
	public List<Loan> getLoanById(int loanId){
		String query = "select * from " + tablename + " where loanid = ?";
		
		try (Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setInt(1, loanId);
			dbResultSet = pstmt.executeQuery();
			
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		return selectLoan(dbResultSet);
	}
    
	public Loan findLoanById(int loanId){
		String query = "select * from " + tablename + " where loanid = ?";
	
		try (Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setInt(1, loanId);
			dbResultSet = pstmt.executeQuery(query);
			
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		List<Loan> result = selectLoan(dbResultSet);
		if (result.size() == 0){
			return null;
		} else {
			return result.get(0);
		}
		
	}
    public List<Loan> getAllLoansFromLastWeek(){
    	String query = "select * from " + tablename + " where startdate between NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER";
    	
    	try (Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			dbResultSet = pstmt.executeQuery(query);
			
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
    	return selectLoan(dbResultSet);
    }

	public boolean newLoan(Loan newLoan) {
		boolean result = false;
		String query = 	"INSERT INTO public.loan("
					+ 	"loantype, amount, status, startdate, duration, closingdate, paidAmount, contractPdf, description, useridfk) "
					+	"VALUES(?,?,?,to_date(?, 'YYYY-MM-DD'),?,to_date(?, 'YYYY-MM-DD'),?,?,?,?)";
		try(Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setString(1, newLoan.getLoanType());
			pstmt.setInt(2, newLoan.getAmount());
			pstmt.setString(3, newLoan.getStatus());
			pstmt.setString(4, newLoan.getStartDate().toString());
			pstmt.setInt(5, newLoan.getDuration());
			pstmt.setString(6, newLoan.getClosingDate().toString());
			pstmt.setInt(7, newLoan.getPaidAmount());
			pstmt.setString(8, newLoan.getContractPdf());
			pstmt.setString(9, newLoan.getDescription());
			pstmt.setInt(10, newLoan.getUserIdFk());
			
			if (pstmt.executeUpdate() == 1){
				result = true;
			}

			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		return result;
	}
	
	
	public Loan updateLoan(Loan changedLoan) {
        String query = "UPDATE "+tablename+" SET loantype=?, status=?, duration=?, closingdate=?, paidamount=?"
        		+ " WHERE loanid=?";

        try (Connection con = super.getConnection()) {
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, changedLoan.getLoanType());
	        pstmt.setString(2, changedLoan.getStatus());
	        pstmt.setInt(3, changedLoan.getDuration());
	        pstmt.setDate(4, changedLoan.getClosingDate());
	        pstmt.setInt(5, changedLoan.getPaidAmount());
	        pstmt.setInt(6, changedLoan.getLoanId());

            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return findLoanById(changedLoan.getLoanId());
    }
	
	public JsonArrayBuilder getGrouplessLoans(){
		String query = "SELECT l.useridfk,	u.firstname || ' ' || u.lastname as name FROM public.user u, public.loan l LEFT JOIN grouploan gl on l.loanid = gl.loanidfk where gl.loanidfk is NULL;";
		JsonArrayBuilder jab = Json.createArrayBuilder();
		
		try (Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			dbResultSet = pstmt.executeQuery();
			
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		
		try {
			while(dbResultSet.next()){
				JsonObjectBuilder job = Json.createObjectBuilder();
				job.add("userid", dbResultSet.getInt("useridfk"));
				job.add("name", dbResultSet.getString("name"));
				jab.add(job);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
    	return jab;
		
	}
	
}
