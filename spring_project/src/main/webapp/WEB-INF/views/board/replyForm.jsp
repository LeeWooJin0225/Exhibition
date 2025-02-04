<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">
<script type="text/javascript">
   $(document).ready(function() {
	   
	   
<c:choose>
	<c:when test="${empty brd}">
		alert("답변할 게시글이 존재하지 않습니다.");
		location.href = "/board/list";
	</c:when>
	   
	<c:otherwise>
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
    		var form = $("#replyForm")[0];
    		var formData = new FormData(form);
    	    
    	    // 비밀글 체크박스 선택 여부 확인 후 값 추가
    	    if ($("#secretChk").is(":checked")) {
    	        formData.append("status", "S"); // 선택된 경우만 "S" 추가
    	    }
    		
    		$.ajax ({
    			type : "POST",
    			enctype : "multipart/form-data",
    			url : "/board/replyProc",
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
    					alert("답변이 등록되었습니다.");
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
      
   });

   function fn_list(boardType) {
      document.bbsForm.boardType.value = boardType;
      document.bbsForm.action = "/board/list";
      document.bbsForm.submit();
   }
   
   
   </c:otherwise>
</c:choose>   
  
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
            <span>답변</span>
         </div>
         
         
     <form name="replyForm" id="replyForm" method="post" enctype="multipart/form-data">   
         <div class="write-container">
            <input type="text" id="userName" name="userName" class="write-input" value="${user.userName }" readonly>
            <input type="text" id="userEmail" name="userEmail" class="write-input" value="${user.userEmail }" readonly>
            
            		<c:if test="${boardType eq '2' || boardType eq '4'}">
				<div class="checkbox-container">
		            <input type="checkbox" id="secretChk" name="secretChk">
		            <label for="secretChk">비밀글</label>
		        </div>
		</c:if>  
            
            
            <input type="text" id="brdTitle" name="brdTitle" class="write-input" value="${brd.brdTitle}" placeholder="제목을 입력하세요">
            <div class="write-input file-input">
               <label for="brdFile" class=""><img alt="" src="/resources/images/file.png" style="height: 20px;"> 첨부파일 업로드</label>
            </div>
            <input type="file" id="brdFile" name="brdFile" class="write-input" placeholder="파일을 선택하세요." required />
            <textarea id="brdContent" name="brdContent" class="write-input" placeholder="내용을 입력하세요"></textarea>
         </div>
         
         <input type="hidden" name="boardType" value="${brd.boardType }">
         <input type="hidden" name="brdSeq" value="${brd.brdSeq }">
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
      <input type="hidden" name="boardType" value="${brd.boardType }">
      <input type="hidden" name="brdSeq" value="">
      <input type="hidden" name="searchType" value="${searchType }">
      <input type="hidden" name="searchValue" value="${searchValue }">
      <input type="hidden" name="curPage" value="${curPage }">
   </form>
</body>
</html>