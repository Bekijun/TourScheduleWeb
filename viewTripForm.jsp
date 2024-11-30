<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pick Us - 여행 일정</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/viewTrip.css">
</head>
<body>
    <jsp:include page="header.jsp" />
    <main>
        <jsp:include page="navigation.jsp" />
        <div class="panel">
            <div class="trip-info">
                <div class="info-header">
                    <div style="display: flex; justify-content: space-between; width: 100%;">
                        <h2 id="tripTitle">여행 제목</h2>
                        <button id="deleteTrip" class="delete-btn">삭제</button>
                    </div>
                    <div class="trip-meta">
                        <span id="tripCountry"></span>
                        <span id="tripRegion"></span>
                        <span id="tripDate"></span>
                    </div>
                </div>
                <div class="cost-info">
                    <span>예상 지출: </span>
                    <span id="displayedCost">0</span>
                    <span>원</span>
                </div>
            </div>
            
            <div class="schedule-panel">
                <div class="calendar">
                    <div class="schedule-list" id="scheduleList">
                        <!-- 일정이 동적으로 추가됨 -->
                    </div>
                </div>
            </div>
        </div>
    </main>
    <jsp:include page="footer.jsp" />

    <script>
        // 서버에서 데이터를 가져오기 위한 schedule_id
        const scheduleId = '<%= request.getParameter("id") %>';
    </script>
    <script src="<%=request.getContextPath()%>/scripts/viewTrip.js"></script>
    <script src="<%=request.getContextPath()%>/scripts/header.js"></script>
</body>
</html> 