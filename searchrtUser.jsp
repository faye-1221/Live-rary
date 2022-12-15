<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%-- 책 찾기 --%>
<%
	String userid = request.getParameter("userid");
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String resultid = null;
	String resultname = null;
	String resultHP = null;

	try {
		String driverName="com.mysql.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
		//InitialContext ctx = new InitialContext();
		//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		//Connection con = ds.getConnection();
		String sql = "select * from check_out where user_id = ?";
	
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userid);
		rs = pstmt.executeQuery();
		
%>
<body>
<table style="width:830px">
	<tHead>
		<tr><th>유저ID</th><th>유저이름</th><th>책번호</th><th>책명</th></tr>
	</tHead>
	<tBody id="chkList">
<%
		while(rs.next()){
%>
		<tr onclick="returnbook()">
			<td><%= rs.getString("user_id") %></td>
			<td><%= rs.getString("user_name") %></td>
			<td><%= rs.getString("book_id") %></td>
			<td><%= rs.getString("book_name") %></td>
		</tr>
<%
		}
		rs.close();
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage());
		e.printStackTrace();
	} finally {
		if(pstmt != null)pstmt.close();
		if(con != null)con.close();
	}
%>
	</tBody>
</table>
</body>
</html>