<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
request.setCharacterEncoding("UTF-8");

String bookId = request.getParameter("bookId");
String userId = (String)session.getAttribute("id");
String bookName = null;
int priorities = 0;

Connection con = null;
PreparedStatement pstmt = null;
String sql = null;

String driverName="com.mysql.jdbc.Driver";
String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";

try {
	
	Class.forName(driverName);
	con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
	//해당하는 책 제목 가져오기
	sql = "select * from book where 등록번호=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, bookId);
	ResultSet result = pstmt.executeQuery();
	while(result.next()){
		bookName = result.getString(3);
	}
	pstmt.close();
	
	//bookName을 기준으로 예약 순서 가져오기
	sql = "select * from reservation where book_name=? order by priorities";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, bookName);
	result = pstmt.executeQuery();
	while(result.next()){
		priorities = result.getInt("priorities");
	}
	
	priorities += 1; //bookName이 없으면 1로 저장됨.(어차피 현재 대출 중이니까)
	pstmt.close();
	
	//reservation에 등록
	sql = "INSERT INTO reservation(user_id, book_id, book_name, date, priorities) VALUES (?, ?, ?, ?, ?)";
	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일");
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, userId);
	pstmt.setString(2, bookId);
	pstmt.setString(3, bookName);
	pstmt.setString(4, sf.format(nowTime));
	pstmt.setInt(5, priorities);
	int r = pstmt.executeUpdate(); //int를 반환하므로 받아주기.

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
	window.open("myReservation.jsp", "_self");
</script>