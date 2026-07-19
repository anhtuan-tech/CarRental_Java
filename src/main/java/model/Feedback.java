package model;

import java.time.LocalDateTime;

/**
 * Maps to the [Feedback] table in the CarRental database.
 */
public class Feedback {

    private int feedbackId;
    private int bookingId;
    private int customerId;
    private int rating;
    private String comment;
    private String ownerReply;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Transient fields from JOINs
    private String reviewerName; // Stores masked reviewer name (e.g. "Dat T.")
    private int carId;
    private String carName;
    private String carBrand;

    public Feedback() {}

    public Feedback(int feedbackId, int bookingId, int customerId, int rating,
                    String comment, String ownerReply, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.feedbackId = feedbackId;
        this.bookingId = bookingId;
        this.customerId = customerId;
        this.rating = rating;
        this.comment = comment;
        this.ownerReply = ownerReply;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // --- Getters & Setters ---

    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public String getOwnerReply() { return ownerReply; }
    public void setOwnerReply(String ownerReply) { this.ownerReply = ownerReply; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }

    public int getCarId() { return carId; }
    public void setCarId(int carId) { this.carId = carId; }

    public String getCarName() { return carName; }
    public void setCarName(String carName) { this.carName = carName; }

    public String getCarBrand() { return carBrand; }
    public void setCarBrand(String carBrand) { this.carBrand = carBrand; }
}
