package controller;

import dao.RevenueDAO;
import model.Booking;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Controller servlet for Admin Financial Analytics (UC-22_View Revenue Report).
 */
@WebServlet(name = "RevenueReportController", urlPatterns = {"/admin/revenue"})
public class RevenueReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin Access Exclusivity (BR89)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/staff");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 1) { // Admin role is 1
            request.getSession(true).setAttribute("toastErrorMsg", "Access denied. High-privilege Admin credentials required.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Date Range Validation Check (BR5)
        if (startDate != null && !startDate.trim().isEmpty() &&
            endDate != null && !endDate.trim().isEmpty()) {
            
            try {
                LocalDate start = LocalDate.parse(startDate);
                LocalDate end = LocalDate.parse(endDate);
                
                if (end.isBefore(start)) {
                    request.setAttribute("errorMsg", "Date Range validation error: End date cannot be before Start date.");
                    // Reset range or proceed with empty lists
                    request.getRequestDispatcher("/WEB-INF/views/admin/revenueReport.jsp").forward(request, response);
                    return;
                }
            } catch (DateTimeParseException ex) {
                request.setAttribute("errorMsg", "Invalid date parameters format.");
                request.getRequestDispatcher("/WEB-INF/views/admin/revenueReport.jsp").forward(request, response);
                return;
            }
        }

        int page = 1;
        int size = 10;
        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
            if (request.getParameter("size") != null) size = Integer.parseInt(request.getParameter("size"));
        } catch (NumberFormatException ignored) {}
        
        int offset = (page - 1) * size;

        RevenueDAO revenueDAO = new RevenueDAO();
        int totalRecords = revenueDAO.countRevenueReport(startDate, endDate);
        int totalPages = (int) Math.ceil((double) totalRecords / size);
        
        List<Booking> list = revenueDAO.getRevenueReport(startDate, endDate, offset, size);

        // Accumulate financial summary metrics (UC-22 step 5)
        Booking totals = revenueDAO.getRevenueTotals(startDate, endDate);
        BigDecimal totalSubtotal = totals.getSubtotalFee() != null ? totals.getSubtotalFee() : BigDecimal.ZERO;
        BigDecimal totalCommission = totals.getPlatformCommission() != null ? totals.getPlatformCommission() : BigDecimal.ZERO;
        BigDecimal totalPayout = totals.getOwnerPayout() != null ? totals.getOwnerPayout() : BigDecimal.ZERO;

        request.setAttribute("revenueData", list);
        request.setAttribute("totalSubtotal", totalSubtotal);
        request.setAttribute("totalCommission", totalCommission);
        request.setAttribute("totalPayout", totalPayout);
        request.setAttribute("startDateVal", startDate);
        request.setAttribute("endDateVal", endDate);
        
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);

        request.getRequestDispatcher("/WEB-INF/views/admin/revenueReport.jsp").forward(request, response);
    }
}
