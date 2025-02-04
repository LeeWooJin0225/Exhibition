package com.sist.web.model;

import java.io.Serializable;

public class Order implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long orderSeq;			// 주문번호
	private String userId;			// 회원아이디
	private String status;			// 주문상태
	private String regDate;			// 주문일자
	private String viewDate;		// 관람일자
	private int totalAmount;		// 주문 총 금액
	private String tid;				// 카카오페이 TID
	private String exhiName;		// 전시회명
	private long brdSeq;			// 게시글 번호
	private long quantity;			// 수량
	
	private String searchType;			// 검색 타입 (1 : 이름, 2 : 제목, 3 : 내용)
	private String searchValue;			// 검색 값
	
	private long startRow;				// 시작 페이지 번호
	private long endRow;				// 마지막 페이지 번호
	
	String userName;					// 사용자명
	
	
	public Order() {
		orderSeq = 0;
		userId = "";
		status = "미결제";
		regDate = "";
		viewDate = "";
		totalAmount = 0;
		tid = "";
		exhiName = "";
		brdSeq = 0;
		quantity = 0;
		
		searchType = "";
		searchValue = "";
		
		startRow = 0;
		endRow = 0;
		
		userName = "";
	}


	public long getOrderSeq() {
		return orderSeq;
	}


	public void setOrderSeq(long orderSeq) {
		this.orderSeq = orderSeq;
	}


	public String getUserId() {
		return userId;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getStatus() {
		return status;
	}


	public void setStatus(String status) {
		this.status = status;
	}


	public String getRegDate() {
		return regDate;
	}


	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}


	public String getViewDate() {
		return viewDate;
	}


	public void setViewDate(String viewDate) {
		this.viewDate = viewDate;
	}



	public int getTotalAmount() {
		return totalAmount;
	}


	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}


	public String getTid() {
		return tid;
	}


	public void setTid(String tid) {
		this.tid = tid;
	}


	public String getExhiName() {
		return exhiName;
	}


	public void setExhiName(String exhiName) {
		this.exhiName = exhiName;
	}


	public long getBrdSeq() {
		return brdSeq;
	}


	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
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


	public String getUserName() {
		return userName;
	}


	public void setUserName(String userName) {
		this.userName = userName;
	}


	public long getQuantity() {
		return quantity;
	}


	public void setQuantity(long quantity) {
		this.quantity = quantity;
	}
	
	
	
	
	

	
}
