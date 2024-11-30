<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PICK US! - 당신의 완벽한 여행 파트너</title>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/index.css">
</head>
<body>
    <div class="hero-section">
        <img src="${pageContext.request.contextPath}/res/airplane.jpg" alt="세계 지도와 국기들" class="hero-image">
        <div class="hero-text">
            <div class="logo">PICK US!</div>
            <h1>당신의 완벽한 여행을 계획하세요</h1>
            <p>전 세계 어디든, PICK US와 함께라면 쉽고 편리하게</p>
            <%-- 로그인 상태에 따라 다른 버튼 표시 --%>
            <% if(session.getAttribute("userId") == null) { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn">로그인하고 시작하기</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/planner/new" class="btn">새 여행 계획하기</a>
            <% } %>
        </div>
    </div>

    <section class="booking-links">
        <h2>예약 서비스</h2>
        <div class="booking-container">
            <a href="https://www.klook.com/ko/" class="booking-circle" target="_blank">
                <div class="circle-image" style="background-image: url('${pageContext.request.contextPath}/res/tourist.jpg')">
                    <div class="circle-text">관광지 예약</div>
                </div>
            </a>
            <a href="https://www.google.com/travel/flights?hl=ko" class="booking-circle" target="_blank">
                <div class="circle-image" style="background-image: url('${pageContext.request.contextPath}/res/airport.jpg')">
                    <div class="circle-text">항공기 예약</div>
                </div>
            </a>
            <a href="https://www.agoda.com/ko-kr/" class="booking-circle" target="_blank">
                <div class="circle-image" style="background-image: url('${pageContext.request.contextPath}/res/hotel.jpg')">
                    <div class="circle-text">호텔 예약</div>
                </div>
            </a>
        </div>
    </section>

    <section class="how-to-use">
        <div class="steps">
            <h2>이용 방법</h2><br>
            <div class="step">
                <h3>1. 회원가입</h3>
                <p>간단한 회원가입으로 시작하세요</p>
            </div>
            <div class="step">
                <h3>2. 여행 일정 생성</h3>
                <p>목적지와 날짜를 선택하고 새로운 여행을 만들어 보세요</p>
            </div>
            <div class="step">
                <h3>3. 일정 관리</h3>
                <p>장소, 교통, 숙소 등 모든 일정을 한 곳에서 관리하세요</p>
            </div>
        </div>
    </section>

    <jsp:include page="footer.jsp" />
</body>
</html>
