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
      //비밀번호 찾기 화면으로 이동
      $("#findPwdBtn").on("click", function() {
         $(".container").addClass("right-panel-active");
      });

      //아이디 찾기 화면으로 이동
      $("#findIdBtn").on("click", function() {
         $(".container").removeClass("right-panel-active");
      });
      
      // ########### PWD 찾기 ########### 
		//아이디 입력 후 엔터
		$("#userIdPwd").on("keypress", function(e) {
			if (e.which == 13)
				fn_findPwd();
		});
	
		//이메일 입력 후 엔터
		$("#userEmailPwd").on("keypress", function(e) {
			if (e.which == 13)
				fn_findPwd();
		});
		
		$("#realFindPwdBtn").on("click", function() {
			fn_findPwd();
		})
		
		
	    // ########### ID 찾기 ########### 
	    // 이름 입력 후 엔터
		$("#userNameId").on("keypress", function(e) {
			if (e.which == 13)
				fn_findId();
		});
	
		// 이메일 입력 후 엔터
		$("#userEmailId").on("keypress", function(e) {
			if (e.which == 13)
				fn_findId();
		});
		
		$("#realFindIdBtn").on("click", function() {
			fn_findId();
		})
		
	});

	//input 하단의 안내 메세지 모두 숨김
	function fn_displayNone() {
		$("#userIdPwdMsg").css("display", "none");
		$("#userEmailPwdMsg").css("display", "none");
		$("#userNameIdMsg").css("display", "none");
		$("#userEmailIdMsg").css("display", "none");
	}
	
	// 비밀번호 찾기
	function fn_findPwd() {
		
		fn_displayNone();
		
		if ($.trim($("#userIdPwd").val()).length <= 0) {
			$("#userIdPwdMsg").text("아이디를 입력하세요.");
			$("#userIdPwdMsg").css("display", "inline");
			$("#userIdPwd").val("");
			$("#userIdPwd").focus();
			return;
		}
		
		if ($.trim($("#userEmailPwd").val()).length <= 0) {
			$("#userEmailPwdMsg").text("이메일을 입력하세요.");
			$("#userEmailPwdMsg").css("display", "inline");
			$("#userEmailPwd").val("");
			$("#userEmailPwd").focus();
			return;
		}
		
		if (!fn_validateEmail($("#userEmailPwd").val())) {
			$("#userEmailPwdMsg").text("이메일 형식이 올바르지 않습니다.");
			$("#userEmailPwdMsg").css("display", "inline");
			$("#userEmailPwd").focus();
			return;
		}
		
		// 비밀번호 찾기 AJAX
		$.ajax ({
			type : "POST",
			url : "/sendMail.pwd",
			data : {
				userId : $("#userIdPwd").val(),
				userEmail : $("#userEmailPwd").val()
			},
			dataType : "JSON",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				
				if (response.code == 0) {
					alert("이메일로 임시 비밀번호가 전송되었습니다.");
					location.href = "/user/userForm";
				}
				else if (response.code == 404) {
					alert("입력하신 정보와 일치하는 회원이 존재하지 않습니다.");
				}
				else if (response.code == 400) {
					alert("파라미터 값이 넘어오지 않았습니다.");
				}
				else if (response.code == 405) {
					alert("입력한 정보가 일치하지 않습니다.");
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
	
	// 아이디 찾기
	function fn_findId() {
		
		fn_displayNone();
		
		if ($.trim($("#userNameId").val()).length <= 0) {
			$("#userNameIdMsg").text("이름을 입력하세요.");
			$("#userNameIdMsg").css("display", "inline");
			$("#userNameId").val("");
			$("#userNameId").focus();
			return;
		}
		
		if ($.trim($("#userEmailId").val()).length <= 0) {
			$("#userEmailIdMsg").text("이메일을 입력하세요.");
			$("#userEmailIdMsg").css("display", "inline");
			$("#userEmailId").val("");
			$("#userEmailId").focus();
			return;
		}
		
		if (!fn_validateEmail($("#userEmailId").val())) {
			$("#userEmailIdMsg").text("이메일 형식이 올바르지 않습니다.");
			$("#userEmailIdMsg").css("display", "inline");
			$("#userEmailId").focus();
			return;
		}
		
		// 아이디 찾기 AJAX
		$.ajax ({
			type : "POST",
			url : "/user/idFind",
			data : {
				userName : $("#userNameId").val(),
				userEmail : $("#userEmailId").val()
			},
			dataType : "JSON",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				
				var data = icia.common.objectValue(response, "data", -500);
				
				if (response.code == 0) {
					alert("아이디는 " + data.userId + "입니다!");
					location.href = "/user/userForm";
				}
				else if (response.code == 404) {
					alert("입력하신 정보와 일치하는 회원이 존재하지 않습니다.");
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


	function fn_validateEmail(value) {
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

		return emailReg.test(value);
	}
</script>
</head>
<body>
   <div class="wrapper findWrap">
      <div class="container">
         <div class="sign-up-container">
            <form>
               <a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
               <h1>Find your Password</h1>
               <input type="text" id="userIdPwd" name="userIdPwd" placeholder="Id" style="margin: 8px 0px;">
               <div class="msgBox"><span id="userIdPwdMsg" class="msgText"></span></div>

               <input type="email" id="userEmailPwd" name="userEmailPwd" placeholder="Email">
               <div class="msgBox"><span id="userEmailPwdMsg" class="msgText"></span></div>

               <button type="button" id="realFindPwdBtn" class="form_btn">Find</button>
            </form>
         </div>
         <div class="sign-in-container">
            <form>
               <a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
               <h1>Find your ID</h1>
               <input type="text" id="userNameId" name="userNameId" placeholder="Name" style="margin: 8px 0px;">
               <div class="msgBox"><span id="userNameIdMsg" class="msgText"></span></div>

               <input type="email" id="userEmailId" name="userEmailId" placeholder="Email">
               <div class="msgBox"><span id="userEmailIdMsg" class="msgText"></span></div>

               <div class="find-link">
                  <span><a href="/user/userForm">Are you sure you want to Sign In?</a></span>
               </div>

               <button type="button" id="realFindIdBtn" class="form_btn">Find</button>
            </form>
         </div>
         <div class="overlay-container">
            <div class="overlay-left">
               <h1>Forgot your ID?</h1>
               <p>Finding Account Information</p>
               <button id="findIdBtn" class="overlay_btn">Find ID</button>
            </div>
            <div class="overlay-right">
               <h1>Forgot your Password?</h1>
               <p>Finding Account Information</p>
               <button id="findPwdBtn" class="overlay_btn">Find Pwd</button>
            </div>
         </div>
      </div>
   </div>
   
   <form id="userForm" name="userForm" method="post">
      <input type="hidden" name="userEmailInput" value="" >
   </form>
</body>
</html>