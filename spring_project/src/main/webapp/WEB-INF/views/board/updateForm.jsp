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

      // 글수정 버튼 클릭 시
      $("#updateBtn").on("click", function() {
         fn_write();
      });

      // 목록 버튼 클릭 시
      $("#listBtn").on("click", function() {
         document.bbsForm.action = "/board/list";
         document.bbsForm.submit();
      });
      
      // 첨부파일 첨부 시
       $('#brdFile').on('change', function() {
           var fileName = $(this).prop('files')[0].name;  // 선택된 파일 이름 가져오기
           $('.fileLabel').html('<img alt="" src="/resources/images/file.png" style="height: 20px;"> 첨부파일 업로드 : ' + fileName);
       });
   });

   function fn_write() {

      if ($.trim($("#brdTitle").val()).length <= 0) {
         alert("제목을 입력하세요!");
         $("#brdTitle").val();
         $("#brdTitle").focus();
         return;
      }

      if ($.trim($("#brdContent").val()).length <= 0) {
         alert("내용을 입력하세요!");
         $("#brdContent").val("");
         $("#brdContent").focus();
         return;
      }

      var form = $("#updateForm")[0];
      var formData = new FormData(form);
      
      //ajax
      $.ajax ({
    	   type : "POST",
		   enctype : "multipart/form-data",
		   url : "/board/updateProc",
		   data : formData,
		   processData : false,
		   contentType : false,
		   cache : false,
		   beforeSend : function(xhr) {
			   xhr.setRequestHeader("AJAX", true);
		   },
		   success : function(response) {
			   if (response.code == 0) {
				   alert("게시글이 수정되었습니다.");
				   location.href = "/board/list";S
			   }
			   else if (response.code == 400) {
				   alert("파라미터 값이 올바르지 않습니다.");
				   $("#btnUpdate").prop("disabled", false);
			   }
			   else if (response.code == 403) {
				   alert("본인 게시글이 아닙니다.");
				   $("#btnUpdate").prop("disabled", false);
			   }
			   else if (response.code == 404) {
				   alert("게시글이 존재하지 않습니다.");
				   location.href = "/board/list";
			   }
			   else {
				   alert("게시글 수정 중 오류가 발생하였습니다. (2)");
				   $("#btnUpdate").prop("disabled", false);
			   }
		   },
		   error : function (error) {
			   icia.common.error(error);
			   alert("게시글 수정 중 오류가 발생하였습니다.");
			   $("#btnUpdate").prop("disabled", false);
		   }
      });
      
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
         <h1><span onclick="fn_list(${boardType})">${boardTitle}</span></h1>
      </div>

      <div class="list-container">
         <div class="write-title-container">
            <span>글수정</span>
         </div>
         
         
         <form name="updateForm" id="updateForm" method="post" enctype="multipart/form-data">
            <div class="write-container">
               <input type="text" id="userName" name="userName" class="write-input" value="${brd.userName }" readonly>
               <input type="text" id="userEmail" name="userEmail" class="write-input" value="${brd.userEmail }" readonly>
               <input type="text" id="brdTitle" name="brdTitle" class="write-input" value="${brd.brdTitle }" placeholder="제목을 입력하세요">
               <div class="write-input file-input">
                  <label for="brdFile" class="fileLabel"><img alt="" src="/resources/images/file.png" style="height: 20px;">
<c:choose>
	<c:when test="${!empty brd.brdFile }">   
                   ${brd.brdFile.fileOrgName }
    </c:when>
    <c:otherwise>
                    첨부파일 업로드
    </c:otherwise>
</c:choose>                     
                    </label>
                   
               </div>
               <input type="file" id="brdFile" name="brdFile" class="write-input" placeholder="파일을 선택하세요." required />
               <textarea id="brdContent" name="brdContent" class="write-input" placeholder="내용을 입력하세요">${brd.brdContent }</textarea>

			   <input type="hidden" name="brdSeq" value="${brd.brdSeq }">
               <input type="hidden" name="boardType" value="${boardType }">
            </div>
            <div class="write-btn-container">
               <button type="button" id="updateBtn" class="writeBtn">수정</button>
               <button type="button" id="listBtn" class="writeBtn">목록</button>
            </div>
         </form>
         
         
      </div>
   </div>

   <!-- 푸터 영역 -->
   <%@ include file="/WEB-INF/views/include/footer.jsp"%>

   <form id="bbsForm" name=bbsForm method="post">
      <input type="hidden" name="boardType" value="${boardType }">
      <input type="hidden" name="brdSeq" value="${brd.brdSeq }">
      <input type="hidden" name="searchType" value="${searchType }">
      <input type="hidden" name="searchValue" value="${searchValue }">
      <input type="hidden" name="curPage" value="${curPage }">
   </form>
</body>
</html>