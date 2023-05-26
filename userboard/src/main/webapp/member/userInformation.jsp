<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//한글 깨짐 방지
	request.setCharacterEncoding("utf8");
	//로그인 정보 없을때는 홈으로 반환
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//세션 로그인 값 받기
	String memberId = (String)session.getAttribute("loginMemberId");
	System.out.println("memberId-->"+memberId);
	
	//DB연결
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	//stmt와 rs 선언
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	//멤버 정보 출력 SELECT문 작성
	String userSql = null;
	userSql = "SELECT member_id,createdate,updatedate FROM member WHERE member_id = ?";
	stmt = conn.prepareStatement(userSql);
	stmt.setString(1,memberId);
	rs = stmt.executeQuery();
	
	//리스트 작성
	Member user = null;
	if(rs.next()){
		user = new Member();
		user.setMemberId(rs.getString("member_id"));
		user.setCreatedate(rs.getString("createdate"));
		user.setUpdatedate(rs.getString("updatedate"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
		<!-- 상단 메뉴바 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		
		<div class="container">
		<hr>
		<h2>회원정보</h2>
		
		<table class="table">
			<tr>
				<th>ID</th>
				<td><%=user.getMemberId() %></td>
			</tr>
			<tr>
				<th>가입일</th>
				<td><%=user.getCreatedate() %></td>
			</tr>
			<tr>
				<th>수정일</th>
				<td><%=user.getUpdatedate() %></td>
			</tr>
			<tr>
				<td colspan="2">
					<a class="btn btn-primary" href="<%=request.getContextPath() %>/member/updatePasswordForm.jsp">비밀번호 변경</a>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<a class="btn btn-primary" href="<%=request.getContextPath() %>/member/deleteUserForm.jsp">회원탈퇴</a>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>