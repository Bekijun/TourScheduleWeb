<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pick Us</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/signup.css">
    </head>
<body>
    <jsp:include page="header.jsp" />
    <div class="container">
        <jsp:include page="navigation.jsp" />
        <section>
            <div class="wrapper">
                <h2>회원가입</h2>
                <form class="login-form" id="signupForm" method="post" action="signup.jsp" onsubmit="return validateForm()">
                    <label for="nickname">닉네임</label>
                    <input type="text" id="nickname" name="nickname" placeholder="닉네임을 입력하세요" required>
            
                    <label for="user_id">아이디</label>
                    <input type="text" id="user_id" name="user_id" placeholder="아이디를 입력하세요"required>
            
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요"required>
            
                    <label for="confirmpassword">비밀번호 재입력</label>
                    <input type="password" id="confirmpassword" name="confirmpassword" placeholder="비밀번호를 재입력하세요"required>
            
                    <button type="submit">회원가입</button>
            </form>
            </div>
            <div id="signupResult"></div>
        </section>
    </div>
    <jsp:include page="footer.jsp" />
    <script src="scripts/header.js"></script>

    <script>
    function validateForm() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmpassword").value;
        
        if (password !== confirmPassword) {
            alert("비밀번호가 일치하지 않습니다.");
            return false;
        }
        
        // 폼 데이터 확인
        console.log("nickname:", document.getElementById("nickname").value);
        console.log("user_id:", document.getElementById("user_id").value);
        console.log("password:", document.getElementById("passward").value);
        
        return true;
    }
    </script>

</body>
</html>