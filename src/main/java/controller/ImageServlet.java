package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.FileUploadUtil;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

/**
 * Serves uploaded images from {catalina.home}/uploads/.
 *
 * URL pattern: /uploads/**
 * e.g. GET /CarRental/uploads/cars/car_uuid.jpg
 *      → reads {catalina.home}/uploads/cars/car_uuid.jpg
 *
 * This servlet is necessary because files stored outside the webapp
 * directory cannot be served by Tomcat's default static file handler.
 */
@WebServlet(name = "ImageServlet", urlPatterns = {"/uploads/*"})
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // pathInfo = "/cars/car_uuid.jpg"  or  "/avatars/avatar_uuid.jpg"
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Security: reject paths with ".." to prevent directory traversal
        if (pathInfo.contains("..")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Resolve file from catalina.home/uploads/
        File uploadRoot = FileUploadUtil.getUploadRoot();
        // pathInfo starts with "/" so strip it: "/cars/uuid.jpg" → "cars/uuid.jpg"
        File requestedFile = new File(uploadRoot, pathInfo.substring(1));

        if (!requestedFile.exists() || !requestedFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Detect and set MIME type
        String mimeType = getServletContext().getMimeType(requestedFile.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        response.setContentLengthLong(requestedFile.length());

        // Cache headers — images don't change once uploaded
        response.setHeader("Cache-Control", "public, max-age=86400");

        // Stream file to client
        try (OutputStream out = response.getOutputStream()) {
            Files.copy(requestedFile.toPath(), out);
        }
    }
}
