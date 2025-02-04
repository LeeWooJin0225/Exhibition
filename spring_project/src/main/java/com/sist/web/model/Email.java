package com.sist.web.model;

import java.io.Serializable;

public class Email implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String userEmail;			// 인증코드 전송 받은 이메일
	private String code;				// 인증코드
	private String regDate;				// 전송코드 보낸 날
	
	public Email() {
		userEmail = "";
		code = "";
		regDate = "";
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	
	
	
	
	
	

}
