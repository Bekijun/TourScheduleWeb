const daysTag = document.querySelector(".days"),
    yearDate = document.querySelector(".year-date"),
    monthDate = document.querySelector(".month-date"),
    lastYearButton = document.querySelector(".last_year"),
    nextYearButton = document.querySelector(".next_year"),
    lastMonthButton = document.querySelector(".last_month"),
    nextMonthButton = document.querySelector(".next_month"),
    weeksContainer = document.querySelector(".weeks");

let date = new Date(),
    currYear = date.getFullYear(),
    currMonth = date.getMonth();

const months = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"];
const weekdays = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];

window.onload = function () {
    const schedules = window.scheduleData;  // window.scheduleData가 정의되었는지 확인
    if (schedules && schedules.length > 0) {
        const firstScheduleId = schedules[0].trip_id;
    } else {
        console.error('scheduleData is not defined or empty');
    }
    // 초기 달력 렌더링
    createWeekdays();
    renderCalendar();
};

// 일정 범위를 색칠할 날짜 구하기
const getHighlightedDates = (schedules) => {
    if (!schedules || schedules.length === 0) {
        return [];
    }

    const highlightedDates = [];
    
    schedules.forEach(schedule => {
        const startDate = new Date(schedule.start_date);
        const endDate = new Date(schedule.end_date);

        let currentDate = new Date(startDate);

        // 일정의 시작일부터 종료일까지 날짜를 구하여 배열에 추가
        while (currentDate <= endDate) {
            const dateKey = getDateKey(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate());
            highlightedDates.push(dateKey);
            currentDate.setDate(currentDate.getDate() + 1);
        }
    });

    return highlightedDates;
};

// 날짜 관련 함수
const getDateKey = (year, month, day) => `${year}-${(month + 1).toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;

const createDayElement = (day, additionalClass = "", description = " ") => {
    return `
        <li class="${additionalClass}" data-date="${day}" data-description="${description}">
            ${day}
            ${additionalClass !== "inactive" ? `<div class="date-description style="margin-bottom: 15px;">${description}</div>` : ""}
        </li>`;
};

const renderCalendar = () => {
    const { firstDayofMonth, lastDateofMonth, lastDayofMonth, lastDateofLastMonth } = getMonthDetails();
    let liTag = "";

    // 일정을 색칠할 날짜 구하기
    const schedules = window.scheduleData;  // 전역 scheduleData를 사용
    const highlightedDates = getHighlightedDates(schedules);  // highlightedDates 계산

    // 이전 달 날짜
    for (let i = firstDayofMonth; i > 0; i--) {
        liTag += createDayElement(lastDateofLastMonth - i + 1, "inactive");
    }

    // 현재 달 날짜
    for (let i = 1; i <= lastDateofMonth; i++) {
        const isToday = i === date.getDate() && currMonth === new Date().getMonth() && currYear === new Date().getFullYear() ? "today" : "";
        const dateKey = getDateKey(currYear, currMonth, i);
        let description = "설명없음";  // 기본값 설정

        // 하이라이트된 날짜인 경우에만 제목 표시
        if (highlightedDates.includes(dateKey) && schedules && schedules.length > 0) {
            const scheduleForDate = schedules.find(schedule => {
                const startDate = new Date(schedule.start_date);
                startDate.setHours(0, 0, 0, 0);  // 시작일의 시간을 00:00:00으로 설정
                
                const endDate = new Date(schedule.end_date);
                endDate.setHours(23, 59, 59, 999);  // 종료일의 시간을 23:59:59로 설정
                
                const currentDate = new Date(currYear, currMonth, i);
                currentDate.setHours(12, 0, 0, 0);  // 현재 날짜의 시간을 정오로 설정
                
                return currentDate >= startDate && currentDate <= endDate;
            });
            
            if (scheduleForDate) {
                description = scheduleForDate.title;
            }
        }

        const isHighlighted = highlightedDates.includes(dateKey) ? "highlighted" : "";
        liTag += createDayElement(i, `${isToday} ${isHighlighted}`, description);
    }

    // 다음 달 날짜
    for (let i = lastDayofMonth; i < 6; i++) {
        liTag += createDayElement(i - lastDayofMonth + 1, "inactive");
    }

    // 헤더 업데이트
    yearDate.innerText = `${currYear}`;
    monthDate.innerText = `${months[currMonth]}`;

    // 달력 날짜 업데이트
    daysTag.innerHTML = liTag;

    // 날짜 선택 이벤트 추가
    attachDayEvents();
};


// 달력의 월과 일 관련 정보 구하기
const getMonthDetails = () => {
    const firstDayofMonth = new Date(currYear, currMonth, 1).getDay();
    const lastDateofMonth = new Date(currYear, currMonth + 1, 0).getDate();
    const lastDayofMonth = new Date(currYear, currMonth, lastDateofMonth).getDay();
    const lastDateofLastMonth = new Date(currYear, currMonth, 0).getDate();

    return { firstDayofMonth, lastDateofMonth, lastDayofMonth, lastDateofLastMonth };
};

// 요일 헤더 생성
const createWeekdays = () => {
    weekdays.forEach(day => {
        const li = document.createElement("li");
        li.textContent = day;
        weeksContainer.appendChild(li);
    });
};

// 날짜 선택 이벤트 연결
const attachDayEvents = () => {
    const dayItems = daysTag.querySelectorAll("li");
    let isMouseDown = false;
    let dragStartDate = null;

    const clearSelection = () => {
        dayItems.forEach(day => day.classList.remove("selected"));
    };

    dayItems.forEach(day => {
        day.addEventListener("mousedown", (e) => {
            if (e.target.classList.contains("inactive")) return;
            isMouseDown = true;
            clearSelection();
            e.target.classList.add("selected");
            dragStartDate = parseInt(e.target.getAttribute("data-date"));
        });

        day.addEventListener("mouseup", () => {
            if (isMouseDown) {
                isMouseDown = false;
                const selectedDate = dragStartDate;

                const dateKey = getDateKey(currYear, currMonth, selectedDate);
                //console.log(`${dateKey}`);

                //sendDateToServer(dateKey);
                window.location.replace(`http://223.130.130.104:8080/checkTrip.jsp?dateKey=${dateKey}`);
            }
        });
    });

    document.addEventListener("mouseup", () => {
        isMouseDown = false;
    });
};

// 이전/다음 연도 및 월 이동
const changeYear = (offset) => {
    currYear += offset;
    date = new Date(currYear, currMonth, date.getDate());
    renderCalendar();
};

const changeMonth = (offset) => {
    currMonth += offset;
    if (currMonth < 0) {
        currMonth = 11;
        currYear -= 1;
    } else if (currMonth > 11) {
        currMonth = 0;
        currYear += 1;
    }
    date = new Date(currYear, currMonth, date.getDate());
    renderCalendar();
};

lastYearButton.addEventListener("click", () => changeYear(-1));
nextYearButton.addEventListener("click", () => changeYear(1));
lastMonthButton.addEventListener("click", () => changeMonth(-1));
nextMonthButton.addEventListener("click", () => changeMonth(1));
