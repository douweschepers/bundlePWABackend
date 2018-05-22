<header class="header">
    <a href="" class="logo">Bundle</a>
    <input class="menu-btn" type="checkbox" id="menu-btn" />
    <label class="menu-icon" for="menu-btn">
    <span class="navicon"></span>

    </label>
    <ul class="menu">
        <li>
            <a href="index.jsp">Home</a>
        </li>
        <li>
            <a href="loans.jsp">Loans</a>
        </li>
        <li>
            <a href="contracts.jsp">Contracts</a>
        </li>
        <li>
            <a href="login.jsp">Login</a>
        </li>
    </ul>
    
    <script>
	    $(function(){
	        var current = location.pathname;
	        current = current.replace('/bundlePWABackend/', '');
	        $('.menu li a').each(function(){
	            var $this = $(this);
	            // if the current path is like this link, make it active
	            if($this.attr('href').indexOf(current) !== -1){
	                $this.addClass('active');
	            }
	        })
	    })
    </script>
</header>

<br>
<br>