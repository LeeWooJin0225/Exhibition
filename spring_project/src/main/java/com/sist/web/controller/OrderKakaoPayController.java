package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonObject;
import com.sist.common.util.StringUtil;
import com.sist.web.dao.KakaoPayDao;
import com.sist.web.model.Brd;
import com.sist.web.model.BrdFile;
import com.sist.web.model.KakaoPayApproveRequest;
import com.sist.web.model.KakaoPayApproveResponse;
import com.sist.web.model.KakaoPayCancelRequest;
import com.sist.web.model.KakaoPayCancelResponse;
import com.sist.web.model.KakaoPayReadyRequest;
import com.sist.web.model.KakaoPayReadyResponse;
import com.sist.web.model.Order;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BrdService;
import com.sist.web.service.KakaoPayOrderService;
import com.sist.web.service.KakaoPayService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.SessionUtil;

@Controller("orderKakaoPayController")
public class OrderKakaoPayController {

	
	private static Logger logger = LoggerFactory.getLogger(OrderKakaoPayController.class);
	
	@Autowired
	private KakaoPayService kakaoPayService;
	
	@Autowired
	private KakaoPayOrderService kakaoPayOrderService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private BrdService brdService;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['kakaopay.tid.session.name']}")
	private String KAKAOPAY_TID_SESSION_NAME;
	
	// Client ID (CID)
	@Value("#{env['kakaopay.client.id']}")
	private String KAKAOPAY_CLIENT_ID;
	
	String orderId = "";
	
	// 매수 선택 화면
	@RequestMapping(value="/board/orderPage") 
	public String orderPage (HttpServletRequest request, HttpServletResponse response) {
		return "/board/orderPage";
	}
	
	// 예매자 정보 화면
	@RequestMapping(value="/board/orderPage2", method=RequestMethod.POST)
	public String orderPage2 (ModelMap model, HttpServletRequest request, HttpServletResponse resoinse) {
		
		String viewDate = HttpUtil.get(request, "viewDate", "");
		String startDate = HttpUtil.get(request, "startDate", "");
		String endDate = HttpUtil.get(request, "endDate", "");
		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		String exhiName = HttpUtil.get(request, "exhiName", "");
		long totalPrice = HttpUtil.get(request, "totalPrice", 0);
		long quantity = HttpUtil.get(request, "quantity", 0);
		
		logger.debug("viewDate : " + viewDate + ", startDate : " + startDate + ", endDate : " + endDate + ", brdSeq: " + brdSeq + ", exhiName : " + exhiName
				+ ", totalPrice : " + totalPrice + "quantity : " + quantity);
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		
		// 로그인 안 했을 때 처리 해야 하는데...;;;;;;;;;
		
		model.addAttribute("user", user);
		model.addAttribute("viewDate", viewDate);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("exhiName", exhiName);
		model.addAttribute("totalPrice", totalPrice);
		model.addAttribute("totalPrice", totalPrice);
		model.addAttribute("quantity", quantity);
		
		return "/board/orderPage2";
	}
	
	// 최종 결제 내역 화면
	@RequestMapping(value="/board/orderPage3")
	public String orderPage3 (ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String userPhone = HttpUtil.get(request, "userPhone", "");
		long orderId = HttpUtil.get(request, "orderId", 0);
		
		logger.debug("===========================================");
		logger.debug("userPhone : " + userPhone + ", orderId : " + orderId);
		logger.debug("===========================================");
		
		// 주문내역 조회
		Order order = kakaoPayOrderService.orderSelect(orderId);
		// 게시글 조회
		Brd brd = brdService.brdSelect(order.getBrdSeq());
		// 게시글 파일 조회
		brd.setBrdFile(brdService.brdFileSelect(order.getBrdSeq()));
		
		model.addAttribute("userPhone", userPhone);
		model.addAttribute("order", order);
		model.addAttribute("brd", brd);
		
		return "/board/orderPage3";
	}
	
	@RequestMapping(value="/kakao/readyAjax", method=RequestMethod.POST)
	@ResponseBody
	public Response<JsonObject> readyAjax (HttpServletRequest request, HttpServletResponse response) {
		
		Response<JsonObject> res = new Response<JsonObject>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		String viewDate = HttpUtil.get(request, "viewDate", "");
		int price = HttpUtil.get(request, "price", 0);
		String userId = HttpUtil.get(request, "userId", "");
		String exhiName = HttpUtil.get(request, "exhiName", "");
		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		long quantity = HttpUtil.get(request, "quantity", 0);
		
		Order order = new Order();
		
		// 주문 테이블 먼저 INSERT -> 카카오페이 -> 최종 결제 후 주문완료 상태 변경
		
		// ########### 주문 테이블 INSERT 시작 ###########
		order.setUserId(cookieUserId);
		order.setStatus("결제대기");
		order.setViewDate(viewDate);
		order.setTotalAmount(price);
		order.setExhiName(exhiName);
		order.setBrdSeq(brdSeq);
		order.setQuantity(quantity);
		
		try {
			kakaoPayOrderService.orderInsert(order);
			orderId = String.valueOf(order.getOrderSeq()); // MyBatis를 통해 생성된 시퀀스 값을 가져옴
		    logger.info("생성된 주문 번호: " + orderId);
		    
			KakaoPayReadyRequest kakaoPayReadyRequest = new KakaoPayReadyRequest();
			// 필수 입력 값 세팅
			kakaoPayReadyRequest.setPartner_order_id(orderId);	// 주문 테이블 주문번호
			kakaoPayReadyRequest.setPartner_user_id(userId);	// 회원 아이디
			kakaoPayReadyRequest.setItem_name(order.getExhiName());	// 상품명
			// kakaoPayReadyRequest.setItem_code(goods.getGoodsCode());	// 상품코드 (필수X)
			kakaoPayReadyRequest.setQuantity((int)order.getQuantity());	// 상품 수량
			kakaoPayReadyRequest.setTotal_amount(price);	// 총 금액
			kakaoPayReadyRequest.setTax_free_amount(0);		// 상품 비과세 금액
			
			// 카카오페이 연동 시작
			logger.debug("00000000000000000000");
			KakaoPayReadyResponse kakaoPayReadyResponse = kakaoPayService.ready(kakaoPayReadyRequest);
			logger.debug("33333333333333333333");
			
			// response 세팅 후 리턴
			if (kakaoPayReadyResponse != null) {
				// 카카오페이 트랜잭션 아이디 세션 저장
				HttpSession session = request.getSession(true);
				SessionUtil.setSession(session, KAKAOPAY_TID_SESSION_NAME, kakaoPayReadyResponse.getTid());
				
				JsonObject json = new JsonObject();
				
				json.addProperty("next_redirect_app_url", kakaoPayReadyResponse.getNext_redirect_app_url());
				json.addProperty("next_redirect_mobile_url", kakaoPayReadyResponse.getNext_redirect_mobile_url());
				
				// 실질적으로 next_redirect_pc_url만 씀
				json.addProperty("next_redirect_pc_url", kakaoPayReadyResponse.getNext_redirect_pc_url());
				
				json.addProperty("android_app_scheme", kakaoPayReadyResponse.getAndroid_app_scheme());
				json.addProperty("ios_app_scheme", kakaoPayReadyResponse.getIos_app_scheme());
				json.addProperty("created_at", kakaoPayReadyResponse.getCreated_at());

		        res.setResponse(0, "성공", json);
			}
			else {
				res.setResponse(-1, "카카오페이 결제 준비 중 오류 발생", null);
			}
		} catch (Exception e) {
			logger.error("[OrderKakaoPayController] orderInsert SQLException", e);
			res.setResponse(-1, "카카오페이 결제 준비 중 오류 발생", null);
		}
		
		// ########### 주문 테이블 INSERT 끝 ###########
		
		logger.debug("=====================================");
		logger.debug("주문 테이블 INSERT 완료");
		logger.debug("=====================================");
		
		
		return res;
	}
	
	// 카카오페이 결제 승인
	@RequestMapping(value="/order/kakaoPay/success", method=RequestMethod.GET)
	public String success (Model model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		String pg_token = HttpUtil.get(request, "pg_token");
		String tid = null;
		
		// false : 세션이 존재하지 않을 경우, 새로운 세션을 생성하지 않고 null 반환
		// 기존 세션 존재시 그 세션을 반환함
		HttpSession session = request.getSession(false);
		
		if (session != null) {
			tid = (String) SessionUtil.getSession(session, KAKAOPAY_TID_SESSION_NAME);
		}
		
		logger.info("pg_token : [" + pg_token + "]");
		logger.info("tid : [" + tid + "]");
		logger.info("orderId : [" + orderId + "]");
		
		if (!StringUtil.isEmpty(pg_token) && !StringUtil.isEmpty(tid)) {
			
			KakaoPayApproveRequest kakaoPayApproveRequest = new KakaoPayApproveRequest();
			
			String userId = cookieUserId;
			
			kakaoPayApproveRequest.setTid(tid);
			kakaoPayApproveRequest.setPartner_order_id(orderId);
			kakaoPayApproveRequest.setPartner_user_id(userId);
			kakaoPayApproveRequest.setPg_token(pg_token);
			
			// 결제 승인 요청
			KakaoPayApproveResponse kakaoPayApproveResponse =
					kakaoPayService.approve(kakaoPayApproveRequest);
			
			if (kakaoPayApproveResponse != null) {
				logger.info("[OrderKakaoPayController] approve KakaoPayApproveResponse : \n "
						+ kakaoPayApproveResponse);
				
				if (kakaoPayApproveResponse.getError_code() == 0) {
					// 성공
					// 주문 테이블 DB 최종 결제 승인 완료로 업데이트
					// 주문 테이블 상태 UPDATE (결제 완료)
					// TID 값 세팅
					try {
						Order order = new Order();
						order.setOrderSeq(Integer.parseInt(orderId));
						order.setTid(tid);
						order.setStatus("결제완료");
						
						if (kakaoPayOrderService.orderComplete(order) > 0) {
							logger.debug("###############################################");
							logger.debug("결제완료 / TID 값 세팅 성공!");
							logger.debug("###############################################");
						}
						else {
							logger.debug("###############################################");
							logger.debug("DB 설정 에러");
							logger.debug("###############################################");
						}
					} catch (Exception e) {
						logger.debug("###############################################");
						logger.debug("DB 설정 에러");
						logger.debug("###############################################");
					}
					
					logger.debug("111111111111111111111111111111111");
					logger.debug("orderId : " + orderId);
					logger.debug("111111111111111111111111111111111");
					
					model.addAttribute("orderId", orderId);
					model.addAttribute("code", 0);
					model.addAttribute("msg", "카카오페이 결제가 완료되었습니다.");
				}
				else {
					// 실패
					model.addAttribute("code", -1);
					model.addAttribute("msg", (!StringUtil.isEmpty(kakaoPayApproveResponse.getError_message()) ?
							kakaoPayApproveResponse.getError_message() : "카카오페이 결제 중 오류가 발생하였습니다."));
				}
				
				if (!StringUtil.isEmpty(tid)) {
					// tid 세션 삭제
					SessionUtil.removeSession(session, KAKAOPAY_TID_SESSION_NAME);
				}
			}
			else {
				// 실패
				model.addAttribute("code", -4);
				model.addAttribute("msg", "카카오페이 결제 처리 중 오류가 발생하였습니다.");
			}
			
		}
		else {
			logger.debug("3333333333333333333333333333333333");
		}
		
		return "/board/result";
	}
	
	
	
	
	// 카카오페이 결제 취소
	@RequestMapping(value="/order/kakaoPay/cancel")
	@ResponseBody
	public Response<Object> cancel (Model model, HttpServletRequest request, HttpServletResponse response) {
		
		Response<Object> res = new Response<Object>();

		long orderSeq = HttpUtil.get(request, "orderSeq", 0);
		
		// 주문
		Order order = null;
		
		HttpSession session = request.getSession(false);
		
		if (session != null) {
			
			try {
				// 주문 상세내역 가져오기
				order = kakaoPayOrderService.orderSelect(orderSeq);
				
				KakaoPayCancelRequest kakaoPayCancelRequest = new KakaoPayCancelRequest();
				
				kakaoPayCancelRequest.setCid(KAKAOPAY_CLIENT_ID);
				kakaoPayCancelRequest.setTid(order.getTid());
				kakaoPayCancelRequest.setCancel_amount(order.getTotalAmount());
				kakaoPayCancelRequest.setCancel_tax_free_amount(0);
				kakaoPayCancelRequest.setCancel_vat_amount(0);
				kakaoPayCancelRequest.setCancel_available_amount(order.getTotalAmount());
				
				// 카카오페이 연동 시작
				KakaoPayCancelResponse kakaoPayCancelResponse = kakaoPayService.cancel(kakaoPayCancelRequest);
				
				if (kakaoPayCancelResponse != null) {
					logger.info("[OrderKakaoPayController] cancel kakaoPayCancelResponse : \n "
							+ kakaoPayCancelResponse);
					
					if (kakaoPayCancelResponse.getError_code() == 0) {
						// 성공
						// 주문 테이블 DB 최종 결제 주문취소로 업데이트
						order.setStatus("결제취소");
						kakaoPayOrderService.orderCancel(order);
						
						res.setResponse(0, "정상적으로 결제가 취소되었습니다.");
					}
					else {
						res.setResponse(-1, (!StringUtil.isEmpty(kakaoPayCancelResponse.getError_message()) ?
								kakaoPayCancelResponse.getError_message() : "카카오페이 결제 취소 중 오류가 발생하였습니다."));
					}
					
				}
				else {
					res.setResponse(-4, "카카오페이 결제 처리 중 오류가 발생하였습니다.");
				}
	
				
			} catch (Exception e) {
				logger.error("[OrderKakaoPayController] cancel SQLException", e);
				res.setResponse(-4, "카카오페이 결제 처리 중 오류가 발생하였습니다.");
			}
		}
		
		
		return res;
		
	}
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
