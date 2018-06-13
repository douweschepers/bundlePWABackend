<!DOCTYPE html>
<html lang="en">

<jsp:include page="parts/head.jsp" />

<body>

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
  <div class="popupHeader">
    <h2>Add Members</h2>
    <button class="buttonRound" onclick="toggleHide('helpPopup', true)">X</button>
    <p>Choose members to add to group</p>
</div>
<div class="popupBody">
  <input id="searchInput" value="Type To Filter">

    <select>
    <option value="Klaas">Klaas</option>
    <option value="Henk">Henk</option>
    <option value="Boris">Boris</option>
    <option value="Shenkie">Shenkie</option>
  </select>
</div>
  <div class="popopFooter">
      <button class="buttonRound" onclick="toggleHide('helpPopup', true)">X</button>
    </div>
</div>
<script type=text/javascript>

</script>

</html>
