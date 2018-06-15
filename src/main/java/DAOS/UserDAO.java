package DAOS;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Objects.User;
import Objects.UserLoanInformation;
import Objects.UserWithAddress;

public class UserDAO extends baseDAO {
	private String tablename = "public.user";
	private ResultSet dbResultSet = null;

    /*private List<User> selectUsers(ResultSet dbResultSet) {
        List<User> results = new ArrayList<User>();

            try {
				while (dbResultSet.next()) {
				    int userId = dbResultSet.getInt("userid");
				    String userType = dbResultSet.getString("usertype");
				    String firstname = dbResultSet.getString("firstname");   
				    String lastname = dbResultSet.getString("lastname");   
					int phonenumber = dbResultSet.getInt("phonenumber");
					String password = dbResultSet.getString("password");
					String salt = dbResultSet.getString("salt");
					String status = dbResultSet.getString("status");
					Date DateOfBirth = dbResultSet.getDate("dateofbirth");
					int addressIdFk = dbResultSet.getInt("addressidfk");
					String photo = dbResultSet.getString("photo");
					String username = dbResultSet.getString("username");
         
				    User newUser = new User(userId, userType, firstname, lastname, phonenumber, password, salt, status, addressIdFk, photo, DateOfBirth, username);


				    results.add(newUser);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
        return results;
    }*/

    private List<UserWithAddress> selectUsersWithAddress (ResultSet dbResultSet) {
        List<UserWithAddress> results = new ArrayList<UserWithAddress>();

        try {
            while (dbResultSet.next()) {
                int userId = dbResultSet.getInt("userid");
                String userType = dbResultSet.getString("usertype");
                String firstname = dbResultSet.getString("firstname");   
                String lastname = dbResultSet.getString("lastname");   
            	int phonenumber = dbResultSet.getInt("phonenumber");
            	String status = dbResultSet.getString("status");
            	Date DateOfBirth = dbResultSet.getDate("dateofbirth");
            	String photo = dbResultSet.getString("photo");
            	String username = dbResultSet.getString("username");
            	
            	int addressId = dbResultSet.getInt("addressid");
                String street = dbResultSet.getString("street");
                int number = dbResultSet.getInt("number");            	
            	String country = dbResultSet.getString("country");
            	String postalcode = dbResultSet.getString("postalCode");
            	String description = dbResultSet.getString("description");
            	String location = dbResultSet.getString("location");
           
                UserWithAddress newUserWithAddress = new UserWithAddress(userId, userType, firstname, lastname, phonenumber, status, photo, DateOfBirth, username, addressId, street, number, country, postalcode, description, location);


                results.add(newUserWithAddress);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return results;
    }
    public List<UserWithAddress> findAllUsers() {
    	String query = 	"select u.*, a.* " +
    					"from public.user u, public.address a " +
    					"where u.addressidfk = a.addressid;";
    	
    	try (Connection con = super.getConnection()) {
    	 PreparedStatement pstmt = con.prepareStatement(query);
    	 dbResultSet = pstmt.executeQuery();

    	} catch (SQLException e) {
    		e.printStackTrace();
    	}
    	return selectUsersWithAddress(dbResultSet);
    }
    

    public UserWithAddress findById(int userId) {
        String query = "select u.*, a.* " +
				"from public.user u, public.address a " +
				"where u.addressidfk = a.addressid and u.userid = ?;";
        List<UserWithAddress> resultlist = new ArrayList<UserWithAddress>();
    	
    	try (Connection con = super.getConnection()) {
    	 PreparedStatement pstmt = con.prepareStatement(query);
    	 
    	 pstmt.setInt(1, userId);
    	 
    	 dbResultSet = pstmt.executeQuery();
    	 con.close();
    	} catch (SQLException e) {
    		e.printStackTrace();
    	}
    	
    	resultlist = selectUsersWithAddress(dbResultSet);
        if (resultlist.size() == 0) {
            return null;
        } else {
            return resultlist.get(0);
        }
    }

    public UserWithAddress update(UserWithAddress user) {
        String query = "UPDATE " + tablename + " SET usertype = ?, firstname = ?, lastname = ?, phonenumber = ?,"
        		+ " status = ?, dateofbirth = ?, photo = ?, addressidfk = ?, username = ?"
        		+ " WHERE userid = ?";

        try (Connection con = super.getConnection()) {
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, user.getUserType());
            pstmt.setString(2, user.getFirstName());
            pstmt.setString(3, user.getLastname());
            pstmt.setInt(4, user.getPhonenumber());
            pstmt.setString(5, user.getStatus());
            pstmt.setDate(6, user.getDateOfBirth());
            pstmt.setString(7, user.getPhoto());
            pstmt.setInt(8, user.getAddressId());
            pstmt.setString(9, user.getUsername());
            pstmt.setInt(10, user.getUserId());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return findById(user.getUserId());
    }

    public boolean deleteUser(int userId) {
        boolean result = false;

        if (findById(userId) != null) {
            String query = "DELETE FROM " + tablename + " WHERE userid = ?";

            try (Connection con = getConnection()) {
                PreparedStatement pstmt = con.prepareStatement(query);
                pstmt.setInt(1, userId);

                if (pstmt.executeUpdate() == 1) {
                    result = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return result;
    }

    public UserWithAddress saveUser(User user) {
        String query = "INSERT INTO " + tablename + "(usertype, firstname, lastname, phonenumber, password, salt, status, dateofbirth, photo, addressidfk, username) VALUES (?,?,?,?,?,?,?,?,?,?,?) RETURNING userid";
        int result;
        try (Connection con = super.getConnection()){
            PreparedStatement pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, user.getUserType());
            pstmt.setString(2, user.getFirstName());
            pstmt.setString(3, user.getLastname());
            pstmt.setInt(4, user.getPhonenumber());
            pstmt.setString(5, user.getPassword());
            pstmt.setString(6, user.getSalt());
            pstmt.setString(7, user.getStatus());
            pstmt.setDate(8, user.getDateOfBirth());
            pstmt.setString(9, user.getPhoto());
            pstmt.setInt(10, user.getAddressIdFk());
            pstmt.setString(11, user.getUsername());

            ResultSet dbResultSet = pstmt.executeQuery();
            if(dbResultSet.next()) {

               result =  dbResultSet.getInt("userid");
               user.setUserId(result);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return findById(user.getUserId());
    }
    
    public String findRoleForNameAndPassword(String name, String password){
    	String role = null;    	
    	String query = "SELECT usertype FROM " + tablename + " WHERE username = ? AND password = ?";
    	
    	try(Connection con = super.getConnection()){
    		PreparedStatement pstmt = con.prepareStatement(query);
    		pstmt.setString(1, name);
    		pstmt.setString(2, password);
    		ResultSet rs = pstmt.executeQuery();
    		
    		if(rs.next()){
    			role = rs.getString("usertype");
    			System.out.println(role);
    		}
    	} catch (SQLException sqle){
    		sqle.printStackTrace();
    	}
    	
    	return role;
    }
    
    public List<UserLoanInformation> getUserLoanInformation(int userId){
    	List<UserLoanInformation> result = new ArrayList<UserLoanInformation>();
    	String query = 	"SELECT g.loanofficeridfk, g.id as groupid, l.loanid" +
    					" FROM public.loan l, public.grouploan gl, public.group g" +
    					" WHERE l.useridfk = ? and l.loanid = gl.loanidfk and gl.groupidfk = g.id;";
    	
    	try(Connection con = super.getConnection()) {
    		PreparedStatement pstmt = con.prepareStatement(query);
    		pstmt.setInt(1, userId);
    		
    		ResultSet dbResultSet = pstmt.executeQuery();
    		
    		while (dbResultSet.next()) {
    			int loanOfficerId = dbResultSet.getInt("loanofficeridfk");
    			int groupId = dbResultSet.getInt("groupid");
    			int loanId = dbResultSet.getInt("loanid");
    			
    			UserLoanInformation userLoanInformation = new UserLoanInformation(loanOfficerId, groupId, loanId);
    			result.add(userLoanInformation);
    		}
    	}catch (SQLException e){
    		e.printStackTrace();
    	}
    	return result;
    }
}