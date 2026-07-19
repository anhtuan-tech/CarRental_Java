<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Control Panel — CarRental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1"/>
</head>
<body>
<% if (session.getAttribute("user") == null) { response.sendRedirect(request.getContextPath() + "/login/staff"); return; } %>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<div class="mgmt-wrapper">
    <aside class="mgmt-sidebar">
        <div class="mgmt-sidebar-header">
            <div class="mgmt-sidebar-title"><i class="bi bi-shield-fill"></i> Admin Portal</div>
            <div class="mgmt-sidebar-subtitle">System Control Panel</div>
        </div>

        <ul class="mgmt-menu">
            <div class="mgmt-menu-section-title">Overview</div>
            <li class="mgmt-menu-item active">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
            </li>

            <div class="mgmt-menu-section-title">Management</div>
            <li class="mgmt-menu-item">
                <a href="${pageContext.request.contextPath}/admin/staff">
                    <i class="bi bi-people-fill"></i> Manage Staff
                </a>
            </li>
            <li class="mgmt-menu-item">
                <a href="${pageContext.request.contextPath}/admin/users">
                    <i class="bi bi-person-lines-fill"></i> Manage Users
                </a>
            </li>

            <div class="mgmt-menu-section-title">Finance</div>
            <li class="mgmt-menu-item">
                <a href="${pageContext.request.contextPath}/admin/revenue">
                    <i class="bi bi-bar-chart-line-fill"></i> Revenue Report
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
            <h1 class="dashboard-title">System Administration Dashboard</h1>
            <p class="dashboard-subtitle">Welcome back, <strong style="color:var(--orange);"><c:out value="${sessionScope.user.email}"/></strong> — Platform operations &amp; personnel control center.</p>
        </div>

        <div style="display:grid; grid-template-columns:repeat(auto-fill,minmax(200px,1fr)); gap:1.25rem; margin-bottom:2rem;">
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-people-fill"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">Total Users</div>
                </div>
            </div>
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-person-badge-fill"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">Staff Accounts</div>
                </div>
            </div>
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-car-front-fill"></i></div>
                <div>
                    <div class="stat-card-v2-val">—</div>
                    <div class="stat-card-v2-lbl">Total Vehicles</div>
                </div>
            </div>
            <div class="stat-card-v2">
                <div class="stat-card-v2-icon"><i class="bi bi-cash-stack"></i></div>
                <div>
                    <div class="stat-card-v2-val">— VND</div>
                    <div class="stat-card-v2-lbl">Platform Revenue</div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <div class="card-title">Admin Quick Actions</div>
            </div>
            <div class="quick-links-grid">
                <a href="${pageContext.request.contextPath}/admin/staff" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-people-fill"></i></div>
                    <div class="quick-link-label">Manage Staff</div>
                    <div class="quick-link-desc">Add, edit, deactivate staff accounts</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/staff?action=create" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-person-plus-fill"></i></div>
                    <div class="quick-link-label">Create Staff</div>
                    <div class="quick-link-desc">Register new staff account</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-person-lines-fill"></i></div>
                    <div class="quick-link-label">Manage Users</div>
                    <div class="quick-link-desc">Manage Customer &amp; Owner accounts</div>
                </a>
                <a href="${pageContext.request.contextPath}/admin/revenue" class="quick-link-card">
                    <div class="quick-link-icon"><i class="bi bi-graph-up-arrow"></i></div>
                    <div class="quick-link-label">Revenue Report</div>
                    <div class="quick-link-desc">Platform financial intelligence</div>
                </a>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
</body>
</html>