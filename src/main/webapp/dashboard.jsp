<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (request.getAttribute("studentCount") == null) {
        response.sendRedirect("DashboardServlet");
        return;
    }

    int studentCount = (Integer) request.getAttribute("studentCount");
    int companyCount = (Integer) request.getAttribute("companyCount");
    int jobCount = (Integer) request.getAttribute("jobCount");
    int appCount = (Integer) request.getAttribute("appCount");
    Map<String, Integer> branchCount = (Map<String, Integer>) request.getAttribute("branchCount");
    Map<String, Integer> statusCount = (Map<String, Integer>) request.getAttribute("statusCount");
    int[] cgpaBuckets = (int[]) request.getAttribute("cgpaBuckets");

    StringBuilder branchLabels = new StringBuilder();
    StringBuilder branchData = new StringBuilder();
    for (Map.Entry<String, Integer> e : branchCount.entrySet()) {
        branchLabels.append("'").append(e.getKey()).append("',");
        branchData.append(e.getValue()).append(",");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .chart-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
        }
        .chart-card h4 {
            font-size: 16px;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 20px;
        }
        .chart-card h4 i { color: #667eea; margin-right: 8px; }
        .chart-wrapper {
            position: relative;
            height: 280px;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand">
        <h2><i class="fas fa-graduation-cap"></i> Placement</h2>
        <p>Management System</p>
    </div>
    <div class="nav-section">Main Menu</div>
    <a href="DashboardServlet" class="nav-item active"><i class="fas fa-th-large"></i> Dashboard</a>
    <% if ("admin".equals(role)) { %>
        <a href="StudentsServlet" class="nav-item"><i class="fas fa-users"></i> Students</a>
        <a href="CompaniesServlet" class="nav-item"><i class="fas fa-building"></i> Companies</a>
        <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
        <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
        <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a>
        <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
    <% } else { %>
        <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Browse Jobs</a>
        <a href="MyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> My Applications</a>
        <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
        <a href="NotificationsServlet" class="nav-item"><i class="fas fa-bell"></i> Notifications</a>
        <a href="ProfileServlet" class="nav-item"><i class="fas fa-user"></i> My Profile</a>
    <% } %>
    <div class="nav-section">Account</div>
    <a href="LogoutServlet" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <div class="spacer"></div>
    <div class="user-info">
        <div class="name">
            <% if ("admin".equals(role)) { %>
                <i class="fas fa-user-shield"></i> Administrator
            <% } else { %>
                <i class="fas fa-user-graduate"></i> <%= session.getAttribute("studentName") %>
            <% } %>
        </div>
        <div class="role">
            <% if ("admin".equals(role)) { %>Admin Account<% } else { %>Student Account<% } %>
        </div>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <div>
            <h1>
                <% if ("admin".equals(role)) { %>
                    Admin Dashboard 👨‍💼
                <% } else { %>
                    Welcome back, <%= session.getAttribute("studentName") %>! 🎓
                <% } %>
            </h1>
            <p>Here's what's happening in your placement portal today.</p>
        </div>
    </div>

    <div class="stats-grid animate-in">
        <div class="stat-card">
            <div class="stat-icon purple"><i class="fas fa-users"></i></div>
            <h3><%= studentCount %></h3>
            <p>Total Students</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon pink"><i class="fas fa-building"></i></div>
            <h3><%= companyCount %></h3>
            <p>Partner Companies</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon blue"><i class="fas fa-briefcase"></i></div>
            <h3><%= jobCount %></h3>
            <p>Active Jobs</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon green"><i class="fas fa-file-alt"></i></div>
            <h3><%= appCount %></h3>
            <p>Applications</p>
        </div>
    </div>

    <% if ("admin".equals(role)) { %>
    <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 20px; color: #1a1a2e;">
        <i class="fas fa-chart-bar me-2" style="color: #667eea;"></i> Analytics Overview
    </h3>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
        <div class="chart-card animate-in">
            <h4><i class="fas fa-graduation-cap"></i> Students by Branch</h4>
            <div class="chart-wrapper">
                <canvas id="branchChart"></canvas>
            </div>
        </div>
        <div class="chart-card animate-in">
            <h4><i class="fas fa-chart-pie"></i> Application Status</h4>
            <div class="chart-wrapper">
                <canvas id="statusChart"></canvas>
            </div>
        </div>
    </div>

    <div class="chart-card animate-in" style="margin-bottom: 30px;">
        <h4><i class="fas fa-chart-line"></i> CGPA Distribution</h4>
        <div class="chart-wrapper">
            <canvas id="cgpaChart"></canvas>
        </div>
    </div>
    <% } %>

    <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 20px; color: #1a1a2e;">
        <i class="fas fa-bolt me-2" style="color: #667eea;"></i> Quick Actions
    </h3>

    <div class="menu-grid animate-in">
        <% if ("admin".equals(role)) { %>
            <a href="StudentsServlet" class="menu-card">
                <i class="fas fa-arrow-right arrow"></i>
                <div class="card-icon"><i class="fas fa-users"></i></div>
                <h4>Manage Students</h4>
                <p>View, add and manage all registered students in the system.</p>
            </a>
            <a href="CompaniesServlet" class="menu-card">
                <i class="fas fa-arrow-right arrow"></i>
                <div class="card-icon" style="background: linear-gradient(135deg, #f093fb, #f5576c);">
                    <i class="fas fa-building"></i>
                </div>
                <h4>Manage Companies</h4>
                <p>Add new companies and manage existing partner organizations.</p>
            </a>
            <a href="JobsServlet" class="menu-card">
                <i class="fas fa-arrow-right arrow"></i>
                <div class="card-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe);">
                    <i class="fas fa-briefcase"></i>
                </div>
                <h4>Manage Jobs</h4>
                <p>Create job postings with eligibility criteria and requirements.</p>
            </a>
            <a href="ShortlistServlet" class="menu-card">
                <i class="fas fa-arrow-right arrow"></i>
                <div class="card-icon" style="background: linear-gradient(135deg, #43e97b, #38f9d7);">
                    <i class="fas fa-trophy"></i>
                </div>
                <h4>View Shortlist</h4>
                <p>See auto-shortlisted students based on job criteria.</p>
            </a>
        <% } else { %>
            <a href="JobsServlet" class="menu-card">
                <i class="fas fa-arrow-right arrow"></i>
                <div class="card-icon"><i class="fas fa-briefcase"></i></div>
                <h4>Browse Jobs</h4>
                <p>Explore all available job opportunities from top companies.</p>
            </a>
            <a href="MyApplicationsServlet" class="menu-card">
                <i class="fas fa-arrow-right arrow"></i>
                <div class="card-icon" style="background: linear-gradient(135deg, #f093fb, #f5576c);">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h4>My Applications</h4>
                <p>Track the status of all your job applications.</p>
            </a>
            <a href="ProfileServlet" class="menu-card">
                <i class="fas fa-arrow-right arrow"></i>
                <div class="card-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe);">
                    <i class="fas fa-user"></i>
                </div>
                <h4>My Profile</h4>
                <p>Update your personal information and skills.</p>
            </a>
        <% } %>
    </div>
</div>

<% if ("admin".equals(role)) { %>
<script>
    new Chart(document.getElementById('branchChart'), {
        type: 'bar',
        data: {
            labels: [<%= branchLabels.toString() %>],
            datasets: [{
                label: 'Students',
                data: [<%= branchData.toString() %>],
                backgroundColor: ['#667eea','#f093fb','#4facfe','#43e97b','#f5576c','#f6c23e'],
                borderRadius: 8,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
        }
    });

    new Chart(document.getElementById('statusChart'), {
        type: 'doughnut',
        data: {
            labels: ['Pending','Shortlisted','Selected','Rejected'],
            datasets: [{
                data: [
                    <%= statusCount.get("PENDING") %>,
                    <%= statusCount.get("SHORTLISTED") %>,
                    <%= statusCount.get("SELECTED") %>,
                    <%= statusCount.get("REJECTED") %>
                ],
                backgroundColor: ['#f6c23e','#43e97b','#4facfe','#f5576c'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } }
        }
    });

    new Chart(document.getElementById('cgpaChart'), {
        type: 'line',
        data: {
            labels: ['<6','6-7','7-8','8-9','9-10'],
            datasets: [{
                label: 'Number of Students',
                data: [<%= cgpaBuckets[0] %>,<%= cgpaBuckets[1] %>,<%= cgpaBuckets[2] %>,<%= cgpaBuckets[3] %>,<%= cgpaBuckets[4] %>],
                borderColor: '#667eea',
                backgroundColor: 'rgba(102,126,234,0.1)',
                fill: true,
                tension: 0.4,
                pointBackgroundColor: '#667eea',
                pointRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
        }
    });
</script>
<% } %>

</body>
</html>