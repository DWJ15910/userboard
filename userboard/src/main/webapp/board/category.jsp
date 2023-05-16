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
	<!-- 메인메뉴 (가로) -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">

		<!-- 메시지 출력 -->
		<div style="color: red;">
			<%
				if(request.getParameter("msg") != null){
			%>
					<div><%=request.getParameter("msg") %></div>
			<%
				}
			%>
		</div>
		
		<hr>
		<table class="table">
			<tr>
				<td>
					<a class="btn btn-primary" href="<%=request.getContextPath() %>/board/insertBoardForm.jsp">카테고리 추가</a>
				</td>
			</tr>
			<tr>
				<td>
					<a class="btn btn-primary" href="<%=request.getContextPath() %>/board/updateBoardForm.jsp">카테고리 수정</a>
				</td>
			</tr>
			<tr>
				<td>
					<a class="btn btn-primary" href="<%=request.getContextPath() %>/board/deleteBoardForm.jsp">카테고리 삭제</a>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>