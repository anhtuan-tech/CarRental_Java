package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.UUID;

/**
 * Saves uploaded files directly to src/main/webapp/uploads/ (committed in Git).
 * Images are served by ImageServlet which reads from the same location.
 *
 * This approach ensures:
 *  - Images survive clean builds (they are in source, not in target).
 *  - Any team member who does "git pull" will have all images immediately.
 *  - No dependency on catalina.home or any machine-specific path.
 */
public class FileUploadUtil {

    /**
     * Save an uploaded Part (multipart form file) to the specified sub-folder.
     *
     * @param part      Uploaded Part
     * @param subFolder e.g. "cars" or "avatars"
     * @param request   Current HTTP request
     * @return Relative URL e.g. "/uploads/cars/uuid.jpg", or null if part is empty.
     */
    public static String saveUploadedFile(Part part, String subFolder,
                                          HttpServletRequest request) throws IOException {
        if (part == null || part.getSize() <= 0) return null;

        String original = getSubmittedFileName(part);
        if (original == null || original.trim().isEmpty()) return null;

        String ext = "";
        int dot = original.lastIndexOf('.');
        if (dot >= 0) ext = original.substring(dot).toLowerCase();

        String fileName = UUID.randomUUID().toString() + ext;

        try (InputStream is = part.getInputStream()) {
            saveBytes(is.readAllBytes(), subFolder, fileName, request);
        }

        return "/uploads/" + subFolder + "/" + fileName;
    }

    /**
     * Save a raw byte array (e.g. decoded base64 image) to the specified sub-folder.
     *
     * @param data      Raw image bytes
     * @param fileName  Desired filename (e.g. "car_uuid.jpg")
     * @param subFolder e.g. "cars" or "avatars"
     * @param request   Current HTTP request
     * @return Relative URL e.g. "/uploads/cars/car_uuid.jpg"
     */
    public static String saveByteArrayFile(byte[] data, String fileName,
                                            String subFolder, HttpServletRequest request) throws IOException {
        if (data == null || data.length == 0) return null;
        saveBytes(data, subFolder, fileName, request);
        return "/uploads/" + subFolder + "/" + fileName;
    }

    // -------------------------------------------------------------------------

    private static void saveBytes(byte[] bytes, String subFolder,
                                  String fileName, HttpServletRequest request) throws IOException {
        File srcWebapp = findSourceWebappDir(request);
        if (srcWebapp == null) {
            throw new IOException("[FileUploadUtil] Cannot locate src/main/webapp directory.");
        }

        File dir = new File(srcWebapp, "uploads" + File.separator + subFolder);
        if (!dir.exists()) dir.mkdirs();

        File out = new File(dir, fileName);
        Files.write(out.toPath(), bytes);
        System.out.println("[FileUploadUtil] Saved -> " + out.getAbsolutePath());
    }

    /**
     * Walks up from the deployed target directory to find src/main/webapp.
     * Works on any machine with a standard Maven layout.
     */
    private static File findSourceWebappDir(HttpServletRequest request) {
        if (request == null || request.getServletContext() == null) return null;
        String runtimeBase = request.getServletContext().getRealPath("");
        if (runtimeBase == null) return null;

        File current = new File(runtimeBase);
        while (current != null) {
            if (current.getName().equalsIgnoreCase("target")) {
                File srcWebapp = new File(current.getParentFile(),
                        "src" + File.separator + "main" + File.separator + "webapp");
                if (srcWebapp.exists()) return srcWebapp;
                break;
            }
            current = current.getParentFile();
        }
        return null;
    }

    /**
     * Rename a temporary file in the src/main/webapp/uploads directory.
     * 
     * @return New relative URL, e.g. "/uploads/cars/car_5.jpg"
     */
    public static String renameUploadedFile(String oldRelativeUrl, String newFileName, 
                                            String subFolder, HttpServletRequest request) {
        if (oldRelativeUrl == null || oldRelativeUrl.trim().isEmpty() || !oldRelativeUrl.contains("temp_")) {
            return oldRelativeUrl;
        }

        try {
            String oldFileName = oldRelativeUrl.substring(oldRelativeUrl.lastIndexOf('/') + 1);
            File srcWebapp = findSourceWebappDir(request);
            if (srcWebapp != null && srcWebapp.exists()) {
                File srcSubDir = new File(srcWebapp, "uploads" + File.separator + subFolder);
                File oldSrcFile = new File(srcSubDir, oldFileName);
                File newSrcFile = new File(srcSubDir, newFileName);
                if (oldSrcFile.exists()) {
                    if (newSrcFile.exists()) newSrcFile.delete();
                    oldSrcFile.renameTo(newSrcFile);
                    System.out.println("[FileUploadUtil] Renamed in SRC -> " + newSrcFile.getAbsolutePath());
                }
            }
            return "/uploads/" + subFolder + "/" + newFileName;
        } catch (Exception e) {
            System.err.println("[FileUploadUtil] Error renaming file: " + e.getMessage());
            return oldRelativeUrl;
        }
    }

    /**
     * Extracts the original filename from a multipart Part header.
     */
    public static String getSubmittedFileName(Part part) {
        if (part == null) return null;
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            if (token.trim().startsWith("filename")) {
                String raw = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                return raw.substring(Math.max(raw.lastIndexOf('/'), raw.lastIndexOf('\\')) + 1);
            }
        }
        return null;
    }
}
