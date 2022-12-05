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
	request.setCharacterEncoding("utf-8");
	String bookname = request.getParameter("bookname");
	String searchvalue = ("%" + bookname + "%");
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {
		String driverName="com.mysql.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
		//InitialContext ctx = new InitialContext();
		//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		//Connection con = ds.getConnection();
		String sql = "select * from book where 서명 like ?";
	
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, searchvalue);
		rs = pstmt.executeQuery();
		
%>
<body>
<table>
	<tHead>
		<tr><th>책ID</th><th>책명</th><th>저자</th><th>출판사</th><th>출판년도</th><th>청구기호</th></tr>
	</tHead>
	<tBody id="chkList">
<%
		while(rs.next()){
%>
		<tr onclick="selectBook()">
			<td><%= rs.getString("등록번호") %></td>
			<td><%= rs.getString("서명") %></td>
			<td><%= rs.getString("저자") %></td>
			<td><%= rs.getString("출판사") %></td>
			<td><%= rs.getString("출판년") %></td>
			<td><%= rs.getString("청구기호") %></td>
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