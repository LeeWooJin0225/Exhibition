package com.sist.web.model;

import java.io.Serializable;

public class Brd implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long brdSeq;				// 게시글 번호 (시퀀스: SEQ_BRD_SEQ)
	private String userId;				// 사용자 아이디
	private String userName;			// 사용자 이름
	private String userEmail;			// 사용자 이메일
	private long brdGroup;				// 그룹 번호
	private int brdOrder;				// 그룹 내 순서
	private int brdIndent;				// 들여쓰기
	private String brdTitle;			// 게시글 제목
	private String brdContent;			// 게시글 내용
	private int brdReadCnt;				// 게시글 조회수
	private String regDate;				// 게시글 등록일
	private String modiDate;			// 게시글 수정일
	private long brdParent;				// 부모 게시글 번호
	private String status;				// 게시글 상태
	private String startDate;			// 전시 시작일
	private String endDate;				// 전시 마감일
	private String boardType;			// 게시글 타입
	
	private String searchType;			// 검색 타입 (1 : 이름, 2 : 제목, 3 : 내용)
	private String searchValue;			// 검색 값
	
	private long startRow;				// 시작 페이지 번호
	private long endRow;				// 마지막 페이지 번호
	
	private BrdFile brdFile;			// 파일 객체 저장
	
	private long commCount;				// 댓글 수
	private long price;					// 전시회 가격
	
	private String dateAgo;				// 몇분전 표시
		
	public Brd() {
		brdSeq = 0;
		userId = "";
		userName = "";
		userEmail = "";
		brdGroup = 0;
		brdOrder = 0;
		brdIndent = 0;
		brdTitle = "";
		brdContent = "";
		brdReadCnt = 0;
		regDate = "";
		modiDate = "";
		brdParent = 0;
		status = "";
		startDate = "";
		endDate = "";
		boardType = "";
		
		searchType = "";
		searchValue = "";
		
		startRow = 0;
		endRow = 0;
		
		brdFile = null;
		commCount = 0;
		price = 0;
		
		dateAgo = "";
	}

	public long getBrdSeq() {
		return brdSeq;
	}

	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public long getBrdGroup() {
		return brdGroup;
	}

	public void setBrdGroup(long brdGroup) {
		this.brdGroup = brdGroup;
	}

	public int getBrdOrder() {
		return brdOrder;
	}

	public void setBrdOrder(int brdOrder) {
		this.brdOrder = brdOrder;
	}

	public int getBrdIndent() {
		return brdIndent;
	}

	public void setBrdIndent(int brdIndent) {
		this.brdIndent = brdIndent;
	}

	public String getBrdTitle() {
		return brdTitle;
	}

	public void setBrdTitle(String brdTitle) {
		this.brdTitle = brdTitle;
	}

	public String getBrdContent() {
		return brdContent;
	}

	public void setBrdContent(String brdContent) {
		this.brdContent = brdContent;
	}

	public int getBrdReadCnt() {
		return brdReadCnt;
	}

	public void setBrdReadCnt(int brdReadCnt) {
		this.brdReadCnt = brdReadCnt;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getModiDate() {
		return modiDate;
	}

	public void setModiDate(String modiDate) {
		this.modiDate = modiDate;
	}

	public long getBrdParent() {
		return brdParent;
	}

	public void setBrdParent(long brdParent) {
		this.brdParent = brdParent;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}


	public String getBoardType() {
		return boardType;
	}

	public void setBoardType(String boardType) {
		this.boardType = boardType;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}

	public BrdFile getBrdFile() {
		return brdFile;
	}

	public void setBrdFile(BrdFile brdFile) {
		this.brdFile = brdFile;
	}

	public long getCommCount() {
		return commCount;
	}

	public void setCommCount(long commCount) {
		this.commCount = commCount;
	}

	public long getPrice() {
		return price;
	}

	public void setPrice(long price) {
		this.price = price;
	}

	public String getDateAgo() {
		return dateAgo;
	}

	public void setDateAgo(String dateAgo) {
		this.dateAgo = dateAgo;
	}
	
	
	

}
