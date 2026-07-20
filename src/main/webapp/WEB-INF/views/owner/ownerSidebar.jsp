<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
    Owner Sidebar — shared include for all Owner pages.
    Active item is detected automatically from the original servlet path
    stored in jakarta.servlet.forward.servlet_path (set by RequestDispatcher.forward).
--%>
<%
    // Lấy path gốc trước khi forward — đây mới là URL người dùng truy cập
    String forwardPath = (String) request.getAttribute("jakarta.servlet.forward.servlet_path");
    if (forwardPath == null) {
        forwardPath = request.getServletPath(); // fallback nếu không qua forward
    }
    pageContext.setAttribute("currentPath", forwardPath);
%>
<aside class="mgmt-sidebar">
    <div class="mgmt-sidebar-header">
        <div class="mgmt-sidebar-title"><i class="bi bi-key-fill"></i> Car Owner Portal</div>
    </div>

    <ul class="mgmt-menu">
        <div class="mgmt-menu-section-title">Overview</div>
        <li class="mgmt-menu-item ${fn:contains(currentPath, '/owner/dashboard') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/owner/dashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </li>

        <div class="mgmt-menu-section-title">My Cars</div>
        <li class="mgmt-menu-item ${fn:contains(currentPath, '/owner/cars') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/owner/cars">
                <i class="bi bi-car-front-fill"></i> Manage My Cars
            </a>
        </li>

        <div class="mgmt-menu-section-title">Business</div>
        <li class="mgmt-menu-item ${fn:contains(currentPath, '/owner/orders') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/owner/orders">
                <i class="bi bi-receipt-cutoff"></i> Manage My Rental Orders
            </a>
        </li>
        <li class="mgmt-menu-item ${fn:contains(currentPath, '/owner/feedbacks') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/owner/feedbacks">
                <i class="bi bi-star-fill"></i> Customer Reviews
            </a>
        </li>
        <li class="mgmt-menu-item ${fn:contains(currentPath, '/owner/earning') ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/owner/earning">
                <i class="bi bi-wallet2"></i> My Earnings
            </a>
        </li>
    </ul>

</aside>
