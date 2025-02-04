<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/userPage.css" type="text/css">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>
<script>
   $(function() {
	   
		document.getElementById('profileImg').addEventListener('change', function(event) {
		    const reader = new FileReader();
		    reader.onload = function() {
		        document.getElementById('profilePreview').src = reader.result;
		    };
		    reader.readAsDataURL(event.target.files[0]);
		});
	   
      //회원정보 수정 버튼 클릭 시
      $("#updateBtn").on("click", function() {
         fn_update();
      });

      // 탈퇴 버튼 클릭 시 모달창 열기
      $("#withdrawalBtn").on("click", function() {
          $("#withdrawalModal").show();
      });
      
      // 모달창 닫기 버튼 클릭 시 모달창 닫기
      $("#closeModalBtn").on("click", function() {
          $("#withdrawalModal").hide();
      });
      
      // 탈퇴 확인 버튼 클릭 시 실제 탈퇴 로직 호출 
      $("#confirmWithdrawalBtn").on("click", function() {
    	  fn_withdraw();
          $("#withdrawalModal").hide();
      });
      
      
      // ########### 회원정보수정  ###########
      	$("#userName").on("keypress", function(e) {
			if (e.which == 13)
				fn_update();
		});
      
		$("#userPwd1").on("keypress", function(e) {
			if (e.which == 13)
				fn_update();
		});
      
		$("#userPwd2").on("keypress", function(e) {
			if (e.which == 13)
				fn_update();
		});
		
		$("#userPwd3").on("keypress", function(e) {
			if (e.which == 13)
				fn_update();
		});
		
		$("#addrCode").on("keypress", function(e) {
			if (e.which == 13)
				fn_update();
		});
		
		$("#addrBase").on("keypress", function(e) {
			if (e.which == 13)
				fn_update();
		});
		
		$("#addrDetail").on("keypress", function(e) {
			if (e.which == 13)
				fn_update();
		});
   });
   
	//input 하단의 안내 메세지 모두 숨김
	function fn_displayNone() {
		$("#userNameMsg").css("display", "none");
		$("#userPwd1Msg").css("display", "none");
		$("#userPwd2Msg").css("display", "none");
		$("#userPwd3Msg").css("display", "none");
	}
   
   function fn_update() {
	   
	   fn_displayNone();
	   
	   var pwdChk = false;
		// 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
		var idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;
	   
		if ($.trim($("#userName").val()).length <= 0) {
			$("#userNameMsg").text("이름을 입력하세요.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}
	   
		if ($.trim($("#userPwd1").val()).length <= 0) {
			$("#userPwd1Msg").text("비밀번호를 입력하세요.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		
		
		if ($("#userPwd1").val() != "${user.userPwd}") {
			$("#userPwd1Msg").text("비밀번호를 다시 확인해주세요.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		
	   
		if ($.trim($("#userPwd2").val()).length > 0) {
			pwdChk = true;
		}
		
		// New Password에 값을 입력했다면
		if (pwdChk) {
			
			if (!idPwdCheck.test($("#userPwd2").val())) {
				$("#userPwd2Msg").text("비밀번호는 영문 대소문자와 숫자로 이루어진 12자리로만 가능합니다.");
				$("#userPwd2Msg").css("display", "inline");
				$("#userPwd2").focus();
				return;
			}
			
			if ($.trim($("#userPwd3").val()).length <= 0) {
				$("#userPwd3Msg").text("비밀번호 확인을 입력하세요.");
				$("#userPwd3Msg").css("display", "inline");
				$("#userPwd3").val("");
				$("#userPwd3").focus();
				return;
			}
			
			
			if ($("#userPwd2").val() != $("#userPwd3").val()) {
				$("#userPwd3Msg").text("비밀번호가 같지 않습니다.");
				$("#userPwd3Msg").css("display", "inline");
				$("#userPwd3").val("");
				$("#userPwd3").focus();
				return;
			}
			
			$("#userPwd").val($("#userPwd2").val());	
			
		}
		else {
			$("#userPwd").val($("#userPwd1").val());	
		}
		
		if ($.trim($("#addrCode").val()).length <= 0) {
			$("#addrCodeMsg").text("주소를 입력하세요.");
			$("#addrCodeMsg").css("display", "inline");
			$("#addrCode").val("");
			$("#addrCode").focus();
			return;
		} 
		
 		if ($.trim($("#addrBase").val()).length <= 0) {
			$("#addrBaseMsg").text("주소를 입력하세요.");
			$("#addrBaseMsg").css("display", "inline");
			$("#addrBase").val("");
			$("#addrBase").focus();
			return;
		} 
		
 		if ($.trim($("#addrDetail").val()).length <= 0) {
			$("#addrDetailMsg").text("상세 주소를 입력하세요.");
			$("#addrDetailMsg").css("display", "inline");
			$("#addrDetail").val("");
			$("#addrDetail").focus();
			return;
		} 
 		
		var form = $("#updateForm")[0];
		var formData = new FormData(form);
 		
 		$.ajax ({
 			type : "POST",
 			url : "/user/updateProc",
 			enctype : "multipart/form-data",
 			data : formData,
			processData : false,			// formData를 String으로 변환 X
			contentType : false,			// content-Type 헤더가 multipart/form-data로 전송
			cache : false,
			timeout : 600000,				// 6초
			dataType : "JSON",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				
				if (response.code == 0) {
					alert("회원정보가 수정되었습니다.");
					location.href = "/";
				}
				else if (response.code == -1) {
					alert("회원정보 수정에 실패하였습니다.");
				}
				else if (response.code == 500) {
					alert("존재하지 않는 회원입니다.");
				}
				else if (response.code == 400) {
					alert("파라미터 값이 넘어오지 않았습니다.");
				}
				else {
					alert("오류가 발생하였습니다.");
				}
				
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
			}
 		});
	   
	   
   }
   
   // 회원탈퇴
   function fn_withdraw() {
	   
		$.ajax ({
 			type : "POST",
 			url : "/user/delete",
 			data : {
 				userId : $("#userId").val()
 			},
			dataType : "JSON",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				
				if (response.code == 0) {
					alert("회원탈퇴가 완료되었습니다.");
					location.href = "/";
				}
				else {
					alert("오류가 발생하였습니다.");
				}
				
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
			}
 		});
	   
   }
   
</script>
<style>
/* 모달창 배경 */
.modal {
    display: none; /* 초기 상태에서는 보이지 않도록 설정 */
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
}

/* 모달창 컨텐츠 */
.modal-content {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 80%;
    max-width: 500px;
    padding: 20px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    text-align: center;
}

.modal-content h2 {
    margin-bottom: 10px;
}

.modal-content p {
    font-size: 14px;
    margin-bottom: 20px;
}
</style>
</head>
<body>

<!-- 모달 창 구조 추가 -->
<div id="withdrawalModal" class="modal">
    <div class="modal-content">
        <h2>탈퇴 안내</h2>
        <p>사용하고 계신 아이디(<span style="color: green;">${user.userId}</span>)는 탈퇴할 경우 재사용 및 복구가 불가능합니다.</p>
        <p style="color: red;">탈퇴한 아이디는 본인과 타인 모두 재사용 및 복구가 불가하오니 신중하게 선택하시기 바랍니다.</p>
        <button id="confirmWithdrawalBtn" class="form_btn">탈퇴하기</button>
        <button id="closeModalBtn" class="form_btn">취소</button>
    </div>
</div>


   <div class="wrapper updateWrap">
      <div class="container">
         <div class="sign-in-container">
         
            <form name="updateForm" id="updateForm" method="post" enctype="multipart/form-data">
               <a href="/index" style="margin-bottom: 20px; opacity: 0.8;"><img alt="" src="/resources/images/logo4.png"></a>
               <h1 style="margin-bottom: 30px;">Modifying Personal info</h1>
               
              	<div class="profile-upload">
		          <label for="profileImg" class="upload-label">
		              <img id="profilePreview" src="/resources/profile/${user.userId }.${user.fileExt}" onerror="this.onerror=null; this.src='/resources/images/default-profile.png';">
		          </label>
		          <input type="file" id="profileImg" name="profileImg" accept="image/*" style="display: none;">
		      </div>

               <input type="text" id="userId" name="userId" value="${user.userId }" readonly>


               <input type="email" id="userEmail" name="userEmail" value="${user.userEmail }" readonly>

               <input type="text" id="userName" name="userName" placeholder="Name" value="${user.userName }">
               <div class="msgBox">
                  <span id="userNameMsg" class="msgText"></span>
               </div>

               <input type="password" id="userPwd1" name="userPwd1" placeholder="Password">
               <div class="msgBox">
                  <span id="userPwd1Msg" class="msgText"></span>
               </div>

               <input type="password" id="userPwd2" name="userPwd2" placeholder="New Password">
               <div class="msgBox">
                  <span id="userPwd2Msg" class="msgText"></span>
               </div>

               <input type="password" id="userPwd3" name="userPwd3" placeholder="New Password Check">
               <div class="msgBox">
                  <span id="userPwd3Msg" class="msgText"></span>
               </div>

               <div class="inputBtn-container">
                  <input type="text" id="addrCode" name="addrCode" class="leftBox" placeholder="Postal Code" value="${user.addrCode }" maxlength="5">
                  <button type="button" id="addrBtn" class="form_btn emailBtn rightBtn" onclick="checkPost()">
                     <span>우편번호 검색</span>
                  </button>
               </div>
               
               	<div class="msgBox">
					<span id="addrCodeMsg" class="msgText"></span>
				</div>
					
               <input type="text" id="addrBase" name="addrBase" placeholder="Address" value="${user.addrBase }">
               <div class="msgBox">
					<span id="addrBaseMsg" class="msgText"></span>
				</div>
               
               <input type="text" id="addrDetail" name="addrDetail" placeholder="Detailed Address" value="${user.addrDetail }">
				<div class="msgBox">
					<span id="addrDetailMsg" class="msgText"></span>
				</div>

               <input type="hidden" id="userPwd" name="userPwd" value="">

               <button type="button" id="updateBtn" class="form_btn">Update</button>
            </form>
            
         </div>
         <div class="overlay-container">
            <div class="overlay-right">
               <h1>
                  Would you like to<br>leave the membership?
               </h1>
               <p>You can sign up again later!</p>
               <button id="withdrawalBtn" class="overlay_btn">Withdrawal</button>
            </div>
         </div>
      </div>
   </div>
</body>
</html>