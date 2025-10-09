// Dashboard JavaScript

// Global variables
let charts = {};
let currentPeriod = 'day';

// Initialize dashboard on page load
document.addEventListener('DOMContentLoaded', function() {
    initializeDashboard();
    initializeCharts();
    populateTables();
    setupEventListeners();
    enforceCanvasHeight();
});

// Initialize dashboard
function initializeDashboard() {
    console.log('Dashboard initialized');
    updateDateTime();
    setInterval(updateDateTime, 60000); // Update every minute
}

// Update date and time
function updateDateTime() {
    const now = new Date();
    const options = { 
        weekday: 'long', 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    };
    // This could be displayed in a header element if needed
}

// Initialize all charts
function initializeCharts() {
    // Get CSS variables for colors
    const styles = getComputedStyle(document.documentElement);
    const primaryColor = '#25935f';
    const infoColor = '#2e90fa';
    const successColor = '#17b26a';
    const warningColor = '#f79009';
    const dangerColor = '#f70647';
    const grayColor = '#6c737f';
    
    // Chart.js default configuration
    Chart.defaults.font.family = 'IBM Plex Sans Arabic, sans-serif';
    Chart.defaults.color = grayColor;
    
    // Users Chart
    if (document.getElementById('usersChart')) {
        charts.usersChart = new Chart(document.getElementById('usersChart'), {
            type: 'line',
            data: {
                labels: ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'],
                datasets: [{
                    label: 'مستخدمون نشطون',
                    data: [120, 150, 180, 160, 190, 210, 156],
                    borderColor: primaryColor,
                    backgroundColor: primaryColor + '20',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
    
    // Chats Distribution Chart
    if (document.getElementById('chatsChart')) {
        charts.chatsChart = new Chart(document.getElementById('chatsChart'), {
            type: 'doughnut',
            data: {
                labels: ['الشؤون الأكاديمية', 'البرمجة', 'الرياضيات', 'العلوم', 'أخرى'],
                datasets: [{
                    data: [35, 25, 20, 12, 8],
                    backgroundColor: [
                        primaryColor,
                        infoColor,
                        successColor,
                        warningColor,
                        grayColor
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }
    
    // Activity Chart
    if (document.getElementById('activityChart')) {
        charts.activityChart = new Chart(document.getElementById('activityChart'), {
            type: 'bar',
            data: {
                labels: ['يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'],
                datasets: [{
                    label: 'محادثات',
                    data: [450, 520, 580, 610, 690, 720, 780, 850, 820, 890, 920, 850],
                    backgroundColor: primaryColor,
                    borderRadius: 6
                }, {
                    label: 'مستخدمون جدد',
                    data: [65, 75, 85, 95, 105, 115, 125, 135, 130, 145, 150, 142],
                    backgroundColor: infoColor,
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
    
    // Users Growth Chart
    if (document.getElementById('usersGrowthChart')) {
        charts.usersGrowthChart = new Chart(document.getElementById('usersGrowthChart'), {
            type: 'line',
            data: {
                labels: ['يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'],
                datasets: [{
                    label: 'إجمالي المستخدمين',
                    data: [100, 165, 250, 345, 450, 565, 690, 825, 955, 1100, 1250, 1247],
                    borderColor: successColor,
                    backgroundColor: successColor + '20',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
    
    // Satisfaction Chart
    if (document.getElementById('satisfactionChart')) {
        charts.satisfactionChart = new Chart(document.getElementById('satisfactionChart'), {
            type: 'pie',
            data: {
                labels: ['راضٍ جداً', 'راضٍ', 'محايد', 'غير راضٍ'],
                datasets: [{
                    data: [62, 25, 8, 5],
                    backgroundColor: [
                        successColor,
                        primaryColor,
                        warningColor,
                        dangerColor
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }
    
    // Satisfaction Trend Chart
    if (document.getElementById('satisfactionTrendChart')) {
        charts.satisfactionTrendChart = new Chart(document.getElementById('satisfactionTrendChart'), {
            type: 'line',
            data: {
                labels: ['يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو'],
                datasets: [{
                    label: 'معدل الرضا %',
                    data: [78, 80, 82, 84, 85, 87],
                    borderColor: successColor,
                    backgroundColor: successColor + '20',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: false,
                        min: 70,
                        max: 100,
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
    
    // Topics Chart
    if (document.getElementById('topicsChart')) {
        charts.topicsChart = new Chart(document.getElementById('topicsChart'), {
            type: 'bar',
            data: {
                labels: [
                    'الشؤون الأكاديمية',
                    'البرمجة',
                    'الرياضيات',
                    'هياكل البيانات',
                    'الخوارزميات',
                    'قواعد البيانات',
                    'الفيزياء',
                    'الكيمياء'
                ],
                datasets: [{
                    label: 'عدد الطلبات',
                    data: [2856, 2145, 1687, 1423, 1189, 987, 756, 534],
                    backgroundColor: primaryColor,
                    borderRadius: 6
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    y: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
    
    // Topics Distribution Chart
    if (document.getElementById('topicsDistributionChart')) {
        charts.topicsDistributionChart = new Chart(document.getElementById('topicsDistributionChart'), {
            type: 'doughnut',
            data: {
                labels: ['الشؤون الأكاديمية', 'البرمجة', 'الرياضيات', 'العلوم', 'أخرى'],
                datasets: [{
                    data: [28, 21, 17, 14, 20],
                    backgroundColor: [
                        primaryColor,
                        infoColor,
                        successColor,
                        warningColor,
                        grayColor
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }
    
    // Topics Trend Chart
    if (document.getElementById('topicsTrendChart')) {
        charts.topicsTrendChart = new Chart(document.getElementById('topicsTrendChart'), {
            type: 'line',
            data: {
                labels: ['يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو'],
                datasets: [{
                    label: 'الشؤون الأكاديمية',
                    data: [320, 380, 420, 460, 510, 550],
                    borderColor: primaryColor,
                    tension: 0.4
                }, {
                    label: 'البرمجة',
                    data: [250, 290, 310, 340, 370, 390],
                    borderColor: infoColor,
                    tension: 0.4
                }, {
                    label: 'الرياضيات',
                    data: [180, 210, 240, 260, 280, 300],
                    borderColor: successColor,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
    
    // Usage by Hour Chart
    if (document.getElementById('usageByHourChart')) {
        charts.usageByHourChart = new Chart(document.getElementById('usageByHourChart'), {
            type: 'line',
            data: {
                labels: ['12ص', '1ص', '2ص', '3ص', '4ص', '5ص', '6ص', '7ص', '8ص', '9ص', '10ص', '11ص', 
                         '12م', '1م', '2م', '3م', '4م', '5م', '6م', '7م', '8م', '9م', '10م', '11م'],
                datasets: [{
                    label: 'عدد المستخدمين',
                    data: [12, 8, 5, 3, 4, 6, 15, 35, 78, 125, 142, 156, 
                           165, 178, 189, 198, 185, 172, 145, 98, 67, 45, 28, 18],
                    borderColor: infoColor,
                    backgroundColor: infoColor + '20',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
    
    // Devices Chart
    if (document.getElementById('devicesChart')) {
        charts.devicesChart = new Chart(document.getElementById('devicesChart'), {
            type: 'pie',
            data: {
                labels: ['الهاتف المحمول', 'الحاسوب', 'اللوحي'],
                datasets: [{
                    data: [58, 32, 10],
                    backgroundColor: [
                        primaryColor,
                        infoColor,
                        successColor
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }
    
    // Retention Chart
    if (document.getElementById('retentionChart')) {
        charts.retentionChart = new Chart(document.getElementById('retentionChart'), {
            type: 'line',
            data: {
                labels: ['الأسبوع 1', 'الأسبوع 2', 'الأسبوع 3', 'الأسبوع 4', 'الأسبوع 5', 'الأسبوع 6'],
                datasets: [{
                    label: 'معدل الاحتفاظ %',
                    data: [100, 85, 78, 72, 68, 65],
                    borderColor: successColor,
                    backgroundColor: successColor + '20',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }
}

// Enforce taller height for selected canvases
function enforceCanvasHeight() {
    const targetCanvases = document.querySelectorAll('canvas.tall');
    const desired = window.matchMedia('(max-width: 768px)').matches ? 360 : 520;
    targetCanvases.forEach((canvas) => {
        // Force explicit height so Chart.js respects it
        canvas.style.height = desired + 'px';
        canvas.height = desired;
    });
}

// Populate tables with data
function populateTables() {
    // Users table
    const usersTableBody = document.getElementById('usersTableBody');
    if (usersTableBody) {
        const usersData = [
            { name: 'أحمد محمد', email: 'ahmed@example.com', date: '2024-01-15', chats: 12, status: 'نشط' },
            { name: 'فاطمة علي', email: 'fatima@example.com', date: '2024-01-14', chats: 8, status: 'نشط' },
            { name: 'محمد خالد', email: 'mohammed@example.com', date: '2024-01-13', chats: 15, status: 'نشط' },
            { name: 'سارة أحمد', email: 'sarah@example.com', date: '2024-01-12', chats: 6, status: 'غير نشط' },
            { name: 'عبدالله سعد', email: 'abdullah@example.com', date: '2024-01-11', chats: 10, status: 'نشط' }
        ];
        
        usersTableBody.innerHTML = usersData.map(user => `
            <tr>
                <td>${user.name}</td>
                <td>${user.email}</td>
                <td>${user.date}</td>
                <td>${user.chats}</td>
                <td><span class="status-badge ${user.status === 'نشط' ? 'active' : 'inactive'}">${user.status}</span></td>
            </tr>
        `).join('');
    }
    
    // Feedback table
    const feedbackTableBody = document.getElementById('feedbackTableBody');
    if (feedbackTableBody) {
        const feedbackData = [
            { user: 'أحمد محمد', rating: 5, comment: 'خدمة ممتازة وسريعة', date: '2024-01-15 14:30' },
            { user: 'فاطمة علي', rating: 4, comment: 'جيدة بشكل عام', date: '2024-01-15 13:20' },
            { user: 'محمد خالد', rating: 5, comment: 'مفيد جداً في الدراسة', date: '2024-01-15 12:15' },
            { user: 'سارة أحمد', rating: 3, comment: 'يحتاج بعض التحسين', date: '2024-01-15 11:45' },
            { user: 'عبدالله سعد', rating: 5, comment: 'رائع! أنصح به بشدة', date: '2024-01-15 10:30' }
        ];
        
        feedbackTableBody.innerHTML = feedbackData.map(feedback => `
            <tr>
                <td>${feedback.user}</td>
                <td>
                    <div class="rating-stars">
                        ${'<i class="fas fa-star"></i>'.repeat(feedback.rating)}
                        ${'<i class="far fa-star"></i>'.repeat(5 - feedback.rating)}
                    </div>
                </td>
                <td>${feedback.comment}</td>
                <td>${feedback.date}</td>
            </tr>
        `).join('');
    }
    
    // Topics table
    const topicsTableBody = document.getElementById('topicsTableBody');
    if (topicsTableBody) {
        const topicsData = [
            { rank: 1, topic: 'الشؤون الأكاديمية', requests: 2856, satisfaction: 89, trend: 'up' },
            { rank: 2, topic: 'البرمجة', requests: 2145, satisfaction: 92, trend: 'up' },
            { rank: 3, topic: 'الرياضيات', requests: 1687, satisfaction: 85, trend: 'stable' },
            { rank: 4, topic: 'هياكل البيانات', requests: 1423, satisfaction: 88, trend: 'up' },
            { rank: 5, topic: 'الخوارزميات', requests: 1189, satisfaction: 86, trend: 'down' },
            { rank: 6, topic: 'قواعد البيانات', requests: 987, satisfaction: 84, trend: 'stable' },
            { rank: 7, topic: 'الفيزياء', requests: 756, satisfaction: 81, trend: 'up' },
            { rank: 8, topic: 'الكيمياء', requests: 534, satisfaction: 83, trend: 'stable' }
        ];
        
        topicsTableBody.innerHTML = topicsData.map(topic => `
            <tr>
                <td><strong>${topic.rank}</strong></td>
                <td>${topic.topic}</td>
                <td>${topic.requests.toLocaleString()}</td>
                <td>${topic.satisfaction}%</td>
                <td>
                    <i class="fas fa-arrow-${topic.trend === 'up' ? 'up' : topic.trend === 'down' ? 'down' : 'right'} trend-icon ${topic.trend}"></i>
                </td>
            </tr>
        `).join('');
    }
}

// Setup event listeners
function setupEventListeners() {
    // Sidebar resizer
    const sidebar = document.getElementById('sidebar');
    const sidebarResizer = document.getElementById('sidebarResizer');
    
    if (sidebarResizer) {
        let isResizing = false;
        
        sidebarResizer.addEventListener('mousedown', (e) => {
            isResizing = true;
            document.body.style.cursor = 'col-resize';
        });
        
        document.addEventListener('mousemove', (e) => {
            if (!isResizing) return;
            
            const newWidth = window.innerWidth - e.clientX;
            if (newWidth >= 280 && newWidth <= 500) {
                sidebar.style.width = newWidth + 'px';
                document.querySelector('.dashboard-main').style.marginRight = newWidth + 'px';
            }
        });
        
        document.addEventListener('mouseup', () => {
            isResizing = false;
            document.body.style.cursor = 'default';
        });
    }
}

// Show section
function showSection(sectionName, event) {
    if (event) {
        event.preventDefault();
    }
    
    // Hide all sections
    document.querySelectorAll('.dashboard-section').forEach(section => {
        section.classList.remove('active');
    });
    
    // Show selected section
    const section = document.getElementById('section-' + sectionName);
    if (section) {
        section.classList.add('active');
    }
    
    // Update menu items
    document.querySelectorAll('.menu-item').forEach(item => {
        item.classList.remove('active');
    });
    event.currentTarget.classList.add('active');
    
    // Update title
    const titles = {
        'overview': 'نظرة عامة',
        'users': 'المستخدمون',
        'satisfaction': 'رضا المستخدمين',
        'topics': 'الموضوعات الأكثر طلباً',
        'analytics': 'التحليلات',
        'reports': 'التقارير'
    };
    
    document.getElementById('dashboardTitle').textContent = titles[sectionName] || 'لوحة التحكم';
}

// Change period
function changePeriod(period, button) {
    currentPeriod = period;
    
    // Update active button
    document.querySelectorAll('.btn-group .btn').forEach(btn => {
        btn.classList.remove('active');
    });
    button.classList.add('active');
    
    // Update data based on period
    updateChartData(period);
}

// Update chart data based on period
function updateChartData(period) {
    // This would typically fetch new data from an API
    console.log('Updating charts for period:', period);
    
    // Example: Update stats
    if (period === 'day') {
        document.getElementById('totalUsers').textContent = '1,247';
        document.getElementById('totalChats').textContent = '8,456';
    } else if (period === 'week') {
        document.getElementById('totalUsers').textContent = '1,180';
        document.getElementById('totalChats').textContent = '7,892';
    } else if (period === 'month') {
        document.getElementById('totalUsers').textContent = '1,050';
        document.getElementById('totalChats').textContent = '6,234';
    }
}

// Toggle chart type
function toggleChartType(chartId) {
    const chart = charts[chartId];
    if (!chart) return;
    
    const currentType = chart.config.type;
    let newType;
    
    if (currentType === 'line') {
        newType = 'bar';
    } else if (currentType === 'bar') {
        newType = 'line';
    } else if (currentType === 'doughnut') {
        newType = 'pie';
    } else if (currentType === 'pie') {
        newType = 'doughnut';
    }
    
    if (newType) {
        chart.config.type = newType;
        chart.update();
    }
}

// Refresh dashboard
function refreshDashboard() {
    console.log('Refreshing dashboard...');
    
    // Show loading state
    const btn = event.currentTarget;
    const icon = btn.querySelector('i');
    icon.classList.add('fa-spin');
    
    // Simulate API call
    setTimeout(() => {
        // Update all charts
        Object.values(charts).forEach(chart => {
            chart.update();
        });
        
        // Update tables
        populateTables();
        
        icon.classList.remove('fa-spin');
        
        // Show success message
        showNotification('تم تحديث البيانات بنجاح', 'success');
    }, 1000);
}

// Export report
function exportReport() {
    console.log('Exporting report...');
    showNotification('جاري تصدير التقرير...', 'info');
    
    // Simulate export
    setTimeout(() => {
        showNotification('تم تصدير التقرير بنجاح', 'success');
    }, 1500);
}

// Download report
function downloadReport(reportType) {
    console.log('Downloading report:', reportType);
    showNotification('جاري تحميل التقرير...', 'info');
    
    // Simulate download
    setTimeout(() => {
        showNotification('تم تحميل التقرير بنجاح', 'success');
    }, 1500);
}

// Generate custom report
function generateCustomReport() {
    console.log('Generating custom report...');
    showNotification('جاري إنشاء التقرير المخصص...', 'info');
    
    // Simulate generation
    setTimeout(() => {
        showNotification('تم إنشاء التقرير بنجاح', 'success');
    }, 2000);
}

// Toggle sidebar
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    sidebar.classList.toggle('collapsed');
}

// Logout function
function logout() {
    if (confirm('هل أنت متأكد من تسجيل الخروج؟')) {
        window.location.href = 'login.html';
    }
}

// Show notification
function showNotification(message, type = 'info') {
    // This could use a notification library or custom implementation
    console.log(`[${type.toUpperCase()}] ${message}`);
    
    // Simple alert for now
    // In production, use a proper notification system
}

