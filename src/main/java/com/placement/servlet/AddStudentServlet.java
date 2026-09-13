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

import com.placement.dao.StudentDAO;
import com.placement.model.Student;

@WebServlet("/AddStudentServlet")
public class AddStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String rollNo = request.getParameter("rollNo");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        double cgpa = Double.parseDouble(request.getParameter("cgpa"));
        String branch = request.getParameter("branch");
        String skillsInput = request.getParameter("skills");

        List<String> skills = Arrays.asList(skillsInput.split(","));

        Student student = new Student(name, rollNo, email, password, cgpa, branch, skills);

        StudentDAO dao = new StudentDAO();
        dao.addStudent(student);

        response.sendRedirect("StudentsServlet");
    }
}