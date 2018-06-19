package DAOS;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import Objects.Group;

public class GroupDAO extends baseDAO{
	ResultSet dbResultSet = null;
	
	public List<Group> selectGroup(ResultSet dbResultSet){
		List<Group> resultslist = new ArrayList<Group>();
		try {
			while (dbResultSet.next()) {
				int userId = dbResultSet.getInt("userid");
				int loanId = dbResultSet.getInt("loanid");
				String firstname = dbResultSet.getString("firstname");
				String lastname = dbResultSet.getString("lastname");
				Group group= new Group(userId, loanId, firstname, lastname, 0, 0);
				resultslist.add(group);
				}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return resultslist;
	}
	
	public List<Group> getAllGroups(){
		String query = "Select * from public.group;";
		List<Group> resultslist = new ArrayList<Group>();
		
		try (Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			dbResultSet = pstmt.executeQuery();
			
			while (dbResultSet.next()) {
				int groupId = dbResultSet.getInt("id");
				int loanOfficerId = dbResultSet.getInt("loanofficeridfk");
				Group group= new Group(0, 0, "", "", loanOfficerId, groupId);
				resultslist.add(group);
			}
			con.close();
			
		}catch (SQLException e){
			e.printStackTrace();
		}
		return resultslist;
	}
	
	public List<Group> getGroupById(int groupId){
		String query = 	"select u.firstname, u.lastname, u.userid, l.loanid " + 
						"from public.loan l, public.user u, public.grouploan g " + 
						"where g.loanidfk = l.loanid and l.useridfk = u.userid and g.groupidfk = ?;";
		
		try(Connection con = super.getConnection()){
			PreparedStatement pstmt = con.prepareStatement(query);
			
			pstmt.setInt(1, groupId);
			
			dbResultSet = pstmt.executeQuery();
			
			con.close();
		
		}catch (SQLException e){
			e.printStackTrace();
		}
		
		return selectGroup(dbResultSet);
	}

	public int newGroup(int loanOfficerId) {
		String query = "INSERT INTO public.group(loanofficeridfk) VALUES(?) returning id";
		int groupId = 0;
		
		try(Connection con = super.getConnection()){
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setInt(1, loanOfficerId);
			dbResultSet = pstmt.executeQuery();
			con.close();
			if(dbResultSet.next()) {
				groupId = dbResultSet.getInt("id");
			}
		}catch (SQLException e){
			e.printStackTrace();
		}
		return groupId;
	}
	
	public boolean deleteGroup(int groupId){
		String query = "delete from public.grouploan where groupidfk = ?";
		String query2 = "delete from public.group where id = ?";
		boolean result = false;
		try(Connection con = super.getConnection()){
			PreparedStatement pstmt = con.prepareStatement(query);
			PreparedStatement pstmt2 = con.prepareStatement(query2);
			
			pstmt.setInt(1, groupId);
			pstmt2.setInt(1, groupId);
			
			pstmt.executeUpdate();
			
			if (pstmt2.executeUpdate() == 1){
				result = true;
			}
			
			con.close();
		} catch (SQLException e){
			e.printStackTrace();
		}
		return result;
	}
	
}
