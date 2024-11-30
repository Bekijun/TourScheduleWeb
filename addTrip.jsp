<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String userId = (String) session.getAttribute("user_id");
    if(userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
        
    request.setCharacterEncoding("UTF-8");
    
    String title = request.getParameter("title");
    String country = request.getParameter("country");
    String region = request.getParameter("region");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    String cost = request.getParameter("expectedCost");
    String schedulesJson = request.getParameter("schedules");
    
    String jdbcUrl = "jdbc:mysql://localhost:3306/TourSchedule?useSSL=false&allowPublicKeyRetrieval=true";
    String dbUser = "root";
    String dbPassword = "1234";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        if (title == null || title.trim().isEmpty()) {
            throw new Exception("제목이 누락되었습니다.");
        }
        if (country == null || country.trim().isEmpty()) {
            throw new Exception("국가가 누락되었습니다.");
        }
        if (region == null || region.trim().isEmpty()) {
            throw new Exception("지역이 누락되었습니다.");
        }
        if (startDate == null || startDate.trim().isEmpty()) {
            throw new Exception("출발 날짜가 누락되었습니다.");
        }
        if (endDate == null || endDate.trim().isEmpty()) {
            throw new Exception("도착 날짜가 누락되었습니다.");
        }
        
        cost = (cost == null || cost.trim().isEmpty()) ? "0" : cost.replaceAll(",", "");
        schedulesJson = (schedulesJson == null || schedulesJson.trim().isEmpty()) ? "{}" : schedulesJson;
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        
        String sql = "INSERT INTO user_schedule (user_id, title, country, region, start_date, end_date, cost, schedules) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, userId);
        pstmt.setString(2, title.trim());
        pstmt.setString(3, country.trim());
        pstmt.setString(4, region.trim());
        pstmt.setDate(5, java.sql.Date.valueOf(startDate.trim()));
        pstmt.setDate(6, java.sql.Date.valueOf(endDate.trim()));
        pstmt.setLong(7, Long.parseLong(cost));
        pstmt.setString(8, schedulesJson);
        
        int result = pstmt.executeUpdate();
        out.print(result > 0 ? "success" : "fail");
        
    } catch(Exception e) {
        response.setContentType("text/plain;charset=UTF-8");
        out.print("error: " + e.getMessage());
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 