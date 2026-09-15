package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.NotificationDAO;
import com.placement.model.Application;
import com.placement.model.Job;

@WebServlet("/UpdateStatusServlet")
public class UpdateStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String newStatus = request.getParameter("status");

        ApplicationDAO appDAO = new ApplicationDAO();

        // Find application to get studentId and jobId
        Application target = null;
        for (Application a : appDAO.getAllApplications()) {
            if (a.getId() == applicationId) { target = a; break; }
        }

        appDAO.updateStatus(applicationId, newStatus);

        // Send notification to student
        if (target != null) {
            String jobTitle = "a job";
            JobDAO jobDAO = new JobDAO();
            for (Job j : jobDAO.getAllJobs()) {
                if (j.getId() == target.getJobId()) { jobTitle = j.getTitle(); break; }
            }

            String message = "Your application for '" + jobTitle + "' is now " + newStatus + ".";
            new NotificationDAO().addNotification(target.getStudentId(), message);
        }

        response.sendRedirect("AdminApplicationsServlet");
    }
}