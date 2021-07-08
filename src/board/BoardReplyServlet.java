package board;

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

@WebServlet("/BoardReplyServlet")
public class BoardReplyServlet extends HttpServlet {
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
			request.getSession().setAttribute("messageContent", "파일의 크기가 10MB가 넘으면 안됩니다.");
			response.sendRedirect("./user/login.jsp");
			return;
		}
		String userID = multi.getParameter("userID");
		HttpSession session = request.getSession();
		if(!userID.equals((String) session.getAttribute("userID"))){
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "잘못된 접근입니다.");
			response.sendRedirect("./user/login.jsp");
			return;
		}
		String boardTitle = multi.getParameter("boardTitle");
		String boardContent = multi.getParameter("boardContent");
		if(boardTitle == null || boardTitle.equals("") || boardContent == null || boardContent.equals("")) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "모든 빈칸을 채워주세요!");
			response.sendRedirect("./board/boardReply.jsp");
			return;
		}
		String boardFile = "";
		String boardRealFile = "";
		File file = multi.getFile("boardFile");
		if(file != null) {
			boardFile = multi.getOriginalFileName("boardFile");
			boardRealFile = file.getName();
		}
		String boardID = multi.getParameter("boardID");
		if(boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "잘못된 접근입니다.");
			response.sendRedirect("./user/login.jsp");
			return;
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO parent = boardDAO.getBoard(boardID);
		boardDAO.replyUpdate(parent);
		boardDAO.reply(userID, boardTitle, boardContent, boardFile, boardRealFile, parent);
		session.setAttribute("messageType", "Success Message");
		session.setAttribute("messageContent", "댓글 작성 성공!");
		response.sendRedirect("./board/boardView.jsp");
		return;
	}

}
