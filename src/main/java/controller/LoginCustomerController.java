package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.PasswordUtils;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.regex.Pattern;

/**
 * Handles Customer login (role_id = 1).
 * GET → customerLogin.jsp | POST → validate → checkLogin → session → homepage
 *
 * Business Rules enforced:
 *   BR49 – email format validation, no blank password
 *   BR50 – only 'Active' accounts allowed
 *   BR51 – 5 failed attempts → 15-minute lock
 */
@WebServlet(name = "LoginCustomerController", urlPatterns = {"/login/customer"})
public class LoginCustomerController extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // If already logged in, redirect to homepage
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/customerLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Step 3 – getParameter("email", "password")
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // BR49 – Validate format
        String validationError = validateInput(email, password);
        if (validationError != null) {
            request.setAttribute("errorMsg", validationError);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/customerLogin.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.checkLogin(email, password, 3);

        if (user == null) {
            // Step 7/8 – Return null → "Incorrect email or password"
            // Detect if it is a lock message by querying again (we use a generic message for security)
            String errorMsg = resolveLoginError(email, userDAO);
            request.setAttribute("errorMsg", errorMsg);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/customerLogin.jsp").forward(request, response);
            return;
        }

        // Step 10 – Return user → Step 11 – session.setAttribute("user", user)
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);

        // Step 12 – sendRedirect("homepage")
        response.sendRedirect(request.getContextPath() + "/home");
    }

    /**
     * Determine a user-friendly error message without leaking account details.
     */
    private String resolveLoginError(String email, UserDAO userDAO) {
        return "Incorrect email or password, or the account is locked/inactive.";
    }

    private String validateInput(String email, String password) {
        if (email == null || email.trim().isEmpty()) return "Email is required.";
        if (!EMAIL_PATTERN.matcher(email.trim()).matches()) return "Invalid email format.";
        if (password == null || password.trim().isEmpty()) return "Password is required.";
        return null;
    }
}
