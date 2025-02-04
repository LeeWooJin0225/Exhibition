package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Order;

@Repository("kakaoPayDao")
public interface KakaoPayDao {

	// 주문 데이터 삽입
	public int orderInsert (Order order);
	// 주문완료 (상태변경 / TID값 세팅)
	public int orderComplete (Order order);
	// 주문내역 조회
	public List<Order> orderList (Order order);
	// 주문내역 수 조회
	public long orderListCount (String userId);
	// 주문내역 상세조회
	public Order orderSelect (long orderSeq);
	// 주문취소 내역 업데이트
	public int orderCancel (Order order);
	
}
