<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"company".equals(role)) { response.sendRedirect("login.jsp"); return; }
    int jobCount = (Integer) request.getAttribute("jobCount");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Dashboard - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <div class="brand"><h2><i class="fas fa-graduation-cap"></i> Placement</h2><p>Company Panel</p></div>
    <div class="nav-section">Main Menu</div>
    <a href="CompanyDashboardServlet" class="nav-item active"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="CompanyJobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> My Jobs</a>
    <a href="CompanyJobPostServlet" class="nav-item"><i class="fas fa-plus-circle"></i> Post Job</a>
    <div class="nav-section">Account</div>
    <a href="LogoutServlet" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <div class="spacer"></div>
    <div class="user-info">
        <div class="name"><i class="fas fa-building"></i> <%= session.getAttribute("companyName") %></div>
        <div class="role">Company Account</div>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <div>
            <h1>Welcome, <%= session.getAttribute("companyName") %>! 🏢</h1>
            <p>Manage your job postings and applications.</p>
        </div>
    </div>

    <div class="stats-grid animate-in">
        <div class="stat-card">
            <div class="stat-icon purple"><i class="fas fa-briefcase"></i></div>
            <h3><%= jobCount %></h3>
            <p>Active Jobs</p>
        </div>
    </div>

    <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 20px; color: #1a1a2e;">
        <i class="fas fa-bolt me-2" style="color: #667eea;"></i> Quick Actions
    </h3>

    <div class="menu-grid animate-in">
        <a href="CompanyJobPostServlet" class="menu-card">
            <i class="fas fa-arrow-right arrow"></i>
            <div class="card-icon"><i class="fas fa-plus-circle"></i></div>
            <h4>Post New Job</h4>
            <p>Create a new job opening with eligibility criteria.</p>
        </a>
        <a href="CompanyJobsServlet" class="menu-card">
            <i class="fas fa-arrow-right arrow"></i>
            <div class="card-icon" style="background: linear-gradient(135deg, #f093fb, #f5576c);">
                <i class="fas fa-briefcase"></i>
            </div>
            <h4>My Jobs</h4>
            <p>View and manage all your posted jobs.</p>
        </a>
    </div>
</div>
</body>
</html>