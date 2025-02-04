package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sist.web.dao.LikeDao;
import com.sist.web.model.Like;

@Service("likeService")
public class LikeService {
	
	private static Logger logger = LoggerFactory.getLogger(LikeService.class);
	
	// 쿠키 이름 얻어오기
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	private LikeDao likeDao;
	
	// 좋아요 체크
	public long likeCount (Like like) {
		long count = 0;
		
		try {
			count = likeDao.likeCount(like);
		} catch (Exception e) {
			logger.error("[LikeService] likeCount SQLException", e);
		}
		
		return count;
	}
	
	// 좋아요 등록
	public int likeInsert (Like like) {
		int count = 0;
		
		try {
			count = likeDao.likeInsert(like);
		} catch (Exception e) {
			logger.error("[LikeService] likeInsert SQLException", e);
		}
		
		return count;
	}
	
	// 좋아요 삭제
	public int likeDelete (Like like) {
		int count = 0;
		
		try {
			count = likeDao.likeDelete(like);
		} catch (Exception e) {
			logger.error("[LikeService] likeDelete SQLException", e);
		}
		
		return count;
	}
	
	// 좋아요 전체 개수 조회
	public long likeTotalCount (long brdSeq) {
		long count = 0;
		
		try {
			count = likeDao.likeTotalCount(brdSeq);
		} catch (Exception e) {
			logger.error("[LikeService] likeTotalCount SQLException", e);
		}
		
		return count;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}
