<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDTO"%>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	// userID가 없을때 로그인안내와 로그인 페이지로 이동
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = '../user/userLogin.jsp");
		script.println("</script>");
		script.close();
		return;
	}

	// 초기화
	String purchaseName = null;
	String manufacturer = null;
	int purchaseYear = 0;
	int purchaseMonth = 0;
	String categories = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	double price = 0;
	String SatisfactionScore = null;
	String size = null;
	String qualityScore = null;

	// null이 아닐때 가져오기
	if (request.getParameter("purchaseName") != null) {
		purchaseName = request.getParameter("purchaseName");
	}
	if (request.getParameter("manufacturer") != null) {
		manufacturer = request.getParameter("manufacturer");
	}
	if (request.getParameter("purchaseYear") != null) {
		try {
			purchaseYear = Integer.parseInt(request.getParameter("purchaseYear"));
		} catch (Exception e) {
			System.out.println("연도 데이터 오류");
		}
	}
	if (request.getParameter("purchaseMonth") != null) {
		try {
			purchaseMonth = Integer.parseInt(request.getParameter("purchaseMonth"));
		} catch (Exception e) {
			System.out.println("월 데이터 오류");
		}
	}
	if (request.getParameter("categories") != null) {
		categories = request.getParameter("categories");
	}
	if (request.getParameter("evaluationTitle") != null) {
		evaluationTitle = request.getParameter("evaluationTitle");
	}
	if (request.getParameter("evaluationContent") != null) {
		evaluationContent = request.getParameter("evaluationContent");
	}
	if (request.getParameter("price") != null) {
		try {
			price = Double.parseDouble(request.getParameter("price"));
		} catch (Exception e) {
			System.out.println("가격 데이터 오류");
		}
	}
	if (request.getParameter("SatisfactionScore") != null) {
		SatisfactionScore = request.getParameter("SatisfactionScore");
	}
	if (request.getParameter("size") != null) {
		size = request.getParameter("size");
	}
	if (request.getParameter("qualityScore") != null) {
		qualityScore = request.getParameter("qualityScore");
	}

	// 빈칸입력 체크
	if (purchaseName.equals("") || manufacturer.equals("") || purchaseYear == 0 || purchaseMonth == 0
			|| categories.equals("") || evaluationTitle.equals("") || evaluationContent.equals("")
			|| price == 0 || SatisfactionScore.equals("") || size.equals("")
			|| qualityScore.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.')");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	int result = evaluationDAO.write(new EvaluationDTO(0, userID, purchaseName, manufacturer, purchaseYear,
			purchaseMonth, categories, evaluationTitle, evaluationContent, price, SatisfactionScore,
			size, qualityScore, 0));
	if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('강의 평가 등록 실패했습니다.')");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else { // 평가등록 성공시에 이동
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = '../lecture/index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>