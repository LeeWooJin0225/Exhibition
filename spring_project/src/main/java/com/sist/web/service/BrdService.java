package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.util.FileUtil;
import com.sist.web.dao.BrdDao;
import com.sist.web.model.Brd;
import com.sist.web.model.BrdFile;


@Service("brdService")
public class BrdService {

	private static Logger logger = LoggerFactory.getLogger(BrdService.class);
	
	@Autowired
	private BrdDao brdDao;
	
	// 파일 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	// 게시글 수 조회
	public List<Brd> brdList (Brd brd) {
		List<Brd> list = null;
		
		try {
			list = brdDao.brdList(brd);
		} catch (Exception e) {
			logger.error("[BrdService] brdList SQLException", e);
		}
		
		return list;
	}
	
	// 총 게시글 수 조회
	public long brdListCount (Brd brd) {
		long count = 0;
		
		try {
			count = brdDao.brdListCount(brd);
		} catch (Exception e) {
			logger.error("[BrdService] brdListCount SQLException", e);
		}
		
		return count;
	}
	
	// 게시글 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int brdInsert (Brd brd) throws Exception {
		int count = 0;
		
		count = brdDao.brdInsert(brd);
		
		// 파일이 있다면 삽입
		if (count > 0 && brd.getBrdFile() != null) {
			brd.getBrdFile().setBrdSeq(brd.getBrdSeq());
			brd.getBrdFile().setFileSeq((short)1);
			brdDao.brdFileInsert(brd.getBrdFile());
		}
		
		
		return count;
	}
	
	// 게시글 첨부파일 등록
	public int brdFileInsert (BrdFile brdFile) {
		int count = 0;
		
		try {
			count = brdDao.brdFileInsert(brdFile);
		} catch (Exception e) {
			logger.error("[BrdService] brdFileInsert SQLExcepiton", e);
		}
		
		return count;
	}
	
	// 게시글 상세 조회
	public Brd brdSelect (long brdSeq) {
		Brd brd = null;
		
		try {
			brd = brdDao.brdSelect(brdSeq);
		} catch (Exception e) {
			logger.error("[BrdService] brdSelect SQLExcepiton", e);
		}
		
		return brd;
	}
	
	// 게시글 첨부파일 조회
	public BrdFile brdFileSelect (long brdSeq) {
		BrdFile brdFile = null;
		
		try {
			brdFile = brdDao.brdFileSelect(brdSeq);
		} catch (Exception e) {
			logger.error("[BrdService] brdFileSelect SQLExcepiton", e);
		}
		
		
		return brdFile;
	}
	
	// 게시글 보기
	public Brd brdView (long brdSeq) {
		Brd brd = null;
		
		try {
			brd = brdDao.brdSelect(brdSeq);
			
			if (brd != null) {
				// 조회수 증가
				brdDao.brdReadCntPlus(brdSeq);
				
				// 첨부파일 받기
				BrdFile brdFile = brdDao.brdFileSelect(brdSeq);
				
				if (brdFile != null) {
					brd.setBrdFile(brdFile);
				}
				
			}
			
		} catch (Exception e) {
			logger.error("[BrdService] brdView SQLExcepiton", e);
		}
		
		return brd;
		
	}
	
	// 게시글 수정폼 조회 (첨부파일 포함)
	public Brd brdViewUpdate (long brdSeq) {
		
		Brd brd = null;
		
		try {
			
			brd = brdDao.brdSelect(brdSeq);
			
			if (brd != null) {
				BrdFile brdFile = brdDao.brdFileSelect(brdSeq);
				
				if (brdFile != null) {
					brd.setBrdFile(brdFile);
				}
			}
			
			
		} catch (Exception e) {
			logger.error("[BrdService] brdViewUpdate SQLExcepiton", e);
		}
		
		return brd;
	}
	
	// 게시글 삭제
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int brdDelete (long brdSeq) throws Exception {
		int count = 0;
		
		Brd brd = brdViewUpdate(brdSeq);
		
		if (brd != null) {
			
			if (brd.getBrdFile() != null) {
				
				if (brdDao.brdFileDelete(brdSeq) > 0) {
					
					// 첨부파일 함께 삭제
					FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + 
							brd.getBrdFile().getFileName());
				}
				
			}
			
			count = brdDao.brdDelete(brdSeq);
			
		}
		
		return count;
	}
	
	// 게시글 수정
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int brdUpdate (Brd brd) throws Exception {
		int count = 0;
		
		count = brdDao.brdUpdate(brd);
		
		// 첨부파일이 있을 때
		if (count > 0 && brd.getBrdFile() != null) {
			
			BrdFile delBrdFile = brdDao.brdFileSelect(brd.getBrdSeq());
			
			// 기존 파일이 있으면 삭제
			if (delBrdFile != null) {
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + 
						delBrdFile.getFileName());
				brdDao.brdFileDelete(brd.getBrdSeq());
			}
			
			brd.getBrdFile().setBrdSeq(brd.getBrdSeq());
			brd.getBrdFile().setFileSeq((short)1);
			
			brdDao.brdFileInsert(brd.getBrdFile());
		}
		
		
		return count;
	}

	
	// 게시글 답변 등록 (트랜잭션 처리)
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int brdReplyInsert (Brd brd) throws Exception {
		int count = 0;
		
		// ORDER 증가
		brdDao.brdGroupOrderUpdate(brd);
		// 답글 INSERT
		count = brdDao.brdReplyInsert(brd);
		
		// 게시글 답글이 정상 등록이 되고 나면 첨부 파일도 등록
		if (count > 0 && brd.getBrdFile() != null) {
			
			BrdFile brdFile = brd.getBrdFile();
			brdFile.setBrdSeq(brd.getBrdSeq());
			brdFile.setFileSeq((short) 1);
			
			brdDao.brdFileInsert(brdFile);
		}
		
		return count;
	}
	
	// 전시회 시간에 따른 상태 업데이트
	public int exhiStatusUpdate (Brd brd) {
		int count = 0;
		
		try {
			count = brdDao.exhiStatusUpdate(brd);
		} catch (Exception e) {
			logger.error("[BrdService] exhiStatusUpdate SQLExcepiton", e);
		}
		
		return count;
	}
	
	// 인덱스 페이지 조회수 TOP 7개 뽑기
	public List<Brd> indexSelect () {
		List<Brd> brd = null;
		
		try {
			brd = brdDao.indexSelect();
		} catch (Exception e) {
			logger.error("[BrdService] indexSelect SQLExcepiton", e);
		}
		
		return brd;
	}
	
	
	
	
	
	
	
}
