<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	//세션검사 세션값이 null이면 홈으로 반환
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//세션 ID값과 입력받은 PW값 가져오기
	String memberId = (String)session.getAttribute("loginMemberId");
	String checkPw = request.getParameter("checkpw");
	//디버깅
	System.out.println("memberId-->"+memberId);
	System.out.println("checkPw-->"+checkPw);

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
	
	//쿼리문작성
	String delSql = null;
	delSql = "DELETE FROM member WHERE member_id=? and member_pw=PASSWORD(?)";
	stmt = conn.prepareStatement(delSql);
	stmt.setString(1,memberId);
	stmt.setString(2,checkPw);
	//디버깅
	System.out.println("del.stmt-->"+stmt);
	
	//정상일 경우 1 아니면 다른 숫자출력
	int row = stmt.executeUpdate();
	
	//row가 1출력 될경우 msg를 홈으로 넘기면서 세션 지우기
	if(row==1){
		String msg = URLEncoder.encode("회원탈퇴가 성공적으로 되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		session.invalidate();
		System.out.println("삭제성공 row값-->"+row);
		return;
	}else{
		//row가 1이 아닐경우 이전페이지로 돌아가며 재시도 요청
		String msg = URLEncoder.encode("비밀번호가 틀렸습니다. 다시 시도해주시기 바랍니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/deleteUserForm.jsp?msg="+msg);
		System.out.println("삭제실패 row값-->"+row);
		return;
	}
	
%>