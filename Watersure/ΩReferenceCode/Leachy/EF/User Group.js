var usergroupid = document.getElementsByClassName("x-toolbar-text dbtext x-box-item x-toolbar-item x-toolbar-text-mainmenuButton")[0].id;
var usergroup = document.getElementById(usergroupid); 

var repList = document.getElementById("reportList");

var loginInfo = usergroup.innerHTML;
loginParts = loginInfo.split(',');
userSecGroup = loginParts.pop();

trimGroup = userSecGroup.trim();