package controller;

import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller servlet serving clean URL dashboard routes for Admin, Staff, and Owner roles.
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/admin/dashboard", "/staff/dashboard", "/owner/dashboard"})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            String path = request.getServletPath();
            if ("/admin/dashboard".equals(path) || "/staff/dashboard".equals(path)) {
                response.sendRedirect(request.getContextPath() + "/login/staff");
            } else {
                response.sendRedirect(request.getContextPath() + "/login/owner");
            }
            return;
        }

        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();

        if ("/admin/dashboard".equals(path)) {
            if (user.getRoleId() != 1) { // Admin role is 1
                session.setAttribute("toastErrorMsg", "Access denied. Admin credentials required.");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/admin/adminDashboard.jsp").forward(request, response);
        } else if ("/staff/dashboard".equals(path)) {
            if (user.getRoleId() != 2 && user.getRoleId() != 1) { // Staff (2) or Admin (1)
                session.setAttribute("toastErrorMsg", "Access denied. Staff credentials required.");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/staff/staffDashboard.jsp").forward(request, response);
        } else if ("/owner/dashboard".equals(path)) {
            if (user.getRoleId() != 4) { // Owner role is 4
                session.setAttribute("toastErrorMsg", "Access denied. Partner Owner credentials required.");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/owner/ownerDashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
