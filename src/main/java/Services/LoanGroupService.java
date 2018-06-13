package Services;

import java.util.List;

import DAOS.LoanGroupDAO;
import Objects.Group;
import Objects.LoanGroup;
import Objects.LoanGroupInformation;



public class LoanGroupService {
LoanGroupDAO loanGroupDAO = new LoanGroupDAO();
	
	public List<Integer> getAllLoanGroupsByLoanOfficer(int loanofficerId) {
		return loanGroupDAO.getAllLoanGroupsByLoanOfficers(loanofficerId);
	}

	public List<LoanGroup> getAllLoanGroups() {
		return loanGroupDAO.getAllLoanGroups();
	}

	public List<LoanGroup> getLoanGroupById(int groupId) {
		return loanGroupDAO.getLoanGroupById(groupId);
	}
	
	public List<LoanGroupInformation> getAllApplicantsByLoanGroupId(int groupId){
		return loanGroupDAO.getAllApplicantsByLoanGroupId(groupId);
	}

	public boolean addLoantoGroup(int groupId, int loanId) {
		return loanGroupDAO.addLoanToGroup(groupId, loanId);
	}
}
