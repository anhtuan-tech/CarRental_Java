package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

/**
 * Serves uploaded images from src/main/webapp/uploads/ (committed in Git).
 *
 * URL pattern : /uploads/**
 * Example     : GET /CarRental/uploads/cars/car_uuid.jpg
 *               -> reads {project}/src/main/webapp/uploads/cars/car_uuid.jpg
 */
@WebServlet(name = "ImageServlet", urlPatterns = {"/uploads/*"})
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Block directory traversal
        if (pathInfo.contains("..")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Strip leading slash: "/cars/uuid.jpg" -> "cars/uuid.jpg"
        String relativePath = pathInfo.substring(1).replace("/", File.separator);

        // Locate src/main/webapp by walking up from the deployed target directory
        String runtimeBase = request.getServletContext().getRealPath("");
        File srcWebapp = findSourceWebappDir(runtimeBase);

        if (srcWebapp == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File file = new File(srcWebapp, "uploads" + File.separator + relativePath);
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) mimeType = "application/octet-stream";

        response.setContentType(mimeType);
        response.setContentLengthLong(file.length());
        response.setHeader("Cache-Control", "public, max-age=86400");

        try (OutputStream out = response.getOutputStream()) {
            Files.copy(file.toPath(), out);
        }
    }

    /**
     * Walks up from the deployed target path to find src/main/webapp.
     * Works on any machine with standard Maven layout, regardless of drive/OS.
     */
    private File findSourceWebappDir(String runtimeBase) {
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
}
