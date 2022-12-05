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
<link type="text/css" rel="stylesheet" href="defaultStyle.css?ver=1">
<style>
.centerSection form {
	width:350px; /* 폼 크기 */
}
form label.error {
	width:262px; /* 텍스트박스 크기 + 12 */
}
h2 {
	margin-bottom:0px;
}
section input[type="text"] {
	width:250px; /* 텍스트박스 크기 */
}
section input[type="submit"] {
	padding:12px;
	font-size:15px;
	font-weight:bold;
	width:100%;
}
</style>
<script>
var num = /[0-9]/;
var eng = /[a-zA-Z]/;
var spc = /[~!@#$%^&*()_+|<>?:{}]/;
var kor = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;

var bookidchk = false;
var booknamechk = false;
var authorcheck = false;
var publisherchk = false;
var publishyearchk = false;
var booklocachk = false;
var rfroomchk = false;

function checkblank(testinput) {
	var chkstr = ("error" + testinput.getAttribute('name'));
	var errormessage = document.getElementById(chkstr);
	if(testinput.value=="") {
		errormessage.style.color = "red";
		errormessage.innerHTML = "빈 칸을 채우세요.";
		switch(chkstr) {
		case "errorbookID":
			bookidchk = false;
			break;
		case "errorbookName":
			booknamechk = false;
			break;
		case "errorauthor":
			authorcheck = false;
			break;
		case "errorpublisher":
			publisherchk = false;
			break;
		case "errorbookLocation":
			booklocachk = false;
			break;
		case "errorrfRoom":
			rfroomchk = false;
			break;
		default:
			break;
		}
	} else {
		errormessage.style.color = "green";
		errormessage.innerHTML = "확인";
		switch(chkstr) {
		case "errorbookID":
			bookidchk = true;
			break;
		case "errorbookName":
			booknamechk = true;
			break;
		case "errorauthor":
			authorcheck = true;
			break;
		case "errorpublisher":
			publisherchk = true;
			break;
		case "errorbookLocation":
			booklocachk = true;
			break;
		case "errorrfRoom":
			rfroomchk = true;
			break;
		default:
			break;
		}
	}
}

function checkNum(testinput) {
	var errormessage = document.getElementById("errorpublishYear");
	if(num.test(testinput.value) && !kor.test(testinput.value) && !eng.test(testinput.value) && !spc.test(testinput.value)){
		if(testinput.value.length == 4) {
			errormessage.style.color = "green";
			errormessage.innerHTML = "확인";
			publishyearchk = true;
		} else {
			errormessage.style.color = "red";
			errormessage.innerHTML = "4자리를 입력해주세요";
			publishyearchk = false;
		}
	} else {
		errormessage.style.color = "red";
		errormessage.innerHTML = "숫자만 입력하세요.";
		publishyearchk = false;
	}
	if(testinput.value=="") {
		errormessage.style.color = "red";
		errormessage.innerHTML = "빈 칸을 채우세요.";
		publishyearchk = false;
	}
}

function checkForm() {
	if(bookidchk && booknamechk && authorcheck && publisherchk && publishyearchk && booklocachk && rfroomchk){
		if(confirm("도서를 등록 하시겠습니까?")){
		    return true;
		} else {
		    return false;
		}
	}
	else {
		if(!bookidchk){
			alert("도서 아이디를 입력해주세요.");
		}
		else if(!booknamechk){
			alert("도서 이름을 입력해주세요.");
		}
		else if(!authorcheck){
			alert("저자를 입력해주세요.");
		}
		else if(!publisherchk){
			alert("출판사를 입력해주세요.");
		}
		else if(!publishyearchk){
			alert("출판년도를 입력해주세요.");
		}
		else if(!booklocachk){
			alert("청구기호를 입력해주세요.");
		}
		else if(!rfroomchk){
			alert("자료실을 입력해주세요.");
		}
		
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
		<h2>도서 등록</h2>
		<form method="post" action="bkregisterAction.jsp" onsubmit="return checkForm();">
			<fieldset>
				<legend>신규 도서 정보</legend>
				<span id = "userResult">
				<label>도서 ID<input type="text" name="bookID" onkeyup="checkblank(this)"></label>
				<label id="errorbookID" class="error"></label>
				<label>도서 이름<input type="text" name="bookName" onkeyup="checkblank(this)"></label>
				<label id="errorbookName" class="error"></label>
				<label>저자<input type="text"  name="author" onkeyup="checkblank(this)"></label>
				<label id="errorauthor" class="error"></label>
				<label>출판사<input type="text" name="publisher" onkeyup="checkblank(this)"></label>
				<label id="errorpublisher" class="error"></label>
				<label>출판년도<input type="text" name="publishYear" size="4" onkeyup="checkNum(this)"></label>
				<label id="errorpublishYear" class="error"></label>
				<label>청구기호<input type="text" name="bookLocation" onkeyup="checkblank(this)"></label>
				<label id="errorbookLocation" class="error"></label>
				<label>자료실<input type="text" name="rfRoom" onkeyup="checkblank(this)"></label>
				<label id="errorrfRoom" class="error"></label><br>
				</span>
				<input type="submit" value="도서 등록">
			</fieldset>
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