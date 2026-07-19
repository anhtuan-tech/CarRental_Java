package dao;

import model.Booking;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Booking database operations (UC-13.1 to UC-13.4 &
 * UC-18).
 */
public class BookingDAO {

    private static final Logger logger = Logger.getLogger(BookingDAO.class.getName());

    /**
     * UC-13.1: View My Car Bookings.
     * Fetches booking records belonging exclusively to a specific customer (BR15 &
     * BR16).
     *
     * @param customerId Primary key of current logged-in customer
     * @return List of Booking objects
     */
    public List<Booking> getBookingsByCustomer(int customerId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();
        String query = "SELECT b.booking_id, b.customer_id, b.car_id, b.start_date, b.end_date, "
                + "b.total_days, b.subtotal_fee, b.platform_commission, b.owner_payout, b.status, b.created_at, "
                + "c.car_name, c.brand, c.license_plate, c.price_per_day, c.owner_id, "
                + "p.full_name AS customer_name, op.full_name AS owner_name, "
                + "CASE WHEN f.feedback_id IS NOT NULL THEN 1 ELSE 0 END AS is_reviewed "
                + "FROM Booking b "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "JOIN Profile p ON b.customer_id = p.user_id "
                + "LEFT JOIN Profile op ON c.owner_id = op.user_id "
                + "LEFT JOIN Feedback f ON b.booking_id = f.booking_id "
                + "WHERE b.customer_id = ? "
                + "ORDER BY b.created_at DESC";
        try {
            rs = db.executeSelectQuery(query, new Object[] { customerId });
            while (rs != null && rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                list.add(booking);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getBookingsByCustomer failed for customerId: " + customerId, ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    /**
     * UC-13.2 Step 1 & BR20: Check vehicle availability for reservation date range.
     * Rejects execution if targeted car has overlapping active/approved bookings.
     *
     * @param carId     Target vehicle ID
     * @param startDate Pick-up start date
     * @param endDate   Drop-off end date
     * @return true if vehicle is available, false if overlapping conflict occurs
     */
    public boolean checkAvailability(int carId, LocalDateTime startDate, LocalDateTime endDate) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT COUNT(*) AS conflict_count FROM Booking "
                + "WHERE car_id = ? "
                + "AND status IN ('Paid', 'Pending Payment', 'Active', 'Approved', 'Confirmed') "
                + "AND NOT (end_date <= ? OR start_date >= ?)";
        try {
            Timestamp startTs = Timestamp.valueOf(startDate);
            Timestamp endTs = Timestamp.valueOf(endDate);
            rs = db.executeSelectQuery(query, new Object[] { carId, startTs, endTs });
            if (rs != null && rs.next()) {
                int conflictCount = rs.getInt("conflict_count");
                return conflictCount == 0;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "checkAvailability failed for carId: " + carId, ex);
        } finally {
            db.closeResources(rs);
        }
        return false;
    }

    public int insertBooking(Booking booking) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "INSERT INTO Booking (customer_id, car_id, start_date, end_date, total_days, "
                + "subtotal_fee, platform_commission, owner_payout, status, created_at) "
                + "OUTPUT INSERTED.booking_id "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";

        Timestamp startTs = Timestamp.valueOf(booking.getStartDate());
        Timestamp endTs = Timestamp.valueOf(booking.getEndDate());

        Object[] params = new Object[] {
                booking.getCustomerId(),
                booking.getCarId(),
                startTs,
                endTs,
                booking.getTotalDays(),
                booking.getSubtotalFee(),
                booking.getPlatformCommission(),
                booking.getOwnerPayout(),
                booking.getStatus() != null ? booking.getStatus() : "Pending Payment"
        };

        try {
            rs = db.executeSelectQuery(query, params);
            if (rs != null && rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "insertBooking failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return -1;
    }

    /**
     * UC-13.2 & UC-13.3: Update booking status.
     *
     * @param bookingId Target booking ID
     * @param newStatus New status string ('Paid', 'Cancelled', 'Refunded', etc.)
     * @return true if update succeeded
     */
    public boolean updateStatus(int bookingId, String newStatus) {
        DBContext db = new DBContext();
        String query = "UPDATE Booking SET status = ? WHERE booking_id = ?";
        int affected = db.executeQuery(query, new Object[] { newStatus, bookingId });
        return affected > 0;
    }

    /**
     * UC-13.3: Fetch booking record by ID.
     *
     * @param bookingId Target booking ID
     * @return Booking object or null
     */
    public Booking getBookingById(int bookingId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT b.booking_id, b.customer_id, b.car_id, b.start_date, b.end_date, "
                + "b.total_days, b.subtotal_fee, b.platform_commission, b.owner_payout, b.status, b.created_at, "
                + "c.car_name, c.brand, c.license_plate, c.price_per_day, c.owner_id, "
                + "p.full_name AS customer_name, op.full_name AS owner_name "
                + "FROM Booking b "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "JOIN Profile p ON b.customer_id = p.user_id "
                + "LEFT JOIN Profile op ON c.owner_id = op.user_id "
                + "WHERE b.booking_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[] { bookingId });
            if (rs != null && rs.next()) {
                return mapResultSetToBooking(rs);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getBookingById failed for bookingId: " + bookingId, ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    /**
     * UC-13.4: Search My Car Bookings by keyword.
     *
     * @param customerId Current logged-in customer ID
     * @param keyword    Search input string
     * @return List of matching Booking objects
     */
    public List<Booking> searchMyBookings(int customerId, String keyword) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();
        String query = "SELECT b.booking_id, b.customer_id, b.car_id, b.start_date, b.end_date, "
                + "b.total_days, b.subtotal_fee, b.platform_commission, b.owner_payout, b.status, b.created_at, "
                + "c.car_name, c.brand, c.license_plate, c.price_per_day, c.owner_id, "
                + "p.full_name AS customer_name, op.full_name AS owner_name "
                + "FROM Booking b "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "JOIN Profile p ON b.customer_id = p.user_id "
                + "LEFT JOIN Profile op ON c.owner_id = op.user_id "
                + "WHERE b.customer_id = ? "
                + "AND (c.car_name LIKE ? OR c.brand LIKE ? OR c.license_plate LIKE ? OR b.status LIKE ? OR CAST(b.booking_id AS VARCHAR) LIKE ?) "
                + "ORDER BY b.created_at DESC";
        String wrap = "%" + (keyword != null ? keyword.trim() : "") + "%";
        try {
            rs = db.executeSelectQuery(query, new Object[] { customerId, wrap, wrap, wrap, wrap, wrap });
            while (rs != null && rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                list.add(booking);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "searchMyBookings failed for customerId: " + customerId, ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    /**
     * Retrieve all rental orders for an owner's fleet (UC-16.1).
     */
    public List<Booking> getAllBookingByOwnerId(int ownerId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();
        String query = "SELECT b.booking_id, b.customer_id, b.car_id, b.start_date, b.end_date, "
                + "b.total_days, b.subtotal_fee, b.platform_commission, b.owner_payout, b.status, b.created_at, "
                + "c.car_name, c.brand, c.license_plate, c.price_per_day, c.owner_id, "
                + "p.full_name AS customer_name, op.full_name AS owner_name "
                + "FROM Booking b "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "JOIN Profile p ON b.customer_id = p.user_id "
                + "LEFT JOIN Profile op ON c.owner_id = op.user_id "
                + "WHERE c.owner_id = ? AND c.status <> 'Deleted' "
                + "ORDER BY b.created_at DESC";
        try {
            rs = db.executeSelectQuery(query, new Object[] { ownerId });
            while (rs != null && rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                list.add(booking);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getAllBookingByOwnerId failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    /**
     * Retrieve all car bookings in the system (UC-18.1).
     */
    public List<Booking> getAllCarBookings() {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();
        String query = "SELECT b.booking_id, b.customer_id, b.car_id, b.start_date, b.end_date, "
                + "b.total_days, b.subtotal_fee, b.platform_commission, b.owner_payout, b.status, b.created_at, "
                + "c.car_name, c.brand, c.license_plate, c.price_per_day, c.owner_id, "
                + "p.full_name AS customer_name, op.full_name AS owner_name "
                + "FROM Booking b "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "JOIN Profile p ON b.customer_id = p.user_id "
                + "LEFT JOIN Profile op ON c.owner_id = op.user_id "
                + "ORDER BY b.created_at DESC";
        try {
            rs = db.executeSelectQuery(query);
            while (rs != null && rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                list.add(booking);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getAllCarBookings failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public Booking getCarBookingDetail(int carBookingId) {
        return getBookingById(carBookingId);
    }

    public List<Booking> searchByKeyword(String keyword) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Booking> list = new ArrayList<>();
        String query = "SELECT b.booking_id, b.customer_id, b.car_id, b.start_date, b.end_date, "
                + "b.total_days, b.subtotal_fee, b.platform_commission, b.owner_payout, b.status, b.created_at, "
                + "c.car_name, c.brand, c.license_plate, c.price_per_day, c.owner_id, "
                + "p.full_name AS customer_name, op.full_name AS owner_name "
                + "FROM Booking b "
                + "JOIN Car c ON b.car_id = c.car_id "
                + "JOIN Profile p ON b.customer_id = p.user_id "
                + "LEFT JOIN Profile op ON c.owner_id = op.user_id "
                + "WHERE p.full_name LIKE ? OR p.phone LIKE ? OR c.car_name LIKE ? OR c.brand LIKE ? OR b.status LIKE ? "
                + "ORDER BY b.created_at DESC";
        String wrap = "%" + (keyword != null ? keyword.trim() : "") + "%";
        try {
            rs = db.executeSelectQuery(query, new Object[] { wrap, wrap, wrap, wrap, wrap });
            while (rs != null && rs.next()) {
                Booking booking = mapResultSetToBooking(rs);
                list.add(booking);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "searchByKeyword failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public boolean updateStatus(String status, int bookingId, int actorId, String oldStatus, String note) {
        DBContext db = new DBContext();
        String queryUpdate = "UPDATE Booking SET status = ? WHERE booking_id = ?";
        int affected = db.executeQuery(queryUpdate, new Object[] { status, bookingId });
        if (affected > 0) {
            String queryHistory = "INSERT INTO BookingHistory (booking_id, changed_by, old_status, new_status, note, changed_at) "
                    + "VALUES (?, ?, ?, ?, ?, GETDATE())";
            db.executeQuery(queryHistory, new Object[] {
                    bookingId,
                    actorId,
                    oldStatus,
                    status,
                    note != null ? note : "Status updated."
            });
            return true;
        }
        return false;
    }

    /**
     * Helper mapper method for ResultSet to Booking entity.
     */
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setCustomerId(rs.getInt("customer_id"));
        booking.setCarId(rs.getInt("car_id"));

        Timestamp start = rs.getTimestamp("start_date");
        if (start != null)
            booking.setStartDate(start.toLocalDateTime());

        Timestamp end = rs.getTimestamp("end_date");
        if (end != null)
            booking.setEndDate(end.toLocalDateTime());

        booking.setTotalDays(rs.getInt("total_days"));
        booking.setSubtotalFee(rs.getBigDecimal("subtotal_fee"));
        booking.setPlatformCommission(rs.getBigDecimal("platform_commission"));
        booking.setOwnerPayout(rs.getBigDecimal("owner_payout"));
        booking.setStatus(rs.getString("status"));

        Timestamp created = rs.getTimestamp("created_at");
        if (created != null)
            booking.setCreatedAt(created.toLocalDateTime());

        booking.setCarName(rs.getString("car_name"));
        booking.setBrand(rs.getString("brand"));
        booking.setLicensePlate(rs.getString("license_plate"));
        booking.setPricePerDay(rs.getBigDecimal("price_per_day"));
        booking.setOwnerId(rs.getInt("owner_id"));
        booking.setCustomerName(rs.getString("customer_name"));
        booking.setOwnerName(rs.getString("owner_name"));
        try {
            booking.setReviewed(rs.getInt("is_reviewed") == 1);
        } catch (SQLException ignored) {}
        return booking;
    }
}
