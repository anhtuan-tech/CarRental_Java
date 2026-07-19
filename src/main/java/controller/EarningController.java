package controller;

import dao.EarningDAO;
import model.BookingHistory;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller servlet for Owner Earnings Analytics (UC-17).
 */
@WebServlet(name = "EarningController", urlPatterns = {"/owner/earnings", "/owner/earning"})
public class EarningController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Valid Session Auth check (UC-17 step 3)
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/owner");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 4) { // Owner only (role_id = 4)
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        EarningDAO earningDAO = new EarningDAO();
        
        // 1. Get Earnings Summary (Completed payout sum)
        BigDecimal totalEarnings = earningDAO.getEarningsSummary(user.getUserId());
        
        // 2. Get Audit Timeline booking log history
        List<BookingHistory> bookingHistory = earningDAO.getBookingHistory(user.getUserId());

        request.setAttribute("totalEarnings", totalEarnings);
        request.setAttribute("bookingHistory", bookingHistory);

        request.getRequestDispatcher("/WEB-INF/views/owner/earning.jsp").forward(request, response);
    }
}
