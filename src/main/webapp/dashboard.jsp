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

            <!-- <canvas id="chart_1"></canvas> -->
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
        (function draw (){
        // set up the timeout variable
        var t;
        // setup the sizing function,
        // with an argument that tells the chart to animate or not
        function size(animate) {
            // If we are resizing, we don't want the charts drawing on every resize event.
            // This clears the timeout so that we only run the sizing function
            // when we are done resizing the window
            clearTimeout(t);
            // This will reset the timeout right after clearing it.
            t = setTimeout(function () {
                $("canvas").each(function (i, el) {
                    // Set the canvas element's height and width to it's parent's height and width.
                    // The parent element is the div.canvas-container
                    $(el).attr({
                        "width": $(el).parent().width(),
                        "height": $(el).parent().outerHeight()
                    });
                });
                // kickoff the redraw function, which builds all of the charts.
                redraw(animate);

                // loop through the widgets and find the tallest one, and set all of them to that height.
                var m = 0;
                // we have to remove any inline height setting first so that we get the automatic height.
                $(".widget").height("");
                $(".widget").each(function (i, el) { m = Math.max(m, $(el).height()); });
                $(".widget").height(m);

            }, 100); // the timeout should run after 100 milliseconds
        }
        });
        $(window).on('resize', size);
        function redraw(animation) {
            var options = {};
            if (!animation) {
                options.animation = false;
            } else {
                options.animation = true;
            }
            draw();
            // ....
            // the rest of our chart drawing will happen here
            // ....
        }
        size();

    </script>
    <script src="js/Chart.min.js"></script>
    <script>
        
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
    </script>
    <script>
            var data = {
                labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                datasets: [
                    {
                        label: "Outgoing Transactions",
                        backgroundCollor: "#083b38",
                        borderColor: "#083b38",
                        strokeColor: "#12736d",
                        pointColor: "#12736d",
                        pointStrokeColor: "#12736d",
                        data: [23321, 5221, 3322, 8882, 4432, 3242, 2344]
                    },
                    {
                        label: "Incomming Transactions",
                        fillColor: "rgba(219,186,52,0.4)",
                        borderColor: "#12736d",
                        strokeColor: "#12736d",
                        pointColor: "rgba(220,220,220,1)",
                        pointStrokeColor: "#fff",
                        data: [22320, 38349, 54543, 23453, 34323, 34432, 50000]
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
        </script>
    <jsp:include page="parts/footer.jsp" />

</body>

</html>