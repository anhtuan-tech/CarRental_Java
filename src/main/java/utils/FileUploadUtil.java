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
            saveBytes(bytes, subFolder, uniqueName, request);
        }

        return "/uploads/" + subFolder + "/" + uniqueName;
    }

    /**
     * Save a raw byte array (e.g. decoded base64 cropped image) to the specified sub-folder.
     *
     * @param data       Raw image bytes
     * @param fileName   Desired filename (should be unique, e.g. UUID + ".jpg")
     * @param subFolder  e.g. "cars" or "avatars"
     * @param request    Current request
     * @return Relative URL path, e.g. "/uploads/cars/uuid.jpg"
     */
    public static String saveByteArrayFile(byte[] data, String fileName, String subFolder,
                                           HttpServletRequest request) throws IOException {
        if (data == null || data.length == 0) {
            return null;
        }
        saveBytes(data, subFolder, fileName, request);
        return "/uploads/" + subFolder + "/" + fileName;
    }

    // -------------------------------------------------------------------------
    // Internal helpers
    // -------------------------------------------------------------------------

    private static void saveBytes(byte[] bytes, String subFolder, String fileName, HttpServletRequest request) throws IOException {
        String runtimeBase = (request != null && request.getServletContext() != null) ? request.getServletContext().getRealPath("") : null;

        // 1. Primary: Save directly to src/main/webapp/uploads/subFolder/fileName
        try {
            File srcWebapp = findSourceWebappDirectory(runtimeBase);
            if (srcWebapp != null && srcWebapp.exists()) {
                File srcDir = new File(srcWebapp, "uploads" + File.separator + subFolder);
                if (!srcDir.exists()) srcDir.mkdirs();
                File srcFile = new File(srcDir, fileName);
                Files.write(srcFile.toPath(), bytes);
                System.out.println("[FileUploadUtil] Saved to SRC → " + srcFile.getAbsolutePath());
            }
        } catch (Exception e) {
            System.err.println("[FileUploadUtil] Could not write to SRC: " + e.getMessage());
        }

        // 2. Secondary: Save to target/CarRental-1.0-SNAPSHOT/uploads/subFolder/fileName
        if (runtimeBase != null) {
            try {
                File targetDir = new File(runtimeBase, "uploads" + File.separator + subFolder);
                if (!targetDir.exists()) targetDir.mkdirs();
                File targetFile = new File(targetDir, fileName);
                Files.write(targetFile.toPath(), bytes);
                System.out.println("[FileUploadUtil] Saved to TARGET → " + targetFile.getAbsolutePath());
            } catch (Exception ignored) {}
        }

        // 3. Fallback: Save to catalina.home/uploads/subFolder/fileName
        try {
            File catDir = new File(getUploadRoot(), subFolder);
            if (!catDir.exists()) catDir.mkdirs();
            File catFile = new File(catDir, fileName);
            Files.write(catFile.toPath(), bytes);
        } catch (Exception ignored) {}
    }

    /**
     * Rename a temporary file (e.g. car_temp_...jpg) to its clean final name (e.g. car_5.jpg).
     * Updates both runtime target directory AND source webapp directory.
     * 
     * @return Clean relative URL, e.g. "/uploads/cars/car_5.jpg"
     */
    public static String renameUploadedFile(String oldRelativeUrl, String newFileName, String subFolder, HttpServletRequest request) {
        if (oldRelativeUrl == null || oldRelativeUrl.trim().isEmpty() || !oldRelativeUrl.contains("temp_")) {
            return oldRelativeUrl;
        }

        try {
            String oldFileName = oldRelativeUrl.substring(oldRelativeUrl.lastIndexOf('/') + 1);
            String runtimeBase = request != null && request.getServletContext() != null 
                    ? request.getServletContext().getRealPath("") : null;

            // 1. Rename in Source (src/main/webapp/uploads/subFolder)
            File srcWebappDir = findSourceWebappDirectory(runtimeBase);
            if (srcWebappDir != null && srcWebappDir.exists()) {
                File srcSubDir = new File(srcWebappDir, "uploads" + File.separator + subFolder);
                File oldSrcFile = new File(srcSubDir, oldFileName);
                File newSrcFile = new File(srcSubDir, newFileName);
                if (oldSrcFile.exists()) {
                    if (newSrcFile.exists()) newSrcFile.delete();
                    oldSrcFile.renameTo(newSrcFile);
                    System.out.println("[FileUploadUtil] Renamed in SRC → " + newSrcFile.getAbsolutePath());
                }
            }

            // 2. Rename in Runtime (target/CarRental-1.0-SNAPSHOT/uploads/subFolder)
            if (runtimeBase != null) {
                File runtimeSubDir = new File(runtimeBase, "uploads" + File.separator + subFolder);
                File oldRuntimeFile = new File(runtimeSubDir, oldFileName);
                File newRuntimeFile = new File(runtimeSubDir, newFileName);
                if (oldRuntimeFile.exists()) {
                    if (newRuntimeFile.exists()) newRuntimeFile.delete();
                    oldRuntimeFile.renameTo(newRuntimeFile);
                    System.out.println("[FileUploadUtil] Renamed in TARGET → " + newRuntimeFile.getAbsolutePath());
                }
            }

            // 3. Rename in catalina.home
            File catSubDir = new File(getUploadRoot(), subFolder);
            File oldCatFile = new File(catSubDir, oldFileName);
            File newCatFile = new File(catSubDir, newFileName);
            if (oldCatFile.exists()) {
                if (newCatFile.exists()) newCatFile.delete();
                oldCatFile.renameTo(newCatFile);
            }

            return "/uploads/" + subFolder + "/" + newFileName;
        } catch (Exception e) {
            System.err.println("[FileUploadUtil] Error renaming file: " + e.getMessage());
            return oldRelativeUrl;
        }
    }

    private static File findSourceWebappDirectory(String runtimeRealPath) {
        if (runtimeRealPath == null) return null;
        File current = new File(runtimeRealPath);

        while (current != null) {
            File srcWebapp = new File(current, "src" + File.separator + "main" + File.separator + "webapp");
            if (srcWebapp.exists() && srcWebapp.isDirectory()) {
                return srcWebapp;
            }
            if (current.getName().equalsIgnoreCase("target")) {
                File parent = current.getParentFile();
                if (parent != null) {
                    File srcWebappParent = new File(parent, "src" + File.separator + "main" + File.separator + "webapp");
                    if (srcWebappParent.exists() && srcWebappParent.isDirectory()) {
                        return srcWebappParent;
                    }
                }
            }
            current = current.getParentFile();
        }
        return null;
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
