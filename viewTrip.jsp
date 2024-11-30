<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String scheduleId = request.getParameter("id");
    String userId = (String) session.getAttribute("user_id");
    
    
    StringBuilder json = new StringBuilder();
    json.append("{");
    
    if(userId == null) {
        json.append("\"error\": \"로그인이 필요합니다.\"");
        json.append("}");
        response.setContentType("application/json");
        out.print(json.toString());
        return;
    }

    String jdbcUrl = "jdbc:mysql://localhost:3306/TourSchedule?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPassword = "1234";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        
        String sql = "SELECT * FROM user_schedule WHERE schedule_id = ? AND user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(scheduleId));
        pstmt.setString(2, userId);
        
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            json.append("\"title\": \"" + escapeJSON(rs.getString("title")) + "\",");
            json.append("\"country\": \"" + escapeJSON(rs.getString("country")) + "\",");
            json.append("\"region\": \"" + escapeJSON(rs.getString("region")) + "\",");
            json.append("\"start_date\": \"" + rs.getString("start_date") + "\",");
            json.append("\"end_date\": \"" + rs.getString("end_date") + "\",");
            json.append("\"cost\": " + rs.getLong("cost") + ",");
            
            String schedulesData = rs.getString("schedules");
            if (schedulesData == null || schedulesData.trim().isEmpty()) {
                json.append("\"schedules\": {}");
            } else {
                json.append("\"schedules\": " + schedulesData);
            }
        } else {
            json.append("\"error\": \"해당 일정을 찾을 수 없습니다. (scheduleId: " + scheduleId + ", userId: " + userId + ")\"");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        json.append("\"error\": \"" + escapeJSON(e.getMessage()) + "\"");
    } finally {
        if(rs != null) try { rs.close(); } catch(SQLException e) {}
        if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
        if(conn != null) try { conn.close(); } catch(SQLException e) {}
    }
    
    json.append("}");
    response.setContentType("application/json");
    out.print(json.toString());
%>

<%!
    private String escapeJSON(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
%> 