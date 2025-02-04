package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.CommentDao;
import com.sist.web.model.Comment;

@Service("commentService")
public class CommentService {

	private static Logger logger = LoggerFactory.getLogger(CommentService.class);
	
	@Autowired
	private CommentDao commDao;
	
	// 댓글 등록
	public int commInsert (Comment comment) {
		int count = 0;
		
		try {
			count = commDao.commInsert(comment);
		} catch (Exception e) {
			logger.error("[CommentService] commInsert SQLException", e);
		}
		
		return count;
	}
	
	// 댓글 조회
	public List<Comment> commList (long brdSeq) {
		List<Comment> list = null;
		
		try {
			list = commDao.commList(brdSeq);
		} catch (Exception e) {
			logger.error("[CommentService] commList SQLException", e);
		}
		
		return list;
	}
	
	// 댓글 수정
	public int commUpdate (Comment comment) {
		int count = 0;
		
		try {
			count = commDao.commUpdate(comment);
		} catch (Exception e) {
			logger.error("[CommentService] commUpdate SQLException", e);
		}
		
		return count;
	}
	
	// 댓글 삭제 (자식 있을 때)
	public int commDelete (long commSeq) {
		int count = 0;
		
		try {
			count = commDao.commDelete(commSeq);
		} catch (Exception e) {
			logger.error("[CommentService] commDelete SQLException", e);
		}
		
		return count;
	}
	
	// 자식 있을 때
	public int commRealDelete (long commSeq) {
		int count = 0;
		
		try {
			count = commDao.commDelete(commSeq);
		} catch (Exception e) {
			logger.error("[CommentService] commRealDelete SQLException", e);
		}
		
		return count;
	}
	
	// 답댓글 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int commReplyInsert (Comment comment) {
		int count = 0;
		
		// ORDER 증가
		commDao.commGroupOrderUpdate(comment);
		// 답댓글 INSERT
		count = commDao.commReplyInsert(comment);
		
		return count;
	}
	
	// 댓글 상세 조회
	public Comment commSelect (long commSeq) {
		Comment comment = null;
		
		try {
			comment = commDao.commSelect(commSeq);
		} catch (Exception e) {
			logger.error("[CommentService] commSelect SQLException", e);
		}
		
		return comment;
		
	}
	
	
	// 댓글 수 조회
	public long commCount (long commSeq) {
		long count = 0;
		
		try {
			count = commDao.commCount(commSeq);
		} catch (Exception e) {
			logger.error("[hiCommService] commCount SQLException", e);
		}
		
		return count;
	}
	
	// 자식 있는지 조회
	public long commChildCount (long commParent) {
		long count = 0;
		
		try {
			count = commDao.commChildCount(commParent);
		} catch (Exception e) {
			logger.error("[hiCommService] commChildCount SQLException", e);
		}
		
		return count;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
