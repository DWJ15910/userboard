<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
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

<style>
	.con {
	  width: 50%; /* 원하는 크기로 조정 */
	  height: auto; /* 내용에 따라 크기 조정 */
	  margin: 0 auto;
	}
	
</style>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<hr>
		<form action="<%=request.getContextPath() %>/board/insertBoardAction.jsp">
			<div style="color: red;">
				<%
					if(request.getParameter("msg") != null){
				%>
						<div><%=request.getParameter("msg") %></div>
				<%
					}
				%>
			</div>
			<h2>카테고리 추가</h2>
			<hr>	
			<table class="table">
				<tr>
					<th>카테고리명 입력</th>
				</tr>
				<tr>
					<td>
						<input class="form-control" type="text" name="local_name">
					</td>
				</tr>
				<tr>
					<td>
						<button class="btn btn-primary" type="submit">카테고리 추가</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>