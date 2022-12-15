<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page trimDirectiveWhitespaces="true" %>
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
<legend>도서 정보</legend>
<table style="width:460px;table-layout:fixed;">
	<tHead style="background-color:black;margin-top:0px;margin-bottom:0px;">
		<tr><th style="width:80px;">도서 ID</th><th>도서 이름</th></tr>
	</tHead>
	<tBody id="chkList">
<%-- 책 찾기 --%>
<%
	String bookname = request.getParameter("bookname");
	bookname = "%" + bookname +"%";
	Connection con = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	PreparedStatement pstmt3 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;
	String resultid = null;
	String resultname = null;
	String resultOk = null;

	try {
		String driverName="com.mysql.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
		//InitialContext ctx = new InitialContext();
		//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		//Connection con = ds.getConnection();
		String sql = "select * from book where 서명 Like ?";
	
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, bookname);
		rs = pstmt.executeQuery();
		
		while(rs.next()){
			resultid = rs.getString("등록번호");
			resultname = rs.getString("서명");
			//resultname=resultname.replaceAll(" ", "&nbsp;");
			//resultOk = resultOk.replaceAll(" ", "&nbsp;");
%>		
		<tr onclick="selectedbook()">
			<td><%= resultid %></td>
			<td><%= resultname %></td>
		</tr>
<%
		}
		rs.close();
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage());
		e.printStackTrace();
	} finally {
		//if(rs != null)rs.close();
		//if(rs2 != null)rs2.close();
		//if(rs3 != null)rs3.close();
		if(pstmt != null)pstmt.close();
		if(pstmt2 != null)pstmt2.close();
		if(pstmt3 != null)pstmt3.close();
		if(con != null)con.close();
	}
%>
</tBody>
</table>
</body>
</html>