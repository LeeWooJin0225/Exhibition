<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>배송선택 및 예매확인</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
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

.delivery-selection, .customer-info, .terms-agreement {
    background-color: #f9f9f9;
    padding: 15px;
    margin-bottom: 20px;
    border: 1px solid #ddd;
}

.delivery-selection h3, .customer-info h3, .terms-agreement h3 {
    font-size: 16px;
    margin-bottom: 10px;
}

.input-field {
    width: 100%;
    padding: 8px;
    margin-top: 5px;
    margin-bottom: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 14px;
}

.terms-agreement label {
    font-size: 12px;
    color: #666;
}

.right-section {
    max-width: 300px;
    display: flex; /* Flexbox 사용 */
    flex-direction: column; /* 세로 방향으로 정렬 */
    height: 100%; /* 부모 요소의 높이에 맞추기 위해 100% 설정 */
}

.reservation-info {
    background-color: #f9f9f9;
    padding: 15px;
    border: 1px solid #ddd;
    flex-grow: 1; /* 예약 정보 섹션이 가능한 공간을 차지하도록 설정 */
}

.reservation-info h3 {
    font-size: 16px;
    margin-bottom: 10px;
}

.reservation-info p {
    font-size: 14px;
    margin-bottom: 5px;
}

.btn-section {
    margin-top: auto; /* 버튼 섹션을 아래로 밀어내기 */
}

.next-button, .prev-button {
    display: block;
    width: 100%;
    padding: 15px;
    color: #fff;
    font-size: 16px;
    border: none;
    cursor: pointer;
    margin-top: 10px; /* 버튼 간의 간격 */
}

.next-button {
    background-color: red;
}

.prev-button {
    background-color: #333;
}

input[type="checkbox"] {
    margin-right: 10px; /* 체크박스와 텍스트 간격 */
}
.agree-all {
	font-size: 20px;
    font-weight: bold; /* 글자 두껍게 */
    color: #333; /* 글자 색상 */
}

    	
    </style>

<script>
	$(document).ready(function () {
		
		$('#agreeAll').change(function() {
		    const isChecked = $(this).is(':checked');
		    $('input[name="agreeTerms"], input[name="agreePrivacy"]').prop('checked', isChecked);
		});
		
		
		$("#btnPay").on("click", function() {
			
			if ($.trim($("#customerPhone").val()).length <= 0) {
				alert("연락처를 입력해주세요.");
				$("#customerPhone").focus();
				return;
			}
			
			if ($.trim($("#customerEmail").val()).length <= 0) {
				alert("이메일을 입력해주세요.");
				$("#customerEmail").focus();
				return;
			}
			
			 // 1. checkbox element를 찾습니다.
			  // 2. checked 속성을 체크합니다.
			  const is_terms_checked = $('#agreeTerms').is(':checked');
			  const is_privacy_checked = $('#agreePrivacy').is(':checked');
			  
			  if (is_terms_checked == false || is_privacy_checked == false) {
				  alert("약관에 동의해주셔야 결제가 가능합니다.");
				  return;
			  }
			  
			  document.orderForm.userPhone.value = $("#customerPhone").val();
			  
			  // 구매 함수
			  fn_purchase();
		});
	});
	
	// ################ 구매 처리 시작 ################
	
	let kakaoPayPopup = null;
	
	function fn_purchase() {
		var viewDate = "${viewDate}";
		var price = ${totalPrice};
		var userId = "${user.userId}";
		var userName = "${user.userName}";
		var exhiName = "${exhiName}";
		var brdSeq = ${brdSeq};
		var quantity = ${quantity};
		
		alert(viewDate + ", " + price + ", " + userId + ", " + userName + ", " + exhiName + ", " 
				+ brdSeq + ", quantity : " + quantity);
		
		let formData = {
				viewDate : viewDate,
				price : price,
				userId : userId,
				exhiName : exhiName,
				brdSeq : brdSeq,
				quantity : quantity
		}
		
		   $.ajax({
			      type:"POST",
			      url:"/kakao/readyAjax",
			      data:formData,
			      datatype:"JSON",
			      beforeSend:function(xhr)
			      {
			         xhr.setRequestHeader("AJAX", "true");
			      },
			      success:function(res)
			      {
			         icia.common.log(res);
			         
			         if(res.code == 0)
			         {
			            let _width = 500;
			            let _height = 500;
			            
			            let _left = Math.ceil((window.screen.width - _width) / 2);
			            let _top = Math.ceil((window.screen.height - _height) / 2);
			            
			            kakaoPayPopup = window.open(res.data.next_redirect_pc_url, "카카오페이 결제", "width="+_width+", height="+_height+", left="+_left+", top="+_top+", resizable=false, scrollbars=false, status=false, titlebar=false, toolbar=false, menubar=false");
			         }
			         else
			         {
			            alert(res.msg);
			         }
			      },
			      error:function(error)
			      {
			         icia.common.error(error);
			      }
			   });
		
	}
	
	   function fn_kakaoPayResult(code, msg, orderId)
	   {
	      /*
	      code : 0  -> 결제 완료
	             -1 -> 결제 승인 실패
	             -2 -> 결제 취소
	             -3 -> 결제 실패
	             -4 -> 결제 승인 리턴값 없음.
	      */
	      
	      if(kakaoPayPopup != null)
	      {
	         if(icia.common.type(kakaoPayPopup) == "object" && !kakaoPayPopup.closed)
	         {
	            //카카오페이 팝업창이 객체이면서 닫히지 않았다면 창을 닫는다.
	            kakaoPayPopup.close();
	         }
	         
	         //카카오페이 팝업창 객체 초기화
	         kakaoPayPopup = null;
	      }
	      
	      icia.common.log("code : [" + code + "]");
	      icia.common.log("msg : [" + msg + "]");
	      icia.common.log("orderId : [" + orderId + "]");
	      
	      // 결제성공
	      if(code == 0)
	      {
	    	 // 주문번호 값 받아서 저장
	    	 document.orderForm.orderId.value = orderId;
	    	  
	         document.orderForm.action = "/board/orderPage3";
	         document.orderForm.submit();
	      }
	      else
	      {
	         alert(msg);
	      }
	   }
	   // ################ 구매 처리 끝 ################
	

	
</script>

</head>
<body>
<div class="payment-page">
    <div class="steps">
        <div class="step completed">권종/할인/매수선택</div>
        <div class="step active">배송선택/예매확인</div>
        <div class="step">결제</div>
    </div>

    <div class="content-container">
        <!-- Left Section -->
        <div class="left-section">
            <div class="delivery-selection">
                <h3>수령 방법 선택</h3>
                <label><input type="radio" name="delivery" value="direct" checked> 현장 수령</label><br>
            </div>

            <div class="customer-info">
                <h3>주문자 정보</h3>
                <label>이름: <input type="text" name="customerName" class="input-field" value="${user.userName }" readonly></label><br>
                <label>연락처: <input type="text" name="customerPhone" id="customerPhone" class="input-field"></label><br>
                <label>이메일: <input type="email" name="customerEmail" id="customerEmail" class="input-field" value="${user.userEmail }"></label>
            </div>

            <div class="terms-agreement">
                <h3>약관 동의</h3>
                <div class="agree-all">
			        <label><input type="checkbox" id="agreeAll" name="agreeAll"> 약관 전체에 동의합니다.</label>
			    </div>
                <label><input type="checkbox" name="agreeTerms" id="agreeTerms"> 예매자 정보 확인 및 결제에 동의합니다.</label><br>
                <label><input type="checkbox" name="agreePrivacy" id="agreePrivacy"> 개인정보 수집 및 이용에 동의합니다.</label>
            </div>
        </div>

        <!-- Right Section -->
        <div class="right-section">
            <div class="reservation-info">
                <h3>예매정보</h3>
                <p>일시: ${startDate } ~ ${endDate }</p>
                <p>티켓금액: <fmt:formatNumber type="number" maxFractionDigits="3" value="${totalPrice }"/>원</p>
                <p>예매수수료: 0</p>
                <p>쿠폰할인: 0</p>
                <p>포인트 사용: 0</p>
                <p><strong>총결제: <fmt:formatNumber type="number" maxFractionDigits="3" value="${totalPrice }"/>원</strong></p>
            </div>
            <div class="btn-section">
                <button type="button" class="next-button" id="btnPay">결제하기</button>
                <!-- <button type="button" class="prev-button" id="btnPrev">이전단계</button> -->
            </div>
        </div>
    </div>
</div>

<form name="orderForm" method="post">
	<input type="hidden" name="userPhone" value="">
	<input type="hidden" name="orderId" value="">
</form>


</body>
</html>
