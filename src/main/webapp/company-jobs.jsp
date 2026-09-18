<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Job" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"company".equals(role)) { response.sendRedirect("login.jsp"); return; }
    List<Job> myJobs = (List<Job>) request.getAttribute("myJobs");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Jobs - Company Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <div class="brand"><h2><i class="fas fa-graduation-cap"></i> Placement</h2><p>Company Panel</p></div>
    <div class="nav-section">Main Menu</div>
    <a href="CompanyDashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="CompanyJobsServlet" class="nav-item active"><i class="fas fa-briefcase"></i> My Jobs</a>
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
        <div><h1>My Jobs 💼</h1><p>All jobs posted by your company.</p></div>
        <a href="CompanyJobPostServlet" class="btn-primary-grad">
            <i class="fas fa-plus"></i> Post New Job
        </a>
    </div>

    <% if (myJobs == null || myJobs.isEmpty()) { %>
        <div class="data-card animate-in">
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-briefcase" style="font-size: 60px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 20px;">No jobs posted yet</h3>
                <a href="CompanyJobPostServlet" class="btn-primary-grad" style="margin-top: 20px;">
                    <i class="fas fa-plus"></i> Post Your First Job
                </a>
            </div>
        </div>
    <% } else { %>
        <% for (Job j : myJobs) { %>
        <div class="job-card-modern animate-in">
            <h4><i class="fas fa-briefcase me-2" style="color:#667eea;"></i> <%= j.getTitle() %></h4>
            <div class="job-meta">
                <span><i class="fas fa-star"></i> Min CGPA: <strong><%= j.getMinCgpa() %></strong></span>
            </div>
            <div style="margin-bottom: 12px;">
                <div style="font-size: 12px; color: #8892b0; margin-bottom: 6px; font-weight: 600;">
                    <i class="fas fa-graduation-cap me-1"></i> ELIGIBLE BRANCHES
                </div>
                <% for (String b : j.getEligibleBranches()) { %>
                    <span class="badge badge-blue"><%= b.trim() %></span>
                <% } %>
            </div>
            <div>
                <div style="font-size: 12px; color: #8892b0; margin-bottom: 6px; font-weight: 600;">
                    <i class="fas fa-code me-1"></i> REQUIRED SKILLS
                </div>
                <% for (String s : j.getRequiredSkills()) { %>
                    <span class="badge badge-purple"><%= s.trim() %></span>
                <% } %>
            </div>
        </div>
        <% } %>
    <% } %>
</div>
</body>
</html>