package Services;

import java.util.List;

import DAOS.UserDAO;
import Objects.User;
import Objects.UserLoanInformation;
import Objects.UserWithAddress;

public class UserService {
	    private UserDAO userDAO = new UserDAO();

	    public UserService() {}

	    public List<UserWithAddress> getAllUsers() { 
	    	return userDAO.findAllUsers(); 
	    	}

	    public UserWithAddress getUserByID(int id) { 
	    	return userDAO.findById(id); 
	    	}

	    public UserWithAddress update (UserWithAddress user) { 
	    	return userDAO.update(user); 
	    	}

	    public boolean deleteUser (int userId) { 
	    	return userDAO.deleteUser(userId); 
	    	}

	    public UserWithAddress newUser (User user) { 
	    	return userDAO.saveUser(user); 
	    	}
	    public List<UserLoanInformation> getUserLoanInformation(int userId){
	    	return userDAO.getUserLoanInformation(userId);
	    }
}
