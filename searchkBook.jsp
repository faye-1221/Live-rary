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

<%-- 책 찾기 --%>
<%
	String bookid = request.getParameter("bookid");
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
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
		String sql = "select * from book where 등록번호 = ?";
	
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, bookid);
		rs = pstmt.executeQuery();
		
		if(rs.next()){
			resultid = rs.getString("등록번호");
			resultname = rs.getString("서명");
			sql = "select * from check_out where book_id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, resultid);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				resultOk = "N";
			} else {
				sql = "select * from reservation where book_name = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, resultname);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					resultOk = "N";
				} else {
					sql = "select * from book_alarm where book_name = ?";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, resultname);
					rs = pstmt.executeQuery();
					if(rs.next()) {
						resultOk = "N";
					} else {
						resultOk = "Y";	
					}
				}
			}
			resultid = resultid.replaceAll(" ", "&nbsp;");
			resultname = resultname.replaceAll(" ", "&nbsp;");
			resultOk = resultOk.replaceAll(" ", "&nbsp;");
		}
		else {
			resultid = "결과없음";
			resultname = "결과없음";
			resultOk = "결과없음";
		}
		 
		con.close();
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage()+"<br>");
		e.printStackTrace();
	}
%>
<legend>도서 정보</legend>
<label id="bookKey">번호<input type="text" name="bookid" value=<%=resultid%>></label>
<label id="bookName">이름<input type="text" name="bookname" value=<%=resultname%>></label>
<label id="bookOkay">대출가능<input type="text" name="bookOk" value=<%=resultOk%>></label><br>
</body>
</html>