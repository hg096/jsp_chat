<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%
String userID = null;
if (session.getAttribute("userID") != null) {
	userID = (String) session.getAttribute("userID");
}
%>

 <%-- <jsp:include page="../include/head.jsp" /> --%>
 
<nav class="navbar navbar-expand-lg navbar-dark  bg-info fixed-top"><!-- fixed-top 상단 고정  -->
	<a class="navbar-brand" href="../lecture/index.jsp">리뷰사이트</a>
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
		<span class="navbar-toggler-icon"></span>
	</button>
	<div id="navbar" class="collapse navbar-collapse">
		<ul class="navbar-nav mr-auto">
			<li class="nav-item">
				<a href="../lecture/index.jsp" class="nav-link">메인</a>
			</li>
			<!-- 추가 -->
			<li>
				<a href="../chat/find.jsp" class="nav-link">친구찾기</a>
			</li>
			<li>
				<a href="../chat/box.jsp" class="nav-link">
					메시지함<span id="unread" class="label label-info"></span>
				</a>
			</li>
			<li>
				<a href="../board/boardView.jsp" class="nav-link">게시판</a>
			</li>
			<!--  -->
			<li class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
					회원 관리 </a>
				<div class="dropdown-menu" aria-labelledby="dropdown">
					<%
					if (userID == null) {
					%>
					<a href="../user/userLogin.jsp" class="dropdown-item">로그인</a>
					<a href="../user/userJoin.jsp" class="dropdown-item">회원가입</a>
					<%
					} else {
					%>
					<!-- 추가 -->
					<a href="../user/update.jsp"class="dropdown-item">정보수정</a>
					<a href="../user/profileUpdate.jsp"class="dropdown-item">프로필사진</a>
					<!--  -->
					<a href="../user/userLogout.jsp" class="dropdown-item">로그아웃</a>
					<%
					}
					%>
				</div>
			</li>


		</ul>
	<!-- 	<form action="../lecture/index.jsp" class="form-inline my-2 my-lg-0">
			<input type="text" name="search" class="form-control mr-sm-2" placeholder="내용을 입력하세요."
				aria-label="search"
			/>
			<button type="submit" class="btn btn-outline-success my-2 my-sm-0">검색</button>
		</form> -->
	</div>
</nav>