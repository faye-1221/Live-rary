<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
/* 캐싱 방지 (로그아웃 후 접근 차단) */
response.setHeader("Pragma", "no-cache"); 
response.setHeader("Cache-Control", "no-cache"); 
response.setHeader("Cache-Control", "no-store"); 
response.setDateHeader("Expires", 0L); 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link type="text/css" rel="stylesheet" href="defaultStyle.css">
<style>
.centerSection{
	margin-top:200px;
	padding:15px;
}
body{
	background-image:url('image/main_bg.jpg');
	background-size : cover;
}
</style>
</head>
<body>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<header>
	<img src="image/logo_transparent_light.png" height="60" alt="LIVE-RARY" onclick="window.open('index.html','_self')">
	<nav>
		<span onclick="window.open('index.html', '_self')">로그인 페이지</span>
	</nav>
</header>
<section class="centerSection">
<%
	request.setCharacterEncoding("utf-8");
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	String name = request.getParameter("name");
	String tel = request.getParameter("tel");
	
	/*
	UserManager um = new UserManager();
	if(password==null){
		if(um.isDuplicationId(id)){
			out.println("/결과/중복있음/결과/");
		}
		else {
			out.println("/결과/중복없음/결과/");
		}
	}
	else{
		if(um.signup(id, password, name, tel)){
			out.println("<h2 id='result'>회원가입이 완료되었습니다.</h2>");
		}
		else {
			out.println("<h2 id='result' style='color:red'>회원가입을 실패했습니다.</h2>");
		}
	}*/
	int menu = 0;
	if(password==null){
		menu=1;
	} else if(name==null){
		menu=2;
	} else {
		menu=3;
	}
	PreparedStatement pstmt = null;
	try {
		String driverName="com.mysql.cj.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		Connection con = DriverManager.getConnection(dbURL, "liverary", "4321");
		
		//InitialContext ctx = new InitialContext();
		//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		//Connection con = ds.getConnection();
		String sql = null;
		int updateCount = 0;
		switch(menu){
		case 1:
			sql = "select * from user where id like ?";

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			ResultSet result = pstmt.executeQuery();
			if(result.next() == true){
				out.println("/결과/중복있음/결과/");
			}
			else {
				out.println("/결과/중복없음/결과/");
			}
			break;
		case 2:
			sql = "delete from user where id=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			updateCount = pstmt.executeUpdate();
			if(updateCount==0){
				out.println("<h2 id='result'>오류가 발생했습니다.</h2>");
			}
			else {
				out.println("<h2 id='result'>회원 탈퇴가 완료되었습니다.</h2>");
			}
			break;
		case 3:
			sql = "insert into user (id, password, name, tel, admin) values (?, ?, ?, ?, 0)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, password);
			pstmt.setString(3, name);
			pstmt.setString(4, tel);
			updateCount = pstmt.executeUpdate();
			if(updateCount==0){
				out.println("<h2 id='result'>오류가 발생했습니다.</h2>");
			}
			else {
				out.println("<h2 id='result'>회원가입이 완료되었습니다.</h2>");
			}
			
			break;
		}
		con.close();
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage()+"<br>");
		e.printStackTrace();
	}
%>
<input type="button" value="로그인" onclick="window.open('index.html', '_self')" style="margin-top:50px;width:100%;padding:12px;font-size:20px;">
</section>
</body>
</html>