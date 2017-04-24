<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <link rel="icon" type="image/ico" href="favicon.ico"/>
    <title>Add Page</title>
<script type="text/javascript">
function doClick(objRad){
if (objRad.value=="0"){
document.getElementById("SFTP").style.display='none'; //hide textbox
document.getElementById("Encryption").style.display='block'; //show other options
}
else if (objRad.value=="1"){
document.getElementById("Encryption").style.display='none'; //hide other options
document.getElementById("SFTP").style.display='block'; //show textbox
}
else{
document.getElementById("Encryption").style.display='none'; //hide both
document.getElementById("SFTP").style.display='none'; //hide both
}
}
 function AddSFTPMethod(){

                               var CCSFTP = document.getElementById('CompanyCodeSFTP').value;
                               var EnvSFTP = document.getElementById('EnvironmentSFTP').value;
                               var Host = document.getElementById('Host').value;
                               var User = document.getElementById('Username').value;
                               var Pass = document.getElementById('Password').value;
                               var Port = document.getElementById('Port').value;
                               var Desc= document.getElementById('Description').value;

                                  if(CCSFTP == "" || EnvSFTP == ""|| Host == ""|| User == ""|| Pass == ""|| Port == ""){
                                     document.getElementById("status").innerHTML = "Please fill out mandatory fields (marked *)";
                                  }
                                  else if(CCSFTP.length >4){
                                      document.getElementById("status").innerHTML = "CompanyCode must be 4 or less characters in length";
                                  }
                                  else if(confirm("Are you sure you would like to add this Asset")){
                                       document.getElementById("addbtn").style.display = "none";
                                       document.getElementById("status").innerHTML = 'please wait ...';
                                       var ajax = new XMLHttpRequest();
                                       ajax.onreadystatechange = function() {
                                       if (ajax.readyState == 4 && ajax.status == 200) {
                                             if(ajax.responseText == "exists"){
                                                document.getElementById("status").innerHTML = "That combination of AssetType, CompanyCode, and Environment already exists. please try again.";
                                                document.getElementById("addbtn").style.display = "block";
                                             }
                                             else {
                                                window.location = "/EditRouter?type=0&id="+ajax.responseText ;
                                             }
                                       }
                                       }
                                 ajax.open("POST", "/AddSFTP", true);
                                 ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                 ajax.send("CC="+CCSFTP+"&Env="+EnvSFTP+"&Host="+Host+"&User="+User+"&Pass="+Pass+"&Port="+Port+"&Desc="+Desc);
                                 }

                          }
 function AddEncMethod(){

                               var CCEnc = document.getElementById('CompanyCodeEnc').value;
                               var EnvEnc = document.getElementById('EnvironmentEnc').value;
                               var EncK = document.getElementById('EncryptKey').value;
                               var EncT = document.getElementById('EncryptType').value;
                               var DecK = document.getElementById('DecryptKey').value;
                               var SignK = document.getElementById('SigningKey').value;
                               var SignVer = document.getElementById('SigningVerificationKey').value;
                               var DecP = document.getElementById('DecryptPassword').value;
                               var SignP = document.getElementById('SigningPassword').value;
                               var Desc= document.getElementById('Description').value;
                                  if(CCEnc == "" || EnvEnc == ""|| EncT == ""){
                                     document.getElementById("status").innerHTML = "Please fill out mandatory fields (marked *)";
                                  }
                                  else if(EncK==""&&DecK==""&&SignK==""&&SignVer==""&&DecP==""&&SignP==""&&Desc==""){
                                  document.getElementById("status").innerHTML = "Please fill out one additional field";
                                  }
                                  else if(CCEnc.length >4){
                                      document.getElementById("status").innerHTML = "CompanyCode must be 4 or less characters in length";
                                  }
                                  else if(confirm("Are you sure you would like to add this Asset")) {
                                       document.getElementById("addbtn").style.display = "none";
                                       document.getElementById("status").innerHTML = 'please wait ...';
                                       var ajax = new XMLHttpRequest();
                                       ajax.onreadystatechange = function() {
                                       if (ajax.readyState == 4 && ajax.status == 200) {
                                             if(ajax.responseText == "exists"){
                                                document.getElementById("status").innerHTML = "That combination of AssetType, CompanyCode, and Environment already exists. please try again.";
                                                document.getElementById("addbtn").style.display = "block";
                                             }
                                             else {
                                                window.location = "/EditRouter?type=0&id="+ajax.responseText ;
                                             }
                                       }
                                       }
                                 ajax.open("POST", "/AddEncryption", true);
                                 ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                 ajax.send("CC="+CCEnc+"&Env="+EnvEnc+"&EncK="+EncK+"&EncT="+EncT+"&DecK="+DecK+"&SignK="+SignK+"&SignVer="+SignVer+"&DecP="+DecP+"&SignP="+SignP+"&Desc="+Desc);

                          }
                          }
</script>
 <link rel="stylesheet" type="text/css" href="styler.css">
</head>
<body>
           <div class="container">
          <div id="AddTopHead"> <img src="fg_logo_TM_2@2.png" class ="AddLogo" alt="Fieldglass">
                 <a href="/Logout" class="link">Logout</a>
                <a href="landing.jsp" class="link">Return</a></div>
           <p class="error" id="status"></p>
            <div class="AddForm">
             <div class="AddHeader"> Add Asset Page</div>
             <div class="body">
             <select name="menu" class="AddSelect" onchange="doClick(this)">
             <option value="none">Select an option</option>
             <option value="1">SFTP</option>
             <option value="0">Encryption</option>
             </select>

            <div id="SFTP" class="AddTable" style="display:none">
            <table width="20%" border="1" bordercolor="white" cellpadding="5" cellspacing="0" bgcolor="#DAEAFA" align="center">
            <form method="post" onsubmit="return false;" autocomplete="off">
                <tr><td width="85%">CompanyCode*:</td> <td width="15%"><input type="text" id="CompanyCodeSFTP"><br/></td></tr>
                <tr><td width="85%">Environment*:</td> <td width="85%"><input type="text" id="EnvironmentSFTP"><br/></td></tr>
                <tr><td width="85%">Host*:</td> <td width="85%"><input type="text" id="Host"><br/></td></tr>
                <tr><td width="85%">Username*:</td> <td width="85%"><input type="text" id="Username"><br/></td></tr>
                <tr><td width="85%">Password*:</td> <td width="85%"><input type="text" id="Password"><br/></td></tr>
                <tr><td width="85%">Port*:</td> <td width="85%"><input type="text" id="Port"><br/></td></tr>
                <tr><td width="85%">Description:</td> <td width="85%"><input type="text" id="Description"><br/></td></tr>
            </table>
            <button id="addbtn" class="button" onclick="AddSFTPMethod()">Add Asset</button>
            </form>
            </div>

<div id="Encryption" class="AddTable" style="display:none">
<table width="20%" border="1" bordercolor="white" cellpadding="5" cellspacing="0" bgcolor="#DAEAFA" align="center">
 <form method="post" onsubmit="return false;" autocomplete="off">
<tr><td width="85%">CompanyCode*:</td> <td width="85%"><input type="text" id="CompanyCodeEnc"><br/></td></tr>
<tr><td width="85%">Environment*:</td> <td width="85%"><input type="text" id="EnvironmentEnc"><br/></td></tr>
<tr><td width="85%">EncryptKey:</td> <td width="85%"><textarea rows="10" cols="80" id="EncryptKey"></textarea><br/></td></tr>
<tr><td width="85%">EncryptType*:</td> <td width="85%"><input type="text" id="EncryptType"><br/></td></tr>
<tr><td width="85%">DecryptKey:</td> <td width="85%"><textarea rows="10" cols="80" id="DecryptKey"></textarea><br/></td></tr>
<tr><td width="85%">SigningKey:</td> <td width="85%"><textarea rows="10" cols="80" id="SigningKey"></textarea><br/></td></tr>
<tr><td width="85%">SigningVerificationKey:</td> <td width="85%"><textarea rows="10" cols="80" id="SigningVerificationKey"></textarea><br/></td></tr>
<tr><td width="85%">DecryptPassword:</td> <td width="85%"><input type="text" id="DecryptPassword"><br/></td></tr>
<tr><td width="85%">SigningPassword:</td> <td width="85%"><input type="text" id="SigningPassword"><br/></td></tr>
<tr><td width="85%">Description:</td> <td width="85%"><input type="text" id="Description"><br/></td></tr>
</table>
<button id="addbtn" class="button" onclick="AddEncMethod()">Add Asset</button>
</form>
</div>
</div>
</div>
</body>
</html>