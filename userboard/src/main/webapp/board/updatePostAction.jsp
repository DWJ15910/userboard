<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	//한글 깨짐 방지
	request.setCharacterEncoding("utf8");
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("세션로그인값없음");
		return;
	}
	//유효성 검사
	if(request.getParameter("local_name")==null
			||request.getParameter("board_title")==null
			||request.getParameter("board_content")==null
			||request.getParameter("board_no")==null
			||request.getParameter("local_name").equals("")
			||request.getParameter("board_title").equals("")
			||request.getParameter("board_content").equals("")
			||request.getParameter("board_no").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/board/updatePostForm.jsp");
		System.out.println("유효성 검사 실패");
		return;
	}
	
	String localName = request.getParameter("local_name");
	String boardTitle = request.getParameter("board_title");
	String boardContent = request.getParameter("board_content");
	int boardNo = Integer.parseInt(request.getParameter("board_no"));
	
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
	
	String disSql = "SELECT count(*) FROM comment WHERE board_no=?";
	PreparedStatement disStmt = conn.prepareStatement(disSql);
	disStmt.setInt(1,boardNo);
	ResultSet disRs = disStmt.executeQuery();
	
	if(disRs.next()){
		int comCnt = disRs.getInt("count(*)");
		if(comCnt>0){
			String msg = URLEncoder.encode("댓글이 있어 게시물 수정이 불가합니다","utf-8");
			response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
			return;
		}
	}
	
	String sql = "UPDATE board SET local_name=?, board_title=?, board_content=?, updatedate=now() where board_no=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,localName);
	stmt.setString(2,boardTitle);
	stmt.setString(3,boardContent);
	stmt.setInt(4,boardNo);
	
	int row = stmt.executeUpdate();
	
	if(row==1){
		String msg = URLEncoder.encode("게시글이 수정되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&msg="+msg);
		System.out.println("row값 정상");
		return;
	}else{
		String msg = URLEncoder.encode("게시글 수정에 실패하였습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertPostForm.jsp?boardNo="+boardNo+"&msg="+msg);
		System.out.println("row값 오류");
		return;
	}
%>