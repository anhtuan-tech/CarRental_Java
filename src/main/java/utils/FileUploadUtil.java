package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.UUID;

/**
 * Portable file uploader — stores files in {catalina.home}/uploads/{subFolder}/.
 *
 * WHY catalina.home?
 *  - It is always set by Tomcat on every machine, regardless of OS or drive letter.
 *  - The uploads folder lives OUTSIDE the webapp deploy directory, so files are
 *    NEVER deleted when you redeploy, clean-build, or move the project.
 *  - Works identically on dev machines, staging, and production servers.
 *
 * Files are served back by ImageServlet (mapped to /uploads/**).
 */
public class FileUploadUtil {

    /**
     * Returns the absolute root directory where uploads are stored.
     * e.g.  {catalina.home}/uploads/
     */
    public static File getUploadRoot() {
        // catalina.home is always set by Tomcat
        String catalinaHome = System.getProperty("catalina.home");
        if (catalinaHome == null || catalinaHome.isEmpty()) {
            // Fallback for non-Tomcat environments (unit tests, embedded servers...)
            catalinaHome = System.getProperty("user.home");
        }
        return new File(catalinaHome, "uploads");
    }

    /**
     * Save an uploaded {@link Part} (multipart form file) to the specified sub-folder.
     *
     * @param part      Uploaded Part
     * @param subFolder e.g. "cars" or "avatars"
     * @param request   Current request (used only to read contextPath)
     * @return Relative URL path suitable for storing in the DB, e.g. "/uploads/cars/uuid.jpg"
     *         Returns null if the part is empty or null.
     */
    public static String saveUploadedFile(Part part, String subFolder, HttpServletRequest request) throws IOException {
        if (part == null || part.getSize() <= 0) {
            return null;
        }

        String originalFileName = getSubmittedFileName(part);
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            return null;
        }

        // Preserve extension
        String ext = "";
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex >= 0) {
            ext = originalFileName.substring(dotIndex).toLowerCase();
        }
        String uniqueName = UUID.randomUUID().toString() + ext;

        try (InputStream is = part.getInputStream()) {
            byte[] bytes = is.readAllBytes();
            saveBytes(bytes, subFolder, uniqueName);
        }

        return "/uploads/" + subFolder + "/" + uniqueName;
    }

    /**
     * Save a raw byte array (e.g. decoded base64 cropped image) to the specified sub-folder.
     *
     * @param data       Raw image bytes
     * @param fileName   Desired filename (should be unique, e.g. UUID + ".jpg")
     * @param subFolder  e.g. "cars" or "avatars"
     * @param request    Current request (kept for API compatibility)
     * @return Relative URL path, e.g. "/uploads/cars/uuid.jpg"
     */
    public static String saveByteArrayFile(byte[] data, String fileName, String subFolder,
                                           HttpServletRequest request) throws IOException {
        if (data == null || data.length == 0) {
            return null;
        }
        saveBytes(data, subFolder, fileName);
        return "/uploads/" + subFolder + "/" + fileName;
    }

    // -------------------------------------------------------------------------
    // Internal helpers
    // -------------------------------------------------------------------------

    private static void saveBytes(byte[] bytes, String subFolder, String fileName) throws IOException {
        File targetDir = new File(getUploadRoot(), subFolder);
        if (!targetDir.exists()) {
            targetDir.mkdirs();
        }
        File targetFile = new File(targetDir, fileName);
        Files.write(targetFile.toPath(), bytes);
        System.out.println("[FileUploadUtil] Saved → " + targetFile.getAbsolutePath());
    }

    /**
     * Extract the original filename from a multipart {@link Part} header.
     */
    public static String getSubmittedFileName(Part part) {
        if (part == null) return null;
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) return null;
        for (String cd : contentDisposition.split(";")) {
            if (cd.trim().startsWith("filename")) {
                String raw = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                // Normalise slashes from both Linux and Windows upload paths
                return raw.substring(Math.max(raw.lastIndexOf('/'), raw.lastIndexOf('\\')) + 1);
            }
        }
        return null;
    }
}
