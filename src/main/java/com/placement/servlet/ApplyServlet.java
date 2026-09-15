package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.ApplicationDAO;

@WebServlet("/ApplyServlet")
public class ApplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        int jobId = Integer.parseInt(request.getParameter("jobId"));

        ApplicationDAO dao = new ApplicationDAO();

        if (dao.hasApplied(studentId, jobId)) {
            // Already applied
            response.sendRedirect("JobsServlet?msg=already");
        } else {
            dao.applyForJob(studentId, jobId);
            response.sendRedirect("JobsServlet?msg=success");
        }
    }
}