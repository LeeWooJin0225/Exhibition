package com.sist.web.model;

import java.io.Serializable;

public class Comment implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private long commSeq;				// 댓글 번호
	private long brdSeq;				// 게시글 번호
	private String userId;				// 사용자 아이디
	private long commGroup;				// 그룹 번호
	private long commOrder;				// 그룹 내 순서
	private long commIndent;			// 들여쓰기용
	private long commParent;			// 부모 댓글 번호
	private String regDate;				// 댓글 등록일
	private String commContent;			// 댓글 내용
	private String status;				// 댓글 상태 (정상/삭제)
	
	private String userName;			// 사용자 닉네임
	private String commMe;				// 내가 쓴 글인지 확인
	
	private long commCount;				// 댓글 수
	
	private String dateAgo;				// 몇분전 표시
	private String fileExt;				// 확장자명
	
	public Comment() {
		commSeq = 0;
		brdSeq = 0;
		userId = "";
		commGroup = 0;
		commOrder = 0;
		commIndent = 0;
		commParent = 0;
		regDate = "";
		commContent = "";
		status = "Y";
		
		userName = "";
		commMe = "N";
		
		commCount = 0;
		
		dateAgo = "";
		fileExt = "";
	}

	public long getCommSeq() {
		return commSeq;
	}

	public void setCommSeq(long commSeq) {
		this.commSeq = commSeq;
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

	public long getCommGroup() {
		return commGroup;
	}

	public void setCommGroup(long commGroup) {
		this.commGroup = commGroup;
	}

	public long getCommOrder() {
		return commOrder;
	}

	public void setCommOrder(long commOrder) {
		this.commOrder = commOrder;
	}

	public long getCommIndent() {
		return commIndent;
	}

	public void setCommIndent(long commIndent) {
		this.commIndent = commIndent;
	}

	public long getCommParent() {
		return commParent;
	}

	public void setCommParent(long commParent) {
		this.commParent = commParent;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getCommContent() {
		return commContent;
	}

	public void setCommContent(String commContent) {
		this.commContent = commContent;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getCommMe() {
		return commMe;
	}

	public void setCommMe(String commMe) {
		this.commMe = commMe;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public long getCommCount() {
		return commCount;
	}

	public void setCommCount(long commCount) {
		this.commCount = commCount;
	}

	public String getDateAgo() {
		return dateAgo;
	}

	public void setDateAgo(String dateAgo) {
		this.dateAgo = dateAgo;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}
	
	
	
	
	
	
	
}
