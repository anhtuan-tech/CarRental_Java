package dao;

import model.Profile;
import model.User;
import utils.DBContext;
import utils.PasswordUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for User-related database operations.
 * All queries strictly use the DBContext class – no ORM.
 */
public class UserDAO {

    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());

    // =========================================================================
    // Registration & Account Checks
    // =========================================================================

    public boolean checkDuplicateAccount(String email, String phoneNumber) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT COUNT(*) AS cnt FROM [User] WHERE LOWER(email) = LOWER(?) OR phone_number = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{email != null ? email.trim() : "", phoneNumber});
            if (rs != null && rs.next()) {
                return rs.getInt("cnt") > 0;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "checkDuplicateAccount failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return false;
    }

    public boolean checkDuplicateForUpdate(int userId, String email, String phoneNumber) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT COUNT(*) AS cnt FROM [User] WHERE (LOWER(email) = LOWER(?) OR phone_number = ?) AND user_id <> ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{email != null ? email.trim() : "", phoneNumber, userId});
            if (rs != null && rs.next()) {
                return rs.getInt("cnt") > 0;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "checkDuplicateForUpdate failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return false;
    }

    public boolean insertAccount(User user) {
        DBContext dbUser = new DBContext();
        DBContext dbProfile = new DBContext();
        ResultSet rs = null;

        String insertUser = "INSERT INTO [User] (role_id, email, password, phone_number, status, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, 'Active', GETDATE(), GETDATE())";
        int affected = dbUser.executeQuery(insertUser,
                new Object[]{user.getRoleId(), user.getEmail(), user.getPassword(), user.getPhoneNumber()});

        if (affected == 0) {
            return false;
        }

        String getNewId = "SELECT TOP 1 user_id FROM [User] WHERE email = ? ORDER BY created_at DESC";
        int newUserId = -1;
        try {
            rs = dbUser.executeSelectQuery(getNewId, new Object[]{user.getEmail()});
            if (rs != null && rs.next()) {
                newUserId = rs.getInt("user_id");
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "insertAccount – get user_id failed", ex);
            return false;
        } finally {
            dbUser.closeResources(rs);
        }

        if (newUserId == -1) {
            return false;
        }

        String fullNameVal = (user.getFullName() != null) ? user.getFullName().trim() : "";
        String insertProfile = "INSERT INTO [Profile] (user_id, full_name, avatar_url, driver_license, id_card_no, address) "
                + "VALUES (?, ?, '', '', '', '')";
        int profileAffected = dbProfile.executeQuery(insertProfile, new Object[]{newUserId, fullNameVal});

        return profileAffected > 0;
    }

    public boolean updateAccount(User user) {
        return updateUser(user);
    }

    public boolean updateUser(User user) {
        DBContext db = new DBContext();
        String query = "UPDATE [User] SET email = ?, phone_number = ?, updated_at = GETDATE() WHERE user_id = ?";
        int affected = db.executeQuery(query, new Object[]{user.getEmail(), user.getPhoneNumber(), user.getUserId()});
        return affected > 0;
    }

    // =========================================================================
    // Login Methods
    // =========================================================================

    public User checkLogin(String email, String password, int roleId) {
        if (email == null || password == null) return null;
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT user_id, role_id, email, password, phone_number, status, created_at, updated_at "
                + "FROM [User] WHERE LOWER(email) = LOWER(?) AND role_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{email.trim(), roleId});
            if (rs != null && rs.next()) {
                User user = mapRowToUser(rs);

                String hashedInput = PasswordUtils.hashSHA256(password);
                String dbPwd = user.getPassword();

                boolean isMatch = (dbPwd != null) && (dbPwd.equals(password) || (hashedInput != null && dbPwd.equalsIgnoreCase(hashedInput)));

                if (!isMatch) {
                    return null;
                }

                if (!"Active".equalsIgnoreCase(user.getStatus())) {
                    return null;
                }

                return user;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "checkLogin failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    public User checkStaffAndAdminLogin(String email, String password) {
        if (email == null || password == null) return null;
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT user_id, role_id, email, password, phone_number, status, created_at, updated_at "
                + "FROM [User] WHERE LOWER(email) = LOWER(?) AND role_id IN (1, 2)";
        try {
            rs = db.executeSelectQuery(query, new Object[]{email.trim()});
            if (rs != null && rs.next()) {
                User user = mapRowToUser(rs);

                String hashedInput = PasswordUtils.hashSHA256(password);
                String dbPwd = user.getPassword();

                boolean isMatch = (dbPwd != null) && (dbPwd.equals(password) || (hashedInput != null && dbPwd.equalsIgnoreCase(hashedInput)));

                if (!isMatch) {
                    return null;
                }

                if (!"Active".equalsIgnoreCase(user.getStatus())) {
                    return null;
                }

                return user;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "checkStaffAndAdminLogin failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    public boolean checkCurrentPassword(int userId, String currentPwd) {
        User u = getUserById(userId);
        if (u == null || currentPwd == null) return false;
        String hashedInput = PasswordUtils.hashSHA256(currentPwd);
        String dbPwd = u.getPassword();
        return dbPwd != null && (dbPwd.equals(currentPwd) || (hashedInput != null && dbPwd.equalsIgnoreCase(hashedInput)));
    }

    // =========================================================================
    // Email & Password Reset
    // =========================================================================

    public User findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) return null;
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT user_id, role_id, email, password, phone_number, status, created_at, updated_at "
                + "FROM [User] WHERE LOWER(email) = LOWER(?)";
        try {
            rs = db.executeSelectQuery(query, new Object[]{email.trim()});
            if (rs != null && rs.next()) {
                return mapRowToUser(rs);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "findByEmail failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    public User checkEmailExist(String email) {
        return findByEmail(email);
    }

    public boolean checkEmailExists(String email) {
        return findByEmail(email) != null;
    }

    public boolean updatePassword(String email, String hashedPwd) {
        DBContext db = new DBContext();
        String query = "UPDATE [User] SET password = ?, updated_at = GETDATE() WHERE LOWER(email) = LOWER(?)";
        int affected = db.executeQuery(query, new Object[]{hashedPwd, email.trim()});
        return affected > 0;
    }

    public boolean updatePassword(int userId, String hashedPwd) {
        DBContext db = new DBContext();
        String query = "UPDATE [User] SET password = ?, updated_at = GETDATE() WHERE user_id = ?";
        int affected = db.executeQuery(query, new Object[]{hashedPwd, userId});
        return affected > 0;
    }

    // =========================================================================
    // Profile Operations
    // =========================================================================

    public Profile getProfileByUserId(int userId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT profile_id, user_id, full_name, avatar_url, driver_license, id_card_no, address "
                + "FROM [Profile] WHERE user_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{userId});
            if (rs != null && rs.next()) {
                Profile p = new Profile();
                p.setProfileId(rs.getInt("profile_id"));
                p.setUserId(rs.getInt("user_id"));
                p.setFullName(rs.getString("full_name"));
                p.setAvatarUrl(rs.getString("avatar_url"));
                p.setDriverLicense(rs.getString("driver_license"));
                p.setIdCardNo(rs.getString("id_card_no"));
                p.setAddress(rs.getString("address"));
                return p;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getProfileByUserId failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    public boolean updateProfile(Profile profile) {
        DBContext db = new DBContext();
        String query = "UPDATE [Profile] SET full_name = ?, avatar_url = ?, driver_license = ?, id_card_no = ?, address = ? WHERE user_id = ?";
        int affected = db.executeQuery(query, new Object[]{
                profile.getFullName() != null ? profile.getFullName() : "",
                profile.getAvatarUrl() != null ? profile.getAvatarUrl() : "",
                profile.getDriverLicense() != null ? profile.getDriverLicense() : "",
                profile.getIdCardNo() != null ? profile.getIdCardNo() : "",
                profile.getAddress() != null ? profile.getAddress() : "",
                profile.getUserId()
        });
        return affected > 0;
    }

    public User getUserById(int userId) {
        return getUserDetails(userId);
    }

    public User getUserDetails(int userId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT u.user_id, u.role_id, u.email, u.password, u.phone_number, u.status, u.created_at, u.updated_at, "
                + "p.full_name, p.avatar_url, p.driver_license, p.id_card_no, p.address "
                + "FROM [User] u LEFT JOIN [Profile] p ON u.user_id = p.user_id "
                + "WHERE u.user_id = ?";
        try {
            rs = db.executeSelectQuery(query, new Object[]{userId});
            if (rs != null && rs.next()) {
                User user = mapRowToUser(rs);
                user.setFullName(rs.getString("full_name"));
                return user;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getUserDetails failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    // =========================================================================
    // Staff & Role Management
    // =========================================================================

    public List<User> getAllStaffAccounts() {
        return getAllStaffs();
    }

    public List<User> getAllStaffs() {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        String query = "SELECT u.user_id, u.role_id, u.email, u.password, u.phone_number, u.status, u.created_at, u.updated_at, "
                + "p.full_name "
                + "FROM [User] u LEFT JOIN [Profile] p ON u.user_id = p.user_id "
                + "WHERE u.role_id = 2 AND u.status <> 'Inactive' "
                + "ORDER BY u.created_at DESC";
        try {
            rs = db.executeSelectQuery(query);
            while (rs != null && rs.next()) {
                User user = mapRowToUser(rs);
                user.setFullName(rs.getString("full_name"));
                list.add(user);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getAllStaffs failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public List<User> searchStaffAccounts(String keyword) {
        return searchStaff(keyword);
    }

    public List<User> searchStaff(String keyword) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        String query = "SELECT u.user_id, u.role_id, u.email, u.password, u.phone_number, u.status, u.created_at, u.updated_at, "
                + "p.full_name "
                + "FROM [User] u LEFT JOIN [Profile] p ON u.user_id = p.user_id "
                + "WHERE u.role_id = 2 AND u.status <> 'Inactive' "
                + "AND (p.full_name LIKE ? OR u.email LIKE ? OR u.phone_number LIKE ?) "
                + "ORDER BY u.created_at DESC";
        String wrap = "%" + (keyword != null ? keyword.trim() : "") + "%";
        try {
            rs = db.executeSelectQuery(query, new Object[]{wrap, wrap, wrap});
            while (rs != null && rs.next()) {
                User user = mapRowToUser(rs);
                user.setFullName(rs.getString("full_name"));
                list.add(user);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "searchStaff failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public User getStaffDetail(int staffId) {
        return getStaffById(staffId);
    }

    public User getStaffById(int staffId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        String query = "SELECT u.user_id, u.role_id, u.email, u.password, u.phone_number, u.status, u.created_at, u.updated_at, "
                + "p.full_name "
                + "FROM [User] u LEFT JOIN [Profile] p ON u.user_id = p.user_id "
                + "WHERE u.user_id = ? AND u.role_id = 2";
        try {
            rs = db.executeSelectQuery(query, new Object[]{staffId});
            if (rs != null && rs.next()) {
                User user = mapRowToUser(rs);
                user.setFullName(rs.getString("full_name"));
                return user;
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getStaffById failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return null;
    }

    public boolean insertStaffAccount(User staffUser) {
        staffUser.setRoleId(2);
        return insertAccount(staffUser);
    }

    public boolean updateStatus(int userId, String status) {
        DBContext db = new DBContext();
        String query = "UPDATE [User] SET status = ?, updated_at = GETDATE() WHERE user_id = ?";
        int affected = db.executeQuery(query, new Object[]{status, userId});
        return affected > 0;
    }

    public boolean updateUserStatus(int userId, String newStatus) {
        return updateStatus(userId, newStatus);
    }

    public List<User> getAllUsersByRole(int roleId) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        String query = "SELECT u.user_id, u.role_id, u.email, u.password, u.phone_number, u.status, u.created_at, u.updated_at, "
                + "p.full_name "
                + "FROM [User] u LEFT JOIN [Profile] p ON u.user_id = p.user_id "
                + "WHERE u.role_id = ? AND u.status <> 'Inactive' "
                + "ORDER BY u.created_at DESC";
        try {
            rs = db.executeSelectQuery(query, new Object[]{roleId});
            while (rs != null && rs.next()) {
                User user = mapRowToUser(rs);
                user.setFullName(rs.getString("full_name"));
                list.add(user);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "getAllUsersByRole failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    public List<User> searchUsersAcrossRoles(String keyword) {
        return searchUser(keyword);
    }

    public List<User> searchUser(String keyword) {
        DBContext db = new DBContext();
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        String query = "SELECT u.user_id, u.role_id, u.email, u.password, u.phone_number, u.status, u.created_at, u.updated_at, "
                + "p.full_name "
                + "FROM [User] u LEFT JOIN [Profile] p ON u.user_id = p.user_id "
                + "WHERE (u.role_id = 3 OR u.role_id = 4) AND u.status <> 'Inactive' "
                + "AND (p.full_name LIKE ? OR u.email LIKE ? OR u.phone_number LIKE ?) "
                + "ORDER BY u.created_at DESC";
        String wrap = "%" + (keyword != null ? keyword.trim() : "") + "%";
        try {
            rs = db.executeSelectQuery(query, new Object[]{wrap, wrap, wrap});
            while (rs != null && rs.next()) {
                User user = mapRowToUser(rs);
                user.setFullName(rs.getString("full_name"));
                list.add(user);
            }
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "searchUser failed", ex);
        } finally {
            db.closeResources(rs);
        }
        return list;
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setRoleId(rs.getInt("role_id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setStatus(rs.getString("status"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) user.setCreatedAt(createdAt.toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) user.setUpdatedAt(updatedAt.toLocalDateTime());

        return user;
    }
}
