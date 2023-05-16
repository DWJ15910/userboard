<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사
	//로그인된 상태로 들어갈려고하면 home.jsp로 이동
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
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
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="container">
		<form action="<%=request.getContextPath() %>/member/insertMemberAction.jsp" method="post">
			<hr>
			<%
				if(request.getParameter("msg") != null){
			%>
					<div><%=request.getParameter("msg") %></div>
			<%
				}
			%>
			<h2>회원가입</h2>
			<table class="table">
				<tr>
					<td>아이디</td>
					<td><input type="text" class="form-control" name="id"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" class="form-control" name="pw"></td>
				</tr>
			</table>
			<button class="btn btn-primary" type="submit">회원가입</button>
		</form>
	</div>
</body>
</html>