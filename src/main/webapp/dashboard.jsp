 <!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body>

    <jsp:include page="parts/navigation.jsp" />

    <main>
        <div class="welcomeBlock">
            <h1>Dashboard</h1>
            <h1 id="title"></h1>

        </div>

        <div class="buttonBlock">
        </div>

        <div class="block">

            <div class="container clearfix">
                <div class="third widget doughnut">
                    <h3>Loans per country</h3>
                    <div class="canvas-container">
                        <canvas id="hours"></canvas>
                    </div>
                </div>
                <div class="third widget line">
                    <div class="chart-legend">
                        <h3>Loans per Day</h3>
                    </div>
                    <div class="canvas-container">
                        <canvas id="loans"></canvas>
                    </div>
                </div>
                <div class="third widget">
                    <div class="chart-legend">
                        <h3>Transactions per Day</h3>
                    </div>
                    <div class="canvas-container">
                        <canvas id="transactions"></canvas>
                    </div>
                </div>
            </div>

        </div>

    </main>
    <script>
        (function draw() {
            var t;
            
            function size(animate) {
                
                clearTimeout(t);
                
                t = setTimeout(function () {
                    $("canvas").each(function (i, el) {
                        
                        $(el).attr({
                            "width": $(el).parent().width(),
                            "height": $(el).parent().outerHeight()
                        });
                    });
                    redraw(animate);

                    var m = 0;
                    $(".widget").height("");
                    $(".widget").each(function (i, el) { m = Math.max(m, $(el).height()); });
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
	if(role == null) {
    	window.location.replace('login.jsp');
    }

        var ctx = document.getElementById("hours");
        var myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ["Ghana", "Rwanda", "Libya", "Nigeria", "Zimbabwe", "Congo"],
                datasets: [{
                    label: '# of Loans',
                    data: [12, 19, 3, 5, 2, 3],
                    backgroundColor: "#12736d",
                    borderColor: "white",
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });


    </script>
    <script>
        var data = {
            labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            datasets: [
                {
                    label: "Closed Loans",
                    backgroundCollor: "#083b38",
                    borderColor: "#083b38",
                    strokeColor: "#12736d",
                    pointColor: "#12736d",
                    pointStrokeColor: "#12736d",
                    data: [65, 54, 30, 81, 56, 55, 40]
                },
                {
                    label: "Added Loans",
                    fillColor: "rgba(219,186,52,0.4)",
                    borderColor: "#12736d",
                    strokeColor: "#12736d",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#fff",
                    data: [20, 60, 42, 58, 31, 21, 50]
                },
            ]
        }

    </script>

    <script>
        var sessionToken = window.sessionStorage.getItem("sessionToken");
        var Loans = {};

        $.ajax({

            url: "/bundlePWABackend/restservices/loan/lastweek",
            type: "get",
            beforeSend: function (xhr) {
                xhr.setRequestHeader("Authorization", "Bearer " + sessionToken);
            },
            success: function (result) {
                $('#mainLoader').fadeOut('fast');

                var data = result;

                data.forEach(function (object) {
                    var startdate = object.startdate;
                    var date = new Date(startdate);
                    var currentDate = new Date(Date.now());

                    var difference = currentDate.getDate() - date.getDate();

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
                    labels: Object.keys(Loans),
                    datasets: [
                        {
                            label: "New Loans",
                            backgroundCollor: "#083b38",
                            borderColor: "#083b38",
                            strokeColor: "#12736d",
                            pointColor: "#12736d",
                            pointStrokeColor: "#12736d",
                            data: Object.values(Loans)
                        },

                    ]
                }
                var canvas = document.getElementById("loans");
                var ctx = canvas.getContext("2d");
                var lineChart = new Chart(ctx, {
                    type: 'line',
                    data: data,
                    options: {
                        scales: {
                            yAxes: [{
                                stacked: true
                            }]
                        }
                    }
                });
            },
            error: function (response, textStatus, errorThrown) {
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

        $.ajax({

            url: "/bundlePWABackend/restservices/transaction/lastweek",
            type: "get",
            beforeSend: function (xhr) {
                xhr.setRequestHeader("Authorization", "Bearer " + sessionToken);
            },
            success: function (result) {
                $('#mainLoader').fadeOut('fast');

                var data = result;
                data.forEach(function (object) {
                    var startdate = object.timestamp;
                    var date = new Date(startdate);
                    var currentDate = new Date(Date.now());

                    var difference = currentDate.getDate() - date.getDate();

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
                    labels: Object.keys(Transactions),
                    datasets: [
                        {
                            label: "Incomming Transactions",
                            backgroundCollor: "#083b38",
                            borderColor: "#083b38",
                            strokeColor: "#12736d",
                            pointColor: "#12736d",
                            pointStrokeColor: "#12736d",
                            data: Object.values(Transactions)
                        },

                    ]
                }
                var canvas = document.getElementById("transactions");
                var ctx = canvas.getContext("2d");
                var lineChart = new Chart(ctx, {
                    type: 'line',
                    data: data,
                    options: {
                        scales: {
                            yAxes: [{
                                stacked: true
                            }]
                        }
                    }
                });
            },
            error: function (response, textStatus, errorThrown) {
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