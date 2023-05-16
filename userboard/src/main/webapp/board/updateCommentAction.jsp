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
	if(request.getParameter("comment_text")==null
		||request.getParameter("commentNo")==null
		||request.getParameter("boardNo")==null
		||request.getParameter("comment_text").equals("")
		||request.getParameter("commentNo").equals("")
		||request.getParameter("boardNo").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		System.out.println("유효성 검사 실패");
		return;
	}
	
	//원래 카테고리명과 바꿀 카테고리명 받기
	String commentText = request.getParameter("comment_text");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
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
	String searchSql ="UPDATE comment SET comment_text=?,updatedate=now() WHERE comment_no = ?";
	PreparedStatement searchStmt = conn.prepareStatement(searchSql);
	searchStmt.setString(1, commentText);
	searchStmt.setInt(2, commentNo);
		
	int row = searchStmt.executeUpdate();
	
	//정상일 경우실행
	if(row==1){
		String msg = URLEncoder.encode("댓글이 수정되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		System.out.println("row값 정상");
		return;
	}else{
		//row가 1이 아닐경우 (오류 날경우 실행)
		String msg = URLEncoder.encode("댓글 수정에 실패했습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		System.out.println("row값 오류");
		return;
	}
%>