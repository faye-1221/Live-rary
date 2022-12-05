<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
request.setCharacterEncoding("UTF-8");

String bookId = request.getParameter("bookId");
String userId = (String)session.getAttribute("id");
Date rtn_date = null;
//https://extbrain.tistory.com/58


Connection con = null;
PreparedStatement pstmt = null;
String sql = null;

String driverName="com.mysql.jdbc.Driver";
String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";


try {	
	Class.forName(driverName);
	con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
	//해당 유저, 책의 rtn_date를 불러옴
	sql = "SELECT * FROM check_out where book_id=? and user_id=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, bookId);
	pstmt.setString(2, userId);
	ResultSet result = pstmt.executeQuery();
	while(result.next()){
		rtn_date = result.getDate("rtn_date");
	}
	pstmt.close();
	
	//불러온 rtn_date에 14일을 추가함
	sql = "SELECT DATE_ADD(?, INTERVAL 14 DAY)";	
	pstmt = con.prepareStatement(sql);
	pstmt.setDate(1, rtn_date);
	result = pstmt.executeQuery();
	while(result.next()){
		rtn_date = result.getDate(1);
	}
	pstmt.close();
	
	//14일 증가된 rtn_date를 저장함, chk_extend를 Y로 변경
	sql = "update check_out set chk_extend=?, rtn_date=? where book_id = ? and user_id = ?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, "N");
	pstmt.setDate(2, rtn_date);
	pstmt.setString(3, bookId);
	pstmt.setString(4, userId);
	int r = pstmt.executeUpdate();
	pstmt.close();

	
} catch(Exception e){
	out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
	out.println(e.getMessage());
	e.printStackTrace();
} finally {
	if(pstmt != null)pstmt.close();
	if(con != null)con.close();
}
%>
<script>
	window.open("myCheckOut.jsp", "_self");
</script>