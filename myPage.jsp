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
<title>마이 페이지 - LIVE-RARY</title>
<link type="text/css" rel="stylesheet" href="signupStyle.css?ver=3">
<style>
body::before {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
	background-image:url(image/main_bg.jpg);
    background-size: cover;
    -webkit-filter: blur(5px); 
    -moz-filter: blur(5px); 
    -o-filter: blur(5px); 
    -ms-filter: blur(5px); 
    filter: blur(5px);
    transform: scale(1.02);
    z-index: -1;
    content: "";
}
.strech {
	display:flex;
	justify-content:space-between;
}
#infoSection{
	position: relative;
	display:flex;
	justify-content:space-between;
	margin:20px auto 20px;
}
.inputSection{
	background-color: #fefaec;
	border-radius: 5px;
	padding:7px;
	margin:5px;
}
section form{
	text-align:left;
	width: 300px;/* 각 폼(대출,반납)의 넓이 조절 */
	color:#625772;
	margin-top:15px;
	padding:10px;
}
input[type="submit"] {
	font-size:20px;
	font-weight:bold;
}
</style>
<script>
function onlyAlphabet(ele) {
	ele.value = ele.value.replace(/[^\\!-z]/gi,"");
}
function onlyNumber(ele) {
	ele.value = ele.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
}
function deleteUser(form) {
	if(!checkBlank("pw", "pwLabel")) {
		alert("비밀번호를 입력해야 회원 탈퇴가 가능합니다.");
		return;
	}
	if(!confirm("회원을 탈퇴하시겠습니까?")){
		return;
	}
	var input = document.createElement('input');
	input.setAttribute("type", "hidden");
	input.setAttribute("name", "menu");
	input.setAttribute("value", "1");
	
	form.appendChild(input);
	form.setAttribute("action", "myPage.jsp");
	form.submit();
}
function editUser(form) {
	if(!checkAll(1)) {
		alert("입력되지 않았거나 잘못 입력된 값이 있습니다.");
		return;
	}
	if(!confirm("회원 정보를 입력한 정보로 수정하시겠습니까?")){
		return;
	}
	var input = document.createElement('input');
	input.setAttribute("type", "hidden");
	input.setAttribute("name", "menu");
	input.setAttribute("value", "2");
	
	form.appendChild(input);
	form.setAttribute("action", "myPage.jsp");
	form.submit();
}
function editPW(form) {
	if(!checkAll(2)) {
		alert("입력되지 않았거나 잘못 입력된 값이 있습니다.");
		return;
	}
	if(!confirm("비밀번호를 입력한 정보로 수정하시겠습니까?")){
		return;
	}
	var input = document.createElement('input');
	input.setAttribute("type", "hidden");
	input.setAttribute("name", "menu");
	input.setAttribute("value", "3");
	
	form.appendChild(input);
	form.setAttribute("action", "myPage.jsp");
	form.submit();
}
function checkAll(val) {
	if(val==1){
		if(checkBlank("name", "nameLabel")&&checkBlank("tel", "telLabel")&&checkBlank("pw", "pwLabel")){
			return true;
		}
		else
			return false;
	}
	if(val==2){
		if(checkBlank("oldPW", "oldPWLabel")&&checkBlank("newPW", "newPWLabel")&&checkPWequal()){
			return true;
		}
		else
			return false;
	}
}
function checkBlank(inputName, labelName) {
	var input = document.getElementById(inputName);
	if(input.value==""){
		var label = document.getElementById(labelName);
		label.innerHTML = "비워둘 수 없습니다.";
		label.style.color = "red";
		return false;
	}
	else{
		var label = document.getElementById(labelName);
		label.innerHTML = "";
		label.style.color = "green";
		return true;
	}
}
function checkPWequal() {
	var newPW = document.getElementById("newPW");
	var newPWCheck = document.getElementById("newPWCheck");
	if(newPW.value==""){
		var label = document.getElementById("newPWCheckLabel");
		return false;
	}
	else if(newPW.value==newPWCheck.value){
		var label = document.getElementById("newPWCheckLabel");
		label.innerHTML = "비밀번호가 일치합니다.";
		label.style.color = "green";
		return true;
	}
	else {
		var label = document.getElementById("newPWCheckLabel");
		label.innerHTML = "비밀번호가 일치하지 않습니다.";
		label.style.color = "red";
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
	boolean isAdmin = false;
	
	if(id==null){
		out.println("<script>alert('로그아웃 되었습니다.')</script>");
		out.println("<script>window.open('index.html','_self')</script>");
	}
	else if(admin.equals("1")){
		isAdmin = true;
	}
	
%>
<header>
	<img src="image/logo_transparent_light.png" height="60" alt="LIVE-RARY" onclick="window.open('<%= isAdmin ? "librarianMain.jsp":"userMain.jsp" %>', '_self');">
	<h2 style="margin-left:-80px">마이 페이지</h2>
	<nav>
		<span onclick="logout()" style="margin-left:20px">로그아웃</span>
	</nav>
</header>
<%@ page import="java.sql.*" %>
<%! String dbName; String dbTel; %>
<%
	request.setCharacterEncoding("utf-8");
	String password = (String) request.getParameter("password");
	String newPassword = (String) request.getParameter("newPassword");
	String name = (String) request.getParameter("name");
	String tel = (String) request.getParameter("tel");
	String m = (String) request.getParameter("menu");

	int menu = 0;
	if(m==null){
		menu=0;
	} else if(m.equals("1")){
		menu=1;
	} else if(m.equals("2")){
		menu=2;
	} else if(m.equals("3")){
		menu=3;
	}
	PreparedStatement pstmt = null;
	Connection con = null;
	try {
		String driverName="com.mysql.cj.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");
		
		//InitialContext ctx = new InitialContext();
		//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		//Connection con = ds.getConnection();
		String sql = null;
		int updateCount = 0;
		sql = "select * from user where id like ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, id);
		ResultSet result = pstmt.executeQuery();
		String dbPassword = null;
		if(result.next() == true){
			dbPassword = result.getString("password");
			if(password!=null&&!password.equals(dbPassword)){
				menu = -1;
			}
			dbName = result.getString("name");
			dbTel = result.getString("tel");
		}
		else {
			out.println("<script>alert('데이터를 읽어오는데 실패했습니다. 로그인 화면으로 돌아갑니다.')</script>");
			out.println("<script>window.open('index.html', '_self')</script>");
		}
		if(pstmt != null)pstmt.close();
		switch(menu){
		case 1:
			sql = "delete from user where id like ?";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			updateCount = pstmt.executeUpdate();
			if(updateCount==0){
				out.println("<script>alert('회원 탈퇴를 실패했습니다.')</script>");
			}
			else {
				out.println("<script>alert('회원 탈퇴를 완료했습니다.')</script>");
				out.println("<script>alert('로그인 화면으로 돌아갑니다.')</script>");
				out.println("<script>window.open('index.html', '_self')</script>");
			}
			break;
		case 2:
			sql = "update user set name=?, tel=? where id like ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, tel);
			pstmt.setString(3, id);
			updateCount = pstmt.executeUpdate();
			if(updateCount==0){
				out.println("<script>alert('오류가 발생하였습니다.')</script>");
			}
			else {
				out.println("<script>alert('회원 정보가 수정되었습니다.')</script>");
				dbName = name;
				dbTel = tel;
			}
			break;
		case 3:
			sql = "update user set password=? where id like ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, newPassword);
			pstmt.setString(2, id);
			updateCount = pstmt.executeUpdate();
			if(updateCount==0){
				out.println("<script>alert('오류가 발생하셨습니다.')</script>");
			}
			else {
				out.println("<script>alert('비밀번호가 수정되었습니다.')</script>");
			}
			break;
		case -1:
			if(newPassword==null){
				out.println("<script>alert('비밀번호가 잘못되었습니다.')</script>");
			} else {
				out.println("<script>alert('기존 비밀번호가 잘못되었습니다.')</script>");
			}
			break;
		}
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage()+"<br>");
		e.printStackTrace();
	} finally {
		if(pstmt != null)pstmt.close();
		if(con != null)con.close();
	}
%>
<section id="infoSection">
<section class="inputSection">
<h2>회원 정보 수정</h2>
<form method="post">
<fieldset>
	<label>아이디<input type="text" id="userID" name="id" readonly value="<%= id %>"></label><br>
	<label>이름<input type="text" name="name" id="name" maxlength="15" placeholder="홍길동" value="<%= dbName %>" onblur="checkBlank(this.id, 'nameLabel')"></label>
	<label id="nameLabel" class="error"></label>
	<label>전화번호<input type="text" name="tel" id="tel" maxlength="11" placeholder="01012345678" value="<%= dbTel %>" oninput="onlyNumber(this)" onblur="checkBlank(this.id, 'telLabel')"></label>
	<label id="telLabel" class="error"></label>
	<label>비밀번호 확인<input type="password" id="pw" name="password" maxlength="24" oninput="onlyAlphabet(this)" onblur="checkBlank(this.id, 'pwLabel')"></label>
	<label id="pwLabel" class="error"></label><br>
	<div class="strech">
	<input type="button" value="회원 탈퇴" onclick="deleteUser(this.form)" style="width:49%">
	<input type="button" value="회원정보 수정" onclick="editUser(this.form)" style="width:49%"></div>
</fieldset>
</form>
</section>

<section class="inputSection">
<h2>비밀번호 변경</h2>
<form method="post">
<fieldset>
	<label>기존 비밀번호<input type="password" id="oldPW" name="password" maxlength="24" oninput="onlyAlphabet(this)" onblur="checkBlank(this.id, 'oldPWLabel')"></label>
	<label id="oldPWLabel" class="error"></label>
	<label>비밀번호<input type="password" id="newPW" name="newPassword" maxlength="24" oninput="onlyAlphabet(this)" onblur="checkBlank(this.id, 'newPWLabel')"></label>
	<label id="newPWLabel" class="error"></label>
	<label>비밀번호 확인<input type="password" id="newPWCheck" maxlength="24" oninput="onlyAlphabet(this)" onblur="checkPWequal()"></label>
	<label id="newPWCheckLabel" class="error"></label>
	<input type="button" value="비밀번호 변경" onclick="editPW(this.form)" style="width:100%;margin-top:75px"><br>
</fieldset>
</form>
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