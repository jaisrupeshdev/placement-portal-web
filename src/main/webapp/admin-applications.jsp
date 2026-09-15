<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Application" %>
<%@ page import="com.placement.model.Student" %>
<%@ page import="com.placement.model.Job" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Application> applications = (List<Application>) request.getAttribute("applicationsList");
    List<Student> students = (List<Student>) request.getAttribute("studentsList");
    List<Job> jobs = (List<Job>) request.getAttribute("jobsList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Applications - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .status-badge {
            padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
            display: inline-block;
        }
        .status-PENDING { background: #fff8e1; color: #b7791f; }
        .status-SHORTLISTED { background: #d4f4dd; color: #1d7a3a; }
        .status-REJECTED { background: #fde2e4; color: #b23a48; }
        .status-SELECTED { background: #d4ecff; color: #1a5fa8; }

        .status-select {
            padding: 6px 12px; border-radius: 8px; border: 1.5px solid #e1e5ee;
            font-size: 13px; font-weight: 600; cursor: pointer;
        }
        .btn-update {
            padding: 6px 14px; background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; border: none; border-radius: 8px; font-size: 13px;
            font-weight: 600; cursor: pointer; transition: 0.3s;
        }
        .btn-update:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(102,126,234,0.3); }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand">
        <h2><i class="fas fa-graduation-cap"></i> Placement</h2>
        <p>Management System</p>
    </div>
    <div class="nav-section">Main Menu</div>
    <a href="DashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="StudentsServlet" class="nav-item"><i class="fas fa-users"></i> Students</a>
    <a href="CompaniesServlet" class="nav-item"><i class="fas fa-building"></i> Companies</a>
    <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
    <a href="AdminApplicationsServlet" class="nav-item active"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a>
    <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
    <div class="nav-section">Account</div>
    <a href="LogoutServlet" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <div class="spacer"></div>
    <div class="user-info">
        <div class="name"><i class="fas fa-user-shield"></i> Administrator</div>
        <div class="role">Admin Account</div>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <div>
            <h1>Applications Management 📄</h1>
            <p>Review and update application statuses.</p>
        </div>
    </div>

    <div class="data-card animate-in">
        <div class="data-card-header">
            <h3><i class="fas fa-file-alt"></i> All Applications (<%= applications != null ? applications.size() : 0 %>)</h3>
        </div>

        <% if (applications == null || applications.isEmpty()) { %>
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-inbox" style="font-size: 60px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; margin-top: 20px; font-size: 18px;">No applications yet</h3>
                <p style="color: #8892b0;">Students haven't applied to any jobs yet.</p>
            </div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student</th>
                        <th>Job</th>
                        <th>Applied Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Application a : applications) {
                        String studentName = "Unknown";
                        String jobTitle = "Unknown";
                        for (Student s : students) {
                            if (s.getId() == a.getStudentId()) { studentName = s.getName(); break; }
                        }
                        for (Job j : jobs) {
                            if (j.getId() == a.getJobId()) { jobTitle = j.getTitle(); break; }
                        }
                    %>
                    <tr>
                        <td>#<%= a.getId() %></td>
                        <td><strong style="color:#1a1a2e;"><%= studentName %></strong></td>
                        <td><%= jobTitle %></td>
                        <td><%= a.getAppliedDate() %></td>
                        <td>
                            <span class="status-badge status-<%= a.getStatus() %>">
                                <%= a.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <form action="UpdateStatusServlet" method="post" style="display: flex; gap: 8px; align-items: center;">
                                <input type="hidden" name="applicationId" value="<%= a.getId() %>">
                                <select name="status" class="status-select">
                                    <option value="PENDING" <%= "PENDING".equals(a.getStatus()) ? "selected" : "" %>>PENDING</option>
                                    <option value="SHORTLISTED" <%= "SHORTLISTED".equals(a.getStatus()) ? "selected" : "" %>>SHORTLISTED</option>
                                    <option value="SELECTED" <%= "SELECTED".equals(a.getStatus()) ? "selected" : "" %>>SELECTED</option>
                                    <option value="REJECTED" <%= "REJECTED".equals(a.getStatus()) ? "selected" : "" %>>REJECTED</option>
                                </select>
                                <button type="submit" class="btn-update">
                                    <i class="fas fa-save"></i> Update
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

</body>
</html>