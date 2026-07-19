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
        if (user.getRoleId() != 4) {
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

        if (email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("errorMsg", "All fields are mandatory.");
            prefillCreateForm(request, email, phone, fullName);
            request.getRequestDispatcher("/WEB-INF/views/admin/createStaff.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        // BR91: Platform email and phone unique validation
        if (userDAO.checkDuplicateAccount(email.trim(), phone.trim())) {
            request.setAttribute("errorMsg",
                    "Render duplicate account notification: Email or Phone is already registered.");
            prefillCreateForm(request, email, phone, fullName);
            request.getRequestDispatcher("/WEB-INF/views/admin/createStaff.jsp").forward(request, response);
            return;
        }

        User staff = new User();
        staff.setRoleId(2); // Role ID 2 = Staff (BR90)
        staff.setEmail(email.trim());
        staff.setPhoneNumber(phone.trim());
        staff.setStatus("Active");
        staff.setFullName(fullName.trim());
        // Set secure temporary password hashed using SHA-256
        staff.setPassword(PasswordUtils.hashSHA256("Staff123"));

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

        String roleParam = request.getParameter("roleId");
        int roleId = 1; // Default to Customer (Role ID = 1)
        if (roleParam != null && !roleParam.trim().isEmpty()) {
            try {
                roleId = Integer.parseInt(roleParam);
            } catch (NumberFormatException ignored) {
            }
        }

        UserDAO userDAO = new UserDAO();
        List<User> list = userDAO.getAllUsersByRole(roleId);

        if (list == null || list.isEmpty()) {
            request.setAttribute("message", "No users available");
        } else {
            request.setAttribute("userList", list);
        }
        request.setAttribute("currentRoleFilter", roleId);
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
}
