<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%


	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl,dbuser,dbpw);
	
	String sql = "SELECT local_name localName,'대한민국' country,'조동욱' worker FROM local LIMIT 0,1";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	//VO대신에 HashMap 타입을 사용
	
	
	HashMap<String, Object> map = null;
	if(rs.next()){
		//System.out.println(rs.getString("localName"));
		//System.out.println(rs.getString("country"));
		//System.out.println(rs.getString("worker"));
		map = new HashMap<String, Object>();
		map.put("localName",rs.getString("localName")); // map.put(키이름,값);
		map.put("country",rs.getString("country"));
		map.put("worker",rs.getString("worker"));
	}
	
	System.out.println((String)map.get("localName"));
	System.out.println((String)map.get("country"));
	System.out.println((String)map.get("worker"));
	
	String sql2 = "SELECT local_name localName,'대한민국' country,'조동욱' worker FROM local";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	ArrayList<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
	while(rs2.next()){
		HashMap<String,Object> m = new HashMap<String, Object>();
		m.put("localName",rs2.getString("localName"));
		m.put("country",rs2.getString("country"));
		m.put("worker",rs2.getString("worker"));
		list.add(m);
	}
	
	
	String sql3 = "SELECT local_name localName,COUNT(local_name) cnt FROM board GROUP BY local_name";
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	stmt3 = conn.prepareStatement(sql3);
	rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String,Object>> list3 = new ArrayList<HashMap<String,Object>>();
	while(rs3.next()){
		HashMap<String,Object> m = new HashMap<String, Object>();
		m.put("localName",rs3.getString("localName"));
		m.put("cnt",rs3.getInt("cnt"));
		list3.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<hr>
	<h2>rs2 결과셋</h2>
	<table>
		<tr>
			<th>localName</th>
			<th>country</th>
			<th>worker</th>
		</tr>
		<%
			for(HashMap<String,Object> m : list){
		%>
				<tr>
					<td><%=m.get("localName") %></td> 
					<td><%=m.get("country") %></td>
					<td><%=m.get("worker") %></td>
				</tr>
		<%
			}
		%>
	</table>
	<hr>
	<h2>r3 결과셋</h2>
	<ul>
		<li>
			<a href="">전체</a>
		</li>
		<%
			for(HashMap<String,Object> m : list3){
		%>		
				<li>
					<a href=""><%=(String)m.get("localName") %>(<%=(Integer)m.get("cnt") %>)</a>
				</li>
		<%
			}
		%>
	</ul>
</body>
</html>