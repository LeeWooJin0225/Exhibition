<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">
<script type="text/javascript">
	$(document).ready(function() {
		
		
<%
	    // 현재 날짜와 시간 가져오기
	    Date currentDate = new Date();
	    request.setAttribute("currentDate", currentDate);
%>
	
	
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
		$("#wrtieBtn").on("click", function() {
			document.bbsForm.boardType.value = ${boardType};
			document.bbsForm.brdSeq.value = "";
			document.bbsForm.action = "/board/writeForm";
			document.bbsForm.submit();
		});
		
		//검색 버튼 클릭시
		$("#btnSearch").on("click", function() {
			document.bbsForm.boardType.value = ${boardType};
			document.bbsForm.brdSeq.value = "";
			document.bbsForm.searchType.value = $("#_searchType").val();
			document.bbsForm.searchValue.value = $("#_searchValue").val();
			document.bbsForm.curPage.value = "1";
			document.bbsForm.action = "/board/list";
			document.bbsForm.submit();
		});
	});
	
	function fn_view(brdSeq) {
		document.bbsForm.boardType.value = ${boardType};
		document.bbsForm.brdSeq.value = brdSeq;
		document.bbsForm.action = "/board/view";
		document.bbsForm.submit(); 
	}
	
	function fn_secret_view(brdSeq, status, brdUserId, brdGroup) {
		
		// 관리자는 모든 글 열람 가능
		// 문의 글 작성자는 답변까지 열람 가능
		// 글 작성자와 아이디가 같지 않지만 같은 그룹에 속해있으면 보기 가능
		
		var isGroup = false;
		
		// alert(brdUserId + ", " + brdSeq + ", " + brdGroup + ", " + "${user.userId}");
		
		// 자식글일 경우
		if (brdSeq != brdGroup) {
			$.ajax ({
				type : "POST",
				url : "/board/isGroup",
				data : {
					brdSeq,
					brdUserId,
					brdGroup
				},
				dataType : "JSON",
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(res) {
					if (res.code == 0) {
						isGroup = true;
						fn_secret_chk(isGroup, brdSeq);
					}
					else if (res.code == -1) {
						fn_secret_chk(isGroup, brdSeq);
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
		// 부모글일 경우
		else {
			if ("${user.userId}" == brdUserId) {
				fn_secret_submit(brdSeq);
			}
			else if ("${user.status}" == 'A') {
				fn_secret_submit(brdSeq);
			}
			else {
				alert("비밀글은 본인만 확인 가능합니다.");
			}
		}
	}
	
	function fn_secret_chk(isGroup, brdSeq) {
		
 		if ("${user.status}" == 'A') {
 			fn_secret_submit(brdSeq);
		}
		
		if (isGroup) {
			fn_secret_submit(brdSeq);
		}
		else {
			alert("비밀글은 본인만 확인 가능합니다.");
		}

	}
	
	function fn_secret_submit(brdSeq) {
			document.bbsForm.boardType.value = ${boardType};
 			document.bbsForm.brdSeq.value = brdSeq;
 			document.bbsForm.action = "/board/view";
 			document.bbsForm.submit(); 
	}

   function fn_list(boardType) {
	      document.bbsForm.curPage.value = "1";
	      document.bbsForm.searchType.value = "";
	      document.bbsForm.searchValue.value = "";
	      document.bbsForm.boardType.value = boardType;
	      document.bbsForm.action = "/board/list";
	      document.bbsForm.submit();
	}
	
	
	function fn_page(curPage) {
		document.bbsForm.brdSeq.value = "";
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.action = "/board/list";
		document.bbsForm.submit();
	}
	
	function fn_endView(brdSeq) {
		
		// 관리자면 그냥 볼 수 있게 해야 함
		if ("${user.status}" == 'A') {
			document.bbsForm.boardType.value = ${boardType};
			document.bbsForm.brdSeq.value = brdSeq;
			document.bbsForm.action = "/board/view";
			document.bbsForm.submit();
		}
		else {
			alert("이미 종료된 전시회입니다.");
		}
		
	}
	
	function fn_commingVew(startDate, brdSeq) {
		if ("${user.status}" == 'A') {
			document.bbsForm.boardType.value = ${boardType};
			document.bbsForm.brdSeq.value = brdSeq;
			document.bbsForm.action = "/board/view";
			document.bbsForm.submit();
		}
		else {
			alert("해당 전시회는 " + startDate + " 오픈될 예정입니다.");
		}
		
	}
	
	// 주문취소 버튼
	function fn_cancel(orderSeq) {

		if (confirm("결제를 취소하시겠습니까?")) {
			
			$.ajax ({
				type : "POST",
				url : "/order/kakaoPay/cancel",
				data : {
					orderSeq
				},
				dataType : "JSON",
				beforeSend:function(xhr)
		        {
		        	 xhr.setRequestHeader("AJAX", "true");
		        },
		        success:function(res)
		        {

		    	  	if (res.code == 0) {
		    	  		alert(res.msg);
		    	  		document.bbsForm.action = "/board/list";
		    	  		document.bbsForm.submit();
		    	  	}
		    	  	else {
		    	  		alert(res.msg);
		    	  	}
		        },
		        error:function(error)
		        {
		        	 icia.common.error(error);
		        }
			});
		}
		
		
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
	<div class="main-container">
		<div class="title-container">
			<h1>${boardTitle }</h1>
		</div>

		<div class="list-container">
			<div class="menu-container">
				<ul>
					<li><a href="javascript:void(0)" class="${boardType == 1 ? 'active' : ''}" onclick="fn_list(1)">공지사항</a></li>
					<li><a href="javascript:void(0)" class="${boardType == 2 ? 'active' : ''}" onclick="fn_list(2)">자유 게시판</a></li>
					<li><a href="javascript:void(0)" class="${boardType == 3 ? 'active' : ''}" onclick="fn_list(3)">전시 게시판</a></li>
					<li><a href="javascript:void(0)" class="${boardType == 4 ? 'active' : ''}" onclick="fn_list(4)">1:1문의</a></li>
					<li><a href="javascript:void(0)" class="${boardType == 5 ? 'active' : ''}" onclick="fn_list(5)">예매내역</a></li>
				</ul>
			</div>

			<div class="board-container">
				<table>
				<c:if test="${boardType ne 3 && boardType ne 5 }">
					<thead>
						<tr>
							<th style="width: 10%">NO</th>
							<th style="width: 55%">제목</th>
							<th style="width: 10%">작성자</th>
							<th style="width: 15%">날짜</th>
							<th style="width: 10%">조회수</th>
						</tr>
					</thead>
				</c:if>	
				
				<c:if test="${boardType eq 5 }">
					<thead>
						<tr>
							<th style="width: 10%">예매번호</th>
							<th style="width: 20%">공연명</th>
							<th style="width: 15%">예매일</th>
							<th style="width: 15%">관람일</th>
							<th style="width: 10%">매수</th>
							<th style="width: 15%">상태</th>
							<th style="width: 15%">결제</th>
						</tr>
					</thead>
				</c:if>	
					<tbody>
					

<!--  전시 게시판 list 시작 -->
<c:if test="${boardType eq 3 }">
	<c:if test="${!empty list }">
	   <div class="exhibi-container">
	      <c:forEach var="brd" items="${list}" varStatus="status">
	         <c:if test="${brd.status ne 'D' }">
	
	            <c:choose>
	               <c:when test="${brd.status eq 'E' }">
	                  <div class="exhibi-item-box" onclick="fn_endView(${brd.brdSeq})">
	                     <div class="exhibi-img">
	                        <img alt="" src="/resources/upload/${brd.brdFile.fileName}" 
	                             onerror="this.src='/resources/images/default-img.jpg';"
	                             style="filter: grayscale(100%);">
	                     </div>
	                     <div class="exhibi-title">
	                        <div><span>${brd.brdTitle}</span></div>
	                     </div>
	                     <div class="closed-overlay">CLOSED</div>
	                  </div>
	               </c:when>
	               
	               <c:when test="${brd.status eq 'C' }">
				        <div class="exhibi-item-box" onclick="fn_commingVew('${brd.startDate}', ${brd.brdSeq })">
				            <div class="exhibi-img">
				               	<img alt="" src="/resources/upload/${brd.brdFile.fileName}" 
	                             onerror="this.src='/resources/images/default-img.jpg';">
				            </div>
				            <div class="exhibi-title">
				                <div><span>${brd.brdTitle}</span></div>
				            </div>
							<div class="closed-overlay">COMING SOON</div> 
				        </div>
	               </c:when>
	
	               <c:otherwise>
	                  <div class="exhibi-item-box" onclick="fn_view(${brd.brdSeq})">
	                     <div class="exhibi-img">
	                        <img alt="" src="/resources/upload/${brd.brdFile.fileName}" 
	                             onerror="this.src='/resources/images/default-img.jpg';">
	                     </div>
	                     <div class="exhibi-title">
	                        <div><span>${brd.brdTitle}</span></div>
	                     </div>
	                  </div>
	               </c:otherwise>
	               
	            </c:choose>
	            
	         </c:if>
	      </c:forEach>
	   </div>
	</c:if>
</c:if>        
<!--  전시 게시판 list 끝 -->

<!-- ########### 주문내역 게시판 ########### -->
<c:if test="${boardType eq 5}">
	<c:if test="${!empty orderList }">
	
		<c:forEach var="order" items="${orderList }" varStatus="status">
		
			<tr>
				<td>${order.orderSeq }</td>
				<td>${order.exhiName }</td>
				<td>${order.regDate }</td>
				<td>${order.viewDate }</td>
				<td>${order.quantity }</td>
				<td>${order.status }</td>
		<c:if test="${order.status eq '결제완료'  }">			
				<td>
				<button type="button" class="btn-order" id="btnOrderCancel" onclick="fn_cancel(${order.orderSeq})">
				주문취소</button>
				</td>
		</c:if>
		<c:if test="${order.status eq '결제대기'  }">	
				<td>
				<button type="button" class="btn-order" id="btnOrder" onclick="fn_order(${order.orderSeq})">
				결제하기</button>
				</td>
		</c:if>
			</tr>
		
		
		</c:forEach>
	
	
	</c:if>
</c:if>


<c:if test="${boardType ne 3 && boardType ne 5 }">					
<c:if test="${!empty list }">

	<c:forEach var="brd" items="${list}" varStatus="status">
					
				<tr>
					<td>${brd.brdSeq }</td>
					<td>
					
				<c:if test="${(brd.boardType eq '4' || brd.boardType eq '2') && brd.brdIndent gt 0}">
				    <c:forEach var="i" begin="1" end="${brd.brdIndent}">
				        &nbsp;
				    </c:forEach>
				    <img src="/resources/images/reply.webp" width="20px">
				    <b>[답글]</b>
				</c:if>
			
			<c:choose>		

				<c:when test="${brd.status eq 'I' }">
					<a href="javascript:void(0)" onclick="fn_view(${brd.brdSeq})">
					<b style="color:red ">[중요]</b> ${brd.brdTitle } &nbsp; [${brd.commCount }]</a>
				</c:when>
				
				<c:when test="${brd.status ne 'I' && brd.boardType eq '1'}">
					<a href="javascript:void(0)" onclick="fn_view(${brd.brdSeq })">
					<b>[안내]</b> ${brd.brdTitle } &nbsp; [${brd.commCount }]</a>
				</c:when>
				
				<c:when test="${brd.status eq 'S' }">
					<a href="javascript:void(0)" onclick="fn_secret_view(${brd.brdSeq}, '${brd.status }', '${brd.userId }', ${brd.brdGroup })">
					🔒 비밀글입니다.</a>
				</c:when>
				
 				<c:when test="${brd.status eq 'D' }">
					<a href="javascript:void(0)">
					❌ 삭제된 게시글입니다. </a>
				</c:when> 
				
				<c:otherwise>
					<a href="javascript:void(0)" onclick="fn_view(${brd.brdSeq })">
					${brd.brdTitle } &nbsp; [${brd.commCount }] </a>
				</c:otherwise>
				
			</c:choose>	
				
					</td>
				
					<td>${brd.userName }</td>
					<td>${brd.regDate }</td>
					<td><fmt:formatNumber type="number" maxFractionDigits="3" groupingUsed="true" value="${brd.brdReadCnt}"/></td>
				</tr>
					
	</c:forEach>
	
</c:if>
</c:if>


<c:if test="${empty orderList && boardType eq 5}">
		<tr>
			<td colspan="7">주문 내역이 존재하지 않습니다.</td>
		</tr>
</c:if>
						
<c:if test="${empty list && boardType ne 5 }">
		<tr>
			<td colspan="5">등록된 게시글이 존재하지 않습니다.</td>
		</tr>
</c:if>

<!-- 게시글 리스트 조회 끝 -->

					</tbody>
					<tfoot>
					</tfoot>
				</table>
			</div>

<!--  글쓰기 버튼 처리 -->
<c:choose>
	<c:when test="${user.status eq 'A' && boardType eq '1'}">
		<div class="writeBtn-container">
			<button type="button" id="wrtieBtn" class="writeBtn">글쓰기</button>
		</div>
	</c:when>
	
	<c:when test="${user.status ne 'A' && boardType eq '1'}">
		 <div class="writeBtn-container" style="visibility: hidden;">
	        <button class="writeBtn" style="visibility: hidden;">글쓰기</button>
	    </div>
	</c:when>
	
	<c:when test="${boardType eq 5 }">
		<div class="writeBtn-container" style="visibility: hidden;">
	        <button class="writeBtn" style="visibility: hidden;">글쓰기</button>
	    </div>
	</c:when>
	
	<c:otherwise>
		<div class="writeBtn-container">
			<button type="button" id="wrtieBtn" class="writeBtn">글쓰기</button>
		</div>
	</c:otherwise>
</c:choose>
		

			<nav>
				<ul class="pagination">

<!--  주문내역 게시판 페이징은 따로 해야 해서 분리!!! -->				
<c:if test="${boardType ne 5 }">				
	<!--  페이징 처리 시작 -->
	<c:if test="${!empty paging }">
	
			<c:if test="${paging.prevBlockPage gt 0}">
	
					<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_page(${paging.prevBlockPage})"> <img alt="" src="/resources/images/prev.png" style="margin-left: -4px;">
					</a></li>
			</c:if>
			
			<c:forEach var="i" begin="${paging.startPage }" end="${paging.endPage }">
			
				<c:choose>
			
					<c:when test="${i ne curPage }">
						<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_page(${i})">${i }</a></li>
					</c:when>
					
					<c:otherwise>
						<li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor: default;">${i }</a></li>
					</c:otherwise>
	         </c:choose>
	         
	   </c:forEach>
	   
	   		 <c:if test="${paging.nextBlockPage gt 0 }">
					<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_page(${paging.nextBlockPage})"> <img alt="" src="/resources/images/next.png" style="margin-right: -6px;">
					</a></li>
			</c:if>
	</c:if>	
</c:if>
<!--  페이징 처리 끝 -->		



<!--  주문내역 게시판 페이징 처리 -->	
	<!--  페이징 처리 시작 -->
	<c:if test="${!empty orderPaging }">
	
			<c:if test="${orderPaging.prevBlockPage gt 0}">
	
					<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_page(${orderPaging.prevBlockPage})"> <img alt="" src="/resources/images/prev.png" style="margin-left: -4px;">
					</a></li>
			</c:if>
			
			<c:forEach var="i" begin="${orderPaging.startPage }" end="${orderPaging.endPage }">
			
				<c:choose>
			
					<c:when test="${i ne curPage }">
						<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_page(${i})">${i }</a></li>
					</c:when>
					
					<c:otherwise>
						<li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor: default;">${i }</a></li>
					</c:otherwise>
	         </c:choose>
	         
	   </c:forEach>
	   
	   		 <c:if test="${orderPaging.nextBlockPage gt 0 }">
					<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_page(${orderPaging.nextBlockPage})"> <img alt="" src="/resources/images/next.png" style="margin-right: -6px;">
					</a></li>
			</c:if>
	</c:if>	
<!-- 주문내역 페이지 페이징 처리 끝 -->



				</ul>
			</nav>


<c:if test="${boardType ne 5 }">
			<div class="searchBar">
				<select name="_searchType" id="_searchType" class="custom-box" style="width: auto;">
					<option value="">조회 항목</option>
					 <option value="1" <c:if test='${searchType eq "1"}'> selected </c:if> >작성자</option>
           			 <option value="2" <c:if test='${searchType eq "2"}'> selected </c:if> >제목</option>
            		 <option value="3" <c:if test='${searchType eq "3"}'> selected </c:if> >내용</option>
				</select>
				<input type="text" name="_searchValue" id="_searchValue" class="custom-box" maxlength="20" style="ime-mode: active;" value="${searchValue }" size="40" placeholder="조회값을 입력하세요." />
				<button type="button" id="btnSearch" class="custom-box">
					<img alt="검색 버튼" src="/resources/images/search.png" style="height: 18px;">
				</button>
			</div>
</c:if>	

<c:if test="${boardType eq 5 }">
	<div class="searchBar" style="visibility: hidden;">
		<select name="_searchType" id="_searchType" class="custom-box" style="width: auto;">
			<option value="">조회 항목</option>
			 <option value="1" <c:if test='${searchType eq "1"}'> selected </c:if> >작성자</option>
         			 <option value="2" <c:if test='${searchType eq "2"}'> selected </c:if> >제목</option>
          		 <option value="3" <c:if test='${searchType eq "3"}'> selected </c:if> >내용</option>
		</select>
		<input type="text" name="_searchValue" id="_searchValue" class="custom-box" maxlength="20" style="ime-mode: active;" value="${searchValue }" size="40" placeholder="조회값을 입력하세요." />
		<button type="button" id="btnSearch" class="custom-box">
			<img alt="검색 버튼" src="/resources/images/search.png" style="height: 18px;">
		</button>
	</div>

</c:if>		
			
			
			
		</div>
	</div>




	<form id="bbsForm" name=bbsForm method="post">
		 <input type="hidden" name="boardType" value="${boardType }">
		<input type="hidden" name="brdSeq" value="">
   		<input type="hidden" name="searchType" id="searchType" value="${searchType }">
   		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue }">
   		<input type="hidden" name="curPage" id="curPage" value="${curPage }">
	</form>
	
	
	<!-- 푸터 영역 -->
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>



	
	
	
	
	
	
	
	
	
	
	
	
</body>
</html>