<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}
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
	
	//카테고리를 DB에서 검색해서 그 중에 고를수 있도록 select 조회문 작성
	String sql = null;
	sql = "select local_name from local";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();

	//sql쿼리문을 통해 불러온 값을 ArrayList에 저장하여 하단에서 사용
	ArrayList<Local> localNameList = new ArrayList<Local>();
	while(rs.next()){
		Local local = new Local();
		local.setLocalName(rs.getString("local_name"));
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
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
		<hr>
		<div class="container">
		<form action="<%=request.getContextPath() %>/board/deleteBoardAction.jsp">
			<div style="color: red;">
				<%
					if(request.getParameter("msg") != null){
				%>
						<div><%=request.getParameter("msg") %></div>
				<%
					}
				%>
			</div>
			<h2>카테고리 삭제</h2>
			<hr>
			<table class="table">
				<tr>
					<th>삭제하실 카테고리명을 입력해주시기 바랍니다</th>
				</tr>
				<tr>
					<td>
						<select name="local_name" class="form-select">
							<%
								for(Local local : localNameList) {
							%>
									<option value="<%=local.getLocalName()%>"><%=local.getLocalName() %></option>
							<%
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<button class="btn btn-primary" type="submit">카테고리 삭제</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>