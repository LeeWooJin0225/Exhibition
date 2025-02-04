package com.sist.web.model;

import java.io.Serializable;

public class Like implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String userId;
	private long brdSeq;
	
	public Like() {
		userId = "";
		brdSeq = 0;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getBrdSeq() {
		return brdSeq;
	}

	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}
	
	

}
