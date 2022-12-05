<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그아웃</title>
</head>
<body>
<%
	session.removeAttribute("id");
	session.removeAttribute("isAdmin");
	session.invalidate();
%>
<script>
	window.open("index.html", "_self");
</script>
</body>
</html>