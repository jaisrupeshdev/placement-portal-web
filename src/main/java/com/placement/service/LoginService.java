package com.placement.service;

import java.util.List;

import com.placement.dao.CompanyDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Company;
import com.placement.model.Student;

public class LoginService {

    private StudentDAO studentDAO = new StudentDAO();
    private CompanyDAO companyDAO = new CompanyDAO();

    public boolean adminLogin(String username, String password) {
        return username.equals("admin") && password.equals("admin123");
    }

    public Student studentLogin(String email, String password) {
        List<Student> students = studentDAO.getAllStudents();
        for (Student s : students) {
            if (s.getEmail().equalsIgnoreCase(email) && s.getPassword().equals(password)) {
                return s;
            }
        }
        return null;
    }

    public Company companyLogin(String email, String password) {
        return companyDAO.login(email, password);
    }
}