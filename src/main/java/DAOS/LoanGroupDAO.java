package DAOS;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import Objects.Group;
import Objects.LoanGroup;
import Objects.LoanGroupInformation;

public class LoanGroupDAO extends baseDAO{
	private ResultSet dbResultSet;
	
	public List<LoanGroup> selectLoanGroup(String query){
		List<LoanGroup> resultslist = new ArrayList<LoanGroup>();
		try(Connection con = super.getConnection()){
			Statement stmt = con.createStatement();
			ResultSet dbResultSet = stmt.executeQuery(query);
			while (dbResultSet.next()) {
				int groupId = dbResultSet.getInt("groupidfk");
				int loanId = dbResultSet.getInt("loanidfk");
				LoanGroup loanGroup= new LoanGroup(groupId, loanId);
				resultslist.add(loanGroup);
			}
			stmt.getConnection().close();
		}
		catch(SQLException sqle){
			sqle.printStackTrace();
		}
		return resultslist;
	}
	
	public List<LoanGroup> getAllLoanGroups() {
		return selectLoanGroup("select * FROM public.grouploan;");
	}
	
	public List<LoanGroupInformation> getAllApplicantsByLoanGroupId(int groupId){
		List<LoanGroupInformation> resultslist = new ArrayList<LoanGroupInformation>();
		String query = 	"select u.firstname, u.lastname, u.userid, l.paidamount, l.amount, l.loanid" + 
				" from public.loan l, public.user u, public.grouploan gl" + 
				" where gl.loanidfk = l.loanid and l.useridfk = u.userid and gl.groupidfk = ?";
		
		try(Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setInt(1, groupId);

			ResultSet dbResultSet = pstmt.executeQuery();
			
			while (dbResultSet.next()) {
				String firstname = dbResultSet.getString("firstname");
				String lastname = dbResultSet.getString("lastname");
				int userId = dbResultSet.getInt("userid");
				int paidAmount = dbResultSet.getInt("paidamount");
				int amount = dbResultSet.getInt("amount");
				int loanId = dbResultSet.getInt("loanid");
				
				LoanGroupInformation loanGroupInformation = new LoanGroupInformation(firstname, lastname, userId, paidAmount, amount, loanId, groupId);
			
				resultslist.add(loanGroupInformation);
			}
		}catch (SQLException e){
			e.printStackTrace();
		}
		
		return resultslist;
	}
		
		public List<Integer> getAllLoanGroupsByLoanOfficers(int loanOfficerId){
			List<Integer> resultslist = new ArrayList<Integer>();
			String query = 	"select g.id as groupid " + 
							"from public.group g " + 
							"where g.loanofficeridfk = ?";
			
			try(Connection con = super.getConnection()) {
				PreparedStatement pstmt = con.prepareStatement(query);
				pstmt.setInt(1, loanOfficerId);

				dbResultSet = pstmt.executeQuery();
				
				while (dbResultSet.next()) {
					int groupId = dbResultSet.getInt("groupid");
					
				
					resultslist.add(groupId);
				}
			}catch (SQLException e){
				e.printStackTrace();
			}
			
			return resultslist;
				//selectLoanGroup("select l.groupidfk, l.loanidfk FROM public.grouploan l, public.group g where l.groupidfk = g.id and g.loanofficeridfk =" + loanofficerId + ";");
		
		
	}

	public List<LoanGroup> getLoanGroupById(int groupId) {
		return selectLoanGroup("Select * FROM public.grouploan where groupidfk = " + groupId);
	}
	
	public boolean addLoanToGroup(int groupId, int loanId){
		String query = "insert into grouploan(groupidfk, loanidfk) values (?,?) returning groupidfk;";
		boolean result = false;
		
		try(Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setInt(1, groupId);
			pstmt.setInt(2, loanId);

			dbResultSet = pstmt.executeQuery();
		} catch (SQLException e){
			e.printStackTrace();
		}
		if (dbResultSet != null){
			result = true;
		}
		
		return result;
		
	}

}
