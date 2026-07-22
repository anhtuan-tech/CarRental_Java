package controller;

import dao.BookingDAO;
import dao.BookingHistoryDAO;
import dao.CarDAO;
import dao.PaymentDAO;
import model.Booking;
import model.Car;
import model.Payment;
import model.User;
import utils.NotificationService;
import utils.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Controller servlet for Customer Car Booking Lifecycle (UC-13.1 to UC-13.4)
 * and Back-office Staff/Admin booking management (UC-18.1 to UC-18.4).
 */
@WebServlet(name = "CarBookingController", urlPatterns = {
    "/customer/bookings",
    "/customer/booking",
    "/customer/vnpay-callback",
    "/staff/bookings"
})
public class CarBookingController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CarBookingController.class.getName());
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookingHistoryDAO bookingHistoryDAO = new BookingHistoryDAO();
    private final CarDAO carDAO = new CarDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final PaymentService paymentService = new PaymentService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();

        // 1. VNPAY Callback handler endpoint
        if ("/customer/vnpay-callback".equals(servletPath)) {
            handleVNPAYCallback(request, response);
            return;
        }

        // 2. Staff Back-Office Routing (/staff/bookings)
        if ("/staff/bookings".equals(servletPath)) {
            handleStaffGetRouting(request, response);
            return;
        }

        // 3. Customer Booking Routing (/customer/bookings, /customer/booking)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/customer");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "pay":
                handleCustomerPay(request, response, user);
                break;
            case "search":
                handleCustomerSearchBookings(request, response, user);
                break;
            case "list":
            default:
                handleCustomerListBookings(request, response, user);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String servletPath = request.getServletPath();

        // Staff Back-Office Routing
        if ("/staff/bookings".equals(servletPath)) {
            handleStaffPostRouting(request, response);
            return;
        }

        // Customer Booking Operations
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/customer");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null) {
            action = "book";
        }

        switch (action) {
            case "book":
            case "submit":
                handleFormSubmissionAndCheck(request, response, user);
                break;
            case "confirmCheckout":
            case "pay":
                handleCheckoutConfirmationAndPay(request, response, user);
                break;
            case "cancel":
                handleCancelBooking(request, response, user);
                break;
            case "search":
                handleCustomerSearchBookings(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/customer/bookings?action=list");
                break;
        }
    }

    // =========================================================================
    // UC-13.1: View My Car Bookings
    // =========================================================================
    private void handleCustomerListBookings(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        List<Booking> bookings = bookingDAO.getBookingsByCustomer(user.getUserId());

        if (bookings == null || bookings.isEmpty()) {
            request.setAttribute("message", "No Bookings Available");
        } else {
            request.setAttribute("carBookingList", bookings);
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/bookingPage.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-13.4: Search My Car Bookings
    // =========================================================================
    private void handleCustomerSearchBookings(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        List<Booking> matchingBookings = bookingDAO.searchMyBookings(user.getUserId(), keyword);

        if (matchingBookings == null || matchingBookings.isEmpty()) {
            request.setAttribute("message", "No Matching Bookings");
        } else {
            request.setAttribute("carBookingList", matchingBookings);
        }
        request.setAttribute("keywordVal", keyword);

        request.getRequestDispatcher("/WEB-INF/views/customer/bookingPage.jsp").forward(request, response);
    }

    private void handleCustomerPay(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        int bookingId = -1;
        try {
            if (bookingIdStr != null) {
                bookingId = Integer.parseInt(bookingIdStr.trim());
            }
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid bookingId for pay action: {0}", bookingIdStr);
        }

        if (bookingId > 0) {
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking != null && "Pending Payment".equals(booking.getStatus())) {
                String paymentUrl = paymentService.preprocessPayment(booking.getBookingId(), booking.getSubtotalFee(), "vnpay",
                        request.getContextPath());
                response.sendRedirect(paymentUrl);
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/customer/bookings?action=list");
    }

    // =========================================================================
    // UC-13.2 Step 1 & 2: Form Submission, Date Check & Checkout Summary
    // =========================================================================
    private void handleFormSubmissionAndCheck(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String carIdStr = request.getParameter("carId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        int carId;
        try {
            carId = Integer.parseInt(carIdStr);
        } catch (Exception e) {
            request.getSession(true).setAttribute("toastErrorMsg", "Invalid car code.");
            response.sendRedirect(request.getContextPath() + "/cars");
            return;
        }

        LocalDateTime startDate = parseDateTime(startDateStr);
        LocalDateTime endDate = parseDateTime(endDateStr);

        // BR5 & BR18 & BR19: Date validation check
        if (!validateBookingDate(startDate, endDate)) {
            request.getSession(true).setAttribute("toastErrorMsg",
                    "The car pickup date must be from today onwards, and the return date must be after the pickup date.");
            response.sendRedirect(request.getContextPath() + "/cars?action=detail&carId=" + carId);
            return;
        }

        // BR20: Check vehicle availability
        boolean isAvailable = bookingDAO.checkAvailability(carId, startDate, endDate);
        if (!isAvailable) {
            request.setAttribute("message", "Car not ready");
            request.getSession(true).setAttribute("toastErrorMsg", "The car is not available during the selected time.");
            response.sendRedirect(request.getContextPath() + "/cars?action=detail&carId=" + carId);
            return;
        }

        // Fetch Car detail & Calculate Total Amount (BR3)
        Car car = carDAO.getCarById(carId);
        if (car == null) {
            request.getSession(true).setAttribute("toastErrorMsg", "Car information not found.");
            response.sendRedirect(request.getContextPath() + "/cars");
            return;
        }

        long days = ChronoUnit.DAYS.between(startDate.toLocalDate(), endDate.toLocalDate());
        int totalDays = (int) Math.max(days, 1);

        BigDecimal pricePerDay = car.getPricePerDay();
        BigDecimal subtotalFee = pricePerDay.multiply(new BigDecimal(totalDays));
        BigDecimal platformCommission = subtotalFee.multiply(new BigDecimal("0.10"));
        BigDecimal ownerPayout = subtotalFee.multiply(new BigDecimal("0.90"));

        request.setAttribute("car", car);
        request.setAttribute("startDateStr", startDateStr);
        request.setAttribute("endDateStr", endDateStr);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("totalDays", totalDays);
        request.setAttribute("subtotalFee", subtotalFee);
        request.setAttribute("platformCommission", platformCommission);
        request.setAttribute("ownerPayout", ownerPayout);

        request.getRequestDispatcher("/WEB-INF/views/customer/checkoutSummary.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-13.2 Step 3: Insert Pending Booking & Redirect to VNPAY Sandbox
    // =========================================================================
    private void handleCheckoutConfirmationAndPay(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String carIdStr = request.getParameter("carId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        int carId;
        try {
            carId = Integer.parseInt(carIdStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/cars");
            return;
        }

        LocalDateTime startDate = parseDateTime(startDateStr);
        LocalDateTime endDate = parseDateTime(endDateStr);

        if (!validateBookingDate(startDate, endDate) || !bookingDAO.checkAvailability(carId, startDate, endDate)) {
            request.getSession(true).setAttribute("toastErrorMsg",
                    "Car not ready or invalid date information.");
            response.sendRedirect(request.getContextPath() + "/cars?action=detail&carId=" + carId);
            return;
        }

        Car car = carDAO.getCarById(carId);
        long days = ChronoUnit.DAYS.between(startDate.toLocalDate(), endDate.toLocalDate());
        int totalDays = (int) Math.max(days, 1);

        BigDecimal subtotalFee = car.getPricePerDay().multiply(new BigDecimal(totalDays));
        BigDecimal platformCommission = subtotalFee.multiply(new BigDecimal("0.10"));
        BigDecimal ownerPayout = subtotalFee.multiply(new BigDecimal("0.90"));

        Booking newBooking = new Booking();
        newBooking.setCustomerId(user.getUserId());
        newBooking.setCarId(carId);
        newBooking.setStartDate(startDate);
        newBooking.setEndDate(endDate);
        newBooking.setTotalDays(totalDays);
        newBooking.setSubtotalFee(subtotalFee);
        newBooking.setPlatformCommission(platformCommission);
        newBooking.setOwnerPayout(ownerPayout);
        newBooking.setStatus("Pending Payment");

        // Insert row using Statement.RETURN_GENERATED_KEYS routine
        int bookingId = bookingDAO.insertBooking(newBooking);

        if (bookingId > 0) {
            bookingHistoryDAO.insertHistory(bookingId, user.getUserId(), "Pending Payment",
                    "Order Initialized. Waiting for VNPAY Payment.");
            String paymentUrl = paymentService.preprocessPayment(bookingId, subtotalFee, "vnpay",
                    request.getContextPath());
            response.sendRedirect(paymentUrl);
        } else {
            request.getSession(true).setAttribute("toastErrorMsg", "Order creation failed.");
            response.sendRedirect(request.getContextPath() + "/cars?action=detail&carId=" + carId);
        }
    }

    // =========================================================================
    // UC-13.2 Step 4: VNPAY IPN / Callback Handler
    // =========================================================================
    private void handleVNPAYCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean isVerified = paymentService.verifyPayment(request.getParameterMap());
        int bookingId = paymentService.parseBookingId(request.getParameterMap());

        if (bookingId <= 0) {
            request.getSession(true).setAttribute("toastErrorMsg",
                    "Payment failed, order information not found.");
            response.sendRedirect(request.getContextPath() + "/customer/bookings?action=list");
            return;
        }

        Booking booking = bookingDAO.getBookingById(bookingId);

        String txnRef = request.getParameter("vnp_TransactionNo");
        if (txnRef == null || txnRef.isEmpty()) {
            txnRef = "VNP" + System.currentTimeMillis();
        }

        if (isVerified && booking != null) {
            // BR21: 100% Online Payment Successful
            bookingDAO.updateStatus(bookingId, "Paid");
            bookingHistoryDAO.insertHistory(bookingId, booking.getCustomerId(), "Paid", "Payment Success 100%");

            // Insert Payment table record
            Payment paymentRecord = new Payment(bookingId, booking.getSubtotalFee(), "VNPAY", txnRef, "Paid");
            paymentDAO.insertPayment(paymentRecord);

            notificationService.sendBookingConfirmation(booking.getCustomerId(), bookingId);
            notificationService.sendBookingToOwner(booking.getOwnerId(), bookingId);

            request.getSession(true).setAttribute("toastSuccessMsg", "Booking and payment via VNPay successful!");
        } else {
            // Payment Mismatch or Cancelled
            bookingDAO.updateStatus(bookingId, "Cancelled");
            if (booking != null) {
                bookingHistoryDAO.insertHistory(bookingId, booking.getCustomerId(), "Cancelled", "Payment Failed");
                Payment paymentRecord = new Payment(bookingId, booking.getSubtotalFee(), "VNPAY", txnRef, "Failed");
                paymentDAO.insertPayment(paymentRecord);
            }
            request.getSession(true).setAttribute("toastErrorMsg", "Payment failed.");
        }

        response.sendRedirect(request.getContextPath() + "/customer/bookings?action=list");
    }

    // =========================================================================
    // UC-13.3: Cancel My Car Bookings (Automated Refund Engine)
    // =========================================================================
    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String bookingIdStr = request.getParameter("bookingId");
        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdStr);
        } catch (Exception e) {
            request.getSession(true).setAttribute("toastErrorMsg", "Invalid order number.");
            response.sendRedirect(request.getContextPath() + "/customer/bookings?action=list");
            return;
        }

        Booking booking = bookingDAO.getBookingById(bookingId);

        // BR25 (Booking Ownership Check)
        if (booking == null || booking.getCustomerId() != user.getUserId()) {
            request.getSession(true).setAttribute("toastErrorMsg", "You do not have permission to perform this action.");
            response.sendRedirect(request.getContextPath() + "/customer/bookings?action=list");
            return;
        }

        // BR26 & BR30: Invalid Cancellation Prevention
        if ("Cancelled".equalsIgnoreCase(booking.getStatus()) || "Refunded".equalsIgnoreCase(booking.getStatus())
                || "Completed".equalsIgnoreCase(booking.getStatus())) {
            request.getSession(true).setAttribute("toastErrorMsg",
                    "The order has been cancelled or cannot be refunded.");
            response.sendRedirect(request.getContextPath() + "/customer/bookings?action=list");
            return;
        }

        // Calculate hours until planned pick-up reservation date
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime pickupDate = booking.getStartDate();
        long hoursUntilPickup = ChronoUnit.HOURS.between(now, pickupDate);

        // Scenario A: Eligible for Refund (At least 1 hour prior to pickup)
        if (hoursUntilPickup >= 1 && "Paid".equalsIgnoreCase(booking.getStatus())) {
            boolean refundOk = paymentService.processRefund(String.valueOf(bookingId), booking.getSubtotalFee());
            if (refundOk) {
                bookingDAO.updateStatus(bookingId, "Refunded");
                bookingHistoryDAO.insertHistory(bookingId, user.getUserId(), "Refunded", "Cancelled & Refunded");
                paymentDAO.updatePaymentStatus(bookingId, "Refunded");
                notificationService.sendCancelNotification(user.getUserId(), booking.getOwnerId(), bookingId);

                request.getSession(true).setAttribute("toastSuccessMsg", "Cancellation successful! The amount has been refunded.");
            } else {
                bookingDAO.updateStatus(bookingId, "Cancelled");
                bookingHistoryDAO.insertHistory(bookingId, user.getUserId(), "Cancelled", "Cancelled - Refund Failed");
                request.getSession(true).setAttribute("toastErrorMsg",
                        "Order cancellation successful, but an issue occurred with the automatic refund.");
            }
        } else {
            // Scenario B: Not Eligible for Refund (Cancelled under 1 hour notice or unpaid)
            bookingDAO.updateStatus(bookingId, "Cancelled");
            bookingHistoryDAO.insertHistory(bookingId, user.getUserId(), "Cancelled", "Cancelled - No Refund");
            notificationService.sendCancelNotification(user.getUserId(), booking.getOwnerId(), bookingId);

            request.getSession(true).setAttribute("toastSuccessMsg",
                    "Cancellation successful! The trip is not eligible for a refund.");
        }

        response.sendRedirect(request.getContextPath() + "/customer/bookings?action=list");
    }

    // =========================================================================
    // Staff Back-Office Handlers (UC-18)
    // =========================================================================
    private void handleStaffGetRouting(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/staff");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 2 && user.getRoleId() != 4) {
            request.getSession(true).setAttribute("toastErrorMsg", "Access denied.");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        String action = request.getParameter("action");

        int page = 1;
        int size = 10;
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("size") != null) {
                size = Integer.parseInt(request.getParameter("size"));
            }
        } catch (NumberFormatException ignored) {
        }

        int offset = (page - 1) * size;
        int totalRecords = 0;
        List<Booking> list;

        if ("search".equalsIgnoreCase(action)) {
            String kw = request.getParameter("keyword");
            if (kw == null) {
                kw = "";
            }
            list = bookingDAO.searchByKeyword(kw, offset, size);
            totalRecords = bookingDAO.countSearchByKeyword(kw);
            request.setAttribute("keywordVal", kw);
        } else {
            list = bookingDAO.getAllCarBookings(offset, size);
            totalRecords = bookingDAO.countAllCarBookings();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / size);

        request.setAttribute("carBookingList", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", size);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.getRequestDispatcher("/WEB-INF/views/staff/carBookingList.jsp").forward(request, response);
    }

    private void handleStaffPostRouting(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/staff");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 2 && user.getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        String action = request.getParameter("action");
        if ("update".equalsIgnoreCase(action)) {
            try {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String newStatus = request.getParameter("status");
                String note = request.getParameter("note");

                bookingDAO.updateStatus(statusToValidString(newStatus), bookingId, user.getUserId(), "Pending", note);
                request.getSession(true).setAttribute("toastSuccessMsg", "Status updated successfully.");
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Staff status update failed", e);
            }
        }
        response.sendRedirect(request.getContextPath() + "/staff/bookings?action=list");
    }

    // =========================================================================
    // Helper Methods
    // =========================================================================
    private boolean validateBookingDate(LocalDateTime startDate, LocalDateTime endDate) {
        if (startDate == null || endDate == null) {
            return false;
        }
        LocalDateTime now = LocalDateTime.now().minusMinutes(5); // 5 min buffer for network latency
        return !startDate.isBefore(now) && endDate.isAfter(startDate);
    }

    private LocalDateTime parseDateTime(String dtStr) {
        if (dtStr == null || dtStr.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalDateTime.parse(dtStr.trim(), DATE_TIME_FORMATTER);
        } catch (Exception e) {
            try {
                return LocalDateTime.parse(dtStr.trim() + "T00:00");
            } catch (Exception ex) {
                return null;
            }
        }
    }

    private String statusToValidString(String s) {
        return s != null ? s.trim() : "Pending Payment";
    }
}
