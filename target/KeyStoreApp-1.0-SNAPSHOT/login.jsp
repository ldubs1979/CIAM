<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html> <head>
    <link rel="icon" type="image/ico" href="favicon.ico"/>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Login Page</title>
    <script>
        function emptyElement(x){
            document.getElementById(x).innerHTML = "";
        }
        function login(){
            var u = document.getElementById('User').value;
            var p = document.getElementById('Pass').value;
            if(u == "" || p == ""){
                document.getElementById("status").innerHTML = "Fill out all of the form data";
            } else {

                document.getElementById("loginbtn").style.display = "none";
                document.getElementById("status").innerHTML = 'please wait ...';
                var ajax = new XMLHttpRequest();
                ajax.onreadystatechange = function() {
                    if (ajax.readyState == 4 && ajax.status == 200) {
                        if(ajax.responseText == "login_failed"){
                            document.getElementById("status").innerHTML = "Login unsuccessful, please try again.";
                            document.getElementById("loginbtn").style.display = "block";
                        } else {
                            console.log(ajax.responseText);
                            window.location = "/landing.jsp";
                        }
                    }
                }
                ajax.open("POST", "/LoginChecker", true);
                ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                ajax.send("u="+u+"&p="+p);

            }
        }
    </script>
   <link rel="stylesheet" type="text/css" href="styler.css">
   </head>

  <body>

  <div class="Container">
 <div class="LoginTopHead"> <img src="fg_logo_TM_2@2.png" class ="LoginLogo" alt="Fieldglass"></div>
 <p class="error" id="status"></p>
   <div class="LoginForm">
    <div class="LoginHeader"> Login Page</div>
    <div class="body">
     <form method="post" onsubmit="return false;" autocomplete="off">
     <input type="text" placeholder="Username" id="User" name="Username" onfocus="emptyElement('status')" autofocus>
     <input type="password" placeholder="Password" id="Pass" name="Password" onfocus="emptyElement('status')">
     <button id="loginbtn" class="LoginButton" onclick="login()" style="display: block">Log In</button>
      </form>
      </div>
       </div>
      </div>
	   </body>
	   <%@include file="footer.html"%>
	   </html>
