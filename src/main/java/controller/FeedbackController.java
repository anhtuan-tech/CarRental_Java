package controller;

import dao.CarDAO;
import dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Car;
import model.Feedback;
import model.User;

import java.io.IOException;
import java.util.List;

/**
 * Controller servlet handling Customer Feedback lifecycle (UC-14.1 to UC-14.5)
 * and AJAX offset reviews loading (UC-11).
 */
@WebServlet(name = "FeedbackController", urlPatterns = {"/feedback"})
public class FeedbackController extends HttpServlet {

    private static final int FEEDBACK_LIMIT = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if this is the UC-11 AJAX request
        String offsetParam = request.getParameter("offset");
        if (offsetParam != null) {
            handleAjaxReviewsLoad(request, response);
            return;
        }

        // Customer Session Verification (BR71)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/customer");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                showCreateForm(request, response, user);
                break;
            case "detail":
                showFeedbackDetail(request, response, user);
                break;
            case "edit":
                showEditForm(request, response, user);
                break;
            case "list":
            default:
                showFeedbackList(request, response, user);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/customer");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            processCreateFeedback(request, response, user);
        } else if ("edit".equalsIgnoreCase(action)) {
            processUpdateFeedback(request, response, user);
        } else if ("delete".equalsIgnoreCase(action)) {
            processDeleteFeedback(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/feedback?action=list");
        }
    }

    // =========================================================================
    // UC-11: AJAX Reviews Loader
    // =========================================================================
    private void handleAjaxReviewsLoad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String carIdParam = request.getParameter("carId");
        String offsetParam = request.getParameter("offset");

        if (carIdParam == null || offsetParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters.");
            return;
        }

        int carId;
        int offset;
        try {
            carId = Integer.parseInt(carIdParam);
            offset = Integer.parseInt(offsetParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters.");
            return;
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbacks = feedbackDAO.getFeedbackByCarId(carId, offset, FEEDBACK_LIMIT);

        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/WEB-INF/views/customer/feedbackList.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-14.1: View My Feedbacks
    // =========================================================================
    private void showFeedbackList(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        // BR63 – customer ownership constraint inside DAO SELECT
        List<Feedback> feedbacks = feedbackDAO.getFeedbacksByCustomerID(user.getUserId());

        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/WEB-INF/views/customer/feedbacksCustomer.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-14.2: Create My Feedback
    // =========================================================================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String carIdParam = request.getParameter("carId");
        if (carIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/cars");
            return;
        }

        int carId;
        try {
            carId = Integer.parseInt(carIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cars");
            return;
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        // BR58 & BR59: eligibility checks
        int bookingId = feedbackDAO.checkValidToFeedback(carId, user.getUserId());

        if (bookingId == -1) {
            // Unauthorised or already reviewed -> redirect back to car specs with error toast
            request.getSession(true).setAttribute("toastErrorMsg", "You can only review a vehicle after completing a transaction, limited to one feedback per transaction.");
            response.sendRedirect(request.getContextPath() + "/cars?action=detail&id=" + carId);
            return;
        }

        Car car = new CarDAO().getCarById(carId);
        request.setAttribute("car", car);
        request.setAttribute("bookingId", bookingId);

        request.getRequestDispatcher("/WEB-INF/views/customer/feedbackForm.jsp").forward(request, response);
    }

    private void processCreateFeedback(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String carIdStr = request.getParameter("carId");
        String bookingIdStr = request.getParameter("bookingId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        int carId = Integer.parseInt(carIdStr);
        int bookingId = Integer.parseInt(bookingIdStr);

        int rating = 0;
        try {
            rating = Integer.parseInt(ratingStr);
        } catch (NumberFormatException ignored) {}

        // BR60 & BR61: validate ranges
        String valError = validateFeedbackData(rating, comment);
        if (valError != null) {
            request.setAttribute("errorMsg", valError);
            request.setAttribute("car", new CarDAO().getCarById(carId));
            request.setAttribute("bookingId", bookingId);
            request.setAttribute("ratingVal", ratingStr);
            request.setAttribute("commentVal", comment);
            request.getRequestDispatcher("/WEB-INF/views/customer/feedbackForm.jsp").forward(request, response);
            return;
        }

        Feedback feedback = new Feedback();
        feedback.setBookingId(bookingId);
        feedback.setCustomerId(user.getUserId());
        feedback.setRating(rating);
        feedback.setComment(comment.trim());
        feedback.setOwnerReply(null);

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        boolean success = feedbackDAO.insertFeedback(feedback);

        if (success) {
            // Find newly created feedback by searching customer's list (take top 1)
            List<Feedback> list = feedbackDAO.getFeedbacksByCustomerID(user.getUserId());
            int newFeedbackId = list.get(0).getFeedbackId();
            request.getSession(true).setAttribute("toastSuccessMsg", "Feedback submitted successfully.");
            response.sendRedirect(request.getContextPath() + "/feedback?action=detail&id=" + newFeedbackId);
        } else {
            request.setAttribute("errorMsg", "Failed to submit feedback. Try again.");
            request.setAttribute("car", new CarDAO().getCarById(carId));
            request.setAttribute("bookingId", bookingId);
            request.getRequestDispatcher("/WEB-INF/views/customer/feedbackForm.jsp").forward(request, response);
        }
    }

    // =========================================================================
    // UC-14.3: View My Feedback Details
    // =========================================================================
    private void showFeedbackDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/feedback?action=list");
            return;
        }

        int feedbackId = Integer.parseInt(idParam);
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

        if (feedback == null || feedback.getCustomerId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/feedback?action=list");
            return;
        }

        Car car = new CarDAO().getCarById(feedback.getCarId());

        request.setAttribute("feedback", feedback);
        request.setAttribute("car", car);
        request.getRequestDispatcher("/WEB-INF/views/customer/feedbacksDetailCustomer.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-14.4: Update My Feedback
    // =========================================================================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/feedback?action=list");
            return;
        }

        int feedbackId = Integer.parseInt(idParam);
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

        // Security check: must own the feedback
        if (feedback == null || feedback.getCustomerId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/feedback?action=list");
            return;
        }

        Car car = new CarDAO().getCarById(feedback.getCarId());
        request.setAttribute("feedback", feedback);
        request.setAttribute("car", car);
        request.getRequestDispatcher("/WEB-INF/views/customer/updateFeedbackForm.jsp").forward(request, response);
    }

    private void processUpdateFeedback(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String feedbackIdStr = request.getParameter("feedbackId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        int feedbackId = Integer.parseInt(feedbackIdStr);
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

        if (feedback == null || feedback.getCustomerId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/feedback?action=list");
            return;
        }

        int rating = 0;
        try {
            rating = Integer.parseInt(ratingStr);
        } catch (NumberFormatException ignored) {}

        String valError = validateFeedbackData(rating, comment);
        if (valError != null) {
            request.setAttribute("errorMsg", valError);
            request.setAttribute("feedback", feedback);
            request.setAttribute("car", new CarDAO().getCarById(feedback.getCarId()));
            request.getRequestDispatcher("/WEB-INF/views/customer/updateFeedbackForm.jsp").forward(request, response);
            return;
        }

        feedback.setRating(rating);
        feedback.setComment(comment.trim());

        boolean success = feedbackDAO.updateFeedback(feedback);

        if (success) {
            request.getSession(true).setAttribute("toastSuccessMsg", "Update completed.");
            response.sendRedirect(request.getContextPath() + "/feedback?action=detail&id=" + feedbackId);
        } else {
            request.setAttribute("errorMsg", "Failed to update feedback.");
            request.setAttribute("feedback", feedback);
            request.setAttribute("car", new CarDAO().getCarById(feedback.getCarId()));
            request.getRequestDispatcher("/WEB-INF/views/customer/updateFeedbackForm.jsp").forward(request, response);
        }
    }

    // =========================================================================
    // UC-14.5: Delete My Feedback
    // =========================================================================
    private void processDeleteFeedback(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/feedback?action=list");
            return;
        }

        int feedbackId = Integer.parseInt(idParam);
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

        // Security check (BR71, BR72)
        if (feedback == null || feedback.getCustomerId() != user.getUserId()) {
            request.getSession(true).setAttribute("toastErrorMsg", "Deleted false.");
            response.sendRedirect(request.getContextPath() + "/feedback?action=list");
            return;
        }

        boolean success = feedbackDAO.deleteFeedback(feedbackId);

        if (success) {
            request.getSession(true).setAttribute("toastSuccessMsg", "Deleted success.");
        } else {
            request.getSession(true).setAttribute("toastErrorMsg", "Deleted false.");
        }
        response.sendRedirect(request.getContextPath() + "/feedback?action=list");
    }

    // Helper validation
    private String validateFeedbackData(int rating, String comment) {
        if (rating < 1 || rating > 5) {
            return "Rating must be an integer between 1 and 5 (BR60).";
        }
        if (comment == null || comment.trim().isEmpty()) {
            return "Feedback comment text cannot be empty.";
        }
        if (comment.trim().length() > 500) { // arbitrary limit, satisfies BR61
            return "Feedback text must not exceed 500 characters limit.";
        }
        return null;
    }
}
