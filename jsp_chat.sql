
create database export0;
USE export0;

drop table USER;
CREATE TABLE USER (

  userID varchar(50), #작성자 아이디
  userPassword varchar(50), #작성자 비밀번호
  userEmail varchar(50), #작성자 이메일
  userEmailHash varchar(64), #이메일 확인 해시값
  userEmailChecked boolean, #이메일 확인 여부
  userProfile VARCHAR(50)
)DEFAULT CHARSET=utf8;

--
-- 리뷰 
drop table evaluation;
CREATE TABLE EVALUATION (

  evaluationID int PRIMARY KEY AUTO_INCREMENT, #번호
  userID varchar(50), #작성자 아이디
  purchaseName varchar(50), #상품명
  manufacturer varchar(50), #제조사
  purchaseYear int, #구매 연도
  purchaseMonth int, # 구매 월
  categories varchar(50), #카테고리 구분
  evaluationTitle varchar(50), #제목
  evaluationContent varchar(2048), #내용
  price double, #구매가격
  SatisfactionScore varchar(10), #상품만족도 점수
  size varchar(10), #사이즈 
  qualityScore varchar(10), # 상품퀄리티 점수
  likeCount int #추천갯수
);

-- CREATE TABLE EVALUATION (
--   evaluationID int PRIMARY KEY AUTO_INCREMENT, #평가 번호
--   userID varchar(50), #작성자 아이디
--   lectureName varchar(50), #상품명
--   professorName varchar(50), #제조사
--   lectureYear int, #구매 날짜 연도
--   semesterDivide varchar(20), # 구매 월 
--   lectureDivide varchar(10), #카테고리 구분
--   evaluationTitle varchar(50), #제목
--   evaluationContent varchar(2048), #내용
--   totalScore varchar(10), #종합 점수
--   creditScore varchar(10), #상품만족도 점수
--   comfortableScore varchar(10), #사이즈 점수
--   lectureScore varchar(10), # 상품퀄리티 점수
--   likeCount int #추천갯수
-- );


drop table LIKEY;
CREATE TABLE LIKEY (

  userID varchar(50), #작성자 아이디
  evaluationID int, #평가 번호
  userIP varchar(50) #작성자 아이피

);


-- 
-- chat 채팅 
DROP TABLE CHAT; 
CREATE TABLE CHAT (
  chatID INT PRIMARY KEY AUTO_INCREMENT,
  fromID VARCHAR(20),
  toID VARCHAR(20),
  chatContent VARCHAR(100),
  chatTime DATETIME,
  chatRead INT
);

DROP TABLE BOARD; 
CREATE TABLE BOARD (
  userID VARCHAR(20),
  boardID INT PRIMARY KEY,
  boardTitle VARCHAR(50),
  boardContent VARCHAR(2048),
  boardDate DATETIME,
  boardHit INT,
  boardFile VARCHAR(100),
  boardRealFile VARCHAR(100),
  boardGroup INT,
  boardSequence INT,
  boardLevel INT,
  boardAvailable INT
);




















