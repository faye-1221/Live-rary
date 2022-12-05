<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link type="text/css" rel="stylesheet" href="defaultStyle.css">
<style>
#resultSection{
	background-color: #fefaec;
	border-radius: 5px;
	position: relative;
	text-align: center;
	width: 500px;
	margin-top: 270px;
	left: 50%;
	transform: translate(-50%, -50%);
}
</style>
</head>
<body>
<section id="resultSection">
<%
	request.setCharacterEncoding("UTF-8");
%>
<%-- 책 제거 --%>
<%
	String bookid = request.getParameter("selectedBook");
	String bookname = request.getParameter("selectedBookinfo");
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String getid = null;
	String getbook = null;
	int deleteresult = 0;

	try {
		String driverName="com.mysql.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
		String sql = "delete from book where 등록번호 = ?";
	
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, bookid);
		deleteresult = pstmt.executeUpdate();
		pstmt.close();
		
		if(deleteresult == 1) {
			out.println("정상적으로 삭제 되었습니다.");
			sql = "delete from check_out where book_id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bookid);
			deleteresult = pstmt.executeUpdate();
			
			sql = "delete from reservation where book_name = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bookname);
			deleteresult = pstmt.executeUpdate();
			
		} else {
			out.println("문제가 생겼습니다.");
		}
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage());
		e.printStackTrace();
	} finally {
		if(pstmt != null)pstmt.close();
		if(con != null)con.close();
	}
		
%>
<br>
<input type="button" value="계속 삭제하기" onclick="location.href='bookdelete.jsp'" style="margin-top:100px;padding:12px;width:100%;">
</section>
</body>
</html>