<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<head>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	String toID = null;
	if (request.getParameter("toID") != null) {
		toID = (String) request.getParameter("toID");
	}
	if (userID == null) {
		response.sendRedirect("../user/userLogin.jsp");
		return;
	}
	if (toID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('받는이의 아이디가 올바르지 않습니다!');");
		script.println("location.href = '../chat/box.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	if(userID.equals(URLDecoder.decode(toID, "UTF-8"))){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('자신에게 메세지를 보낼 수 없습니다!');");
		script.println("location.href = '../chat/box.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	String fromProfile = new UserDAO().getProfile(userID);
	String toProfile = new UserDAO().getProfile(toID);
%>
<meta charset="UTF-8">
<jsp:include page="../include/head.jsp" />
<jsp:include page="../include/header.jsp" />
<script type="text/javascript">
	function autoClosingAlert(selector, delay){
		var alert = $(selector).alert();
		alert.show();
		window.setTimeout(function() { alert.hide() }, delay);
	}
	function submitFunction() {
		var fromID = '<%= userID %>';
		var toID = '<%= toID %>';
		var chatContent = $('#chatContent').val();
		$.ajax({
			type : "POST",
			url : "../chatSubmitServlet",
			data : {
				fromID : encodeURIComponent(fromID),
				toID : encodeURIComponent(toID),
				chatContent : encodeURIComponent(chatContent),
			},
			success : function(result) {
				if (result == 1) {
					autoClosingAlert('#successMessage', 2000);
				} else if (result == 0) {
					autoClosingAlert('#dangerMessage', 2000);
				} else {
					autoClosingAlert('#warningMessage', 2000);
				}
			}
		});
		$('#chatContent').val('');
	}
	var lastID = 0;
	function chatListFunction(type) {
		var fromID = '<%= userID %>';
		var toID = '<%= toID %>';
		$.ajax({
			type: "POST",
			url: "../chatListServlet",
			data: {
				fromID: encodeURIComponent(fromID),
				toID: encodeURIComponent(toID),
				listType: type
			},
			success: function(data) {
				if(data == "") return;
				var parsed = JSON.parse(data);
				var result = parsed.result;
				for(var i = 0; i < result.length; i++){
					if(result[i][0].value == fromID){
						result[i][0].value = "Me";
					}
					addChat(result[i][0].value, result[i][2].value, result[i][3].value);
				}
				lastID = Number(parsed.last);
			}
		});
	}
	function addChat(chatName, chatContent, chatTime){
		if(chatName == 'Me'){
		$('#chatList').append('<div class="row">' +
				'<div class="col-lg-12">' +
				'<div class="media">' +
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" style="width: 30px; height: 30px;"src="<%= fromProfile %>" alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				chatName +
				'<span class="small pull-right">' +
				chatTime +
				'</span>' +
				'</h4>' +
				'<p>' +
				chatContent +
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>');
		} else {
			$('#chatList').append('<div class="row">' +
					'<div class="col-lg-12">' +
					'<div class="media">' +
					'<a class="pull-left" href="#">' +
					'<img class="media-object img-circle" style="width: 30px; height: 30px;"src="<%= toProfile %>" alt="">' +
					'</a>' +
					'<div class="media-body">' +
					'<h4 class="media-heading">' +
					chatName +
					'<span class="small pull-right">' +
					chatTime +
					'</span>' +
					'</h4>' +
					'<p>' +
					chatContent +
					'</p>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'<hr>');
			}
		$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
	}
	function getInfiniteChat() {
		setInterval(function() {
			chatListFunction(lastID);
		}, 3000);
	}
	function getUnread(){
		$.ajax({
			type: "POST",
			url: "../chatUnread",
			data: {
				userID: encodeURIComponent('<%= userID %>'),
			},
			success: function(result) {
				if(result >= 1) {
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
	
	<div class="container bootstrap snippet">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4>
								실시간 채팅
							</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="panel-collapse collapse in">
						<div id="chatList" class="portlet-body chat-widget"
							style="overflow-y: auto; width: auto; height: 600px;"></div>
						<div class="portlet-footer">
							<div class="row" style="height: 90px;">
								<div class="form-group col-xs-10">
									<textarea style="height: 80px;" id="chatContent" name="chatContent"
										class="form-control" placeholder="메세지를 입력해주세요"
										maxlength="100"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right"
										onclick="submitFunction();">보내기</button>
									<div class="clearfix"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="alert alert-success" id="successMessage"
			style="display: none;">
			<strong>메세지 전송성공</strong>
		</div>
		<div class="alert alert-danger" id="dangerMessage"
			style="display: none;">
			<strong>이름과 내용 모두 입력해주세요</strong>
		</div>
		<div class="alert alert-warning" id="warningMessage"
			style="display: none;">
			<strong>데이터베이스 오류</strong>
		</div>
	</div>
	
	
	
	<script type="text/javascript">
	$(document).ready(function() {
		getUnread();
		chatListFunction('0');
		getInfiniteChat();
		getInfiniteUnread();
	});
	</script>
</body>
</html>