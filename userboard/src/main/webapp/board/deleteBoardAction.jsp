<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}
	//유효성검사
	if(request.getParameter("local_name")==null
		||request.getParameter("local_name").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp");
		System.out.println("유효성 검사 실패");
		return;
	}
	
	//삭제에 사용될 local_name 선언
	String localName = request.getParameter("local_name");
	
	//DB연동
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	//외래키 위반 중복 검사
	String searchSql ="select count(*) from board where local_name = ?";
	PreparedStatement searchStmt = conn.prepareStatement(searchSql);
	searchStmt.setString(1, localName);
	
	ResultSet searchRs = searchStmt.executeQuery();
	int cnt = 0;
	if(searchRs.next()){
		cnt = searchRs.getInt("count(*)");
	}
	
	//cnt가 0이 아니면 페이지 반환
	if(cnt != 0){
		String msg = URLEncoder.encode("외래키 제약 조건에 위배되어 삭제할 수 없습니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg=" + msg);
		return;
	}
	
	//카테고리 삭제를 위한 sql 쿼리문 작성
	String sql = "DELETE FROM local where local_name = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,localName);
	System.out.println("del.stmt-->"+stmt);
	
	int row = stmt.executeUpdate();
	
	if(row==1){
		String msg = URLEncoder.encode("카테고리가 삭제되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		System.out.println("row값 정상");
		return;
	}else{
		String msg = URLEncoder.encode("카테고리 삭제에 실패했습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+msg);
		System.out.println("row값 오류");
		return;
	}
%>