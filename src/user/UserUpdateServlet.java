package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserUpdateServlet")
public class UserUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
// 회원 정보 수정
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String userID = request.getParameter("userID");
		HttpSession session = request.getSession();
		String userPassword1 = request.getParameter("userPassword1");
		String userPassword2 = request.getParameter("userPassword2");
		
		String userEmail = request.getParameter("userEmail");
		if (userID == null || userID.equals("") || userPassword1 == null || userPassword1.equals("")
				|| userPassword2 == null
				|| userPassword2.equals("") /*|| userName == null || userName.equals("")
											|| userAge == null || userAge.equals("") || userGender == null || userGender.equals("")
											|| userEmail == null || userEmail.equals("")*/) {
			request.getSession().setAttribute("messageType", "Error Message");
			request.getSession().setAttribute("messageContent", "모든 칸을 입력해주세요!");
			response.sendRedirect("./user/update.jsp");
			return;
		}
		if(!userID.equals((String) session.getAttribute("userID"))){
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "잘못된 접근입니다!");
			response.sendRedirect("./user/login.jsp");
			return;
		}
		if (!userPassword1.equals(userPassword2)) {
			request.getSession().setAttribute("messageType", "Error Message");
			request.getSession().setAttribute("messageContent", "같은 비밀번호를 입력해주세요.");
			response.sendRedirect("./user/update.jsp");
			return;
		}
		int result = new UserDAO().update(userID,
				userPassword1/*, userName, userAge, userGender*/, userEmail);
		
		if (result == 1) {
			request.getSession().setAttribute("userID", userID);
			request.getSession().setAttribute("messageType", "Confirm Message");
			request.getSession().setAttribute("messageContent", "수정 성공!");
			response.sendRedirect("./chat/box.jsp");
			return;
		} else {
			request.getSession().setAttribute("messageType", "Confirm Message");
			request.getSession().setAttribute("messageContent", "데이터베이스 에러!");
			response.sendRedirect("./user/update.jsp");
			return;
		}
	}
}
