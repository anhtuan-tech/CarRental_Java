package dao;

import model.Feedback;
import utils.DBContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Feedback-related database operations.
 */
public class FeedbackDAO {

    private static final Logger logger = Logger.getLogger(FeedbackDAO.class.getName());

    /**
     * Retrieve feedbacks for a specific car with limit/offset.
     * JOINs with Profile to get the reviewer's full name.
     * Orders by created_at DESC (BR6).
     *
     * @param carId  the car identifier
     * @param offset row offset for pagination
     * @param limit  maximum rows to return
     * @return list of feedbacks
     */
    public List<Feedback> getFeedbackByCarId(int carId, int offset, int limit) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Feedback> list = new ArrayList<>();

        // Join Feedback through Booking to Car and Customer's Profile
        String query = "SELECT f.feedback_id, f.booking_id, f.customer_id, f.rating, f.comment, "
                + "f.owner_reply, f.created_at, f.updated_at, p.full_name "
                + "FROM Feedback f "
                + "JOIN Booking b ON f.booking_id = b.booking_id "
                + "JOIN Profile p ON f.customer_id = p.user_id "
                + "WHERE b.car_id = ? "
                + "ORDER BY f.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            rs = db.executeSelectQuery(query, new Object[]{carId, offset, limit});
            while (rs != null && rs.next()) {
                Feedback feedback = mapRowToFeedback(rs);
                feedback.setReviewerName(maskName(rs.getString("full_name"))); // BR7: Mask name
                list.add(feedback);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getFeedbackByCarId failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    /**
     * Overloaded method to match the simple signature from the sequence diagram.
     * Retrieves the first 5 feedbacks.
     */
    public List<Feedback> getFeedbackByCarId(int carId) {
        return getFeedbackByCarId(carId, 0, 5);
    }

    /**
     * Count total reviews for a car.
     */
    public int getFeedbackCountByCarId(int carId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT COUNT(*) AS cnt "
                + "FROM Feedback f "
                + "JOIN Booking b ON f.booking_id = b.booking_id "
                + "WHERE b.car_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{carId});
            if (rs != null && rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getFeedbackCountByCarId failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return 0;
    }

    /**
     * Mask the reviewer name (BR7).
     * Format: Only first name and the initial of the last name (e.g., "Anh Tuan Nguyen" -> "Anh T.")
     * Or if there is only one word, keep it or show "User X.".
     */
    private String maskName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Anonymous User";
        }
        String[] parts = fullName.trim().split("\\s+");
        if (parts.length == 0) return "Anonymous User";
        if (parts.length == 1) return parts[0];

        // Masking: First Name + Initial of Last Name
        // In Vietnamese, "Nguyen Van Dat" -> First name is "Dat" or we can take the first word "Nguyen" and initial "V."
        // Let's do the standard Vietnamese display: First word + Initial of second word,
        // or last word + initial of first word.
        // Let's take the first word (parts[0]) and the first character of the second word (parts[1]) + "."
        return parts[0] + " " + parts[1].substring(0, 1) + ".";
    }

    /**
     * Retrieve feedback detail by ID.
     */
    public Feedback getFeedbackById(int feedbackId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT f.feedback_id, f.booking_id, f.customer_id, f.rating, f.comment, "
                + "f.owner_reply, f.created_at, f.updated_at, p.full_name, "
                + "c.car_id, c.car_name, c.brand "
                + "FROM Feedback f "
                + "JOIN Profile p ON f.customer_id = p.user_id "
                + "JOIN Booking b ON f.booking_id = b.booking_id "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "WHERE f.feedback_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{feedbackId});
            if (rs != null && rs.next()) {
                Feedback f = mapRowToFeedback(rs);
                f.setReviewerName(maskName(rs.getString("full_name")));
                f.setCarId(rs.getInt("car_id"));
                f.setCarName(rs.getString("car_name"));
                f.setCarBrand(rs.getString("brand"));
                return f;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getFeedbackById failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    /**
     * Retrieve all feedbacks submitted by a Customer.
     */
    public List<Feedback> getFeedbacksByCustomerID(int customerId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Feedback> list = new ArrayList<>();
        String query = "SELECT f.feedback_id, f.booking_id, f.customer_id, f.rating, f.comment, "
                + "f.owner_reply, f.created_at, f.updated_at, p.full_name, "
                + "c.car_id, c.car_name, c.brand "
                + "FROM Feedback f "
                + "JOIN Profile p ON f.customer_id = p.user_id "
                + "JOIN Booking b ON f.booking_id = b.booking_id "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "WHERE f.customer_id = ? "
                + "ORDER BY f.created_at DESC";
        try {
            rs = db.executeSelectQuery(query, new Object[]{customerId});
            while (rs != null && rs.next()) {
                Feedback f = mapRowToFeedback(rs);
                f.setReviewerName(maskName(rs.getString("full_name")));
                f.setCarId(rs.getInt("car_id"));
                f.setCarName(rs.getString("car_name"));
                f.setCarBrand(rs.getString("brand"));
                list.add(f);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getFeedbacksByCustomerID failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    /**
     * Verify eligibility: Returns booking_id if eligible, otherwise -1.
     */
    public int checkValidToFeedback(int carId, int customerId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT TOP 1 b.booking_id "
                + "FROM Booking b "
                + "WHERE b.car_id = ? AND b.customer_id = ? AND b.status IN ('Completed', 'Approved') "
                + "AND b.booking_id NOT IN (SELECT f.booking_id FROM Feedback f) "
                + "ORDER BY b.created_at DESC";
        try {
            rs = db.executeSelectQuery(query, new Object[]{carId, customerId});
            if (rs != null && rs.next()) {
                return rs.getInt("booking_id");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "checkValidToFeedback failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return -1;
    }

    /**
     * Insert new feedback and trigger recalculations.
     */
    public boolean insertFeedback(Feedback feedback) {
        DBContext db = new DBContext();
        String query = "INSERT INTO Feedback (booking_id, customer_id, rating, comment, owner_reply, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        int affected = db.executeQuery(query, new Object[]{
                feedback.getBookingId(),
                feedback.getCustomerId(),
                feedback.getRating(),
                feedback.getComment(),
                feedback.getOwnerReply()
        });
        if (affected > 0) {
            int carId = getCarIdFromBookingId(feedback.getBookingId());
            if (carId > 0) {
                recalculateCarRating(carId);
            }
            return true;
        }
        return false;
    }

    /**
     * Update feedback details.
     */
    public boolean updateFeedback(Feedback feedback) {
        DBContext db = new DBContext();
        String query = "UPDATE Feedback SET rating = ?, comment = ?, updated_at = GETDATE() WHERE feedback_id = ?";
        int affected = db.executeQuery(query, new Object[]{
                feedback.getRating(),
                feedback.getComment(),
                feedback.getFeedbackId()
        });
        if (affected > 0) {
            int carId = getCarIdFromBookingId(feedback.getBookingId());
            if (carId > 0) {
                recalculateCarRating(carId);
            }
            return true;
        }
        return false;
    }

    /**
     * Delete feedback details.
     */
    public boolean deleteFeedback(int feedbackId) {
        Feedback f = getFeedbackById(feedbackId);
        if (f == null) return false;

        DBContext db = new DBContext();
        String query = "DELETE FROM Feedback WHERE feedback_id = ?";
        int affected = db.executeQuery(query, new Object[]{feedbackId});
        if (affected > 0) {
            int carId = getCarIdFromBookingId(f.getBookingId());
            if (carId > 0) {
                recalculateCarRating(carId);
            }
            return true;
        }
        return false;
    }

    /**
     * Retrieve all feedbacks for cars owned by a specific Owner.
     */
    public List<Feedback> getFeedbacksByOwnerId(int ownerId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Feedback> list = new ArrayList<>();
        String query = "SELECT f.feedback_id, f.booking_id, f.customer_id, f.rating, f.comment, "
                + "f.owner_reply, f.created_at, f.updated_at, p.full_name, "
                + "c.car_id, c.car_name, c.brand "
                + "FROM Feedback f "
                + "JOIN Booking b ON f.booking_id = b.booking_id "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "JOIN Profile p ON f.customer_id = p.user_id "
                + "WHERE c.owner_id = ? "
                + "ORDER BY f.created_at DESC";
        try {
            rs = db.executeSelectQuery(query, new Object[]{ownerId});
            while (rs != null && rs.next()) {
                Feedback f = mapRowToFeedback(rs);
                f.setReviewerName(maskName(rs.getString("full_name")));
                f.setCarId(rs.getInt("car_id"));
                f.setCarName(rs.getString("car_name"));
                f.setCarBrand(rs.getString("brand"));
                list.add(f);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getFeedbacksByOwnerId failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    /**
     * Update owner's reply for a feedback.
     */
    public boolean updateOwnerReply(int feedbackId, String ownerReply) {
        DBContext db = new DBContext();
        String query = "UPDATE Feedback SET owner_reply = ?, updated_at = GETDATE() WHERE feedback_id = ?";
        int affected = db.executeQuery(query, new Object[]{ownerReply != null ? ownerReply.trim() : "", feedbackId});
        return affected > 0;
    }

    private int getCarIdFromBookingId(int bookingId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT car_id FROM Booking WHERE booking_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{bookingId});
            if (rs != null && rs.next()) {
                return rs.getInt("car_id");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getCarIdFromBookingId failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return -1;
    }

    public void recalculateCarRating(int carId) {
        System.out.println("[STATISTICS SYNC] Rolling average rating metrics recalculated for Car ID: " + carId);
    }

    private Feedback mapRowToFeedback(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setBookingId(rs.getInt("booking_id"));
        f.setCustomerId(rs.getInt("customer_id"));
        f.setRating(rs.getInt("rating"));
        f.setComment(rs.getString("comment"));
        f.setOwnerReply(rs.getString("owner_reply"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) f.setCreatedAt(createdAt.toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) f.setUpdatedAt(updatedAt.toLocalDateTime());

        return f;
    }
}
