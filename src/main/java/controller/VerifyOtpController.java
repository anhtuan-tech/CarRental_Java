package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller servlet for verifying OTP verification codes (UC-07).
 */
@WebServlet(name = "VerifyOtpController", urlPatterns = {"/verify-otp"})
public class VerifyOtpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String resetEmail = (session != null) ? (String) session.getAttribute("resetEmail") : null;

        if (resetEmail == null || resetEmail.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/verifyOtp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String resetEmail = (session != null) ? (String) session.getAttribute("resetEmail") : null;
        String sessionOtp = (session != null) ? (String) session.getAttribute("recoveryOtp") : null;

        if (resetEmail == null || resetEmail.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String inputOtp = request.getParameter("otpCode");

        if (inputOtp == null || inputOtp.trim().length() != 6) {
            request.setAttribute("errorMsg", "Verification code must be 6 digits.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verifyOtp.jsp").forward(request, response);
            return;
        }

        // OTP verification: matches sent code
        boolean isMatch = (sessionOtp != null && sessionOtp.equals(inputOtp.trim()));

        if (isMatch) {
            session.setAttribute("otpVerified", "true");
            session.removeAttribute("recoveryOtp"); // Clean up OTP
            session.setAttribute("toastSuccessMsg", "OTP verified! Please set your new password.");
            response.sendRedirect(request.getContextPath() + "/reset-password");
        } else {
            request.setAttribute("errorMsg", "Invalid verification code. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verifyOtp.jsp").forward(request, response);
        }
    }
}
