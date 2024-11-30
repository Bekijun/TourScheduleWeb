<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String dateKey = request.getParameter("dateKey");
    String userId = (String) session.getAttribute("user_id"); // user_id 세션에서 가져오기

    if (userId == null) {  // user_id가 존재하지 않으면
        // 아이디가 없을 경우, calendar.jsp로 페이지 이동
        out.println("<script>alert('아이디가 존재하지 않습니다. 로그인해주세요.'); window.location.replace('http://223.130.130.104:8080/calendar.jsp');</script>");
    } else {  // user_id가 존재할 경우
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String jdbcDriver = "jdbc:mysql://localhost:3306/TourSchedule?serverTimezone=UTC";
            String dbUser = "root";
            String dbPass = "1234";
            conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);

            // 첫 번째 쿼리: Users 테이블에서 user_id를 기준으로 조회
            String sql = "SELECT * FROM Users WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, userId);  // user_id를 쿼리에 설정
            rs = stmt.executeQuery();

            if (rs.next()) { // user_id가 존재하면
                // 두 번째 쿼리: user_schedule 테이블에서 해당 user_id로 일정 조회
                String scheduleSql = "SELECT * FROM user_schedule WHERE user_id = ? AND (start_date <= ? AND end_date >= ?)";
                stmt = conn.prepareStatement(scheduleSql);
                stmt.setString(1, userId);  // user_id를 쿼리에 설정
                stmt.setString(2, dateKey);  // start_date가 dateKey보다 이전인 일정
                stmt.setString(3, dateKey);  // end_date가 dateKey보다 이후인 일정
                rs = stmt.executeQuery();

                if (rs.next()) { // 일정이 존재하는 경우
                    //out.println("<script>alert('일정이 있습니다.');</script>");
                    String scheduleId = rs.getString("schedule_id");
                    out.println("<script>window.location.href='http://223.130.130.104:8080/viewTripForm.jsp?id=" + scheduleId + "';</script>");
                } else { // 일정이 존재하지 않는 경우
                    // 일정이 없을 경우, calendar.jsp로 페이지 이동
                    out.println("<script>alert('일정이 없습니다.'); window.location.replace('http://223.130.130.104:8080/calendar.jsp');</script>");
                }

            } else { // user_id가 존재하지 않는 경우
                // user_id가 없을 경우, calendar.jsp로 페이지 이동
                out.println("<script>alert('아이디가 존재하지 않습니다. 로그인해주세요.'); window.location.replace('http://223.130.130.104:8080/calendar.jsp');</script>");
            }

        } catch (SQLException ex) {
            out.println("<script>alert('DB 오류 발생: " + ex.getMessage() + "'); window.location.replace('http://223.130.130.104:8080/calendar.jsp');</script>");
            ex.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ex) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ex) {}
            if (conn != null) try { conn.close(); } catch (SQLException ex) {}
        }
    }
%>
