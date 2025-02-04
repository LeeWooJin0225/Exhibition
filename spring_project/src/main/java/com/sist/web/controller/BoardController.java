package com.sist.web.controller;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Brd;
import com.sist.web.model.BrdFile;
import com.sist.web.model.Comment;
import com.sist.web.model.Like;
import com.sist.web.model.Order;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BrdService;
import com.sist.web.service.CommentService;
import com.sist.web.service.KakaoPayOrderService;
import com.sist.web.service.LikeService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;


@Controller("boardController")
public class BoardController {
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	// 쿠키 이름 얻어오기
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	// 파일 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	// 업로드 파일 저장 경로
	@Value("#{env['profile.save.dir']}")
	private String PROFILE_SAVE_DIR;
	
	@Autowired
	private BrdService brdService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private CommentService commService;
	
	@Autowired
	private KakaoPayOrderService kakaoPayOrderService;
	
	@Autowired
	private LikeService likeService;
	
	// 페이징에 대한 상수 정의
	// 한 페이지의 게시글 수
	private static final int LIST_COUNT = 8;
	// 페이징 수
	private static final int PAGE_COUNT = 5;
	
   // 게시물 종류 별 타이틀
   public String brdTitle(int boardType) {
      if (boardType == 1)
         return "공지사항";
      else if (boardType == 2)
         return "자유게시판";
      else if (boardType == 3)
         return "전시게시판";
      else if (boardType == 4)
         return "1:1문의";
      else if (boardType == 5) 
         return "예매내역";
      else 
    	  return "그 외";
   }

	// ========================================================================================================================================================================================================
	// 게시글 목록 화면
	@RequestMapping(value = "/board/list")
	public String list(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		// 게시판 타입
		int boardType = HttpUtil.get(request, "boardType", 1);
		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		
		// 총 게시글 수
		long totalCount = 0;
		// 게시글 리스트
		List<Brd> list = null;
		// 조회할 객체
		Brd search = new Brd();
		// 페이징 객체 (totalCount가 0 이상일 때만 사용할 것이기 때문에 기본값 null)
		Paging paging = null;
		// 쿠키 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 사용자
		User user = null;
		
		
		// 주문
		Order orderSearch = new Order();
		// 주문내역 게시판용 페이징 객체
		Paging orderPaging = null;
		// 주문내역 총 수 조회
		long orderTotalCount = 0;
		// 주문내역 리스트
		List<Order> orderList = null;
		
		String subBoardType = Integer.toString(boardType);
		// 게시판 타입 설정
		search.setBoardType(subBoardType);
		
		if (boardType != 5) {
			if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
				search.setSearchType(searchType);
				search.setSearchValue(searchValue);
			}
			
			totalCount = brdService.brdListCount(search);
			
			logger.debug("========================================");
			logger.debug("search.getBoardType : " + search.getBoardType());
			logger.debug("totalCount : " + totalCount);
			logger.debug("========================================");
			
			if (totalCount > 0) {
				paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
				
				logger.debug(paging.getListCount() + ", " + paging.getPageCount());
				
				search.setStartRow(paging.getStartRow());
				search.setEndRow(paging.getEndRow());
				
				list = brdService.brdList(search);
			}
			
			if (list != null) {
				
				// 전시 게시판 상태 값
				if (boardType == 3) {
					
					for (int i = 0; i < list.size(); i++) {
						String check = timeStatus(list.get(i).getStartDate(), list.get(i).getEndDate());
						logger.debug("===================================================");
						logger.debug(check);
						logger.debug("===================================================");
						
						// 기존에 있던 상태와 똑같거나 삭제된 게시글이라면 업데이트 안 하고 돌아가기
						if (StringUtil.equals(check, list.get(i).getStatus()) ||
								StringUtil.equals(list.get(i).getStartDate(), "D")) {
							continue;
						}
						
						// 상태 업데이트
						list.get(i).setStatus(check);
						brdService.exhiStatusUpdate(list.get(i));	

						
						logger.debug("===================================================");
						logger.debug("업데이트 성공");
						logger.debug("===================================================");
					}
					
				}
				
				for (int i = 0; i < list.size(); i++) {
					
					BrdFile brdFile = brdService.brdFileSelect(list.get(i).getBrdSeq());
					
					if (brdFile != null) {
						list.get(i).setBrdFile(brdFile);
					}
				}
			}
		}
		else {
			orderTotalCount = kakaoPayOrderService.orderListCount(cookieUserId);
			
			if (orderTotalCount > 0) {
				orderPaging = new Paging("/board/list", orderTotalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
				
				orderSearch.setUserId(cookieUserId);
				orderSearch.setStartRow(orderPaging.getStartRow());
				orderSearch.setEndRow(orderPaging.getEndRow());
				
				orderList = kakaoPayOrderService.orderList(orderSearch);
			}
			
			logger.debug("========================================");
			logger.debug("search.getBoardType : " + search.getBoardType());
			logger.debug("orderTotalCount : " + orderTotalCount);
			logger.debug("========================================");
		}

		user = userService.userSelect(cookieUserId);
		
		if (user != null) {
			model.addAttribute("user", user);
		}
		
		// 주문내역
		model.addAttribute("orderPaging", orderPaging);
		model.addAttribute("orderList", orderList);
		
		model.addAttribute("boardTitle", brdTitle(boardType));
		model.addAttribute("list", list);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		model.addAttribute("boardType", boardType);

		return "/board/list";
	}
	
	// 게시글 쓰기 화면 이동
	@RequestMapping(value="/board/writeForm")
	public String writeForm (ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		// 쿠키 값
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 조회 항목
		String searchType = HttpUtil.get(request, "searchType");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "currPage", (long) 1);
		// 사용자 정보 조회
		User user = userService.userSelect(cookieUserId);
		// 게시판 유형
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		model.addAttribute("cookieUserId", cookieUserId);
		model.addAttribute("boardTitle", brdTitle(boardType));
		model.addAttribute("user", user);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("boardType", boardType);
		
		return "/board/writeForm";
	}
	
	// 게시글 등록
	@RequestMapping(value="/board/writeProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc (MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String brdTitle = HttpUtil.get(request, "brdTitle", "");
		String brdContent = HttpUtil.get(request, "brdContent", "");
		String boardType = HttpUtil.get(request, "boardType", "");
		String status = HttpUtil.get(request, "status", "");
		String startDate = HttpUtil.get(request, "realStartDate", "");
		String endDate = HttpUtil.get(request, "realEndDate", "");
		long price = HttpUtil.get(request, "price", 0);
		
		FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);
				
		if (!StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
			
			Brd brd = new Brd();
			
			// 전시 게시판이라면
			if (StringUtil.equals(boardType, "3")) {
				
				logger.debug("############################################");
				logger.debug("startDate : " + startDate + "endDate : " + endDate + "price : " + price);
				logger.debug("############################################");
				
				if (!StringUtil.isEmpty(startDate) && !StringUtil.isEmpty(endDate) && !StringUtil.isEmpty(price)) {
					
					logger.debug("############################################");
					logger.debug("게시판 관련 INSERT 들어옴");
					logger.debug("############################################");
					
					brd.setStartDate(startDate);
					brd.setEndDate(endDate);
					brd.setPrice(price);
					
					logger.debug("############################################");
					logger.debug("startDate : " + brd.getStartDate() + ", endDate : " + brd.getEndDate() + ", price : " + price);
					logger.debug("############################################");
				}
				else {
					res.setResponse(400, "파라미터 안 넘어옴");
				}
			}

			
			brd.setUserId(cookieUserId);
			brd.setBrdTitle(brdTitle);
			brd.setBrdContent(brdContent);
			brd.setBoardType(boardType);
			brd.setStatus(status);
			
			// 파일이 존재하고 사이즈가 0보다 크다면
			if (fileData != null && fileData.getFileSize() > 0) {
				BrdFile brdFile = new BrdFile();
				
				// 파일 객체 값 설정
				brdFile.setFileName(fileData.getFileName());
				brdFile.setFileOrgName(fileData.getFileOrgName());
				brdFile.setFileExt(fileData.getFileExt());
				brdFile.setFileSize(fileData.getFileSize());
				
				brd.setBrdFile(brdFile);
			}
			
			try {
				
				if (brdService.brdInsert(brd) > 0) {
					res.setResponse(0, "성공");
				}
				else {
					res.setResponse(500, "내부 서버 오류");
				}
				
			} catch (Exception e) {
				logger.error("[BoardController] writeProc SQLExcepiton", e);
			}
			
		}
		else {
			res.setResponse(400, "파라미터 안 넘어옴");
		}
		
		return res;
	}
	
	// 게시글 상세 화면 이동
	@RequestMapping(value="/board/view", method=RequestMethod.POST)
	public String view (ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		// 게시판 유형
		int boardType = HttpUtil.get(request, "boardType", 1);
		// 쿠키 값
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 게시글 번호
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		// 조회 항목
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회 값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 본인글 여부
		String boardMe = "N";
		// 좋아요 했는지 여부
		String likeChk = "N";
		// 좋아요 개수
		long likeCount = 0;
		// 좋아요 총 개수
		long totalLikeCount = 0;
		
		logger.debug("========================================");
		logger.debug("brdSeq : " + brdSeq);
		logger.debug("========================================");
		
		Brd brd = null;
		
		if (brdSeq > 0) {
			
			brd = brdService.brdView(brdSeq);
			
			// 본인 글인지 확인
			if (brd != null && StringUtil.equals(brd.getUserId(), cookieUserId)) {
				boardMe = "Y";
			}
			
			User user = userService.userSelect(cookieUserId);
			
			if (user != null) {
				model.addAttribute("user", user);
			}
			
			Like like = new Like();
			
			like.setBrdSeq(brdSeq);
			like.setUserId(cookieUserId);
			
			likeCount = likeService.likeCount(like);
			totalLikeCount = likeService.likeTotalCount(brdSeq);
			
			// 좋아요를 눌렀다면
			if (likeCount > 0) {
				likeChk = "Y";
			}
		}
		
		logger.debug("#####################################");
		logger.debug("likeChk : " + likeChk);
		logger.debug("#####################################");
		
		model.addAttribute("totalLikeCount", totalLikeCount);
		model.addAttribute("likeChk", likeChk);
		model.addAttribute("cookieUserId", cookieUserId);
		model.addAttribute("boardType", boardType);
		model.addAttribute("brd", brd);
		model.addAttribute("boardMe", boardMe);
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("boardTitle", brdTitle(boardType));
		
		return "/board/view";
	}

	
	// 날짜 지났는지 체크하는 함수
	public static String timeStatus (String startDate, String endDate) {
		
		// O : 현재 진행중 / currentDate보다 startDate가 늦고 endDate가 currentDate보다 이를 때 
		// E : 마감		   / endDate가 currentDate보다 빠를 때
		// C : 아직 안 열림 / startDate가 currentDate보다 늦을 때
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
		
		try {
			// 문자열을 Date 객체로 변환
			Date startDateFormat = dateFormat.parse(startDate);		// 시작 시간
			Date endDateFormat = dateFormat.parse(endDate);			// 마감 시간
			Date now = new Date();	// 현재 시간
			
			logger.debug("======================================================================");
			logger.debug("startDateFormat : " + startDateFormat + ", endDateFormat : " + endDateFormat
					+ ", now : " + now);
			logger.debug("======================================================================");
			
//			public int compareTo(Calendar calendar 2)
//			- 주어진 날짜가 매개변수로 전달받은 날짜와 같을 경우 0을 리턴
//			- 주어진 날짜가 매개변수로 전달받은 날짜보다 클 경우 양수를 리턴 (나중)
//			- 주어진 날짜가 매개변수로 전달받은 날짜보다 작을 경우 음수를 리턴 (이전)
			
			// currentDate보다 startDate가 늦고 endDate가 currentDate보다 이를 때 
			if (startDateFormat.compareTo(now) < 0 && endDateFormat.compareTo(now) > 0) {
				// 현재 진행 중
				return "O";
			}
			//startDate가 currentDate보다 늦을 때
			else if (endDateFormat.compareTo(now) > 0) {
				// 열릴 예정
				return "C";
			}
			// endDate가 currentDate보다 이를 때
			else {
				// 마감
				return "E";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return "잘못된 날짜 형식입니다";
		}
	}

	
	// 첨부파일 다운로드
	@RequestMapping(value="/board/download")
	public ModelAndView download (HttpServletRequest request, HttpServletResponse response) {
		ModelAndView modelAndView = null;
		
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		
		if (brdSeq > 0) {
			
			BrdFile brdFile = brdService.brdFileSelect(brdSeq);
			
			if (brdFile != null) {
				
				File file = new File(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + brdFile.getFileName());
				
				logger.debug("=======================================");
				logger.debug("UPLOAD_SAVE_DIR : " + UPLOAD_SAVE_DIR);
				logger.debug("FileUtil.getFileSeparator() : " + FileUtil.getFileSeparator());
				logger.debug("brdFile.getFileName() : " + brdFile.getFileName());
				logger.debug("brdFile.getFileOrgName() : " + brdFile.getFileOrgName());
				logger.debug("=======================================");
				
				// 파일 존재하는지 확인
				if (FileUtil.isFile(file)) {
					
					modelAndView = new ModelAndView();
					
					// 응답할 View 설정
					modelAndView.setViewName("fileDownloadView");
					modelAndView.addObject("file", file);									// 다운 받을 파일
					modelAndView.addObject("fileName", brdFile.getFileOrgName());		// 다운 받을 파일 이름
					
					return modelAndView;
					
				}
				
			}
			
		}
		
		return modelAndView;
		
	}
	
	// 게시글 수정 화면
	@RequestMapping(value="/board/updateForm")
	public String updateForm (ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		Brd brd = null;
		
		if (brdSeq > 0) {
			
			brd = brdService.brdViewUpdate(brdSeq);
			User user = userService.userSelect(cookieUserId);
			
			if (brd != null) {
				
				if (!StringUtil.equals(brd.getUserId(), cookieUserId)) {
					brd = null;
				}
			}
		}
		
		model.addAttribute("boardTitle", brdTitle(boardType));
		model.addAttribute("boardType", boardType);
		model.addAttribute("brd", brd);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/updateForm";
	}
	
	// 게시글 수정
	@RequestMapping(value="/board/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc (MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		String brdTitle = HttpUtil.get(request, "brdTitle", "");
		String brdContent = HttpUtil.get(request, "brdContent", "");
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);
		
		if (brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
			
			Brd brd = brdService.brdSelect(brdSeq);
			
			if (brd != null) {
				
				if (StringUtil.equals(brd.getUserId(), cookieUserId)) {
					
					brd.setBrdTitle(brdTitle);
					brd.setBrdContent(brdContent);
					
					if (fileData != null && fileData.getFileSize() > 0) {
						
						BrdFile brdFile = new BrdFile();
						
						brdFile.setFileExt(fileData.getFileExt());
						brdFile.setFileName(fileData.getFileName());
						brdFile.setFileOrgName(fileData.getFileOrgName());
						brdFile.setFileSize(fileData.getFileSize());
						
						brd.setBrdFile(brdFile);
					}
					
					try {
						
						if (brdService.brdUpdate(brd) > 0) {
							res.setResponse(0, "success");
						}
						else {
							res.setResponse(500, "error");
						}
						
					} catch (Exception e) {
						logger.error("[BoardController] updateProc SQLException", e);
					}
					
				}
				else {
					res.setResponse(403, "내부 서버 오류");
				}
				
				
			}
			else {
				res.setResponse(404, "찾을 수 없음");
			}
			
			
		}
		else {
			res.setResponse(400, "bad request");
		}
		
		return res;
	}
	
	// 게시글 삭제
	@RequestMapping(value="/board/delete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		
		if (brdSeq > 0) {
			
			Brd brd = brdService.brdSelect(brdSeq);
			User user = userService.userSelect(cookieUserId);
			
			if (brd != null) {
				
				// 관리자 삭제 가능
				if (StringUtil.equals(cookieUserId, brd.getUserId()) || StringUtil.equals(user.getStatus(), "A")) {
					
					try {
						
						if (brdService.brdDelete(brdSeq) > 0) {
							res.setResponse(0, "성공");
						}
						else {
							res.setResponse(500, "서버 에러");
						}
						
					} catch (Exception e) {
						logger.error("[BoardController] delete SQLException", e);
						res.setResponse(500, "서버 에러");
					}
					
				}
				else {
					res.setResponse(403, "서버 에러");
				}
				
			}
			else {
				res.setResponse(404, "찾을 수 없음");
			}
			
		}
		else {
			res.setResponse(400, "bad request");
		}
		
		if (logger.isDebugEnabled()) {
			logger.debug("[BoardController] /delete response\n" + JsonUtil.toJsonPretty(res));
		}
		
		return res;
	}
	
	
	// 게시글 답변 화면 이동
	@RequestMapping(value="/board/replyForm")
	public String replyForm (ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		int boardType = HttpUtil.get(request, "boardType", 1);
		User user = userService.userSelect(cookieUserId);
		
		Brd brd = null;
		
		if (brdSeq > 0) {
			
			brd = brdService.brdSelect(brdSeq);
			
		}
		
		model.addAttribute("user", user);
		model.addAttribute("boardTitle", brdTitle(boardType));
		model.addAttribute("boardType", boardType);
		model.addAttribute("brd", brd);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/replyForm";
	}
	
	
	// 게시글 답변 등록
	@RequestMapping(value="/board/replyProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> replyProc (MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String brdTitle = HttpUtil.get(request, "brdTitle", "");
		String brdContent = HttpUtil.get(request, "brdContent", "");
		String boardType = HttpUtil.get(request, "boardType", "");
		String status = HttpUtil.get(request, "status", "");
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);
		
		// FileData fileData = HttpUtil.getFile(request, "brdFile", PROFILE_SAVE_DIR, 0, cookieUserId);
		
		logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		logger.debug("brdSeq : " + brdSeq);
		logger.debug("boardType : " + boardType);
		logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		
		if (brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent) && !StringUtil.isEmpty(boardType)) {
			
			// 부모 게시글
			Brd parentBrd = brdService.brdSelect(brdSeq);
			
			if (parentBrd != null) {
				
				// 답글 게시글
				Brd brd = new Brd();
				
				brd.setUserId(cookieUserId);
				brd.setBrdTitle(brdTitle);
				brd.setBrdContent(brdContent);
				brd.setBrdGroup(parentBrd.getBrdGroup());
				brd.setBrdOrder(parentBrd.getBrdOrder() + 1);
				brd.setBrdIndent(parentBrd.getBrdIndent() + 1);
				brd.setBrdParent(brdSeq);
				brd.setStatus(status);
				brd.setBoardType(boardType);
				
				// 파일이 있다면
				if (fileData != null && fileData.getFileSize() > 0) {
					
					BrdFile brdFile = new BrdFile();
					
					// 파일 세팅
					brdFile.setFileName(fileData.getFileName());
					brdFile.setFileOrgName(fileData.getFileOrgName());
					brdFile.setFileExt(fileData.getFileExt());
					brdFile.setFileSize(fileData.getFileSize());
					
					brd.setBrdFile(brdFile);
					
				}
				
				try {
					
					if (brdService.brdReplyInsert(brd) > 0) {
						res.setResponse(0, "성공");
					}
					else {
						res.setResponse(500, "내부 서버 오류");
					}
					
				} catch (Exception e) {
					logger.error("[BoardController] replyProc SQLException", e);
					res.setResponse(500, "내부 서버 오류");
				}
				
				
			}
			else {
				res.setResponse(404, "not found");
			}
			
		}
		else {
			res.setResponse(400, "파라미터 값 X");
		}
		
		return res;
		
	}
	
	// 답댓글 등록
	@RequestMapping(value="/board/commReplyInsertProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> commReplyInsertProc (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String replyContent = HttpUtil.get(request, "replyContent", "");
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		long commSeq = HttpUtil.get(request, "commSeq", (long) 0);
		
		if (brdSeq > 0 && commSeq > 0 && !StringUtil.isEmpty(replyContent)) {
			
			// 부모 hiComm
			Comment parentHiComm = commService.commSelect(commSeq);
			
			if (parentHiComm != null) {
				
				// 답글 hiComm
				Comment hiComm = new Comment();
				
				hiComm.setBrdSeq(brdSeq);
				hiComm.setUserId(cookieUserId);
				hiComm.setCommContent(replyContent);
				hiComm.setCommGroup(parentHiComm.getCommGroup());
				hiComm.setCommOrder(parentHiComm.getCommOrder() + 1);
				hiComm.setCommIndent(parentHiComm.getCommIndent() + 1);
				hiComm.setCommParent(commSeq);
				
				try {
					if (commService.commReplyInsert(hiComm) > 0) {
						ajaxResponse.setResponse(0, "success");
					}
					else {
						ajaxResponse.setResponse(500, "internal server error2");
					}
				} catch (Exception e) {
					logger.error("[HiCommController] commReplyInsert SQLException", e);
				}
				
			}
			else {
				ajaxResponse.setResponse(404, "not found");
			}
			
		}
		else {
			ajaxResponse.setResponse(400, "bad request");
		}
		
		
		return ajaxResponse;
	}
	
	// 전시회 게시판 상세화면 이동
	@RequestMapping(value="/board/exhiList")
	public String exhiList (HttpServletRequest request, HttpServletResponse response) {
		
		
		return "/board/exhiList";
	}
	
	
	// 문의게시글 답변 같은 그룹에 속해있으면 보이게 하기
	@RequestMapping(value="/board/isGroup", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> isGroup (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		String brdUserId = HttpUtil.get(request, "brdUserId", "");
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdGroup = HttpUtil.get(request, "brdGroup", 0);
		
		if (!StringUtil.isEmpty(brdSeq) && !StringUtil.isEmpty(brdUserId) && !StringUtil.isEmpty(brdGroup)) {
			
			Brd brd = brdService.brdSelect(brdSeq);
			
			if (brd != null) {

				Brd parentBrd = brdService.brdSelect(brd.getBrdGroup());
				User user = userService.userSelect(cookieUserId);
				
				logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
				logger.debug("brdSeq : " + brdSeq + ", brdUserId : " + brdUserId + ", brdGroup : " + brdGroup + ", brd.getBrdParent() : " 
				+ brd.getBrdParent() + ", parentBrd.getUserId() : " + parentBrd.getUserId()
				+ ", userId " + brdUserId);
				logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
				
				// 부모 게시글과 같은 그룹에 속해있고 로그인 한 유저 아이디와 부모 게시글의 작성자가 같다면
				
				logger.debug("brdGroup : " + brdGroup + ", brd.getBrdParent() : " + brd.getBrdParent()
						+ ", cookieUserId : " + cookieUserId + ", parentBrd.getUserId() : " + parentBrd.getUserId()
						+ ", status : " + user.getStatus());
				
//				if (brdGroup == brd.getBrdParent() || StringUtil.equals(user.getStatus(), "A")) 
				
				if ((brdGroup == brd.getBrdParent() && StringUtil.equals(cookieUserId, parentBrd.getUserId()))
						|| StringUtil.equals(user.getStatus(), "A")) {
					res.setResponse(0, "성공");
				}
				else {
					res.setResponse(-1, "실패");
				}
			}
			else {
				res.setResponse(500, "게시글 없음");
			}
		}
		else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}
		
		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /updateProc response\n" + JsonUtil.toJsonPretty(res));
		}
	      
		
		return res;
	}
	
	
	
	
	
	
	
	
	
}
