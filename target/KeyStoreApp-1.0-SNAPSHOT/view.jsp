<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
 <html> <head> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 <link rel="icon" type="image/ico" href="favicon.ico"/>
	 <title>View Page</title>
<link rel="stylesheet" type="text/css" href="styler.css">
  		<%if(session.getAttribute("Username")==null){
                 response.setStatus(response.SC_MOVED_TEMPORARILY);
                 response.setHeader("Location", "/login.jsp");
             }%>
                  			</head>
  <body>
   <div class="container">
            <div id="ViewTopHead"> <img src="fg_logo_TM_2@2.png" class ="ViewLogo" alt="Fieldglass">
            <a href="/Logout" class="button">Logout</a><a href="landing.jsp" class="button">Return</a>
            </div>
             <p class="error" id="status"></p>
              <div class="ViewForm">
               <div class="ViewHeader"> View Page</div>
               <div class="body">
	                <table class="ViewTable">
	                     <% List<Document> keys= (List<Document>)session.getAttribute("docKeys");
		                    List<Document> values= (List<Document>)session.getAttribute("docValues");
		                    for(int i = 0; i < keys.size() ; i+=1) {%>
			                <tr><td><b>
                             <% out.println(keys.get(i));%></b>
			                </td>
			                <td class="long"><%out.println(values.get(i));%> </td>
			                </tr>
                         <% } %>
                    </table>
		</div>
		<div id="ViewBotButtons">
		<a href="/EditRouter?type=1&id=<%out.print(session.getAttribute("_id"));%>">Edit</a>
		<a href="/DeleteAsset?id=<%out.print(session.getAttribute("_id"));%>"  onclick="return confirm('Are you sure you want to delete permanently?')">Delete</a>
		</div>
	  </body> </html>