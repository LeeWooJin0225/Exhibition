package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.gson.JsonObject;
import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BrdService;
import com.sist.web.service.MailService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;


@Controller("userController")
public class UserController {

	private static Logger logger = LoggerFactory.getLogger(UserController.class);

	// 쿠키
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	// 업로드 파일 저장 경로
	@Value("#{env['profile.save.dir']}")
	private String PROFILE_SAVE_DIR;
	
	@Autowired
	private MailService mailService;
	
	@Autowired
	private UserService userService;
	
	@RequestMapping(value="/user/userForm")
	public String userForm (HttpServletRequest request, HttpServletResponse response) {
		
		return "/user/userForm";
	}

	// 아이디 중복 검사
	@RequestMapping(value="/user/idDupChk", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idDupChk (HttpServletRequest request, HttpServletResponse response) {
		
		Response<Object> res = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		
		logger.debug("userId : " + userId);
		
		if (!StringUtil.isEmpty(userId)) {
			
			if (userService.userSelect(userId) == null) {
				// 중복 아이디 X
				res.setResponse(0, "Success");
			}
			else {
				res.setResponse(-1, "중복 아이디 존재");
			}
		}
		else {
			res.setResponse(400, "값 안 넘어옴");
		}
		
		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /user/idDupChk res \n" + JsonUtil.toJsonPretty(res));
		}
		
		return res;
	}
	
	// 회원가입
	@RequestMapping(value="/user/regProc", method=RequestMethod.POST)
	@ResponseBody 
	public Response<Object> regProc (MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		String userPwd = HttpUtil.get(request, "userPwd", "");
		String userName = HttpUtil.get(request, "userName", "");
		String addrCode = HttpUtil.get(request, "addrCode", "");
		String addrBase = HttpUtil.get(request, "addrBase", "");
		String addrDetail = HttpUtil.get(request, "addrDetail", "");
		String userEmail = HttpUtil.get(request, "userEmail", "");
		FileData fileData = HttpUtil.getFile(request, "profileImg", PROFILE_SAVE_DIR, 0, userId);
		
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName)
			&& !StringUtil.isEmpty(addrCode) && !StringUtil.isEmpty(addrBase) 
			&& !StringUtil.isEmpty(addrDetail) && !StringUtil.isEmpty(userEmail)) {
			
			if (userService.userSelect(userId) == null) {
				
				User user = new User();
				
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setAddrCode(addrCode);
				user.setAddrBase(addrBase);
				user.setAddrDetail(addrDetail);
				user.setStatus("Y");
				user.setRating("1");
				user.setUserEmail(userEmail);
				
				// 프로필 이미지가 등록되었다면
				if (fileData != null && fileData.getFileSize() > 0) {
					// 파일 확장자명 설정
					user.setFileExt(fileData.getFileExt());
				}
				
				if (userService.userInsert(user) > 0) {
					
					if (mailService.emailDelete(userEmail) > 0) {
						res.setResponse(0, "성공");
					}

				}
				else {
					res.setResponse(-1, "실패");
				}
				
			}
			else {
				res.setResponse(500, "중복 아이디 존재");
			}
			
		}
		else {
			res.setResponse(400, "값 안 넘어옴");
		}
		
		return res;
	}
	
	// 로그인
	@RequestMapping(value="/user/login", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> login (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		String userPwd = HttpUtil.get(request, "userPwd", "");
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {
			
			User user = userService.userSelect(userId);
			
			if (user != null) {
				if (StringUtil.equals(user.getUserPwd(), userPwd)) {
					
					if (StringUtil.equals(user.getStatus(), "Y") || StringUtil.equals(user.getStatus(), "A")) {
						CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
						res.setResponse(0, "성공");
					}
					else {
						res.setResponse(-99, "정지 회원");
					}
			}
				else {
					res.setResponse(500, "존재하지 않는 아이디");
				}
				
			}
			else {
				res.setResponse(404, "bad request");
			}
			
		}
		else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}
		
		return res;
	}
	
	// 로그아웃
	@RequestMapping(value="/user/logout", method=RequestMethod.GET)
	public String logout (HttpServletRequest request, HttpServletResponse response) {
		if (CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
		}
		
		return "redirect:/index";
	}
	
	// 아이디 찾기
	@RequestMapping(value="/user/idFind", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idFind (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		logger.debug("33333333333333333333333");
		
		String userName = HttpUtil.get(request, "userName", "");
		String userEmail = HttpUtil.get(request, "userEmail", "");
		
		if (!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) {
			
			User user = new User();
			user.setUserName(userName);
			user.setUserEmail(userEmail);
			
			User user1 = userService.idFindSelect(user);
			
			JsonObject json = new JsonObject();
			
			if (user1 != null) {
				
				String userId = user1.getUserId();
				int visibleLength = 3;  // 보여줄 앞부분 길이
				int maskedLength = userId.length() - visibleLength;

				StringBuilder maskedPart = new StringBuilder();
				for (int i = 0; i < maskedLength; i++) {
				    maskedPart.append('*');
				}

				String maskedUserId = userId.substring(0, visibleLength) + maskedPart.toString();
				
				json.addProperty("userId", maskedUserId);
				res.setResponse(0, "성공", json);
			}
			else {
				res.setResponse(404, "일치하는 회원 정보 없음");
			}
		}
		else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}
		
		
		
		return res;
	}
	/*
	   // 비밀번호 찾기
	   @RequestMapping(value="/user/pwdFind", method=RequestMethod.POST)
	   @ResponseBody
	   public Response<Object> pwdFind (HttpServletRequest request, HttpServletResponse response) {
	      Response<Object> res = new Response<Object>();
	      
	      String userId = HttpUtil.get(request, "userId", "");
	      String userEmail = HttpUtil.get(request, "userEmail", "");
	      
	      if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userEmail)) {
	         
	         User user = userService.userSelect(userId);
	         
	         if (user != null) {
	            
	            logger.debug("###############################");
	            logger.debug("userEmail : " + user.getUserEmail());
	            logger.debug("################################");
	            
	            
	            if (StringUtil.equals(user.getUserEmail(), userEmail)) {
	            	
	               JsonObject json = new JsonObject();
	               json.addProperty("userPwd", user.getUserPwd());
	               
	               res.setResponse(0, "성공", json);
	               
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
	      }
	      
	      return res;
	   }
	   */
	
	// 회원정보수정
	@RequestMapping(value="/user/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc (MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		logger.debug("dfasdgasdfadfasfsa");
		
		String userId = HttpUtil.get(request, "userId", "");
		String userPwd = HttpUtil.get(request, "userPwd", "");
		String addrCode = HttpUtil.get(request, "addrCode", "");
		String addrBase = HttpUtil.get(request, "addrBase", "");
		String addrDetail = HttpUtil.get(request, "addrDetail", "");
		String userName = HttpUtil.get(request, "userName", "");
		
		FileData fileData = HttpUtil.getFile(request, "profileImg", PROFILE_SAVE_DIR, 0, userId);
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(addrCode)
				&& !StringUtil.isEmpty(addrBase) && !StringUtil.isEmpty(addrDetail) && !StringUtil.isEmpty(userName)) {
			
			User user = userService.userSelect(userId);
			
			if (user != null) {
				
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setAddrCode(addrCode);
				user.setAddrBase(addrBase);
				user.setAddrDetail(addrDetail);
				user.setUserName(userName);
				
				if (fileData != null && fileData.getFileSize() > 0) {
					
					// 이미 프로필 사진이 있었다면
					if (StringUtil.isEmpty(userService.userSelect(userId).getFileExt())) {
						FileUtil.deleteFile(PROFILE_SAVE_DIR + FileUtil.getFileSeparator() + userId);
					}
					
					user.setFileExt(fileData.getFileExt());
				}
				
				if (userService.userUpdate(user) > 0) {

					res.setResponse(0, "성공");
				}
				else {
					res.setResponse(-1, "실패");
				}
				
			}
			else {
				res.setResponse(500, "존재하지 않는 회원");
			}
			
		}
		else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}
			
		
		return res;
	}
	
	// 회원탈퇴
	@RequestMapping(value="/user/delete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete (HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		
		if (!StringUtil.isEmpty(userId)) {
			
			User user = userService.userSelect(userId);
			
			if (user != null) {
				
				if (userService.userDelete(userId) > 0) {
					
					if (CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) {
						CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
					}
					
					res.setResponse(0, "성공");
				}
				else {
					res.setResponse(500, "실패");
				}
				
			}
			else {
				res.setResponse(404, "존재하는 회원 아님");
			}
			
		}
		else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}
		
		return res;
	}

	@RequestMapping(value = "/main")
	public String main() {
		return "/main";
	}

	@RequestMapping(value = "/user/findForm")
	public String findForm() {
		return "/user/findForm";
	}

	@RequestMapping(value = "/user/updateForm")
	public String updateForm(Model model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		model.addAttribute("user", user);
		
		return "/user/updateForm";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}
