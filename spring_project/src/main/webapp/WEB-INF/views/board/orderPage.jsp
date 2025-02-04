<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<title>결제 페이지</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
}

.payment-page {
    width: 90%;
    max-width: 1200px;
    margin: 20px auto;
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

.content-container {
    display: flex;
    gap: 20px;
}

.left-section, .right-section {
    flex: 1;
}

.notice-box {
    background-color: #f9f9f9;
    padding: 15px;
    margin-bottom: 20px;
    border: 1px solid #ddd;
}

.notice-box p {
    font-size: 14px;
    color: #333;
    margin-bottom: 5px;
}

.notice-box label {
    font-size: 12px;
    color: #666;
}

.ticket-selection p {
    font-size: 14px;
    margin-bottom: 10px;
}

table {
    width: 100%;
    border-collapse: collapse;
}

td {
    padding: 10px;
    border: 1px solid #ddd;
    text-align: center;
}

.right-section {
    max-width: 300px;
}

.reservation-info {
    background-color: #f9f9f9;
    padding: 15px;
    border: 1px solid #ddd;
}

.reservation-info h3 {
    font-size: 16px;
    margin-bottom: 10px;
}

.reservation-info p {
    font-size: 14px;
    margin-bottom: 5px;
}

.next-button {
    display: block;
    width: 100%;
    padding: 15px;
    background-color: #333;
    color: #fff;
    font-size: 16px;
    border: none;
    cursor: pointer;
    margin-top: 20px;
    text-align: center;
}

</style>


<script>

	$(document).ready(function() {
		// 부모 페이지에서 보낸 값 받기
		let params = new URLSearchParams(window.location.search);
		let viewDate = params.get("viewDate");
		let price = params.get("price");
		let userId = params.get("userId");
		let exhiName = params.get("exhiName");
		let brdSeq = params.get("brdSeq");
		let startDate = params.get("minDate");
		let endDate = params.get("maxDate");
		
		// orderForm 값 세팅
		document.orderForm.viewDate.value = viewDate;
		document.orderForm.startDate.value = startDate;
		document.orderForm.endDate.value = endDate;
		document.orderForm.brdSeq.value = brdSeq;
		document.orderForm.exhiName.value = exhiName;
		
		console.log("viewDate : " + viewDate + ", price : " + price + ", userId : " + userId + ", exhiName : " + exhiName + ", brdSeq : " + brdSeq + ", startDate : " + startDate + ", endDate : " + endDate);
		
		// 받아온 값들 HTML 세팅
		// 가격을 숫자로 변환하고 천의 자리마다 쉼표 추가
		if (price) {
		    changePrice = Number(price).toLocaleString(); // 가격을 숫자로 변환 후 쉼표 추가
		}
		
		document.getElementById("exhiName").textContent = exhiName;
		document.getElementById("price").textContent = changePrice + "원";
		document.getElementById("startDate").textContent = startDate;
		document.getElementById("endDate").textContent = endDate;
		
		// 티켓 선택한 매수에 따라 가격 값 달라지게 하기
		// select 요소 가져오기
        var ticketCount = document.getElementById("ticketCount");

 	  	  // focusout 이벤트 리스너 추가
        ticketCount.addEventListener("focusout", function() {
            // 선택된 값 가져오기
            const selectedValue = parseInt(ticketCount.value);
         	// 문자열을 숫자로 변환
            const selectedCount = Number(selectedValue); 
            let totalPrice = price * selectedCount;
            
            // orderForm에 totalPrice 값 설정
            document.orderForm.totalPrice.value = totalPrice;
            
            var changeTotalPrice = totalPrice.toLocaleString();
			
            document.getElementById("totalTicketPrice").textContent = changeTotalPrice;
            document.getElementById("realTotalTicketPrice").textContent = changeTotalPrice;
        });
 	  	  
 	  	// 다음단계 버튼 클릭시  
 	  	$("#btnNext").on("click", function() {
 	  		
 	  		var ticketCount = document.getElementById('ticketCount').value;
 	  		
 	  		if (ticketCount == "" || ticketCount == 0) {
 	  			alert("티켓 수를 지정해주세요.");
 	  			return; 
 	  		}
 	  		
 	  		document.orderForm.quantity.value = ticketCount;
 	  		
 	  		document.orderForm.action = "/board/orderPage2";
 	  		document.orderForm.submit();
 	  		
 	  	});
		
	});

</script>

</head>
<body>

<div class="payment-page">
    <div class="steps">
        <div class="step active">권종/할인/매수선택</div>
        <div class="step completed">배송선택/예매확인</div>
        <div class="step">결제</div>
    </div>

    <div class="content-container">
        <!-- Left Section -->
        <div class="left-section">
            <div class="notice-box">
                <p><strong>[티켓링크박스]</strong> 박스 이용권 <span style="color: red;">PAYCO</span> 자동결제 회원은 티켓링크 예매수수료 무한 면제!</p>
                <label><input type="checkbox"> [티켓링크박스] 예매수수료 면제 혜택 대상자 인증에 동의합니다</label>
            </div>

            <div class="ticket-selection">
                <p>권종을 선택하세요. 최대 <strong>5매</strong>까지 예매가 가능합니다.</p>
                <table>
                    <tr>
                        <td>일반할인</td>
                        <td>얼리버드 1인권</td>
                        <td><span id="price">원</span></td>
                        <td>
                            <select id="ticketCount">
                                <option value="0">0</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                            </select>
                            
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- Right Section -->
        <div class="right-section">
            <div class="reservation-info">
                <h3>예매정보</h3>
                <p>전시회명: <span id="exhiName"></span>
                <p>일시: <span id="startDate"></span> ~ <span id="endDate"></span></p>
                <p>티켓금액: <span id="totalTicketPrice"></span></p>
                <p>예매수수료: 0</p>
                <p>배송료: 0</p>
                <p>쿠폰할인: 0</p>
                <p>포인트 사용: 0</p>
                <p><strong>총결제: <span id="realTotalTicketPrice"></span></strong></p>
            </div>

            <button type="button" class="next-button" id="btnNext">다음단계</button>
        </div>
    </div>
</div>

<form name="orderForm" method="post">
	<input type="hidden" name="viewDate" value="">
	<input type="hidden" name="startDate" value="">
	<input type="hidden" name="endDate" value="">
	<input type="hidden" name="brdSeq" value="">
	<input type="hidden" name="exhiName" value="">
	<input type="hidden" name="totalPrice" value="">
	<input type="hidden" name="quantity" value="">
</form>

</body>
</html>
