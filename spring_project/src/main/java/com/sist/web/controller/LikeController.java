package com.sist.web.controller;

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

import com.sist.common.util.StringUtil;
import com.sist.web.model.Like;
import com.sist.web.model.Response;
import com.sist.web.service.LikeService;
import com.sist.web.util.HttpUtil;

@Controller("likeController")
public class LikeController {
	private static Logger logger = LoggerFactory.getLogger(LikeController.class);
	
	// 쿠키 이름 얻어오기
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	private LikeService likeService;
	
	@RequestMapping(value="/board/like", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> like (HttpServletRequest request, HttpServletResponse response) {
		
		Response<Object> res = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		long totalCount = 0;
		
		Like like = new Like();
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(brdSeq)) {
			
			like.setBrdSeq(brdSeq);
			like.setUserId(userId);
			
			// 이미 좋아요를 했다면
			if (likeService.likeCount(like) > 0) {
				
				logger.debug("1111111111111111111111");
				
				if (likeService.likeDelete(like) > 0) {
					totalCount = likeService.likeTotalCount(brdSeq);
					res.setResponse(300, "좋아요 취소 완료", totalCount);
				}
				else {
					logger.debug("2222222222222222");
					res.setResponse(303, "좋아요 취소 중 오류 발생");
				}
			}
			else {
				
				if (likeService.likeInsert(like) > 0) {
					totalCount = likeService.likeTotalCount(brdSeq);
					res.setResponse(0, "좋아요 완료", totalCount);
				}
				else {
					logger.debug("333333333333333");
					res.setResponse(-1, "좋아요 삽입 중 오류 발생");
				}
			}
			
		}
		else {
			logger.debug("444444444444444");
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}
		
		
		return res;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
