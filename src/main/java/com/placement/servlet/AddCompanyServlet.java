package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.CompanyDAO;
import com.placement.model.Company;

@WebServlet("/AddCompanyServlet")
public class AddCompanyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String industry = request.getParameter("industry");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Company company = new Company(name, industry);
        company.setEmail(email);
        company.setPassword(password);

        CompanyDAO dao = new CompanyDAO();
        dao.addCompanyWithLogin(company);

        response.sendRedirect("CompaniesServlet");
    }
}