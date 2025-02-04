package com.sist.web.controller;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Email;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.MailService;
import com.sist.web.service.UserService;
import com.sist.web.util.HttpUtil;


@Controller("mailController")
@EnableAsync//비동기로 동작하게 하는 어노테이션
public class MailController {
		
	@Autowired
	private MailService mailService;
	
	@Autowired
	private UserService userService;
	
	private static Logger logger = LoggerFactory.getLogger(MailController.class);
	
	// 인증번호용 메일 전송
	@RequestMapping(value = "/sendMail.do", method= RequestMethod.POST)
	@ResponseBody
	public Response<Object> sendSimpleMail(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		Response<Object> res = new Response<Object>();
		
		String userEmail = HttpUtil.get(request, "userEmail", "");
		
		// 난수 생성
		int number = (int) ((Math.random() * (90000)) + 100000);
		String code = Integer.toString(number);
		
		if (!StringUtil.isEmpty(userEmail)) {
			request.setCharacterEncoding("utf-8");
			response.setContentType("text/html;charset=utf-8");
			
			String title = "[Spring] 이메일 인증번호 보내드립니다.";
			
			String body = "<html>" 
			        + "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f5f5f5; color: #333333;'>"
			        + "<div style='max-width: 600px; margin: auto; background-color: #ffffff; padding: 40px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);'>"

			        // 상단 로고 섹션
			        + "<header style='text-align: center; padding-bottom: 30px;'>"
			        + "    <h1 style='color: #333399; font-size: 32px; margin: 0; font-weight: bold;'>WOONGJIN 전시회</h1>"
			        + "    <p style='color: #666666; font-size: 16px;'>당신의 예술적 여정을 시작하세요</p>"
			        + "</header>"
			        + "<hr style='border: 0; border-top: 1px solid #dddddd; margin: 20px 0;' />"

			        // 본문 섹션
			        + "<div style='padding: 30px; text-align: center;'>"
			        + "    <h2 style='color: #333399; font-size: 24px;'>인증 코드</h2>"
			        + "    <p style='font-size: 18px; color: #555555; margin: 10px 0;'>아래의 인증 코드를 입력하여 인증을 완료해 주세요:</p>"
			        + "    <p style='font-size: 36px; font-weight: bold; color: #ffffff; background-color: #333399; padding: 15px 25px; border-radius: 8px; display: inline-block; letter-spacing: 3px;'>"
			        + code + "</p>"
			        + "</div>"

			        // 구분선
			        + "<hr style='border: 0; border-top: 1px solid #dddddd; margin: 30px 0;' />"

			        // 하단 안내문
			        + "<footer style='text-align: center; font-size: 12px; color: #888888;'>"
			        + "    <p style='margin: 5px 0;'>※ 본 메일은 자동 발송 메일입니다. 회신하지 마세요.</p>"
			        + "    <p style='font-size: 14px; color: #333399;'>&copy; 2024 WOONGJIN 전시회. All rights reserved.</p>"
			        + "</footer>"

			        + "</div>"
			        + "</body>"
			        + "</html>";

			
			// PrintWriter out = response.getWriter();
			mailService.sendMail(userEmail, title, body);
			
			
			// Email 객체 값 세팅
			Email email = new Email();
			email.setCode(code);
			email.setUserEmail(userEmail);
			
			if (mailService.emailInsert(email) > 0) {
				logger.debug("#######################");
				logger.debug("메일 데이터 삽입 성공");
				logger.debug("#######################");
			}
			else {
				logger.debug("#######################");
				logger.debug("메일 데이터 삽입 실패");
				logger.debug("#######################");
			}
			
			res.setResponse(0, "성공");
			logger.debug("메일 전송 완료");
		}
		else {
			res.setResponse(-1, "실패");
			logger.debug("메일 전송 실패");
		}
		
		return res;
	}
	
	
	// 비밀번호 찾기용 메일 전송
	@RequestMapping(value = "/sendMail.pwd", method= RequestMethod.POST)
	@ResponseBody
	public Response<Object> sendPwdMail (HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		Response<Object> res = new Response<Object>();
		
		String userEmail = HttpUtil.get(request, "userEmail", "");
		String userId = HttpUtil.get(request, "userId", "");
		
		
	     if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userEmail)) {
	    	 
	    	 User user = userService.userSelect(userId);
	    	 
	    	 if (user != null) {
	    		 
	    		 if (StringUtil.equals(user.getUserEmail(), userEmail)) {
	 	 			request.setCharacterEncoding("utf-8");
					response.setContentType("text/html;charset=utf-8");
					
			        // generate temporary password
			        char[] charSet = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
			                'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

			        StringBuilder tempPw = new StringBuilder();

			        for (int i = 0; i < 10; i++) {
			            int idx = (int) (charSet.length * Math.random());
			            tempPw.append(charSet[idx]);
			        }
			        
			        String newPwd = tempPw.toString();
			        
			        user.setUserPwd(newPwd);
			        
					String title = "[Spring] 임시 비밀번호 보내드립니다.";
					
					String body = "<html>"
					        + "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f7f7f7; color: #333;'>"
					        + "<div style='max-width: 600px; margin: auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);'>"

					        // 상단 로고 섹션
					        + "<header style='text-align: center; padding-bottom: 20px;'>"
					        + "    <h2 style='color: #333; font-weight: bold;'>WOONGJIN 전시회</h2>"
					        + "</header>"
					        + "<hr style='border: 0; border-top: 1px solid #dddddd; margin: 20px 0;' />"

					        // 본문 섹션
					        + "<div style='padding: 30px; text-align: center;'>"
					        + "    <h1 style='color: #444; font-size: 24px;'>임시 비밀번호 안내</h1>"
					        + "    <p style='font-size: 18px; color: #666; margin: 10px 0;'>아래의 임시 비밀번호를 사용하여 로그인해 주세요.</p>"
					        + "    <p style='font-size: 28px; font-weight: bold; color: #ffffff; background-color: #1d72b8; padding: 10px 20px; border-radius: 8px; display: inline-block;'>"
					        + newPwd + "</p>"
					        + "    <p style='font-size: 16px; color: #888; margin-top: 20px;'>로그인 후 비밀번호 변경을 권장합니다.</p>"
					        + "</div>"

					        // 구분선
					        + "<hr style='border: 0; border-top: 1px solid #dddddd; margin: 20px 0;' />"

					        // 하단 안내문
					        + "<footer style='text-align: center; font-size: 12px; color: #888888; margin-top: 20px;'>"
					        + "    <p style='margin: 5px 0;'>※ 본 메일은 자동 발송 메일이므로 회신하지 마세요.</p>"
					        + "    <p>&copy; 2024 WOONGJIN 전시회. All rights reserved.</p>"
					        + "</footer>"

					        + "</div>"
					        + "</body>"
					        + "</html>";
					
					// PrintWriter out = response.getWriter();
					mailService.sendMail(userEmail, title, body);
					
					// User 객체 임시 비밀번호로 비밀번호 UPDATE
			        userService.userPwdUpdate(user);
					
					res.setResponse(0, "성공");
					logger.debug("메일 전송 완료");
	    		 }
	    		 else {
	    			 res.setResponse(405, "입력한 이메일 정보가 틀림");
	    		 }

	    	 }
	    	 else {
	    		 res.setResponse(404, "일치하는 회원 정보 없음");
	    	 }
		}
		else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
			logger.debug("메일 전송 실패");
		}
		
		return res;
	}

	
	
	@RequestMapping(value="/mailChk", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> mailChk (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		String authNum = HttpUtil.get(request, "authNum", "");
		String userEmail = HttpUtil.get(request, "userEmail", "");
		
		if (!StringUtil.isEmpty(authNum) && !StringUtil.isEmpty(userEmail)) {
			
			String code = mailService.emailSelect(userEmail);
			
			if (!StringUtil.isEmpty(code)) {
				
				if (StringUtil.equals(code, authNum)) {
					res.setResponse(0, "성공");
				}
				else {
					res.setResponse(-1, "코드 값 틀림");
				}
				
			}
			else {
				res.setResponse(404, "이메일에 해당하는 코드 없음");
			}
			
		}
		else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}
		
		return res;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
}
