document.addEventListener('DOMContentLoaded', function() {
    loadTripData();
});

async function loadTripData() {
    try {
        const response = await fetch(`viewTrip.jsp?id=${scheduleId}`);
        const text = await response.text();
        console.log('서버 응답:', text);
        
        const data = JSON.parse(text);
        
        if (data.error) {
            alert('데이터를 불러오는데 실패했습니다: ' + data.error);
            return;
        }

        document.getElementById('tripTitle').textContent = data.title;
        document.getElementById('tripCountry').textContent = data.country;
        document.getElementById('tripRegion').textContent = data.region;
        document.getElementById('tripDate').textContent = 
            `${formatDate(data.start_date)} - ${formatDate(data.end_date)}`;
        document.getElementById('displayedCost').textContent = 
            Number(data.cost).toLocaleString();

        updateScheduleDisplay(data.schedules);
    } catch (error) {
        console.error('Error:', error);
        console.error('Response:', text);
        alert('데이터를 불러오는데 실패했습니다. 상세 오류: ' + error.message);
    }
}

function formatDate(dateStr) {
    const date = new Date(dateStr);
    return date.toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
}

function updateScheduleDisplay(schedules) {
    const scheduleList = document.getElementById('scheduleList');
    scheduleList.innerHTML = '';

    if (!schedules || Object.keys(schedules).length === 0) {
        scheduleList.innerHTML = '<p>등록된 일정이 없습니다.</p>';
        return;
    }

    Object.entries(schedules).forEach(([date, items]) => {
        const scheduleItems = items.map(item => `
            <div class="schedule-item">
                <span class="time">${item.time}</span>
                <span class="content">${item.content}</span>
            </div>
        `).join('');

        scheduleList.innerHTML += `
            <div class="date-group">
                <h4>${formatDate(date)}</h4>
                ${scheduleItems}
            </div>
        `;
    });
}

document.getElementById('deleteTrip').addEventListener('click', async function() {
    const confirmed = confirm('이 일정을 삭제하시겠습니까?\n삭제된 일정은 복구할 수 없습니다.');
    
    if (confirmed) {
        try {
            const response = await fetch('deleteTrip.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `id=${scheduleId}`
            });
            
            const data = await response.json();
            
            if (data.success) {
                alert('일정이 성공적으로 삭제되었습니다.');
                window.location.href = 'calendar.jsp';
            } else {
                alert(data.error || '일정 삭제에 실패했습니다.');
            }
        } catch (error) {
            console.error('Error:', error);
            alert('오류가 발생했습니다: ' + error.message);
        }
    }
}); 