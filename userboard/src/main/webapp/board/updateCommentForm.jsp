<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}
	
	if(request.getParameter("commentNo")==null
	||request.getParameter("commentNo").equals("")
	||request.getParameter("boardNo")==null
	||request.getParameter("boardNo").equals("")){
	
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	System.out.println("유효성 검사 실패");
	return;
	}
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
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
	<!-- 메인메뉴 (가로) -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<hr>
		<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp">
		<h2>댓글 수정</h2>
		<hr>
			<table class="table table-hover">
				<tr>
					<th>댓글 수정</th>
				</tr>
				<tr>
					<th><input type ="text" name="comment_text" class="form-control"></th>
				</tr>
			</table>
			
			<button class="btn btn-primary" type="submit">수정</button>
			<!-- boardNo와 commentNo값 보내기용 -->
			<input type="hidden" name="boardNo" value="<%=boardNo %>">
			<input type="hidden" name="commentNo" value="<%=commentNo %>">
		</form>
	</div>
</body>
</html>