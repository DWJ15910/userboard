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
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	int boardNo=0;

	if(request.getParameter("boardNo")!=null){
		boardNo = Integer.parseInt(request.getParameter("boardNo"));
		System.out.println("boardOne.boardNo값 받아옴");
	} else {
	//null값이 왔을경우 home으로 이동
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("updatePost 값 오류");
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
	
	String sql = "SELECT board_no,local_name,board_title,board_content,member_id FROM board WHERE board_no=?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1,boardNo);
	rs = stmt.executeQuery();
	
	Board board = null;
	if(rs.next()){
		board = new Board();
		board.setBoardNo(rs.getInt("board_no"));
		board.setLocalName(rs.getString("local_name"));
		board.setBoardTitle(rs.getString("board_title"));
		board.setBoardContent(rs.getString("board_content"));
		board.setMemberId(rs.getString("member_id"));
	}
	
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
		<form action="<%=request.getContextPath()%>/board/updatePostAction.jsp">
		<h2>게시글 수정</h2>
		<hr>
			<table class="table table-hover">
				<tr>
					<th>board_no</th>
					<td>
						<input type="number" name="board_no" class="form-control" readonly="readonly" value="<%=board.getBoardNo()%>">
					</td>
				</tr>
				<tr>
					<th>member_id</th>
					<td>
						<input type="text" name="member_id" class="form-control" readonly="readonly" value="<%=loginMemberId %>">
					</td>
				</tr>
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
						<input type="text" name="board_title" class="form-control" value="<%=board.getBoardTitle()%>">
					</td>
				</tr>
				<tr>
					<th>board_content</th>
					<td>
						<input type="text" name="board_content" class="form-control" value="<%=board.getBoardContent()%>">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button class="btn btn-primary" type="submit">게시글 수정</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>