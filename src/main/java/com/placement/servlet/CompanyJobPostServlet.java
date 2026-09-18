package com.placement.servlet;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.JobDAO;
import com.placement.model.Job;

@WebServlet("/CompanyJobPostServlet")
public class CompanyJobPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("company-add-job.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");
        String title = request.getParameter("title");
        double minCgpa = Double.parseDouble(request.getParameter("minCgpa"));
        List<String> branches = Arrays.asList(request.getParameter("branches").split(","));
        List<String> skills = Arrays.asList(request.getParameter("skills").split(","));

        Job job = new Job(companyId, title, minCgpa, branches, skills);
        new JobDAO().addJob(job);

        response.sendRedirect("CompanyJobsServlet");
    }
}