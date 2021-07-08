<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.BoardDTO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<%
String userID = null;
if (session.getAttribute("userID") != null) {
	userID = (String) session.getAttribute("userID");
}
if (userID == null) {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('로그인을 해주세요.');");
	script.println("location.href = '../user/userLogin.jsp';");
	script.println("</script>");
	script.close();
	return;
}
String pageNumber = "1";
if (request.getParameter("pageNumber") != null) {
	pageNumber = request.getParameter("pageNumber");
}
try {
	Integer.parseInt(pageNumber);
} catch (Exception e) {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('잘못된 페이지 입니다!');");
	script.println("location.href = '../user/userLogin.jsp';");
	script.println("</script>");
	script.close();
	return;
}
ArrayList<BoardDTO> boardList = new BoardDAO().getList(pageNumber);
%>
<head>
<meta charset="UTF-8">
<jsp:include page="../include/head.jsp" />
<jsp:include page="../include/header.jsp" />

<script type="text/javascript">
	function getUnread(){
		$.ajax({
			type: "POST",
			url: "../chatUnread",
			data: {
				userID: encodeURIComponent('<%=userID%>
	'),
			},
			success : function(result) {
				if (result >= 1) {
					showUnread(result);
				} else {
					showUnread('');
				}
			}
		});
	}
	function getInfiniteUnread() {
		setInterval(function() {
			getUnread();
		}, 2000);
	}
	function showUnread(result) {
		$('#unread').html(result);
	}
</script>
</head>
<body>
	<br>
	<br>
	<br>
	<div class="container">
		<table class="table table-bordered table-hover"
			style="text-align: center; border: 1px solid #DDDDDD"
		>
			<thead>
				<tr>
					<th colspan="5">
						<h4>게시판</h4>
					</th>
				</tr>
				<tr>
					<th style="background-color: #fafafa; color: #000000; width: 70px;">
						<h5>번호</h5>
					</th>
					<th style="background-color: #fafafa; color: #000000;">
						<h5>제목</h5>
					</th>
					<th style="background-color: #fafafa; color: #000000; width: 100px;">
						<h5>작성자</h5>
					</th>
					<th style="background-color: #fafafa; color: #000000; width: 100px;">
						<h5>날짜</h5>
					</th>
					<th style="background-color: #fafafa; color: #000000; width: 70px;">
						<h5>조회수</h5>
					</th>
				</tr>
			</thead>
			<tbody>
				<%
				for (BoardDTO board : boardList) {
				%>
				<tr>
					<td><%=board.getBoardID()%></td>
					<td style="text-align: left;">
						<a href="boardShow.jsp?boardID=<%=board.getBoardID()%>">
							<%
							for (int j = 0; j < board.getBoardLevel(); j++) {
							%>
							<span class="glyphicon glyphicon-arrow-right" aria-hidden="true";></span>
							<%
							}
							%>
							<%
							if (board.getBoardAvailable() == 0) {
							%>
							(Deleted Post)
							<%
							} else {
							%>
							<%=board.getBoardTitle()%>
							<%
							}
							%>
						</a>
					</td>
					<td><%=board.getUserID()%></td>
					<td><%=board.getBoardDate()%></td>
					<td><%=board.getBoardHit()%></td>
				</tr>
				<%
				}
				%>
				<tr>
					<td colspan="5">
						<a href="boardWrite.jsp" class="btn btn-primary pull-right" type="submit">글쓰기</a>
						<ul class="pagination" style="margin: 0 auto;">
							<%
							int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
							int maxPage = 0;
							if (Integer.parseInt(pageNumber) % 10 == 0)
								startPage -= 10;
							int targetPage = new BoardDAO().targetPage(pageNumber);
							if (startPage != 1) {
							%>
							<li>
								<a href="boardView.jsp?pageNumber=<%=startPage - 1%>">
									<span class="glyphicon glyphicon-chevron-left"></span>
								</a>
							</li>
							<%
							} else {
							%>
							<li>
								<span class="glyphicon glyphicon-chevron-left" style="color: gray;">이전</span>
							</li>
							<%
							}
							for (int i = startPage; i < Integer.parseInt(pageNumber); i++) {
							%>
							<li>
								<a href="boardView.jsp?pageNumber=<%=i%>"><%=i%></a>
							</li>
							<%
							}
							%>
							<li class="active">
								<a href="boardView.jsp?pageNumber=<%=pageNumber%>"><%=pageNumber%></a>
							</li>
							<%
							for (int i = Integer.parseInt(pageNumber) + 1; i <= targetPage + Integer.parseInt(pageNumber); i++) {
								if (i < startPage + 10) {
							%>
							<li>
								<a href="boardView.jsp?pageNumber=<%=i%>"><%=i%></a>
							</li>
							<%
							}
							}
							if (targetPage + Integer.parseInt(pageNumber) > startPage + 9) {
							%>
							<li>
								<a href="boardView.jsp?pageNumber=<%=startPage + 10%>">
									<span class="glyphicon glyphicon-chevron-right"></span>
								</a>
							</li>
							<%
							} else {
							%>
							<li>
								<span class="glyphicon glyphicon-chevron-right" style="color: gray;">다음</span>
							</li>
							<%
							}
							%>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>
	</div>


	<%
	if (userID != null) {
	%>
	<script type="text/javascript">
		$(document).ready(function() {
			getUnread();
			getInfiniteUnread();
		});
	</script>
	<%
	}
	%>

</body>
</html>