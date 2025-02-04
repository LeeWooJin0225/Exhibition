package com.sist.web.model;

import java.io.Serializable;

public class BrdFile implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long brdSeq;				// 게시글 번호
	private long fileSeq;				// 파일 번호
	private String fileOrgName;			// 원본파일명
	private String fileName;			// 파일명
	private String fileExt;				// 파일 확장자명
	private long fileSize;				// 파일 크기
	private String regDate;				// 파일 등록일
	
	public BrdFile() {
		brdSeq = 0;
		fileSeq = 0;
		fileOrgName = "";
		fileName = "";
		fileExt = "";
		fileSize = 0;
		regDate = "";
	}

	public long getBrdSeq() {
		return brdSeq;
	}

	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}

	public long getFileSeq() {
		return fileSeq;
	}

	public void setFileSeq(long fileSeq) {
		this.fileSeq = fileSeq;
	}

	public String getFileOrgName() {
		return fileOrgName;
	}

	public void setFileOrgName(String fileOrgName) {
		this.fileOrgName = fileOrgName;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	
	

}
