<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	//DB연결
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String sql = "SELECT ";
%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a{
		text-decoration: none;
		color: #000000;
		font-weight: bold;
	}
</style>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
	<div class="container-fluid container">
		<ul class="navbar-nav">
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
			
			<!-- 
				로그인전 : 회원가입 
				로그인후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemberId
			-->
			<%
				if(session.getAttribute("loginMemberId")==null){ //로그인 전
			%>
					<li class="nav-item">
						<a class="nav-link" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a>
					</li>
			<%
				} else { //로그인 후
			%>
					<li class="nav-item">
						<a class="nav-link" href="<%=request.getContextPath()%>/member/userInformation.jsp">회원정보</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<%=request.getContextPath()%>/board/category.jsp">카테고리 관리</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<%=request.getContextPath()%>/board/insertPostForm.jsp">게시글 추가</a>
					</li>
			<%
				}
			%>
		</ul>
			<form class="d-flex" action="<%=request.getContextPath()%>/home.jsp">
				<input class="form-control me-2" type="text" placeholder="Search" name="search">
				<button class="btn btn-primary" type="submit">Search</button>
			</form>
	</div>
</nav>