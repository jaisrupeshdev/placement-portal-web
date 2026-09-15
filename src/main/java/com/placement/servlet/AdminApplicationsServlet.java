package com.placement.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Application;
import com.placement.model.Job;
import com.placement.model.Student;

@WebServlet("/AdminApplicationsServlet")
public class AdminApplicationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        ApplicationDAO appDAO = new ApplicationDAO();
        StudentDAO studentDAO = new StudentDAO();
        JobDAO jobDAO = new JobDAO();

        List<Application> applications = appDAO.getAllApplications();
        List<Student> students = studentDAO.getAllStudents();
        List<Job> jobs = jobDAO.getAllJobs();

        // Enrich applications with student and job info
        List<Application> enrichedApps = new ArrayList<>();
        for (Application a : applications) {
            // We'll store extra info in a wrapper or just set additional attributes later
            // For simplicity, we'll create a small class here, but we can also use request attributes
            // Let's create a simple DTO-like approach: we'll add fields to Application? No.
            // Instead, we'll pass separate lists and match in JSP.
            enrichedApps.add(a);
        }

        request.setAttribute("applicationsList", enrichedApps);
        request.setAttribute("studentsList", students);
        request.setAttribute("jobsList", jobs);
        request.getRequestDispatcher("admin-applications.jsp").forward(request, response);
    }
}