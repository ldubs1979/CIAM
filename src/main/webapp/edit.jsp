<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
 <html> <head> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 <link rel="icon" type="image/ico" href="favicon.ico"/>
	 <title>Edit Page</title>
	 <% List<Document> keys= (List<Document>)session.getAttribute("docKeys");
           List<Document> values= (List<Document>)session.getAttribute("docValues");
     	  if(session.getAttribute("Username")==null){
     		response.setStatus(response.SC_MOVED_TEMPORARILY);
     		response.setHeader("Location", "/login.jsp");
     		}%>
<link rel="stylesheet" type="text/css" href="styler.css">
 		<script>
                          function emptyElement(x){
                              document.getElementById(x).innerHTML = "";
                          }
                          function UpdateSFTPMethod(){

                              var id = '<%= session.getAttribute("_id") %>';
                              var CompanyCode = document.getElementById('CompanyCode').value;
                              var Environment = document.getElementById('Environment').value;
                              var Host = document.getElementById('Host').value;
                              var Username = document.getElementById('Username').value;
                              var Password = document.getElementById('Password').value;
                              var Port = document.getElementById('Port').value;
                              var Description= document.getElementById('Description').value;
                              if(CompanyCode == "" || Environment == ""|| Host == ""|| Username == ""|| Password == ""|| Port == ""){
                                  document.getElementById("status").innerHTML = "Please fill out mandatory fields (marked *)";
                              }
                              else if(CompanyCode.length >4){
                                   document.getElementById("status").innerHTML = "CompanyCode must be 4 or less characters in length";
                               }
                              else if(confirm("Are you sure you would like to save this Asset")){
                                  document.getElementById("editbtn").style.display = "none";
                                  document.getElementById("status").innerHTML = 'please wait ...';
                                  var ajax = new XMLHttpRequest();
                                  ajax.onreadystatechange = function() {
                                      if (ajax.readyState == 4 && ajax.status == 200) {
                                          if(ajax.responseText == "exists"){
                                              document.getElementById("status").innerHTML = "That combination of AssetType, CompanyCode, and Environment already exists. please try again.";
                                              document.getElementById("editbtn").style.display = "block";
                                          } else {
                                              window.location = "/EditRouter?type=0&id="+id;
                                          }
                                      }
                                  }
                                  ajax.open("POST", "/UpdateSFTP", true);
                                  ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                  ajax.send("id="+id+"&CompanyCode="+CompanyCode+"&Environment="+Environment+"&Host="+Host+"&Username="+Username+"&Password="+Password+"&Port="+Port+"&Description="+Description);
                              }

                          }
                          function UpdateEncMethod(){
                           if(confirm("Are you sure you would like to save this Asset")){
                                 var id = '<%= session.getAttribute("_id") %>';
                               var CompanyCode = document.getElementById('CompanyCode').value;
                               var Environment = document.getElementById('Environment').value;
                               var EncryptKey = document.getElementById('EncryptKey').value;
                               var EncryptType = document.getElementById('EncryptType').value;
                               var DecryptKey = document.getElementById('DecryptKey').value;
                               var SigningKey = document.getElementById('SigningKey').value;
                               var SigningVerificationKey = document.getElementById('SigningVerificationKey').value;
                               var DecryptPassword = document.getElementById('DecryptPassword').value;
                               var SigningPassword = document.getElementById('SigningPassword').value;
                               var Description= document.getElementById('Description').value;
                                  if(CompanyCode == "" || Environment == "" || EncryptType == ""){
                                     document.getElementById("status").innerHTML = "Please fill out mandatory fields (marked *)";
                                  }
                                  else if(EncryptKey == ""&& DecryptKey == ""&& SigningKey == ""&& SigningVerificationKey == ""&& DecryptPassword == ""&& SigningPassword == ""&& Description == ""){
                                    document.getElementById("status").innerHTML= "Please fill out at least one additional field"
                                  }
                                  else if(CompanyCode.length >4){
                                      document.getElementById("status").innerHTML = "CompanyCode must be 4 or less characters in length";
                                  }
                                  else {
                                       document.getElementById("editbtn").style.display = "none";
                                       document.getElementById("status").innerHTML = 'please wait ...';
                                       var ajax = new XMLHttpRequest();
                                       ajax.onreadystatechange = function() {
                                       if (ajax.readyState == 4 && ajax.status == 200) {
                                             if(ajax.responseText == "exists"){
                                                document.getElementById("status").innerHTML = "That combination of AssetType, CompanyCode, and Environment already exists. please try again.";
                                                document.getElementById("editbtn").style.display = "block";
                                             }
                                             else {
                                                window.location = "/EditRouter?type=0&id="+id;
                                             }
                                       }
                                       }
                                 ajax.open("POST", "/UpdateEncryption", true);
                                 ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                 ajax.send("id="+id+ "&CompanyCode="+CompanyCode+"&Environment="+Environment+"&EncryptKey="+EncryptKey+"&EncryptType="+EncryptType+"&DecryptKey="+DecryptKey+
                                 "&SigningKey="+SigningKey+"&SigningVerificationKey="+SigningVerificationKey+"&DecryptPassword="+DecryptPassword+"&SigningPassword="+SigningPassword+"&Description="+Description);
                                 }
                          }
                          }
                      </script>
                      </head>
  <body>
    <div class="container">
             <div id="EditTopHead"> <img src="fg_logo_TM_2@2.png" class ="EditLogo" alt="Fieldglass">
             <a href="/Logout" >Logout</a>
             <a href="landing.jsp" >Return</a>
             </div>
              <p class="error" id="status"></p>
               <div class="EditForm">
                <div class="EditHeader"> Edit Page</div>
                <div class="body">
                 <form method="post" onsubmit="return false;" autocomplete="off">
    	 <table class="EditTable">
	        <% for(int i = 1; i < keys.size() ; ++i) {%>
			    <tr><td><b>
                 <%if(session.getAttribute("AssetType").toString().equalsIgnoreCase("Enc")&&(i==1||i==2||i==3||i==5)){out.println(keys.get(i)+"*");}
                 else if(session.getAttribute("AssetType").toString().equalsIgnoreCase("SFTP")&&(i<=7)){out.println(keys.get(i)+"*");}
                 else{
                     out.println(keys.get(i));
                }%></b>
			    </td>
			        <%if (i==1){%>
		            	<td width="80%" align="center" style="word-wrap: break-word"> <%out.println(values.get(i));%> </td>
			            <%} else if (session.getAttribute("AssetType").toString().equalsIgnoreCase("Enc")&& (i==4||i==6||i==7||i==8)){%>
			            <td ><textarea rows="10" cols="80" id="<%out.print(keys.get(i));%>"><%out.print(values.get(i));%></textarea> </td>
			            <%}else{%>
			            <td width="80%" align="center" style="word-wrap: break-word"><input type="text" id="<%out.print(keys.get(i));%>" value="<%out.print(values.get(i));%>"> </td>
			            <%}%>
			            </tr>
                        <% } %></table>
                        <div id="EditBotButtons">
		                </br> <button id="editbtn" class="EditButton" onclick="<%if(session.getAttribute("AssetType").equals("SFTP")){out.print("UpdateSFTPMethod()");}else{out.print("UpdateEncMethod()");}%>" style="display: block">Submit</button>
				        </form>

                          <a href="/DeleteAsset?id=<%out.print(session.getAttribute("_id"));%>"  onclick="return confirm('Are you sure you want to delete permanently?')">Delete</a>
		        </div>
		        </div>
		</div>
	  </body> </html>