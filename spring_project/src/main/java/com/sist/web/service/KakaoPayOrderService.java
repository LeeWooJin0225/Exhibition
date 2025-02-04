package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.KakaoPayDao;
import com.sist.web.model.Order;

@Service("kakaoPayOrderService")
public class KakaoPayOrderService {
	
	private static Logger logger = LoggerFactory.getLogger(KakaoPayOrderService.class);
	
	@Autowired
	private KakaoPayDao kakaoPayDao;
	
	// 주문 데이터 삽입
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int orderInsert (Order order) {
		int count = 0;
		
		try {
			count = kakaoPayDao.orderInsert(order);
		} catch (Exception e) {
			logger.error("[KakaoPayOrderService] orderInsert SQLExcepton", e);
		}
		
		return count;
	}
	
	// 결제 완료
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int orderComplete (Order order) {
		int count = 0;
		
		try {
			count = kakaoPayDao.orderComplete(order);
		} catch (Exception e) {
			logger.error("[KakaoPayOrderService] orderComplete SQLExcepton", e);
		}
		
		return count;
	}
	
	// 주문내역 상세조회
	public Order orderSelect (long orderSeq) {
		Order order = null;
		
		try {
			order = kakaoPayDao.orderSelect(orderSeq);
		} catch (Exception e) {
			logger.error("[KakaoPayOrderService] orderSelect SQLExcepton", e);
		}
		
		return order;
	}
	
	// 주문취소 내역 업데이트
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int orderCancel (Order order) {
		int count = 0;
		
		try {
			count = kakaoPayDao.orderCancel(order);
		} catch (Exception e) {
			logger.error("[KakaoPayOrderService] orderCancel SQLExcepton", e);
		}
		
		return count;
	}
	
	// 주문내역 조회
	public List<Order> orderList (Order order) {
		List<Order> list = null;
		
		try {
			list = kakaoPayDao.orderList(order);
		} catch (Exception e) {
			logger.error("[KakaoPayOrderService] orderList SQLExcepton", e);
		}
		
		return list;
	}
	
	// 주문내역 수 조회
	public long orderListCount (String userId) {
		long count = 0;
		
		try {
			count = kakaoPayDao.orderListCount(userId);
		} catch (Exception e) {
			logger.error("[KakaoPayOrderService] orderList SQLExcepton", e);
		}
		
		return count;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
