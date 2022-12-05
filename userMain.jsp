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
<title>LIVE-RARY</title>
<link type="text/css" rel="stylesheet" href="defaultStyle.css">
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
	width: calc(80vw);
	max-width: 800px;
}

</style>
<script>
	function logout() {
		if (confirm("로그아웃 하시겠습니까?")) {
			window.open("logoutAction.jsp", "_self");
		}
	}

	function sectionChange(changeType) {
		location.href = "userMain.jsp?changeType=" + changeType;

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
	String changeType = request.getParameter("changeType");
	%>
	<header>
		<img src="image/logo_transparent_light.png" height="60" alt="LIVE-RARY" onclick="window.open('userMain.jsp','_self')">
		<form action="bookSearch.jsp">
			<select name="searchType" id="searchType">
				<option value="book_name">책 제목</option>
				<option value="book_author">저자</option>
			</select> <input type="text" name="searchValue" placeholder="도서 이름 입력"> <input type="submit" value="검색">
		</form>
		<nav>
			<a href="myPage.jsp"><%=id%> 님</a> <span onclick="logout()" style="margin-left: 20px;">로그아웃</span>
		</nav>
	</header>
	<nav class="mainMenu">
		<button id="alarm" onclick="sectionChange(this.id)">알림</button>
		<button id="myCheckOut" onclick="sectionChange(this.id)">대출 목록</button>
		<button id="myReservation" onclick="sectionChange(this.id)">예약 목록</button>
	</nav>
	<section id="section">
		<%
		if (changeType == null) {
		%>
		<jsp:include page="alarm.jsp" />
		<%
		} else if (changeType.equals("alarm")) {
		%><jsp:include page="alarm.jsp" />
		<%
		} else if (changeType.equals("myCheckOut")) {
		%><jsp:include page="myCheckOut.jsp" />
		<%
		} else if (changeType.equals("myReservation")) {
		%><jsp:include page="myReservation.jsp" />
		<%
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