package controller;

import dao.CarDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Car;
import model.CarType;
import model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller servlet for Owner Car operations (UC-15.1 to UC-15.6).
 * Scoped to Owner role (role_id = 3).
 */
@WebServlet(name = "MyCarController", urlPatterns = { "/owner/cars" })
public class MyCarController extends HttpServlet {

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

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "register":
                showRegisterForm(request, response);
                break;
            case "detail":
                showCarDetail(request, response, user);
                break;
            case "search":
                handleOwnerSearch(request, response, user);
                break;
            case "list":
            default:
                handleOwnerCarList(request, response, user);
                break;
        }
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

        if ("register".equalsIgnoreCase(action)) {
            processRegisterCar(request, response, user);
        } else if ("update".equalsIgnoreCase(action)) {
            processUpdateCar(request, response, user);
        } else if ("delete".equalsIgnoreCase(action)) {
            processDeleteCar(request, response, user);
        } else if ("uploadImage".equalsIgnoreCase(action)) {
            processUploadImage(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=list");
        }
    }

    private void processUploadImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String base64Data = request.getParameter("base64Image");
        if (base64Data == null || base64Data.isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"No image data provided\"}");
            return;
        }

        try {
            String[] parts = base64Data.split(",");
            String imageString = parts.length > 1 ? parts[1] : parts[0];
            byte[] imageBytes = java.util.Base64.getDecoder().decode(imageString);

            // Create uploads directory in Tomcat deployment
            String uploadPath = request.getServletContext().getRealPath("") + java.io.File.separator + "uploads" + java.io.File.separator + "cars";
            java.io.File uploadDir = new java.io.File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Generate unique filename
            String fileName = "car_" + java.util.UUID.randomUUID().toString() + ".jpg";
            java.io.File file = new java.io.File(uploadDir, fileName);

            // Write to deployment directory
            try (java.io.FileOutputStream fos = new java.io.FileOutputStream(file)) {
                fos.write(imageBytes);
            }

            // Write to project source directory so it persists across rebuilds
            String sourcePath = "d:/SU26 07/SWD392/CarRental/src/main/webapp/uploads/cars";
            java.io.File sourceDir = new java.io.File(sourcePath);
            if (!sourceDir.exists()) {
                sourceDir.mkdirs();
            }
            java.io.File sourceFile = new java.io.File(sourceDir, fileName);
            try (java.io.FileOutputStream fosSource = new java.io.FileOutputStream(sourceFile)) {
                fosSource.write(imageBytes);
            }

            String relativeUrl = request.getContextPath() + "/uploads/cars/" + fileName;
            response.getWriter().write("{\"success\":true,\"imageUrl\":\"" + relativeUrl + "\"}");

        } catch (Exception e) {
            e.printStackTrace(); // In ra console để gỡ lỗi!
            response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    // =========================================================================
    // UC-15.1: View My Cars
    // =========================================================================
    private void handleOwnerCarList(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        CarDAO carDAO = new CarDAO();
        // BR37 – owner view restriction is applied inside CarDAO query
        List<Car> carList = carDAO.getCarsByOwner(user.getUserId());

        if (carList == null || carList.isEmpty()) {
            request.setAttribute("message", "No registered vehicles");
        } else {
            request.setAttribute("carList", carList);
        }
        request.getRequestDispatcher("/WEB-INF/views/owner/carList.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-15.2: Search My Cars
    // =========================================================================
    private void handleOwnerSearch(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Keyword cannot be blank.");
            handleOwnerCarList(request, response, user);
            return;
        }

        CarDAO carDAO = new CarDAO();
        // BR39 – Scopes keyword search strictly inside the owner's active collection
        List<Car> carList = carDAO.searchCars(user.getUserId(), keyword.trim());

        if (carList == null || carList.isEmpty()) {
            request.setAttribute("message", "No matching vehicle");
        } else {
            request.setAttribute("carList", carList);
        }
        request.setAttribute("keywordVal", keyword);
        request.getRequestDispatcher("/WEB-INF/views/owner/carList.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-15.3: Register Car
    // =========================================================================
    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CarType> carTypes = new CarDAO().getAllCarTypes();
        request.setAttribute("carTypes", carTypes);
        request.getRequestDispatcher("/WEB-INF/views/owner/registerCar.jsp").forward(request, response);
    }

    private void processRegisterCar(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String carName = request.getParameter("carName");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String priceStr = request.getParameter("pricePerDay");
        String typeIdStr = request.getParameter("typeId");
        String documentUrl = request.getParameter("documentUrl");
        String specsJson = request.getParameter("specsJson");
        String primaryImageUrl = request.getParameter("primaryImageUrl");

        // Simple validation
        BigDecimal price = BigDecimal.ZERO;
        int typeId = 0;
        try {
            price = new BigDecimal(priceStr);
            typeId = Integer.parseInt(typeIdStr);
        } catch (Exception ignored) {
        }

        String valError = validateCarDetails(carName, brand, model, licensePlate, price, documentUrl);
        if (valError != null) {
            request.setAttribute("errorMsg", valError);
            prefillRegisterForm(request, carName, brand, model, licensePlate, priceStr, typeIdStr, documentUrl,
                    specsJson, primaryImageUrl);
            showRegisterForm(request, response);
            return;
        }

        CarDAO carDAO = new CarDAO();
        // BR41: unique plate rule
        if (carDAO.checkDuplicateLicense(licensePlate)) {
            request.setAttribute("errorMsg", "License plate is already registered to another active vehicle.");
            prefillRegisterForm(request, carName, brand, model, licensePlate, priceStr, typeIdStr, documentUrl,
                    specsJson, primaryImageUrl);
            showRegisterForm(request, response);
            return;
        }

        Car car = new Car();
        car.setOwnerId(user.getUserId());
        car.setTypeId(typeId);
        car.setCarName(carName.trim());
        car.setBrand(brand.trim());
        car.setModel(model.trim());
        car.setLicensePlate(licensePlate.trim().toUpperCase());
        car.setPricePerDay(price);
        car.setDocumentUrl(documentUrl != null ? documentUrl.trim() : "");
        car.setPrimaryImageUrl(primaryImageUrl != null ? primaryImageUrl.trim() : "");
        car.setSpecsJson(specsJson != null ? specsJson.trim() : "");

        boolean success = carDAO.insertCar(car);

        if (success) {
            request.getSession(true).setAttribute("toastSuccessMsg", "Registration successful. Pending approval.");
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=list");
        } else {
            request.setAttribute("errorMsg", "Failed to register car. Try again.");
            prefillRegisterForm(request, carName, brand, model, licensePlate, priceStr, typeIdStr, documentUrl,
                    specsJson, primaryImageUrl);
            showRegisterForm(request, response);
        }
    }

    // =========================================================================
    // UC-15.4: View My Car Information
    // =========================================================================
    private void showCarDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=list");
            return;
        }

        int carId = Integer.parseInt(idParam);
        CarDAO carDAO = new CarDAO();

        // BR43: Owners can strictly view specs details of their own vehicles
        if (!carDAO.checkOwner(carId, user.getUserId())) {
            request.getSession(true).setAttribute("toastErrorMsg", "Access denied. You do not own this vehicle.");
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=list");
            return;
        }

        Car car = carDAO.getCarDetail(carId);
        List<model.Booking> history = carDAO.getRentalHistory(carId);
        List<CarType> carTypes = carDAO.getAllCarTypes();

        request.setAttribute("car", car);
        request.setAttribute("history", history);
        request.setAttribute("carTypes", carTypes);

        request.getRequestDispatcher("/WEB-INF/views/owner/carDetail.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-15.5: Update My Car Information
    // =========================================================================
    private void processUpdateCar(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String carIdStr = request.getParameter("carId");
        String carName = request.getParameter("carName");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String priceStr = request.getParameter("pricePerDay");
        String typeIdStr = request.getParameter("typeId");
        String documentUrl = request.getParameter("documentUrl");
        String specsJson = request.getParameter("specsJson");
        String primaryImageUrl = request.getParameter("primaryImageUrl");

        System.out.println("=== processUpdateCar DEBUG ===");
        System.out.println("carIdStr: " + carIdStr);
        System.out.println("carName: " + carName);
        System.out.println("brand: " + brand);
        System.out.println("model: " + model);
        System.out.println("licensePlate: " + licensePlate);
        System.out.println("priceStr: " + priceStr);
        System.out.println("typeIdStr: " + typeIdStr);
        System.out.println("documentUrl: " + documentUrl);
        System.out.println("specsJson: " + specsJson);
        System.out.println("primaryImageUrl: " + primaryImageUrl);
        System.out.println("==============================");

        int carId = Integer.parseInt(carIdStr);
        int typeId = Integer.parseInt(typeIdStr);

        CarDAO carDAO = new CarDAO();
        if (!carDAO.checkOwner(carId, user.getUserId())) {
            request.getSession(true).setAttribute("toastErrorMsg", "Access denied.");
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=list");
            return;
        }

        BigDecimal price = BigDecimal.ZERO;
        try {
            price = new BigDecimal(priceStr);
        } catch (Exception ignored) {
        }

        String valError = validateCarDetails(carName, brand, model, licensePlate, price, documentUrl);
        if (valError != null) {
            request.getSession(true).setAttribute("toastErrorMsg", valError);
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=detail&id=" + carId);
            return;
        }

        Car existing = carDAO.getCarDetail(carId);

        // If the license plate changes, check unique constraints (but check if status
        // is approved first)
        if (!"Available".equalsIgnoreCase(existing.getStatus())
                && !existing.getLicensePlate().equalsIgnoreCase(licensePlate.trim())) {
            if (carDAO.checkDuplicateLicense(licensePlate)) {
                request.getSession(true).setAttribute("toastErrorMsg", "Duplicate license plate error.");
                response.sendRedirect(request.getContextPath() + "/owner/cars?action=detail&id=" + carId);
                return;
            }
        }

        Car car = new Car();
        car.setCarId(carId);
        car.setTypeId(typeId);
        car.setCarName(carName.trim());
        car.setBrand(brand.trim());
        car.setModel(model.trim());
        // BR45: license plate is ignored on DB updates if status is Approved (handled
        // inside CarDAO.updateCar)
        car.setLicensePlate(licensePlate.trim().toUpperCase());
        car.setPricePerDay(price);
        car.setDocumentUrl(documentUrl != null ? documentUrl.trim() : "");
        car.setPrimaryImageUrl(primaryImageUrl != null ? primaryImageUrl.trim() : "");
        car.setSpecsJson(specsJson != null ? specsJson.trim() : "");

        boolean success = carDAO.updateCar(car);

        if (success) {
            request.getSession(true).setAttribute("toastSuccessMsg", "Update Successful.");
        } else {
            String errorMsg = "Update failed.";
            if (CarDAO.getLastError() != null) {
                errorMsg += " DB Error: " + CarDAO.getLastError();
            }
            request.getSession(true).setAttribute("toastErrorMsg", errorMsg);
        }
        response.sendRedirect(request.getContextPath() + "/owner/cars?action=detail&id=" + carId);
    }

    // =========================================================================
    // UC-15.6: Remove My Car
    // =========================================================================
    private void processDeleteCar(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String idParam = request.getParameter("carId");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=list");
            return;
        }

        int carId = Integer.parseInt(idParam);
        CarDAO carDAO = new CarDAO();

        if (!carDAO.checkOwner(carId, user.getUserId())) {
            request.getSession(true).setAttribute("toastErrorMsg", "Access denied.");
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=list");
            return;
        }

        // BR46 – Block deletion if active bookings exist
        if (carDAO.checkActiveBooking(carId)) {
            request.getSession(true).setAttribute("toastErrorMsg", "Cannot remove: Active structural bookings exist.");
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=detail&id=" + carId);
            return;
        }

        boolean success = carDAO.removeCar(carId); // BR47, BR48 Soft Delete status update

        if (success) {
            request.getSession(true).setAttribute("toastSuccessMsg", "Vehicle removed successfully.");
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=list");
        } else {
            request.getSession(true).setAttribute("toastErrorMsg", "Failed to remove vehicle.");
            response.sendRedirect(request.getContextPath() + "/owner/cars?action=detail&id=" + carId);
        }
    }

    // Validation rules (BR40, BR44)
    private String validateCarDetails(String carName, String brand, String model, String licensePlate, BigDecimal price,
            String documentUrl) {
        if (carName == null || carName.trim().isEmpty() ||
                brand == null || brand.trim().isEmpty() ||
                model == null || model.trim().isEmpty() ||
                licensePlate == null || licensePlate.trim().isEmpty()) {
            return "Name, Brand, Model, and License Plate are mandatory.";
        }
        // BR40 – document url (no longer mandatory as per user request)
        // BR44 – price range
        if (price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
            return "Price per day must be strictly greater than zero (BR44).";
        }
        return null;
    }

    private void prefillRegisterForm(HttpServletRequest request, String carName, String brand, String model,
            String licensePlate, String priceStr, String typeIdStr, String documentUrl, String specsJson, String primaryImageUrl) {
        request.setAttribute("carNameVal", carName);
        request.setAttribute("brandVal", brand);
        request.setAttribute("modelVal", model);
        request.setAttribute("licensePlateVal", licensePlate);
        request.setAttribute("priceVal", priceStr);
        request.setAttribute("typeIdVal", typeIdStr);
        request.setAttribute("documentUrlVal", documentUrl);
        request.setAttribute("specsJsonVal", specsJson);
        request.setAttribute("primaryImageUrlVal", primaryImageUrl);
    }
}
