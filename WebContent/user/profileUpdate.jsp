<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
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
	function passwordCheckFunction() {
		var userPassword1 = $('#userPassword1').val();
		var userPassword2 = $('#userPassword2').val();
		if (userPassword1 != userPassword2) {
			$('#passwordCheckMessage').html('Enter the same passwords.');
		} else {
			$('#passwordCheckMessage').html('');
		}
	}
</script>
</head>
<body>
	<br> <br> <br>
	<div class="container">
		<form method="post" action="../userProfile" enctype="multipart/form-data">
			<table class="table table-bordered table-hover"
				style="text-align: center; border: 1px solid #dddddd"
			>
				<thead>
					<tr>
						<th colspan="2">
							<h4>프로필 사진 추가</h4>
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 100px;">
							<h5>아이디</h5>
						</td>
						<td>
							<h5><%=user.getUserID()%></h5>
							<input type="hidden" name="userID" value="<%=user.getUserID()%>">
						</td>
					</tr>
					<tr>
						<td style="width: 100px;">
							<h5>파일 올리기</h5>
						</td>
						<td colspan="2">
							<input type="file" name="userProfile" class="file">
							<div class="input-group col-xs-8" style="margin: auto;">
								<span class="input-group-addon"><i class="glyphicon glyphicon-picture"></i></span>
								<input type="text" class="form-control input-lg" disabled
									placeholder="이미지를 업로드해주세요"
								>
								<span class="input-group-btn">
									<button type="button" class="browse btn btn-primary input-lg">
										찾기&nbsp;<i class="glyphicon glyphicon-search"></i>
									</button>
								</span>
							</div>
					</tr>
					<tr>
						<td style="text-align: left;" colspan="3">
							<h5 style="color: red;" id="passwordCheckMessage"></h5>
							<button class="btn btn-primary pull-right" type="submit" name="submit">확인</button>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
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
	<script type="text/javascript">
		$(document).on('click', '.browse', function() {
			var file = $(this).parent().parent().parent().find('.file');
			file.trigger('click');
		});
		$(document).on(
				'change',
				'.file',
				function() {
					$(this).parent().find('.form-control').val(
							$(this).val().replace(/C:\\fakepath\\/i, ''));
				});
	</script>
</body>
</html>