package DAOS;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import Objects.Address;

public class AddressDAO extends baseDAO {

	private String tablename = "public.address";
	private ResultSet dbResultSet = null;

    private List<Address> selectAddress(ResultSet dbResultSet) {
        List<Address> results = new ArrayList<Address>();

        try{
            while (dbResultSet.next()) {
                int id = dbResultSet.getInt("addressid");
                String street = dbResultSet.getString("street");
                int number = dbResultSet.getInt("number");            	
            	String country = dbResultSet.getString("country");
            	String postalcode = dbResultSet.getString("postalCode");
            	String description = dbResultSet.getString("description");
            	String location = dbResultSet.getString("location");
           
                Address newAdress = new Address(id, street, number, country, postalcode, description, location);

                results.add(newAdress);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return results;
    }

    public List<Address> findAll() { 
    	String query = "SELECT * From " + tablename;
    	
    	try (Connection con = super.getConnection()) {
       	 PreparedStatement pstmt = con.prepareStatement(query);
       	 dbResultSet = pstmt.executeQuery();

       	} catch (SQLException e) {
       		e.printStackTrace();
    	}
    	return selectAddress(dbResultSet);
    }

    public Address findById(int addressId) {
        String query = "SELECT * FROM " + tablename + " WHERE addressid = ?";
        try (Connection con = super.getConnection()) {
          	 PreparedStatement pstmt = con.prepareStatement(query);
          	 pstmt.setInt(1, addressId);
          	 dbResultSet = pstmt.executeQuery();

          	} catch (SQLException e) {
          		e.printStackTrace();
       	}
       	List<Address> results = selectAddress(dbResultSet);
        if (results.size() == 0) {
            return null;
        } else {
            return results.get(0);
        }
    }
    
    public List<Address> findAdressesByUserIDFK(int userId) {
        String query = "SELECT * FROM "+tablename+" WHERE useridfk = ?";
        
        try (Connection con = super.getConnection()) {
          	 PreparedStatement pstmt = con.prepareStatement(query);
          	 pstmt.setInt(1, userId);
          	 dbResultSet = pstmt.executeQuery();

          	} catch (SQLException e) {
          		e.printStackTrace();
       	}
       	return selectAddress(dbResultSet);
    }
    
    public Address newAddress(Address address) {
        String query = "INSERT INTO " + tablename + " (street, number, country, postalcode, description, location) VALUES (?,?,?,?,?,?) RETURNING addressid";
        
        try (Connection con = super.getConnection()){
            PreparedStatement pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, address.getStreet());
            pstmt.setInt(2, address.getNumber());
            pstmt.setString(3, address.getCountry());
            pstmt.setString(4, address.getPostalCode());
            pstmt.setString(5, address.getDescription());
            pstmt.setString(6, address.getLocation());

            ResultSet dbResultSet = pstmt.executeQuery();
            if(dbResultSet.next()) {
            	
                int result =  dbResultSet.getInt("addressid");
                address.setAdressId(result);
                
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return findById(address.getAdressId());
    }

	public Address update(Address address) {
		String query = "UPDATE " + tablename + " SET street = ?, number = ?, country = ?, postalcode = ?,"
        		+ " description = ?, location=? WHERE addressid = ?;";
		try (Connection con = super.getConnection()){
	            PreparedStatement pstmt = con.prepareStatement(query);
	            
	            pstmt.setString(1, address.getStreet());
	            pstmt.setInt(2, address.getNumber());
	            pstmt.setString(3, address.getCountry());
	            pstmt.setString(4, address.getPostalCode());
	            pstmt.setString(5, address.getDescription());
	            pstmt.setString(6, address.getLocation());
	            pstmt.setInt(7, address.getAdressId());

	            ResultSet dbResultSet = pstmt.executeQuery();
	            if(dbResultSet.next()) {
	                return findById(dbResultSet.getInt(1));
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }

	        return findById(address.getAdressId());
	}
	
	public boolean deleteAddress (int addressId) {
        boolean result = false;

        if (findById(addressId) != null) {
            String query = "DELETE FROM " + tablename + " WHERE addressid = ?";

            try (Connection con = getConnection()) {
                PreparedStatement pstmt = con.prepareStatement(query);
                pstmt.setInt(1, addressId);

                if (pstmt.executeUpdate() == 1) {
                    result = true;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return result;
    }
}
