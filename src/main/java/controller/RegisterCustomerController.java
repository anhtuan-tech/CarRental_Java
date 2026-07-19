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
 * Handles Customer registration: GET shows the form, POST processes registration.
 * Sequence: getParameters → validateData → checkDuplicateAccount → insertAccount
 */
@WebServlet(name = "RegisterCustomerController", urlPatterns = {"/register/customer"})
public class RegisterCustomerController extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    // BR13: Min 8 characters
    private static final int MIN_PWD_LENGTH = 8;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/registerCustomer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Step 3 – getParameter
        String email       = request.getParameter("email");
        String password    = request.getParameter("password");
        String confirmPwd  = request.getParameter("confirmPassword");
        String phoneNumber = request.getParameter("phoneNumber");

        // Step 4 – validateData()
        String validationError = validateData(email, password, confirmPwd, phoneNumber);
        if (validationError != null) {
            // Step 5/6 – Forward back with error (Invalid server validation data)
            request.setAttribute("errorMsg", validationError);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.getRequestDispatcher("/WEB-INF/views/auth/registerCustomer.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();

        // Step 7 – checkDuplicateAccount(email, phone_number)
        boolean isDuplicate = userDAO.checkDuplicateAccount(email, phoneNumber);
        if (isDuplicate) {
            // Step 10-12 – Account exists → render duplicate notification
            request.setAttribute("errorMsg", "Email or phone number already registered. Please try again.");
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.getRequestDispatcher("/WEB-INF/views/auth/registerCustomer.jsp").forward(request, response);
            return;
        }

        // Step 13 – Valid account → build User and insertAccount
        String hashedPassword = PasswordUtils.hashSHA256(password);
        User user = new User();
        user.setRoleId(3); // Customer = 3
        user.setEmail(email);
        user.setPassword(hashedPassword);
        user.setPhoneNumber(phoneNumber);

        // Step 14 – insertAccount(user)
        boolean success = userDAO.insertAccount(user);

        if (!success) {
            // Step 17-19 – Execute failed → system error
            request.setAttribute("errorMsg", "System error. Please try again later.");
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.getRequestDispatcher("/WEB-INF/views/auth/registerCustomer.jsp").forward(request, response);
            return;
        }

        // Step 20-22 – Execute complete → success message
        request.setAttribute("successMsg", "Registration successful! You can now log in.");
        request.getRequestDispatcher("/WEB-INF/views/auth/registerCustomer.jsp").forward(request, response);
    }

    /**
     * Server-side validation (BR49, BR13).
     *
     * @return error message string, or null if valid
     */
    private String validateData(String email, String password, String confirmPwd, String phoneNumber) {
        if (email == null || email.trim().isEmpty()) {
            return "Email is required.";
        }
        // BR49 – Email format
        if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            return "Invalid email format.";
        }
        if (password == null || password.trim().isEmpty()) {
            return "Password is required.";
        }
        // BR13 – Min 8 characters
        if (password.length() < MIN_PWD_LENGTH) {
            return "Password must be at least 8 characters.";
        }
        if (!password.equals(confirmPwd)) {
            return "Passwords do not match.";
        }
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return "Phone number is required.";
        }
        if (!phoneNumber.trim().matches("^[0-9]{9,11}$")) {
            return "Invalid phone number (9-11 digits).";
        }
        return null;
    }
}
