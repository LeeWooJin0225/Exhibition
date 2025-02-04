package com.sist.web.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonObject;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Brd;
import com.sist.web.model.Comment;
import com.sist.web.model.Response;
import com.sist.web.service.BrdService;
import com.sist.web.service.CommentService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("commentController")
public class CommentController {

	private static Logger logger = LoggerFactory.getLogger(CommentController.class);
	
	// 쿠키 이름 얻어오기
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	// 의존성 주입
	@Autowired
	private CommentService commService;
	
	@Autowired
	private BrdService brdService;
	
	// 댓글 등록
	@RequestMapping(value="/board/commInsertProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> commInsertProc (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		String commContent = HttpUtil.get(request, "commContent", "");
		
		if (brdSeq > 0 && !StringUtil.isEmpty(commContent)) {
			
			Brd brd = brdService.brdSelect(brdSeq);
			
			if (brd != null) {
				
				Comment comment = new Comment();
				
				comment.setBrdSeq(brdSeq);
				comment.setCommContent(commContent);
				comment.setUserId(cookieUserId);
				comment.setStatus("Y");
				
				if (commService.commInsert(comment) > 0) {
					ajaxResponse.setResponse(0, "success");
				}
				
				else {
					ajaxResponse.setResponse(-1, "bad request");
				}
				
			}
			else {
				ajaxResponse.setResponse(404, "not found");
			}
			
		}
		else {
			// 파라미터 값 X
			ajaxResponse.setResponse(400, "bad request");
		}
		
		
		return ajaxResponse;
	}
	
	// 댓글 조회
	@RequestMapping(value="/board/commList", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> commList (HttpServletRequest request, HttpServletResponse reponse) {
		Response<Object> ajaxResponse = new Response<Object>();
		
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		// list 객체 보내기
		List<Comment> list = commService.commList(brdSeq);
		// JSON 리스트
		List<JsonObject> jsonArray = new ArrayList<JsonObject>();
		
		for (int i = 0; i < list.size(); i++) {
			JsonObject json = new JsonObject();
			
			// 삭제된 댓글 처리가 되어있고
			if (StringUtil.equals(list.get(i).getStatus(), "N")) {
				logger.debug("111111111111111111 상태 : N임 11111111111111111111");
				
				// 자식이 없다면
				if (commService.commChildCount(list.get(i).getCommSeq()) == 0) {
					logger.debug("222222222222222222 자식 없음 222222222222");
					logger.debug(Double.toString(commService.commChildCount(list.get(i).getCommSeq())));
					// 댓글 삭제
					commService.commRealDelete(list.get(i).getCommSeq());
					logger.debug("33333333333333333 삭제 완료 33333333333333");
					continue;
				}
			}
			
			// 내가 작성한 댓글인지 확인
			if (StringUtil.equals(cookieUserId, list.get(i).getUserId())) {
				list.get(i).setCommMe("Y");
			}
			
			// 부모 이름 가져오기
			if (list.get(i).getCommParent() > 0) {
				Comment parentComm = commService.commSelect(list.get(i).getCommParent());
				json.addProperty("parentCommName", parentComm.getUserName());
			}
			
			String dateAgo = timeAgo(list.get(i).getRegDate());
			
			// 프로필 사진 가져오기
			if (!StringUtil.isEmpty(list.get(i).getFileExt())) {
				json.addProperty("fileExt", list.get(i).getFileExt());
				logger.debug(list.get(i).getFileExt());
			}
			
			json.addProperty("dateAgo", dateAgo);
			json.addProperty("commMe", list.get(i).getCommMe());
			json.addProperty("commSeq", list.get(i).getCommSeq());
			json.addProperty("userId", list.get(i).getUserId());
			json.addProperty("userName", list.get(i).getUserName());
			json.addProperty("commContent", list.get(i).getCommContent());
			json.addProperty("regDate", list.get(i).getRegDate());
			json.addProperty("commIndent", list.get(i).getCommIndent());
			json.addProperty("status", list.get(i).getStatus());
			jsonArray.add(json);
		}
		
		ajaxResponse.setResponse(0, "Success", jsonArray);
		
		return ajaxResponse;
	}
	
	// 시간 계산 메소드
	// regDate를 기준으로 얼마전에 쓴 건지 반환
	public static String timeAgo(String dateString) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");

		try {
			// 문자열을 Date 객체로 변환
			Date postDate = dateFormat.parse(dateString);
			Date now = new Date(); // 현재 시간

			// 두 날짜 간의 차이를 밀리초 단위로 계산
			long diffInMillis = now.getTime() - postDate.getTime();
			long diffInMinutes = diffInMillis / (1000 * 60);

			if (diffInMinutes < 1) {
				return "방금 전";
			} else if (diffInMinutes < 60) {
				return diffInMinutes + "분 전";
			} else if (diffInMinutes < 1440) {
				long hours = diffInMinutes / 60;
				return hours + "시간 전";
			} else if (diffInMinutes < 43200) { // 1440분 * 30일 = 43200분 (약 한 달)
				long days = diffInMinutes / 1440;
				return days + "일 전";
			} else if (diffInMinutes < 525600) { // 43200분 * 12개월 = 525600분 (약 1년)
				long months = diffInMinutes / 43200;
				return months + "달 전";
			} else {
				long years = diffInMinutes / 525600;
				return years + "년 전";
			}
		} catch (ParseException e) {
			e.printStackTrace();
			return "잘못된 날짜 형식입니다";
		}
	}
	
	
	// 댓글 수정
	@RequestMapping(value="/board/commUpdateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> commUpdateProc (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();
		
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		long commSeq = HttpUtil.get(request, "commSeq", (long) 0);
		String newContent = HttpUtil.get(request, "newContent", "");
		
		if (brdSeq > 0) {
			if (commSeq > 0 && !StringUtil.isEmpty(newContent)) {
				
				Comment comment = new Comment();
				
				comment.setCommSeq(commSeq);
				comment.setCommContent(newContent);
				
				if (commService.commUpdate(comment) > 0) {
					ajaxResponse.setResponse(0, "success");
				}
				else {
					ajaxResponse.setResponse(-1, "bad request");
				}
				
			}
			else {
				ajaxResponse.setResponse(400, "bad request");
			}
		}
		else {
			ajaxResponse.setResponse(404, "not found");
		}
		
		
		return ajaxResponse;
		
	}
	
	// 댓글 삭제
	@RequestMapping(value="/board/commDeleteProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> commDeleteProc (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();
		
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		long commSeq = HttpUtil.get(request, "commSeq", (long) 0);
		
		// 자식 댓글이 있는지 확인
		// 자식 댓글이 있다면 상태 UPDATE
		// 자식 댓글이 없다면 DELETE
		
		if (brdSeq > 0) {
			
			if (commSeq > 0) {
			
				if (commService.commDelete(commSeq) > 0) {
					ajaxResponse.setResponse(0, "success");
				}
				else {
					ajaxResponse.setResponse(-1, "bad request");
				}
				
			}
			else {
				ajaxResponse.setResponse(400, "bad request");
			}
			
		}
		else {
			ajaxResponse.setResponse(404, "not found");
		}
		
		
		return ajaxResponse;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
}
