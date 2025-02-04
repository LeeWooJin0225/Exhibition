# 🖼 전시 예매 플랫폼
![Image](https://github.com/user-attachments/assets/593e460f-55e5-4330-9a61-48670fdf0c57)

전시회 예매와 커뮤니티를 통해 소통이 가능한 플랫폼
<br>
<br>

## 프로젝트 소개
> 사용자들 간의 소통을 통해 의견을 나눌 수 있으며, 판매 중인 전시회 티켓을 예매할 수 있는 플랫폼입니다.
<br>

## 개발 기간 및 인원
> 2024.09.20 ~ 2024.10.02<br>
> 1명 (Full-Stack)
<br>

## 목차
> 1. [ERD 구조](#erd-구조)
> 2. [개발 환경](#개발-환경)
> 3. [주요 기능](#주요-기능)
<br>

## ERD 구조
![Image](https://github.com/user-attachments/assets/f13b5b9d-26e6-4836-af60-f50dcbb6b2fb)
<br>

## 개발 환경
- 개발 언어<br>
![SpringBoot](https://img.shields.io/badge/SpringBoot-6db33f?style=for-the-badge&logo=springboot&logoColor=white)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![jQuery](https://img.shields.io/badge/jquery-%230769AD.svg?style=for-the-badge&logo=jquery&logoColor=white)
![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E)
![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/css3-%231572B6.svg?style=for-the-badge&logo=css3&logoColor=white)

- 서버<br>
![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/apache%20tomcat-%23F8DC75.svg?style=for-the-badge&logo=apache-tomcat&logoColor=black)

- 개발 도구<br>
![Eclipse](https://img.shields.io/badge/Eclipse-FE7A16.svg?style=for-the-badge&logo=Eclipse&logoColor=white)
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)

<br>

## 주요 기능
<table align="center">
  <tr>
   <th>
    사용자
   </th>
   <th >
    관리자
   </th>
   </tr>
  <tr>
   <td align="left" width="350px" class="사용자">
    - 회원가입, 로그인
    <br/>
    - 게시글 관리
    <br/>
    - 티켓 구매
   </td>
   <td align="left" width="350px" class="관리자">
     - 게시글 관리
    <br/>
   </td>
  </tr>
</table>
<br>

## [ 사용자 기능 ]
### 회원가입, 로그인
- 사용자는 아이디, 이메일, 이름, 비밀번호, 주소를 입력해 회원가입이 가능하다.
    - 이메일 인증을 통해 유효한 이메일인지 확인할 수 있다.
<details>
  <summary>🔽 이미지 보기</summary>
  <p>
    <strong>1. 회원가입 - 이메일 인증</strong> <br>
    <img src="https://github.com/user-attachments/assets/7a459bd7-d9d2-40c4-801d-6e8902254dac"
         alt="image1" style="height: 400px;" />
  </p>
</details> 

## 게시글 관리
- 자유 게시판, 전시 게시판, 1:1 문의 게시판에 게시글 등록/열람/수정/삭제가 가능하다.
- 자유 게시판에서 좋아요와 댓글 기능을 통해 사용자의 의견을 표현할 수 있다.
  - AJAX를 이용하여 실시간으로 확인할 수 있다.
  - 좋아요 버튼은 한 사람당 1개의 좋아요만 표현할 수 있기에 한 번 누를 시 등록이며 그 상태에서 한 번 더 누를시 취소가 된다.
  - 시간을 계산하여 사용자의 댓글이 언제 작성되었는지 대략적인 수치를 알 수 있다.

<details>
  <summary>🔽 이미지 보기</summary>
  
  <p>
    <strong>1. 자유 게시판 - 게시글 등록</strong> <br>
    <img src="https://github.com/user-attachments/assets/d04a7611-4e52-44c4-99e7-a391bed87f46"
         alt="image1" style="height: 400px;" />
  </p>
  
  <p>
    <strong>2. 자유 게시판 - 좋아요 </strong> <br>
    <img src="https://github.com/user-attachments/assets/58085879-b8a1-491f-b23e-058012d75430"
         alt="image2" style="height: 400px;" />
  </p>

  <p>
    <strong>2. 자유 게시판 - 댓글 </strong> <br>
    <img src="https://github.com/user-attachments/assets/a3f6a03d-eead-4ac8-8d5d-d5d1f27ac9af"
         alt="image2" style="height: 400px;" />
  </p>

</details>

## 티켓 구매
- 현재 구매 가능한 전시회들 중에서만 구매를 할 수 있다.
  - 전시 판매가 시작하지 않았거나 끝난 전시회들은 회색으로 처리되며 'CLOSED', 'COMMING SOON'으로 표시해두어 사용자가 확인할 수 있다.
  - 오라클 프로시저를 이용하여 전시회의 시작 날짜와 마감 날짜에 맞추어 상태값을 변경 가능하도록 하였다.
- 카카오페이 API를 이용하여 사용자가 직접 결제가 가능하다.
  
<details>
  <summary>🔽 이미지 보기</summary>
  <p>
    <strong>1. 티켓 구매 - 날짜 선택</strong> <br>
    <img src="https://github.com/user-attachments/assets/446e3e8e-4a29-447e-a24b-824626899872"
         alt="image1" style="height: 400px;" />
  </p>

  <p>
    <strong>2. 티켓 구매 - 결제</strong> <br>
    <img src="https://github.com/user-attachments/assets/e6ced99c-157c-4254-9a54-3fbbb0b11b48"
         alt="image1" style="height: 400px;" />
  </p>

  <p>
    <strong>2. 오라클 프로시저 - 전시회 상태값 자동 변경 </strong> <br>
    <img src="https://github.com/user-attachments/assets/bec640c3-1e3a-4997-8e22-1bd1bea870fe"
         alt="image1" style="height: 400px;" />
  </p>
</details> 

## [ 관리자 기능 ]
### 게시글 관리
- 공지사항 게시판에 글을 등록할 수 있다.
    - '중요 글' 표시를 통해 중요한 글은 최우선으로 정렬이 가능하도록 하였다.
- QnA 게시판에서 사용자가 등록한 글에 답글을 달아줄 수 있다.
 
  <details>
  <summary>🔽 이미지 보기</summary>
  <p>
    <strong>1. 공지사항 게시판 - 글 작성</strong> <br>
    <img src="https://github.com/user-attachments/assets/6c4a7898-afa7-4869-bd36-057e8e9298f3"
         alt="image1" style="height: 400px;" />
  </p>

  <p>
    <strong>2. QnA 게시판 - 답글 작성</strong> <br>
    <img src="https://github.com/user-attachments/assets/8143ee5b-ffd8-4022-86b8-275ce9aa9d89"
         alt="image1" style="height: 400px;" />
  </p>
</details> 













