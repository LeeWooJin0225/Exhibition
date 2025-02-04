<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">
<script type="text/javascript">
   $(document).ready(function() {
      // 햄버거 버튼 클릭 이벤트
      $('nav ul li a img[alt="햄버거버튼"]').on('click', function(event) {
         event.preventDefault();
         $('.dropdown-menu').toggle();
      });

      // 메뉴 외부를 클릭했을 때 드롭다운 메뉴 숨기기
      $(document).on('click', function(event) {
         if (!$(event.target).closest('nav').length) {
            $('.dropdown-menu').hide();
         }
      });
      
      //목록 버튼 클릭 시
      $("#listBtn").on("click", function() {
         document.bbsForm.boardType.value = ${boardType};
         document.bbsForm.action = "/board/list";
         document.bbsForm.submit();
      });
      
      // 첨부파일 첨부 시
      $('#brdFile').on('change', function() {
          var fileName = $(this).prop('files')[0].name;  // 선택된 파일 이름 가져오기
          $('.fileLabel').html('<img alt="" src="/resources/images/file.png" style="height: 20px;"> 첨부파일 업로드 : ' + fileName);
      });

      //글쓰기 버튼 클릭 시
      $("#writeBtn").on("click", function() {
  		if ($.trim($("#brdTitle").val()).length <= 0) {
			alert("제목을 입력해주세요.");
			$("#brdTitle").val("");
			$("#brdTitle").focus();
			return;
		}
		
		if ($.trim($("#brdContent").val()).length <= 0) {
			alert("내용을 입력해주세요.");
			$("#brdContent").val("");
			$("#brdContent").focus();
			return;
		}
		
    	 
		// 폼 객체 만들기
		var form = $("#writeForm")[0];
		var formData = new FormData(form);
		
	    // 중요글 체크박스 선택 여부 확인 후 값 추가
	    if ($("#impoChk").is(":checked")) {
	        formData.append("status", "I"); // 선택된 경우만 "I" 추가
	    }
	    
	    // 비밀글 체크박스 선택 여부 확인 후 값 추가
	    if ($("#secretChk").is(":checked")) {
	        formData.append("status", "S"); // 선택된 경우만 "S" 추가
	    }
	    
	    
	    // ######### 데이트 처리 시작 #########
	    if (${boardType} == 3) {
	    	
		   	let date = new Date(); //현재 날짜 (시간은 안 가져옴)
			let minDate = getFormatDate(date); 
			
			date.setDate(date.getDate() + 90);
			let maxDate = getFormatDate(date);
			
			var startDate = $("#startDate").val();
			var endDate = $("#endDate").val();
		    var price = $("#price").val();
		    
		    var comStartDate = new Date(startDate);
		    var comEndDate = new Date(endDate);
		    
		    // 한국시간으로 하려면 9시간 더해야 함!!!!!!!!! 
		    comStartDate.setHours(comStartDate.getHours() + 9);
		    comEndDate.setHours(comEndDate.getHours() + 9);

	    	
		   	if ($.trim(startDate).length <= 0) {
		   		alert("전시회 시작 날짜를 입력해주세요.");
		   		$("#startDate").focus();
		   		return;
		   	}
		   	
		   	if ($.trim(endDate).length <= 0) {
		   		alert("전시회 마감 날짜를 입력해주세요.");
		   		$("#endDate").focus();
		   		return;
		   	}
			
			if (startDate < minDate) {
				alert("오늘 이후의 날짜를 선택해주세요.");
				$("#startDate").focus();
				return;
			}
			
			if (comEndDate < comStartDate) {
				alert("전시 마감일은 전시 시작일보다 늦어야 합니다.");
				$("#comEndDate").focus();
				return;
			}
			
			if ($.trim(price).length <= 0) {
				alert("전시회 가격을 입력해주세요.");
				$("#price").focus();
				return;
			}

		    
			 // SQL에서 사용할 형식으로 변환 (예: "YYYY-MM-DD HH:MM:SS")
		    var formattedStartDate = comStartDate.toISOString().slice(0, 19).replace('T', ' ');
		    var formattedEndDate = comEndDate.toISOString().slice(0, 19).replace('T', ' ');
		    
		    // alert("formattedStartDate : " + formattedStartDate +", formattedEndDate : " + formattedEndDate);
			
			formData.append("realStartDate", formattedStartDate);
			formData.append("realEndDate", formattedEndDate);
	    }
		

			  
		$.ajax ({
			type : "POST",
			enctype : "multipart/form-data",
			url : "/board/writeProc",
			data : formData,
			processData : false,			// formData를 String으로 변환 X
			contentType : false,			// content-Type 헤더가 multipart/form-data로 전송
			cache : false,
			timeout : 600000,				// 6초
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				if (response.code == 0) {
					alert("게시글이 등록되었습니다.");
					document.bbsForm.action = "/board/list";
					document.bbsForm.submit();
				}
				else if (response.code == 400) {
					alert("파라미터 값이 넘어오지 않았습니다.");
					$("#brdTitle").focus();
				}
				else {
					alert("게시글 등록 중 오류가 발생하였습니다.(2)");
					$("#brdTitle").focus();
				}
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
				alert("게시글 등록 중 오류가 발생하였습니다.");
				$("#brdTitle").focus();
			}
		});
		
	  
	    
    	  
      });


   });
   
   function getFormatDate(date){
	    var year = date.getFullYear();              //yyyy
	    var month = (1 + date.getMonth());          //M
	    month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
	    var day = date.getDate();                   //d
	    day = day >= 10 ? day : '0' + day;          //day 두자리로 저장
	    return  year + '-' + month + '-' + day;       //'-' 추가하여 yyyy-mm-dd 형태 생성 가능
	}
   
   function fn_list(boardType) {
	      document.bbsForm.action = "/board/list";
	      document.bbsForm.submit();
	   }

</script>
</head>
<body>
   <!-- 헤더 영역 -->
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <!-- 배너 사진 -->
   <div class="banner-container">
      <img alt="" src="/resources/images/list_banner.jpg">
   </div>

   <!-- 메인 컨테이너 -->
   <div class="main-container write-main-cont">
      <div class="title-container">
         <h1>${boardTitle}</h1>
      </div>

      <div class="list-container">
         <div class="write-title-container">
            <span>글쓰기</span>
         </div>
         
         <form name="writeForm" id="writeForm" method="post" enctype="multipart/form-data">
	            <div class="write-container">
	            <input type="text" id="userName" name="userName" class="write-input" value="${user.userName }" readonly>
	            <input type="text" id="userEmail" name="userEmail" class="write-input" value="${user.userEmail }" readonly>
	             
	             
	     <!-- 중요 체크박스 추가 -->
	    <c:if test="${user.status eq 'A' && boardType eq '1'}">     
		        <div class="checkbox-container">
		            <input type="checkbox" id="impoChk" name="impoChk" value="I">
		            <label for="impoChk">중요글</label>
		        </div>
		</c:if> 
		
		<c:if test="${boardType eq '2' || boardType eq '4'}">
				<div class="checkbox-container">
		            <input type="checkbox" id="secretChk" name="secretChk">
		            <label for="secretChk">비밀글</label>
		        </div>
		</c:if>     
		
		
		<!--  전시 게시판일 때 처리 -->
		<c:choose>
                  <c:when test="${boardType eq 3 }">
                     <!-- 전시 일시 설정 -->
                     <div class="exhibi-info-container">
                        <div class="exhibi-container-list">
                           <div class="info-title">
                              <span>전시 시작일</span>
                           </div>
                           <div class="info-date">
                              <input type="datetime-local" id="startDate" name="startDate" placeholder="전시 시작일" />
                           </div>
                        </div>
                        <div class="exhibi-container-list">
                           <div class="info-title">
                              <span>전시 종료일</span>
                           </div>
                           <div class="info-date">
                              <input type="datetime-local" id="endDate" name="endDate" placeholder="전시 종료일" />
                           </div>
                        </div>
                        <div class="exhibi-container-list">
                           <div class="info-title">
                              <span>가격</span>
                           </div>
                           <div class="info-date">
                              <input type="number" id="price" name="price">
                           </div>
                        </div>
                     </div>
                  </c:when>
       </c:choose>
       <!--  전시 게시판일 때 처리 끝 -->       
               
               
		        
	            <input type="text" id="brdTitle" name="brdTitle" class="write-input" placeholder="제목을 입력하세요">
	            <div class="write-input file-input">
	               <label for="brdFile" class="fileLabel"><img alt="" src="/resources/images/file.png" style="height: 20px;"> 첨부파일 업로드</label>
	            </div>
	            <input type="file" id="brdFile" name="brdFile" class="write-input" placeholder="파일을 선택하세요." required />
	            <textarea id="brdContent" name="brdContent" class="write-input" placeholder="내용을 입력하세요"></textarea>
	         </div>
	         
	         <input type="hidden" name="boardType" value="${boardType }">
         </form>
         
         <div class="write-btn-container">
            <button type="button" id="writeBtn" class="writeBtn">완료</button>
            <button type="button" id="listBtn" class="writeBtn">목록</button>
         </div>
      </div>
   </div>

   <!-- 푸터 영역 -->
   <%@ include file="/WEB-INF/views/include/footer.jsp"%>

   <form id="bbsForm" name=bbsForm method="post">
      <input type="hidden" name="boardType" value="${boardType }">
   </form>
</body>
</html>