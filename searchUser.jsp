<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% /* 혹시나 해서 만들었지만 안쓸 문서 나중에 삭제 예정 */ %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사용자 검색</title>
<link type="text/css" rel="stylesheet" href="defaultStyle.css">
<style>
body{
	min-width:500px;
}
header{
	display:inline;
	justify-content:flex-start;
	padding:1rem;
	height:50px;
}
form{
	text-align:center;
}
</style>
</head>
<body>
<header>
	<form action="searchUserAction.jsp">
		<input type="text" placeholder="사용자 아이디 입력" style="width:300px">
		<input type="submit" value="검색" style="color: #213458;background:#F6E8E8;">
	</form>
</header>
<table>

</table>
</body>
</html>