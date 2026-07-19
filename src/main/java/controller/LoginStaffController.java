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
import java.util.regex.Pattern;

/**
 * Handles Staff (role_id=2) and Admin (role_id=4) login.
 * GET → staffLogin.jsp | POST → checkStaffAndAdminLogin → redirect by role
 *
 * Business Rules enforced:
 *   BR49 – email format, no blank password
 *   BR50 – Active only
 *   BR51 – brute-force lock (handled in UserDAO)
 */
@WebServlet(name = "LoginStaffController", urlPatterns = {"/login/staff"})
public class LoginStaffController extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User u = (User) session.getAttribute("user");
            redirectByRole(u, request, response);
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/staffLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Step 3 – getParameter("email", "password")
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        String validationError = validateInput(email, password);
        if (validationError != null) {
            request.setAttribute("errorMsg", validationError);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/staffLogin.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.checkStaffAndAdminLogin(email, password);

        if (user == null) {
            // Step 7/8/9 – Return null → error
            request.setAttribute("errorMsg", "Incorrect email or password, or unauthorized account access.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/staffLogin.jsp").forward(request, response);
            return;
        }

        // Step 11 – session.setAttribute("user", user)
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);

        // Step 12/14 – Redirect based on role
        redirectByRole(user, request, response);
    }

    /**
     * Redirect to staff/dashboard (role_id=2) or admin/dashboard (role_id=4).
     */
    private void redirectByRole(User user, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (user.getRoleId() == 1 || user.getRoleId() == 4) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
        }
    }

    private String validateInput(String email, String password) {
        if (email == null || email.trim().isEmpty()) return "Email is required.";
        if (!EMAIL_PATTERN.matcher(email.trim()).matches()) return "Invalid email format.";
        if (password == null || password.trim().isEmpty()) return "Password is required.";
        return null;
    }
}
