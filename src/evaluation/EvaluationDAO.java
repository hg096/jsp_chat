package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class EvaluationDAO {
	// 강의 평가 남기기
	public int write(EvaluationDTO evaluationDTO) {
		String sql = "insert into evaluation values (NULL,?,?,?,?,?,?,?,?,?,?,?,?,0)";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, evaluationDTO.getUserID().replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\r\n", "<br>"));
			pstmt.setString(2, evaluationDTO.getPurchaseName().replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\r\n", "<br>"));
			pstmt.setString(3, evaluationDTO.getManufacturer().replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\r\n", "<br>"));
			pstmt.setInt(4, evaluationDTO.getPurchaseYear());
			pstmt.setInt(5, evaluationDTO.getPurchaseMonth());
			pstmt.setString(6, evaluationDTO.getCategories().replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\r\n", "<br>"));
			pstmt.setString(7, evaluationDTO.getEvaluationTitle().replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\r\n", "<br>"));
			pstmt.setString(8, evaluationDTO.getEvaluationContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\r\n", "<br>"));
			pstmt.setDouble(9, evaluationDTO.getPrice());
			pstmt.setString(10, evaluationDTO.getSatisfactionScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\r\n", "<br>"));
			pstmt.setString(11, evaluationDTO.getSize().replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\r\n", "<br>"));
			pstmt.setString(12, evaluationDTO.getQualityScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\r\n", "<br>"));
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
				if (pstmt != null)
					pstmt.close();
				if (rs != null)
					rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -2; // 데이터베이스 오류
	}

	// 검색기능 포함 평가리스트 가져오기
	public ArrayList<EvaluationDTO> getList(String lectureDivide, String searchType, String search, int pageNumber) {
		if (lectureDivide.equals("전체")) {
			lectureDivide = "";
		}
		ArrayList<EvaluationDTO> evaluationList = null;
		String sql = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		// 6개씩 가져와서 5개씩 끊어서 출력 가져온게 6개 이하일때 페이징기능 잠금
		try {
			if (searchType.equals("최신순")) {
				sql = "select * from evaluation where categories like ? and concat(purchaseName, manufacturer, evaluationTitle, evaluationContent) like "
						+ "? order by evaluationID desc limit " + pageNumber + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("추천순")) {
				sql = "select * from evaluation where categories like ? and concat(purchaseName, manufacturer, evaluationTitle, evaluationContent) like "
						+ "? order by likeCount desc limit " + pageNumber + ", " + pageNumber * 5 + 6;
			}
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%" + lectureDivide + "%");
			pstmt.setString(2, "%" + search + "%");
			rs = pstmt.executeQuery();
			evaluationList = new ArrayList<EvaluationDTO>();
			while (rs.next()) {
				EvaluationDTO evaluation = new EvaluationDTO(rs.getInt(1), rs.getString(2), rs.getString(3),
						rs.getString(4), rs.getInt(5), rs.getInt(6), rs.getString(7), rs.getString(8),
						rs.getString(9), rs.getDouble(10), rs.getString(11), rs.getString(12), rs.getString(13),
						rs.getInt(14));
				evaluationList.add(evaluation);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
				if (pstmt != null)
					pstmt.close();
				if (rs != null)
					rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return evaluationList;
	}

	// 좋아요 기능 
	public int like(String evaluationID) {
		// evaluationID를 찾아서 likeCount를 1씩 증가 
		String sql = "update evaluation set likeCount = likeCount + 1 where evaluationID = ?";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
				if (pstmt != null)
					pstmt.close();
				if (rs != null)
					rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}

	// 삭제기능 강의 평가를 삭제
	public int delete(String evaluationID) {
		String sql = "delete from evaluation where evaluationID = ?";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
				if (pstmt != null)
					pstmt.close();
				if (rs != null)
					rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 데이터베이스 오류
	}

	// 평가 번호로 작성한 유저의 아이디 찾기
	public String getUserID(String evaluationID) {
		String sql = "select userID from evaluation where evaluationID = ?";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
				if (pstmt != null)
					pstmt.close();
				if (rs != null)
					rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null; // 존재하지 않는 강의글
	}

}
