package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Email;

@Repository("emailDao")
public interface EmailDao {
	// 이메일 인증코드 삽입
	public int emailInsert (Email email);
	// 이메일 인증코드 조회
	public String emailSelect (String email);
	// 이메일 인증코드 삭제
	public int emailDelete (String email);

}
