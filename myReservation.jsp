<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 캐싱 방지 (로그아웃 후 접근 차단) --%>
<%
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", 0L);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 정보 - LIVE-RARY</title>
<link type="text/css" rel="stylesheet" href="defaultStyle.css">
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<style>
header {
	padding-top: 100px;
	top: -100px;
}

section {
	text-align: center;
}

table {
	/* 테이블 크기 지정 */
	width: calc(95vw);
	max-width: 1200px;
}
</style>
<script>
	function del_reservation(bookName) {
		var input = document.createElement('input');
		input.setAttribute("type", "hidden");
		input.setAttribute("name", "book_name");
		input.setAttribute("value", bookName);
		input.setHTML(bookName);

		var newForm = document.createElement('form');
		newForm.appendChild(input);
		newForm.setAttribute("action", "deletereservation.jsp");
		newForm.setAttribute("method", "post");

		document.body.appendChild(newForm);

		if (confirm("해당 도서의 예약을 취소하시겠습니까?")) {
			newForm.submit();
			alert("예약이 취소되었습니다.");
		} else {
			alert("예약을 취소하지 않았습니다.");
		}
	}
	function logout() {
		if (confirm("로그아웃 하시겠습니까?")) {
			window.open("logoutAction.jsp", "_self");
		}
	}
</script>
</head>
<body>
	<%
	String id = (String) session.getAttribute("id");
	if (id == null) {
		out.println("<script>alert('로그아웃 되었습니다.')</script>");
		out.println("<script>window.open('index.html','_self')</script>");
	}
	%>
	<header>
		<img src="image/logo_transparent_light.png" height="60" alt="LIVE-RARY" onclick="window.open('userMain.jsp','_self')">
		<form action="bookSearch.jsp">
			<input type="text" name="searchValue" placeholder="도서 이름 입력"> <input type="submit" value="검색">
		</form>
		<nav>
			<a href="myPage.jsp"><%=id%> 님</a> <span onclick="logout()" style="margin-left: 20px">로그아웃</span>
		</nav>
	</header>
	<nav class="mainMenu">
		<a href="userMain.jsp">알림</a> <a href="myCheckOut.jsp">대출 목록</a> <a href="myReservation.jsp" style="font-weight: bold;">예약 목록</a>
	</nav>

	<section id="section" style="margin-top: 10px">
		<%
		request.setCharacterEncoding("UTF-8");

		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;

		String driverName = "com.mysql.jdbc.Driver";
		String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";

		sql = "SELECT * FROM reservation where user_id = ?";

		try {

			Class.forName(driverName);
			con = DriverManager.getConnection(dbURL, "liverary", "4321");

			pstmt = con.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			pstmt.setString(1, id);

			/* String book_id = null;
			String date = null; */
			rs = pstmt.executeQuery();
		%>
		<table>
			<tHead>
				<%
				if (rs.next()) {
					out.println("<tr>\n<th>책 등록 번호</th>\n<th>책 제목</th>\n<th>예약한 일자</th>\n<th>예약 순번</th>\n<th>예약 취소</th>\n</tr>");
					rs.beforeFirst();
				} else {
					out.println("<tr class='noResult'><th>예약한 이력이 없습니다.</th></tr>");
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
					<td><%=rs.getString("date")%></td>
					<td>
						<%
						if (0 == rs.getInt("priorities"))
							out.print("대출 가능");
						else
							out.print(rs.getString("priorities"));
						%>
					</td>
					<td><input type="button" id="<%=rs.getString("book_name")%>" value="예약 삭제" onclick=del_reservation(this.id) /></td>
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
		%>
	</section>



	<footer>
		<img src="image/kongju_logo.png" height="50" alt="LIVE-RARY">
		<nav style="font-size: 13px; margin-left: 50px; text-align: left;">
			<span style="margin-right: 5px; font-weight: 550">Developer</span><br> <span>201801743 김규빈</span><br> <span>201801828 홍상혁</span><br> <span>202001834 진민주</span><br>
		</nav>
	</footer>
</body>
</html>