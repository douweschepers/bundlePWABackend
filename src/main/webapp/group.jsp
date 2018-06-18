<!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body onload="getGroup();getUsers();">

	<jsp:include page="parts/navigation.jsp" />

	<main>
	<div class="welcomeBlock">
		<h1>Group</h1>
		<button class="buttonRound" onclick="toggleHide('helpPopup', false)">?</button>
		<button class="buttonRound"
			onclick="toggleHide('AddMember', false)">+</button>
	</div>

	<div class="block">
       	<div id="mainLoader" class="loaderBlock">
       		<div class="loader"></div>
       	</div>
		<div id="GroupTable">
			<ul class="flex-outer filterList">
				<li><input type="text"
					id="searchInput" placeholder="Type here to filter"></li>
			</ul>
			<table id='contractstable' class='contracts_table'>
				<thead>
					<tr class="desktop">
						<th>Name</th>
						<th>Amount</th>
						<th>Progress</th>
						<th>Time Remaining</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody id="fbody">
				</tbody>
			</table>
		</div>
	</div>

	<jsp:include page="parts/footer.jsp" />

	<div id="helpPopup" class="popup" style="display: none;">
		<div>
			<h2>Contracts explained</h2>
			<button class="buttonRound" onclick="toggleHide('helpPopup', true)">X</button>
			<p>Lorem ipsum dolor sit amet, pretium leo sed, ac leo aenean
				tellus, orci amet maxime amet sed nunc pharetra, scelerisque
				tristique pretium morbi scelerisque mollis sed, vivamus pede irure
				ac lacus. Diam ante sit amet, blandit laoreet interdum sem
				pellentesque. Sit turpis ligula non, iaculis viverra. Lorem ipsum
				dolor sit amet, pretium leo sed, ac leo aenean tellus, orci amet
				maxime amet sed nunc pharetra, scelerisque tristique pretium morbi
				scelerisque mollis sed, vivamus pede irure ac lacus. Diam ante sit
				amet, blandit laoreet interdum sem pellentesque. Sit turpis ligula
				non, iaculis viverra.</p>
		</div>
	</div>
	<div id="AddMember" class="popup"  style="display: none;">
		<div>
			<h2>Add group members</h2>
			<button class="buttonRound" onclick="toggleHide('AddMember', true)">X</button>

					<select id="users-dropdown" name="users">
			</select>
		</div>
		<button class="buttonRound" onclick="AddUser();">Save</button>

	</div>
	</main>

	<script>
	$("#searchInput").keyup(function() {
		// Split the current value of the filter textbox
		var data = this.value.split(" ");
		// Get the table rows
		var rows = $("#fbody").find("tr");
		if (this.value == "") {
			rows.show();
			return;
		}

		// Hide all the rows initially
		rows.hide();

		// Filter the rows; check each term in data
		rows.filter(function(i, v) {
			for (var d = 0; d < data.length; ++d) {
				if ($(this).is(":contains('" + data[d] + "')")) {
					return true;
				}
			}
			return false;
		})
		// Show the rows that match.
		.show();
	}).focus(function() { // style the filter box
		this.value = "";
		$(this).css({
			"color" : "black"
		});
		$(this).unbind('focus');
	}).css({
		"color" : "#C0C0C0"
	});

	// make contains case insensitive globally
	// (if you prefer, create a new Contains or containsCI function)
	$.expr[":"].contains = $.expr
			.createPseudo(function(arg) {
				return function(elem) {
					return $(elem).text().toUpperCase().indexOf(
							arg.toUpperCase()) >= 0;
				};
			});
		function getGroup() {
			var hr = new XMLHttpRequest();
			if(getParameterByName("id") === null) {
				id = getCookie("groupid");
				$('#mainLoader').fadeOut('fast');
				addNotification("No group specified, try again from the groups page...");
			} else {
				id = getParameterByName("id");
				hr.open("GET", "/bundlePWABackend/restservices/loangroup/" +id ,
						true);

				hr.onreadystatechange = function() {
					if (hr.readyState == 4 && hr.status == 200) {
						var data = JSON.parse(hr.responseText);
						var datalength = data.length;

						for (var i = 0; i < datalength; i++) {
							var id = data[i].loaninformation[0].useridfk.toString();

							var amount = data[i].loaninformation[0].amount;
							var paidamount = data[i].loaninformation[0].paidamount;
							var duration = data[i].loaninformation[0].duration;
							var status = data[i].loaninformation[0].status;
							var loanid = data[i].loaninformation[0].loanId;
							done = createCode(id, name, amount, paidamount, duration, status, loanid);

						}
						$('#mainLoader').fadeOut('fast');
					} else if (hr.readyState == 4) {
						addNotification('Retrieving data failed with status '
								+ hr.status + '. Try again later.');
					}
				}
				hr.send(null);

			}

			function createCode(id, name, amount, paidamount, duration, status,
					loanid) {

				$
						.ajax({
							url : "/bundlePWABackend/restservices/user/" + id,
							type : "get",

							success : function(response) {

								var data2 = response;
								var name = data2[0].firstName + " "
										+ data2[0].lastName;

								var table = document
										.getElementById('fbody');
								var tr = document.createElement('tr');
								tr.innerHTML = '<td class="name" id="name" data-label="Name">'
										+ name
										+ '</td>'
										+ '<td id ="amount" data-label="Amount">'
										+ amount
										+ '</td>'
										+ '<td id ="progress" data-label="Progress">'
										+ '<progress class="inlineProgress" value=' +paidamount+' max= '+  amount+ '> </progress></td>'
										+ '<td id = "duration" data-label="Time Remaining">'
										+ duration
										+ " months"
										+ '</td>'
										+ '<td id="status" data-label="Status">'
										+ status
										+ '</td>'
										+ "<td class='tdHide'>  <button class='small' onclick='toViewLoan("+ loanid + ");'>View</button></td> "
										+ "<td class='tdHide'>  <button class='small' onclick='toEditLoan("
										+ loanid + ");'>Edit</button> </td>";
								table.appendChild(tr);
								return true;
							},
							error : function(response, textStatus, errorThrown) {
								console.log("Failed.");
								console.log("textStatus: " + textStatus);
								console.log("errorThrown: " + errorThrown);
								console.log("status: " + response.status);

							}
						});

			}
			}
			function getUsers(){
			let dropdown = $('#users-dropdown');

			dropdown.empty();

			dropdown.append('<option selected="true" disabled>Choose user</option>');
			dropdown.prop('selectedIndex', 0);



			// Populate dropdown with list of provinces
			$.getJSON('http://localhost:4711/bundlePWABackend/restservices/loan/groupless', function (data) {
				$.each(data, function (key, entry) {
					dropdown.append($('<option></option>').attr('value', entry.loanid).text(entry.name));
				})
			});
			}
function AddUser(){
	var pdfData;
	id = getCookie("groupid");
	loanid=document.getElementById("users-dropdown").value;
	$.ajax({
		url : "/bundlePWABackend/restservices/loangroup/"+id+"/"+loanid,
		type : "post",
		data : pdfData,

		success : function(response) {

			addNotification('Group member added.', "green", 6000);

		},
		error : function(response, textStatus, errorThrown) {

			addNotification('Error while adding member, contact admin', null, 6000);
			console.log("textStatus: " + textStatus);
			console.log("errorThrown: " + errorThrown);
			console.log("status: " + response.status);

		}
	});
	location.reload();
}
	</script>
</body>
</html>
