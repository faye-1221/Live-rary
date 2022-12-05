<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%-- 책 제거 --%>
<%
	String userid = request.getParameter("userid");
	String bookid = request.getParameter("bookid");
	String bookname = request.getParameter("bookname");
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String getid = null;
	String getbook = null;

	try {
		String driverName="com.mysql.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
		//InitialContext ctx = new InitialContext();
		//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		//Connection con = ds.getConnection();
		String sql = "delete from check_out where user_id = ? and book_id = ?";
	
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userid);
		pstmt.setString(2, bookid);
		int deleteresult = pstmt.executeUpdate();
		pstmt.close();
		
		if(deleteresult == 1) {
			sql = "select * from reservation where book_name = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bookname);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				sql = "update reservation set priorities = priorities - 1 where book_name = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, bookname);
				int updateresult = pstmt.executeUpdate();
				
				/*
				sql = "select * from reservation where priorities = 0";
				pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					getid = rs.getString("user_id");
					getbook = rs.getString("book_name");
				}
				
				sql = "delete from reservation where priorities = 0";
				pstmt = con.prepareStatement(sql);
				deleteresult = pstmt.executeUpdate();
				
				sql = "insert into book_alarm(user_id, book_name) values(?, ?)";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userid);
				pstmt.setString(2, bookname);
				int rs2 = pstmt.executeUpdate();
				*/
			}			
		}
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage());
		e.printStackTrace();
	} finally {
		if(pstmt != null)pstmt.close();
		if(con != null)con.close();
	}
	
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
<table>
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