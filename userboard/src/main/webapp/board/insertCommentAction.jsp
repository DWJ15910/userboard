<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	
	//작성자,댓글내용,boardNo(간추리기용) 유효성검사
	if(request.getParameter("addWriter")==null
		||request.getParameter("addText")==null
		||request.getParameter("boardNo")==null){
			System.out.println("null있음");
			//3개중 1개라도 null일 경우 home.jsp로 반환
			response.sendRedirect(request.getContextPath()+"/home.jsp");
			return;
	}
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}
	//상단의 3개의 데이터를 모두 받아 왔을 경우 변수선언
	String addWirter = request.getParameter("addWriter");
	String addText = request.getParameter("addText");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//DB연동
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	//commentSql에 사용할 Stmt선언
	PreparedStatement commentStmt = null;
	
	//댓글 작성용 쿼리문 작성
	String commentSql = null;
	commentSql = "INSERT INTO comment(member_id ,comment_text,board_no,createdate,updatedate) values(?,?,?,now(),now())";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setString(1,addWirter);
	commentStmt.setString(2,addText);
	commentStmt.setInt(3,boardNo);
	System.out.println("insertCommentAction.commentStmt-->"+commentStmt);
	
	//정상일 경우 row값 1반환
	int row = commentStmt.executeUpdate();
	
	if(row==1){//정상일 경우 다시 댓글 입력했던 페이지로 돌아가서 결과확인
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
		System.out.println("insertCommentAction.row-->"+row);
		return;
	} else {//실패일 경우 홈페이지로 이동
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("insertCommentAction.row-->"+row);
		return;
	}
	
	
	

%>