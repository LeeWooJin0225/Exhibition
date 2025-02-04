package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.User;

@Repository("userDao")
public interface UserDao {
	// 회원 정보 조회
	public User userSelect (String userId);
	// 회원 가입
	public int userInsert (User user);
	// 아이디 찾기
	public User idFindSelect (User user);
	// 회원정보수정
	public int userUpdate (User user);
	// 임시비밀번호로 수정
	public int userPwdUpdate (User user);
	// 회원탈퇴
	public int userDelete (String userId);
	
}
