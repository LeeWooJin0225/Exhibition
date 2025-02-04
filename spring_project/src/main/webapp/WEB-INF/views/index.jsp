<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
* {
   margin: 0;
   padding: 0;
   box-sizing: border-box;
}

.hero {
   background-image: url(/resources/images/main.jpg);
   height: 550px;
   display: flex;
   flex-direction: column;
   justify-content: center;
   align-items: center;
   text-align: center;
   color: white;
   background-size: cover;
   position: relative;
}

.overlay {
   position: absolute;
   top: 0;
   left: 0;
   right: 0;
   bottom: 0;
   background-color: rgba(0, 0, 0, 0.5);
   z-index: 1;
}

.hero h1, .hero .search-bar {
   position: relative;
   z-index: 2;
   font-size: 40px;
}

.search-bar {
   /*margin-top: 20px;*/
   
}

.search-bar input {
   padding: 10px;
   width: 500px;
   border: none;
   border-radius: 10px;
}

.search-bar button {
   padding: 10px;
   border: none;
   background-color: #333;
   color: white;
   border-radius: 10px;
}

.image-description {
   padding: 150px 0px;
   display: flex;
   justify-content: flex-end;
}

.image-container {
   position: relative;
   width: 1150px;
   height: 600px;
   display: flex;
   justify-content: flex-end;
   align-items: flex-start;
   margin-right: 50px;
}

.image-container .placeholder {
   width: 100%;
   height: 600px;
   background-color: #d3d3d3;
   border-radius: 10px;
}

.placeholder img{
   width: 100%;
   height: 100%;
   object-fit: cover;
   background-size: cover;
   border-radius: 10px;
}


.caption {
   position: absolute;
   bottom: 10%;
   left: -16%;
   width: 48%;
   background-color: rgba(0, 0, 0, 0.5);
   color: white;
   padding: 40px;
   height: 44%;
   border-radius: 10px;
}

.caption h3 {
   margin-top: 20px;
   margin-bottom: 20px;
   font-size: 30px;
}

.best-work {
   padding: 0px 100px 150px 100px;
   text-align: center;
   overflow:hidden;
}

.best-work h2 {
   font-size: 2em;
   margin-bottom: 30px;
}

.best-work .work-grid {
   width:100%;
   height:400px;
   perspective:500px;
   transform-style:preserve-3d;
}

.best-work .work-item {
   transition:0.5s;
   width:300px;
   height:400px;
   box-shadow:0 10px 50px gray;
   background:white;
   border:1px solid rgba(0,0,0,0.1);
   position:absolute;
   left:50%;
   top:0%;
   transform:translate(-50%,20px);
}


.work-item:nth-of-type(1),.work-item:nth-of-type(2){
   transform:translate(calc(-50%*5.1), 20px) translateZ(-100px);
}
.work-item:nth-of-type(3){
   transform:translate(calc(-50%*3.1), 20px) translateZ(-50px);
}
.work-item:nth-of-type(4){
   transform:translate(calc(-50%*1.1), 20px) translateZ(50px);
}
.work-item:nth-of-type(5){
   transform:translate(calc(-50%*-0.9), 20px) translateZ(-50px);
}
.work-item:nth-of-type(6){
   transform:translate(calc(-50%*-2.9), 20px) translateZ(-100px);
}

.best-work .work-item .placeholder1 {
   width: 100%;
   height: 300px;
   background-color: #d3d3d3;
   border-radius: 10px;
}

.best-work .work-grid p {
   margin-top: 1rem;
}

.placeholder1 img {
   width: 100%;
   height: 100%;
   object-fit: cover;
   background-size: cover;
   border-radius: 10px;
}


.image-container1{
   display:flex;
   width:90%;
   position: relative;
}
.image-container1 .placeholder{
   flex:1;
   position:absolute;
   opacity:0;
   transition: opacity 1s ease-in-out;
}

.image-container1 div:nth-child(1){
   opacity:1;
} 
.caption2{
   display:flex;
   width:100%;
   postion: relative;
}
.caption2 div{
   flex:1;
   position:absolute;
   opacity:0;
   transition: opacity 1s ease-in-out;
}
.caption2 div:first-child{
   opacity:1;
}

footer {
    background-color: #333;
    color: #8a8a8a;
    padding: 20px;
    text-align: center;
}

footer img{
   width: 40px;
   margin: 20px 0 20px 0;
   opacity: 20%;
}

footer p{
   font-size: 12px;
}

footer .lastp{
   margin-top: 20px;
}

.search-bar input {
   padding: 15px;
   width: 600px;
   border: none;
   border-radius: 100px;
   margin-left: 34px;
   margin-bottom: 20px;
}

.search-bar button {
    transform: translate(-179%, 15%);
    padding: 6px;
    border: none;
    background-color: #fff;
    color: white;
    border-radius: 100px;
}


</style>

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
        
        const children = document.querySelectorAll('.placeholder');
        const children2 = document.querySelectorAll('.caption2 div');
        var index = 0;
        setInterval(function(){
           children[index].style.opacity = '0';
           children2[index].style.opacity = '0';
           index = (index + 1) % children.length;
           children[index].style.opacity = '1';
           children2[index].style.opacity = '1';
           $("#index").val(index);
        }, 3000);
        
    });
    
    
	function fn_list(boardType) {
		document.bbsForm.boardType.value = boardType;
		document.bbsForm.action = "/board/list";
		document.bbsForm.submit();
	}
	
	setInterval(function(){
        const slides = document.querySelectorAll('.work-item');
        document.querySelector('.work-grid').append(slides[0]);
     }, 3000);
	
	function fn_view () {
		document.bbsForm.boardType.value = "3";
		document.bbsForm.action = "/board/list";
		document.bbsForm.submit();
	}
	
</script>

</head>
<body>
<form class="form-signin">
    <!-- 헤더 영역 -->
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

    <!-- 메인 배너 영역 -->
     <section class="hero">
         <div class="overlay"></div>
         <h1>쌍용교육센터</h1>
         <div class="search-bar">
            <input type="text" name="_searchValue" id="_searchValue" placeholder="검색어를 입력하세요">
            <button type="button" id="btnSearch" style="cursor: pointer"><img alt="검색 버튼" src="/resources/images/search.png" style="height: 22px;"></button>
         </div>
      </section>

    <!-- 이미지 설명 영역 -->
      <section class="image-description">
         <div class="image-container">
            <div class="image-container1" onclick="fn_href()">
               <div class="placeholder">
                  <img alt="" src="/resources/images/seoulart.webp">
               </div>
               <div class="placeholder">
                  <img alt="" src="/resources/images/kart.webp">
               </div>
               <div class="placeholder">
                  <img alt="" src="/resources/images/ex2.jpg">
               </div>
            </div>
            <div class="caption">
            <div class="caption2">
            <div >
               <h3>서울 예술의 전당</h3>
               <p>
                  서울특별시 서초구 서초동 700번지 <br /> 불멸의 화가 반 고흐, 미셸 앙리등 <br /> 다양한 전시회를 관람하세요.
               </p>
            </div>
            <div>
               <h3>K현대 미술관</h3>
               <p>
                  서울특별시 강남구 선릉로 807 <br /> 파리의 휴일, 디즈니 특별전등 <br /> 다양한 전시회를 관람하세요.
               </p>
            </div>
            <div>
               <h3>Art & Culture</h3>
               <p>
                  여러 아티스트의 작품을 감상할 수 있는 <br /> 특별한 공간 쌍용미니프로젝트 전시회에 <br /> 여러분들을 초대합니다.
               </p>
            </div>
            </div>
            </div>
         </div>
      </section>

    <!-- 베스트 작업물 영역 -->
    <section class="best-work">
        <h2>BEST WORK</h2>
        <div class="work-grid">
        
        <c:forEach var="brd" items="${list }" varStatus="status">
        
            <div class="work-item">
                <div class="placeholder1" onclick="fn_view(${brd.brdSeq})"><img alt="" src="/resources/upload/${brd.brdFile.fileName}" ></div>
                <p>${brd.brdTitle }</p>
                <small>${brd.startDate } ~ ${brd.endDate }</small>
            </div>
            
		</c:forEach>
		
        </div>
    </section>
    
    <br><br><br><br><br>

    <!-- 푸터 영역 -->
    <footer>

       <img alt="" src="/resources/images/logo2.png">
          <p>(주)미니프로젝트3 대표이사 : 고건민   |  주소 : 서울특별시 중구 소공로 63(충무로 1가)  |  개인정보보호책임자 : 권순일 상무</p>
          <p>대표전화 : 02-336-8546 (유료)  |  사업자등록번호 : 444-44-44444  |  통신판매업신고번호 : 1996-홍대입구-0291</p>
        <p class="lastp">© MINIPROJECT</p>
    </footer>
    
</form>    

	<form id="bbsForm" name=bbsForm method="post">
		<input type="hidden" name="boardType" value="">
	</form>
</body>


</html>
