<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
request.setCharacterEncoding("UTF-8");

String bookName = request.getParameter("book_name");
String userId = (String)session.getAttribute("id");
String bookId = null;
int priorities = 0;
int numbering = 0;

Connection con = null;
PreparedStatement pstmt = null;
PreparedStatement pstmt2 = null;
PreparedStatement pstmt3 = null;
String sql = null;
String sql2 = null;
String sql3 = null;
int r = 0;

String driverName="com.mysql.jdbc.Driver";
String dbURL = "jdbc:mysql://gyudb.ddns.net:41000/liverary";


try {	
	Class.forName(driverName);
	con = DriverManager.getConnection(dbURL, "liverary", "4321");
	
	//해당 예약 우선순위 불러오기(book_name을 기준으로)
	sql = "SELECT * FROM RESERVATION WHERE book_name=? and user_id=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, bookName);
	pstmt.setString(2, userId);
	ResultSet result = pstmt.executeQuery();
	
	while(result.next()){
		bookId = result.getString("book_id");
		priorities = result.getInt("priorities");
	}
	pstmt.close();
	%>
	<%= bookName %>
	<%
	
	/* 	//삭제할 예약이 우선순위가 0일 때 알람에서 삭제
	if(priorities == 0){
		sql = "DELETE FROM book_alarm where book_name=? and user_id=?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, bookName);
		pstmt.setString(2, userId);
		r = pstmt.executeUpdate();
		pstmt.close();
	} */
	
	//해당 예약 삭제(book_id를 기준으로)
	sql = "DELETE FROM reservation where book_id=? and user_id=?"; 
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, bookId);
	pstmt.setString(2, userId);
	r = pstmt.executeUpdate();
	pstmt.close();
	
	//해당 book 예약 우선순위 당기기(book_name을 기준으로)
	sql = "SELECT * from reservation where book_name=? and priorities >= ?"; 
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, bookName);
	pstmt.setInt(2, priorities);
	result = pstmt.executeQuery();
	
	//우선순위 업데이트
	sql2 = "update reservation set priorities=? where numbering=?";
	pstmt2 = con.prepareStatement(sql2);
	
/* 	//알람에 넣기(book_name을 기준으로)
	sql3 = "INSERT INTO book_alarm(user_id, book_name) VALUES (?, ?)";
	pstmt3 = con.prepareStatement(sql3); */

	
	while(result.next()){
		priorities = result.getInt("priorities");
		numbering = result.getInt("numbering");
		
/* 		//순서를 당기다가 해당 값이 0로 변경될 경우 book_alarm에 저장
		if(priorities-1 == 0){
			pstmt3.setString(1, userId);
			pstmt3.setString(2, bookName);
			r = pstmt3.executeUpdate();
		}	 */
		
		//각각 우선순위 -1로 저장
		pstmt2.setInt(1, priorities-1);
		pstmt2.setInt(2, numbering);
		r = pstmt2.executeUpdate();
	}
	
} catch(Exception e){
	out.println("MySql 데이터베이스 접속에 문제가 있습니다. <hr>");
	out.println(e.getMessage());
	e.printStackTrace();
} finally {
	if(pstmt != null)pstmt.close();
	if(pstmt2 != null)pstmt2.close();
	if(pstmt3 != null)pstmt3.close();
	if(con != null)con.close();
}
%>

<script>
	window.open("myReservation.jsp", "_self");
</script>