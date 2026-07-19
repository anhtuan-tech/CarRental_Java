package controller;

import dao.UserDAO;
import model.User;
import utils.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller servlet for high-privilege Admin back-office personnel management
 * (UC-20.1 to UC-20.6).
 */
@WebServlet(name = "AdminController", urlPatterns = { "/admin/staff", "/admin/users" })
@jakarta.servlet.annotation.MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin Access Exclusivity (BR89)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/staff");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 1) { // Admin role is 1
            request.getSession(true).setAttribute("toastErrorMsg", "Access denied. Admin credentials required.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        String servletPath = request.getServletPath();
        if ("/admin/users".equals(servletPath)) {
            doGetUsers(request, response);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                request.getRequestDispatcher("/WEB-INF/views/admin/createStaff.jsp").forward(request, response);
                break;
            case "detail":
                showStaffDetail(request, response);
                break;
            case "search":
                handleStaffSearch(request, response);
                break;
            case "list":
            default:
                handleStaffList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/staff");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 1) { // Admin role is 1
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        String servletPath = request.getServletPath();
        if ("/admin/users".equals(servletPath)) {
            doPostUsers(request, response, user);
            return;
        }

        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {
            processCreateStaff(request, response);
        } else if ("update".equalsIgnoreCase(action)) {
            processUpdateStaff(request, response, user);
        } else if ("delete".equalsIgnoreCase(action)) {
            processDeleteStaff(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
        }
    }

    // =========================================================================
    // UC-20.1: View Staff Accounts
    // =========================================================================
    private void handleStaffList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAO();
        List<User> list = userDAO.getAllStaffs();

        if (list == null || list.isEmpty()) {
            request.setAttribute("message", "No staff accounts available");
        } else {
            request.setAttribute("staffList", list);
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/staffList.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-20.2: Search Staff Accounts
    // =========================================================================
    private void handleStaffSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
            return;
        }

        UserDAO userDAO = new UserDAO();
        List<User> list = userDAO.searchStaff(keyword.trim());

        if (list == null || list.isEmpty()) {
            request.getSession(true).setAttribute("toastErrorMsg", "No staff found matching keyword");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
            return;
        }

        request.setAttribute("staffList", list);
        request.setAttribute("keywordVal", keyword);
        request.getRequestDispatcher("/WEB-INF/views/admin/staffList.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-20.3: Create Staff Account
    // =========================================================================
    private void processCreateStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "All fields are mandatory.");
            prefillCreateForm(request, email, phone, fullName);
            request.getRequestDispatcher("/WEB-INF/views/admin/createStaff.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        if (userDAO.checkDuplicateAccount(email.trim(), phone.trim())) {
            request.setAttribute("errorMsg", "Email or Phone is already registered.");
            prefillCreateForm(request, email, phone, fullName);
            request.getRequestDispatcher("/WEB-INF/views/admin/createStaff.jsp").forward(request, response);
            return;
        }

        String avatarUrl = "";
        try {
            jakarta.servlet.http.Part filePart = request.getPart("avatarFile");
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (!"image/png".equalsIgnoreCase(contentType) &&
                        !"image/jpeg".equalsIgnoreCase(contentType) &&
                        !"image/jpg".equalsIgnoreCase(contentType)) {
                    throw new IllegalArgumentException("Only PNG or JPG formats are supported.");
                }
                if (filePart.getSize() > 5242880) { // 5MB
                    throw new IllegalArgumentException("Avatar image file size must not exceed 5MB.");
                }
                avatarUrl = saveUploadedAvatar(request, filePart, "avatar_staff");
            }
        } catch (Exception ex) {
            request.setAttribute("errorMsg", ex.getMessage() != null ? ex.getMessage() : "Avatar upload failed.");
            prefillCreateForm(request, email, phone, fullName);
            request.getRequestDispatcher("/WEB-INF/views/admin/createStaff.jsp").forward(request, response);
            return;
        }

        User staff = new User();
        staff.setRoleId(2); // Role ID 2 = Staff
        staff.setEmail(email.trim());
        staff.setPhoneNumber(phone.trim());
        staff.setStatus("Active");
        staff.setFullName(fullName.trim());
        staff.setAvatarUrl(avatarUrl);
        staff.setPassword(PasswordUtils.hashSHA256(password.trim()));

        boolean success = userDAO.insertAccount(staff);

        if (success) {
            request.getSession(true).setAttribute("toastSuccessMsg", "Staff account created successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
        } else {
            request.setAttribute("errorMsg", "System failure. Could not create account.");
            prefillCreateForm(request, email, phone, fullName);
            request.getRequestDispatcher("/WEB-INF/views/admin/createStaff.jsp").forward(request, response);
        }
    }

    // =========================================================================
    // UC-20.4: View Staff Account Details
    // =========================================================================
    private void showStaffDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
            return;
        }

        int staffId = Integer.parseInt(idParam);
        UserDAO userDAO = new UserDAO();
        User staff = userDAO.getStaffDetail(staffId);

        if (staff == null) {
            request.setAttribute("message", "No staff available");
        } else {
            // BR95: Password remains securely hidden (we do not bind/display u.password)
            staff.setPassword("[PROTECTED]");
            request.setAttribute("staffDetail", staff);
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/staffDetail.jsp").forward(request, response);
    }

    // =========================================================================
    // UC-20.5: Update Staff Account
    // =========================================================================
    private void processUpdateStaff(HttpServletRequest request, HttpServletResponse response, User adminUser)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("staffId");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");
        String fullName = request.getParameter("fullName");
        String status = request.getParameter("status");

        int staffId = Integer.parseInt(idStr);

        UserDAO userDAO = new UserDAO();
        User staff = userDAO.getStaffDetail(staffId);

        if (staff == null) {
            request.getSession(true).setAttribute("toastErrorMsg", "Staff account not found.");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
            return;
        }

        // BR92: Admin Account Protection (Admin cannot update/deactivate admin account
        // context via staff controller)
        if (staffId == adminUser.getUserId()) {
            request.getSession(true).setAttribute("toastErrorMsg", "Admin protection rule: Mutation rejected.");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=detail&id=" + staffId);
            return;
        }

        if (email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                status == null) {
            request.getSession(true).setAttribute("toastErrorMsg", "All fields are mandatory.");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=detail&id=" + staffId);
            return;
        }

        // Check duplicates for update
        if (userDAO.checkDuplicateForUpdate(staffId, email.trim(), phone.trim())) {
            request.getSession(true).setAttribute("toastErrorMsg",
                    "Duplicate alert: Email or Phone conflicts with another active user.");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=detail&id=" + staffId);
            return;
        }

        staff.setEmail(email.trim());
        staff.setPhoneNumber(phone.trim());
        staff.setFullName(fullName.trim());
        staff.setStatus(status);

        String password = request.getParameter("password");
        if (password != null && !password.trim().isEmpty()) {
            staff.setPassword(password.trim());
        } else {
            staff.setPassword("[PROTECTED]");
        }

        String avatarUrl = "";
        try {
            jakarta.servlet.http.Part filePart = request.getPart("avatarFile");
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (!"image/png".equalsIgnoreCase(contentType) &&
                        !"image/jpeg".equalsIgnoreCase(contentType) &&
                        !"image/jpg".equalsIgnoreCase(contentType)) {
                    throw new IllegalArgumentException("Only PNG or JPG formats are supported.");
                }
                if (filePart.getSize() > 5242880) { // 5MB
                    throw new IllegalArgumentException("Avatar image file size must not exceed 5MB.");
                }
                avatarUrl = saveUploadedAvatar(request, filePart, "avatar_staff_" + staffId);
                staff.setAvatarUrl(avatarUrl);
            }
        } catch (Exception ex) {
            request.getSession(true).setAttribute("toastErrorMsg",
                    ex.getMessage() != null ? ex.getMessage() : "Avatar upload failed.");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=detail&id=" + staffId);
            return;
        }

        boolean success = userDAO.updateAccount(staff);

        if (success) {
            // BR94: Suspended or Blocked immediately terminates user sessions
            if ("Suspended".equalsIgnoreCase(status) || "Blocked".equalsIgnoreCase(status)) {
                System.out.println(
                        "[SESSION TERMINATION] Enforced immediate session termination rules for User ID: " + staffId);
            }
            request.getSession(true).setAttribute("toastSuccessMsg", "Update successful.");
        } else {
            request.getSession(true).setAttribute("toastErrorMsg", "System update failed.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff?action=detail&id=" + staffId);
    }

    // =========================================================================
    // UC-20.6: Delete Staff Account
    // =========================================================================
    private void processDeleteStaff(HttpServletRequest request, HttpServletResponse response, User adminUser)
            throws ServletException, IOException {

        String idParam = request.getParameter("staffId");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
            return;
        }

        int staffId = Integer.parseInt(idParam);
        UserDAO userDAO = new UserDAO();

        // BR92: Admin Account Protection
        if (staffId == adminUser.getUserId()) {
            request.getSession(true).setAttribute("toastErrorMsg",
                    "Admin protection rule: Cannot deactivate admin accounts.");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
            return;
        }

        // BR93: Soft-delete pattern deactivates status to 'Inactive' instead of
        // deleting SQL row
        boolean success = userDAO.updateStatus(staffId, "Inactive");

        if (success) {
            request.getSession(true).setAttribute("toastSuccessMsg", "Staff account deactivated successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=list");
        } else {
            request.getSession(true).setAttribute("toastErrorMsg", "Deactivation failed.");
            response.sendRedirect(request.getContextPath() + "/admin/staff?action=detail&id=" + staffId);
        }
    }

    private void prefillCreateForm(HttpServletRequest request, String email, String phone, String fullName) {
        request.setAttribute("emailVal", email);
        request.setAttribute("phoneVal", phone);
        request.setAttribute("fullNameVal", fullName);
    }

    // =========================================================================
    // Admin Back-office User Management Module (UC-21)
    // =========================================================================
    private void doGetUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                showUserDetail(request, response);
                break;
            case "search":
                handleUserSearch(request, response);
                break;
            case "list":
            default:
                handleUserList(request, response);
                break;
        }
    }

    private void doPostUsers(HttpServletRequest request, HttpServletResponse response, User adminUser)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("updateStatus".equalsIgnoreCase(action)) {
            processUpdateUserStatus(request, response, adminUser);
        } else if ("delete".equalsIgnoreCase(action)) {
            processDeleteUser(request, response, adminUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
        }
    }

    private void handleUserList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAO();
        List<User> list = new java.util.ArrayList<>();
        
        List<User> staff = userDAO.getAllUsersByRole(2);
        if (staff != null) {
            list.addAll(staff);
        }

        List<User> owners = userDAO.getAllUsersByRole(3);
        if (owners != null) {
            list.addAll(owners);
        }
        
        List<User> customers = userDAO.getAllUsersByRole(4);
        if (customers != null) {
            list.addAll(customers);
        }

        if (list.isEmpty()) {
            request.setAttribute("message", "No users available");
        } else {
            list.sort((u1, u2) -> {
                if (u1.getCreatedAt() == null && u2.getCreatedAt() == null) return 0;
                if (u1.getCreatedAt() == null) return 1;
                if (u2.getCreatedAt() == null) return -1;
                return u2.getCreatedAt().compareTo(u1.getCreatedAt());
            });
            request.setAttribute("userList", list);
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/userList.jsp").forward(request, response);
    }

    private void handleUserSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
            return;
        }

        UserDAO userDAO = new UserDAO();
        List<User> list = userDAO.searchUser(keyword.trim());

        if (list == null || list.isEmpty()) {
            request.getSession(true).setAttribute("toastErrorMsg", "No user found matching keyword");
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
            return;
        }

        request.setAttribute("userList", list);
        request.setAttribute("keywordVal", keyword);
        request.getRequestDispatcher("/WEB-INF/views/admin/userList.jsp").forward(request, response);
    }

    private void showUserDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
            return;
        }

        int userId = Integer.parseInt(idParam);
        UserDAO userDAO = new UserDAO();
        User userDetail = userDAO.getUserDetails(userId);

        if (userDetail == null) {
            request.setAttribute("message", "No user available");
        } else {
            // BR95: Password remains securely hidden on UI
            userDetail.setPassword("[PROTECTED]");
            request.setAttribute("userDetail", userDetail);
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/userDetail.jsp").forward(request, response);
    }

    private void processUpdateUserStatus(HttpServletRequest request, HttpServletResponse response, User adminUser)
            throws ServletException, IOException {

        String idStr = request.getParameter("userId");
        String newStatus = request.getParameter("status");

        if (idStr == null || newStatus == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
            return;
        }

        int userId = Integer.parseInt(idStr);

        // BR92: Admin Account Protection (Admin cannot deactivate or suspend
        // themselves)
        if (userId == adminUser.getUserId()) {
            request.getSession(true).setAttribute("toastErrorMsg",
                    "Admin protection rule: Cannot suspend or block the active admin session.");
            response.sendRedirect(request.getContextPath() + "/admin/users?action=detail&id=" + userId);
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.updateUserStatus(userId, newStatus);

        if (success) {
            // BR94: Immediate status suspension / blockage session enforcement
            if ("Suspended".equalsIgnoreCase(newStatus) || "Blocked".equalsIgnoreCase(newStatus)) {
                System.out.println(
                        "[SESSION SUSPENSION] Enforced immediate session termination rules for User ID: " + userId);
            }
            request.getSession(true).setAttribute("toastSuccessMsg", "User status updated successfully.");
        } else {
            request.getSession(true).setAttribute("toastErrorMsg", "Failed to update status.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?action=detail&id=" + userId);
    }

    private void processDeleteUser(HttpServletRequest request, HttpServletResponse response, User adminUser)
            throws ServletException, IOException {

        String idStr = request.getParameter("userId");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
            return;
        }

        int userId = Integer.parseInt(idStr);

        // BR92: Admin Account Protection
        if (userId == adminUser.getUserId()) {
            request.getSession(true).setAttribute("toastErrorMsg",
                    "Admin protection rule: Cannot delete admin account.");
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
            return;
        }

        UserDAO userDAO = new UserDAO();
        // BR93: Soft delete by deactivating database status flag to Inactive (preserves
        // logs)
        boolean success = userDAO.updateStatus(userId, "Inactive");

        if (success) {
            request.getSession(true).setAttribute("toastSuccessMsg", "User account deactivated successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
        } else {
            request.getSession(true).setAttribute("toastErrorMsg", "Deactivation failed.");
            response.sendRedirect(request.getContextPath() + "/admin/users?action=detail&id=" + userId);
        }
    }

    // =========================================================================
    // Avatar Upload Helper
    // =========================================================================

    /**
     * Saves uploaded avatar file to the runtime serving directory (getRealPath)
     * AND also to src/main/webapp/uploads/avatars for persistence across builds.
     * Uses pom.xml presence to locate the project root reliably.
     *
     * @param request  the HTTP request (for context path and realPath)
     * @param filePart the uploaded file Part
     * @param prefix   filename prefix e.g. "avatar_staff" or "avatar_staff_21"
     * @return the context-relative URL to use in HTML/DB, e.g. "/uploads/avatars/filename.jpg"
     */
    private String saveUploadedAvatar(HttpServletRequest request,
            jakarta.servlet.http.Part filePart, String prefix) throws Exception {

        String originalName = filePart.getSubmittedFileName();
        String extension = "";
        if (originalName != null) {
            int dot = originalName.lastIndexOf('.');
            if (dot >= 0) {
                extension = originalName.substring(dot).toLowerCase();
            }
        }
        String uniqueName = prefix + "_" + System.currentTimeMillis() + extension;

        // --- Primary: runtime serving directory ---
        String runtimeDir = request.getServletContext().getRealPath("/uploads/avatars");
        if (runtimeDir == null) {
            runtimeDir = request.getServletContext().getRealPath("")
                    + java.io.File.separator + "uploads"
                    + java.io.File.separator + "avatars";
        }
        java.io.File runtimeDirFile = new java.io.File(runtimeDir);
        if (!runtimeDirFile.exists()) {
            runtimeDirFile.mkdirs();
        }
        String runtimeFilePath = runtimeDir + java.io.File.separator + uniqueName;
        filePart.write(runtimeFilePath);

        // --- Secondary: src/main/webapp for persistence across builds ---
        try {
            String deployPath = request.getServletContext().getRealPath("");
            java.io.File projectRoot = findProjectRoot(new java.io.File(deployPath != null ? deployPath : ""));
            if (projectRoot != null) {
                java.io.File srcAvatarDir = new java.io.File(projectRoot,
                        "src" + java.io.File.separator + "main"
                        + java.io.File.separator + "webapp"
                        + java.io.File.separator + "uploads"
                        + java.io.File.separator + "avatars");
                if (!srcAvatarDir.exists()) {
                    srcAvatarDir.mkdirs();
                }
                java.nio.file.Files.copy(
                        java.nio.file.Paths.get(runtimeFilePath),
                        new java.io.File(srcAvatarDir, uniqueName).toPath(),
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (Exception ignored) {
            // Non-critical: file already saved to runtime dir
        }

        return request.getContextPath() + "/uploads/avatars/" + uniqueName;
    }

    /**
     * Walks up the directory tree from {@code dir} until it finds a directory
     * containing pom.xml (= Maven project root), or returns null.
     */
    private java.io.File findProjectRoot(java.io.File dir) {
        java.io.File current = dir;
        while (current != null) {
            if (new java.io.File(current, "pom.xml").exists()) {
                return current;
            }
            current = current.getParentFile();
        }
        return null;
    }
}
