package dao;

import model.Payment;
import utils.DBContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Payment database operations.
 */
public class PaymentDAO {

    private static final Logger logger = Logger.getLogger(PaymentDAO.class.getName());

    /**
     * Insert a new payment transaction record.
     * Uses OUTPUT INSERTED.payment_id to return generated key.
     *
     * @param payment Payment model entity
     * @return Generated paymentId or -1 if failed
     */
    public int insertPayment(Payment payment) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "INSERT INTO Payment (booking_id, amount, payment_method, transaction_ref, payment_status, paid_at) "
                + "OUTPUT INSERTED.payment_id "
                + "VALUES (?, ?, ?, ?, ?, GETDATE())";

        Object[] params = new Object[]{
                payment.getBookingId(),
                payment.getAmount(),
                payment.getPaymentMethod() != null ? payment.getPaymentMethod() : "VNPAY",
                payment.getTransactionRef() != null ? payment.getTransactionRef() : "",
                payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "Completed"
        };

        try {
            rs = db.executeSelectQuery(query, params);
            if (rs != null && rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "insertPayment failed for bookingId: " + payment.getBookingId(), ex);
        } finally {
            db.closeResources(rs);
        }
        return -1;
    }

    /**
     * Retrieve payment record by booking ID.
     *
     * @param bookingId Booking ID reference
     * @return Payment object or null
     */
    public Payment getPaymentByBookingId(int bookingId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT payment_id, booking_id, amount, payment_method, transaction_ref, payment_status, paid_at "
                + "FROM Payment WHERE booking_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{bookingId});
            if (rs != null && rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setBookingId(rs.getInt("booking_id"));
                p.setAmount(rs.getBigDecimal("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setTransactionRef(rs.getString("transaction_ref"));
                p.setPaymentStatus(rs.getString("payment_status"));

                Timestamp paid = rs.getTimestamp("paid_at");
                if (paid != null) p.setPaidAt(paid.toLocalDateTime());
                return p;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getPaymentByBookingId failed for bookingId: " + bookingId, ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    /**
     * Update status of payment record for a booking.
     *
     * @param bookingId Target booking ID
     * @param status    New payment status ('Completed', 'Failed', 'Refunded', etc.)
     * @return true if updated successfully
     */
    public boolean updatePaymentStatus(int bookingId, String status) {
        DBContext db = new DBContext();
        String query = "UPDATE Payment SET payment_status = ? WHERE booking_id = ?";
        int affected = db.executeQuery(query, new Object[]{status, bookingId});
        return affected > 0;
    }
}
