<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String scheduleId = request.getParameter("id");
    String userId = (String) session.getAttribute("user_id");
    
    response.setContentType("application/json");
    
    if(userId == null) {
        out.print("{\"success\": false, \"error\": \"로그인이 필요합니다.\"}");
        return;
    }

    String jdbcUrl = "jdbc:mysql://localhost:3306/TourSchedule?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPassword = "1234";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        
        String sql = "DELETE FROM user_schedule WHERE schedule_id = ? AND user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, scheduleId);
        pstmt.setString(2, userId);
        
        int result = pstmt.executeUpdate();
        
        if(result > 0) {
            out.print("{\"success\": true}");
        } else {
            out.print("{\"success\": false, \"error\": \"일정을 삭제할 수 없습니다.\"}");
        }
        
    } catch(Exception e) {
        out.print("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
        if(conn != null) try { conn.close(); } catch(SQLException e) {}
    }
%>