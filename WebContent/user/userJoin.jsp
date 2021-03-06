<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<jsp:include page="../include/head.jsp" />
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID")!=null){ 
			userID = (String)session.getAttribute("userID");
		}
		// 로그인 했는데 가입 페이지로 올때
		if(userID != null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 된 상태입니다.');");
			script.println("location.href = '../lecture/index.jsp';");
			script.println("</script>");
			script.close();
			return;
		}
	%>
	<jsp:include page="../include/header.jsp" />
	<section class="container mt-5" style="max-width: 560px">
		<form action="./userRegisterAction.jsp" method="post">
			<div class="form-group">
				<label for="">아이디</label>
				<input type="text" name="userID" class="form-control" />
			</div>
			<div class="form-group">
				<label for="">비밀번호</label>
				<input type="password" name="userPassword" class="form-control" />
			</div>
			<div class="form-group">
				<label for="">이메일</label>
				<input type="text" name="userEmail" class="form-control" />
			</div>
			<button type="submit" class="btn btn-primary">회원가입</button>
		</form>
	</section>
	<jsp:include page="../include/footer.jsp" />
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="../js/jquery-3.4.1.min.js"></script>
	<script src="../js/popper.min.js"></script>
	<script src="../js/bootstrap.min.js"></script>
</body>
</html>