<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="mgmt-sidebar">
    <div class="mgmt-sidebar-header">
        <div class="mgmt-sidebar-title"><i class="bi bi-shield-fill"></i> Admin Dashboard</div>
        <div class="mgmt-sidebar-subtitle">System Control Panel</div>
    </div>
    <ul class="mgmt-menu">
        <div class="mgmt-menu-section-title">Overview</div>
        <li class="mgmt-menu-item ${param.activeMenu == 'dashboard' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </li>
        <div class="mgmt-menu-section-title">Management</div>
        <li class="mgmt-menu-item ${param.activeMenu == 'staff' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/staff">
                <i class="bi bi-people-fill"></i> Manage Staff
            </a>
        </li>
        <li class="mgmt-menu-item ${param.activeMenu == 'users' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/users">
                <i class="bi bi-person-lines-fill"></i> Manage Users
            </a>
        </li>
        <div class="mgmt-menu-section-title">Finance</div>
        <li class="mgmt-menu-item ${param.activeMenu == 'revenue' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/revenue">
                <i class="bi bi-bar-chart-line-fill"></i> Revenue Report
            </a>
        </li>
    </ul>
</aside>
