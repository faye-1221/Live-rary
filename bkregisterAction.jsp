<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 등록</title>
<link type="text/css" rel="stylesheet" href="defaultStyle.css">
<style>
body{
	background-image:url('image/main_bg.jpg');
	background-size : cover;
}
.centerSection {
	margin-top:100px;
	text-align:center;
	padding:10px;
	width:300px;
}
</style>
</head>
<body>
<%@ page import="java.sql.*" %>
<header>
	<img src="image/logo_transparent_light.png" height="60" alt="LIVE-RARY" onclick="window.open('userMain.html','_self')">
	<nav>
		<span onclick="window.open('index.html', '_self')">로그인 페이지</span>
	</nav>
</header>
<section class="centerSection">
<%
	request.setCharacterEncoding("utf-8");
	String bookid = request.getParameter("bookID");
	String bookName = request.getParameter("bookName");
	String author = request.getParameter("author");
	String publisher = request.getParameter("publisher");
	int publishYear = Integer.parseInt(request.getParameter("publishYear"));
	String bookLocation = request.getParameter("bookLocation");
	String rfroom = request.getParameter("rfRoom");
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try {
		String driverName="com.mysql.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		Connection con = DriverManager.getConnection(dbURL, "liverary", "4321");
		String sql = "select * from book where 등록번호 = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, bookid);
		rs = pstmt.executeQuery();
		
		if(rs.next()) {
			out.println("키값이 중복됩니다.<br>");		
		} else {
			sql = "insert into book(등록번호, 서명, 저자, 출판사, 출판년, 청구기호, 자료실) values(?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bookid);
			pstmt.setString(2, bookName);
			pstmt.setString(3, author);
			pstmt.setString(4, publisher);
			pstmt.setInt(5, publishYear);
			pstmt.setString(6, bookLocation);
			pstmt.setString(7, rfroom);
			int insertnum = pstmt.executeUpdate();
			if(insertnum == 1) {
				out.println("<h2 id='result'>신규 도서가 등록 되었습니다.</h2>");
				out.println("등록번호 : " + bookid + "<br>");
				out.println("서명 : " + bookName + "<br>");
				out.println("저자 : " + author + "<br>");
				out.println("출판사 : " + publisher + "<br>");
				out.println("출판년 : " + Integer.toString(publishYear) + "<br>");
				out.println("청구기호 : " + bookLocation + "<br>");
				out.println("자료실 : " + rfroom + "<br><br>");
			}	
		}
		con.close();
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage()+"<br>");
		e.printStackTrace();
	}
%>
<input type="button" value="계속 등록하기" onclick="location.href='bookregister.jsp'" style="margin-top:100px;padding:12px;width:100%;">
</section>
</body>
</html>