package controller;

import dao.BookingDAO;
import dao.CarDAO;
import model.Booking;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller servlet handling Owner Rental Orders (UC-16.1, UC-16.2).
 */
@WebServlet(name = "RentalOrderController", urlPatterns = {"/owner/orders"})
public class RentalOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/owner");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 4) { // Owner only (role_id = 4)
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int page = 1;
        int size = 10;
        try {
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
            if (request.getParameter("size") != null) size = Integer.parseInt(request.getParameter("size"));
        } catch (NumberFormatException ignored) {}
        
        int offset = (page - 1) * size;

        BookingDAO bookingDAO = new BookingDAO();
        int totalRecords = bookingDAO.countAllBookingByOwnerId(user.getUserId());
        int totalPages = (int) Math.ceil((double) totalRecords / size);

        List<Booking> orders = bookingDAO.getAllBookingByOwnerId(user.getUserId(), offset, size);

        if (orders == null || orders.isEmpty()) {
            request.setAttribute("message", "No rental transactions");
        } else {
            request.setAttribute("orders", orders);
        }

        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);

        request.getRequestDispatcher("/WEB-INF/views/owner/listRentalOrders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/owner");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 4) { // Owner only (role_id = 4)
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        if ("update".equalsIgnoreCase(action)) {
            processUpdateStatus(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/owner/orders");
        }
    }

    private void processUpdateStatus(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");
        String targetStatus = request.getParameter("status");
        String note = request.getParameter("note");

        if (bookingIdStr == null || targetStatus == null) {
            response.sendRedirect(request.getContextPath() + "/owner/orders");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdStr);
        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingById(bookingId);

        if (booking == null) {
            request.getSession(true).setAttribute("toastErrorMsg", "Rental order not found.");
            response.sendRedirect(request.getContextPath() + "/owner/orders");
            return;
        }

        // Security check: Must belong to owner's car fleet
        CarDAO carDAO = new CarDAO();
        if (!carDAO.checkOwner(booking.getCarId(), user.getUserId())) {
            request.getSession(true).setAttribute("toastErrorMsg", "Access Denied.");
            response.sendRedirect(request.getContextPath() + "/owner/orders");
            return;
        }

        // State Transition Validation (BR29, BR55)
        String currentStatus = booking.getStatus();
        if (!isValidTransition(currentStatus, targetStatus)) {
            request.getSession(true).setAttribute("toastErrorMsg", 
                    "Invalid state transition from '" + currentStatus + "' to '" + targetStatus + "'.");
            response.sendRedirect(request.getContextPath() + "/owner/orders");
            return;
        }

        boolean success = bookingDAO.updateStatus(targetStatus, bookingId, user.getUserId(), currentStatus, note);

        if (success) {
            // Trigger system notification logging (BR22, BR27, BR56)
            triggerNotificationSimulate(booking.getCustomerId(), user.getUserId(), bookingId, targetStatus);
            request.getSession(true).setAttribute("toastSuccessMsg", "Update successful.");
        } else {
            request.getSession(true).setAttribute("toastErrorMsg", "Update false.");
        }
        
        response.sendRedirect(request.getContextPath() + "/owner/orders");
    }

    private boolean isValidTransition(String current, String target) {
        if (current == null || target == null) return false;
        
        // Normalize status strings
        current = current.trim();
        target = target.trim();

        if ("Pending".equalsIgnoreCase(current) || "Paid".equalsIgnoreCase(current) || "Approved".equalsIgnoreCase(current)) {
            return "Confirmed".equalsIgnoreCase(target) || "Active".equalsIgnoreCase(target) || "Completed".equalsIgnoreCase(target) || "Rejected".equalsIgnoreCase(target);
        }
        if ("Confirmed".equalsIgnoreCase(current)) {
            return "Active".equalsIgnoreCase(target) || "Completed".equalsIgnoreCase(target);
        }
        if ("Active".equalsIgnoreCase(current)) {
            return "Completed".equalsIgnoreCase(target);
        }
        
        return false;
    }

    private void triggerNotificationSimulate(int customerId, int ownerId, int bookingId, String status) {
        // Notification Rule Simulation (BR22, BR27, BR56)
        System.out.println("[NOTIFICATION LOG] Rental Order ID: " + bookingId + " status updated to: " + status);
        System.out.println("[NOTIFICATION LOG] Sending email trigger to Customer ID: " + customerId);
        System.out.println("[NOTIFICATION LOG] Sending database alert sync to Fleet Owner ID: " + ownerId);
    }
}
