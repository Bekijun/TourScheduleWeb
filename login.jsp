<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pick Us</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/login.css">
</head>

<body>
    <jsp:include page="header.jsp" />
    <div class="container">
        <jsp:include page="navigation.jsp" />
        <section>
            <div class="wrapper">
                <h2>로그인</h2>
                <form action="loginProcess.jsp" method="post">
                    <div>
                        <label for="user_id">아이디</label>
                        <input type="text" id="user_id" name="user_id" placeholder="아이디를 입력하세요" required>
                    </div>
                    <div>
                        <label for="password">비밀번호</label>
                        <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
                    </div>
                    <button type="submit">로그인</button>
                </form>
            </div>
        </section>
    </div>
    <jsp:include page="footer.jsp" />

    <script src="scripts/header.js"></script>
</body>
</html>