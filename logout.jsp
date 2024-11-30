<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 현재 로그인 상태 확인
    String loggedInUserId = (String)session.getAttribute("user_id");
    
    if(loggedInUserId != null) {
        // 로그인 상태일 때만 세션 무효화
        session.invalidate();
        // calendar.jsp로 리다이렉트
        response.sendRedirect("calendar.jsp");
    } else {
        // 로그인 상태가 아니면 이전 페이지로 돌아가기
        response.sendRedirect(request.getHeader("Referer"));
    }
%> 