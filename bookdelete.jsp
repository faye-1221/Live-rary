<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 캐싱 방지 (로그아웃 후 접근 차단) --%>
<%
response.setHeader("Pragma", "no-cache"); 
response.setHeader("Cache-Control", "no-cache"); 
response.setHeader("Cache-Control", "no-store"); 
response.setDateHeader("Expires", 0L); 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사서 등록 - LIVE-RARY</title>
<link type="text/css" rel="stylesheet" href="defaultStyle.css">
<style>
section input[type="submit"] {
	font-size:17px;
	padding:12px;
	width:100%;
}
section form{
	padding: 10px;
	color:#625772;
}

table tbody tr:hover {
    background-color: lightgray;
    cursor:pointer;
}
table {
	width:830px;
}
#search_list {
	margin-top:10px;
	margin-left:10px;
	margin-bottom:10px;
	margin-right:10px;
	width: 860px;
	height: 460px;
	overflow: auto;
}
#chk_result input[type="text"]{
	width:170px;
	background-color:transparent;
	border-radius: 0px;
	border-top-width:0;
	border-left-width:0;
	border-right-width:0;
	border-bottom-width:1;
}
table {
	width:850px;
}
th {
	min-width:70px;
}
table tbody tr:hover {
    background-color:rgba( 0, 0, 0, 0.1 );
    cursor:pointer;
}
tHead tr th {
	background-color:#625772;
	color:#fefaec;
	margin-top:0px;margin-bottom:0px;
}

tr:first-child th:first-child { border-top-left-radius: 5px; }
tr:first-child th:last-child { border-top-right-radius: 5px; }

tr:first-child td:first-child { border-top-left-radius: 0px; }
tr:first-child td:last-child { border-top-right-radius: 0px; }
</style>
<script>
var value;

function createRequest() {
	try {
		value = new XMLHttpRequest();
	} catch(failed) {
		value = null;
	}
	
	if(value == null) 
		alert("리퀘스트 오브젝트 생성 중 에러");
}

function searchBook() {
	var bookname = document.getElementById("bookname").value;
	var url = "searchRmBook.jsp";
	createRequest();
	value.open('POST', url, true);
	value.onreadystatechange = updateSearchReturn;
	value.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	value.send("bookname=" + bookname);
}

function updateSearchReturn() {
	//console.log(value.readyState);
	if(value.readyState == 4 && value.status == 200) {		
		var data = value.responseText;
		var searchResult = document.getElementById("search_list");
		searchResult.innerHTML = data;
	}
}

function selectBook() {
	var getclick = event.currentTarget;	
	var url = "searchRmchk.jsp";
	createRequest();
	value.open('POST', url, true);
	value.onreadystatechange = updateChkReturn;
	value.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	value.send("bookid=" + getclick.children[0].innerHTML + "&bookname=" + getclick.children[1].innerHTML);
}

function updateChkReturn() {
	if(value.readyState == 4 && value.status == 200) {		
		var data = value.responseText;
		var chkResult = document.getElementById("chk_result");
		chkResult.innerHTML = data;
	}
}

function checkForm() {
	var chk = document.getElementsByName("selectedchk");
	if(chk[0].value == "대출중") {
		if(confirm("현재 이 책은 대출중입니다. 그럼에도 삭제 하시겠습니까?")) {
			return true;
		} else {
			return false;
		}
	} else if(chk[0].value == "대출없음") {
		return true;
	} else {
		return false;
	}
}
function logout() {
	if(confirm("로그아웃 하시겠습니까?")){
		window.open("logoutAction.jsp", "_self");
	}
}
</script>
</head>
<body>
<%
	String id = (String) session.getAttribute("id");
	String admin = (String) session.getAttribute("admin");
	
	if(id==null){
		out.println("<script>alert('로그아웃 되었습니다.')</script>");
		out.println("<script>window.open('index.html','_self')</script>");
	}
	else if(!admin.equals("1")){
		out.println("<script>alert('접근이 허용되지 않은 이용자입니다.')</script>");
		out.println("<script>window.open('index.html','_self')</script>");
	}
%>
<header>
	<img src="image/logo_transparent_light.png" height="60" alt="LIVE-RARY" onclick="window.open('librarianMain.jsp','_self')">
	<form action="bookSearch.jsp">
		<input type="text" name="searchValue" placeholder="도서 이름 입력">
		<input type="submit" value="검색">
	</form>
	<nav>
		<a href="myPage.jsp"><%= id %> 님(사서)</a>
			<span onclick="logout()" style="margin-left:20px">로그아웃</span>
	</nav>
</header>
<section class="centerSection">
	<h2>책 삭제하기</h2>
	<form style="width:300px;margin:auto;">
		<label>책 이름<input type="text" id="bookname" placeholder="책 이름 입력">
		<input type="button" value="검색" onclick="searchBook()"></label>
	</form>
	<section id="search_list"></section><br>
	<form method="post" action="bkdeleteAction.jsp" onsubmit="return checkForm();" style="width:300px;margin:auto;">
		<fieldset id="chk_result">
			<label id="selected"><input style="border-color:transparent; background-color:transparent;"	name="selectedBook"></label>
			<label><input style="border-color:transparent; background-color:transparent;" name="selectedBookinfo"></label>
			<label><input style="border-color:transparent; background-color:transparent;" name="selectedchk"></label>
		</fieldset><br><br>
		<input type="submit" value="책 삭제">
	</form>
</section>
<footer>
<img src="image/kongju_logo.png" height="50" alt="LIVE-RARY">
<nav style="font-size:13px;margin-left:50px;text-align:left;">
	<span style="margin-right:5px;font-weight:550">Developer</span><br>
	<span>201801743 김규빈</span><br>
	<span>201801828 홍상혁</span><br>
	<span>202001834 진민주</span><br>
</nav>
</footer>
</body>
</html>