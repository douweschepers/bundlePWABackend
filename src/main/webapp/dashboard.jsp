<!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body>

	<jsp:include page="parts/navigation.jsp" />

	<main>
	<div class="welcomeBlock">
		<h1>Dashboard</h1>
		<button class="buttonRound" onclick="toggleHide('helpPopup', false)">?</button>
	</div>

	<div class="block dashboardBlock">
		<div class="blockHalf dashboardfull">
			<h3>Loans per country</h3>
			<canvas id="loans_per_country"></canvas>
		</div>
		<div class="blockHalf dashboard">
			<div class="chart-legend">
				<h3>Loans per Day</h3>
			</div>
			<canvas id="loans"></canvas>
		</div>
		<div class="blockHalf dashboard">
			<div class="chart-legend">
				<h3>Transactions per Day</h3>
			</div>
			<canvas id="transactions"></canvas>
		</div>
	</div>

	<div id="helpPopup" class="popup" style="display: none;">
		<div>
			<h2>Dashboard explained</h2>
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

	</main>
	<script>
		(function draw() {
			var t;

			function size(animate) {

				clearTimeout(t);

				t = setTimeout(function() {
					$("canvas").each(function(i, el) {

						$(el).attr({
							"width" : $(el).parent().width(),
							"height" : $(el).parent().outerHeight()
						});
					});
					redraw(animate);

					var m = 0;
					$(".widget").height("");
					$(".widget").each(function(i, el) {
						m = Math.max(m, $(el).height());
					});
					$(".widget").height(m);

				}, 100);
			}
		});

		$(window).on('resize');
		function redraw(animation) {
			var options = {};
			if (!animation) {
				options.animation = false;
			} else {
				options.animation = true;
			}
			draw();

		}
	</script>
	<script src="js/Chart.min.js"></script>

	<script>
		if (role == null) {
			window.location.replace('login.jsp');
		}
		var sessionToken = window.sessionStorage.getItem("sessionToken");
		var Countries = {};

		$
				.ajax({

					url : "/bundlePWABackend/restservices/address/loanspercountry",
					type : "get",
					beforeSend : function(xhr) {
						xhr.setRequestHeader("Authorization", "Bearer "
								+ sessionToken);
					},
					success : function(result) {
						$('#mainLoader').fadeOut('fast');

						var data = result;

						data.forEach(function(object) {
							var country = object.country;
							var numberOfContracts = object.amount;

							Countries[country] = numberOfContracts;

						});

						var ctx = document.getElementById("loans_per_country");
						var myChart = new Chart(ctx, {
							type : 'bar',
							data : {
								labels : Object.keys(Countries),
								datasets : [ {
									label : '# of Loans',
									data : Object.values(Countries),
									backgroundColor : "#12736d",
									borderColor : "white",
									borderWidth : 1
								} ]
							},
							options : {
								scales : {
									yAxes : [ {
										ticks : {
											beginAtZero : true
										}
									} ]
								}
							}
						});
					},
					error : function(response, textStatus, errorThrown) {
						addNotification("Unauthorized, Countries not loaded!")
						console.log("textStatus: " + textStatus);
						console.log("errorThrown: " + errorThrown);
						console.log("status: " + response.status);
					}
				});
	</script>

	<script>
		var sessionToken = window.sessionStorage.getItem("sessionToken");
		var Loans = {};

		$
				.ajax({

					url : "/bundlePWABackend/restservices/loan/lastweek",
					type : "get",
					beforeSend : function(xhr) {
						xhr.setRequestHeader("Authorization", "Bearer "
								+ sessionToken);
					},
					success : function(result) {
						$('#mainLoader').fadeOut('fast');

						var data = result;

						data.forEach(function(object) {
							var startdate = object.startdate;
							var date = new Date(startdate);
							var currentDate = new Date(Date.now());

							var difference = currentDate.getDate()
									- date.getDate();

							switch (difference) {
							case 1:
								if (Loans[startdate] >= 1) {
									Loans[startdate] += 1;
								} else {
									Loans[startdate] = 1;
								}
								break;
							case 2:
								if (Loans[startdate] >= 1) {
									Loans[startdate] += 1;
								} else {
									Loans[startdate] = 1;
								}
								break;
							case 3:
								if (Loans[startdate] >= 1) {
									Loans[startdate] += 1;
								} else {
									Loans[startdate] = 1;
								}
								break;
							case 4:

								if (Loans[startdate] >= 1) {
									Loans[startdate] += 1;
								} else {
									Loans[startdate] = 1;
								}

								break;
							case 5:
								if (Loans[startdate] >= 1) {
									Loans[startdate] += 1;
								} else {
									Loans[startdate] = 1;
								}
								break;
							case 6:
								if (Loans[startdate] >= 1) {
									Loans[startdate] += 1;
								} else {
									Loans[startdate] = 1;
								}
								break;
							case 7:
								if (Loans[startdate] >= 1) {
									Loans[startdate] += 1;
								} else {
									Loans[startdate] = 1;
								}
								break;
							case 0:
								if (Loans[startdate] >= 1) {
									Loans[startdate] += 1;
								} else {
									Loans[startdate] = 1;
								}
								break;

							default:
								break;
							}
						});

						var data = {
							labels : Object.keys(Loans),
							datasets : [ {
								label : "New Loans",
								backgroundCollor : "#083b38",
								borderColor : "#083b38",
								strokeColor : "#12736d",
								pointColor : "#12736d",
								pointStrokeColor : "#12736d",
								data : Object.values(Loans)
							},

							]
						}
						var canvas = document.getElementById("loans");
						var ctx = canvas.getContext("2d");
						var lineChart = new Chart(ctx, {
							type : 'line',
							data : data,
							options : {
								scales : {
									yAxes : [ {
										stacked : true
									} ]
								}
							}
						});
					},
					error : function(response, textStatus, errorThrown) {
						addNotification("Unauthorized, loan not loaded!")
						console.log("textStatus: " + textStatus);
						console.log("errorThrown: " + errorThrown);
						console.log("status: " + response.status);
					}
				});
	</script>

	<script>
		var sessionToken = window.sessionStorage.getItem("sessionToken");
		var Transactions = {};

		$
				.ajax({

					url : "/bundlePWABackend/restservices/transaction/lastweek",
					type : "get",
					beforeSend : function(xhr) {
						xhr.setRequestHeader("Authorization", "Bearer "
								+ sessionToken);
					},
					success : function(result) {
						$('#mainLoader').fadeOut('fast');

						var data = result;
						data.forEach(function(object) {
							var startdate = object.timestamp;
							var date = new Date(startdate);
							var currentDate = new Date(Date.now());

							var difference = currentDate.getDate()
									- date.getDate();

							switch (difference) {
							case 1:
								if (Transactions[startdate] >= 1) {
									Transactions[startdate] += 1;
								} else {
									Transactions[startdate] = 1;
								}
								break;
							case 2:
								if (Transactions[startdate] >= 1) {
									Transactions[startdate] += 1;
								} else {
									Transactions[startdate] = 1;
								}
								break;
							case 3:
								if (Transactions[startdate] >= 1) {
									Transactions[startdate] += 1;
								} else {
									Transactions[startdate] = 1;
								}
								break;
							case 4:

								if (Transactions[startdate] >= 1) {
									Transactions[startdate] += 1;
								} else {
									Transactions[startdate] = 1;
								}

								break;
							case 5:
								if (Transactions[startdate] >= 1) {
									Transactions[startdate] += 1;
								} else {
									Transactions[startdate] = 1;
								}
								break;
							case 6:
								if (Transactions[startdate] >= 1) {
									Transactions[startdate] += 1;
								} else {
									Transactions[startdate] = 1;
								}
								break;
							case 7:
								if (Transactions[startdate] >= 1) {
									Transactions[startdate] += 1;
								} else {
									Transactions[startdate] = 1;
								}
								break;
							case 0:
								if (Transactions[startdate] >= 1) {
									Transactions[startdate] += 1;
								} else {
									Transactions[startdate] = 1;
								}
								break;

							default:
								break;
							}
						});

						var data = {
							labels : Object.keys(Transactions),
							datasets : [ {
								label : "Incomming Transactions",
								backgroundCollor : "#083b38",
								borderColor : "#083b38",
								strokeColor : "#12736d",
								pointColor : "#12736d",
								pointStrokeColor : "#12736d",
								data : Object.values(Transactions)
							},

							]
						}
						var canvas = document.getElementById("transactions");
						var ctx = canvas.getContext("2d");
						var lineChart = new Chart(ctx, {
							type : 'line',
							data : data,
							options : {
								scales : {
									yAxes : [ {
										stacked : true
									} ]
								}
							}
						});
					},
					error : function(response, textStatus, errorThrown) {
						addNotification("Unauthorized, loan not loaded!")
						console.log("textStatus: " + textStatus);
						console.log("errorThrown: " + errorThrown);
						console.log("status: " + response.status);
					}
				});
	</script>
	<jsp:include page="parts/footer.jsp" />

</body>

</html>