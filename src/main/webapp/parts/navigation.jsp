<header id="nav">
	<div class="logo">
		<a href="index.jsp"> <img alt="Bundle Logo"
			src="img/logowhite.png">
		</a>
	</div>

	<input class="menu-btn" type="checkbox" id="menu-btn" /> <label
		class="menu-icon" for="menu-btn"> <span class="navicon"></span>

	</label>
	<ul class="menu" id="menu">
		<li role="loggedIn" class="noHover hide"><a href=""><h2 id="username" class="navTitle username">Username</h2></a></li>
		<li role="loggedIn" class="hide" ><a href="account.jsp">My Account</a></li>
		<li role="loggedOut" class="hide" ><a href="index.jsp">Login</a></li>
		<li role="loggedIn" style="cursor: pointer;" class="hide" ><span onclick = javascript:logOut();> <a  ignore="true">Logout</a></span></li>
		
		<li role="applicant" class="noHover hide"><a href=""><h2 class="navTitle" >Applicant Pages</h2></a></li>
		<li role="applicant" class="hide" ><a href="group.jsp">Group</a></li>
		
		<li role="officer" class="noHover hide"><a href=""><h2 class="navTitle" >Officer Pages</h2></a></li>
		<li role="officer" class="hide" ><a href="groups.jsp">Groups</a></li>
		<li role="officer" class="hide" ><a  href="loans.jsp">Loans</a></li>
		
		<li role="admin" class="noHover hide"><a href=""><h2 class="navTitle" >Admin Pages</h2></a></li>
		<li role="admin" class="hide" ><a href="dashboard.jsp">Dashboard</a></li>
		<li role="admin" class="hide" ><a href="groups.jsp">Groups</a></li>
		<li role="admin" class="hide" ><a href="accounts.jsp">Accounts</a></li>
		<li role="admin" class="hide" ><a  href="loans.jsp">Loans</a></li>
		<li role="admin" class="hide" ><a  href="transactions.jsp">Transactions</a></li>
	</ul>

	<footer>
		<p class="copyright">&#169; Bundle 2017-2018</p>
	</footer>

	<script>
		var role = window.sessionStorage.getItem("userType");
		
		var loggedInOut;
		
		if(role != undefined) {
			loggedInOut =("loggedIn");
		} else {
			loggedInOut = ("loggedOut");
		}
		
		if(loggedInOut == "loggedIn") {
    		$('#username').text(getCookie("username"));
    	}
		
		var listItems = $("#menu li");
		listItems.each(function(idx, li) {
		    var item = $(li);
			var roleArray = item.attr("role").split(',');
			if (roleArray.indexOf(role) > -1 || roleArray.indexOf("all") > -1 || roleArray.indexOf(loggedInOut) > -1) {
				item.removeClass('hide');
			}
		});
		
		$(function() {

			// Give navigation bar active page a color
			var current = location.pathname;
			current = current.replace('/bundlePWABackend/', '');
			
			$('.menu li a').each(function() {
				var $this = $(this);
				// if the current path is like this link, make it active
				if (current != '' && $this.attr('ignore') != 'true') {
					if ($this.attr('href').indexOf(current) !== -1) {
						$this.addClass('active');
					}
				} else {
					$('.menu li a[href="index.jsp"]').addClass('active');
				}

			})
		})
	</script>
</header>

<div id="container">
	<div id="notificationBlock"></div>