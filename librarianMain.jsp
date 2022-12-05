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
<title>사서 메인 - LIVE-RARY</title>
<link type="text/css" rel="stylesheet" href="defaultStyle.css?ver=0">
<style>
.centerSection{
	flex-direction:row;
	justify-content:space-between;
	background-color:transparent;
}
.centerSection section {
	margin:5px;
	padding:5px;
}
.strech {
	padding:5px;
}
#inputSection1{
	width: 320px; /* 각 폼(대출,반납)의 넓이 조절*/
	background-color: #fefaec;
	border-radius: 5px;
}

#inputSection2{
	width: 860px; /* 각 폼(대출,반납)의 넓이 조절*/
	background-color: #fefaec;
	border-radius: 5px;
}

#buttonSection{
	width: 220px; /* 각 폼(대출,반납)의 넓이 조절*/
	background-color: #fefaec;
	border-radius: 5px;
	padding:5px;
}
#buttonSection input{
	padding:12px;
	width:auto;
	margin:10px;
	font-size:15px;
	font-weight:bold;
}
#search_list{
	margin:0px;
	padding:0px;
}
#userResult input[type="text"], #bookResult input[type="text"]{
	width:170px;
	background-color:transparent;
	border-radius: 0px;
	border-top-width:0;
	border-left-width:0;
	border-right-width:0;
	border-bottom-width:1;
}
body{
	min-width:1470px;
	text-align:left;
}
form legend {
	padding-top:20px;
	margin-left:-5px;
}
section input[type="submit"] {
	margin-top:100px;
	padding:12px;
	font-size:15px;
	font-weight:bold;
	width:100%;
}
table {
	width:830px;
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

function searchCheckUser() {
	var userid = document.getElementById("searchuserID").value;
	var url = "searchkUser.jsp";
	createRequest();
	value.open('POST', url, true);
	value.onreadystatechange = updateUser;
	value.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	value.send("userid=" + userid);
}

function searchCheckBook() {
	var bookid = document.getElementById("searchbookKey").value;
	var url = "searchkBook.jsp";
	createRequest();
	value.open('POST', url, true);
	value.onreadystatechange = updateBook;
	value.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	value.send("bookid=" + bookid);
}

function updateUser() {
	if(value.readyState == 4 && value.status == 200) {
		var data = value.responseText;
		var searchResult = document.getElementById("userResult");
		searchResult.innerHTML = data;
	}
}

function updateBook() {
	if(value.readyState == 4 && value.status == 200) {
		var data = value.responseText;
		var searchResult = document.getElementById("bookResult");
		searchResult.innerHTML = data;
	}
}

function searchOutUser() {
	var userid = document.getElementById("searchuserID2").value;
	var url = "searchrtUser.jsp";
	createRequest();
	value.open('POST', url, true);
	value.onreadystatechange = updateSearchReturn;
	value.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	value.send("userid=" + userid);
}

function updateSearchReturn() {
	console.log(value.readyState);
	if(value.readyState == 4 && value.status == 200) {		
		var data = value.responseText;
		var searchResult = document.getElementById("search_list");
		searchResult.innerHTML = data;
	}
}

var row_count = 0;
function returnbook() {
	var getclick = event.currentTarget;
	console.log(getclick.children[0]);
	var userid = getclick.children[0].innerHTML;
	var bookid = getclick.children[2].innerHTML;
	var bookname = getclick.children[3].innerHTML;
	var sTable = document.getElementById('chkList');
	row_count = sTable.rows.length;
	console.log(row_count);

	if(confirm(getclick.children[1].innerHTML+"님이 " + getclick.children[3].innerHTML.replaceAll("&nbsp;", " ")+"(을)를 반납합니다. 맞습니까? ")) {
		var url = "returnbook.jsp";
		createRequest();
		value.open('POST', url, true);
		value.onreadystatechange = updateReturn;
		value.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		value.send("userid=" + userid + "&bookid=" + bookid + "&bookname=" + bookname);
	} else {
		alert("반납을 취소하셨습니다.")
	}
}

function updateReturn() {
	console.log(value.readyState);
	if(value.readyState == 4 && value.status == 200) {		
		var data = value.responseText;
		var searchResult = document.getElementById("search_list");
		searchResult.innerHTML = data;
		var rowResult = document.getElementById("chkList");
		if(row_count == rowResult.rows.length + 1) {
			alert("반납에 성공하였습니다.");
		} else {
			alert("반납에 실패하셨습니다.")
		}
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
	<section id="inputSection1">
		<h2>대출</h2>
		<form method="post" action="checkOut.jsp">
			<fieldset>
				<label>대출자 ID<input type="text" id="searchuserID" placeholder="대출자 아이디 입력">
				<input type="button" value="검색" onclick="searchCheckUser()"></label>
				<label>도서 번호<input type="text" id="searchbookKey" placeholder="도서 번호 입력">
				<input type="button" value="검색" onclick="searchCheckBook()"></label>
			</fieldset>
			<fieldset id="userResult">
				<legend>대출자 정보</legend>
				<label>아이디<input type="text" name="userid" readonly></label>
				<label>이름<input type="text" name="username" readonly></label>
				<label>전화번호<input type="text" name="userHP" readonly></label>
				<label>대출 가능 여부<input type="text" name="userOk" readonly></label>
			</fieldset>
			<fieldset id="bookResult">
				<legend>도서 정보</legend>
				<label>번호<input type="text" name="bookid" readonly></label>
				<label>이름<input type="text" name="bookname" readonly></label>
				<label>대출가능<input type="text" name="bookOk" readonly></label><br>
			</fieldset>
			<input type="submit" value="대출 승인">
		</form>
	</section>
		
	<section id="inputSection2">
		<h2>반납</h2>
		<form>
			대출자 ID <input type="text" id="searchuserID2" placeholder="사용자 아이디 입력">
			<input type="button" value="검색" onclick="searchOutUser()"><br>
			<section id="search_list"></section>
		</form>
	</section>
	<section id="buttonSection">
		<h2>도서 목록 관리</h2>
		<span class="strech"><input type="button" value="신규 도서 등록" onclick="location.href='bookregister.jsp'">
		<input type="button" value="도서 삭제" onclick="location.href='bookdelete.jsp'"></span>
	</section>
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