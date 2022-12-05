<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
body::before {
	background-image: linear-gradient( rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3) ),url(image/main_bg.jpg);
}
caption {
	color: #F6E8E8;
	font-weight:bold;
	margin-top:20px;
	margin-bottom:10px;
}
table tHead tr th {
	background-color:#fefaec;
	color:#625772;
	margin-top:0px;margin-bottom:0px;
}
table tr.noResult th {
	font-weight:500;
	background-color:transparent;
	color:#F6E8E8;
}
table tr:first-child th:first-child { border-top-left-radius: 5px; }
table tr:first-child th:last-child { border-top-right-radius: 5px; }

table tr:first-child td:first-child { border-top-left-radius: 0px; }
table tr:first-child td:last-child { border-top-right-radius: 0px; }
</style>
</head>
<link type="text/css" rel="stylesheet" href="defaultStyle.css">
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.time.LocalDate"%>

<body>

	<!-- 연체 목록, 대출하러 오라고 보여주기 -->
	<%
	String user_id = (String) session.getAttribute("id");
	
	request.setCharacterEncoding("UTF-8");

	Connection con = null;
	PreparedStatement pstmt = null;
	String sql = null;
	ResultSet rs = null;

	String driverName = "com.mysql.jdbc.Driver";
	String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";

	//자신의 아이디 기준으로 reservation에서 우선순위가 0인 값 가져오기
	sql = "SELECT * FROM reservation where user_id=? and priorities <= 0";

    try {

        Class.forName(driverName);
        con = DriverManager.getConnection(dbURL, "liverary", "4321");

        pstmt = con.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
        pstmt.setString(1, user_id);
        rs = pstmt.executeQuery();
    %> 
	<table>
		<caption>대출 가능한 예약 도서</caption>
		<tHead>
		<%
			if(rs.next()){
				out.println("<tr>\n<th>책 등록 번호</th>\n<th>책 제목</th>\n</tr>");
				rs.beforeFirst();
			}
			else {
				out.println("<tr class='noResult'><th>알림 없음</th></tr>");
			}
		%>
		</tHead>
		<tBody>
			<%
			while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getString("book_id")%></td>
				<td><%=rs.getString("book_name")%></td>
			</tr>

			<%
			}
			%>
		</tBody>
	</table>
	<% 
	} catch (Exception e) {
	out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
	out.println(e.getMessage());
	e.printStackTrace();
	} finally {
	if (pstmt != null)
		pstmt.close();
	if (con != null)
		con.close();
	}
		
		LocalDate local_date = LocalDate.now(); //java.time.localdate
		Date today = Date.valueOf(LocalDate.now());
		sql = "select book_id, book_name, rtn_date from check_out where rtn_date < ? and user_id =?";
		try {

		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");

		pstmt = con.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
		pstmt.setDate(1, today);
		pstmt.setString(2, user_id);
		rs = pstmt.executeQuery();
	%>
	<table>
		<caption>연체 도서</caption>
		<tHead>
		<%
			if(rs.next()){
				out.println("<tr>\n<th>책 등록 번호</th>\n<th>책 제목</th>\n<th>연체 일자</th>\n</tr>");
				rs.beforeFirst();
			}
			else {
				out.println("<tr class='noResult'><th>알림 없음</th></tr>");
			}
		%>
		</tHead>
		<tBody>
			<%
			while (rs.next()) {
			%>
			<tr>
				<td style="width:100px"><%=rs.getString("book_id")%></td>
				<td><%=rs.getString("book_name")%></td>
				<td style="width:100px;color:red;"><%=rs.getString("rtn_date")%></td>
			</tr>
			<%} %>
		</tBody>
	</table>
	<% 
	} catch (Exception e) {
	out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
	out.println(e.getMessage());
	e.printStackTrace();
	} finally {
	if (pstmt != null)
		pstmt.close();
	if (con != null)
		con.close();
	}
	%>
</body>
</html>