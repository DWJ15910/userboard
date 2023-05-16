<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		<hr>
		<form action="<%=request.getContextPath() %>/member/deleteUserAction.jsp">
			<div style="color: red;">
				<%
					if(request.getParameter("msg") != null){
				%>
						<div><%=request.getParameter("msg") %></div>
				<%
					}
				%>
			</div>
			<h2>회원탈퇴</h2>
			<table class="table">
				<tr>
					<th>정말 삭제하신다면 비밀번호를 입력해주시기 바랍니다</th>
				</tr>
				<tr>
					<th><input class="form-control" type="password" name="checkpw"></th>
				</tr>
				<tr>
					<th><button class="btn btn-danger" type="submit">회원탈퇴</button></th>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>