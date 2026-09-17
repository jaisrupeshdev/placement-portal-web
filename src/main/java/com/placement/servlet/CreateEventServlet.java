package com.placement.servlet;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.EventDAO;
import com.placement.model.Event;

@WebServlet("/CreateEventServlet")
public class CreateEventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String eventDateStr = request.getParameter("eventDate");
        String venue = request.getParameter("venue");
        int companyId = Integer.parseInt(request.getParameter("companyId"));

        LocalDate eventDate = null;
        if (eventDateStr != null && !eventDateStr.isEmpty()) {
            eventDate = LocalDate.parse(eventDateStr);
        }

        Event event = new Event(title, description, eventDate, venue, companyId);
        new EventDAO().addEvent(event);

        response.sendRedirect("EventsServlet");
    }
}