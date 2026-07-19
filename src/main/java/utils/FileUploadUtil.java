package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * Universal portable file uploader.
 * Automatically saves uploaded files to BOTH the runtime target directory 
 * AND the dynamic source workspace directory (src/main/webapp/uploads).
 * 
 * Works seamlessly across different machines, OS, and drives when team members pull code via Git.
 */
public class FileUploadUtil {

    /**
     * Save an uploaded Part to the target subfolder (e.g. "cars" or "avatars").
     * 
     * @param part Uploaded Part object
     * @param subFolder Subfolder under uploads directory (e.g. "cars", "avatars")
     * @param request HttpServletRequest
     * @return Context-relative URL path, e.g. "/uploads/cars/uuid_filename.jpg"
     */
    public static String saveUploadedFile(Part part, String subFolder, HttpServletRequest request) throws IOException {
        if (part == null || part.getSize() <= 0) {
            return null;
        }

        String originalFileName = getSubmittedFileName(part);
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            return null;
        }

        // Clean extension
        String ext = "";
        int dotIndex = originalFileName.lastIndexOf(".");
        if (dotIndex >= 0) {
            ext = originalFileName.substring(dotIndex);
        }
        String uniqueName = UUID.randomUUID().toString().substring(0, 8) + "_" + System.currentTimeMillis() + ext;

        // 1. Save to Runtime deployment directory (target/CarRental-1.0-SNAPSHOT/uploads/subFolder)
        String runtimeBase = request.getServletContext().getRealPath("");
        File runtimeSubDir = new File(runtimeBase, "uploads" + File.separator + subFolder);
        if (!runtimeSubDir.exists()) {
            runtimeSubDir.mkdirs();
        }
        File runtimeFile = new File(runtimeSubDir, uniqueName);

        // Save to source webapp dir and runtime dir
        saveFileToWebappDirs(runtimeBase, subFolder, uniqueName, part.getInputStream());

        // Return clean relative path for DB, e.g., "/uploads/cars/filename.jpg"
        return "/uploads/" + subFolder + "/" + uniqueName;
    }

    /**
     * Helper to save raw byte array (e.g., base64 cropped avatar)
     */
    public static String saveByteArrayFile(byte[] data, String uniqueName, String subFolder, HttpServletRequest request) throws IOException {
        if (data == null || data.length == 0) {
            return null;
        }

        String runtimeBase = request.getServletContext().getRealPath("");
        saveBytesToWebappDirs(runtimeBase, subFolder, uniqueName, data);

        // Return clean relative path for DB, e.g., "/uploads/avatars/filename.jpg"
        return "/uploads/" + subFolder + "/" + uniqueName;
    }

    private static void saveFileToWebappDirs(String runtimeBase, String subFolder, String fileName, InputStream is) throws IOException {
        byte[] bytes = is.readAllBytes();
        saveBytesToWebappDirs(runtimeBase, subFolder, fileName, bytes);
    }

    private static void saveBytesToWebappDirs(String runtimeBase, String subFolder, String fileName, byte[] bytes) throws IOException {
        // 1. Save to Runtime deployment directory
        if (runtimeBase != null) {
            File runtimeSubDir = new File(runtimeBase, "uploads" + File.separator + subFolder);
            if (!runtimeSubDir.exists()) runtimeSubDir.mkdirs();
            File runtimeFile = new File(runtimeSubDir, fileName);
            Files.write(runtimeFile.toPath(), bytes);
        }

        // 2. Save directly to Source directory src/main/webapp/uploads/subFolder
        try {
            File srcWebappDir = findSourceWebappDirectory(runtimeBase);
            if (srcWebappDir != null && srcWebappDir.exists()) {
                File srcSubDir = new File(srcWebappDir, "uploads" + File.separator + subFolder);
                if (!srcSubDir.exists()) srcSubDir.mkdirs();
                File srcFile = new File(srcSubDir, fileName);
                Files.write(srcFile.toPath(), bytes);
            }
        } catch (Exception e) {
            System.err.println("[FileUploadUtil] Notice: Could not sync bytes to source webapp dir: " + e.getMessage());
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

    public static String getSubmittedFileName(Part part) {
        if (part == null) return null;
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1)
                               .substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }
}
