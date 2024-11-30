<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 문자 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    // 디버깅을 위한 파라미터 값 출력
    out.println("<div style='background-color: #f0f0f0; padding: 10px; margin: 10px;'>");
    out.println("<h3>전송된 파라미터 확인:</h3>");
    out.println("nickname: [" + request.getParameter("nickname") + "]<br>");
    out.println("user_id: [" + request.getParameter("user_id") + "]<br>");
    out.println("password: [" + (request.getParameter("password") != null ? "입력됨" : "null") + "]<br>");
    out.println("confirmpassword: [" + (request.getParameter("confirmpassword") != null ? "입력됨" : "null") + "]<br>");
    out.println("</div>");

    // 폼에서 전송된 데이터 받기
    String nickname = request.getParameter("nickname");
    String user_id = request.getParameter("user_id");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmpassword");
    
    // null 체크 및 유효성 검사
    if (user_id == null || user_id.trim().isEmpty()) {
        out.println("<div style='color: red;'>Error: user_id 값이 비어 있습니다!</div>");
        return;
    }
    if (nickname == null || nickname.trim().isEmpty()) {
        out.println("<div style='color: red;'>Error: nickname 값이 비어 있습니다!</div>");
        return;
    }
    if (password == null || password.trim().isEmpty()) {
        out.println("<div style='color: red;'>Error: password 값이 비어 있습니다!</div>");
        return;
    }

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
        
        // 아이디 중복 체크
        String checkSql = "SELECT COUNT(*) FROM Users WHERE user_id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, user_id);
        rs = pstmt.executeQuery();
        rs.next();
        
        if(rs.getInt(1) > 0) {
            // 중복된 아이디가 있는 경우
            response.sendRedirect("signup.jsp?error=duplicate");
            return;
        }
        
        // 회원 정보 삽입
        String sql = "INSERT INTO Users (user_id, nickname, password) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, user_id);
        pstmt.setString(2, nickname);
        pstmt.setString(3, password);
        
        int result = pstmt.executeUpdate();
        
        if(result > 0) {
            // 회원가입 성공 시 lggin.jsp로 리다이렉트
            response.sendRedirect("login.jsp?signup=success");
        } else {
            // 회원가입 실패
            response.sendRedirect("signupForm.jsp?error=database");
        }
        
    } catch(Exception e) {
        // 오류 발생
        e.printStackTrace();
        out.println("<div style='color: red;'>오류 발생: " + e.getMessage() + "</div>");
        out.println("<div>스택 트레이스:</div>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
        return;
    } finally {
        // 리소스 해제
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%> 