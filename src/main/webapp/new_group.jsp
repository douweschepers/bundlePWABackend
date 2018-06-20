<!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body onload=getUsers();>

	<jsp:include page="parts/navigation.jsp" />

	<main>


    <div class="welcomeBlock">
		<h1>Add Members</h1>
  		<button class="buttonRound" onclick="toggleHide('AddMember', false)">?</button>
    </div>



</main>
</body>

<jsp:include page="parts/footer.jsp" />
<div id="AddMember" class="popup" style="display: none;">
	<div>
		<h2>Add group members</h2>
		<button class="buttonRound" onclick="toggleHide('helpPopup', true)">X</button>

		<select id="users-dropdown" name="users">
</select>
	</div>
</div>
<script type="text/javascript">
if(role == null) {
	window.location.replace('index.jsp');
}
function getUsers(){
let dropdown = $('#users-dropdown');

dropdown.empty();

dropdown.append('<option selected="true" disabled>Choose user</option>');
dropdown.prop('selectedIndex', 0);



// Populate dropdown with list of provinces
$.getJSON('http://localhost:4711/bundlePWABackend/restservices/loan/groupless', function (data) {
  $.each(data, function (key, entry) {
    dropdown.append($('<option></option>').attr('value', entry.userid).text(entry.name));
  })
});
}
</script>


</html>
