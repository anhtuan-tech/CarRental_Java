<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="mgmt-sidebar">
    <div class="mgmt-sidebar-header">
        <div class="mgmt-sidebar-title"><i class="bi bi-clipboard2-check-fill"></i> Staff Dashboard</div>
        <div class="mgmt-sidebar-subtitle">Operations Panel</div>
    </div>
    <ul class="mgmt-menu">
        <div class="mgmt-menu-section-title">Overview</div>
        <li class="mgmt-menu-item ${param.activeMenu == 'dashboard' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/staff/dashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </li>
        <div class="mgmt-menu-section-title">Operations</div>
        <li class="mgmt-menu-item ${param.activeMenu == 'bookings' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/staff/bookings">
                <i class="bi bi-calendar2-check-fill"></i> Manage Bookings
            </a>
        </li>
        <li class="mgmt-menu-item ${param.activeMenu == 'cars' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/staff/cars">
                <i class="bi bi-car-front-fill"></i> Manage Cars
            </a>
        </li>
    </ul>
</aside>
