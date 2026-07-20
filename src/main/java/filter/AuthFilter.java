package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

/**
 * Global Authorization Filter that intercepts all routes and validates
 * role-based access.
 * Rules enforced:
 * - /admin/* -> Requires Admin role (roleId = 1)
 * - /staff/* -> Requires Staff role (roleId = 2) or Admin (roleId = 1)
 * - /owner/* -> Requires Owner role (roleId = 4)
 * - /customer/* -> Requires Customer role (roleId = 3)
 * - /profile, /logout -> Requires any authenticated user
 */
@WebFilter(urlPatterns = { "/*" })
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No custom initialization required
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String contextPath = httpRequest.getContextPath();
        String uri = httpRequest.getRequestURI();

        // Extract relative request path
        String path = uri.substring(contextPath.length());

        // Allow static resources (CSS, JS, images, uploads) without session
        // interception
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")
                || path.startsWith("/uploads/") || path.contains(".")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. Admin Area Check
        if (path.startsWith("/admin/")) {
            if (user == null) {
                httpResponse.sendRedirect(contextPath + "/login/staff?role=admin");
                return;
            }
            if (user.getRoleId() != 1) { // role_id 1 is Admin
                triggerAccessDenied(httpRequest, httpResponse, "Access Denied. Administrator credentials required.");
                return;
            }
        }

        // 2. Staff Area Check
        else if (path.startsWith("/staff/")) {
            if (user == null) {
                httpResponse.sendRedirect(contextPath + "/login/staff?role=staff");
                return;
            }
            if (user.getRoleId() != 2 && user.getRoleId() != 1) { // role_id 2 is Staff, 1 is Admin
                triggerAccessDenied(httpRequest, httpResponse, "Access Denied. Staff or Admin credentials required.");
                return;
            }
        }

        // 3. Owner Area Check
        else if (path.startsWith("/owner/")) {
            if (user == null) {
                httpResponse.sendRedirect(contextPath + "/login/owner");
                return;
            }
            if (user.getRoleId() != 4) { // role_id 4 is Owner
                triggerAccessDenied(httpRequest, httpResponse, "Access Denied. Partner Owner credentials required.");
                return;
            }
        }

        // 4. Customer-Restricted Area Check (e.g. /customer/bookings, /feedback)
        else if (path.startsWith("/customer/") || path.startsWith("/feedback")) {
            if (user == null) {
                httpResponse.sendRedirect(contextPath + "/login/customer");
                return;
            }
            if (user.getRoleId() != 3) { // role_id 3 is Customer
                triggerAccessDenied(httpRequest, httpResponse, "Access Denied. Customer credentials required.");
                return;
            }
        }

        // 5. Shared Authenticated Pages Check
        else if (path.equals("/profile") || path.equals("/logout")) {
            if (user == null) {
                httpResponse.sendRedirect(contextPath + "/login/customer");
                return;
            }
        }

        // Access allowed, proceed down the chain
        chain.doFilter(request, response);
    }

    /**
     * Redirects unauthorized logged-in users to their correct home dashboard and
     * sets a warning toast.
     */
    private void triggerAccessDenied(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        HttpSession session = request.getSession(true);
        session.setAttribute("toastErrorMsg", message);

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            // Send back to their appropriate dashboard home
            switch (user.getRoleId()) {
                case 1:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
                case 2:
                    response.sendRedirect(request.getContextPath() + "/staff/dashboard");
                    break;
                case 4:
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                    break;
                case 3:
                default:
                    response.sendRedirect(request.getContextPath() + "/home");
                    break;
            }
        }
    }

    @Override
    public void destroy() {
        // No cleanup necessary
    }
}
