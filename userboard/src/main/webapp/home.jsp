<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석(컨트롤러 계층)
	// 1) session 내장개체
	// 2) request/reponse JSP내창 객체
	//한글 깨짐 방지
	request.setCharacterEncoding("utf8");
	//현재페이지 선언
	//페이징 설정
	int currentPage = 1;
	//localName을 전체를 기본 설정
	String localName ="전체";
	String search = null;
	
	//유효성 검사
	if(request.getParameter("localName") != null){
		localName = request.getParameter("localName");
		System.out.println("home.localName 유효성검사 실패");
	}
	
	if(request.getParameter("search") != null){
		search = request.getParameter("search");
		System.out.println("home.localName 유효성검사 실패");
	}
	
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		System.out.println("home.currentPage 유효성검사 실패");
	}
	
	//로그인 했을때 로그인 값 받기
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	//디버깅
	System.out.println("loginMemberId-->"+loginMemberId);
	
	//한페이지당 보여줄 게시물의 수
	int rowPerPage = 10;
	//게시물을 보여주기 시작할 DB에서의 row
	int startRow = (currentPage-1)*rowPerPage;

	
	//DB연동
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	//stmt와 rs미리 선언
	PreparedStatement subMenuStmt2 = null;
	ResultSet subMenuRs2 = null;
	PreparedStatement totalStmt = null;
	ResultSet totalRs = null;
	
	//submenu 출력을 위한 쿼리 작성
	//전체항목,각항목 소계 출력과 더불어 게시물의 개수가 0인 카테고리들도 나오도록 작성
	String subMenuSql = "select '전체' localName,count(local_name) cnt from board union all select local_name localName,count(local_name) cnt from board group by local_name"
						+" "+
						"UNION ALL SELECT local_name localName, 0 cnt FROM local WHERE local_name NOT IN (SELECT DISTINCT local_name FROM board)";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	//디버깅
	System.out.println("home.subMenuStmt-->"+subMenuStmt);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	System.out.println("home.subMenuRs-->"+subMenuRs);
	
	//submenu로 나올 게시판 sql 분기 작성
	String subMenuSql2 = null;
	if(localName.equals("전체")){ //전체를 고를시에 where를 구문에서 삭제하여 전체에서 게시판 출력
		if(search!=null){
			subMenuSql2 = "SELECT board_no boardNo, local_name localName,board_title boardTitle,substring(board_content,1,10) boardContent,member_id memberId FROM board WHERE board_content LIKE ? OR member_id LIKE ? OR board_title LIKE ? limit ?,?";
			subMenuStmt2 = conn.prepareStatement(subMenuSql2);
			subMenuStmt2.setString(1, "%" + search + "%");
			subMenuStmt2.setString(2, "%" + search + "%");
			subMenuStmt2.setString(3, "%" + search + "%");
			subMenuStmt2.setInt(4,startRow);
			subMenuStmt2.setInt(5, rowPerPage);
		}else{
			subMenuSql2 = "SELECT board_no boardNo, local_name localName,board_title boardTitle,substring(board_content,1,10) boardContent,member_id memberId FROM board limit ?,?";
			subMenuStmt2 = conn.prepareStatement(subMenuSql2);
			subMenuStmt2.setInt(1,startRow);
			subMenuStmt2.setInt(2,rowPerPage);
			System.out.println("home1.subMenuStmt2-->"+subMenuStmt2);
			System.out.println("전체");
		}
	} else { // ?를 통해 클릭한 값의 localName만 출력
		subMenuSql2 = "SELECT board_no boardNo,local_name localName,board_title boardTitle,substring(board_content,1,10) boardContent,member_id memberId FROM board WHERE local_name = ? limit ?,?";
		subMenuStmt2 = conn.prepareStatement(subMenuSql2);
		subMenuStmt2.setString(1,localName);
		subMenuStmt2.setInt(2,startRow);
		subMenuStmt2.setInt(3,rowPerPage);
		System.out.println("home2.subMenuStmt2-->"+subMenuStmt2);
	}
	subMenuRs2 = subMenuStmt2.executeQuery();
	System.out.println("home.subMenuRs2-->"+subMenuRs2);
	
	//페이지의 전체 행 구하는 쿼리문
	String totalRowSql = null;
	if(localName.equals("전체")){
		if(search!=null){
			totalRowSql = "SELECT '전체', count(*) FROM board WHERE board_content LIKE ? OR member_id LIKE ? OR board_title LIKE ? ";
			totalStmt = conn.prepareStatement(totalRowSql);
			totalStmt.setString(1, "%" + search + "%");
			totalStmt.setString(2, "%" + search + "%");
			totalStmt.setString(3, "%" + search + "%");
		}else{
			totalRowSql = "SELECT '전체', count(*) FROM board ";
			totalStmt = conn.prepareStatement(totalRowSql);
		}
	}else{
		totalRowSql = "SELECT count(*) FROM board WHERE local_name=?";
		totalStmt = conn.prepareStatement(totalRowSql);
		totalStmt.setString(1,localName);
	}
	totalRs = totalStmt.executeQuery();
	//디버깅
	System.out.println("totalStmt-->"+totalStmt);
	System.out.println("totalRs-->"+totalRs);
		
	//전체 페이지수를 구하고
	int totalRow = 0;
	if(totalRs.next()){
		//totalRowSql을 통해 구한 count(*)을 totalRow에 저장
		totalRow=totalRs.getInt("count(*)");
	}
	
	//마지막 페이지는 총게시물의 수 / 페이지당 보여줄 게시물의 갯수
	int lastPage = totalRow/rowPerPage;
	//마지막 페이지가 나머지가 0이 아니면 페이지수 1추가
	if(totalRow%rowPerPage!=0){
		lastPage++;
	}
	
	// subMenuList <-- 모델데이터
	//서브메뉴 작성을 위한 해시맵 작성
	ArrayList<HashMap<String,Object>> subMenuList = new ArrayList<HashMap<String,Object>>();
	while(subMenuRs.next()){
		HashMap<String,Object> m = new HashMap<String,Object>();
		m.put("localName",subMenuRs.getString("localName"));
		m.put("cnt",subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	
	//게시판 작성을 위해 vo 패키지의 class 함수를 통해 값 가져오기 (boardNo는 나중에 게시판 연결을 위해 채택)
	ArrayList<Board> localNameList = new ArrayList<Board>();
	while(subMenuRs2.next()){
		Board b = new Board();
		b.setBoardNo(subMenuRs2.getInt("boardNo"));
		b.setLocalName(subMenuRs2.getString("localName"));
		b.setBoardTitle(subMenuRs2.getString("boardTitle"));
		b.setBoardContent(subMenuRs2.getString("boardContent"));
		b.setMemberId(subMenuRs2.getString("memberId"));
		localNameList.add(b);
	}
	
	//페이지 이동 조건문 작성
	String addPage = "";
	if(localName != null && !localName.equals("")) {
		addPage += "&localName=" + localName;
	}
	if(search != null && !search.equals("")) {
		addPage += "&search=" + search;
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
		<!-- 서브메뉴 (세로) subMenuList모델을 출력 -->
		<hr>
		<div class="row">
			<div class="col-sm-2">
			<h3>카테고리</h3>
				<ul class="list-group" >
					<%
						for(HashMap<String,Object> m : subMenuList){
					%>		
							<li style="width:200px;" class="list-group-item">
								<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
								<%=(String)m.get("localName") %>(<%=(Integer)m.get("cnt") %>)</a>
							</li>
					<%
						}
					%>
				</ul>
			</div>
			
			<!-- 로그인폼 -->
			
			<!-- 개발 환경 및 사항 -->
			<div class="col-sm-10">
				<div class="row">
					<div class="col-sm-2" style="background: grey; color: #FFFFFF;">
					<br>
					<h5 style="text-align: center">-개요-</h5>
						게시판 작성<br>
						기간:23.05~23.05<br>
						인원: 1명
					</div>
					<div class="col-sm-2" style="background: grey; color: #FFFFFF;">
					<br>
					<h5 style="text-align: center">-개발환경-</h5>
						OS:window10<br>
						Tool: Eclipse,HeidiSQL<br>
						DB:MariaDB(3.1.3)<br>
						WAS: Tomcat (10.1.7)
					</div>
					<div class="col-sm-4" style="background: grey; color: #FFFFFF;">
					<br>
					<h5 style="text-align: center">-개발내용-</h5>
						-1~10페이지 이동 기능 구현<br>
						-회원가입,댓글,게시물,카테고리 구현<br>
						-각 항목의 삽입,삭제,수정 기능 구현<br>
						-검색 기능 구현
						-로그인 기능 구현
					</div>
				
					<!-- 로그인 폼 출력 -->
					<div class="col-sm-4">
						<%
							if(session.getAttribute("loginMemberId")==null){//로그인전이면 로그인폼 출력
						%>
								<form action="<%=request.getContextPath() %>/member/loginAction.jsp" method="post">
									<h2>로그인</h2>
									<table class="table table-hover">
										<tr>
											<td>아이디</td>
											<td><input class="form-control" type="text" name="memberId"></td>
										</tr>
										<tr>
											<td>패스워드</td>
											<td><input class="form-control" type="password" name="memberPw"></td>
										</tr>
									</table>
									<button style="float: right;" class="btn btn-primary" type="submit">로그인</button>
								</form>
						<%
							}else{
						%>
								<table class="table">
									<tr>
										<td><%=loginMemberId %>님 접속중 입니다</td>
									</tr>
								</table>
						<%	
							}
						%>
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
					</div><!-- 로그인폼 -->
				</div><!-- row -->
				<!-- 게시판 10개 출력 -->
		<hr>
		<div>
			<table class="table table-hover" style="table-layout: fixed;">
				<tr>
					<thead class="table-dark">
						<th style="width:200px;">카테고리명</th>
						<th style="width:300px;">게시글 제목</th>
						<th style="width:300px;">내용</th>
						<th>작성자</th>
					</thead>
				</tr>
			<%
				for(Board b : localNameList){
			%>
				<tr>
					<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>"><%=b.getLocalName() %></a></td>
					<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>"><%=b.getBoardTitle() %></a></td>
					<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>"><%=b.getBoardContent() %></a></td>
					<td><%=b.getMemberId() %></td>
				</tr>
			<%
				}
			%>
			</table>
		</div>
		
		<!-- 페이징 설정 -->
		<div style="text-align: center">
		<%
			//1~10번을 눌러도 1~10페이지만 출력되도록 설정
			int startPage = ((currentPage-1)/10)*10+1;
			//몇 페이지까지 나오게 하는지 선택 startPage+9와 lastPage중에서 작은 수가 출력된다
			int endPage = Math.min(startPage+9,lastPage);
			
			//startPage숫자가 10초과를 해야 ex)11에서 1로 갈수 있도록 -10으로 설정
			if(startPage>10){
		%>
				<a class="btn btn-primary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=startPage-10%>&addPage=<%=addPage%>">이전</a>
		<%
			}
			//보이는 페이지를 startPage부터 endPage까지 1씩 늘려가며 설정
			for(int i = startPage; i<=endPage; i++){				
		%>
				<a class="<%=currentPage==i ? "btn btn-danger":"btn btn-primary"%>" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=i%>&addPage=<%=addPage%>"><%=i %></a>
		<%
			}
			//currentPage 변수대신 endPage변수를 이용하여 최종페이지 전까지만 출력하도록 변경
			if(endPage<lastPage){
		%>
				<a class="btn btn-primary" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=endPage+1%>&addPage=<%=addPage%>">다음</a>
		<%
			}
		%>
		</div>
			</div><!-- col sm 10 -->
			
			
		</div><!-- 큰row -->
		<!-- 로그인폼 끝 -->
		
	
		
		
		<!-- copyright -->
		<div>
			<%
				//request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response);
				//이 코드 액션태그로 변경하면 아래와 같다
			%>
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	<!-- class con 닫기 -->
	</div>
</body>
</html>