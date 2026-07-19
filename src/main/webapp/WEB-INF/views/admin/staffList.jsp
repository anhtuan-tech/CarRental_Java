<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Personnel Management - CarRental Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
                <style>
                    .admin-container {
                        max-width: 1000px;
                        margin: var(--space-8) auto;
                    }

                    .action-bar {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: var(--space-6);
                        gap: var(--space-4);
                        flex-wrap: wrap;
                    }

                    .search-form {
                        display: flex;
                        gap: var(--space-2);
                        flex-grow: 1;
                        max-width: 500px;
                    }

                    .staff-row-card {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-6);
                        margin-bottom: var(--space-4);
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        transition: var(--transition-fast);
                    }

                    .staff-row-card:hover {
                        border-color: var(--color-blue-border);
                    }

                    .staff-details {
                        display: flex;
                        flex-direction: column;
                        gap: var(--space-1);
                    }

                    .staff-name {
                        font-size: 1.2rem;
                        font-weight: 700;
                        color: var(--color-white);
                    }

                    .staff-meta {
                        font-size: 0.85rem;
                        color: var(--color-gray-light);
                    }

                    .status-badge {
                        display: inline-block;
                        font-size: 0.75rem;
                        font-weight: 600;
                        padding: var(--space-1) var(--space-3);
                        border-radius: var(--radius-full);
                        text-transform: uppercase;
                    }

                    .status-badge.active {
                        background: rgba(16, 185, 129, 0.1);
                        color: #10B981;
                        border: 1px solid rgba(16, 185, 129, 0.2);
                    }

                    .status-badge.suspended {
                        background: rgba(245, 158, 11, 0.1);
                        color: #F59E0B;
                        border: 1px solid rgba(245, 158, 11, 0.2);
                    }

                    .status-badge.blocked {
                        background: rgba(239, 68, 68, 0.1);
                        color: #EF4444;
                        border: 1px solid rgba(239, 68, 68, 0.2);
                    }
                </style>
            </head>

            <body>
                <jsp:include page="/WEB-INF/views/common/header.jsp" />
                <div class="mgmt-wrapper">
                    <!-- Admin Sidebar -->
                    <aside class="mgmt-sidebar">
                        <div class="mgmt-sidebar-header">
                            <div class="mgmt-sidebar-title"><i class="bi bi-shield-fill"></i> Admin Portal</div>
                            <div class="mgmt-sidebar-subtitle">System Control Panel</div>
                        </div>
                        <ul class="mgmt-menu">
                            <div class="mgmt-menu-section-title">Overview</div>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                            <div class="mgmt-menu-section-title">Management</div>
                            <li class="mgmt-menu-item active"><a href="${pageContext.request.contextPath}/admin/staff"><i class="bi bi-people-fill"></i> Manage Staff</a></li>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-person-lines-fill"></i> Manage Users</a></li>
                            <div class="mgmt-menu-section-title">Finance</div>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/revenue"><i class="bi bi-bar-chart-line-fill"></i> Revenue Report</a></li>

                        </ul>
                        <div class="mgmt-sidebar-footer">
                            <div class="mgmt-user-info"><i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.email}"/></div>
                            <a href="${pageContext.request.contextPath}/logout" style="display:block; margin-top:0.5rem; font-size:0.8rem; color:#EF4444; text-decoration:none;"><i class="bi bi-box-arrow-right"></i> Logout</a>
                        </div>
                    </aside>
                    <!-- Main Content -->
                    <main class="mgmt-content">
                        <div class="admin-container">

                            <div class="mb-6">
                                <h1 class="hero-title"
                                    style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">Manage <span>Staff
                                        Accounts</span></h1>
                                <p class="text-muted text-sm">Provision internal back-office personnel credentials,
                                    manage activity access, and suspension details.</p>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                            <!-- Action bar & searches -->
                            <div class="action-bar">
                                <form action="${pageContext.request.contextPath}/admin/staff" method="get"
                                    class="search-form">
                                    <input type="hidden" name="action" value="search" />
                                    <input type="text" name="keyword" class="form-control"
                                        placeholder="Search by name, email, phone..."
                                        value="<c:out value='${requestScope.keywordVal}'/>" required />
                                    <button type="submit" class="btn btn-blue btn-sm"
                                        style="padding:0 var(--space-4); height:42px;">Search</button>
                                    <c:if test="${not empty keywordVal}">
                                        <a href="${pageContext.request.contextPath}/admin/staff?action=list"
                                            class="btn btn-ghost btn-sm"
                                            style="height:42px; display:flex; align-items:center;">Reset</a>
                                    </c:if>
                                </form>

                                <a href="${pageContext.request.contextPath}/admin/staff?action=create"
                                    class="btn btn-blue btn-sm"
                                    style="height:42px; display:inline-flex; align-items:center;">+ Add New Staff</a>
                            </div>

                            <!-- Staff indexes list () -->
                            <c:choose>
                                <c:when test="${not empty staffList}">
                                    <c:forEach var="staff" items="${staffList}">
                                        <div class="staff-row-card">
                                            <div class="staff-details">
                                                <div class="staff-name">
                                                    <c:out value="${staff.fullName}" />
                                                </div>
                                                <div class="staff-meta">Email: <strong>
                                                        <c:out value="${staff.email}" />
                                                    </strong></div>
                                                <div class="staff-meta">Phone:
                                                    <c:out value="${staff.phoneNumber}" />
                                                </div>
                                            </div>

                                            <div
                                                style="text-align:right; display:flex; flex-direction:column; gap:var(--space-2); align-items:flex-end;">
                                                <div
                                                    class="status-badge ${staff.status == 'Active' ? 'active' : (staff.status == 'Suspended' ? 'suspended' : 'blocked')}">
                                                    <c:out value="${staff.status}" />
                                                </div>
                                                <a href="${pageContext.request.contextPath}/admin/staff?action=detail&id=${staff.userId}"
                                                    class="btn btn-outline-blue btn-sm">Manage Profile</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Empty list state message -->
                                     <div class="empty-state">
                                         <div class="empty-state-icon"><i class="bi bi-people-fill"></i></div>
                                         <div class="empty-state-title">No staff accounts available</div>
                                        <p class="text-muted text-sm" style="margin-top:0.5rem;">There are no
                                            back-office personnel registered under this node.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </main>
                </div>
                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </body>
            </html>