package controller;

import dao.BookingDAO;
import dao.CarDAO;
import dao.EarningDAO;
import model.Booking;
import model.Car;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Controller servlet serving clean URL dashboard routes for Admin, Staff, and Owner roles.
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/admin/dashboard", "/staff/dashboard", "/owner/dashboard"})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            String path = request.getServletPath();
            if ("/admin/dashboard".equals(path) || "/staff/dashboard".equals(path)) {
                response.sendRedirect(request.getContextPath() + "/login/staff");
            } else {
                response.sendRedirect(request.getContextPath() + "/login/owner");
            }
            return;
        }

        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();

        if ("/admin/dashboard".equals(path)) {
            if (user.getRoleId() != 1) {
                session.setAttribute("toastErrorMsg", "Access denied. Admin credentials required.");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            populateAdminDashboard(request);
            request.getRequestDispatcher("/WEB-INF/views/admin/adminDashboard.jsp").forward(request, response);

        } else if ("/staff/dashboard".equals(path)) {
            if (user.getRoleId() != 2 && user.getRoleId() != 1) {
                session.setAttribute("toastErrorMsg", "Access denied. Staff credentials required.");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            populateStaffDashboard(request);
            request.getRequestDispatcher("/WEB-INF/views/staff/staffDashboard.jsp").forward(request, response);

        } else if ("/owner/dashboard".equals(path)) {
            if (user.getRoleId() != 4) {
                session.setAttribute("toastErrorMsg", "Access denied. Partner Owner credentials required.");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            populateOwnerDashboard(request, user.getUserId());
            request.getRequestDispatcher("/WEB-INF/views/owner/ownerDashboard.jsp").forward(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    /**
     * Query all data needed by adminDashboard.jsp and set as request attributes.
     */
    private void populateAdminDashboard(HttpServletRequest request) {
        dao.UserDAO userDAO = new dao.UserDAO();
        CarDAO carDAO = new CarDAO();
        BookingDAO bookingDAO = new BookingDAO();

        long totalUsers = userDAO.getAllUsersByRole(2).size() + userDAO.getAllUsersByRole(3).size() + userDAO.getAllUsersByRole(4).size();
        long staffAccounts = userDAO.getAllStaffs().size();
        long totalVehicles = carDAO.getAllCars().size();

        List<Booking> allBookings = bookingDAO.getAllCarBookings();
        BigDecimal platformRevenue = BigDecimal.ZERO;
        
        int[] bookingsByMonth = new int[12];
        for (Booking b : allBookings) {
            if (b.getCreatedAt() != null) {
                int month = b.getCreatedAt().getMonthValue() - 1;
                if (month >= 0 && month <= 11) {
                    bookingsByMonth[month]++;
                }
            }
            if ("Completed".equalsIgnoreCase(b.getStatus()) && b.getSubtotalFee() != null && b.getOwnerPayout() != null) {
                platformRevenue = platformRevenue.add(b.getSubtotalFee().subtract(b.getOwnerPayout()));
            }
        }

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("staffAccounts", staffAccounts);
        request.setAttribute("totalVehicles", totalVehicles);
        request.setAttribute("platformRevenue", platformRevenue);

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < 12; i++) {
            sb.append(bookingsByMonth[i]);
            if (i < 11) sb.append(",");
        }
        sb.append("]");
        request.setAttribute("monthlyBookingsJson", sb.toString());
    }

    /**
     * Query all data needed by staffDashboard.jsp and set as request attributes.
     */
    private void populateStaffDashboard(HttpServletRequest request) {
        CarDAO     carDAO     = new CarDAO();
        BookingDAO bookingDAO = new BookingDAO();

        List<Car> allCars = carDAO.getAllCars();
        List<Booking> allBookings = bookingDAO.getAllCarBookings();

        long pendingBookings = allBookings.stream()
                .filter(b -> "Pending".equalsIgnoreCase(b.getStatus()))
                .count();

        long activeRentals = allBookings.stream()
                .filter(b -> "Active".equalsIgnoreCase(b.getStatus()))
                .count();

        long carsToReview = allCars.stream()
                .filter(c -> "Pending_Approval".equalsIgnoreCase(c.getStatus()))
                .count();

        long completedBookings = allBookings.stream()
                .filter(b -> "Completed".equalsIgnoreCase(b.getStatus()))
                .count();

        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("activeRentals", activeRentals);
        request.setAttribute("carsToReview", carsToReview);
        request.setAttribute("completedBookings", completedBookings);

        // Chart data: Bookings per month (current year logic simplified to all time per month)
        int[] bookingsByMonth = new int[12];
        for (Booking b : allBookings) {
            if (b.getCreatedAt() != null) {
                int month = b.getCreatedAt().getMonthValue() - 1;
                if (month >= 0 && month <= 11) {
                    bookingsByMonth[month]++;
                }
            }
        }
        
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < 12; i++) {
            sb.append(bookingsByMonth[i]);
            if (i < 11) sb.append(",");
        }
        sb.append("]");
        request.setAttribute("monthlyBookingsJson", sb.toString());
    }

    /**
     * Query all data needed by ownerDashboard.jsp and set as request attributes.
     */
    private void populateOwnerDashboard(HttpServletRequest request, int ownerId) {
        CarDAO     carDAO     = new CarDAO();
        BookingDAO bookingDAO = new BookingDAO();
        EarningDAO earningDAO = new EarningDAO();

        // ── 1. Fleet stats ──────────────────────────────────────────────────
        List<Car> allCars = carDAO.getCarsByOwner(ownerId);

        long totalCars   = allCars.size();
        long activeCars  = allCars.stream()
                .filter(c -> "Available".equalsIgnoreCase(c.getStatus())
                          || "Approved".equalsIgnoreCase(c.getStatus()))
                .count();
        long pendingCars = allCars.stream()
                .filter(c -> "Pending_Approval".equalsIgnoreCase(c.getStatus())
                          || "Pending".equalsIgnoreCase(c.getStatus()))
                .count();

        request.setAttribute("totalCars",   totalCars);
        request.setAttribute("activeCars",  activeCars);
        request.setAttribute("pendingCars", pendingCars);

        // ── 2. Bookings for this owner ───────────────────────────────────────
        List<Booking> allBookings = bookingDAO.getAllBookingByOwnerId(ownerId);

        // Pending orders (status = Paid hoặc Pending Payment — chờ owner xác nhận)
        List<Booking> pendingOrderList = allBookings.stream()
                .filter(b -> "Paid".equalsIgnoreCase(b.getStatus())
                          || "Pending Payment".equalsIgnoreCase(b.getStatus())
                          || "Pending".equalsIgnoreCase(b.getStatus()))
                .collect(Collectors.toList());

        request.setAttribute("pendingOrders",    pendingOrderList.size());
        request.setAttribute("pendingOrderList", pendingOrderList);

        // ── 3. Monthly earnings (tháng hiện tại) ────────────────────────────
        LocalDateTime now           = LocalDateTime.now();
        int           currentMonth  = now.getMonthValue();
        int           currentYear   = now.getYear();

        BigDecimal monthlyEarnings = allBookings.stream()
                .filter(b -> "Completed".equalsIgnoreCase(b.getStatus())
                        && b.getCreatedAt() != null
                        && b.getCreatedAt().getMonthValue() == currentMonth
                        && b.getCreatedAt().getYear()       == currentYear)
                .map(b -> b.getOwnerPayout() != null ? b.getOwnerPayout() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        request.setAttribute("monthlyEarnings", monthlyEarnings);

        // ── 4. Total earnings (all-time, for reference) ──────────────────────
        BigDecimal totalEarnings = earningDAO.getEarningsSummary(ownerId);
        request.setAttribute("totalEarnings", totalEarnings);

        // ── 5. Chart data — earnings per month for last 6 months ─────────────
        String[] monthNames = {"Jan","Feb","Mar","Apr","May","Jun",
                               "Jul","Aug","Sep","Oct","Nov","Dec"};

        StringBuilder labelsJson = new StringBuilder("[");
        StringBuilder dataJson   = new StringBuilder("[");

        for (int i = 5; i >= 0; i--) {
            LocalDateTime targetMonth = now.minusMonths(i);
            int tMonth = targetMonth.getMonthValue();
            int tYear  = targetMonth.getYear();

            BigDecimal monthTotal = allBookings.stream()
                    .filter(b -> "Completed".equalsIgnoreCase(b.getStatus())
                            && b.getCreatedAt() != null
                            && b.getCreatedAt().getMonthValue() == tMonth
                            && b.getCreatedAt().getYear()       == tYear)
                    .map(b -> b.getOwnerPayout() != null ? b.getOwnerPayout() : BigDecimal.ZERO)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            labelsJson.append("\"").append(monthNames[tMonth - 1]).append("\"");
            dataJson.append(monthTotal.longValue());

            if (i > 0) {
                labelsJson.append(",");
                dataJson.append(",");
            }
        }
        labelsJson.append("]");
        dataJson.append("]");

        request.setAttribute("chartLabels", labelsJson.toString());
        request.setAttribute("chartData",   dataJson.toString());
    }
}

