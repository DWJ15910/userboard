<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	//세션 검사 세션ID가 null이면 홈으로 반환
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//세션 ID와 원래비밀번호 새비밀번호 교차검증 비밀번호 값받기
	String memberId = (String)session.getAttribute("loginMemberId");
	String beforePw = request.getParameter("beforepw");
	String newPw = request.getParameter("newpw");	
	String newPw2 = request.getParameter("newpw2");	
	//디버깅
	System.out.println("updatePasswordAction.memberId-->"+memberId);
	System.out.println("updatePasswordAction.beforePw-->"+beforePw);
	System.out.println("updatePasswordAction.newPw-->"+newPw);
	System.out.println("updatePasswordAction.newPw2-->"+newPw2);
	
	//새비밀번호와 교차검증비밀번호 둘이 맞는지 확인
	if(!newPw.equals(newPw2)){
		String msg = URLEncoder.encode("새 비밀번호와 재입력 비밀번호가 서로 다릅니다. 다시 입력해주시기 바랍니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp?msg="+msg);
		System.out.println("newPw와 newPw2가 다름!");
		return;
	}

	//DB연결
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	//stmt,rs선언
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	
	//비밀번호 변경 쿼리문 작성
	String pwSql = null;
	pwSql = "UPDATE member SET member_pw = PASSWORD(?),updatedate=now() WHERE member_id = ? and member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(pwSql);
	stmt.setString(1,newPw);
	stmt.setString(2,memberId);
	stmt.setString(3,beforePw);
	System.out.println("updatePasswordAction.stmt-->"+stmt);
	
	//row갑 1이면 정상 아니면 비정상
	int row = stmt.executeUpdate();
	
	//row값이 1일경우 메시지와 함께 홈으로 반환
	if(row==1){
		String msg = URLEncoder.encode("비밀번호가 변경되었습니다. 다시 로그인해주시기 바랍니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		session.invalidate();
		System.out.println("변경성공 row값-->"+row);
		return;
	}else{
		//row값이 1이 아닐경우 메시지와 함게 이전페이지로 반환
		String msg = URLEncoder.encode("비밀번호 변경을 실패하였습니다. 다시 시도해주시기 바랍니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp?msg="+msg);
		System.out.println("변경실패 row값-->"+row);
		return;
	}
	
%>