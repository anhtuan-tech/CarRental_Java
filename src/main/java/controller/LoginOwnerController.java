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
 * Handles Owner login (role_id = 3).
 * GET → ownerLogin.jsp | POST → checkLogin(role_id=3) → ownerDashboard
 *
 * Business Rules enforced:
 *   BR49 – email format, no blank password
 *   BR50 – Active only
 *   BR51 – brute-force lock (handled in UserDAO)
 */
@WebServlet(name = "LoginOwnerController", urlPatterns = {"/login/owner"})
public class LoginOwnerController extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/ownerLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        String validationError = validateInput(email, password);
        if (validationError != null) {
            request.setAttribute("errorMsg", validationError);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/ownerLogin.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.checkLogin(email, password, 4); // role_id = 4 (Owner)

        if (user == null) {
            request.setAttribute("errorMsg", "Incorrect email or password, or the account is locked/inactive.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/ownerLogin.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);

        response.sendRedirect(request.getContextPath() + "/owner/dashboard");
    }

    private String validateInput(String email, String password) {
        if (email == null || email.trim().isEmpty()) return "Email is required.";
        if (!EMAIL_PATTERN.matcher(email.trim()).matches()) return "Invalid email format.";
        if (password == null || password.trim().isEmpty()) return "Password is required.";
        return null;
    }
}
