<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
 <html> <head> <%
               				if(session.getAttribute("Username")==null){
               				response.setStatus(response.SC_MOVED_TEMPORARILY);
               				response.setHeader("Location", "/login.jsp");
               			}%>
               			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 <link rel="icon" type="image/ico" href="favicon.ico"/>
	 <title>Landing Page</title>
<link rel="stylesheet" type="text/css" href="LandingStyler.css">
	 <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js" type="text/javascript"></script>
	 <script type='text/javascript' src='chosen_v1.6.1/chosen.jquery.min.js'></script>
	 <link rel="stylesheet" type="text/css" href="chosen_v1.6.1/chosen.min.css" />
	 <script type="text/javascript" src="jquery.tablesorter.min.js"></script>
	 <script>
		 $( document ).ready(function() {

			 $.getJSON("/AutocompleteController", function(result){
				 var x = "";
				 $.each(result, function(i, field){
					 x += "<option>"+field+"</option>";
				 });
				 document.getElementById("selectBox").innerHTML = x;
				 $(".chosen-select").trigger("chosen:updated");

			 });
		 });

		 function emptyElement(x){
			 document.getElementById(x).innerHTML = "";
		 }
		 function search(values){


			 if(values != null) {
				 var input = "";
				 for (val of values) {
					 input += val + ";";
				 }
				 var ajax = new XMLHttpRequest();
				 ajax.onreadystatechange = function () {
					 if (ajax.readyState == 4 && ajax.status == 200) {
						 document.getElementById("status").innerHTML = '';

						 if (ajax.responseText == "failed") {
							 document.getElementById("status").innerHTML = "Servlet error.";

						 } else {
							 var data = JSON.parse(ajax.responseText);

							 if(data.length > 0) {
								 var output = "";

								 output += '<thead> <tr> <th>Company Code</th> <th>Environment</th> <th>Asset Type</th> <th>Commands</th> </tr> </thead> <tbody>';

								 // cells creation
								 for (var i = 0; i < data.length; i++) {

									 output += '<tr><td width="25%" class="TableCell">' + data[i].CompanyCode + '</td>';
									 output += '<td width="25%"class="TableCell">' + data[i].Environment + '</td>';
									 output += '<td width="25%"class="TableCell">' + data[i].AssetType + '</td>';
									 output += '<td width="25%" align="center" class="TableCell"><a href="/EditRouter?type=0&id=' + data[i]._id.$oid + '">View</a> | <a href="/EditRouter?type=1&id=' + data[i]._id.$oid + '">Edit</a></td></tr>';

								 }
								 output += '</tbody>'

								 document.getElementById("resultsTable").innerHTML = output;
								 $("#resultsTable").tablesorter({
									 cancelSelection: true,
									 headers: {3: {sorter: false}}

								 });
							 } else {
								 document.getElementById("resultsTable").innerHTML = "";
								 document.getElementById("status").innerHTML = "No results found.";
							 }
						 }
					 }
				 }
				 ajax.open("POST", "/Query", true);
				 ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
				 ajax.send("query=" + input);
			 } else {
			 	document.getElementById("resultsTable").innerHTML = "";
			 }
		 }
	 </script>





  <body>
           <div class="container">
          <div id="LandingTopHead"> <img src="fg_logo_TM_2@2.png" class ="LandingLogo" alt="Fieldglass"><a href="/Logout" class="button">Logout</a></div>
           <p class="error" id="status"></p>
            <div class="LandingForm">
             <div class="LandingHeader"> Landing Page</div>
             <div class="body">

				  <select id="selectBox" data-placeholder="Enter a query" style="width:350px;" class="chosen-select" multiple tabindex="6">

					  </select>


  <div id="dataTable"><table id="resultsTable" class="tablesorter"></table>
  </div><div id="LandingBotButtons">
  <a href="add.jsp" class="button">Add New Asset</a></div>
  </div></div>

			   <script type="text/javascript">
				   $(".chosen-select").chosen({search_contains:true}).change(function(e, params) {
					   var values = $("#selectBox").chosen().val();
					   search(values);
					   var keys = ["CompanyCode", "Environment", "AssetType"];
					   var select = document.getElementById('selectBox');
					   var selectedItem = params.selected, deselectedItem = params.deselected;
					   function processChangeRequest(item, change) {
						   if(values == null || values[0] === "All") {
							   select[select.length-1].disabled = false;
							   for (let i=0; i<select.length-1; i++) {
								   select[i].disabled = change;
							   }
						   } else {
							   var key;
							   for(const i of keys) {
								   if(item.includes(i)) {
									   key = i;
									   break;
								   }
							   }
							   select[select.length-1].disabled = true;
							   for (let i=0; i<select.length-1; i++) {
								   if (select[i].childNodes[0].data != item && select[i].childNodes[0].data.includes(key)) {
									   select[i].disabled = change;
								   }
							   }
						   }
						   $(".chosen-select").trigger("chosen:updated");
					   }
					   if(selectedItem != null) {
						   processChangeRequest(selectedItem, true);
					   }
					   else if(deselectedItem != null) {
						   processChangeRequest(deselectedItem, false);
					   }
				   });
			   </script>
	</body></html>

