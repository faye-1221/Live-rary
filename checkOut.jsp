<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대출</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
%>
<%
	String userid = request.getParameter("userid");
	String username = request.getParameter("username");
	String userok = request.getParameter("userOk");
	String bookid = request.getParameter("bookid");
	String bookname = request.getParameter("bookname");
	String bookok = request.getParameter("bookOk");
	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sf.format(nowTime);
	Calendar week = Calendar.getInstance();
	week.add(Calendar.DATE, 14);
	String returnday = new java.text.SimpleDateFormat("yyyy-MM-dd").format(week.getTime());
	Connection con = null;
	PreparedStatement pstmt = null;
	String sql = null;

	if(bookok.equals("N")) {
		try {
			String driverName="com.mysql.jdbc.Driver";
			String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
			Class.forName(driverName);
			con = DriverManager.getConnection(dbURL, "liverary", "4321");
			sql = "delete from reservation where user_id = ? and book_name = ? and priorities <= 0";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, bookname);
			int deleteresult = pstmt.executeUpdate();
			if(deleteresult > 0) {
				bookok = "Y";
			}
			con.close();
		} catch(Exception e){
			out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
			out.println(e.getMessage()+"<br>");
			e.printStackTrace();
		}	
	} 
	
	if(bookok.equals("Y") && userok.equals("Y")) {
		try {
			String driverName="com.mysql.jdbc.Driver";
			String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
			Class.forName(driverName);
			con = DriverManager.getConnection(dbURL, "liverary", "4321");
			sql = "insert into check_out(user_id, user_name, book_id, book_name, chk_date, rtn_date, chk_extend) values(?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, username);
			pstmt.setString(3, bookid);
			pstmt.setString(4, bookname);
			pstmt.setString(5, today);
			pstmt.setString(6, returnday);
			pstmt.setString(7, "Y");
			int rs = pstmt.executeUpdate();

			out.println("<script>alert('대출이 완료되었습니다.');</script>");
			out.println("<script>window.open('librarianMain.jsp', '_self')</script>");
			con.close();
		} catch(Exception e){
			out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
			out.println(e.getMessage()+"<br>");
			e.printStackTrace();
		}
	} else {
		out.println("<script>alert('대출이 불가합니다');</script>");
		out.println("<script>window.open('librarianMain.jsp', '_self')</script>");
	}

%>
</body>
</html>