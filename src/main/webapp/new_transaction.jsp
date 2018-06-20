<!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body>
    <jsp:include page="parts/navigation.jsp" />

    <main>
        <div class="welcomeBlock">
            <h1>New Transaction</h1>
            <button class="buttonRound" onclick="toggleHide('helpPopup', false)">?</button>
        </div>

        <div class="buttonBlock"></div>

        <div class="block">
            <div class="formMargin">
                <form id="transaction" onsubmit="return false">
                    <ul class="flex-outer">
                        <li>
                            <label for="amount">Amount</label>
                            <input name="amount" id="amount" placeholder="Enter the transaction-amount here"></input>
                        </li>
                        <li>
                            <label for="timestamp">Timestamp</label>
                            <input name="timestamp" type="date" id="timestamp">
                        </li>
                        
                        <li>
                            <label for="sender">Sender</label>
                            <input name="sender" id="sender" placeholder="Enter the sender here"></input>
                        </li>
                        <li>
                            <label for="receiver">Receiver</label>
                            <input name="receiver" id="receiver" placeholder="Enter the receiver here"></input>
                        </li>
                        <li>
                            <button style="width: 100%;" id="submit" type="submit">Submit</button>
                        </li>

                    </ul>

                </form>

            </div>
        </div>
    </main>


    <script type="text/javascript">
	if(role == null || role == "applicant") {
    	window.location.href = 'index.jsp';
    }

        var loanId = getParameterByName("id");

        $(document).ready(function () {
            $("form").submit(function () {
                var formData = $("#transaction").serializeArray();
                formData.push({
                    name: "loanidfk",
                    value: loanId
                });

                $.ajax({
                    url: "/bundlePWABackend/restservices/transaction",
                    type: "post",
                    data: formData,

                    success: function (response) {
                        addNotification('Transaction saved', "green", 6000);

                        console.log(response);
                    },
                    error: function (response, textStatus, errorThrown) {

                        addNotification('Transaction not saved, contact admin', null, 6000);
                        console.log("textStatus: " + textStatus);
                        console.log("errorThrown: " + errorThrown);
                        console.log("status: " + response.status);

                    }
                });
            });
        });
    </script>

    <jsp:include page="parts/footer.jsp" />

    <div id="helpPopup" class="popup" style="display: none;">
        <div>
            <h2>New Transaction explained</h2>
            <button class="buttonRound" onclick="toggleHide('helpPopup', true)">X</button>
            <p>Add text here that explains where some of the fields are used for</p>
        </div>
    </div>

</body>

</html>