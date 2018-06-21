package DAOS;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import Objects.Transaction;

public class TransactionDAO extends baseDAO{
	private String tablename = "public.transaction";
	ResultSet dbResultSet = null;
	
	private List<Transaction> selectTransaction(ResultSet dbResultSet){
		List<Transaction> resultlist = new ArrayList<Transaction>();
		
		try{
			while(dbResultSet.next()) {
				int transactionId = dbResultSet.getInt("transactionid");
				int amount = dbResultSet.getInt("amount");
				String sender = dbResultSet.getString("sender");
				String receiver = dbResultSet.getString("receiver");
				Date timeStamp = dbResultSet.getDate("timestamp");
				int loanIdFk = dbResultSet.getInt("loanidfk");
						
				Transaction transaction = new Transaction(transactionId, amount, sender, receiver, timeStamp, loanIdFk);
				resultlist.add(transaction);
			}
		}catch(SQLException e){
			e.printStackTrace();
		}
		return resultlist;
	}
	
	public List<Transaction> getAllTransactions(){
		String query = "Select * from " + tablename;
		
		try (Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			dbResultSet = pstmt.executeQuery();
			
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		
		return selectTransaction(dbResultSet);
	}
	
	public List<Transaction> getTransactionById(int transactionId){
		String query = "Select * from " + tablename + " where transactionid = ?";
		
		try(Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setInt(1, transactionId);
			
			dbResultSet = pstmt.executeQuery();
			
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		return selectTransaction(dbResultSet);
	}
	
	public List<Transaction> getTransactionByLoanId(int loanId){
		String query = "select * from " + tablename + " where loanidfk = ?";
		
		try(Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			pstmt.setInt(1, loanId);
			
			dbResultSet = pstmt.executeQuery();
			
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		return selectTransaction(dbResultSet);
	}
	
	public List<Transaction> getTransactionFromLastWeek(){
		String query = "select * from " + tablename + " where timestamp between NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER order by timestamp asc";
		
		try(Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			dbResultSet = pstmt.executeQuery();
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		return selectTransaction(dbResultSet);
	}
	
	public boolean addTransaction(Transaction transaction, boolean paidEnough) {
		String query = "Insert Into " + tablename + "(amount, sender, receiver, timestamp, loanidfk) Values(?,?,?,?,?)";
		String query2 = "Update public.loan set paidamount = paidamount + ? where loanid = ?";
		if (paidEnough){
			query2 = "Update public.loan set paidamount = paidamount + ? , status = 'closed' where loanid = ?";
		}
		boolean result = false;
		try (Connection con = super.getConnection()) {
			PreparedStatement pstmt = con.prepareStatement(query);
			PreparedStatement pstmt2 = con.prepareStatement(query2);
			
			pstmt.setInt(1, transaction.getAmount());
			pstmt.setString(2, transaction.getSender());
			pstmt.setString(3, transaction.getReceiver());
			pstmt.setDate(4, transaction.getTimeStamp());
			pstmt.setInt(5, transaction.getLoanIdFk());

			pstmt2.setInt(1, transaction.getAmount());
			pstmt2.setInt(2, transaction.getLoanIdFk());
			
			if (pstmt.executeUpdate() == 1 && pstmt2.executeUpdate() == 1) {
				result = true;
			}
			con.close();
		}catch (SQLException e){
			e.printStackTrace();
		}
		return result;
	}
}
