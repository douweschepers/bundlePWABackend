<!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body >

    <jsp:include page="parts/navigation.jsp" />

	<main>
        <div class="welcomeBlock">
            <h1>Edit Loan</h1>
        </div>

        <div class="buttonBlock">
        </div>

        <div class="block">
            <form onsubmit="return false">
                <ul class="flex-outer">

                    <li>
                        <label for="loan-type">Loan Type</label>
                        <select name="loan-type" id="loan-type">
                            <option value="ST">Short-term</option>
                            <option value="MT">Mid-term</option>
                            <option value="LT">Long-term</option>
                        </select>
                    </li>
                    <li id="loanSatusItem" class="hide">
                        <label for="loan-status">Loan Status</label>
                        <select name="loan-status" id="loan-status">
                            <option value="active">Active</option>
                            <option value="pending">Pending</option>
                            <option value="defaulted">Defaulted</option>
                            <option value="denied">Denied</option>
                        </select>
                    </li>
                    <input class="hide" name="paidamount" id="paidamount" placeholder="Enter the loan-amount here"></input>
                    <li>
                        <label for="duration">Duration</label>
                        <input type="number" name="duration" id="duration" min="1" max="36" placeholder="Enter the loan-duration here"></input>
                    </li>
                    <li>
                        <label for="closing-date">Closing Date</label>
                        <input type="date" name="closing-date" id="closing-date"></input>
                    </li>
                    <li>
                        <label for="description">Description</label>
                        <input id="description" name="description" placeholder="Enter the loan-description here"></input>
                    </li>
                    <li>
                        <button style="width: 100%;" type="submit">Submit</button>
                    </li>
                </ul>
            </form>
        </div>
    </main>

    <script type="text/javascript">
		if(role == null || role == "applicant") {
	    	window.location.href = 'index.jsp';
	    }

		if(role == "admin") {
			$('#loanSatusItem').removeClass('hide');
		}

		//if (getParameterByName('id') == null)
        //retrieve data to fill form
        $(document).ready(function() {
            $.ajax({
                url : "/bundlePWABackend/restservices/loan/"
                + getParameterByName('id'),
                type : "get",

                success : function(response) {

                        $("#paidamount").val(response["amount"]);
                        $("#loan-status").val(response["status"]);
                        $("#loan-type").val(response["loantype"]);
                        $("#paidamount").val(response["paidamount"]);
                        $("#duration").val(response["duration"]);
                        $("#closing-date").val(response["closingdate"]);
                        $("#description").val(response["description"]);

                },
                error : function(response, textStatus, errorThrown) {
                	addNotification("Failed to load data");
                }
            });

            //post data when form is submitted
            $("form").submit(function() {
            $.ajax({
					url : "/bundlePWABackend/restservices/loan/" + getParameterByName('id'),
					type : "put",
					data : $("form").serialize(),

					success : function(response) {
						addNotification("Loan updated succesfully", "green");
              window.location.href="loan.jsp?id="+id;
					},
					error : function(response, textStatus, errorThrown) {
						addNotification("Loan could not be updated.");
					}
				});
        });
        });
    </script>

    <jsp:include page="parts/footer.jsp" />

</body>
</html>
