package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Profile;
import model.User;
import utils.PasswordUtils;

import java.io.File;
import java.io.IOException;

/**
 * Controller servlet for Profile management sub-use cases (UC-12.1, UC-12.2, UC-12.3).
 */
@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 5,       // 5MB (BR11)
        maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/customer");
            return;
        }

        User userSession = (User) session.getAttribute("user");
        if (userSession.getRoleId() == 1 || userSession.getRoleId() == 2) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied for Admin/Staff profile management.");
            return;
        }
        UserDAO userDAO = new UserDAO();

        User user = userDAO.getUserById(userSession.getUserId());
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Profile profile = userDAO.getProfileByUserId(userSession.getUserId());
        if (profile == null) {
            profile = new Profile();
            profile.setUserId(user.getUserId());
            profile.setFullName(user.getFullName() != null ? user.getFullName() : "");
            profile.setAvatarUrl("");
            profile.setDriverLicense("");
            profile.setIdCardNo("");
            profile.setAddress("");
            userDAO.createProfile(profile);
        }

        request.setAttribute("user", user);
        request.setAttribute("profile", profile);

        request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login/customer");
            return;
        }

        User userSession = (User) session.getAttribute("user");
        if (userSession.getRoleId() == 1 || userSession.getRoleId() == 2) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied for Admin/Staff profile management.");
            return;
        }
        String action = request.getParameter("action");

        if ("edit".equalsIgnoreCase(action)) {
            handleEditProfile(request, response, userSession);
        } else if ("changePassword".equalsIgnoreCase(action)) {
            handleChangePassword(request, response, userSession);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    private void handleEditProfile(HttpServletRequest request, HttpServletResponse response, User userSession)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String driverLicense = request.getParameter("driverLicense");
        String idCardNo = request.getParameter("idCardNo");
        String address = request.getParameter("address");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(userSession.getUserId());
        Profile profile = userDAO.getProfileByUserId(userSession.getUserId());

        // Validate mandatory fields (BR10)
        if (fullName == null || fullName.trim().isEmpty() || phoneNumber == null || phoneNumber.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Full Name and Phone Number are mandatory.");
            request.setAttribute("user", user);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
            return;
        }

        String avatarUrl = profile.getAvatarUrl();
        String croppedAvatarBase64 = null;
        try {
            Part croppedPart = request.getPart("croppedAvatarBase64");
            croppedAvatarBase64 = getValueFromPart(croppedPart);
        } catch (Exception ignored) {}
        if (croppedAvatarBase64 == null || croppedAvatarBase64.trim().isEmpty()) {
            croppedAvatarBase64 = request.getParameter("croppedAvatarBase64");
        }

        if (croppedAvatarBase64 != null && !croppedAvatarBase64.trim().isEmpty()) {
            try {
                String[] parts = croppedAvatarBase64.split(",");
                String base64Data = parts.length > 1 ? parts[1] : parts[0];
                byte[] imageBytes = java.util.Base64.getDecoder().decode(base64Data.trim());
                
                String avatarFileName = "avatar_" + user.getUserId() + ".jpg";
                avatarUrl = utils.FileUploadUtil.saveByteArrayFile(imageBytes, avatarFileName, "avatars", request);
            } catch (Exception ex) {
                request.setAttribute("errorMsg", "Failed to process cropped avatar image: " + ex.getMessage());
                request.setAttribute("user", user);
                request.setAttribute("profile", profile);
                request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
                return;
            }
        } else {
            try {
                Part filePart = request.getPart("avatarFile");
                if (filePart != null && filePart.getSize() > 0) {
                    // Validate format & size (BR11)
                    String contentType = filePart.getContentType();
                    if (!"image/png".equalsIgnoreCase(contentType) &&
                        !"image/jpeg".equalsIgnoreCase(contentType) &&
                        !"image/jpg".equalsIgnoreCase(contentType)) {
                        throw new IllegalArgumentException("Only PNG or JPG formats are supported.");
                    }

                    if (filePart.getSize() > 5242880) { // 5MB
                        throw new IllegalArgumentException("Avatar image file size must not exceed 5MB.");
                    }

                    String avatarFileName = "avatar_" + user.getUserId() + ".jpg";
                    byte[] fileBytes = filePart.getInputStream().readAllBytes();
                    avatarUrl = utils.FileUploadUtil.saveByteArrayFile(fileBytes, avatarFileName, "avatars", request);
                }
            } catch (IllegalArgumentException ex) {
                request.setAttribute("errorMsg", ex.getMessage());
                request.setAttribute("user", user);
                request.setAttribute("profile", profile);
                request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
                return;
            }
        }

        // Apply changes
        user.setPhoneNumber(phoneNumber.trim());
        user.setFullName(fullName.trim());
        user.setAvatarUrl(avatarUrl);

        profile.setFullName(fullName.trim());
        profile.setDriverLicense(driverLicense != null ? driverLicense.trim() : "");
        profile.setIdCardNo(idCardNo != null ? idCardNo.trim() : "");
        profile.setAddress(address != null ? address.trim() : "");
        profile.setAvatarUrl(avatarUrl);

        boolean updateU = userDAO.updateUser(user);
        boolean updateP = userDAO.updateProfile(profile);

        if (updateU && updateP) {
            // Update session info
            request.getSession(true).setAttribute("user", user);
            request.getSession(true).setAttribute("toastSuccessMsg", "Update Successful.");
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("errorMsg", "Database update failed. Please try again.");
            request.setAttribute("user", user);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User userSession)
            throws ServletException, IOException {

        String currentPwd = request.getParameter("currentPassword");
        String newPwd = request.getParameter("newPassword");
        String confirmPwd = request.getParameter("confirmPassword");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(userSession.getUserId());
        Profile profile = userDAO.getProfileByUserId(userSession.getUserId());

        if (currentPwd == null || currentPwd.isEmpty() || newPwd == null || newPwd.isEmpty()) {
            request.setAttribute("errorMsg", "All password fields are required.");
            request.setAttribute("user", user);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
            return;
        }

        // BR13 – Password Complexity
        if (newPwd.length() < 8) {
            request.setAttribute("errorMsg", "New password must be at least 8 characters.");
            request.setAttribute("user", user);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
            return;
        }

        // BR14 – Same as old password check
        if (currentPwd.equals(newPwd)) {
            request.setAttribute("errorMsg", "New password cannot be identical to the current password.");
            request.setAttribute("user", user);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
            return;
        }

        // Check if passwords match
        if (!newPwd.equals(confirmPwd)) {
            request.setAttribute("errorMsg", "New password and confirmation password do not match.");
            request.setAttribute("user", user);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
            return;
        }

        // Verify current password correctness
        boolean isCurrentCorrect = userDAO.checkCurrentPassword(user.getUserId(), currentPwd);
        if (!isCurrentCorrect) {
            request.setAttribute("errorMsg", "Current password incorrect.");
            request.setAttribute("user", user);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
            return;
        }

        // Hash new password using SHA-256 and update
        String hashedNew = PasswordUtils.hashSHA256(newPwd);
        boolean success = userDAO.updatePassword(user.getUserId(), hashedNew);

        if (success) {
            request.getSession(true).setAttribute("toastSuccessMsg", "Password updated successfully.");
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("errorMsg", "Failed to update password. Please try again.");
            request.setAttribute("user", user);
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/WEB-INF/views/common/profile.jsp").forward(request, response);
        }
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1); // safe filename
            }
        }
        return "unknown";
    }

    private String getValueFromPart(Part part) throws IOException {
        if (part == null) return null;
        try (java.io.BufferedReader reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(part.getInputStream(), java.nio.charset.StandardCharsets.UTF_8))) {
            StringBuilder value = new StringBuilder();
            char[] buffer = new char[1024];
            int length;
            while ((length = reader.read(buffer)) > 0) {
                value.append(buffer, 0, length);
            }
            return value.toString();
        }
    }
}
