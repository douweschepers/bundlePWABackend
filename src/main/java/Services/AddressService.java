package Services;

import java.util.List;

import DAOS.AddressDAO;
import Objects.Address;

public class AddressService {
	private AddressDAO addressDAO = new AddressDAO();

    public AddressService() {}

    public List<Address> getAllAdresses() {
    	return addressDAO.findAll();
    	}

    public Address getAdressByID(int addressId) { 
    	
    	return addressDAO.findById(addressId); 
    	}

    public boolean deleteAdress (int addressId) { 
    	return addressDAO.deleteAddress(addressId); 
    	}
    
      public Address newAddress (Address address) { 
    	  return addressDAO.newAddress(address); }

	public Address updateAddress(Address updateAddress) {
		return addressDAO.update(updateAddress);
	}
}
