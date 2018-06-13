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
		<li><a href="index.jsp">Home</a></li>
		<li><a href="dashboard.jsp">Dashboard</a></li>
		<li><a href="groups.jsp">Groups</a></li>
		<li><a href="contracts.jsp">Contracts</a></li>
		<li><a href="allaccounts.jsp">All Accounts</a></li>
		<li><a href="account.jsp">My Account</a></li>
		<li id="login"><a href="login.jsp">Login</a></li>
	</ul>

	<footer>
		<p class="copyright">&#169; Bundle 2017-2018</p>
	</footer>

	<script>
		$(function() {
			if (getCookie("username") != null && getCookie("password") != null) {
				document.getElementById('login').innerHTML = '<span onclick = javascript:logOut();> <a href="login.jsp">Logout</a>  </span>';

			}
			if (getCookie("username") == null && getCookie("password") == null) {

				document.getElementById('menu').innerHTML = '  <li> <a href="index.jsp">Home</a></li>   <li id ="login"><a  href="login.jsp">Login</a></li>';

				if (window.location.pathname == "/bundlePWABackend/loans.jsp"
						|| window.location.pathname == "/bundlePWABackend/contracts.jsp") {
					window.location.replace("login.jsp");
				}

			}

			// Give navigation bar active page a color
			var current = location.pathname;
			current = current.replace('/bundlePWABackend/', '');
			$('.menu li a').each(function() {
				var $this = $(this);
				// if the current path is like this link, make it active
				if (current != '') {
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