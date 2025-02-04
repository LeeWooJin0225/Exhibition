<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">
<script type="text/javascript">
   $(document).ready(function() {
	
	   <c:if test="${boardType eq 3 }">            	   
		   var date = (new Date()).toISOString().substring(0, 10);
	       drawMonth(date);
	
	       $('.month-move').on('click', function (e) {
	           e.preventDefault();
	
	           drawMonth($(this).data('ym'));
	       });
       </c:if>
	   
	  // 댓글 조회
	  fn_getCommList();
	   
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

      //좋아요 버튼 클릭 시
      $("#recomBtn").on("click", function() {
         
         var userId = "${cookieUserId}";
         var brdSeq = ${brdSeq};
         
         if (userId == "") {
        	 alert("로그인 후 이용 가능하십니다.");
        	 return;
         }
         
         $.ajax ({
        	 type : "POST",
        	 url : "/board/like",
        	 data : {
        		 userId, brdSeq
        	 },
			dataType : "JSON",
			beforeSend:function(xhr)
	        {
	        	 xhr.setRequestHeader("AJAX", "true");
	        },
	        success:function(res)
	        {
	        	var button = document.getElementById("recomBtn");
	            
	        	if (res.code == 0) {
	        		alert("좋아요를 누르셨습니다.");
	        		button.style.background = '#4B89DC'; // 파란색
	        		likeCnt.innerText = res.data;
	        	}
	        	else if (res.code == 300) {
	        		alert("좋아요를 취소하셨습니다.");
	        		button.style.background = '#d76464'; // 빨간색
	        		likeCnt.innerText = res.data;
	        	}
	        	else {
	        		alert("좋아요 처리 중 오류가 발생하였습니다.");
	        	}
	        },
	        error:function(error)
	        {
	        	 icia.common.error(error);
	        }
	        
         });
      });

      //답글 버튼 클릭 시
      $("#writeBtn").on("click", function() {
         document.bbsForm.action = "/board/replyForm";
         document.bbsForm.submit();
      });

      //수정 버튼 클릭 시
      $("#updateBtn").on("click", function() {
         document.bbsForm.action = "/board/updateForm";
         document.bbsForm.submit();
      });

      //삭제 버튼 클릭 시
      $("#deleteBtn").on("click", function() {
    	  fn_delete();
      });

      //목록 버튼 클릭 시
      $("#listBtn").on("click", function() {
         document.bbsForm.action = "/board/list";
         document.bbsForm.submit();
      });

      //댓글 작성 버튼 클릭 시
      $("#btnCommSubmit").on("click", function() {
         fn_commSumbit();
      });
      
      let popupWindow = null;
      
      // 구매 버튼 클릭시
      $("#btnPurchase").on("click", function() {
    	  
          // 오라클에서 가져온 날짜 문자열
          const oracleDateMin = "${brd.startDate}"; 	  // 최소 날짜
          const oracleDateMax = "${brd.endDate}}";  //  최대 날짜

          // 날짜 형식 변환 함수
          function formatDateForInput(dateString) {
              const [datePart] = dateString.split(" "); // 시간 부분은 무시
              const [year, month, day] = datePart.split(".");
              
              // Date 객체 생성 (UTC로 설정) 
              const date = new Date(Date.UTC(year, month - 1, day)); // month는 0부터 시작하므로 -1

              // YYYY-MM-DD 형식으로 변환
              const formattedDate = date.toISOString().split('T')[0];
              
              return formattedDate; // YYYY-MM-DD 형식으로 반환
          }

          // 변환된 날짜
          // YYYY-MM-DD
          const minDate = formatDateForInput(oracleDateMin);	// 전시 시작일
          const maxDate = formatDateForInput(oracleDateMax);	// 전시 마감일
          
          // 선택한 날짜 값 가져오기
          var selectedDate = document.getElementById('selectDate').value;
   	   
	   	   if ($.trim(selectedDate).length <= 0) {
	   		   alert("전시회 관람일을 선택해주세요.");
	   		   return;
	   	   }
   	   
    	  /* 팝업창 테스트 */
		   let _width = 800;
           let _height = 600;
           
           let _left = Math.ceil((window.screen.width - _width) / 2);
           let _top = Math.ceil((window.screen.height - _height) / 2);
           
/*             // dateInput 요소 가져오기
            var dateInput = document.getElementById("dateInput");
            
            // min과 max 값 가져오기
            var minDate = dateInput.min;
            var maxDate = dateInput.max; */
      	  
     	   var purDate = $("#selectDate").val();
           // alert(purDate);
          
	           // 전달할 값
	   		var realPurDate = new Date(purDate);
		    var viewDate = realPurDate.toISOString().slice(0, 19).replace('T', ' ');
			var price = ${brd.price};
			var userId = "${cookieUserId}";
			var exhiName = "${brd.brdTitle}";
			var brdSeq = ${brd.brdSeq};
			
			// alert(minDate + ", " + maxDate);
		
			let formData = {
				    viewDate: viewDate,
				    minDate: minDate,
				    maxDate: maxDate,
				    price: price,
				    userId: userId,
				    exhiName: exhiName,
				    brdSeq: brdSeq
				};
	
			// URLSearchParams를 이용해 객체를 쿼리스트링으로 변환
			let queryString = new URLSearchParams(formData).toString();
			let url = "/board/orderPage?" + queryString;
			
		    // 기존 팝업이 열려 있다면 닫기
		      if(popupWindow != null)
		      {
		         if(icia.common.type(popupWindow) == "object" && !popupWindow.closed)
		         {
		            popupWindow.close();
		         }
		         
		         popupWindow = null;
		      }
			
		      popupWindow = window.open(url, "_blank", "width=" + _width + ",height=" + _height + ",left=" + _left + ",top=" + _top);

    	  
    	  // fn_purchase();
      });
   });

   function fn_list(boardType) {
      document.bbsForm.action = "/board/list";
      document.bbsForm.submit();
   }
   
   function fn_delete() {
	   if (confirm("게시글을 삭제하시겠습니까?")) {
		   
		   $.ajax({
				type : "POST",
				url : "/board/delete",
				data : {
					brdSeq : ${brdSeq}
				},
				dataType : "JSON",
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");	
				},
				success : function (response) {
					if (response.code == 0) {
						alert("게시글이 삭제되었습니다.");
						location.href = "/board/list";
					}
					else {
						alert("게시글 삭제 중 오류가 발생하였습니다.");
					}
				},
				error : function (xhr, status, error) {
					icia.common.error(error);
				}
		   });
		   
	   }
   }
   
   
   // ############ 댓글 처리 시작 ############
   function fn_getCommList() {
	   
	   const commContent = $("#commContent").val();
	   const brdSeq = ${brd.brdSeq};
	   
	   $.ajax ({
		   type : "POST",
		   url : "/board/commList",
		   data : {
			   brdSeq
		   },
		   datatype : "JSON",
		   beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				if (response.code == 0) {
					
					var data = response.data;
					var commHtml = "<div>";
					
					for (var i = 0; i < data.length; i++) {
		                console.log("data.length: " + data.length + ", userName: " + data[i].userName + 
		                		", userId: " + data[i].userId + ", commSeq: " + data[i].commSeq + 
		                		", data[i].commContent: " + data[i].commContent
		                		+", data[i].commMe: " + data[i].commMe
		                		+", data[i].commIndent: " + data[i].commIndent
		                		+", data[i].status : " + data[i].status
		                		+", data[i].parentCommName : " + data[i].parentCommName
		                		+", data[i].dateAgo : " + data[i].dateAgo
		                		+", data[i].fileExt : " + data[i].fileExt);
		                
		                
		                // list에서 받아온 값 정리
		                var commSeq = data[i].commSeq;
		                var commMe = data[i].commMe;
		                var commContent = data[i].commContent;
		                var regDate = data[i].regDate;
		                var userName = data[i].userName;
		                var userId = data[i].userId;
		                var compareUserId = "${brd.userId}";
		                var commIndent = data[i].commIndent;
		                var status = data[i].status;
		                var parentCommName = data[i].parentCommName;
		                var dateAgo = data[i].dateAgo;
		                var fileExt = data[i].fileExt;
		                
		                commHtml += '<div class="comment" id="commNum' + commSeq + '">';
		                
		                // 삭제된 댓글이라면
		                if (status == 'N') {
			                commHtml += '        <p class="comment-text">' + "삭제된 댓글입니다." + '</p>';
			                commHtml += '</div>';
		                }
		                else {
		                	
			                // 대댓글일 경우 들여쓰기 적용하여 이미지 추가
			                if (commIndent > 0) {
			                	commHtml += '<div class="reply-content">';
			                	commHtml += '<div class="reply-icon" style="margin-left:' + (commIndent) + 'em;">';
			                	commHtml += '<img src="/resources/images/reply.webp" width="20px">';
			                	commHtml += '</div>';
			                }
			                
			                commHtml += '    <div class="comment-content">';
			                commHtml += '        <div class="comment-header">';
			                
			                
			                // 프로필 사진 처리
			                if (fileExt !== undefined) {
			                	commHtml += '            <div class="profile-pic"><img src="/resources/profile/' + userId + '.' + fileExt + '" onerror="this.onerror=null; this.src="/resources/images/default-profile.png";></div>';
			                }
			                else {
			                	commHtml += '            <div class="profile-pic"><img src="/resources/images/default-profile.png"></div>';
			                }
			                
			                commHtml += '            <span class="username">' + userName + '</span>';
			                
			                if (compareUserId == userId) {
			                	commHtml += '	<span class="badge">작성자</span>'; 
			                }
			                
			                commHtml += '&nbsp; &nbsp;' + dateAgo +'';
			                commHtml += '        </div>';
			                
			                if (commIndent > 0) {
			                	commHtml += '        <p class="comment-text">' + commContent + '</p>';
			                }
			                else {
			                	commHtml += '        <p class="comment-text">' + commContent + '</p>';
			                }
			                
			                
			                commHtml += '        <div class="comment-footer">';
			                commHtml += '            <span class="timestamp">' + regDate + '</span>';
			                commHtml += '            <div class="footer-buttons">';
			                commHtml += '                <button class="reply" type="button" id="btnCommReply' + commSeq + '">답글</button>';
			                
			                // 내가 쓴 댓글이면 수정/삭제 보이도록
			                if (data[i].commMe == "Y") {
			                	commHtml += '                <button class="edit-btn" type="button" id="btnCommUpdate' + commSeq + '">수정</button>';
			                	commHtml += '                <button class="delete-btn" type="button" id="btnCommDelete' + commSeq +'">삭제</button>';
			                }
			                
			                commHtml += '            </div>';
			                commHtml += '        </div>';
			                commHtml += '    </div>';
			                commHtml += '</div>';
			                
			                if (commIndent > 0) {
			                	commHtml += '</div>';
			                }
			                
						}
					}

					
	                $("#commList").html(commHtml);

				}
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
				alert("댓글 등록 중 오류가 발생하였습니다.");
			}
	   });
	   
   }
   
   // 댓글 등록
   function fn_commSumbit() {
	   
       if ("${cookieUserId}" == "") {
      	 alert("로그인 후 이용 가능하십니다.");
      	 return;
       }
	   
	   if ($.trim($("#commContent").val()).length <= 0) {
		   alert("댓글 내용을 입력해주세요!");
		   $("#commContent").val("");
		   $("#commContent").focus();
		   return;
	   }
	   
	   var brdSeq = ${brd.brdSeq};
	   var commContent = $("#commContent").val();
	   
	   $.ajax({
		   type : "POST",
		   url : "/board/commInsertProc",
		   data : {
			 	brdSeq,
			 	commContent
		   },
		   datatype : "JSON",
		   beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				if (response.code == 0) {
					$("#commContent").val("");
					fn_getCommList();
				}
				else if (response.code == 01) {
					alert("댓글 등록에 실패하였습니다.");
				}
				else if (response.code == 400) {
					alert("파라미터 값이 잘못되었습니다.");
				}
				else if (response.code == 404) {
					alert("해당 게시글이 존재하지 않습니다.");
					location.href = "/board/list";
				}
				else {
					alert("댓글 등록 중 오류가 발생하였습니다. (2)");
				}
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
				alert("댓글 등록 중 오류가 발생하였습니다.");
			}
	   });
	   
   }
   
   // 댓글 수정 버튼 클릭시
   $(document).on("click","[id^=btnCommUpdate]", function() {
	    // 클릭된 댓글의 시퀀스 번호 추출
	    var commSeq = $(this).attr("id").replace("btnCommUpdate", "");

	    // 모든 댓글의 수정 박스와 버튼 숨기기
	    $(".comment-edit-box").remove();
	    $(".comment-edit-actions").remove();

	    // 모든 댓글의 내용과 버튼 다시 보이기
	    $(".comment-text").show();
	    $(".comment-actions").show();
	    $(".footer-buttons").show();
	    $(".timestamp").show(); // 작성 날짜 다시 보이기

	    // 현재 댓글 내용
	    var currentContent = $("#commNum" + commSeq + " .comment-text").text();

	    // 댓글 내용을 textarea로 변환하고 기존 스타일 유지
	    var editHtml = '<div class="comment-edit-box">';
	    editHtml += '<textarea id="editCommContent' + commSeq + '" class="comment-box" style="width: 100%; height: 80px; border: 1px solid #ccc; padding: 10px; border-radius: 5px; box-sizing: border-box;">' + currentContent + '</textarea>';
	    editHtml += '</div>';

	    // 수정 완료, 수정 취소 버튼 추가
	    editHtml += '<div class="comment-edit-actions" style="text-align: left; margin-top: 10px;">';
	    editHtml += '<button type="button" class="comment-actions-btn btnCommSave" id="btnCommSave' + commSeq + '" data-commseq="' + commSeq + '" style="padding: 3px 8px; margin-right: 5px; border: 1px solid #ddd; background-color: #fff; border-radius: 5px; cursor: pointer;">수정</button>';
	    editHtml += '<button type="button" class="comment-actions-btn btnCommCancel" id="btnCommCancel' + commSeq + '" data-commseq="' + commSeq + '" style="padding: 3px 8px; margin-right: 5px; border: 1px solid #ddd; background-color: #fff; border-radius: 5px; cursor: pointer;">취소</button>';
	    editHtml += '</div>';

	    // 기존 댓글 내용과 버튼 숨기기
	    $("#commNum" + commSeq + " .comment-text").hide();
	    $("#commNum" + commSeq + " .comment-actions").hide();
	    $("#commNum" + commSeq + " .footer-buttons").hide();
	    $("#commNum" + commSeq + " .timestamp").hide(); // 작성 날짜 숨기기

	    // 수정할 수 있는 textarea와 버튼 추가
	    $("#commNum" + commSeq).append(editHtml);
   });
   
   // 수정 취소 버튼 클릭시
   $(document).on("click", ".btnCommCancel", function() {
	   var commSeq = $(this).data("commseq");
	   
	    // 모든 댓글의 수정 박스와 버튼 숨기기
	    $(".comment-edit-box").remove();
	    $(".comment-edit-actions").remove();

	    // 모든 댓글의 내용과 버튼 다시 보이기
	    $(".comment-text").show();
	    $(".comment-actions").show();
	    $(".footer-buttons").show();
	    $(".timestamp").show(); // 작성 날짜 다시 보이기
   });
   
   // 수정 완료 버튼 클릭시
   $(document).on("click", ".btnCommSave", function() {
	    var commSeq = $(this).data("commseq"); // 댓글 번호
	    var newContent = $("#editCommContent" + commSeq).val();	// 수정된 댓글 내용
	    var brdSeq = ${brd.brdSeq};	// 게시글 번호
	    
	    if ($.trim(newContent).length <= 0) {
	    	alert("댓글 내용을 입력해주세요!");
	    	$("#newContent").focus();
	    	return;
	    }
	    
	    $.ajax({
			   type : "POST",
			   url : "/board/commUpdateProc",
			   data : {
				    brdSeq,
				    commSeq,
				 	newContent
			   },
			   datatype : "JSON",
			   beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					if (response.code == 0) {
						fn_getCommList();
					}
					else if (response.code == -1) {
						alert("댓글 수정에 실패하였습니다.");
					}
					else if (response.code == 400) {
						alert("파라미터 값이 잘못되었습니다.");
					}
					else if (response.code == 404) {
						alert("해당 게시글이 존재하지 않습니다.");
						location.href = "/board/list";
					}
					else {
						alert("댓글 수정 중 오류가 발생하였습니다. (2)");
					}
				},
				error : function(xhr, status, error) {
					icia.common.error(error);
					alert("댓글 수정 중 오류가 발생하였습니다.");
				}
		   });
   });
   
   // 댓글 삭제 버튼 클릭시
   $(document).on("click", "[id^=btnCommDelete]", function() {
	     var brdSeq = ${brd.brdSeq};	// 게시글 번호
	     var commSeq = $(this).attr("id").replace("btnCommDelete", "");	// 댓글 번호
	     
    	 if (confirm("댓글을 삭제하시겠습니까?")) {
    		
    		 $.ajax({
  			   type : "POST",
  			   url : "/board/commDeleteProc",
  			   data : {
  				    brdSeq,
  				    commSeq
  			   },
  			   datatype : "JSON",
  			   beforeSend : function(xhr) {
  					xhr.setRequestHeader("AJAX", "true");
  				},
  				success : function(response) {
  					if (response.code == 0) {
						fn_getCommList();
					}
					else if (response.code == -1) {
						alert("댓글 삭제 실패하였습니다.");
					}
					else if (response.code == 400) {
						alert("파라미터 값이 잘못되었습니다.");
					}
					else if (response.code == 404) {
						alert("해당 게시글이 존재하지 않습니다.");
						location.href = "/board/list2";
					}
					else {
						alert("댓글 삭제 중 오류가 발생하였습니다. (2)");
					}
  				},
  				error : function(xhr, status, error) {
					icia.common.error(error);
					alert("댓글 삭제 중 오류가 발생하였습니다.");
				}
  				
    		 });
    	}
   });
   
   // 답글 버튼 클릭시
   $(document).on("click", "[id^=btnCommReply]", function() {
	   
	    var commSeq = $(this).attr("id").replace("btnCommReply", "");
	    var cookieUserId = "${cookieUserId}";
	    var userName = "${user.userName}";
	    
	    // 이미 열려 있는 답글 박스를 닫기
	    $(".reply-container").not("#replyCommBox" + commSeq).hide();
	    
	    // 이미 답글 박스가 있는지 확인
	    if ($("#replyCommBox" + commSeq).length === 0) {
	    	
	    	var replyHtml = '<div id="replyCommBox' + commSeq + '" class="reply-container">';
	    	replyHtml += '<div class="reply-content">'; // 큰 div 추가
		    replyHtml += '<div class="reply-icon">'; // 왼쪽 이미지 div
	    	replyHtml += '<img src="/resources/images/reply.webp" width="20px">';
	    	replyHtml += '</div>'; // 왼쪽 이미지 div 종료
	    	replyHtml += '<div class="reply-text">'; // 오른쪽 답글 div
	    	replyHtml += '<div class="reply-author"><strong>' + userName + '</strong></div>'; // 작성자 이름 추가
	    	replyHtml += '<textarea class="comment-box" id="replyCommContent' + commSeq + '" placeholder="답글을 작성하세요..."></textarea>';
	    	replyHtml += '<div class="comment-options">';
	    	replyHtml += '<button type="button" class="comment-actions-btn btnCommReplySubmit">등록</button>'; // 등록 버튼
	    	replyHtml += '<button type="button" class="comment-actions-btn btnCommReplyCancel">취소</button>'; // 등록 취소 버튼
	    	replyHtml += '</div>';
	    	replyHtml += '</div>'; // 오른쪽 답글 div 종료
	    	replyHtml += '</div>'; // 큰 div 종료
	    	replyHtml += '</div>';

	        // 해당 댓글 아래에 답글 UI 추가 (댓글 바깥에 추가)
	        $(this).closest('.comment').after(replyHtml);
	        
	    } else {
	        // 이미 답글 박스가 존재하면, 해당 박스를 토글할 수 있습니다.
	        $("#replyCommBox" + commSeq).toggle();
	    }
   });
   
   // 답글 취소 버튼 클릭시
   $(document).on("click", ".btnCommReplyCancel", function() {
       // 답글 입력창 제거
       $(this).closest(".reply-container").remove();
   });
   
   // 답글 등록 버튼 눌렀을 때
   $(document).on("click", ".btnCommReplySubmit", function() {
		// 답글 입력창에서 시퀀스 번호 추출
	    var commSeq = $(this).closest(".reply-container").attr("id").replace("replyCommBox", "");
	    
	    // 해당 시퀀스의 답글 내용 가져오기
	    var replyContent = $("#replyCommContent" + commSeq).val();
	    var brdSeq = ${brd.brdSeq};
	    
	    if(replyContent.trim() === "") {
	        alert("답글 내용을 입력하세요.");
	        return; 
	    }
	    
	    // DB에 답댓글 INSERT
	    $.ajax({
			   type : "POST",
			   url : "/board/commReplyInsertProc",
			   data : {
				   commSeq,
				   replyContent,
				   brdSeq
			   },
			   datatype : "JSON",
			   beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					if (response.code == 0) {
						fn_getCommList();
					}
					else if (response.code == -1) {
						alert("댓글 등록에 실패하였습니다.");
					}
					else if (response.code == 400) {
						alert("파라미터 값이 잘못되었습니다.");
					}
					else if (response.code == 404) {
						alert("해당 게시글이 존재하지 않습니다.");
						location.href = "/board/list2";
					}
					else {
						alert("댓글 등록 중 오류가 발생하였습니다. (2)");
					}
				},
				error : function(xhr, status, error) {
					icia.common.error(error);
					alert("댓글 등록 중 오류가 발생하였습니다.");
				}
		   });
   });
   
   // 이전 달과 다음달 처리
   // 이전 달
   function prevMonth(date) {
       var target = new Date(date);
       target.setDate(1);
       target.setMonth(target.getMonth() - 1);

       return getYmd(target);
   }

   // 다음 달
   function nextMonth(date) {
       var target = new Date(date);
       target.setDate(1);
       target.setMonth(target.getMonth() + 1);

       return getYmd(target);
   }

   function getYmd(target) {
       // IE에서 날짜 문자열에 0이 없으면 인식 못함
       var month = ('0' + (target.getMonth() + 1)).slice(-2);
       return [target.getFullYear(), month, '01'].join('-');
   }

   function fullDays(date) {
       var target = new Date(date);
       var year = target.getFullYear();
       var month = target.getMonth();

       var firstWeekDay = new Date(year, month, 1).getDay();
       var thisDays = new Date(year, month + 1, 0).getDate();

       // 월 표시 달력이 가지는 셀 갯수는 3가지 가운데 하나이다.
       // var cell = [28, 35, 42].filter(n => n >= (firstWeekDay + thisDays)).shift();
       var cell = [28, 35, 42].filter(function (n) {
               return n >= (firstWeekDay + thisDays);
           }).shift();

       // 셀 초기화, IE에서 Array.fill()을 지원하지 않아서 변경
       // var days = new Array(cell).fill({date: '', dayNum: '', today: false});
       var days = []
       for (var i = 0; i < cell; i++) {
           days[i] = {
               date: '',
               dayNum: '',
               today: false
           };
       }

       var now = new Date();
       var today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
       var inDate;
       for (var index = firstWeekDay, i = 1; i <= thisDays; index++, i++) {
           inDate = new Date(year, month, i);
           days[index] = {
               date: i,
               dayNum: inDate.getDay(),
               today: (inDate.getTime() === today.getTime())
           };
       }

       return days;
   }

   function drawMonth(date) {
	   // 2024-11-01 형식으로 date를 받음
	   
       $('#month-this').text(date.substring(0, 7).replace('-', '.'));
	   
	   // 이전 월과 다음 월의 정보 저장
       $('#month-prev').data('ym', prevMonth(date));
       $('#month-next').data('ym', nextMonth(date));
	
       // 날짜 적힌 테이블 비움
       $('#tbl-month').empty();
       
       // REST : 요일 표시할 색깔 (빨간색 : 일요일, 검은색 : 그냥 평범한 요일, 파란색 : 토요일)
       // fn_selectDate(YEAR, MONTH, DAY) 구별해서 onclick 구현
       // a class = "요일 표시"

       var td = '<td class="__REST__" __ONCLICK__><a class="">__DATE__</a></td>'; 
       var href = '/depart/schedule?date=' + date.substring(0, 8);
       var hasEvent;
       var tdClass;
       var week = null;
       var days = fullDays(date);
       var targetDate = new Date(date);
       var year = targetDate.getFullYear();
       var month = ('0' + (targetDate.getMonth() + 1)).slice(-2);  // 두 자릿수 월
       
       // 오라클에서 가져온 날짜 문자열
       const oracleDateMin = "${brd.startDate}"; 	  // 최소 날짜
       const oracleDateMax = "${brd.endDate}}";  //  최대 날짜

       // 날짜 형식 변환 함수
       function formatDateForInput(dateString) {
           const [datePart] = dateString.split(" "); // 시간 부분은 무시
           const [year, month, day] = datePart.split(".");
           
           // Date 객체 생성 (UTC로 설정) 
           const date = new Date(Date.UTC(year, month - 1, day)); // month는 0부터 시작하므로 -1

           // YYYY-MM-DD 형식으로 변환
           const formattedDate = date.toISOString().split('T')[0];
           
           return formattedDate; // YYYY-MM-DD 형식으로 반환
       }
       
       // minDate와 maxDate에서 날짜 부분만 추출
       function getFormattedDate(dateString) {
           const dateParts = dateString.split('-'); // YYYY-MM-DD 형식으로 분리
           const day = parseInt(dateParts[2], 10); // 날짜 부분을 정수로 변환하여 앞의 0 제거
           return day; // 정수로 반환
       }

       // 변환된 날짜
       // YYYY-MM-DD
       const minDate = formatDateForInput(oracleDateMin);	// 전시 시작일
       const maxDate = formatDateForInput(oracleDateMax);	// 전시 마감일
       
       const startDay = getFormattedDate(minDate);
       const endDay = getFormattedDate(maxDate);
       
       document.getElementById("startDate").textContent = minDate;
       document.getElementById("endDate").textContent = maxDate;

       for (var i = 0, length = days.length; i < length; i += 7) {
           week = days.slice(i, i + 7);
           
           var $tr = $('<tr></tr>');
           week.forEach(function (obj, index) {
        	   
               // 기본 클래스 초기화
               var tdClass = '';
         	   // 기본 onclick 속성
               var onclickAttr = ''; // 기본적으로 빈 onclick 속성
 
	           // 날짜를 비교하여 시작일과 마감일에 해당하는 경우 클래스 추가
		        var dateObj = obj['date'];
		        var currentYear = year; // 현재 연도
		        var currentMonth = month; // 현재 월
		        
		    	 // 현재 날짜를 Date 객체로 생성
		        var currentDateObj = new Date(currentYear, currentMonth - 1, dateObj); // month는 0부터 시작하므로 -1
		        var realCurrentDateObj = new Date();
		        
		   		// 시간, 분, 초, 밀리초를 모두 0으로 설정
		        realCurrentDateObj.setHours(0);
		        realCurrentDateObj.setMinutes(0);
		        realCurrentDateObj.setSeconds(0);
		        realCurrentDateObj.setMilliseconds(0);
		        

		        // YYYY-MM-DD 형식으로 변환
		        var currentDate = currentDateObj.toISOString().split('T')[0];
		        
		        // minDate와 maxDate를 Date 객체로 변환
		        var minDateObj = new Date(minDate);
		        var maxDateObj = new Date(maxDate);
		        
		  	    // 9시간 빼기
		        minDateObj.setHours(minDateObj.getHours() - 9);
		        maxDateObj.setHours(maxDateObj.getHours() - 9);
		     
		        
		        console.log("dateObj : " + dateObj + ", minDate : " + minDate + ", minDateObj : " + minDateObj + ", maxDateObj : " + maxDateObj
		        		+ ", currentDateObj : " + currentDateObj + ", realCurrentDateObj : " + realCurrentDateObj);
		        
				if (currentDateObj >= realCurrentDateObj && currentDateObj >= minDateObj && currentDateObj <= maxDateObj) {
		            // 시작일과 마감일 사이의 날짜인 경우
		            // 일반적으로 표시
	           	   tdClass = (index === 0) ? 'sun' : '';
	               tdClass = (index === 6) ? 'sat' : tdClass;

	               // 토요일과 일요일이 아닌 경우 bold 클래스 추가
	               if (index !== 0 && index !== 6) { // index 0은 일요일, 6은 토요일
	                   tdClass += ' bold'; // bold 클래스 추가
	               }
	               
	               // 디버깅을 위한 로그 추가
	               console.log("currentDate : " + currentDateObj);
	               console.log("Setting onclick for:", currentYear, currentMonth, dateObj);
	               
	          	  // onclick 속성 설정 (year, month, day 동적으로 설정)
	               onclickAttr = 'onclick="fn_selectDay(' + currentYear + ', ' + currentMonth + ', ' + dateObj + ')"';
		        } else {
		            tdClass += ' gray'; // 그 외의 날짜는 회색 글씨로 표시
		            onclickAttr = ''; // 회색 글씨인 경우 onclick 속성 제거
		        }
	           
               $tr.append(td.replace('__REST__', tdClass)
            			   .replace('__ONCLICK__', onclickAttr || '')
                           .replace('__DATE__', obj['date'] || '')
                           .replace('__YEAR__', year)
                           .replace('__MONTH__', month)
                           .replace('__DAY__', obj['date'] || ''));
           });
           $('#tbl-month').append($tr);
       }
   }
   
   function padZero(value) {
	    return value < 10 ? '0' + value : value;
	}

	function fn_selectDay(year, month, day) {
	    if (day) {
	        var formattedMonth = padZero(month); // 월을 두 자릿수로 변환
	        var selectedDate = year + '-' + formattedMonth + '-' + ('0' + day).slice(-2);  // 날짜도 두 자릿수로
	        $("#selectDate").val(selectedDate);
	    } else {
	        console.log("유효하지 않은 날짜입니다.");
	    }
	}
/* 	
   function fn_selectDay(year, month, day) {
       if (day) {
           var selectedDate = year + '-' + month + '-' + ('0' + day).slice(-2);  // 날짜도 두 자릿수로
           $("#selectDate").val(selectedDate);
       } else {
           console.log("유효하지 않은 날짜입니다.");
       }
   } */

   
   
   
   
   
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
         <h1 onclick="fn_list(${boardType})">${boardTitle}</h1>
      </div>

      <div class="list-container">
         <div class="write-title-container">
            <span>상세보기</span>
         </div>
         <form name="viewForm" id="viewForm" method="post" enctype="multipart/form-data">
            <div class="write-container">
               <div class="view-header">
                  <div class="view-title">
                     <h3>${brd.brdTitle }</h3>
                  </div>
                  <div class="view-info">작성자: ${brd.userName } | 작성일 : ${brd.regDate} | 조회수 : ${brd.brdReadCnt }
<c:if test="${!empty brd.brdFile }">
				  | 첨부파일  : 
                  <a href="/board/download?brdSeq=${brd.brdFile.brdSeq }" style="color:#000;">[첨부파일]</a>
</c:if>  
				</div>
               </div>
 
<!--  전시 게시판일 경우 VIEW 다르게 설정 -->               
 <c:if test="${boardType eq 3 }">
 		<div class="view-content">
 		
		   <div class="exhibition-detail">
		   
			<div class="exhibition-info-container">
			
			<div class="seperator">
			   <div class="exhibition-image">
			      <img src="/resources/upload/${brd.brdFile.fileName}" alt="전시회 이미지">
			   </div>
			   
			   <div class="exhibition-info">
			      <div class="exhibition-location">전시 장소: 서울시 마포구 쌍용강북센터</div>
			      <div class="exhibition-date">전시 기간: <span id="startDate"></span> ~ <span id="endDate"></span></div>
			      <div class="exhibition-price">가격: <fmt:formatNumber type="number" maxFractionDigits="3" value="${brd.price}" />원</div>
			   </div>  
			</div>
			   
			     <div class="ticket-date"> 
     				 <div class="date-wrap">
                     <div class="date-month">
                        <div class="date-title">
                        <button type="button" id="month-prev" class="month-move" data-ym="2022-04-01"><</button>
                        <span id="month-this">2024.11</span>
                        <button type="button" id="month-next" class="month-move" data-ym="2022-06-01">></button>
                        </div>
                     </div>
                     <table class="date-month">
                        <thead>
                           <tr>
                              <th class="sun" style="width:15%">SUN</th>
                              <th style="width:14%">MON</th>
                              <th style="width:14%">TUE</th>
                              <th style="width:14%">WED</th>
                              <th style="width:14%">THU</th>
                              <th style="width:14%">FRI</th>
                              <th class="sat" style="width:15%">SAT</th>
                           </tr>
                        </thead>
                        <tbody id="tbl-month">
                           <tr>
                              <td class="sun dateBox"><a>1</a></td>
                              <td class="dateBox"><a>2</a></td>
                              <td class="dateBox"><a>3</a></td>
                              <td class="dateBox"><a>4</a></td>
                              <td class="dateBox"><a>5</a></td>
                              <td class="dateBox"><a>6</a></td>
                              <td class="sat dateBox"><a>7</a></td>
                           </tr>
                           <tr>
                              <td class="sun dateBox"><a>29</a></td>
                              <td class="dateBox"><a>30</a></td>
                              <td class="dateBox"><a>31</a></td>
                              <td class="dateBox"><a></a></td>
                              <td class="dateBox"><a></a></td>
                              <td class="dateBox"><a></a></td>
                              <td class="sat dateBox"><a></a></td>
                           </tr>
                        </tbody>
                     </table>
                     
		                 <div class="date-container">
		                  <input type="date" id="selectDate" value="" readonly>
		                  <button type="button" class="purchase-button" id="btnPurchase">티켓 구매하기</button>
		               </div> 
                  </div>
		   </div>
		   
			</div>
			
			
		      <div class="exhibition-description">
		         <pre>${brd.brdContent }</pre>
		      </div>

		   
		   </div>
		</div>
 </c:if>
               
               
<c:if test="${boardType ne 3 }">               
               <div class="view-content">

<!--  파일 여러개는 나중에 하는 걸로 ...^^ -->               
<c:if test="${!empty brd.brdFile }">
	<img src="/resources/upload/${brd.brdFile.fileName}" width="200px" height="200px">
	<br>
</c:if>   
             
                  <pre>${brd.brdContent }</pre>
               </div>

</c:if>               
               
               
            </div>
            <div class="write-btn-container" style="padding-bottom: 80px;">
            
  <!-- 좋아요 버튼 하실 분 사용하세요 -->
  <div class="view-left" style="float: left;">
  
<button type="button" id="recomBtn" class="writeBtn" style="background: ${likeChk eq 'Y' ? '#4B89DC' : '#d76464'};">
    좋아요 <span id="likeCnt">${totalLikeCount}</span>
</button>
  
 
    
    
    
                  
<!-- 문의 게시판 : 관리자만 답글 가능 / 자유 게시판 : 다 답글 가능 -->
	<!-- <c:if test="${boardType eq '2'}" >
                <button type="button" id="writeBtn" class="writeBtn">답글</button>
    </c:if> -->
    
    
    <c:if test="${boardType eq '4' && user.status eq 'A'}">
             <button type="button" id="writeBtn" class="writeBtn">답글</button>
    </c:if>   
               
               </div>
              
               <div class="view-right" style="float: right;">
               
<!--  내 글이거나 관리자일 때 수정/삭제 가능 -->               
<c:if test="${boardMe eq 'Y' || user.status eq 'A' }">
	 <c:if test="${boardMe eq ' Y' }">                 
                  <button type="button" id="updateBtn" class="writeBtn">수정</button>
      </c:if>            
     <c:if test="${boardType ne '4'|| user.status eq 'A' }">             
                  <button type="button" id="deleteBtn" class="writeBtn">삭제</button>
     </c:if>
</c:if>   
 
                  <button type="button" id="listBtn" class="writeBtn">목록</button>
               </div>                        
            </div>
         </form>
         
 <!--  댓글 -->

      
  <div class="comment-section">
  
    <!-- 댓글창 -->
  <div class="comment-container" >
     <input type="text" id="commContent" class="com-input" placeholder="내용을 입력하세요">
     <input type="button" id="btnCommSubmit" class="com-btn" value="댓글 작성">
  </div>
         
  
  <!--  댓글 리스트 받아오기 -->
   <div id="commList"> 
   
   </div>
    


<br><br>
         
         
      </div>
   </div>
  </div>

   <!-- 푸터 영역 -->
   <%@ include file="/WEB-INF/views/include/footer.jsp"%>

   <form id="bbsForm" name=bbsForm method="post">
      <input type="hidden" name="boardType" value="${boardType }">
      <input type="hidden" name="brdSeq" value="${brdSeq }">
      <input type="hidden" name="searchType" value="${searchType }">
      <input type="hidden" name="searchValue" value="${searchValue }">
      <input type="hidden" name="curPage" value="${curPage }">
   </form>
   
</body>
</html>