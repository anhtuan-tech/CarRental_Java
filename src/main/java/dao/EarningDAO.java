package dao;

import model.BookingHistory;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Owner Earnings analytic (UC-17).
 */
public class EarningDAO {

    private static final Logger logger = Logger.getLogger(EarningDAO.class.getName());

    /**
     * Compute sum of owner payout for completed transactions (UC-17 step 6).
     */
    public BigDecimal getEarningsSummary(int ownerId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT SUM(b.owner_payout) AS total_earn "
                + "FROM Booking b "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "WHERE c.owner_id = ? AND b.status = 'Completed'";
        try {
            rs = db.executeSelectQuery(query, new Object[]{ownerId});
            if (rs != null && rs.next()) {
                BigDecimal val = rs.getBigDecimal("total_earn");
                return val != null ? val : BigDecimal.ZERO;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getEarningsSummary failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return BigDecimal.ZERO;
    }

    /**
     * Fetch timeline booking history log trail for an owner's fleet (UC-17 step
     * 10).
     */
    public List<BookingHistory> getBookingHistory(int ownerId) {
        return getBookingHistory(ownerId, 0, 100000);
    }

    public List<BookingHistory> getBookingHistory(int ownerId, int offset, int limit) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<BookingHistory> list = new ArrayList<>();
        String query = "SELECT bh.history_id, bh.booking_id, bh.changed_by, bh.old_status, bh.new_status, bh.note, bh.changed_at, "
                + "c.car_name, c.brand "
                + "FROM BookingHistory bh "
                + "JOIN Booking b ON bh.booking_id = b.booking_id "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "WHERE c.owner_id = ? "
                + "ORDER BY bh.changed_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            rs = db.executeSelectQuery(query, new Object[]{ownerId, offset, limit});
            while (rs != null && rs.next()) {
                BookingHistory bh = new BookingHistory();
                bh.setHistoryId(rs.getInt("history_id"));
                bh.setBookingId(rs.getInt("booking_id"));
                bh.setChangedBy(rs.getInt("changed_by"));
                bh.setOldStatus(rs.getString("old_status"));
                bh.setNewStatus(rs.getString("new_status"));

                String carContext = rs.getString("brand") + " " + rs.getString("car_name");
                String note = rs.getString("note");
                bh.setNote("[" + carContext + "] " + (note != null ? note : ""));

                Timestamp ts = rs.getTimestamp("changed_at");
                if (ts != null) {
                    bh.setChangedAt(ts.toLocalDateTime());
                }

                list.add(bh);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getBookingHistory failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public int getBookingHistoryCount(int ownerId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT COUNT(*) AS total_rows "
                + "FROM BookingHistory bh "
                + "JOIN Booking b ON bh.booking_id = b.booking_id "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "WHERE c.owner_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{ownerId});
            if (rs != null && rs.next()) {
                return rs.getInt("total_rows");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getBookingHistoryCount failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return 0;
    }
}
