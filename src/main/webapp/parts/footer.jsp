</div>
<footer class="mobile">
    <p class="copyright">&#169; Bundle 2017-2018</p>
</footer>

<div class="connection" style="display: none;">
	<div class="connect">
		<p>You are offline</p>
	</div>
</div>

<script>
function updateIndicator() {
	if(navigator.onLine) {
		$(".connection").fadeOut('slow');	
	} else {
		$(".connection").fadeIn('slow');
	}
}

// Update the online status icon based on connectivity
window.addEventListener('online',  updateIndicator);
window.addEventListener('offline', updateIndicator);
updateIndicator(); 
</script>