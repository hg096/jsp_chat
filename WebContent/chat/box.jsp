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
	function getUnread() {
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
	function chatBoxFunction() {
		var userID = '<%= userID %>'
		$.ajax({
			type: "POST",
			url: "../chatBox",
			data: {
				userID: encodeURIComponent('<%= userID %>'),
			},
			success: function(data) {
				if (data == "") return;
				else {
					$('#boxTable').html('');
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i = 0; i < result.length; i++) {
						if(result[i][0].value == userID) {
							result[i][0].value = result[i][1].value;
						} else {
							result[i][1].value = result[i][0].value;
						}
						addBox(result[i][0].value, result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value, result[i][5].value);
					}
				}
			}
		});
	}
	function addBox(lastID, toID, chatContent, chatTime, unread, profile){
		$('#boxTable').append('<tr onclick="location.href=\'chat.jsp?toID=' + encodeURIComponent(toID) + '\'">' +
				'<td style="width: 150px;">' +
				'<h5><image class="media-object img-circle" style="margin: 0 auto; max-width: 40px; max-height: 40px; display: inline;" src="'+ profile +'">&nbsp;' +
				lastID + '</h5></td>' +
				'<td>' +
				'<h5>' + chatContent + 
				'&nbsp;<span class="label label-info">' + unread + '</span></h5>' +
				'<div class="pull-right">' + chatTime + '</div>' + 
				'</td>' +
				'</tr>');
	}
	function getInfiniteBox() {
		setInterval(function() {
			chatBoxFunction();
		}, 3000);
	}
</script>
</head>
<body>
	<br> <br> <br> 
	<div class="container">
		<table class="table" style="margin: 0 auto;">
			<thead>
				<tr>
					<th><h4>메세지 리스트</h4></th>
				</tr>
			</thead>
			<div style="overflow-y: auto; width: 100%; max-height: 450px;">
				<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #DDDDDD; margin: 0 auto;">
					<tbody id="boxTable">
					</tbody>
				</table>
			</div>
		</table>
	</div>
	
	
	
	<%
		if (userID != null) {
	%>
	<script type="text/javascript">
		$(document).ready(function() {
			getUnread();
			getInfiniteUnread();
			chatBoxFunction();
			getInfiniteBox();
		});
	</script>
	<%
		}
	%>

</body>
</html>