package Services;

import java.util.List;

import DAOS.GroupDAO;
import Objects.Group;

public class GroupService {
	
	GroupDAO groupDAO = new GroupDAO();
	
	public List<Group> getAllGroups(){
		return groupDAO.getAllGroups();
	}
	
	public List<Group> getGroupById(int groupId){
		return groupDAO.getGroupById(groupId);
	}
	
	public int newGroup(int loanOfficerId){
		return groupDAO.newGroup(loanOfficerId);
	}

}
