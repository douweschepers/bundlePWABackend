<!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body onload="getContracts()">

	<jsp:include page="parts/navigation.jsp" />

	<main>
	<div class="welcomeBlock">
		<h1>Transactions</h1>
		<button class="buttonRound" onclick="toggleHide('helpPopup', false)">?</button>
		<button class="buttonRound" onclick="window.location.href='new_transaction.jsp'">+</button>
	</div>

	<div class="block">

		<div id="mainLoader" class="loaderBlock">
        <div class="loader"></div>
    </div>
    
		<div id="contracts">
			<ul class="flex-outer filterList">
				<li><input type="text"
					id="searchInput" placeholder="Type here to filter"></li>
			</ul>
			<table id='transactionstable' class='transactions_table'>
				<thead>
					<tr class="desktop">
						<th>Id</th>
						<th>Amount</th>
						<th>Sender</th>
						<th>Receiver</th>
						<th>Timestamp</th>
					</tr>
				</thead>
				<tbody id="fbody">
				</tbody>
			</table>
		</div>
	</div>
	</main>

	<jsp:include page="parts/footer.jsp" />
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
	
	function getContracts(){
		var sessionToken = window.sessionStorage.getItem("sessionToken");
		
		$.ajax({
			url: "/bundlePWABackend/restservices/transaction",
			type: "get",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("Authorization",  "Bearer " + sessionToken);
			},
			success: function(result) {
				addNotification("Authorized, Transactions loaded!", "green");
				$('#mainLoader').fadeOut('fast');
				var data = result;
				var table = document.getElementById('fbody');
				data.forEach(function(object) {
					var tr = document.createElement('tr');
					tr.innerHTML = '<td id="transactionId" data-label="ID">'
							+ object.transactionid + '</td>'
							+ '<td id ="amount" data-label="Amount">'
							+ object.amount + ' $</td>'
							+ '<td id = "sender" data-label="Sender">'
							+ object.sender + '</td>'
							+ '<td id = "receiver" data-label="Receiver">'
							+ object.receiver + '</td>'
							+ '<td id="timestamp" data-label="Timestamp">'
							+ object.timestamp + '</td>';
					table.appendChild(tr);
				});
			},
			error: function(response, textStatus, errorThrown) {
					addNotification("Unauthorized, Transactions not loaded!")
					console.log("textStatus: " + textStatus);
					console.log("errorThrown: " + errorThrown);
					console.log("status: " + response.status);
			}
		});
	}</script>

	<div id="helpPopup" class="popup" style="display: none;">
		<div>
			<h2>Contracts explained</h2>
			<button class="buttonRound" onclick="toggleHide('helpPopup', true)">X</button>
			<p>
				Lorem ipsum dolor sit amet, pretium leo sed, ac leo aenean tellus, orci amet maxime amet sed nunc pharetra, scelerisque tristique pretium morbi scelerisque mollis sed, vivamus pede irure ac lacus. Diam ante sit amet, blandit laoreet interdum sem pellentesque. Sit turpis ligula non, iaculis viverra.
				Lorem ipsum dolor sit amet, pretium leo sed, ac leo aenean tellus, orci amet maxime amet sed nunc pharetra, scelerisque tristique pretium morbi scelerisque mollis sed, vivamus pede irure ac lacus. Diam ante sit amet, blandit laoreet interdum sem pellentesque. Sit turpis ligula non, iaculis viverra.
			</p>
		</div>
	</div>

</body>
</html>
