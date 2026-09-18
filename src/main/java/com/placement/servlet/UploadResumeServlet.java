package com.placement.servlet;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.placement.dao.StudentDAO;
import com.placement.model.Student;

@WebServlet("/UploadResumeServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class UploadResumeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        Part filePart = request.getPart("resume");

        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("ProfileServlet?msg=nofile");
            return;
        }

        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || !fileName.toLowerCase().endsWith(".pdf")) {
            response.sendRedirect("ProfileServlet?msg=invalidtype");
            return;
        }

        String uploadDir = getServletContext().getRealPath("/uploads/resumes/");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String savedFileName = "resume_" + studentId + "_" + System.currentTimeMillis() + ".pdf";
        String filePath = uploadDir + File.separator + savedFileName;
        filePart.write(filePath);

        String relativePath = "uploads/resumes/" + savedFileName;
        StudentDAO dao = new StudentDAO();
        Student student = dao.getStudentById(studentId);
        student.setResumePath(relativePath);
        dao.updateStudent(student);

        response.sendRedirect("ProfileServlet?msg=resumeuploaded");
    }
}