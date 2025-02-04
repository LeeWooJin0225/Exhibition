package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Like;

@Repository
public interface LikeDao {

	// 좋아요 했는지 체크
	public long likeCount (Like like);
	// 좋아요 증가
	public int likeInsert (Like like);
	// 좋아요 제거
	public int likeDelete (Like like);
	// 좋아요 총 개수
	public long likeTotalCount (long brdSeq);
	
}
