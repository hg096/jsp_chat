package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class UserDAO {
	
	// 유저 로그인
	public int login(String userID, String userPassword) {
		String sql = "select userPassword from user where userID = ?";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString(1).contentEquals(userPassword)) {
					return 1; // 로그인 성공
				} else {
					return 0; // 비밀번호 틀림
				}
			}
			return -1; // 아이디 없음
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
	
	// 회원가입 false은 이메일 인증여부 회원가입은 브라우저 내에서 해야함
	public int join(UserDTO user) {
		String sql = "insert into user values (?,?,?,?,false,?)";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserEmail());
			pstmt.setString(4, user.getUserEmailHash());
			
			//
			pstmt.setString(5, user.getUserProfile());
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
		return -1; // 회원가입 실패
	}

	// 회원 이메일 가져오기
	public String getUserEmail(String userID) {
		String sql = "select userEmail from user where userID = ?";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userID);
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
		return null; // 데이터베이스 오류
	}

	// 이메일 인증여부 확인
	public boolean getUserEmailChecked(String userID) {
		String sql = "select userEmailChecked from user where userID = ?";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getBoolean(1);
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
		return false; // 데이터베이스 오류
	}

	// 이메일 인증 승인 처리 
	public boolean setUserEmailChecked(String userID) {
		String sql = "update user set userEmailChecked = true where userID = ?";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DatabaseUtil.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
			return true;
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
		return false; // 데이터베이스 오류
	}
	
	
	// 
	// 추가
	
	// 유저 아이디로 데이터 가져오기
		public UserDTO getUser(String userID) {
			UserDTO user = new UserDTO();
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String SQL = "SELECT * FROM USER WHERE userID = ?";
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					user.setUserID(userID);
					user.setUserPassword(rs.getString("userPassword"));
					user.setUserEmail(rs.getString("userEmail"));
					user.setUserProfile(rs.getString("userProfile"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					if (rs != null)
						rs.close();
					if (pstmt != null)
						pstmt.close();
					if (conn != null)
						conn.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			return user; // Database Error
		}
		// 아이디 중복 체크
		public int registerCheck(String userID) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String SQL = "SELECT * FROM USER WHERE userID = ?";
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				if (rs.next() || userID.equals("")) {
					return 0; // ID is already taken
				} else {
					return 1; // ID is available
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					if (rs != null)
						rs.close();
					if (pstmt != null)
						pstmt.close();
					if (conn != null)
						conn.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			return -1; // Database Error
		}
		
		// 업데이트
		public int update(String userID, String userPassword,/*, String userName, String userAge, String userGender,*/
															String userEmail) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			String SQL = "UPDATE USER SET userPassword=?, userEmail=? WHERE userID=?"; // , userName = ?, userAge = ?, userGender = ?, userEmail = ?
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userPassword);
				/*pstmt.setString(2, userName);
				pstmt.setInt(3, Integer.parseInt(userAge));
				pstmt.setString(4, userGender);*/
				pstmt.setString(2, userEmail);
				pstmt.setString(3, userID);
				return pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					if (pstmt != null)
						pstmt.close();
					if (conn != null)
						conn.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			return -1; // Database Error
		}
		// 프로필 업로드
		public int profile(String userID, String userProfile) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			String SQL = "UPDATE USER SET userProfile = ? WHERE userID = ?";
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userProfile);
				pstmt.setString(2, userID);
				return pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					if (pstmt != null)
						pstmt.close();
					if (conn != null)
						conn.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			return -1; // Database Error
		}
		// 프로필 가져오기 
		public String getProfile(String userID) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String SQL = "SELECT userProfile FROM USER WHERE userID = ?";
			try {
				conn = DatabaseUtil.getConnection();
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					if (rs.getString("userProfile") == null) {
						return "http://localhost:8015/export/images/icon.jpg";
					} else {
						return "http://localhost:8015/export/upload/" + rs.getString("userProfile");
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
					if (rs != null)
						rs.close();
					if (pstmt != null)
						pstmt.close();
					if (conn != null)
						conn.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			return "http://localhost:8015/export/images/icon.jpg"; // Database Error
		}
	
	
}
