<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	//로그인이 되어있지않으면 home페이지로 반환
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}
	//유효성 검사
	if(request.getParameter("local_name")==null
		||request.getParameter("local_name").equals("")
		||request.getParameter("local_name2")==null
		||request.getParameter("local_name2").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp");
		System.out.println("유효성 검사 실패");
		return;
	}
	
	//원래 카테고리명과 바꿀 카테고리명 받기
	String localName = request.getParameter("local_name");
	String localName2 = request.getParameter("local_name2");
	
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
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg=" + msg);
		return;
	}
	
	//local_name변경을 위한 sql 쿼리문 작성
	String sql = "UPDATE local SET local_name = ? WHERE local_name=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,localName2);
	stmt.setString(2,localName);
	System.out.println("update.stmt-->"+stmt);
	
	int row = stmt.executeUpdate();
	
	//정상일 경우실행
	if(row==1){
		String msg = URLEncoder.encode("카테고리가 수정되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		System.out.println("row값 정상");
		return;
	}else{
		//row가 1이 아닐경우 (오류 날경우 실행)
		String msg = URLEncoder.encode("카테고리 수정에 실패했습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg);
		System.out.println("row값 오류");
		return;
	}
%>