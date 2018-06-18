<!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body onload="getLoan(); getTransaction();">

	<jsp:include page="parts/navigation.jsp" />

	<main>
	<div class="welcomeBlock">
		<h1>Loan</h1>
		<button class="buttonRound" onclick="toggleHide('helpPopup', false)">?</button>
		<button id="edit" class="buttonRound hide" onclick="window.location.href='edit_loan.jsp'">&#9998;</button>
	</div>
	
	<div class="block">
       	<div id="mainLoader" class="loaderBlock">
       		<div class="loader"></div>
       	</div>
		
		<div class="blockHalf">
			<h2>Personal information</h2>
			<br>
			
			<div>
				<label for="name"> <b>Name</b>
				<button id="accountButton" class="buttonRound">&#8618;</button>
				</label>
				<h3 id="name">Loading...</h3>
			</div>
			
			<div>
				<label for="loantype"> <b>Group</b>
				<button id="groupButton" class="buttonRound">&#8618;</button>
				</label>
				<h3 id="group">Loading...</h3>
			</div>
	
			<div>
				<label for="userstatus"> <b>Status</b>
				</label>
				<h3 id="status">Loading...</h3>
			</div>
			
			<h2>Loan progress</h2>
			<br>
			<div id='statusDiv'>
				<label for="loanstatus"> <b>Status</b>
				</label>
				<h3 id="loanstatus">Loading...</h3>
			</div>
			
			<div>
				<label for="amount"> <b>Amount</b>
				</label>
				<h3 id="amount">Loading...</h3>
			</div>
	
			<div>
				<label for="remaining"> <b>Paid Back</b>
				</label>
				<h3 id="remaining">Loading...</h3>
				<progress id="remainingBar"> </progress>
			</div>
		</div>
	
		<div class="blockHalf">
	
			<h2>Loan detail</h2>
			<br>
	
			<div>
				<label for="loantype"> <b>Loan type</b>
				</label>
				<h3 id="loantype">Loading...</h3>
			</div>
			
			<div>
				<label for="duration"> <b>Duration</b>
				</label>
				<h3 id="duration">Loading...</h3>
			</div>
	
			<div>
				<label for="duration"> <b>Start Date</b>
				</label>
				<h3 id="startdate">Loading...</h3>
			</div>
	
			<div>
				<label for="duration"> <b>Closing Date</b>
				</label>
				<h3 id="closingdate">Loading...</h3>
			</div>
			
			<div>
				<label for="description"> <b>Description</b>
				</label>
				<h3 id="description">Loading...</h3>
			</div>
			
			<div>
				<label for="contract"> <b>Contract</b>
				</label>
				<br>
				<br>
				<button id='contract' class="small" >Download</button>
			</div>
		</div>
	
		<div class="block blockUnderHalf">
			<br>
			<h2>Transactions</h2>
			<br>
			<div id="TransactionTable">
				<table id='transactionTable' class='transactionTable'>
					<tr class="desktop">
						<th>Id</th>
						<th>Amount</th>
						<th>Receiver</th>
						<th>Date</th>
					</tr>
				</table>
			</div>
		</div>
		</div>
	</main>

	<jsp:include page="parts/footer.jsp" />
	<script>
	
    var usertype = window.sessionStorage.getItem("userType");
    var hideEdit = 'hide';

    if(usertype != null &&usertype != "applicant") {
   		$('#edit').removeClass('hide');
   		hideEdit = '';
    } else if(usertype == null) {
    	window.location.replace('login.jsp');
    }
    
	function getTransaction() {
		var hr = new XMLHttpRequest();
    	var id = getParameterByName("id");

    	hr.open("GET", "/bundlePWABackend/restservices/transaction/loanid/" + id, true);

    	hr.onreadystatechange = function() {
    		if (hr.readyState == 4 && hr.status == 200) {
    			var object = JSON.parse(hr.responseText);
				var table = document.getElementById('transactionTable');
				var datalength = object.length;

				for (var i = 0; i < datalength; i++) {
					var tr = document.createElement('tr');
					tr.innerHTML = '<td class="id" id="loanid" data-label="ID">'
							+ object[i].transactionid + '</td>'
							+ '<td id ="amount" data-label="Amount">'
							+ object[i].amount + '</td>'
							+ '<td id = "receiver" data-label="receiver">'
							+ object[i].receiver + '</td>'
							+ '<td id = "timestamp" data-label="timestamp">'
							+ object[i].timestamp + '</td>';
					table.appendChild(tr);
				}
				
				if(datalength == 0){
					var tr = document.createElement('tr');
					tr.innerHTML = '<td style="text-align: center;" colspan=100%>No transactions found</td>';
					table.appendChild(tr);
				}
    		} else if (hr.readyState == 4) {
    			addNotification('Retrieving data failed with status ' + hr.status + '. Try again later.');
    		}
    	}
    	hr.send(null);
	}
	
	function getLoan() {
		var hr = new XMLHttpRequest();
    	var id = getParameterByName("id");

    	hr.open("GET", "/bundlePWABackend/restservices/loan/" + id, true);

    	hr.onreadystatechange = function() {
    		if (hr.readyState == 4 && hr.status == 200) {
    			var loanData = JSON.parse(hr.responseText);

    			$('#loanstatus').text(UCFirst(checkValue(loanData.status)));
    			$('#amount').text(checkValue(loanData.amount, 0) + " $");
    			$('#remaining').text(checkValue(loanData.paidamount, 0) + " $");
    			$('#remainingBar').attr("max", loanData.amount);
    			$('#remainingBar').attr("value", loanData.paidamount);
    			$('#loantype').text(checkValue(loanData.loantype));
    			$('#duration').text(checkValue(loanData.duration) + " Months");
    			$('#startdate').text(checkValue(loanData.startdate));
    			$('#closingdate').text(checkValue(loanData.closingdate));
    			$('#description').text(UCFirst(checkValue(loanData.description)));
    			$('#contract').attr("onclick", 'window.location.href="' + loanData.contractpdf + '"');
    			
    			getUser(loanData.useridfk);

    		} else if (hr.readyState == 4) {
    			addNotification('Retrieving data failed with status ' + hr.status + '. Try again later.');
    		}
    	}
    	hr.send(null);
	}
	
	function getUser(id) {
    	var hr = new XMLHttpRequest();

    	hr.open("GET", "/bundlePWABackend/restservices/user/" + id, true);

    	hr.onreadystatechange = function() {
    		if (hr.readyState == 4 && hr.status == 200) {
    			$('#mainLoader').fadeOut('fast');
    			var userData = JSON.parse(hr.responseText);
    			var loanData = userData[0].loaninformation[0];

    			$('#name').text(checkValue(userData[0].firstName + " " + userData[0].lastName));
    			$('#accountButton').attr("onclick", "window.location.href='account.jsp?id="+ userData[0].userid +"'");
    			$('#group').text(checkValue(loanData.groupid));
    			$('#groupButton').attr("onclick", 'window.location.href="group.jsp?id=' + loanData.groupid + '"');
    			$('#status').text(UCFirst(checkValue(userData[0].status)));	

    		} else if (hr.readyState == 4) {
    			addNotification('Retrieving data failed with status ' + hr.status + '. Try again later.');
    		}
    	}
    	hr.send(null);
    }
	</script>
	<div id="helpPopup" class="popup" style="display: none;">
		<div>
			<h2>Loan explained</h2>
			<button class="buttonRound" onclick="toggleHide('helpPopup', true)">X</button>
			<p>This page will give you a overview of your loan
				details.</p>
		</div>
	</div>
</body>
</html>
