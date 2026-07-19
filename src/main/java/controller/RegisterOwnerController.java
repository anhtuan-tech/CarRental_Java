package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.PasswordUtils;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * Handles Owner registration: GET shows the form, POST processes registration.
 * Identical flow to RegisterCustomerController but role_id = 3 (Owner).
 */
@WebServlet(name = "RegisterOwnerController", urlPatterns = {"/register/owner"})
public class RegisterOwnerController extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final int MIN_PWD_LENGTH = 8;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/registerOwner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email       = request.getParameter("email");
        String password    = request.getParameter("password");
        String confirmPwd  = request.getParameter("confirmPassword");
        String phoneNumber = request.getParameter("phoneNumber");

        String validationError = validateData(email, password, confirmPwd, phoneNumber);
        if (validationError != null) {
            request.setAttribute("errorMsg", validationError);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.getRequestDispatcher("/WEB-INF/views/auth/registerOwner.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();

        boolean isDuplicate = userDAO.checkDuplicateAccount(email, phoneNumber);
        if (isDuplicate) {
            request.setAttribute("errorMsg", "Email or phone number already registered.");
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.getRequestDispatcher("/WEB-INF/views/auth/registerOwner.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtils.hashSHA256(password);
        User user = new User();
        user.setRoleId(4); // Owner = 4
        user.setEmail(email);
        user.setPassword(hashedPassword);
        user.setPhoneNumber(phoneNumber);

        boolean success = userDAO.insertAccount(user);

        if (!success) {
            request.setAttribute("errorMsg", "System error. Please try again later.");
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.getRequestDispatcher("/WEB-INF/views/auth/registerOwner.jsp").forward(request, response);
            return;
        }

        request.setAttribute("successMsg", "Owner registration successful! Please wait for approval.");
        request.getRequestDispatcher("/WEB-INF/views/auth/registerOwner.jsp").forward(request, response);
    }

    private String validateData(String email, String password, String confirmPwd, String phoneNumber) {
        if (email == null || email.trim().isEmpty()) return "Email is required.";
        if (!EMAIL_PATTERN.matcher(email.trim()).matches()) return "Invalid email format.";
        if (password == null || password.trim().isEmpty()) return "Password is required.";
        if (password.length() < MIN_PWD_LENGTH) return "Password must be at least 8 characters.";
        if (!password.equals(confirmPwd)) return "Passwords do not match.";
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) return "Phone number is required.";
        if (!phoneNumber.trim().matches("^[0-9]{9,11}$")) return "Invalid phone number.";
        return null;
    }
}
