<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	
	//DB연동
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String selSql="SELECT local_name FROM local";
	PreparedStatement selStmt = conn.prepareStatement(selSql);
	ResultSet selRs = selStmt.executeQuery();
	
	ArrayList<Local> localNameList = new ArrayList<Local>();
	while(selRs.next()){
		Local local = new Local();
		local.setLocalName(selRs.getString("local_name"));
		localNameList.add(local);
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
	<!-- 메인메뉴 (가로) -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<div class="container">
		<hr>
		<form action="<%=request.getContextPath()%>/board/insertPostAction.jsp">
			<h2>게시물 작성</h2>
			<hr>
			<table class="table table-hover">
				<tr>
					<th>local_name</th>
					<td>
						<select name="local_name" class="form-select">
							<%
								for(Local local : localNameList){
							%>
									<option value="<%=local.getLocalName()%>"><%=local.getLocalName()%></option>
							<%
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>board_title</th>
					<td>
						<input type="text" name="board_title" class="form-control">
					</td>
				</tr>
				<tr>
					<th>board_content</th>
					<td>
						<input type="text" name="board_content" class="form-control">
					</td>
				</tr>
				<tr>
					<th>member_id</th>
					<td>
						<input type="text" name="member_id" disabled="disabled" value="<%=memberId %>" class="form-control">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="submit" class="btn btn-primary">게시글 작성</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>