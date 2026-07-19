package controller;

import dao.CarDAO;
import dao.FeedbackDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Car;
import model.CarImage;
import model.CarType;
import model.Feedback;
import model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller servlet for Car-related operations (UC-08, UC-09, UC-10).
 */
@WebServlet(name = "CarController", urlPatterns = {"/cars", "/staff/cars"})
public class CarController extends HttpServlet {

    private static final int PAGE_SIZE = 12;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String servletPath = request.getServletPath();
        if ("/staff/cars".equals(servletPath)) {
            doGetStaff(request, response);
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                handleCarDetail(request, response);
                break;
            case "search":
                handleCarSearch(request, response);
                break;
            case "list":
            default:
                handleCarList(request, response);
                break;
        }
    }

    private void handleCarList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CarDAO carDAO = new CarDAO();

        // Get page index
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalCars = carDAO.getAvailableCarCount();
        int totalPages = (int) Math.ceil((double) totalCars / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * PAGE_SIZE;
        List<Car> cars = carDAO.getAvailableCar(offset, PAGE_SIZE);
        List<CarType> carTypes = carDAO.getAllCarTypes();

        request.setAttribute("cars", cars);
        request.setAttribute("totalCars", totalCars);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("carTypes", carTypes);

        request.getRequestDispatcher("/WEB-INF/views/customer/carList.jsp").forward(request, response);
    }

    private void handleCarDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/cars");
            return;
        }

        int carId;
        try {
            carId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cars");
            return;
        }

        CarDAO carDAO = new CarDAO();
        Car car = carDAO.getCarById(carId);

        if (car == null) {
            response.sendRedirect(request.getContextPath() + "/cars");
            return;
        }

        // Retrieve related entities
        List<CarImage> carImages = carDAO.getCarImage(carId);
        List<Feedback> feedbacks = new FeedbackDAO().getFeedbackByCarId(carId, 0, 5); // Load up to 5 initially
        int totalFeedbacks = new FeedbackDAO().getFeedbackCountByCarId(carId);

        // Populate details
        request.setAttribute("car", car);
        request.setAttribute("carImages", carImages);
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("totalFeedbacks", totalFeedbacks);

        request.getRequestDispatcher("/WEB-INF/views/customer/carDetail.jsp").forward(request, response);
    }

    private void handleCarSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CarDAO carDAO = new CarDAO();

        // Get filter inputs
        String searchVal = request.getParameter("query");
        String typeParam = request.getParameter("typeId");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");

        Integer typeId = null;
        if (typeParam != null && !typeParam.isEmpty()) {
            try {
                typeId = Integer.parseInt(typeParam);
            } catch (NumberFormatException ignored) {}
        }

        BigDecimal minPrice = null;
        if (minPriceParam != null && !minPriceParam.isEmpty()) {
            try {
                minPrice = new BigDecimal(minPriceParam);
            } catch (NumberFormatException ignored) {}
        }

        BigDecimal maxPrice = null;
        if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
            try {
                maxPrice = new BigDecimal(maxPriceParam);
            } catch (NumberFormatException ignored) {}
        }

        // Get page index
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalCars = carDAO.searchCarsCount(searchVal, typeId, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalCars / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * PAGE_SIZE;
        List<Car> cars = carDAO.searchCars(searchVal, typeId, minPrice, maxPrice, offset, PAGE_SIZE);
        List<CarType> carTypes = carDAO.getAllCarTypes();

        // Bind attributes
        request.setAttribute("cars", cars);
        request.setAttribute("totalCars", totalCars);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("carTypes", carTypes);

        // Pre-fill parameters in UI search widget
        request.setAttribute("queryVal", searchVal);
        request.setAttribute("typeIdVal", typeId);
        request.setAttribute("minPriceVal", minPriceParam);
        request.setAttribute("maxPriceVal", maxPriceParam);

        request.getRequestDispatcher("/WEB-INF/views/customer/carList.jsp").forward(request, response);
    }

    // =========================================================================
    // Staff/Admin Car Verification Module (UC-19)
    // =========================================================================
    protected void doGetStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/staff");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 2 && user.getRoleId() != 4) { // Staff or Admin only
            request.getSession(true).setAttribute("toastErrorMsg", "Access denied. Back-office credentials required.");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                showStaffCarDetail(request, response);
                break;
            case "search":
                handleStaffCarSearch(request, response);
                break;
            case "list":
            default:
                handleStaffCarList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        if (!"/staff/cars".equals(servletPath)) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

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
            processUpdateCarStatus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/cars?action=list");
        }
    }

    private void handleStaffCarList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CarDAO carDAO = new CarDAO();
        // BR83: Fetch all cars regardless of status
        List<Car> carList = carDAO.getAllCars();

        if (carList == null || carList.isEmpty()) {
            request.setAttribute("message", "No cars available");
        } else {
            request.setAttribute("carList", carList);
        }
        request.getRequestDispatcher("/WEB-INF/views/staff/staffCarList.jsp").forward(request, response);
    }

    private void showStaffCarDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/staff/cars?action=list");
            return;
        }

        int carId = Integer.parseInt(idParam);
        CarDAO carDAO = new CarDAO();
        Car car = carDAO.getCarDetails(carId);

        if (car == null) {
            request.setAttribute("message", "No car available");
        } else {
            request.setAttribute("carDetail", car);
        }
        request.getRequestDispatcher("/WEB-INF/views/staff/staffCarDetail.jsp").forward(request, response);
    }

    private void handleStaffCarSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/cars?action=list");
            return;
        }

        CarDAO carDAO = new CarDAO();
        // BR88: Master vehicle search scopes the entire database space
        List<Car> carList = carDAO.searchByKeyword(keyword.trim());

        if (carList == null || carList.isEmpty()) {
            request.getSession(true).setAttribute("toastErrorMsg", "No car found matching keyword");
            response.sendRedirect(request.getContextPath() + "/staff/cars?action=list");
            return;
        }

        request.setAttribute("carList", carList);
        request.setAttribute("keywordVal", keyword);
        request.getRequestDispatcher("/WEB-INF/views/staff/staffCarList.jsp").forward(request, response);
    }

    private void processUpdateCarStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String carIdStr = request.getParameter("carId");
        String targetStatus = request.getParameter("status");
        String reason = request.getParameter("reason");

        if (carIdStr == null || targetStatus == null) {
            response.sendRedirect(request.getContextPath() + "/staff/cars?action=list");
            return;
        }

        int carId = Integer.parseInt(carIdStr);
        CarDAO carDAO = new CarDAO();
        Car car = carDAO.getCarDetails(carId);

        if (car == null) {
            request.getSession(true).setAttribute("toastErrorMsg", "Vehicle not found.");
            response.sendRedirect(request.getContextPath() + "/staff/cars?action=list");
            return;
        }

        // BR85: Enforce that status mutations are only permitted if currently Pending_Approval
        if (!"Pending_Approval".equalsIgnoreCase(car.getStatus())) {
            request.setAttribute("errorMsg", "Transition locked: Vehicle status is not Pending Approval.");
            request.setAttribute("carDetail", car);
            request.getRequestDispatcher("/WEB-INF/views/staff/staffCarDetail.jsp").forward(request, response);
            return;
        }

        // BR86: If status is Rejected, a reason note is mandatory
        if ("Rejected".equalsIgnoreCase(targetStatus) && (reason == null || reason.trim().isEmpty())) {
            request.setAttribute("errorMsg", "Rejection reason is mandatory (BR86).");
            request.setAttribute("carDetail", car);
            request.getRequestDispatcher("/WEB-INF/views/staff/staffCarDetail.jsp").forward(request, response);
            return;
        }

        boolean success = carDAO.updateCarStatus(carId, targetStatus);

        if (success) {
            // BR87: Notify associated vehicle owner regarding outcome
            triggerOwnerNotification(car.getOwnerId(), carId, targetStatus, reason);
            request.getSession(true).setAttribute("toastSuccessMsg", "Registration status updated successfully.");
            response.sendRedirect(request.getContextPath() + "/staff/cars?action=detail&id=" + carId);
        } else {
            request.getSession(true).setAttribute("toastErrorMsg", "System update failed.");
            response.sendRedirect(request.getContextPath() + "/staff/cars?action=detail&id=" + carId);
        }
    }

    private void triggerOwnerNotification(int ownerId, int carId, String status, String reason) {
        System.out.println("[VERIFICATION NOTIFICATION] Alert owner ID: " + ownerId + " for Car ID: " + carId);
        System.out.println("[VERIFICATION NOTIFICATION] Resolution: " + status + (reason != null ? " Reason: " + reason : ""));
    }
}
