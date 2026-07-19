package controller;

import dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Feedback;
import model.User;

import java.io.IOException;
import java.util.List;

/**
 * Controller servlet for Car Owner to view customer ratings/reviews
 * and submit owner responses/replies.
 */
@WebServlet(name = "OwnerFeedbackController", urlPatterns = {"/owner/feedbacks"})
public class OwnerFeedbackController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/owner");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 3 && user.getRoleId() != 4) { // Role 3 or 4 = Owner
            response.sendRedirect(request.getContextPath() + "/login/owner");
            return;
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbacks = feedbackDAO.getFeedbacksByOwnerId(user.getUserId());

        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/WEB-INF/views/owner/feedbacksOwner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/owner");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 3 && user.getRoleId() != 4) {
            response.sendRedirect(request.getContextPath() + "/login/owner");
            return;
        }

        String feedbackIdStr = request.getParameter("feedbackId");
        String ownerReply = request.getParameter("ownerReply");

        if (feedbackIdStr != null && !feedbackIdStr.trim().isEmpty()) {
            try {
                int feedbackId = Integer.parseInt(feedbackIdStr.trim());
                FeedbackDAO feedbackDAO = new FeedbackDAO();
                Feedback fb = feedbackDAO.getFeedbackById(feedbackId);

                // 24-hour restriction on editing owner response
                if (fb != null && fb.getOwnerReply() != null && !fb.getOwnerReply().trim().isEmpty()) {
                    java.time.LocalDateTime replyTime = (fb.getUpdatedAt() != null) ? fb.getUpdatedAt() : fb.getCreatedAt();
                    if (replyTime != null) {
                        long hours = java.time.Duration.between(replyTime, java.time.LocalDateTime.now()).toHours();
                        if (hours >= 24) {
                            session.setAttribute("toastErrorMsg", "Owner response can only be edited within 24 hours of publication.");
                            response.sendRedirect(request.getContextPath() + "/owner/feedbacks");
                            return;
                        }
                    }
                }

                boolean success = feedbackDAO.updateOwnerReply(feedbackId, ownerReply);

                if (success) {
                    session.setAttribute("toastSuccessMsg", "Your response has been published successfully!");
                } else {
                    session.setAttribute("toastErrorMsg", "Failed to update response.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("toastErrorMsg", "Invalid feedback ID.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/owner/feedbacks");
    }
}
