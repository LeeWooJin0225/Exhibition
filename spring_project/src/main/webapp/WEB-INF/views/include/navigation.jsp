<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<style>
dl, ol, ul {
   margin-top: 0;
   margin-bottom: 0px;
}

p {
   margin-top: 0;
   margin-bottom: 0;
}

body {
   font-family: Arial, sans-serif;
   color: #333;
}

header {
   display: flex;
   justify-content: center;
   align-items: center;
   padding: 20px 100px;
   background-color: #333;
}

header .header-content {
   display: flex;
   justify-content: center;
   align-items: center;
   width: 100%;
}

header .logo {
   margin-right: auto;
}

header .logo img {
   width: 100px;
}

header nav {
   margin-left: auto;
   position: relative; /* To position dropdown */
}

header nav ul {
   display: flex;
   list-style: none;
}

header nav ul li {
   margin-left: 20px;
   margin-bottom: 0px;
   position: relative;
}

header nav ul li a {
   color: white;
   text-decoration: none;
}

header nav ul li a img {
   width: 30px;
   margin-bottom: 2px;
}

/* 드롭다운 메뉴 숨기기 */
.dropdown-menu {
   display: none;
   position: absolute;
   top: 60px; /* 네비게이션 아래에 위치 */
   background-color: #333;
   border-radius: 8px;
   padding: 10px 0;
   box-shadow: 0px 4px 8px rgba(0, 0, 0.5, 0.8);
   list-style: none;
   min-width: 150px; /* 드롭다운 메뉴 최소 너비 */
   transform: translateX(-77%); /* 햄버거 버튼의 오른쪽 끝과 메뉴의 오른쪽 끝을 맞춤 */
   z-index: 7;
}

.dropdown-menu li {
   margin: 0;
}

.dropdown-menu li a {
   color: white;
   padding: 10px 20px;
   display: block;
   text-decoration: none;
}

.dropdown-menu li a:hover {
   background-color: #555;
}

/* 햄버거 버튼 위치 */
.nav-item-dropdown {
   position: relative;
}

header .header-content {
   display: flex;
   justify-content: center;
   align-items: center;
   width: 100%;
   padding-top: 6px;
}

/* 프로필 사진 및 텍스트 정렬 */
.profile-container {
    display: flex;
    gap: 8px; /* 이미지와 텍스트 간격 */
}

.profile-picture img {
    width: 36px; /* 이미지 크기 */
    height: 36px;
    border-radius: 50%; /* 둥근 모양 */
    margin-top: -4px; /* 위로 올리기 위해 음수 마진 추가 */
}

.profile-text {
    color: white; /* 텍스트 색상 */
    text-decoration: none; /* 링크 밑줄 제거 */
}

.profile-text:hover {
    color: #ddd; /* 호버 시 색상 변경 */
}


</style>

<script>
	


</script>


<%
if (com.sist.web.util.CookieUtil.getCookie(request, (String) request.getAttribute("AUTH_COOKIE_NAME")) == null) {
%>
<header>
	<div class="header-content">
		<div class="logo">
			<a href="/index"><img src="/resources/images/logo.png" alt="로고"></a>
		</div>
		<nav>
			<ul>
				<li><a href="/user/userForm">로그인</a></li>
				<li class="nav-item-dropdown"><a href="#"><img alt="햄버거버튼" src="/resources/images/menu.png"></a> <!-- 드롭다운 메뉴 -->
					<ul class="dropdown-menu">
						<li><a href="#" onclick="fn_list(1)">공지사항</a></li>
						<li><a href="#" onclick="fn_list(2)">자유 게시판</a></li>
						<li><a href="#" onclick="fn_list(3)">전시 게시판</a></li>
						<li><a href="#" onclick="fn_list(4)">1:1문의</a></li>
						<li><a href="#" onclick="fn_list(5)">예매내역</a></li>
					</ul></li>
			</ul>
		</nav>
	</div>
</header>
<%
} else {
%>
<header>
	<div class="header-content">
		<div class="logo">
			<a href="/index"><img src="/resources/images/logo.png" alt="로고"></a>
		</div>

		        
		<nav>
			<ul>
        		<li>
				  <!-- 프로필 사진과 텍스트 추가 -->
				  <div class="profile-container">
				      <div class="profile-picture">
				          <img src="/resources/profile/${user.userId }.${user.fileExt}" onerror="this.onerror=null; this.src='/resources/images/default-profile.png';" alt="프로필 사진">
				      </div>
				      <a href="/user/updateForm" class="profile-text">${user.userName }</a>
				  </div>
        		</li>
        		<li><a href="#" onclick="fn_list(5)">예매확인/취소</a></li>
        		<li><a href="/user/logout">로그아웃</a></li>
				<!--   <li><a href="/user/updateForm">회원정보수정</a></li> -->
				<li class="nav-item-dropdown"><a href="#"><img alt="햄버거버튼" src="/resources/images/menu.png"></a> <!-- 드롭다운 메뉴 -->
					<ul class="dropdown-menu">
						<li><a href="#" onclick="fn_list(1)">공지사항</a></li>
						<li><a href="#" onclick="fn_list(2)">자유 게시판</a></li>
						<li><a href="#" onclick="fn_list(3)">전시 게시판</a></li>
						<li><a href="#" onclick="fn_list(4)">1:1문의</a></li>
						<li><a href="#" onclick="fn_list(5)">예매내역</a></li>
					</ul></li>
			</ul>
		</nav>
	</div>
</header>

<%
}
%>
