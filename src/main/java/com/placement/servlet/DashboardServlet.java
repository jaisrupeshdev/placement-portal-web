package com.placement.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.CompanyDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Application;
import com.placement.model.Student;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        StudentDAO studentDAO = new StudentDAO();
        CompanyDAO companyDAO = new CompanyDAO();
        JobDAO jobDAO = new JobDAO();
        ApplicationDAO appDAO = new ApplicationDAO();

        List<Student> students = studentDAO.getAllStudents();
        List<Application> applications = appDAO.getAllApplications();

        int studentCount = students.size();
        int companyCount = companyDAO.getAllCompanies().size();
        int jobCount = jobDAO.getAllJobs().size();
        int appCount = applications.size();

        // Branch-wise student count
        Map<String, Integer> branchCount = new LinkedHashMap<>();
        for (Student s : students) {
            String b = s.getBranch() != null ? s.getBranch() : "Unknown";
            branchCount.put(b, branchCount.getOrDefault(b, 0) + 1);
        }

        // Application status count
        Map<String, Integer> statusCount = new HashMap<>();
        statusCount.put("PENDING", 0);
        statusCount.put("SHORTLISTED", 0);
        statusCount.put("SELECTED", 0);
        statusCount.put("REJECTED", 0);
        for (Application a : applications) {
            String st = a.getStatus() != null ? a.getStatus() : "PENDING";
            statusCount.put(st, statusCount.getOrDefault(st, 0) + 1);
        }

        // CGPA distribution (buckets)
        int[] cgpaBuckets = new int[5]; // <6, 6-7, 7-8, 8-9, 9-10
        for (Student s : students) {
            double c = s.getCgpa();
            if (c < 6) cgpaBuckets[0]++;
            else if (c < 7) cgpaBuckets[1]++;
            else if (c < 8) cgpaBuckets[2]++;
            else if (c < 9) cgpaBuckets[3]++;
            else cgpaBuckets[4]++;
        }

        // Set attributes
        request.setAttribute("studentCount", studentCount);
        request.setAttribute("companyCount", companyCount);
        request.setAttribute("jobCount", jobCount);
        request.setAttribute("appCount", appCount);
        request.setAttribute("branchCount", branchCount);
        request.setAttribute("statusCount", statusCount);
        request.setAttribute("cgpaBuckets", cgpaBuckets);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}