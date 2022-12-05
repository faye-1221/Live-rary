<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%-- 대출한 책 찾기 --%>
<%
String bookid = request.getParameter("bookid");
String bookname = request.getParameter("bookname");
Connection con = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String resultOk = null;

try {
	String driverName="com.mysql.jdbc.Driver";
	String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
	Class.forName(driverName);
	con = DriverManager.getConnection(dbURL, "liverary", "4321");

	//InitialContext ctx = new InitialContext();
	//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
	//Connection con = ds.getConnection();
	String sql = "select * from check_out where book_id = ?";

	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, bookid);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
		resultOk = "대출중";
	} else {
		resultOk = "대출없음";
	}
	bookname = bookname.replaceAll(" ", "&nbsp;");
	con.close();
} catch(Exception e){
	out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
	out.println(e.getMessage()+"<br>");
	e.printStackTrace();
}
%>
<label>선택한 책<input type="text" name="selectedBook" value=<%=bookid%>></label>
<label><input type="text" name="selectedBookinfo" value=<%=bookname%>></label>
<label>현재 대출상황<input type="text" name="selectedchk" value=<%=resultOk%>></label>
</body>
</html>