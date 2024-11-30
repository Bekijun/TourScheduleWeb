<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pick Us</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/addTrip.css">
</head>

<body>
    <jsp:include page="header.jsp" />
    <main>
        <jsp:include page="navigation.jsp" />
        <div class="panel">
            <div class="left-panel">
                <form id="travelForm" class="travel-form" method="post">
                    <div class="form-header">
                        <h2>여행 계획 작성</h2>
                    </div>

                    <h3>여행 제목</h3>
                    <input type="text" name="title" class="input-field" required>

                    <h3>여행 나라</h3>
                    <input type="text" name="country" class="input-field" required>
                    
                    <h3>여행 지역</h3>
                    <input type="text" name="region" class="input-field" required>
                    
                    <div class="date-section">
                        <div>
                            <h3>출발 날짜</h3>
                            <input type="date" name="startDate" class="date-input" required>
                        </div>
                        <div>
                            <h3>도착 날짜</h3>
                            <input type="date" name="endDate" class="date-input" required>
                        </div>
                    </div>
                    
                    <h3>예상 지출</h3>
                    <input type="text" name="expectedCost" class="input-field" required>
                    
                    <!-- hidden input 추가 -->
                    <input type="hidden" name="schedules" value="{}">
                </form>
            </div>
            
            <div class="right-panel">
                <div class="calendar">
                    <div class="calendar-header">
                        <button type="button" class="date-nav-btn prev-date">&lt;</button>
                        <div class="date-info">
                            <h2><span id="selectedCountry"></span> <span id="selectedRegion"></span>✈️</h2>
                            <h3><span id="selectedDate">날짜를 선택해주세요</span></h3>
                        </div>
                        <button type="button" class="date-nav-btn next-date">&gt;</button>
                    </div>
                    
                    <div class="schedule-input">
                        <input type="time" id="scheduleTime" class="time-input" required>
                        <input type="text" id="scheduleContent" placeholder="일정 내용" class="content-input" required>
                        <button type="button" onclick="addSchedule()" class="add-btn">추가</button>
                    </div>
                    
                    <div class="schedule-list" id="scheduleList">
                        <!-- 시간별 일정이 동적으로 추가됨 -->
                    </div>
                    
                    <div class="expected-cost">
                        <span>예상 지출: </span>
                        <span id="displayedCost">0</span>
                        <span>원</span>
                    </div>

                    <!-- 제출 버튼 추가 -->
                    <div class="submit-section">
                        <button type="button" onclick="submitTravelForm(event)" class="submit-btn">저장하기</button>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <jsp:include page="footer.jsp" />

    <script src="<%=request.getContextPath()%>/scripts/header.js"></script>
    <script src="<%=request.getContextPath()%>/scripts/addTrip.js"></script>
</body>
</html> 