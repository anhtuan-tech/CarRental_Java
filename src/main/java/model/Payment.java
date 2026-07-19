package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Maps to the [Payment] table in the database schema.
 */
public class Payment {

    private int paymentId;
    private int bookingId;
    private BigDecimal amount;
    private String paymentMethod;
    private String transactionRef;
    private String paymentStatus;
    private LocalDateTime paidAt;

    public Payment() {}

    public Payment(int bookingId, BigDecimal amount, String paymentMethod, String transactionRef, String paymentStatus) {
        this.bookingId = bookingId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.transactionRef = transactionRef;
        this.paymentStatus = paymentStatus;
    }

    // --- Getters & Setters ---

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }
}
