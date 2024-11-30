// === 전역 변수 선언 ===
let scheduleData = [];
let currentDate = null;
let startDate = null;
let endDate = null;
let schedulesByDate = {};

// === 이벤트 리스너 등록 ===
document.addEventListener('DOMContentLoaded', function() {
    // 날짜, 지역 정보 변경 감지
    document.querySelector('input[name="startDate"]').addEventListener('change', updateCalendarInfo);
    document.querySelector('input[name="country"]').addEventListener('input', updateCalendarInfo);
    document.querySelector('input[name="region"]').addEventListener('input', updateCalendarInfo);
    document.querySelector('input[name="expectedCost"]').addEventListener('input', updateExpectedCost);

    // 날짜 이동 버튼
    document.querySelector('.prev-date').addEventListener('click', () => moveDate(-1));
    document.querySelector('.next-date').addEventListener('click', () => moveDate(1));

    // 날짜 변경
    document.querySelector('input[name="startDate"]').addEventListener('change', handleStartDateChange);
    document.querySelector('input[name="endDate"]').addEventListener('change', handleEndDateChange);

    // 예상 지출 입력 필드의 이벤트 리스너
    const costInput = document.querySelector('input[name="expectedCost"]');
    costInput.addEventListener('input', function(e) {
        updateExpectedCost(e.target.value);
    });
});

// === 날짜 관련 함수 ===
function handleStartDateChange(e) {
    const newStartDate = new Date(e.target.value);
    const endDateInput = document.querySelector('input[name="endDate"]');
    
    if (endDateInput.value && new Date(endDateInput.value) < newStartDate) {
        alert('도착 날짜는 출발 날짜보다 빠를 수 없습니다.');
        e.target.value = startDate ? formatDate(startDate) : '';
        return;
    }
    
    endDateInput.min = e.target.value;
    startDate = newStartDate;
    currentDate = new Date(startDate);
    
    updateCalendarInfo();
    loadSchedulesForDate(formatDate(currentDate));
}

function handleEndDateChange(e) {
    const newEndDate = new Date(e.target.value);
    
    if (!startDate) {
        alert('출발 날짜를 먼저 선택해주세요.');
        e.target.value = '';
        return;
    }
    
    if (newEndDate < startDate) {
        alert('도착 날짜는 출발 날짜보다 빠를 수 없습니다.');
        e.target.value = endDate ? formatDate(endDate) : '';
        return;
    }
    
    endDate = newEndDate;
    updateCalendarInfo();
    loadSchedulesForDate(formatDate(currentDate));
}

function moveDate(direction) {
    if (!currentDate || !startDate || !endDate) return;
    const nextDate = new Date(currentDate);
    nextDate.setDate(nextDate.getDate() + direction);
    if (nextDate >= startDate && nextDate <= endDate) {
        currentDate = nextDate;
        updateCalendarInfo();
        loadSchedulesForDate(formatDate(currentDate));
    }
}

function formatDate(date) {
    if (!date) return '';
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// === UI 업데이트 함수 ===
function updateCalendarInfo() {
    const country = document.querySelector('input[name="country"]').value;
    const region = document.querySelector('input[name="region"]').value;
    
    if (currentDate) {
        document.getElementById('selectedDate').textContent = 
            `${currentDate.getFullYear()}년 ${currentDate.getMonth() + 1}월 ${currentDate.getDate()}일`;
    }
    
    if (country || region) {
        document.getElementById('selectedCountry').textContent = 
            [country, region].filter(Boolean).join(' ');
    }
}

// === 일정 관리 함수 ===
function loadSchedulesForDate(dateStr) {
    scheduleData = schedulesByDate[dateStr] || [];
    updateScheduleList();
}

function addSchedule() {
    if (!currentDate) return;
    const timeInput = document.getElementById('scheduleTime');
    const contentInput = document.getElementById('scheduleContent');
    
    if (timeInput.value && contentInput.value) {
        const dateStr = formatDate(currentDate);
        if (!schedulesByDate[dateStr]) schedulesByDate[dateStr] = [];
        
        schedulesByDate[dateStr].push({
            time: timeInput.value,
            content: contentInput.value
        });
        
        schedulesByDate[dateStr].sort((a, b) => a.time.localeCompare(b.time));
        timeInput.value = '';
        contentInput.value = '';
        loadSchedulesForDate(dateStr);
    }
}

function updateScheduleList() {
    const scheduleList = document.querySelector('.schedule-list');
    scheduleList.innerHTML = '';
    
    scheduleData.forEach((schedule, index) => {
        const scheduleItem = document.createElement('div');
        scheduleItem.className = 'schedule-item';
        scheduleItem.innerHTML = `
            <div class="time">${schedule.time}</div>
            <div class="content">${schedule.content}</div>
            <button type="button" class="delete-btn" onclick="deleteSchedule(${index})">×</button>
        `;
        scheduleList.appendChild(scheduleItem);
    });
}

function deleteSchedule(index) {
    const dateStr = formatDate(currentDate);
    if (confirm('이 일정을 삭제하시겠습니까?')) {
        schedulesByDate[dateStr].splice(index, 1);
        loadSchedulesForDate(dateStr);
    }
}

// === 비용 관리 함수 ===
function updateExpectedCost(value) {
    const displayElement = document.getElementById('displayedCost');
    const inputElement = document.querySelector('input[name="expectedCost"]');
    
    if (!value) {
        displayElement.textContent = '0';
        inputElement.value = '';
        return;
    }

    const numStr = value.toString().replace(/[^\d]/g, '');
    if (numStr) {
        inputElement.value = numStr;
        displayElement.textContent = Number(numStr).toLocaleString();
    }
}

// === 폼 제출 처리 ===
function submitTravelForm(event) {
    event.preventDefault();
    const form = document.getElementById('travelForm');
    
    const formData = new URLSearchParams();
    ['title', 'country', 'region', 'startDate', 'endDate'].forEach(field => {
        const value = form.querySelector(`input[name="${field}"]`).value;
        if (!value) {
            alert('모든 필수 항목을 입력해주세요.');
            throw new Error('필수 입력값 누락');
        }
        formData.append(field, value);
    });

    const expectedCost = form.querySelector('input[name="expectedCost"]').value || '0';
    formData.append('expectedCost', expectedCost.replace(/,/g, ''));
    formData.append('schedules', JSON.stringify(schedulesByDate));

    fetch('addTrip.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: formData.toString()
    })
    .then(response => response.text())
    .then(data => {
        if(data.includes('success')) {
            alert('여행 계획이 성공적으로 저장되었습니다.');
            window.location.href = 'calendar.jsp';
        } else if(data.includes('error')) {
            alert('저장 실패: ' + (data.split(': ')[1] || '알 수 없는 오류가 발생했습니다.'));
        } else {
            alert('여행 계획 저장에 실패했습니다.');
        }
    })
    .catch(error => alert('오류가 발생했습니다: ' + error.message));
}

