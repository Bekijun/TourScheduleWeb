<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="sessionCheck.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pick Us</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/mypage.css">
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="container">
        <jsp:include page="navigation.jsp" />
        <section>
            <div class="wrapper">
                <div class="profile-section">
                    <div class="profile-info">
                        <form action="mypage.jsp" method="post">
                            <div class="info-group">
                                <label class="info-label">아이디</label>
                                <input type="text" name="user_id" class="input-field" value="<%= session.getAttribute("user_id") %>" readonly>
                            </div>
                            <div class="info-group">
                                <label class="info-label">닉네임</label>
                                <input type="text" name="nickname" class="input-field" value="<%= session.getAttribute("nickname") %>" required>
                            </div>
                            <div class="info-group">
                                <label class="info-label">한 줄 소개</label>
                                <input type="text" name="bio" class="input-field" value="<%= session.getAttribute("bio") %>">
                            </div>
                            <button type="submit" class="save-button">저장하기</button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="wrapper">
                <div class="profile-section">
                    <div class="profile-info">
                        <h2>내 여행 일정</h2>
                        <div class="schedule-list" id="scheduleList">
                            
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <jsp:include page="footer.jsp" />
    <script src="<%=request.getContextPath()%>/scripts/header.js"></script>
    <script>
    // 페이지 로드 시 일정 목록 가져오기
    window.onload = function() {
        fetch('mypage.jsp')
            .then(response => response.text())
            .then(html => {
                document.getElementById('scheduleList').innerHTML = html;
            })
            .catch(error => console.error('Error:', error));
    };

    // 일정 버튼 클릭 시 viewTripForm으로 이동
    function viewSchedule(scheduleId) {
        location.href = 'viewTripForm.jsp?id=' + scheduleId;
    }
    </script>
</body>
</html>