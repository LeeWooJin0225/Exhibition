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

	var mailSend = false;	// 메일 보냈는지 안 보냈는지 체크
	var idChk = false;		// 아이디 중복검사 했는지 체크
	var mailChk = false;	// 메일 인증체크 제대로 했는지 체크

	$(function() {
		
		$("#userIdLogin").focus();
		
		document.getElementById('profileImg').addEventListener('change', function(event) {
		    const reader = new FileReader();
		    reader.onload = function() {
		        document.getElementById('profilePreview').src = reader.result;
		    };
		    reader.readAsDataURL(event.target.files[0]);
		});
		
		//로그인 화면으로 이동
		$("#signUpBtn").on("click", function() {
			$(".container").addClass("right-panel-active");
		});

		//회원가입 화면으로 이동
		$("#signInBtn").on("click", function() {
			$(".container").removeClass("right-panel-active");
		});

		//아이디 입력 후 엔터
		$("#userIdLogin").on("keypress", function(e) {
			if (e.which == 13)
				fn_loginCheck();
		});

		//비밀번호 입력 후 엔터
		$("#userIdLogin").on("keypress", function(e) {
			if (e.which == 13)
				fn_loginCheck();
		});

		//로그인 버튼 클릭 시
		$("#realSignInBtn").on("click", function() {
			fn_loginCheck();
		});
		
		
		// 회원가입
		// 아이디 입력 후 엔터
		$("#userId").on("keypress", function(e) {
			if (e.which == 13)
				fn_join();
		});
		
		//아이디 중복 체크(엔터)
		$("#userId").on("keypress", function(e) {
			if (e.which == 13)
				fn_idCheck();
		});

		//아이디 중복 체크(버튼)
		$("#idBtn").on("click", function() {
			fn_idCheck();
		}); 
		
		// 이메일 입력 후 엔터
		$("#userEmail").on("keypress", function(e) {
			if (e.which == 13)
				fn_join();
		});
		
		// 이메일 전송 버튼 클릭
		$("#emailBtn").on("click", function() {
			fn_emailSend();
		});
		
		//이메일 인증번호 입력 후 엔터
		$("#authNum").on("keypress", function(e) {
			if (e.which == 13)
				fn_auth();
		});
		
		//이메일 인증번호 확인 버튼 클릭 
		$("#authBtn").on("click", function()  {
			fn_auth();
		});
		
		//비밀번호 입력 후 엔터
		$("#userPwd1").on("keypress", function(e) {
			if (e.which == 13)
				fn_join();
		});
		
		//비밀번호 확인 입력 후 엔터
		$("#userPwd2").on("keypress", function(e) {
			if (e.which == 13)
				fn_join();
		});
		
		//이름 입력 후 엔터
		$("#userName").on("keypress", function(e) {
			if (e.which == 13)
				fn_join();
		});
		
		//주소 입력 후 엔터
		$("#addrCode").on("keypress", function(e) {
			if (e.which == 13)
				fn_join();
		});
		
		//주소 입력 후 엔터
		$("#addrBase").on("keypress", function(e) {
			if (e.which == 13)
				fn_join();
		});
		
		//주소 입력 후 엔터
		$("#addrDetail").on("keypress", function(e) {
			if (e.which == 13)
				fn_join();
		});
		
		//회원가입 버튼 클릭 
		$("#realSignUpBtn").on("click", function()  {
			fn_join();
		});
		
		
	});
	
	//input 하단의 안내 메세지 모두 숨김
   function fn_displayNone() {
      $("#userIdMsg").css("display", "none");
      $("#userIdLoginMsg").css("display", "none");
      $("#userEamilMsg").css("display", "none");
      $("#userNameMsg").css("display", "none");
      $("#authCheckMsg").css("display", "none");
      $("#authNumMsg").css("display", "none");
      $("#userPwd1Msg").css("display", "none");
      $("#userPwd2Msg").css("display", "none");
      $("#userPwdLoginMsg").css("display", "none");
      $("#addrCodeMsg").css("display", "none");
   }
	

	//로그인
	function fn_loginCheck() {
		//공백 체크
		var emptCheck = /\s/g;

		fn_displayNone();

		if ($.trim($("#userIdLogin").val()).length <= 0) {
			$("#userIdLoginMsg").text("사용자 아이디를 입력하세요.");
			$("#userIdLoginMsg").css("display", "inline");
			$("#userIdLogin").val("");
			$("#userIdLogin").focus();
			return;
		}

		if (emptCheck.test($("#userIdLogin").val())) {
			$("#userIdLoginMsg").text("사용자 아이디는 공백을 포함할 수 없습니다.");
			$("#userIdLoginMsg").css("display", "inline");
			$("#userIdLogin").val("");
			$("#userIdLogin").focus();
			return;
		}

		if ($.trim($("#userPwdLogin").val()).length <= 0) {
			$("#userPwdLoginMsg").text("비밀번호를 입력하세요.");
			$("#userPwdLoginMsg").css("display", "inline");
			$("#userPwdLogin").val("");
			$("#userPwdLogin").focus();
			return;
		}

		if (emptCheck.test($("#userPwdLogin").val())) {
			$("#userPwdLoginMsg").text("사용자 비밀번호는 공백을 포함할 수 없습니다.");
			$("#userPwdLoginMsg").css("display", "inline");
			$("#userPwdLogin").val("");
			$("#userPwdLogin").focus();
			return;
		}

		//로그인 ajax
		$.ajax ({
			type : "POST",
			url : "/user/login",
			data : {
				userId : $("#userIdLogin").val(),
				userPwd : $("#userPwdLogin").val()
			},
			dataType : "JSON",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				
				if (response.code == 0) {
					location.href = "/";
				}
				else {
					alert("다시 입력해주세요!");
				}
				
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
			}
			
			
		});
	}
	
function fn_validateEmail(value)
{
   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
   
   return emailReg.test(value);
}

// 아이디 중복검사
function fn_idCheck() { 
	
	fn_displayNone();
	
	// 아이디
	if ($.trim($("#userId").val()).length <= 0) {
		$("#userIdMsg").text("사용자 아이디를 입력하세요.");
		$("#userIdMsg").css("display", "inline");
		$("#userId").val("");
		$("#userId").focus();
		return;
	}
	
		
     $.ajax({
         type : "POST",
         url : "/user/idDupChk",
         data : {
            userId : $("#userId").val()
         },
         dataType : "JSON",
         beforeSend : function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
         },
         success : function(res) {
            if (res.code == 0) {
               $('#userId').css('border-color', '#ccc');
               $('#userIdMsg').show().css("color", "green").text("사용 가능한 아이디입니다.");
               idChk = true;
            }
            else if (res.code == -1) {
               $('#userId').css('border-color', 'red');
               $('#userIdMsg').show().css("color", "red").text("사용 불가능한 아이디입니다.");
               $("#userId").focus();
               idChk = false;
            }
            else if (res.code == 400) {
               alert("값이 넘어오지 않았습니다!");
               $("#userId").focus();
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

	// 이메일 보내기
	function fn_emailSend() {
		
		
		fn_displayNone();
		
		// 이메일
		if ($.trim($("#userEmail").val()).length <= 0) {
			$("#userEmailMsg").text("이메일을 입력해주세요");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}
		
		if (!fn_validateEmail($("#userEmail").val())) {
			$("#userEmailMsg").text("사용자 이메일 형식이 올바르지 않습니다.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").focus();
			return;
		}
		
	      $.ajax({
	          type : "POST",
	          url : "/sendMail.do",
	          data : {
	             userEmail : $("#userEmail").val()
	          },
	          dataType : "JSON",
	          beforeSend : function(xhr) {
	             xhr.setRequestHeader("AJAX", "true");
	          },
	          success : function(response) {
	             
	             if (response.code == 0) {
	                alert("이메일이 전송되었습니다.");
	                $("#userEmailMsg").css("display", "none");
	    			$("#authNumMsg").text("인증번호를 입력해주세요.");
	    			$("#authNumMsg").css("display", "inline");
	    			$("#authNum").focus();
	    			
	    			mailSend = true;
	             }
	             else {
	                alert("메일 전송 실패;;");
	             }
	             
	          },
	          error : function(xhr, status, error) {
	             icia.common.error(error);
	          }
	       });   
		
		
		
	}
	
	// 이메일 인증번호 체크
	function fn_auth() {
		
		fn_displayNone();
		
		if (mailSend) {
			if ($.trim($("#authNum").val()).length <= 0) {
				$("#authNumMsg").text("인증번호를 입력해주세요.");
				$("#authNumMsg").css("display", "inline");
				$("#authNum").val("");
				$("#authNum").focus();
				return;
			}
			
			$.ajax ({
				type : "POST",
				url : "/mailChk",
				data : {
					authNum : $("#authNum").val(),
					userEmail : $("#userEmail").val()
				},
				dataType : "JSON",
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					if (response.code == 0) {
		                $('#authNumMsg').show().css("color", "green").text("사용 가능한 이메일입니다.");
		                mailChk = true;
					}
					else if (response.code == 400) {
						alert("파라미터 값 안 넘어옴");
					}
					else if (response.code == 404) {
						alert("이메일과 일치하는 코드 없음");
					}
					else if (response.code == -1) {
						$('#authNumMsg').show().css("color", "red").text("올바르지 않은 인증코드입니다.");
					}
				},
				error : function(xhr, status, error) {
					icia.common.error(error);
				}
			});
		}
		else {
			$("#authNumMsg").text("인증번호를 전송해주세요.");
			$("#authNumMsg").css("display", "inline");
			return;
		}
		
		
		
	}
	
	
	function fn_join() {
		
		fn_displayNone();
		
		var emptCheck = /\s/g;
		// 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
		var idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;
		
		// 아이디
		if ($.trim($("#userId").val()).length <= 0) {
			$("#userIdMsg").text("사용자 아이디를 입력하세요.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").val("");
			$("#userId").focus();
			return;
		}
		
		if (emptCheck.test($("#userId").val())) {
			$("#userIdMsg").text("사용자 아이디는 공백을 포함할 수 없습니다.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").val("");
			$("#userId").focus();
			return;
		}
		
		if (!idPwdCheck.test($("#userId").val())) {
			$("#userIdMsg").text("아이디는 영문 대소문자와 숫자로 이루어진 12자리로만 가능합니다.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").focus();
			return;
		}
		
		fn_idCheck();
		
		// 아이디 중복체크
 		if (idChk == false) {
            $('#userId').css('border-color', 'red');
            $('#userIdMsg').show().css("color", "red").text("사용 불가능한 아이디입니다.");
            $("#userId").focus();
            return;
		}  
		
		// 이메일
		if ($.trim($("#userEmail").val()).length <= 0) {
			$("#userEmailMsg").text("이메일을 입력해주세요");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}
		
		if (!fn_validateEmail($("#userEmail").val())) {
			$("#userEmailMsg").text("사용자 이메일 형식이 올바르지 않습니다.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").focus();
			return;
		}
		
		// 인증메일 보냈는지 체크
		if (mailSend == false) {
				$("#authNumMsg").text("인증코드를 전송해주세요.");
				$("#authNumMsg").css("display", "inline");
				$("#authNum").val("");
				$("#authNum").focus();
				return;
		}
		
		// 인증코드 제대로 확인했는지 체크
		if (mailChk == false) {
				$("#authNumMsg").text("인증코드를 입력해주세요.");
				$("#authNumMsg").css("display", "inline");
				$("#authNum").val("");
				$("#authNum").focus();
				return;
		}
		
		// 이름
		if ($.trim($("#userName").val()).length <= 0) {
			$("#userNameMsg").text("사용자 이름을 입력하세요.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}
		
		// 비밀번호
		if ($.trim($("#userPwd1").val()).length <= 0) {
			$("#userPwd1Msg").text("사용자 비밀번호를 입력하세요.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		
		if (!idPwdCheck.test($("#userPwd1").val())) {
			$("#userPwd1Msg").text("비밀번호는 영문 대소문자와 숫자로 이루어진 12자리로만 가능합니다.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").focus();
			return;
		}
		
		// 비밀번호 확인
		if ($.trim($("#userPwd2").val()).length <= 0) {
			$("#userPwd2Msg").text("사용자 비밀번호 확인을 입력하세요.");
			$("#userPwd2Msg").css("display", "inline");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
		}
		
		if ($("#userPwd1").val() != $("#userPwd2").val()) {
			$("#userPwd2Msg").text("비밀번호가 같지 않습니다.");
			$("#userPwd2Msg").css("display", "inline");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
		}
		
		$("#userPwd").val($("#userPwd1").val());	
	
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
 		
		// 아이디 중복 검사를 통과하지 못했다면
		if (idChk == false || mailSend == false || mailChk == false) {
			return;
		}
		
		var form = $("#regForm")[0];
		var formData = new FormData(form);
			
		$.ajax({
			type : "POST",
			enctype : "multipart/form-data",
			url : "/user/regProc",
			data : formData,
			dataType : "JSON",
			processData : false,			// formData를 String으로 변환 X
			contentType : false,			// content-Type 헤더가 multipart/form-data로 전송
			cache : false,
			timeout : 600000,				// 6초
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				
				if (response.code == 0) {
					alert("회원가입이 완료되었습니다.");
					location.href = "/user/userForm";
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
</head>
<body>


<!-- 회원가입 -->
	<div class="wrapper">
		<div class="container">
			<div class="sign-up-container">
			
				<form name="regForm" id="regForm" method="post" enctype="multipart/form-data">
				    <a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
					<h1>Create Account</h1>
					
					<br>
			        <!-- 프로필 이미지 업로드 -->
			      <div class="profile-upload">
			          <label for="profileImg" class="upload-label">
			              <img id="profilePreview" src="/resources/images/default-profile.png" onerror="this.onerror=null; this.src='/resources/images/default-profile.png';">
			          </label>
			          <input type="file" id="profileImg" name="profileImg" accept="image/*" style="display: none;">
			      </div>

					<div class="inputBtn-container">
						<input type="text" id="userId" name="userId" class="leftBox" placeholder="ID">
						<button type="button" id="idBtn" class="form_btn idBtn rightBtn">
							<span class="idCheckMsg">아이디 중복 체크</span>
						</button>
					</div>
					<div class="msgBox">
						<span id="userIdMsg" class="msgText"></span>
					</div>

					<!-- 이메일 인증 추가하실 분은 아래의 div를 사용하시면 됩니다. -->
					
					<div class="inputBtn-container"> 
						<input type="email" id="userEmail" name="userEmail" class="leftBox" placeholder="Email">						
						<button type="button" id="emailBtn" class="form_btn emailBtn rightBtn">
							<span class="authSendMsg">인증번호 전송</span>
						</button>
					</div> 
					<div class="msgBox">
						<span id="userEmailMsg" class="msgText"></span>
					</div>

					<div class="inputBtn-container">
						<input type="text" id="authNum" name="authNum" class="emailInput leftBox" value="" placeholder="Authentication Number" maxlength="6">
						<button type="button" id="authBtn" class="form_btn authBtn rightBtn">
							<span class="authCheckMsg">인증번호 체크</span>
						</button>
					</div>
					<div class="msgBox">
						<span id="authNumMsg" class="msgText"></span>
					</div> 
					
<!-- 					<input type="email" id="userEmail" name="userEmail" placeholder="Email">
					<div class="msgBox">
						<span id="userEamilMsg" class="msgText"></span>
					</div> -->

					<input type="text" id="userName" name="userName" placeholder="Name">
					<div class="msgBox">
						<span id="userNameMsg" class="msgText"></span>
					</div>

					<input type="password" id="userPwd1" name="userPwd1" placeholder="Password">
					<div class="msgBox">
						<span id="userPwd1Msg" class="msgText"></span>
					</div>

					<input type="password" id="userPwd2" name="userPwd2" placeholder="Password Check">
					<div class="msgBox">
						<span id="userPwd2Msg" class="msgText"></span>
					</div>

					<div class="inputBtn-container">
						<input type="text" id="addrCode" name="addrCode" class="leftBox" placeholder="Postal Code" maxlength="5">
						<button type="button" id="addrBtn" class="form_btn emailBtn rightBtn" onclick="checkPost()">
							<span>우편번호 검색</span>
						</button>
					</div>
					
					<div class="msgBox">
						<span id="addrCodeMsg" class="msgText"></span>
					</div>
					
					<input type="text" id="addrBase" name="addrBase" placeholder="Address">
					
					<div class="msgBox">
						<span id="addrBaseMsg" class="msgText"></span>
					</div>
					
					<input type="text" id="addrDetail" name="addrDetail" placeholder="Detailed Address">
					<div class="msgBox">
						<span id="addrDetailMsg" class="msgText"></span>
					</div>

					<input type="hidden" id="userPwd" name="userPwd" value="">

					<button type="button" id="realSignUpBtn" class="form_btn">Sign Up</button>
				</form>
				
			</div>
			<div class="sign-in-container">
				<form>
				    <a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
					<h1>Sign In</h1>
					<div class="social-links">
						<!-- 소셜 로그인을 하실 분은 아래의 div를 사용하시면 됩니다 -->
						<!-- <div onclick="fn_naverLogin()">
							<img alt="" src="/resources/images/naver.png">
						</div> -->
					</div>
					<input type="text" id="userIdLogin" name="userIdLogin" placeholder="ID">
					<div class="msgBox">
						<span id="userIdLoginMsg" class="msgText"></span>
					</div>

					<input type="password" id="userPwdLogin" name="userPwdLogin" placeholder="Password" style="margin-top: 30px;">
					<div class="msgBox">
						<span id="userPwdLoginMsg" class="msgText"></span>
					</div>

					<div class="find-link">
						<span><a href="/user/findForm">Forgot your Account?</a></span>
					</div>

					<button type="button" id="realSignInBtn" class="form_btn">Sign In</button>
				</form>
			</div>
			<div class="overlay-container">
				<div class="overlay-left">
					<h1>Welcome Back</h1>
					<p>To keep connected with us please login with your personal info</p>
					<button id="signInBtn" class="overlay_btn">Sign In</button>
				</div>
				<div class="overlay-right">
					<h1>Hello, Friend</h1>
					<p>Enter your personal details and start journey with us</p>
					<button id="signUpBtn" class="overlay_btn">Sign Up</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>