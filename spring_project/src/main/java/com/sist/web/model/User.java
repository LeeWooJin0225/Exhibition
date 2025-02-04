package com.sist.web.model;

import java.io.Serializable;

public class User implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String userId;			// 회원 아이디
	private String userPwd;			// 회원 비밀번호
	private String userName;		// 회원 이름
	private String status;			// 회원 상태
	private String regDate;			// 회원 가입일
	private String addrCode;		// 우편번호
	private String addrBase;		// 주소
	private String addrDetail;		// 상세 주소
	private String rating;			// 회원 등급
	private String userEmail;		// 사용자 이메일
	private String fileExt;			// 파일 확장자명
	
	public User() {
		userId = "";
		userPwd = "";
		userName = "";
		status = "Y";
		regDate = "";
		addrCode = "";
		addrBase = "";
		addrDetail = "";
		rating = "";
		userEmail = "";
		fileExt = "";
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
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

	public String getAddrCode() {
		return addrCode;
	}

	public void setAddrCode(String addrCode) {
		this.addrCode = addrCode;
	}

	public String getAddrBase() {
		return addrBase;
	}

	public void setAddrBase(String addrBase) {
		this.addrBase = addrBase;
	}

	public String getAddrDetail() {
		return addrDetail;
	}

	public void setAddrDetail(String addrDetail) {
		this.addrDetail = addrDetail;
	}

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}
	
	
	
	
	
}
