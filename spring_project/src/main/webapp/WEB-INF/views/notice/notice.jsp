<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@ include file="/WEB-INF/views/include/head.jsp"%>
    <title>공지사항</title>
    <link rel="stylesheet" href="styles.css">
    
    <style>
    /* 기본 스타일 */
body {
    font-family: Arial, sans-serif;
    background-color: #f8f9fa;
    margin: 0;
    padding: 0;
}

/* 컨테이너 설정 */
.container {
    width: 80%;
    margin: 0 auto;
    padding: 10px 0; /* 상하 여백은 유지하고 좌우 여백을 줄입니다 */
    background-color: #fff;
}

/* 헤더 스타일 */
header {
    display: flex;
    justify-content: flex-start; /* 왼쪽 정렬 */
    align-items: center;
    border-bottom: 1px solid #ddd;
    padding-bottom: 10px;
    gap: 30px; /* 제목과 네비게이션 메뉴 간격 추가 */
}

header h1 {
    font-size: 24px;
    font-weight: bold;
    margin-right: 20px; /* 제목과 메뉴 간격 조정 */
}

header nav ul {
    list-style: none;
    padding: 0;
    display: flex;
    gap: 15px;
}

header nav ul li {
    display: inline;
}

header nav ul li a {
    text-decoration: none;
    color: black;
    font-weight: bold;
    padding: 5px 10px;
}

header nav ul li a.active, 
header nav ul li a:hover {
    color: gray;
    border-bottom: 2px solid black;
}

/* 공지사항 리스트 스타일 */
.notice-list {
    margin-top: 20px;
}

.notice-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #eee;
    padding: 15px 0;
}

.notice-item .category {
    color: gray;
    font-weight: bold;
    margin-right: 20px;
}

.notice-item a {
    text-decoration: none;
    color: #333;
    flex: 1;
}

.notice-item .date {
    color: #999;
}

/* 반응형 스타일 */
@media (max-width: 768px) {
    .container {
        width: 100%;
        padding: 10px;
    }

    header {
        flex-direction: column;
        align-items: flex-start;
    }

    header nav ul {
        flex-direction: column;
        gap: 10px;
    }

    .notice-item {
        flex-direction: column;
        align-items: flex-start;
    }

    .notice-item .category {
        margin-bottom: 5px;
    }
}

/* 페이지네이션 스타일 */
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
    gap: 8px;
}

.pagination .page-link {
    display: inline-block;
    padding: 8px 12px;
    text-decoration: none;
    color: gray;
    border: 1px solid #ddd;
    border-radius: 50%;
    transition: background-color 0.3s, color 0.3s;
}

.pagination .page-link.active {
    background-color: black;
    color: white;
}

.pagination .page-link:hover {
    background-color: #f0f0f0;
    color: black;
}

.pagination .page-link:focus {
    outline: none;
    background-color: #e0e0e0;
}


    
    </style>
</head>

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
    });
</script>


<body>
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>
   
    <div class="container">
        <header>
            <h1>공지사항</h1>
            <nav>
                <ul>
                    <li><a href="#" class="active">전체</a></li>
                    <li><a href="#">업데이트</a></li>
                    <li><a href="#">서비스</a></li>
                    <li><a href="#">이벤트</a></li>
                    <li><a href="#">공공기관</a></li>
                    <li><a href="#">광고</a></li>
                </ul>
            </nav>
        </header>
        <section class="notice-list">
            <div class="notice-item">
                <span class="category">작업</span>
                <a href="#">[안내] 10/24(목) 네이버웍스 코어 메시지 서비스 서버 점검 작업</a>
                <span class="date">2024.10.22</span>
            </div>
            <div class="notice-item">
                <span class="category">서비스</span>
                <a href="#">네이버웍스 코어 & 웍스 드라이브 일부 기능의 사양 변경 및 종료 안내</a>
                <span class="date">2024.10.18</span>
            </div>
            <div class="notice-item">
                <span class="category">이벤트</span>
                <a href="#">[프로모션 안내] 네이버웍스 슬로보드 신규 고객 반값 시간 2배 혜택 제공</a>
                <span class="date">2024.10.18</span>
            </div>
                        <div class="notice-item">
                <span class="category">이벤트</span>
                <a href="#">[프로모션 안내] 네이버웍스 슬로보드 신규 고객 반값 시간 2배 혜택 제공</a>
                <span class="date">2024.10.18</span>
            </div>
                        <div class="notice-item">
                <span class="category">이벤트</span>
                <a href="#">[프로모션 안내] 네이버웍스 슬로보드 신규 고객 반값 시간 2배 혜택 제공</a>
                <span class="date">2024.10.18</span>
            </div>
                        <div class="notice-item">
                <span class="category">이벤트</span>
                <a href="#">[프로모션 안내] 네이버웍스 슬로보드 신규 고객 반값 시간 2배 혜택 제공</a>
                <span class="date">2024.10.18</span>
            </div>
                        <div class="notice-item">
                <span class="category">이벤트</span>
                <a href="#">[프로모션 안내] 네이버웍스 슬로보드 신규 고객 반값 시간 2배 혜택 제공</a>
                <span class="date">2024.10.18</span>
            </div>
                        <div class="notice-item">
                <span class="category">이벤트</span>
                <a href="#">[프로모션 안내] 네이버웍스 슬로보드 신규 고객 반값 시간 2배 혜택 제공</a>
                <span class="date">2024.10.18</span>
            </div>
            <!-- 반복되는 항목들 -->
            
            <div class="pagination">
		    <a href="#" class="page-link">&lt;</a>
		    <a href="#" class="page-link active">1</a>
		    <a href="#" class="page-link">2</a>
		    <a href="#" class="page-link">3</a>
		    <a href="#" class="page-link">4</a>
		    <a href="#" class="page-link">5</a>
		    <a href="#" class="page-link">&gt;</a>
			</div>
			
		
        </section>
    </div>
    
    <%@ include file="/WEB-INF/views/include/footer.jsp"%>

</body>
</html>
