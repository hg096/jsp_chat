<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.BoardDTO"%>
<!DOCTYPE html>
<html>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) {
		response.sendRedirect("../user/userLogin.jsp");
		return;
	}
	// 게시물 검증
	String boardID = null;
	if (request.getParameter("boardID") != null) {
		boardID = (String) request.getParameter("boardID");
	}
	if(boardID == null || boardID.equals("")) {
		response.sendRedirect("../board/boardView.jsp");
		return;
	}
	BoardDAO boardDAO = new BoardDAO();
	BoardDTO board = boardDAO.getBoard(boardID);
	if(board.getBoardAvailable() == 0) {
		response.sendRedirect("../board/boardView.jsp");
		return;		
	}
	boardDAO.hit(boardID);
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
				userID: encodeURIComponent('<%=userID%>'),
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
	<br> <br> <br> 
	<div class="container">
		<table class="table table-bordered table-hover"
			style="text-align: center; border: 1px solid #DDDDDD">
			<thead>
				<tr>
					<th colspan="5"><h4>게시판</h4></th>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>제목</h5></td>
					<td colspan="3"><h5><%=board.getBoardTitle()%></h5>
					</td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>글쓴이</h5></td>
					<td colspan="3"><h5><%=board.getUserID()%></h5>
					</td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>날짜</h5></td>
					<td><h5><%=board.getBoardDate()%></h5>
					</td>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>조회수</h5></td>
					<td><h5><%=board.getBoardHit() + 1%></h5>
					</td>
				</tr>
				<tr>
					<td
						style="vertical-align: middle; min-height: 150px; background-color: #fafafa; color: #000000; width: 80px;"><h5>내용</h5></td>
					<td colspan="3" style="text-align: left;"><h5><%=board.getBoardContent()%></h5></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>첨부파일</h5></td>
					<td colspan="3"><h5>
							<a href="boardDownload.jsp?boardID=<%=board.getBoardID()%>"><%=board.getBoardFile()%></a>
						</h5></td>
				</tr>
			</thead>
			<tbody>

				<tr>
					<td colspan="5" style="text-align: right;">
						<a href="boardView.jsp"	class="btn btn-primary">돌아가기</a>
						<a href="boardReply.jsp?boardID=<%= board.getBoardID() %>" class="btn btn-primary">답글</a>
					
					<%
						if(userID.equals(board.getUserID())) {
					%>
						<a href="boardUpdate.jsp?boardID=<%=board.getBoardID()%>"
						class="btn btn-primary">수정</a> 
						<a href="../boardDelete?boardID=<%=board.getBoardID()%>"
						class="btn btn-primary" onclick="return confirm('해당 글을 삭제하시겠습니까?')">삭제</a> 
					<%		
						}
					%>
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
		});
	</script>
	<%
		}
	%>

</body>
</html>