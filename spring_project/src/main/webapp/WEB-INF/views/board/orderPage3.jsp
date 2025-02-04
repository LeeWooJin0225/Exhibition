<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
/* 전체 컨테이너 스타일 */
.ticketing-container {
    display: flex;
    justify-content: space-between;
    width: 80%;
    margin: 20px auto;
    font-family: Arial, sans-serif;
}

/* 좌측 정보 섹션 */
.ticket-info-box {
    width: 65%;
    border: 1px solid #ddd;
    padding: 20px;
    box-sizing: border-box;
}

.completed-text {
    color: red;
    font-weight: bold;
    margin-bottom: 10px;
    border: 1px solid red;
    padding: 8px;
    text-align: center;
}

.event-info {
    display: flex;
    margin-bottom: 20px;
}

.event-image {
    width: 120px;
    height: auto;
    margin-right: 15px;
}

.event-details p {
    margin: 5px 0;
}

.location-btn {
    background-color: #ddd;
    border: 1px solid #bbb;
    padding: 5px 10px;
    font-size: 14px;
    cursor: pointer;
}

.reservation-summary, .payment-summary {
    margin: 20px 0;
}

.payment-summary p {
    margin: 5px 0;
}

.payment-summary span {
    float: right;
}

/* 우측 유의사항 섹션 */
.notice-box {
    width: 30%;
    border: 1px solid #ddd;
    padding: 15px;
    font-size: 14px;
    line-height: 1.5;
    box-sizing: border-box;
}

/* 버튼 스타일 */

.buttons {
    display: flex;
    flex-direction: column; /* 버튼을 수직으로 배치 */
    gap: 10px; /* 버튼 간 간격 */
}

.print-btn, .confirm-btn {
    width: 100%; /* 버튼을 박스 너비에 맞추어 넓게 */
    padding: 10px;
    font-size: 14px;
    cursor: pointer;
    background-color: #f5f5f5;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.confirm-btn {
    background-color: #333; /* 검은색 배경 */
    color: #fff; /* 흰색 글씨 */
    border: none;
    padding: 10px 20px;
    font-size: 14px;
    cursor: pointer;
    border-radius: 5px;
}

.print-btn:hover, .confirm-btn:hover {
    background-color: #ddd;
}

.steps {
    display: flex;
    justify-content: space-around;
    margin-bottom: 20px;
}

.step {
    flex: 1;
    text-align: center;
    padding: 10px;
    border-bottom: 3px solid #ddd;
}

.step.active {
    font-weight: bold;
    color: #333;
    border-color: #333;
}

.step.completed {
    color: #333;
}

</style>


<script>
	$(document).ready(function() {
		
		$("#btnPayEnd").on("click", function() {
			
	        // 부모 창의 bbsForm에 접근하여 boardType 값 설정
	        window.opener.document.bbsForm.boardType.value = "5";
	        
	        // 부모 창에서 bbsForm 제출
	        window.opener.document.bbsForm.action = "/board/list";
	        window.opener.document.bbsForm.submit();
	        
	        // 자식 창 닫기
	        window.close();
			
		});
	});

</script>


</head>
<body>

    <div class="steps">
        <div class="step completed">권종/할인/매수선택</div>
        <div class="step completed">배송선택/예매확인</div>
        <div class="step active">결제</div>
    </div>
    
<div class="ticketing-container">
    
    <div class="ticket-info-box">
        <p class="completed-text">티켓예매가 완료되었습니다.</p>
        
        <div class="event-info">
            <img src="/resources/upload/${brd.brdFile.fileName}" alt="Event Image" class="event-image">
            <div class="event-details">
                <p><strong>예매번호</strong>: ${order.orderSeq }</p>
                <p><strong>티켓명</strong>: ${order.exhiName }</p>
                <p><strong>장소</strong>: 쌍용강북교육센터</p>
                <p><strong>일시</strong>: ${order.viewDate }</p>
            </div>
        </div>

        <div class="reservation-summary">
            <p><strong>예매자</strong>: ${order.userName }</p>
            <p><strong>연락처</strong>: ${userPhone }</p>
            <p><strong>티켓수령방법</strong>: 현장수령</p>
        </div>

        <div class="payment-summary">
            <p><strong>총 결제금액</strong></p>
            <p>티켓금액: <span><fmt:formatNumber type="number" maxFractionDigits="3" value="${order.totalAmount}" />원</span></p>
            <p>매수: <span>${order.quantity }</span></p>
            <p>예매수수료: <span>0</span></p>
            <p>부가상품: <span>0</span></p>
            <p>배송료: <span>0</span></p>
            <p><strong>결제정보</strong>: 카카오페이</p>
        </div>

    </div>

    <div class="notice-box">
        <p><strong>유의사항</strong></p>
        <p>예매수수료는 예매 당일 취소하실 경우만 환불되며, 그 이후 취소 시에는 환불되지 않습니다.</p>
        <p>예매취소 시 취소일에 따라 취소수수료가 부과될 수 있습니다. (티켓금액의 0~30%)</p>
        <p>당일관람 예매건에 대해서는 취소가 불가능하니 이점 양해 부탁드립니다.</p>
        <p>티켓이 배송된 이후에는 온라인에서 취소가 불가합니다. 티켓을 받은 후 반송기한에 티켓링크로 접수로 직접 등기우편을 보내주셔야 취소가 가능합니다.</p>
    
    	<div class="buttons">
            <button class="print-btn">내역 프린트</button>
            <button class="confirm-btn" type="button" id="btnPayEnd">예매 확인</button>
        </div>
    </div>
</div>

<form name="bbsForm" method="post">
	<input type="hidden" name="boardType" value="">
</form>



</body>
</html>