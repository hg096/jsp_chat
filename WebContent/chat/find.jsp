<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	%>
<head>
<meta charset="UTF-8">
<jsp:include page="../include/head.jsp" />
<jsp:include page="../include/header.jsp" />
<script type="text/javascript">

	function findFunction(){
		var userID = $("#findID").val();
		$.ajax({
			type: 'POST',
			url: '../UserFindServlet',
			data: {userID: userID},
			success: function(result){
				if(result == -1) {
					$('#checkMessage').html('친구의 아이디를 다시 한번 확인해주세요!');
					$('#checkType').attr('class', 'modal-content panel-warning');
					failFriend(); 
				} else {
					$('#checkMessage').html('검색에 성공했습니다!');
					$('#checkType').attr('class', 'modal-content panel-success');
					var data = JSON.parse(result);
					var profile = data.userProfile;
					getFriend(userID, profile); 
				}
				$('#checkModal').modal("show");
			}
		});
	}
	function getFriend(findID , userProfile){
		$('#friendResult').html('<thead>' +
				'<tr>' +
				'<th><h4>친구찾기결과</h4></th>' +
				'</tr>' +
				'</thead>' +
				'<tbody>' +
				'<tr>' +
				'<td style="text-align: center;">' +
				'<image class="media-object img-circle" style="max-width: 150px; margin: 0px auto;" src="' + userProfile + '">' +
				'<h3>' + findID + '</h3><a href="chat.jsp?toID=' + encodeURIComponent(findID) + '" class="btn btn-primary pull-right">' + '메세지 보내기</a></td>' +
				'</tr>' +
				'</tbody>');
	}
	function failFriend(){
		$('#friendResult').html('');
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
	
	 <br> <br> <br> 
	<div class="container">
		<table class="table table-bordered table-hover"
			style="text-align: center; border: 1px solid #dddddd;">
			<thead>
				<tr>
					<th colspan="2"><h4>친구 찾기</h4></th> 
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width: 110px;"><h5>친구 아이디</h5></td>
					<td><input class="form-control" type="text" id="findID" maxlength="20" placeholder="아이디를 검색해주세요" /></td> 
				</tr>
				<tr>
					<td colspan="2"><button class="btn btn-primary pull-right" onclick="findFunction();">검색</button></td> 
				</tr>
			</tbody>
		</table>
	</div>
	<div class="container">
		<table id="friendResult" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
		
		</table>
	</div>
	
	<%
		if(userID != null) {
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