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

@WebServlet("/AddJobServlet")
public class AddJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = Integer.parseInt(request.getParameter("companyId"));
        String title = request.getParameter("title");
        double minCgpa = Double.parseDouble(request.getParameter("minCgpa"));
        String branchesInput = request.getParameter("branches");
        String skillsInput = request.getParameter("skills");

        List<String> branches = Arrays.asList(branchesInput.split(","));
        List<String> skills = Arrays.asList(skillsInput.split(","));

        Job job = new Job(companyId, title, minCgpa, branches, skills);

        JobDAO dao = new JobDAO();
        dao.addJob(job);

        response.sendRedirect("JobsServlet");
    }
}