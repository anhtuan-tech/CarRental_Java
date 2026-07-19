package dao;

import model.Booking;
import utils.DBContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Financial and Revenue analytics operations.
 */
public class RevenueDAO {

    private static final Logger logger = Logger.getLogger(RevenueDAO.class.getName());

    /**
     * Fetch all bookings in range to evaluate platform commission revenue (UC-22 step 4).
     */
    public List<Booking> getRevenueReport(String startDate, String endDate) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();

        StringBuilder query = new StringBuilder(
                "SELECT booking_id, customer_id, car_id, start_date, end_date, "
                + "total_days, subtotal_fee, platform_commission, owner_payout, status, created_at "
                + "FROM Booking WHERE status = 'Completed'"
        );
        List<Object> params = new ArrayList<>();

        if (startDate != null && !startDate.trim().isEmpty()) {
            query.append(" AND created_at >= ?");
            params.add(startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            query.append(" AND created_at <= ?");
            params.add(endDate + " 23:59:59");
        }
        query.append(" ORDER BY created_at DESC");

        try {
            rs = db.executeSelectQuery(query.toString(), params.toArray());
            while (rs != null && rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setCustomerId(rs.getInt("customer_id"));
                booking.setCarId(rs.getInt("car_id"));

                Timestamp sd = rs.getTimestamp("start_date");
                if (sd != null) booking.setStartDate(sd.toLocalDateTime());

                Timestamp ed = rs.getTimestamp("end_date");
                if (ed != null) booking.setEndDate(ed.toLocalDateTime());

                booking.setTotalDays(rs.getInt("total_days"));
                booking.setSubtotalFee(rs.getBigDecimal("subtotal_fee"));
                booking.setPlatformCommission(rs.getBigDecimal("platform_commission"));
                booking.setOwnerPayout(rs.getBigDecimal("owner_payout"));
                booking.setStatus(rs.getString("status"));

                Timestamp ca = rs.getTimestamp("created_at");
                if (ca != null) booking.setCreatedAt(ca.toLocalDateTime());

                list.add(booking);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getRevenueReport SQL execution failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }
}
