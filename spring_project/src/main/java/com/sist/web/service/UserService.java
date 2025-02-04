package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.UserDao;
import com.sist.web.model.User;

@Service("userService")
public class UserService {
	
	private static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private UserDao userDao;

	// 회원 정보 조회
	public User userSelect (String userId) {
		User user = null;
		
		try {
			user = userDao.userSelect(userId);
		} catch (Exception e) {
			logger.error("[UserService] userSelect SQLException", e);
		}
		
		return user;
	}
	
	// 회원 가입
	public int userInsert (User user) {
		int count = 0;
		
		try {
			count = userDao.userInsert(user);
		} catch (Exception e) {
			logger.error("[UserService] userInsert SQLException", e);
		}
		
		return count;
	}
	
	// 아이디 찾기
	public User idFindSelect (User user) {
		User user1 = null;
		
		try {
			user1 = userDao.idFindSelect(user);
		} catch (Exception e) {
			logger.error("[UserService] idFindSelect SQLException", e);
		}
		
		return user1;
	}
	
	// 회원정보수정
	public int userUpdate (User user) {
		int count = 0;
		
		try {
			count = userDao.userUpdate(user);
		} catch (Exception e) {
			logger.error("[UserService] userUpdate SQLException", e);
		}
		
		return count;
	}
	
	// 임시비밀번호로 수정
	public int userPwdUpdate (User user) {
		int count = 0;
		
		try {
			count = userDao.userPwdUpdate(user);
		} catch (Exception e) {
			logger.error("[UserService] userPwdUpdate SQLException", e);
		}
		
		return count;
	}
	
	// 회원탈퇴
	public int userDelete (String userId) {
		int count = 0;
		
		try {
			count = userDao.userDelete(userId);
		} catch (Exception e) {
			logger.error("[UserService] userDelete SQLException", e);
		}
		
		return count;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
