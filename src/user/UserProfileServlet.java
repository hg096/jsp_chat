package user;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("test/html;charset=UTF-8");
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = request.getRealPath("/upload").replaceAll("\\\\", "/");
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "Error Message");
			request.getSession().setAttribute("messageContent", "파일의 용량이 10MB가 넘으면 안됩니다.");
			response.sendRedirect("./user/profileUpdate.jsp");
			return;
		}
		// 유저아이디가 일치하지 않을 때
		String userID = multi.getParameter("userID");
		HttpSession session = request.getSession();
		if(!userID.equals((String) session.getAttribute("userID"))){
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "잘못된 접근입니다!");
			response.sendRedirect("./chat/box.jsp");
			return;
		}
		String fileName = "";
		File file = multi.getFile("userProfile");
		if(file != null) {
			String ext = file.getName().substring(file.getName().lastIndexOf(".") + 1);
			if(ext.equals("jpg") || ext.equals("png") || ext.equals("gif")) {
				String prev = new UserDAO(). getUser(userID).getUserProfile();
				File prevFile = new File(savePath + "/" + prev);
				if(prevFile.exists()) {
					prevFile.delete();
				}
				fileName = file.getName();
			} else {
				if(file.exists()) {
					file.delete();
				}
				session.setAttribute("messageType", "Error Message");
				session.setAttribute("messageContent", "지원하지 않는 파일 확장명입니다.");
				response.sendRedirect("./user/profileUpdate.jsp");
				return;
			}
		}
		new UserDAO().profile(userID, fileName);
		session.setAttribute("messageType", "Success Message");
		session.setAttribute("messageContent", "프로필 변경완료!");
		response.sendRedirect("./chat/box.jsp");
		return;
	}

}
