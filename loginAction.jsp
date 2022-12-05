<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	PreparedStatement pstmt = null;
	String driverName="com.mysql.cj.jdbc.Driver";
	String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
	try {
		Class.forName(driverName);
		Connection con = DriverManager.getConnection(dbURL, "liverary", "4321");
		
		//InitialContext ctx = new InitialContext();
		//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		//Connection con = ds.getConnection();
		String sql = null;
		int updateCount = 0;
		sql = "select * from user where id like ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, id);
		ResultSet result = pstmt.executeQuery();
		if(result.next() == true){
			if(password.equals(result.getString("password"))){
				session.setAttribute("id", id);
				session.setAttribute("admin", result.getString("admin"));
				if(result.getString("admin").equals("1"))
					out.println("<script>window.open('librarianMain.jsp', '_self')</script>");
				else
					out.println("<script>window.open('userMain.jsp', '_self')</script>");
			}
			out.println("<script>alert('아이디 혹은 비밀번호가 잘못되었습니다.');</script>");
			out.println("<script>window.open('index.html', '_self')</script>");
		}
		else {
			out.println("<script>alert('아이디가 존재하지 않습니다.');</script>");
			out.println("<script>window.open('index.html', '_self')</script>");
		}
		con.close();
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage()+"<br>");
		e.printStackTrace();
	}
	
%>
</body>
</html>