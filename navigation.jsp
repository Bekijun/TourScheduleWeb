<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/styles/navigation.css">

<div>
    <aside>
        <img src="<%=request.getContextPath()%>/res/profile.png" alt="Profile Image">
        <div class="info">
            <% 
            // 세션에서 사용자 정보 확인
            String loggedInUserId = (String)session.getAttribute("user_id");
            String nickname = (String)session.getAttribute("nickname");
            String bio = (String)session.getAttribute("bio");
            %>
            <p id="nickname" class="nickname"><%= nickname != null ? nickname : "게스트" %></p>
            <p class="bio"><%= bio != null ? bio : "한 줄 소개를 입력해 주세요" %></p>
        </div>
        <div class="menu">
            <a href="<%=request.getContextPath()%>/calendar.jsp">캘린더</a>
            <a href="<%=request.getContextPath()%>/mypageForm.jsp" onclick="return checkLogin('mypageForm')">마이페이지</a>
            <% if(loggedInUserId != null) { %>
                <a href="<%=request.getContextPath()%>/logout.jsp" onclick="return confirm('로그아웃 하시겠습니까?')">로그아웃</a>
            <% } else { %>
                <a href="<%=request.getContextPath()%>/login.jsp">로그인</a>
                <a href="<%=request.getContextPath()%>/signupForm.jsp">회원가입</a>
            <% } %>
        </div>
    </aside>
</div>

<script>
function checkLogin(page) {
    if(session.getAttribute("user_id") == null) {
        if(page === 'mypage') {
            alert("마이페이지는 로그인이 필요한 서비스입니다.");
            location.href = "<%=request.getContextPath()%>/login.jsp";
            return false;
        }
    }
    return true;
}
</script>