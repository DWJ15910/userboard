<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	//세션 전송
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}
	//유효성 검사
	if(request.getParameter("local_name")==null){
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp");
		System.out.println("local_name전송오류");
		return;
	}
	
	//지울 local_name데이터 받아오기
	String localName = request.getParameter("local_name");
	System.out.println("localName-->"+localName);
	
	//DB연결
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String searchSql ="select count(*) from local where local_name = ?";
	PreparedStatement searchStmt = conn.prepareStatement(searchSql);
	searchStmt.setString(1, localName);
	
	ResultSet searchRs = searchStmt.executeQuery();
	int cnt = 0;
	if(searchRs.next()){
		cnt = searchRs.getInt("count(*)");
	}
	
	//cnt가 0이 아니면 페이지 반환
	if(cnt != 0){
		String msg = URLEncoder.encode("중복된 카테고리 이름입니다", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBoardForm.jsp?msg=" + msg);
		return;
	}
	
	//카테고리 추가 sql 문 추가
	String sql = "insert local (local_name,createdate,updatedate) values(?,now(),now())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,localName);
	System.out.println("stmt-->"+stmt);
	
	int row = stmt.executeUpdate();
	
	if(row==1){
		//정상일 경우 출력
		String msg = URLEncoder.encode("카테고리가 생성되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		System.out.println("row값 정상");
		return;
	}else{
		//row가 1이 아닐경우 row 오류 출력
		String msg = URLEncoder.encode("카테고리생성에 실패하였습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		System.out.println("row값 오류");
		return;
	}
%>