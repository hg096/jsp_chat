<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
<%
String userID = null;
if (session.getAttribute("userID") != null) {
	userID = (String) session.getAttribute("userID");
}
%>
<head>
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

<!-- 스타일, 부트스트랩 등등 -->
<body>
	<%
	request.setCharacterEncoding("UTF-8");
	String categories = "전체";
	String searchType = "최신순";
	String search = "";

	int pageNumber = 0;
	if (request.getParameter("categories") != null) {
		categories = request.getParameter("categories");
	}
	if (request.getParameter("searchType") != null) {
		searchType = request.getParameter("searchType");
	}
	if (request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if (request.getParameter("pageNumber") != null) {
		try {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		} catch (Exception e) {
			System.out.println("검색 페이지 번호 오류");
		}
	}
	/* 로그인 아이디 가져오기 String userID = null; 상단으로 올라감 11 */

	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	/* 로그인 아이디가 없을 때 */
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = '../user/userLogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	/* 이메일 인증을 받지않았을 때 */
	boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
	if (emailChecked == false) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = '../email/emailSendConfirm.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	%>
	<!-- 메뉴바  -->
	<jsp:include page="../include/head.jsp" />
	<jsp:include page="../include/header.jsp" />
	<!-- 검색기능 -->
	<section class="container">
		<form method="get" action="../lecture/index.jsp" class="form-inline mt-3">
			<select name="categories" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="옷" <%if (categories.equals("옷"))
	out.println("selected");%>>옷</option>
				<option value="악세사리" <%if (categories.equals("악세사리"))
	out.println("selected");%>>악세사리</option>
				<option value="모자/신발" <%if (categories.equals("모자/신발"))
	out.println("selected");%>>모자/신발</option>
				<option value="시계" <%if (categories.equals("시계"))
	out.println("selected");%>>시계</option>
				<option value="취미" <%if (categories.equals("취미"))
	out.println("selected");%>>취미</option>
				<option value="전자기기" <%if (categories.equals("전자기기"))
	out.println("selected");%>>전자기기</option>
				<option value="기타" <%if (categories.equals("기타"))
	out.println("selected");%>>기타</option>
			</select>
			<select name="searchType" id="" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<option value="추천순" <%if (categories.equals("추천순"))
	out.println("selected");%>>추천순</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요" />
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a href="#registerModal" class="btn btn-primary mx-1 mt-2" data-toggle="modal">등록하기</a>
			<a href="#reportModal" class="btn btn-danger mx-1 mt-2" data-toggle="modal">신고</a>
		</form>

		<br>
		<br>
		<%
		/* 5개씩 가져오기 */
		ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
		evaluationList = new EvaluationDAO().getList(categories, searchType, search, pageNumber);
		if (evaluationList != null) {
			for (int i = 0; i < evaluationList.size(); i++) {
				if (i == 5)
			break;
				EvaluationDTO evaluation = evaluationList.get(i);
		%>
		<!-- 강의 평가 가져오기 -->
		<div class="card bg-light mt-3 font-weight-bold">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">
						<!--  -->
						<%=evaluation.getPurchaseName()%>

						<small><%=evaluation.getManufacturer()%> - <%=evaluation.getUserID()%></small>
					</div>
					<div class="col-4 text-right">
						<span style="color: gray;"><%=evaluation.getCategories()%></span> - <span
							style="color: red;"
						><%=evaluation.getPrice()%> 만원</span>
					</div>
				</div>
			</div>
			<!-- 평가 리스트 -->
			<div class="card-body">
				<h3 class="card-title font-weight-bold">
					<!-- 제목 / 년도 -->
					<%=evaluation.getEvaluationTitle()%>
					<small>(<%=evaluation.getPurchaseYear()%>)
					</small>
				</h3>
				<!-- 내용 -->
				<br>
				<p class="card-text"><%=evaluation.getEvaluationContent()%></p>
				<div class="row">
					<!-- 평가 -->
					<div class="col-9 text-left">
						상품만족도 <span style="color: maroon;"><%=evaluation.getSatisfactionScore()%></span> 사이즈
						<span style="color: maroon;"><%=evaluation.getSize()%></span> 상품퀄리티 <span
							style="color: maroon;"
						><%=evaluation.getQualityScore()%></span> <span style="color: green">(추천:<%=evaluation.getLikeCount()%>)
						</span>
					</div>
					<!-- 로그인 아이디에 따라 항목 변경 -->
					<div class="col-3 text-right">
						<%
						if (!userID.equals(evaluation.getUserID())) {
						%>
						<a onclick="return confirm('추천하시겠습니까?')"
							href="./likeAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>"
						>추천</a>
						<%
						} else {
						%>
						<a onclick="return confirm('삭제하시겠습니까?')"
							href="./deleteAction.jsp?evaluationID=<%=evaluation.getEvaluationID()%>"
							style="color: red"
						>삭제</a>
						<%}%>
					</div>
				</div>
			</div>
		</div>
		<%
		}
		}
		%>

	</section>
	<div class="text-center">
		<!-- 페이지 네이션 -->
		<nav aria-label="Page navigation">
			<ul class="pagination">
				<li class="page-item">
					<!-- 페이지의 값이 0일때 잠금 초기값은 0 -->
					<%
					if (pageNumber <= 0) {
					%>
					<a class="page-link disabled">이전</a>
					<%
					} else {
					%>
					<a class="page-link"
						href="../lecture/index.jsp
				?lectureDivide=<%=URLEncoder.encode(categories, "UTF-8")%>
				&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>
				&search=<%=URLEncoder.encode(search, "UTF-8")%>
				&pageNumber=<%=pageNumber - 1%>"
					>이전</a>
					<%
					}
					%>
				</li>

				<li class="page-item">
					<!-- EvaluationDAO에서 글을 한번에 6개씩 가져오는데 5개만 출력한다
			 그래서 다음을 눌렀을때 5개이하로 출력된다는 것은 6개를 가져오지 못하고 다음 페이지가 없음  -->
					<%
					if (evaluationList.size() < 6) {
					%>
					<a class="page-link disabled">다음</a>
					<%
					} else {
					%>
					<a class="page-link"
						href="../lecture/index.jsp
				?lectureDivide=<%=URLEncoder.encode(categories, "UTF-8")%>
				&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>
				&search=<%=URLEncoder.encode(search, "UTF-8")%>
				&pageNumber=<%=pageNumber + 1%>"
					>다음</a>
					<%
					}
					%>
				</li>
			</ul>
		</nav>
	</div>
	<!-- 모달 사용으로 강의 평가 등록 -->
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog"
		aria-labelledby="modal"
	>
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h2 class="modal-title" id="modal">리뷰 등록</h2>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="../lecture/evaluationRegisterAction.jsp" method="post">
						<div class="form-row">
							<div class="form-group col-sm-6">
								<label for="purchaseName">상품명</label>
								<input type="text" name="purchaseName" id="purchaseName" class="form-control"
									maxlength="20"
								/>
							</div>
							<div class="form-group col-sm-6">
								<label for="manufacturer">제조사</label>
								<input type="text" name="manufacturer" id="manufacturer" class="form-control"
									maxlength="20"
								/>
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-4">
								<label for="purchaseYear">구매 연도</label>
								<select name="purchaseYear" id="purchaseYear" class="form-control">
									<option value="2021" selected>2021</option>
									<option value="2020">2020</option>
									<option value="2019">2019</option>
									<option value="2019">2018</option>
									<option value="2019">2017</option>
									<option value="2019">2016</option>
									<option value="2019">2015</option>
									<option value="2019">2014</option>
									<option value="2019">2013</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label for="purchaseMonth">구매 월</label>
								<select name="purchaseMonth" id="purchaseMonth" class="form-control">
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									<option value="6">6</option>
									<option value="7">7</option>
									<option value="8">8</option>
									<option value="9">9</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label for="categories">카테고리</label>
								<select name="categories" id="categories" class="form-control">
									<option value="옷" <%if (categories.equals("옷"))
	out.println("selected");%>>옷</option>
									<option value="악세사리" <%if (categories.equals("악세사리"))
	out.println("selected");%>>악세사리</option>
									<option value="모자/신발" <%if (categories.equals("모자/신발"))
	out.println("selected");%>>모자/신발</option>
									<option value="시계" <%if (categories.equals("시계"))
	out.println("selected");%>>시계</option>
									<option value="취미" <%if (categories.equals("취미"))
	out.println("selected");%>>취미</option>
									<option value="전자기기" <%if (categories.equals("전자기기"))
	out.println("selected");%>>전자기기</option>
									<option value="기타" <%if (categories.equals("기타"))
	out.println("selected");%>>기타</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="evaluationTitle">제목</label>
							<input name="evaluationTitle" id="evaluationTitle" class="form-control"
								maxlength="30"
							>
						</div>
						<div class="form-group">
							<label for="evaluationContent">내용</label>
							<textarea name="evaluationContent" id="evaluationContent" class="form-control"
								maxlength="2048" style="height: 180px"
							></textarea>
						</div>
						<div class="form-row">
							<div class="form-group col-sm-3">
								<label for="price">구매가격(만원)</label>
								<!-- 숫자만 입력받고 step 0.1로 소수점 한자리까지 입력 받음 -->
								<input name="price" id="price" class="form-control" maxlength="20"
									style="height: 35px" type="number" step="0.1"
								></input>

							</div>
							<div class="form-group col-sm-3">
								<label for="SatisfactionScore">상품만족도</label>
								<select name="SatisfactionScore" id="SatisfactionScore" class="form-control">
									<option value="매우 만족" selected>매우 만족</option>
									<option value="만족">만족</option>
									<option value="보통">보통</option>
									<option value="불만">불만</option>
									<option value="매우 불만족">매우 불만족</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label for="size">사이즈</label>
								<select name="size" id="size" class="form-control">
									<option value="SS(85)" selected>SS(85)</option>
									<option value="S(90)">S(90)</option>
									<option value="M(95)">M(95)</option>
									<option value="L(100)">L(100)</option>
									<option value="XL(105)">XL(105)</option>
									<option value="XXL(110)">XXL(110)</option>
									<option value="FREE">FREE</option>
									<option value="없음">없음</option>
								</select>
							</div>
							<div class="form-group col-sm-3">
								<label for="qualityScore">상품퀄리티</label>
								<select name="qualityScore" id="qualityScore" class="form-control">
									<option value="매우 만족" selected>매우 만족</option>
									<option value="만족">만족</option>
									<option value="보통">보통</option>
									<option value="불만">불만</option>
									<option value="매우 불만족">매우 불만족</option>

								</select>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="reportModal" tabindex="-1" role="dialog"
		aria-labelledby="modal"
	>
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="../lecture/reportAction.jsp" method="post">
						<div class="form-group">
							<label for="reportTitle">신고 제목</label>
							<input name="reportTitle" id="reportTitle" class="form-control" maxlength="30"
								placeholder="제목을 입력해주세요"
							>
						</div>
						<div class="form-group">
							<label for="reportContent">신고 내용</label>
							<textarea name="reportContent" id="reportContent" class="form-control"
								maxlength="2048" style="height: 180px" placeholder="제목과 함께 신고내용을 상세하게 입력해주세요"
							></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
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


	<jsp:include page="../include/footer.jsp" />
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="../js/jquery-3.4.1.min.js"></script>
	<script src="../js/popper.min.js"></script>
	<script src="../js/bootstrap.min.js"></script>
</body>
</html>