<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//메세지 선언
	String msg = "";
	
	//세션 유효성 검사
	//로그인된 상태로 들어갈려고하면 home.jsp로 이동
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//유효성 검사
	if(request.getParameter("id")==null
		||request.getParameter("pw")==null
		||request.getParameter("id").equals("")
		||request.getParameter("pw").equals("")){
		
		msg = URLEncoder.encode("ID와 비밀번호를 모두 입력해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}

	
	
	//insertMemberForm에서 입력한 ID와 PW값 불러오기
	String memberId = request.getParameter("id");
	String memberPw = request.getParameter("pw");
	//디버깅
	System.out.println("insertMemberAction.memberId-->" + memberId);
	System.out.println("insertMemberAction.memberPw-->" + memberPw);
	
	//db연결
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	//stmt,rs선언
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	ResultSet rs = null;
	
	// 중복 체크를 위해 SELECT 쿼리 실행
    String checkSql = "SELECT count(*) FROM member WHERE member_id = ?";
    stmt = conn.prepareStatement(checkSql);
    stmt.setString(1, memberId);
    rs = stmt.executeQuery();
    
    // 중복된 member_id가 있으면 cnt 카운트가 오름
    int cnt = 0;
    if (rs.next()) {
        cnt = rs.getInt("count(*)");
    }
    // 중복된 ID값이 있으면 에러 메시지 출력
    if (cnt > 0) {//중복된 id가 있으면 다시 회원가입창으로 이동
    	System.out.println("중복된 ID 있음");
    	msg = URLEncoder.encode("이미 가입된 동일한 ID가 있습니다","utf-8");
        response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
        return;
    }
	
    //회원가입 쿼리문 작성
	String sql = "INSERT INTO member(member_id,member_pw,createdate,updatedate) values(?,PASSWORD(?),now(),now())";
	//쿼리문으로 변경
	stmt2 = conn.prepareStatement(sql);
	//?값 입력
	stmt2.setString(1,memberId);
	stmt2.setString(2,memberPw);
	System.out.println("insertMemberAction.stmt2-->" + stmt2);	
	
	int row = stmt2.executeUpdate();
	System.out.println("insertMemberAction.row-->"+row);
	
	if(row==1){//정상 작동 하면 홈페이지로 이동
		System.out.println("insertMemberAction.row-->" + row);
		msg = URLEncoder.encode("회원가입 완료","utf-8");
		response.sendRedirect(request.getContextPath()+"/home.jsp?msg="+msg);
		return;
	} else {//비정상 작동하면 다시 가입페이지로 이동
		System.out.println("insertMemberAction.row-->" + row);
		msg = URLEncoder.encode("회원가입 실패","utf-8");
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp?msg="+msg);
		return;
	}
%>