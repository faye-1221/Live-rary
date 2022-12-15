<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색결과 - LIVE-RARY</title>
<link type="text/css" rel="stylesheet" href="defaultStyle.css">
<style>
body::before {
	/* 배경 어둡게 */
	background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3)),
		url(image/main_bg.jpg);
}

body {
	text-align: center;
}

table {
	/* 테이블 크기 지정 */
	width: calc(95vw);
	max-width: 1200px;
}

th {
	min-width: 90px;
}

input[type="button"]:disabled {
	background-color: #c2b7d2;
	color: #e2d7f2;
}
</style>

<script>
	function reservation(bookId) {
		var input = document.createElement('input');
		input.setAttribute("type", "hidden");
		input.setAttribute("name", "bookId");
		input.setAttribute("value", bookId);
		input.setHTML(bookId);

		var newForm = document.createElement('form');
		newForm.appendChild(input);
		newForm.setAttribute("action", "reservationAction.jsp");
		newForm.setAttribute("method", "post");

		document.body.appendChild(newForm);

		if (confirm("해당 도서를 예약하시겠습니까?")) {
			newForm.submit();
			alert("예약되었습니다.");
		} else {
			alert("취소되었습니다.");
		}
	}
</script>
</head>
<body>
	<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.util.ArrayList"%>
	<%
	String id = (String) session.getAttribute("id");
	String admin = (String) session.getAttribute("admin");
	boolean isAdmin = false;

	if (id == null) {
		out.println("<script>alert('로그아웃 되었습니다.')</script>");
		out.println("<script>window.open('index.html','_self')</script>");
	} else if (admin.equals("1")) {
		isAdmin = true;
	}

	request.setCharacterEncoding("utf-8");
	String searchValue = request.getParameter("searchValue");
	String searchType[] = request.getParameterValues("searchType");
	%>
	<header>
		<img src="image/logo_transparent_light.png" height="60" alt="LIVE-RARY" onclick="window.open('<%=isAdmin ? "librarianMain.jsp" : "userMain.jsp"%>','_self')">
		<form action="bookSearch.jsp">
			<select name="searchType" id="searchType">
				<option value="book_name">책 제목</option>
				<option value="book_author">저자</option>
			</select> <input type="text" name="searchValue" value="<%=(searchValue == null) ? "" : searchValue%>" placeholder="도서 이름 입력"> <input type="submit" value="검색">
		</form>
		<nav>
			<a href="myPage.jsp"><%=id%> 님<%=isAdmin ? "(사서)" : ""%></a> <a href="logoutAction.jsp" style="margin-left: 20px">로그아웃</a>
		</nav>
	</header>

	<%!int rowCount;
	int limit;
	ArrayList<String> checkOutList = new ArrayList<>();
	ArrayList<String> reservationList = new ArrayList<>();
	ArrayList<String> myCheckOutList = new ArrayList<>();%>
	<%
	rowCount = 0;
	limit = 0; //예약 권 수 + 대출 권 수

	searchValue = "%" + searchValue + "%"; // 포함 단어로 검색

	Connection con = null;
	PreparedStatement pstmt = null;
	String sql = null;
	/* 커넥션 풀 사용 안하면 주석 해제 */
	String driverName = "com.mysql.jdbc.Driver";
	String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";

	/* 대출 목록(book_id)을 checkOutList에 저장 */
	sql = "select * from check_out";
	try {

		/* 커넥션 풀 사용 안하면 주석 해제 */
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");

		/* 커넥션 풀 사용 */
		/* 	InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			con = ds.getConnection(); */
		/* 커넥션 풀 */

		pstmt = con.prepareStatement(sql);
		ResultSet result = pstmt.executeQuery();
		while (result.next()) {
			checkOutList.add(result.getString(3));
			if (result.getString("user_id").equals(id)) {
		myCheckOutList.add(result.getString(3));
			}
		}
		pstmt.close();

		//당사자의 예약 목록(book_id)을 reservationList에 저장.
		sql = "select * from reservation where user_id = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, id);
		result = pstmt.executeQuery();
		while (result.next()) {
			reservationList.add(result.getString(3));

			limit += 1;
		}

		result.close();
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
	/* 대출 목록을 checkOutList에 저장 끝 */

	/* 전체 도서 목록에서 입력한 제목 검색 */
	if (searchType[0].equals("book_name")) { //책 이름으로 찾을 경우
		sql = "select * from book where 서명 like ?";
	} else { //저자로 찾을 경우
		sql = "select * from book where 저자 like ?";
	}
	try {
		/* 커넥션 풀 사용 안하면 주석해제 */
		Class.forName(driverName);
		con = DriverManager.getConnection(dbURL, "liverary", "4321");

		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, searchValue);
		ResultSet result = pstmt.executeQuery();
	%>

	<table>
		<tHead>
			<tr>
				<th>등록 번호</th>
				<th>도서 제목</th>
				<th>저자</th>
				<th>출판사</th>
				<th>출판년도</th>
				<th>대출 여부</th>
				<th>예약</th>
			</tr>
		</tHead>
		<tBody id="bookList">
			<%
			while (result.next()) {
			%>
			<tr>
				<td><%=result.getString(2)%></td>
				<td><%=result.getString(3)%></td>
				<td><%=result.getString(4)%></td>
				<td><%=result.getString(5)%></td>
				<td><%=result.getString(6)%></td>
				<%
				/* 대출중인 경우 */
				if (!checkOutList.contains(result.getString(2)))
					out.print("<td style='color:green'>대출 가능</td>");
				else
					out.print("<td style='color:red'>대출 중</td>");
				%>
				<td><input type="button" id="<%=result.getString(2)%>" <%//대출 예약 사서인 경우 || 대출 중이 아닌 경우(book_id) ||  당사자가 책 5권 (예약 + 대출) 했을 경우 || 이미 당사자가 동일한 책 id를 예약 || 대출했을 경우 
if (isAdmin || !checkOutList.contains(result.getString(2)) || limit >= 3 || reservationList.contains(result.getString(2))
		|| myCheckOutList.contains(result.getString(2)))
	out.print("disabled");%> onclick="reservation(this.id)" value="대출 예약"> <%

 %></td>

			</tr>
			<%
			rowCount++;
			}
			//list가 남아있어서 clear
			checkOutList.clear();
			reservationList.clear();
			myCheckOutList.clear();
			limit = 0;

			result.close();
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
		</tBody>
	</table>
	<section style="color: #F6E8E8; margin-bottom: 10px">
		<%
		if (rowCount == 0)
			out.println("조회된 결과가 없습니다.");
		else
			out.println("조회된 결과는 총 " + rowCount + "건 입니다.");
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