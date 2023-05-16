<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>패스워드 변경</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 상단메뉴바 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="container">
		<hr>
		<h2>비밀번호 변경</h2>
		<form action="<%=request.getContextPath()%>/member/updatePasswordAction.jsp" method="post">
			<!-- 메세지 출력 -->
			<div>
				<%
					if(request.getParameter("msg") != null){
				%>
						<div style="color: red;"><%=request.getParameter("msg") %></div>
				<%
					}
				%>
			</div>
			
			<table class="table">
				<tr>
					<th>이전 비밀번호 입력</th>
					<td><input class="form-control" type="password" name="beforepw"></td>
				</tr>
				<tr>
					<th>새 비밀번호 입력</th>
					<td><input class="form-control" type="password" name="newpw"></td>
				</tr>
				<tr>
					<th>새 비밀번호 재입력</th>
					<td><input class="form-control" type="password" name="newpw2"></td>
				</tr>
			</table>
			<button class="btn btn-primary" type="submit">비밀번호 변경</button>
		</form>
	</div>
</body>
</html>