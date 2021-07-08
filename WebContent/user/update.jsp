<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html>
<jsp:include page="../include/head.jsp" />
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			response.sendRedirect("../user/userLogin.jsp");
			return;
		}
		UserDTO user = new UserDAO().getUser(userID);
	%>
<head>
<meta charset="UTF-8">

<jsp:include page="../include/header.jsp" />
<script type="text/javascript">

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
	
	function passwordCheckFunction(){
		var userPassword1 = $('#userPassword1').val();
		var userPassword2 = $('#userPassword2').val();
		if(userPassword1 != userPassword2){
			$('#passwordCheckMessage').html('같은 비밀번호를 입력해주세요');
		} else {
			$('#passwordCheckMessage').html('');
		}
	}
</script>
</head>
<body>
	<br> <br> <br>
	<div class="container">
		<form method="post" action="../userUpdate">
			<table class="table table-bordered table-hover"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>프로필 수정</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 100px;"><h5>아이디</h5></td>
						<td><h5><%= user.getUserID() %></h5>
						<input type="hidden" name="userID" value="<%= user.getUserID() %>"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>비밀번호</h5></td>
						<td colspan="2"><input type="password" class="form-control"
							placeholder="비밀번호를 입력해주세요" id="userPassword1" name="userPassword1"
							maxlength="20" onkeyup="passwordCheckFunction();"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>비밀번호 확인</h5></td>
						<td colspan="2"><input type="password" class="form-control"
							placeholder="비밀번호를 한번 더 입력해주세요" id="userPassword2"
							name="userPassword2" maxlength="20"
							onkeyup="passwordCheckFunction();"></td>
					</tr>
					<tr>
						<td style="width: 100px;"><h5>이메일</h5></td>
						<td colspan="2"><input type="email" class="form-control"
							placeholder="이메일" id="userEmail" name="userEmail"
							maxlength="20" value="<%= user.getUserEmail() %>" readonly="readonly"></td>
					</tr> 
					
					<tr>
					<td style="text-align: left;" colspan="3"><h5 style="color: red;" id="passwordCheckMessage"></h5><button class="btn btn-primary pull-right" type="submit" name="submit">수정</button></td>
					</tr>
					
				</tbody>
			</table>
		</form>
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