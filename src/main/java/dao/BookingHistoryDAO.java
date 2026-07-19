package dao;

import utils.DBContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for BookingHistory database operations (UC-13.2, UC-13.3, UC-18).
 */
public class BookingHistoryDAO {

    private static final Logger logger = Logger.getLogger(BookingHistoryDAO.class.getName());

    /**
     * Insert booking history trace audit log node.
     * Automatically fetches previous state from history if oldStatus is null/unspecified.
     *
     * @param bookingId Target booking ID
     * @param changedBy User ID of actor who triggered status transition
     * @param newStatus Target new status string
     * @param note      Descriptive audit note
     * @return true if history row inserted successfully
     */
    public boolean insertHistory(int bookingId, int changedBy, String newStatus, String note) {
        DBContext db = new DBContext();

        String oldStatus = "Pending Payment";
        String lastHistoryQuery = "SELECT TOP 1 new_status FROM BookingHistory WHERE booking_id = ? ORDER BY changed_at DESC";
        ResultSet rs = null;
        try {
            rs = db.executeSelectQuery(lastHistoryQuery, new Object[]{bookingId});
            if (rs != null && rs.next()) {
                oldStatus = rs.getString("new_status");
            } else {
                // Check initial booking status
                String currentStatusQuery = "SELECT status FROM Booking WHERE booking_id = ?";
                ResultSet rsBooking = db.executeSelectQuery(currentStatusQuery, new Object[]{bookingId});
                if (rsBooking != null && rsBooking.next()) {
                    oldStatus = rsBooking.getString("status");
                }
                db.closeResources(rsBooking);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Failed to fetch previous status for booking history log", ex);
        } finally {
            db.closeResources(rs);
        }

        String query = "INSERT INTO BookingHistory (booking_id, changed_by, old_status, new_status, note, changed_at) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE())";
        int affected = db.executeQuery(query, new Object[]{
                bookingId,
                changedBy,
                oldStatus,
                newStatus,
                note != null ? note : "Status transitioned to " + newStatus
        });
        return affected > 0;
    }

    /**
     * Insert booking history trace audit log node with explicit oldStatus.
     */
    public boolean insertHistory(int bookingId, int changedBy, String oldStatus, String newStatus, String note) {
        DBContext db = new DBContext();
        String query = "INSERT INTO BookingHistory (booking_id, changed_by, old_status, new_status, note, changed_at) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE())";
        int affected = db.executeQuery(query, new Object[]{
                bookingId,
                changedBy,
                oldStatus != null ? oldStatus : "Pending Payment",
                newStatus,
                note != null ? note : "Status transitioned to " + newStatus
        });
        return affected > 0;
    }
}
