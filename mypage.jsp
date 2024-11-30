<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // POST 요청일 때 프로필 업데이트 처리
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String user_id = (String)session.getAttribute("user_id");
        String newNickname = request.getParameter("nickname");
        String newBio = request.getParameter("bio");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String jdbcUrl = "jdbc:mysql://localhost:3306/TourSchedule?useSSL=false&allowPublicKeyRetrieval=true";
            String dbUser = "root";
            String dbPassword = "1234";
            
            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            
            String sql = "UPDATE Users SET nickname = ?, bio = ? WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newNickname);
            pstmt.setString(2, newBio);
            pstmt.setString(3, user_id);
            
            int result = pstmt.executeUpdate();
            
            if(result > 0) {
                session.setAttribute("nickname", newNickname);
                session.setAttribute("bio", newBio);
                %>
                <script>
                    alert('프로필이 업데이트되었습니다.');
                    location.href='mypageForm.jsp';
                </script>
                <%
            } else {
                %>
                <script>
                    alert('프로필 업데이트에 실패했습니다.');
                    history.back();
                </script>
                <%
            }
        } catch(Exception e) {
            %>
            <script>
                alert('오류가 발생했습니다: <%= e.getMessage() %>');
                history.back();
            </script>
            <%
        } finally {
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
    // GET 요청일 때 일정 목록 조회
    else {
        String user_id = (String)session.getAttribute("user_id");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String jdbcUrl = "jdbc:mysql://localhost:3306/TourSchedule?useSSL=false&serverTimezone=UTC";
            String dbUser = "root";
            String dbPassword = "1234";
            
            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            
            String sql = "SELECT schedule_id, title FROM user_schedule WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user_id);
            
            rs = pstmt.executeQuery();
            
            StringBuilder html = new StringBuilder();
            boolean hasSchedules = false;
            
            while(rs.next()) {
                hasSchedules = true;
                html.append("<button ")
                    .append("type='button' ")
                    .append("class='schedule-item' ")
                    .append("onclick='viewSchedule(").append(rs.getInt("schedule_id")).append(")' ")
                    .append("style='")
                    .append("background-color: #4dabf7; ")
                    .append("color: white; ")
                    .append("padding: 20px; ")
                    .append("border-radius: 12px; ")
                    .append("cursor: pointer; ")
                    .append("width: 100%; ")
                    .append("text-align: left; ")
                    .append("font-size: 18px; ")
                    .append("border: none; ")
                    .append("outline: none; ")
                    .append("margin: 10px 0; ")
                    .append("font-weight: 500; ")
                    .append("box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); ")
                    .append("transition: all 0.3s ease-in-out;'")
                    .append("onmouseover='this.style.backgroundColor=\"#339af0\"' ")
                    .append("onmouseout='this.style.backgroundColor=\"#4dabf7\"' ")
                    .append(">")
                    .append(rs.getString("title"))
                    .append("</button>");
            }
            
            if(!hasSchedules) {
                html.append("<div class='no-schedule'>지금 바로 일정을 추가해 주세요!</div>");
            }
            
            response.setContentType("text/html;charset=UTF-8");
            out.print(html.toString());
            
        } catch(Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            out.print("오류가 발생했습니다: " + e.getMessage());
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
%>