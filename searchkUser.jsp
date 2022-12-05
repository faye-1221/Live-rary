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
<%!
	String resultOk = null;
%>

<%-- 유저 찾기 --%>
<%
	String userid = request.getParameter("userid");
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String resultid = null;
	String resultname = null;
	String resultHP = null;
	int getrow = 0;

	try {
		String driverName="com.mysql.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
		//InitialContext ctx = new InitialContext();
		//DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		//Connection con = ds.getConnection();
		String sql = "select * from user where id = ?";
	
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userid);
		rs = pstmt.executeQuery();
		

		if(rs.next()){
			getrow = 0;
			resultid = rs.getString("id");
			resultname = rs.getString("name");
			resultHP = rs.getString("tel");
			resultOk = "Y";
			sql = "select * from check_out where user_id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, resultid);
			rs = pstmt.executeQuery();

			while(rs.next()) {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				Date returndate = formatter.parse(rs.getString("rtn_date"));
				Date nowTime = new Date();
				if(nowTime.after(returndate))
					resultOk = "N&nbsp;(연체)";
				getrow++;
			}
			if(getrow >= 5) {
				resultOk = "N (대출 가능 수 초과)";
				resultOk = resultOk.replaceAll(" ", "&nbsp;");
			}
		}
		else {
			resultid = "결과없음";
			resultname = "결과없음";
			resultHP = "결과없음";
			resultOk = "결과없음";
		}		 
		con.close();
	} catch(Exception e){
		out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
		out.println(e.getMessage()+"<br>");
		e.printStackTrace();
	}
%>
<legend>대출자 정보</legend>
<label id="userID">아이디<input type="text" name="userid" value=<%=resultid%>> </label>
<label id="userName">이름<input type="text" name="username" value=<%=resultname%>></label>
<label id="userTel">전화번호<input type="text" name="userHP" value=<%=resultHP%>></label>
<label id="userOk">대출 가능 여부<input type="text" name="userOk" value=<%=resultOk%>></label>
</body>
</html>