package dao;

import model.Car;
import model.CarImage;
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
 * Data Access Object for Car-related database operations.
 */
public class CarDAO {

    private static final Logger logger = Logger.getLogger(CarDAO.class.getName());
    private static String lastError = null;
    
    public static String getLastError() {
        return lastError;
    }

    /**
     * Retrieve all available cars (non-paginated).
     */
    public List<Car> getAvailableCars() {
        return getAvailableCar(0, 100);
    }

    /**
     * Retrieve top 3 most rented available cars for the homepage.
     */
    public List<Car> getTop3MostRentedCars() {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Car> cars = new ArrayList<>();

        String query = "SELECT TOP 3 c.car_id, c.owner_id, c.type_id, c.car_name, c.brand, c.model, "
                + "c.license_plate, c.specs_json, c.price_per_day, c.status, c.document_url, "
                + "ct.type_name, "
                + "ISNULL(ci.image_url, '') AS primary_image_url, "
                + "(SELECT COUNT(*) FROM Booking b WHERE b.car_id = c.car_id AND b.status IN ('Approved', 'Completed', 'Active')) AS booking_count "
                + "FROM Car c "
                + "LEFT JOIN CarType ct ON c.type_id = ct.type_id "
                + "LEFT JOIN CarImage ci ON c.car_id = ci.car_id AND ci.is_primary = 1 "
                + "WHERE c.status = 'Available' "
                + "ORDER BY booking_count DESC, c.car_id DESC";
        try {
            rs = db.executeSelectQuery(query);
            while (rs != null && rs.next()) {
                Car car = mapRowToCar(rs);
                cars.add(car);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getTop3MostRentedCars failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return cars;
    }

    /**
     * Retrieve available cars with limit/offset pagination.
     * Orders by car_id DESC (BR1, BR2).
     */
    public List<Car> getAvailableCar(int offset, int limit) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Car> cars = new ArrayList<>();

        String query = "SELECT c.car_id, c.owner_id, c.type_id, c.car_name, c.brand, c.model, "
                + "c.license_plate, c.specs_json, c.price_per_day, c.status, c.document_url, "
                + "ct.type_name, "
                + "ISNULL(ci.image_url, '') AS primary_image_url "
                + "FROM Car c "
                + "LEFT JOIN CarType ct ON c.type_id = ct.type_id "
                + "LEFT JOIN CarImage ci ON c.car_id = ci.car_id AND ci.is_primary = 1 "
                + "WHERE c.status = 'Available' "
                + "ORDER BY c.car_id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            rs = db.executeSelectQuery(query, new Object[]{offset, limit});
            while (rs != null && rs.next()) {
                Car car = mapRowToCar(rs);
                cars.add(car);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getAvailableCar failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return cars;
    }

    /**
     * Overloaded method to match simple getAvailableCar() from sequence diagram.
     * Delegates to first page.
     */
    public List<Car> getAvailableCar() {
        return getAvailableCar(0, 12);
    }

    /**
     * Count total available cars.
     */
    public int getAvailableCarCount() {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT COUNT(*) AS cnt FROM Car WHERE status = 'Available'";
        try {
            rs = db.executeSelectQuery(query);
            if (rs != null && rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getAvailableCarCount failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return 0;
    }

    /**
     * Retrieve details of a single car by its ID.
     */
    public Car getCarById(int carId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT c.car_id, c.owner_id, c.type_id, c.car_name, c.brand, c.model, "
                + "c.license_plate, c.specs_json, c.price_per_day, c.status, c.document_url, "
                + "ct.type_name, "
                + "ISNULL(ci.image_url, '') AS primary_image_url "
                + "FROM Car c "
                + "LEFT JOIN CarType ct ON c.type_id = ct.type_id "
                + "LEFT JOIN CarImage ci ON c.car_id = ci.car_id AND ci.is_primary = 1 "
                + "WHERE c.car_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{carId});
            if (rs != null && rs.next()) {
                return mapRowToCar(rs);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getCarById failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    /**
     * Retrieve all images for a specific car.
     */
    public List<CarImage> getCarImage(int carId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<CarImage> images = new ArrayList<>();
        String query = "SELECT image_id, car_id, image_url, is_primary FROM CarImage WHERE car_id = ? ORDER BY is_primary DESC";
        try {
            rs = db.executeSelectQuery(query, new Object[]{carId});
            while (rs != null && rs.next()) {
                CarImage img = new CarImage();
                img.setImageId(rs.getInt("image_id"));
                img.setCarId(rs.getInt("car_id"));
                img.setImageUrl(rs.getString("image_url"));
                img.setPrimary(rs.getBoolean("is_primary"));
                images.add(img);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getCarImage failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return images;
    }

    /**
     * Search cars using AND logic for all specified query filters (BR4).
     */
    public List<Car> searchCars(String searchVal, Integer typeId, BigDecimal minPrice, BigDecimal maxPrice, int offset, int limit) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Car> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT c.car_id, c.owner_id, c.type_id, c.car_name, c.brand, c.model, "
                + "c.license_plate, c.specs_json, c.price_per_day, c.status, c.document_url, "
                + "ct.type_name, ISNULL(ci.image_url, '') AS primary_image_url "
                + "FROM Car c "
                + "LEFT JOIN CarType ct ON c.type_id = ct.type_id "
                + "LEFT JOIN CarImage ci ON c.car_id = ci.car_id AND ci.is_primary = 1 "
                + "WHERE c.status = 'Available'"
        );

        List<Object> params = new ArrayList<>();

        if (searchVal != null && !searchVal.trim().isEmpty()) {
            sql.append(" AND (c.car_name LIKE ? OR c.brand LIKE ? OR c.model LIKE ?)");
            String wrap = "%" + searchVal.trim() + "%";
            params.add(wrap);
            params.add(wrap);
            params.add(wrap);
        }

        if (typeId != null && typeId > 0) {
            sql.append(" AND c.type_id = ?");
            params.add(typeId);
        }

        if (minPrice != null) {
            sql.append(" AND c.price_per_day >= ?");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append(" AND c.price_per_day <= ?");
            params.add(maxPrice);
        }

        sql.append(" ORDER BY c.car_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try {
            rs = db.executeSelectQuery(sql.toString(), params.toArray());
            while (rs != null && rs.next()) {
                list.add(mapRowToCar(rs));
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "searchCars failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    /**
     * Count results of search filters.
     */
    public int searchCarsCount(String searchVal, Integer typeId, BigDecimal minPrice, BigDecimal maxPrice) {
        DBContext db = new DBContext();
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS cnt FROM Car c WHERE status = 'Available'");
        List<Object> params = new ArrayList<>();

        if (searchVal != null && !searchVal.trim().isEmpty()) {
            sql.append(" AND (c.car_name LIKE ? OR c.brand LIKE ? OR c.model LIKE ?)");
            String wrap = "%" + searchVal.trim() + "%";
            params.add(wrap);
            params.add(wrap);
            params.add(wrap);
        }

        if (typeId != null && typeId > 0) {
            sql.append(" AND c.type_id = ?");
            params.add(typeId);
        }

        if (minPrice != null) {
            sql.append(" AND c.price_per_day >= ?");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append(" AND c.price_per_day <= ?");
            params.add(maxPrice);
        }

        try {
            rs = db.executeSelectQuery(sql.toString(), params.toArray());
            if (rs != null && rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "searchCarsCount failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return 0;
    }

    /**
     * Retrieve list of all car types for select dropdowns.
     */
    public List<model.CarType> getAllCarTypes() {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<model.CarType> list = new ArrayList<>();
        String query = "SELECT type_id, type_name, description FROM CarType ORDER BY type_name";
        try {
            rs = db.executeSelectQuery(query);
            while (rs != null && rs.next()) {
                list.add(new model.CarType(rs.getInt("type_id"), rs.getString("type_name"), rs.getString("description")));
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getAllCarTypes failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    /**
     * Retrieve the primary image URL for a specific car.
     */
    public String getPrimaryImageForCar(int carId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT TOP 1 image_url FROM CarImage WHERE car_id = ? AND is_primary = 1";
        try {
            rs = db.executeSelectQuery(query, new Object[]{carId});
            if (rs != null && rs.next()) {
                return rs.getString("image_url");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getPrimaryImageForCar failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return "";
    }

    /**
     * Retrieve all cars owned by a specific partner.
     * Soft-deleted cars ('Deleted') are filtered out (BR37, BR47, BR48).
     */
    public List<Car> getCarsByOwner(int ownerId) {
        return getCarsByOwner(ownerId, 0, 1000000);
    }

    public List<Car> getCarsByOwner(int ownerId, int offset, int limit) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Car> list = new ArrayList<>();
        String query = "SELECT c.car_id, c.owner_id, c.type_id, c.car_name, c.brand, c.model, "
                + "c.license_plate, c.specs_json, c.price_per_day, c.status, c.document_url, "
                + "ct.type_name, ISNULL(ci.image_url, '') AS primary_image_url "
                + "FROM Car c "
                + "LEFT JOIN CarType ct ON c.type_id = ct.type_id "
                + "LEFT JOIN CarImage ci ON c.car_id = ci.car_id AND ci.is_primary = 1 "
                + "WHERE c.owner_id = ? AND c.status <> 'Deleted' "
                + "ORDER BY c.car_id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            rs = db.executeSelectQuery(query, new Object[]{ownerId, offset, limit});
            while (rs != null && rs.next()) {
                list.add(mapRowToCar(rs));
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getCarsByOwner failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public int countCarsByOwner(int ownerId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        int count = 0;
        String query = "SELECT COUNT(*) AS cnt FROM Car c WHERE c.owner_id = ? AND c.status <> 'Deleted'";
        try {
            rs = db.executeSelectQuery(query, new Object[]{ownerId});
            if (rs != null && rs.next()) {
                count = rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "countCarsByOwner failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return count;
    }

    /**
     * Search cars within the logged-in owner's fleet only (BR39).
     */
    public List<Car> searchCars(int ownerId, String keyword, int offset, int limit) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Car> list = new ArrayList<>();
        String query = "SELECT c.car_id, c.owner_id, c.type_id, c.car_name, c.brand, c.model, "
                + "c.license_plate, c.specs_json, c.price_per_day, c.status, c.document_url, "
                + "ct.type_name, ISNULL(ci.image_url, '') AS primary_image_url "
                + "FROM Car c "
                + "LEFT JOIN CarType ct ON c.type_id = ct.type_id "
                + "LEFT JOIN CarImage ci ON c.car_id = ci.car_id AND ci.is_primary = 1 "
                + "WHERE c.owner_id = ? AND c.status <> 'Deleted' "
                + "AND (c.car_name LIKE ? OR c.brand LIKE ? OR c.license_plate LIKE ?) "
                + "ORDER BY c.car_id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        String wrap = "%" + keyword.trim() + "%";
        try {
            rs = db.executeSelectQuery(query, new Object[]{ownerId, wrap, wrap, wrap, offset, limit});
            while (rs != null && rs.next()) {
                list.add(mapRowToCar(rs));
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "searchCars (owner) failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public int countSearchCars(int ownerId, String keyword) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        int count = 0;
        String query = "SELECT COUNT(*) AS cnt FROM Car c "
                + "WHERE c.owner_id = ? AND c.status <> 'Deleted' "
                + "AND (c.car_name LIKE ? OR c.brand LIKE ? OR c.license_plate LIKE ?)";
        String wrap = "%" + keyword.trim() + "%";
        try {
            rs = db.executeSelectQuery(query, new Object[]{ownerId, wrap, wrap, wrap});
            if (rs != null && rs.next()) {
                count = rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "countSearchCars (owner) failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return count;
    }

    /**
     * Check if a license plate already exists for active cars (BR41).
     */
    public boolean checkDuplicateLicense(String licensePlate) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT COUNT(*) AS cnt FROM Car WHERE license_plate = ? AND status <> 'Deleted'";
        try {
            rs = db.executeSelectQuery(query, new Object[]{licensePlate.trim()});
            if (rs != null && rs.next()) {
                return rs.getInt("cnt") > 0;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "checkDuplicateLicense failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return false;
    }

    /**
     * Register a new vehicle. Default status is 'Pending_Approval' (BR42, BR44).
     */
    public boolean insertCar(Car car) {
        return insertCar(car, null);
    }

    public boolean insertCar(Car car, jakarta.servlet.http.HttpServletRequest request) {
        DBContext db = new DBContext();
        String query = "INSERT INTO Car (owner_id, type_id, car_name, brand, model, license_plate, specs_json, price_per_day, status, document_url) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Pending_Approval', ?); SELECT SCOPE_IDENTITY() AS new_id;";
        java.sql.Connection conn = null;
        java.sql.PreparedStatement st = null;
        java.sql.ResultSet rs = null;
        try {
            conn = db.getConnection();
            st = conn.prepareStatement(query);
            st.setInt(1, car.getOwnerId());
            st.setInt(2, car.getTypeId());
            st.setString(3, car.getCarName());
            st.setString(4, car.getBrand());
            st.setString(5, car.getModel());
            st.setString(6, car.getLicensePlate());
            st.setString(7, car.getSpecsJson());
            st.setBigDecimal(8, car.getPricePerDay());
            st.setString(9, car.getDocumentUrl());
            
            boolean hasResults = st.execute();
            while (!hasResults && st.getUpdateCount() != -1) {
                hasResults = st.getMoreResults();
            }
            
            if (hasResults) {
                rs = st.getResultSet();
                if (rs != null && rs.next()) {
                    int carId = rs.getInt("new_id");
                    car.setCarId(carId);
                    
                    if (car.getPrimaryImageUrl() != null && !car.getPrimaryImageUrl().trim().isEmpty()) {
                        String finalImgUrl = car.getPrimaryImageUrl();
                        if (finalImgUrl.contains("temp_")) {
                            String newFileName = "car_" + carId + ".jpg";
                            finalImgUrl = utils.FileUploadUtil.renameUploadedFile(finalImgUrl, newFileName, "cars", request);
                            car.setPrimaryImageUrl(finalImgUrl);
                        }

                        String imgQuery = "INSERT INTO CarImage (car_id, image_url, is_primary) VALUES (?, ?, 1)";
                        try (java.sql.PreparedStatement stImg = conn.prepareStatement(imgQuery)) {
                            stImg.setInt(1, carId);
                            stImg.setString(2, finalImgUrl);
                            stImg.executeUpdate();
                        }
                    }
                    return true;
                }
            }
        } catch (SQLException ex) {
            lastError = ex.getMessage();
            logger.log(Level.SEVERE, "insertCar failed", ex);
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (st != null) try { st.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
        return false;
    }

    /**
     * View specific car info details (UC-15.4).
     */
    public Car getCarDetail(int carId) {
        return getCarById(carId);
    }

    /**
     * Retrieve list of bookings for the car.
     */
    public List<model.Booking> getRentalHistory(int carId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<model.Booking> history = new ArrayList<>();
        String query = "SELECT b.booking_id, b.customer_id, b.car_id, b.start_date, b.end_date, "
                + "b.total_days, b.subtotal_fee, b.status, b.created_at, p.full_name "
                + "FROM Booking b "
                + "JOIN Profile p ON b.customer_id = p.user_id "
                + "WHERE b.car_id = ? "
                + "ORDER BY b.created_at DESC";
        try {
            rs = db.executeSelectQuery(query, new Object[]{carId});
            while (rs != null && rs.next()) {
                model.Booking booking = new model.Booking();
                booking.setBookingId(rs.getInt("booking_id"));
                booking.setCustomerId(rs.getInt("customer_id"));
                booking.setCarId(rs.getInt("car_id"));

                Timestamp start = rs.getTimestamp("start_date");
                if (start != null) booking.setStartDate(start.toLocalDateTime());

                Timestamp end = rs.getTimestamp("end_date");
                if (end != null) booking.setEndDate(end.toLocalDateTime());

                booking.setTotalDays(rs.getInt("total_days"));
                booking.setSubtotalFee(rs.getBigDecimal("subtotal_fee"));
                booking.setStatus(rs.getString("status"));

                Timestamp created = rs.getTimestamp("created_at");
                if (created != null) booking.setCreatedAt(created.toLocalDateTime());

                booking.setCustomerName(rs.getString("full_name"));
                history.add(booking);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getRentalHistory failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return history;
    }

    /**
     * Check if owner owns this vehicle (BR43).
     */
    public boolean checkOwner(int carId, int ownerId) {
        Car car = getCarById(carId);
        return car != null && car.getOwnerId() == ownerId;
    }

    /**
     * Update car details. Ignores license plate update if already approved (BR45).
     */
    public boolean updateCar(Car car) {
        Car existing = getCarById(car.getCarId());
        if (existing == null) return false;

        DBContext db = new DBContext();
        String query = "UPDATE Car SET type_id = ?, car_name = ?, brand = ?, model = ?, specs_json = ?, price_per_day = ?, document_url = ? "
                + "WHERE car_id = ?";

        java.sql.Connection conn = null;
        java.sql.PreparedStatement st = null;
        try {
            conn = db.getConnection();
            st = conn.prepareStatement(query);
            st.setInt(1, car.getTypeId());
            st.setString(2, car.getCarName());
            st.setString(3, car.getBrand());
            st.setString(4, car.getModel());
            st.setString(5, car.getSpecsJson());
            st.setBigDecimal(6, car.getPricePerDay());
            st.setString(7, car.getDocumentUrl());
            st.setInt(8, car.getCarId());
            
            int affected = st.executeUpdate();
            if (affected > 0) {
                if (car.getPrimaryImageUrl() != null && !car.getPrimaryImageUrl().trim().isEmpty()) {
                    String checkQuery = "SELECT COUNT(*) AS cnt FROM CarImage WHERE car_id = ? AND is_primary = 1";
                    boolean hasPrimary = false;
                    try (java.sql.PreparedStatement checkSt = conn.prepareStatement(checkQuery)) {
                        checkSt.setInt(1, car.getCarId());
                        try (java.sql.ResultSet rs = checkSt.executeQuery()) {
                            if (rs != null && rs.next()) {
                                hasPrimary = rs.getInt("cnt") > 0;
                            }
                        }
                    }
                    
                    if (hasPrimary) {
                        String updateImg = "UPDATE CarImage SET image_url = ? WHERE car_id = ? AND is_primary = 1";
                        try (java.sql.PreparedStatement upSt = conn.prepareStatement(updateImg)) {
                            upSt.setString(1, car.getPrimaryImageUrl());
                            upSt.setInt(2, car.getCarId());
                            upSt.executeUpdate();
                        }
                    } else {
                        String insertImg = "INSERT INTO CarImage (car_id, image_url, is_primary) VALUES (?, ?, 1)";
                        try (java.sql.PreparedStatement inSt = conn.prepareStatement(insertImg)) {
                            inSt.setInt(1, car.getCarId());
                            inSt.setString(2, car.getPrimaryImageUrl());
                            inSt.executeUpdate();
                        }
                    }
                }
                return true;
            }
        } catch (SQLException ex) {
            lastError = ex.getMessage();
            ex.printStackTrace();
            logger.log(Level.SEVERE, "updateCar failed", ex);
        } finally {
            if (st != null) try { st.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
        return false;
    }

    /**
     * Check active future booking overlaps (BR46).
     */
    public boolean checkActiveBooking(int carId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT COUNT(*) AS cnt FROM Booking WHERE car_id = ? "
                + "AND status IN ('Pending Payment', 'Paid', 'Pending', 'Approved', 'Confirmed', 'Active') "
                + "AND end_date >= GETDATE()";
        try {
            rs = db.executeSelectQuery(query, new Object[]{carId});
            if (rs != null && rs.next()) {
                return rs.getInt("cnt") > 0;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "checkActiveBooking failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return false;
    }

    /**
     * Remove car - soft delete (BR47, BR48).
     */
    public boolean removeCar(int carId) {
        DBContext db = new DBContext();
        String query = "UPDATE Car SET status = 'Deleted' WHERE car_id = ?";
        int affected = db.executeQuery(query, new Object[]{carId});
        return affected > 0;
    }

    /**
     * Retrieve all cars across the platform regardless of status (UC-19.1).
     */
    public List<Car> getAllCars() {
        return getAllCars(0, 1000000);
    }

    public List<Car> getAllCars(int offset, int limit) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Car> list = new ArrayList<>();
        String query = "SELECT c.car_id, c.owner_id, c.type_id, c.car_name, c.brand, c.model, "
                + "c.license_plate, c.specs_json, c.price_per_day, c.status, c.document_url, "
                + "ct.type_name, ISNULL(ci.image_url, '') AS primary_image_url, p.full_name AS owner_name "
                + "FROM Car c "
                + "LEFT JOIN CarType ct ON c.type_id = ct.type_id "
                + "LEFT JOIN CarImage ci ON c.car_id = ci.car_id AND ci.is_primary = 1 "
                + "LEFT JOIN Profile p ON c.owner_id = p.user_id "
                + "WHERE c.status <> 'Deleted' "
                + "ORDER BY c.car_id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            rs = db.executeSelectQuery(query, new Object[]{offset, limit});
            while (rs != null && rs.next()) {
                Car car = mapRowToCar(rs);
                car.setOwnerName(rs.getString("owner_name"));
                list.add(car);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getAllCars failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public int countAllCars() {
        DBContext db = new DBContext();
        ResultSet rs = null;
        int count = 0;
        String query = "SELECT COUNT(*) AS cnt FROM Car c WHERE c.status <> 'Deleted'";
        try {
            rs = db.executeSelectQuery(query);
            if (rs != null && rs.next()) {
                count = rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "countAllCars failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return count;
    }

    /**
     * Retrieve single Car specs details joined with owner and category details (UC-19.2).
     */
    public Car getCarDetails(int carId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT c.car_id, c.owner_id, c.type_id, c.car_name, c.brand, c.model, "
                + "c.license_plate, c.specs_json, c.price_per_day, c.status, c.document_url, "
                + "ct.type_name, ISNULL(ci.image_url, '') AS primary_image_url, p.full_name AS owner_name "
                + "FROM Car c "
                + "LEFT JOIN CarType ct ON c.type_id = ct.type_id "
                + "LEFT JOIN CarImage ci ON c.car_id = ci.car_id AND ci.is_primary = 1 "
                + "LEFT JOIN Profile p ON c.owner_id = p.user_id "
                + "WHERE c.car_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{carId});
            if (rs != null && rs.next()) {
                Car car = mapRowToCar(rs);
                car.setOwnerName(rs.getString("owner_name"));
                return car;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getCarDetails failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    /**
     * Update car status (UC-19.3 step 8).
     */
    public boolean updateCarStatus(int carId, String newStatus) {
        DBContext db = new DBContext();
        String query = "UPDATE Car SET status = ? WHERE car_id = ?";
        int affected = db.executeQuery(query, new Object[]{newStatus, carId});
        return affected > 0;
    }

    /**
     * Search cars across the master database space (UC-19.4).
     */
    public List<Car> searchByKeyword(String keyword, int offset, int limit) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<Car> list = new ArrayList<>();
        String query = "SELECT c.car_id, c.owner_id, c.type_id, c.car_name, c.brand, c.model, "
                + "c.license_plate, c.specs_json, c.price_per_day, c.status, c.document_url, "
                + "ct.type_name, ISNULL(ci.image_url, '') AS primary_image_url, p.full_name AS owner_name "
                + "FROM Car c "
                + "LEFT JOIN CarType ct ON c.type_id = ct.type_id "
                + "LEFT JOIN CarImage ci ON c.car_id = ci.car_id AND ci.is_primary = 1 "
                + "LEFT JOIN Profile p ON c.owner_id = p.user_id "
                + "WHERE c.status <> 'Deleted' "
                + "AND (c.car_name LIKE ? OR c.brand LIKE ? OR c.license_plate LIKE ? OR c.status LIKE ? OR p.full_name LIKE ?) "
                + "ORDER BY c.car_id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        String wrap = "%" + keyword.trim() + "%";
        try {
            rs = db.executeSelectQuery(query, new Object[]{wrap, wrap, wrap, wrap, wrap, offset, limit});
            while (rs != null && rs.next()) {
                Car car = mapRowToCar(rs);
                car.setOwnerName(rs.getString("owner_name"));
                list.add(car);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "searchByKeyword failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public int countSearchByKeyword(String keyword) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        int count = 0;
        String query = "SELECT COUNT(*) AS cnt FROM Car c "
                + "LEFT JOIN Profile p ON c.owner_id = p.user_id "
                + "WHERE c.status <> 'Deleted' "
                + "AND (c.car_name LIKE ? OR c.brand LIKE ? OR c.license_plate LIKE ? OR c.status LIKE ? OR p.full_name LIKE ?)";
        String wrap = "%" + keyword.trim() + "%";
        try {
            rs = db.executeSelectQuery(query, new Object[]{wrap, wrap, wrap, wrap, wrap});
            if (rs != null && rs.next()) {
                count = rs.getInt("cnt");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "countSearchByKeyword failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return count;
    }

    private Car mapRowToCar(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setCarId(rs.getInt("car_id"));
        car.setOwnerId(rs.getInt("owner_id"));
        car.setTypeId(rs.getInt("type_id"));
        car.setCarName(rs.getString("car_name"));
        car.setBrand(rs.getString("brand"));
        car.setModel(rs.getString("model"));
        car.setLicensePlate(rs.getString("license_plate"));
        car.setSpecsJson(rs.getString("specs_json"));
        car.setPricePerDay(rs.getBigDecimal("price_per_day"));
        car.setStatus(rs.getString("status"));
        car.setDocumentUrl(rs.getString("document_url"));
        car.setTypeName(rs.getString("type_name"));
        car.setPrimaryImageUrl(rs.getString("primary_image_url"));
        return car;
    }
}
