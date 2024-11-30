<%
    String user_id = (String)session.getAttribute("user_id");
    String nickname = (String)session.getAttribute("nickname");
    
    // 로그인이 필요한 페이지에서는 다음 코드를 추가
    if(user_id == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%> 