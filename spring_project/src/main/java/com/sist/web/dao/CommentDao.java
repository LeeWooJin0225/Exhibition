package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Comment;

@Repository("commentDao")
public interface CommentDao {
	// 댓글 등록
	public int commInsert (Comment comment);
	// 댓글 조회
	public List<Comment> commList (long brdSeq);
	// 댓글 수정
	public int commUpdate (Comment comment);
	// 댓글 삭제 (자식 있을 때)
	public int commDelete (long commSeq);
	// 댓글 삭제 (자식 없을 때)
	public int commRealDelete (long commSeq);
	// 답댓글 등록
	public int commReplyInsert (Comment comment);
	// 댓글 상세 조회
	public Comment commSelect (long commSeq);
	// 댓글 그룹 내 순서 변경
	public int commGroupOrderUpdate(Comment comment);
	// 댓글 수 조회
	public long commCount (long brdSeq);
	// 자식 있는지 조회
	public long commChildCount (long commParent);
}
