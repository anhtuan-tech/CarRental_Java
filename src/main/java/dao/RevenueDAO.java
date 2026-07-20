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
    public List<Booking> getRevenueReport(String startDate, String endDate, int offset, int limit) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();

        StringBuilder query = new StringBuilder(
                "SELECT b.booking_id, b.customer_id, b.car_id, b.start_date, b.end_date, "
                + "b.total_days, b.subtotal_fee, b.platform_commission, b.owner_payout, b.status, b.created_at, "
                + "cp.full_name AS customer_name, op.full_name AS owner_name "
                + "FROM Booking b "
                + "LEFT JOIN [Profile] cp ON b.customer_id = cp.user_id "
                + "LEFT JOIN Car c ON b.car_id = c.car_id "
                + "LEFT JOIN [Profile] op ON c.owner_id = op.user_id "
                + "WHERE b.status = 'Completed'"
        );
        List<Object> params = new ArrayList<>();

        if (startDate != null && !startDate.trim().isEmpty()) {
            query.append(" AND b.created_at >= ?");
            params.add(startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            query.append(" AND b.created_at <= ?");
            params.add(endDate + " 23:59:59");
        }
        query.append(" ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

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
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setOwnerName(rs.getString("owner_name"));

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

    public int countRevenueReport(String startDate, String endDate) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        int count = 0;
        StringBuilder query = new StringBuilder(
                "SELECT COUNT(*) AS cnt "
                + "FROM Booking b "
                + "WHERE b.status = 'Completed'"
        );
        List<Object> params = new ArrayList<>();

        if (startDate != null && !startDate.trim().isEmpty()) {
            query.append(" AND b.created_at >= ?");
            params.add(startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            query.append(" AND b.created_at <= ?");
            params.add(endDate + " 23:59:59");
        }

        try {
            rs = db.executeSelectQuery(query.toString(), params.toArray());
            if (rs != null && rs.next()) {
                count = rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "countRevenueReport SQL execution failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return count;
    }

    public Booking getRevenueTotals(String startDate, String endDate) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        Booking totals = new Booking();
        totals.setSubtotalFee(java.math.BigDecimal.ZERO);
        totals.setPlatformCommission(java.math.BigDecimal.ZERO);
        totals.setOwnerPayout(java.math.BigDecimal.ZERO);

        StringBuilder query = new StringBuilder(
                "SELECT SUM(subtotal_fee) as sum_subtotal, "
                + "SUM(platform_commission) as sum_commission, "
                + "SUM(owner_payout) as sum_payout "
                + "FROM Booking "
                + "WHERE status = 'Completed'"
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

        try {
            rs = db.executeSelectQuery(query.toString(), params.toArray());
            if (rs != null && rs.next()) {
                if (rs.getBigDecimal("sum_subtotal") != null) totals.setSubtotalFee(rs.getBigDecimal("sum_subtotal"));
                if (rs.getBigDecimal("sum_commission") != null) totals.setPlatformCommission(rs.getBigDecimal("sum_commission"));
                if (rs.getBigDecimal("sum_payout") != null) totals.setOwnerPayout(rs.getBigDecimal("sum_payout"));
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getRevenueTotals SQL execution failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return totals;
    }
}
