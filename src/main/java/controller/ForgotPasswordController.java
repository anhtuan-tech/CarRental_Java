package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.EmailServices;

import java.io.IOException;

/**
 * Controller servlet handling Forgot Password workflow (UC-07).
 */
@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgotPassword"})
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/forgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Email is required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/forgotPassword.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.checkEmailExist(email.trim());

        if (user != null) {
            // Mock email sending
            EmailServices.sendResetPasswordEmail(email.trim());
            // Set message and redirect
            request.getSession(true).setAttribute("toastSuccessMsg", "Please check your email.");
            response.sendRedirect(request.getContextPath() + "/login/customer");
        } else {
            request.setAttribute("errorMsg", "Email does not exist.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/forgotPassword.jsp").forward(request, response);
        }
    }
}
