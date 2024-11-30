<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 문자 인코딩 설정
    request.setCharacterEncoding("UTF-8");
    
    // 폼에서 전송된 데이터 받기
    String user_id = request.getParameter("user_id");
    String password = request.getParameter("password");
    
    // DB 연결 정보
    String jdbcUrl = "jdbc:mysql://localhost:3306/TourSchedule?useSSL=false&allowPublicKeyRetrieval=true";
    String dbUser = "root";
    String dbPassword = "1234";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // DB 연결
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        
        // 사용자 인증
        String sql = "SELECT * FROM Users WHERE user_id = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, user_id);
        pstmt.setString(2, password);
        
        rs = pstmt.executeQuery();
        
        if(rs.next()) {
            // 로그인 성공
            // 세션에 사용자 정보 저장
            session.setAttribute("user_id", user_id);
            session.setAttribute("nickname", rs.getString("nickname"));
            session.setAttribute("bio", rs.getString("bio"));
            
            // calendar.jsp로 리다이렉트
            response.sendRedirect("calendar.jsp");
        } else {
            // 로그인 실패 시 alert 표시
            %>
            <script>
                alert('아이디 또는 비밀번호가 일치하지 않습니다.');
                history.back();
            </script>
            <%
        }
        
    } catch(Exception e) {
        %>
        <script>
            alert('로그인 처리 중 오류가 발생했습니다.');
            history.back();
        </script>
        <%
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 