<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pick Us</title>
    <link rel="stylesheet" href="styles/calendar.css">
</head>
<body>
    <jsp:include page="header.jsp" />
    <main>
        <jsp:include page="navigation.jsp" />
        <div class="wrapper">
            <div class="calendar">
                <div class="navContainer">
                    <div class="year">
                        <button class="last_year"> &lt </button>
                        <p class="current-date year-date"></p>
                        <button class="next_year"> &gt </button>
                    </div>
                    <div class="month">
                        <button class="last_month"> &lt </button>
                        <p class="current-date month-date"></p>
                        <button class="next_month"> &gt </button>
                    </div>
                </div>
                <ul class="weeks"></ul>
                <ul class="days"></ul>
            </div>
        </div>
    </main>
    <div id="footer"></div>
</body>
<div class="floating-button">
    <% if(session.getAttribute("user_id") != null) { %>
        <a href="addTripForm.jsp">+</a>
    <% } else { %>
        <a href="#" onclick="checkLoginForAdd()">+</a>
    <% } %>
</div>

<script>
function checkLoginForAdd() {
    alert("일정 추가는 로그인이 필요한 서비스입니다.");
    location.href = "<%=request.getContextPath()%>/login.jsp";
    return false;
}
</script>

<script>
    function loadHTML() {
        fetch('header.jsp')
            .then(response => response.text())
            .then(data => {
                document.getElementById('header').innerHTML = data;
                document.getElementById('date').textContent = formattedDate;
            });
        fetch('navigation.jsp')
            .then(response => response.text())
            .then(data => {
                document.getElementById('navigation').innerHTML = data;
            });
        fetch('footer.jsp')
            .then(response => response.text())
            .then(data => {
                document.getElementById('footer').innerHTML = data;
            });
    }
    document.addEventListener('DOMContentLoaded', loadHTML);
</script>

<% 
    String jsonDataString = "null"; // 기본값 설정
    String userId = (String) session.getAttribute("user_id"); // user_id 세션에서 가져오기

    if (userId != null) {  // user_id가 존재할 경우

        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        StringBuilder jsonData = new StringBuilder();

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

            if (rs.next()) { // id가 존재하면

                jsonData.append("[");

                // 두 번째 쿼리: user_schedule 테이블에서 해당 user_id로 일정 조회
                String scheduleSql = "SELECT * FROM user_schedule WHERE user_id = ?";
                stmt = conn.prepareStatement(scheduleSql);
                stmt.setString(1, userId);  // user_id를 쿼리에 설정
                ResultSet scheduleRs = stmt.executeQuery();

                boolean hasData = false;  // hasData 변수 선언 위치 수정

                while (scheduleRs.next()) {
                    hasData = true;

                    // 각 일정마다 JSON 객체를 추가
                    jsonData.append("{");
                    jsonData.append("\"schedule_id\":\"").append(scheduleRs.getInt("schedule_id")).append("\",");
                    jsonData.append("\"start_date\":\"").append(scheduleRs.getDate("start_date")).append("\",");
                    jsonData.append("\"end_date\":\"").append(scheduleRs.getDate("end_date")).append("\",");
                    jsonData.append("\"title\":\"").append(scheduleRs.getString("title")).append("\"");
                    jsonData.append("},");

                }

                if (hasData) {
                    // 마지막 쉼표 제거
                    jsonData.deleteCharAt(jsonData.length() - 1);
                }

                jsonData.append("]");
                jsonDataString = jsonData.toString();
                scheduleRs.close(); // scheduleResultSet을 닫습니다.
            } 
            
            else { 
                jsonDataString = "null"; // user_id가 없으면 null
            }

        } catch (SQLException ex) {
            out.println(ex.getMessage());
            ex.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ex) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ex) {}
            if (conn != null) try { conn.close(); } catch (SQLException ex) {}
        }
    }
%>

<script>
    // 이스케이프된 JSON 데이터가 아닌 원본 JSON 문자열을 그대로 삽입
    const scheduleData = '<%= jsonDataString %>';
    console.log("Received schedule data from JSP: ", scheduleData);
    if (scheduleData) {
        try {
            window.scheduleData = JSON.parse(scheduleData); // JSON 파싱
        } catch (error) {
            console.error('JSON parsing error: ', error);
        }
    } else {
        console.log('No schedule data available.');
        window.scheduleData = null;
    }
</script>
<script src="scripts/calendar.js"></script>
<script src="scripts/header.js"></script>
</html>
