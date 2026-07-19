package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.PasswordUtils;

import java.io.IOException;

/**
 * Controller servlet handling the Reset Password workflow (UC-07).
 */
@WebServlet(name = "ResetPasswordController", urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String resetEmail = (session != null) ? (String) session.getAttribute("resetEmail") : null;
        String otpVerified = (session != null) ? (String) session.getAttribute("otpVerified") : null;

        if (resetEmail == null || resetEmail.trim().isEmpty() || !"true".equals(otpVerified)) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/resetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String resetEmail = (session != null) ? (String) session.getAttribute("resetEmail") : null;
        String otpVerified = (session != null) ? (String) session.getAttribute("otpVerified") : null;

        if (resetEmail == null || resetEmail.trim().isEmpty() || !"true".equals(otpVerified)) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String password = request.getParameter("password");
        if (password == null || password.trim().length() < 6) {
            request.setAttribute("errorMsg", "Password must be at least 6 characters.");
            request.getRequestDispatcher("/WEB-INF/views/auth/resetPassword.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtils.hashSHA256(password.trim());
        UserDAO userDAO = new UserDAO();
 
        // Enforce security check: New password must not match the current password
        model.User user = userDAO.findByEmail(resetEmail.trim());
        if (user != null && user.getPassword() != null && user.getPassword().equalsIgnoreCase(hashedPassword)) {
            request.setAttribute("errorMsg", "New password cannot be the same as your current password.");
            request.getRequestDispatcher("/WEB-INF/views/auth/resetPassword.jsp").forward(request, response);
            return;
        }
 
        boolean success = userDAO.updatePassword(resetEmail.trim(), hashedPassword);

        if (success) {
            session.removeAttribute("resetEmail");
            session.removeAttribute("otpVerified");
            session.setAttribute("toastSuccessMsg", "Password reset successful! Please login with your new password.");
            response.sendRedirect(request.getContextPath() + "/login/customer");
        } else {
            request.setAttribute("errorMsg", "Failed to reset password. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/resetPassword.jsp").forward(request, response);
        }
    }
}
