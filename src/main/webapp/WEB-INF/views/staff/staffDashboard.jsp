<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Staff Operations Desk — CarRental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<% if (session.getAttribute("user") == null) { response.sendRedirect(request.getContextPath() + "/login/staff"); return; } %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="mgmt-wrapper">
    <aside class="mgmt-sidebar">
        <div class="mgmt-sidebar-header">
            <div class="mgmt-sidebar-title"><i class="bi bi-clipboard2-check-fill"></i> Staff Desk</div>
            <div class="mgmt-sidebar-subtitle">Operations Panel</div>
        </div>

        <ul class="mgmt-menu">
            <div class="mgmt-menu-section-title">Overview</div>
            <li class="mgmt-menu-item active">
                <a href="${pageContext.request.contextPath}/staff/dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
            </li>

            <div class="mgmt-menu-section-title">Operations</div>
            <li class="mgmt-menu-item">
                <a href="${pageContext.request.contextPath}/staff/bookings">
                    <i class="bi bi-calendar2-check-fill"></i> Manage Bookings
                </a>
            </li>
            <li class="mgmt-menu-item">
                <a href="${pageContext.request.contextPath}/staff/cars">
                    <i class="bi bi-car-front-fill"></i> Manage Cars
                </a>
            </li>

        </ul>

        <div class="mgmt-sidebar-footer">
            <div class="mgmt-user-info"><i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.email}"/></div>
            <a href="${pageContext.request.contextPath}/logout" style="display:block; margin-top:0.5rem; font-size:0.8rem; color:#EF4444; text-decoration:none; padding:0.4rem 0.5rem; border-radius:6px;" onmouseover="this.style.background='rgba(239,68,68,0.1)'" onmouseout="this.style.background='transparent'">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </aside>

    <main class="mgmt-content">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Staff Operational Dashboard</h1>
            <p class="dashboard-subtitle">Welcome back, <strong style="color:var(--orange);"><c:out value="${sessionScope.user.email}"/></strong> — Manage vehicle approvals and booking operations.</p>
        </div>

        <div style="display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:1.25rem; margin-bottom:2rem;">
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-calendar2-check-fill"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">Pending Bookings</div>
                </div>
            </div>
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-arrow-repeat"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">Active Rentals</div>
                </div>
            </div>
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-car-front-fill"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">Cars to Review</div>
                </div>
            </div>
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-check-circle-fill"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">Completed Today</div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <div class="card-title">Staff Quick Actions</div>
            </div>
            <div class="quick-links-grid">
                <a href="${pageContext.request.contextPath}/staff/bookings" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-calendar2-check-fill"></i></div>
                    <div class="quick-link-label">Manage Bookings</div>
                    <div class="quick-link-desc">Handle pickup, return &amp; delivery</div>
                </a>
                <a href="${pageContext.request.contextPath}/staff/bookings?status=pending" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-bell-fill"></i></div>
                    <div class="quick-link-label">Pending Bookings</div>
                    <div class="quick-link-desc">View &amp; confirm new bookings</div>
                </a>
                <a href="${pageContext.request.contextPath}/staff/cars" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-car-front-fill"></i></div>
                    <div class="quick-link-label">Manage Cars</div>
                    <div class="quick-link-desc">Vehicle verification queue</div>
                </a>
                <a href="${pageContext.request.contextPath}/staff/cars?status=pending" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-search"></i></div>
                    <div class="quick-link-label">Cars for Review</div>
                    <div class="quick-link-desc">Approve / reject new listings</div>
                </a>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>