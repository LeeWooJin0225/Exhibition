package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Brd;
import com.sist.web.model.BrdFile;

@Repository("brdDao")
public interface BrdDao {
	// 게시글 조회
	public List<Brd> brdList (Brd brd);
	// 게시글 수 조회
	public long brdListCount (Brd brd);
	// 게시글 등록
	public int brdInsert (Brd brd);
	// 게시글 첨부파일 등록
	public int brdFileInsert (BrdFile brdFile);
	// 게시글 상세 조회
	public Brd brdSelect (long brdSeq);
	// 게시글 첨부파일 조회
	public BrdFile brdFileSelect (long brdSeq);
	// 게시글 조회수 증가
	public int brdReadCntPlus (long brdSeq);
	// 게시글 삭제
	public int brdDelete (long brdSeq);
	// 게시글 첨부 파일 삭제
	public int brdFileDelete (long brdSeq);
	// 게시글 수정
	public int brdUpdate (Brd brd);
	// 게시글 그룹 내 순서 변경
	public int brdGroupOrderUpdate (Brd brd);
	// 게시글 답변 등록
	public int brdReplyInsert (Brd brd);
	// 전시회 시간에 따른 상태 업데이트
	public int exhiStatusUpdate (Brd brd);
	// 인덱스 페이지 조회
	public List<Brd> indexSelect();
}
