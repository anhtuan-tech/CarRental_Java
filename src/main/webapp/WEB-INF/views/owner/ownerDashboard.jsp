<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Owner Fleet Hub — CarRental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<% if (session.getAttribute("user") == null) { response.sendRedirect(request.getContextPath() + "/login/owner"); return; } %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="mgmt-wrapper">
    <aside class="mgmt-sidebar">
        <div class="mgmt-sidebar-header">
            <div class="mgmt-sidebar-title"><i class="bi bi-key-fill"></i> Owner Hub</div>
            <div class="mgmt-sidebar-subtitle">Fleet Management</div>
        </div>

        <ul class="mgmt-menu">
            <div class="mgmt-menu-section-title">Overview</div>
            <li class="mgmt-menu-item active">
                <a href="${pageContext.request.contextPath}/owner/dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
            </li>

            <div class="mgmt-menu-section-title">My Fleet</div>
            <li class="mgmt-menu-item">
                <a href="${pageContext.request.contextPath}/owner/cars">
                    <i class="bi bi-car-front-fill"></i> My Vehicles
                </a>
            </li>

            <div class="mgmt-menu-section-title">Business</div>
            <li class="mgmt-menu-item">
                <a href="${pageContext.request.contextPath}/owner/orders">
                    <i class="bi bi-receipt-cutoff"></i> Rental Orders
                </a>
            </li>
            <li class="mgmt-menu-item">
                <a href="${pageContext.request.contextPath}/owner/earning">
                    <i class="bi bi-wallet2"></i> Earnings &amp; Payouts
                </a>
            </li>

            <div class="mgmt-menu-section-title">Account</div>
            <li class="mgmt-menu-item">
                <a href="${pageContext.request.contextPath}/profile">
                    <i class="bi bi-gear-fill"></i> My Profile
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
            <h1 class="dashboard-title">Car Owner Fleet Dashboard</h1>
            <p class="dashboard-subtitle">Welcome back, <strong style="color:var(--orange);"><c:out value="${sessionScope.user.email}"/></strong> — Monitor fleet performance, rentals, and income.</p>
        </div>

        <div style="display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:1.25rem; margin-bottom:2rem;">
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-car-front-fill"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">My Vehicles</div>
                </div>
            </div>
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-calendar2-week-fill"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">Bookings This Month</div>
                </div>
            </div>
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-cash-stack"></i></div>
                <div>
                    <div class="stat-card-v2-val">— VND</div>
                    <div class="stat-card-v2-lbl">Revenue This Month</div>
                </div>
            </div>
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-star-fill"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">Avg Rating</div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <div class="card-title">Owner Quick Actions</div>
            </div>
            <div class="quick-links-grid">
                <a href="${pageContext.request.contextPath}/owner/cars?action=register" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-plus-circle-fill"></i></div>
                    <div class="quick-link-label">Register New Car</div>
                    <div class="quick-link-desc">List a new vehicle on the platform</div>
                </a>
                <a href="${pageContext.request.contextPath}/owner/cars" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-car-front-fill"></i></div>
                    <div class="quick-link-label">Manage My Fleet</div>
                    <div class="quick-link-desc">View, edit and manage all vehicles</div>
                </a>
                <a href="${pageContext.request.contextPath}/owner/orders" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-receipt-cutoff"></i></div>
                    <div class="quick-link-label">Rental Orders</div>
                    <div class="quick-link-desc">Track all bookings on your vehicles</div>
                </a>
                <a href="${pageContext.request.contextPath}/owner/earning" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-wallet2"></i></div>
                    <div class="quick-link-label">Earnings Summary</div>
                    <div class="quick-link-desc">View income and payout history</div>
                </a>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>