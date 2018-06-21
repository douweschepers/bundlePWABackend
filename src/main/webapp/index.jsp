<!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body onload="loadingText('...');">
    
    <jsp:include page="parts/navigation.jsp" />
	
    <main class="login">
      <div class="welcomeBlock">
      	<h1>Login</h1>
      </div>
      
      <div class="block">
	    <form id = "loginform" name = "loginform" action="javascript:validateLogin();"  class = "form">
		  <ul class="flex-outer">
			  <li>	
			  	<label for="uname"><b>Username</b></label>
			  	<input id = "userName" type="text" placeholder="Enter Username" name="uname">
			  </li>
			  
			  <li>
			 	 <label for="psw"><b>Password</b></label>
			  	<input id = "pass" type="password" placeholder="Enter Password" name="psw">
			  </li>
			  
			  <li>
			  	<button id="loginbutton" type="submit" >Login</button>
			  </li>
		  </ul>
		
		  
	    </form>
	</div>
   </main>

    <jsp:include page="parts/footer.jsp" />
    
    <script>
    if(role != null) {
    	window.location.href = 'account.jsp';
    }
    
    function validateLogin() {
    	$('#loginbutton').attr('loading', 'true');
    	var pass = document.getElementById('pass').value;
    	var username = document.getElementById('userName').value;

    	if (username == '') {
    		$('#loginbutton').attr('loading', 'false');
    		$('#loginbutton').text('Try again');
    		addNotification('Username can not be empty');
    	} else if (pass == '') {
    		$('#loginbutton').attr('loading', 'false');
    		$('#loginbutton').text('Try again');
    		addNotification('Password can not be empty');
    	} else {
    		var logRequest;
    		try {
    			logRequest = new XMLHttpRequest();
    			logRequest.open('GET', "/bundlePWABackend/restservices/login", true);
    			logRequest.setRequestHeader("username", username);
    			logRequest.setRequestHeader("password", pass);
    			logRequest.send(null);
    			logRequest.onload = function() {
    				if (logRequest.readyState === logRequest.DONE && logRequest.status === 200) {
    					var response = JSON.parse(logRequest.response);
    					if (response[0]['userid'] !== undefined) {
    						console.log("2");
    						$('#loginbutton').attr('loading', 'false');
    						$('#loginbutton').text('Succes');
    						setCookie('username', username, 1);
    						window.sessionStorage.setItem('sessionToken', response[0]['session']);
    						window.sessionStorage.setItem('userType', response[0]['usertype']);
    						setCookie('userid', response[0]['userid']);
    						addNotification("Login successful", "green");
    						window.location.href = "account.jsp";
    					} else {
    						$('#loginbutton').attr('loading', 'false');
    						$('#loginbutton').text('Try again');
    						addNotification(response[0]['error']);
    					}
    				} else {
    					$('#loginbutton').attr('loading', 'false');
    					$('#loginbutton').text('Try again');
    					addNotification('Retrieving data failed with status '
    							+ logRequest.status + '. Try again later.');
    				}
    			}

    		} catch (exception) {
    			addNotification("Request failed");
    		}
    	}
    }
    </script>

</body>
</html>