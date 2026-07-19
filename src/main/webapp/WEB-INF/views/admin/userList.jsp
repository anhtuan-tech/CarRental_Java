<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>User Accounts Registry - CarRental Admin</title>
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
                        max-width: 450px;
                    }

                    .role-filters {
                        display: flex;
                        gap: var(--space-2);
                    }

                    .user-row-card {
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

                    .user-row-card:hover {
                        border-color: var(--color-blue-border);
                    }

                    .user-details {
                        display: flex;
                        flex-direction: column;
                        gap: var(--space-1);
                    }

                    .user-name {
                        font-size: 1.2rem;
                        font-weight: 700;
                        color: var(--color-white);
                    }

                    .user-meta {
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
                    <aside class="mgmt-sidebar">
                        <div class="mgmt-sidebar-header">
                            <div class="mgmt-sidebar-title"><i class="bi bi-shield-fill"></i> Admin Portal</div>
                            <div class="mgmt-sidebar-subtitle">System Control Panel</div>
                        </div>
                        <ul class="mgmt-menu">
                            <div class="mgmt-menu-section-title">Overview</div>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                            <div class="mgmt-menu-section-title">Management</div>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/staff"><i class="bi bi-people-fill"></i> Manage Staff</a></li>
                            <li class="mgmt-menu-item active"><a href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-person-lines-fill"></i> Manage Users</a></li>
                            <div class="mgmt-menu-section-title">Finance</div>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/revenue"><i class="bi bi-bar-chart-line-fill"></i> Revenue Report</a></li>

                        </ul>
                        <div class="mgmt-sidebar-footer">
                            <div class="mgmt-user-info"><i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.email}"/></div>
                            <a href="${pageContext.request.contextPath}/logout" style="display:block; margin-top:0.5rem; font-size:0.8rem; color:#EF4444; text-decoration:none;"><i class="bi bi-box-arrow-right"></i> Logout</a>
                        </div>
                    </aside>
                    <main class="mgmt-content">
                        <div class="admin-container">

                            <div class="mb-6">
                                <h1 class="hero-title"
                                    style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">Manage
                                    <span>Platform Users</span></h1>
                                <p class="text-muted text-sm">Review registered Customer & Car Owner partner account
                                    lifecycles.</p>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                            <!-- Filter togglers & Search widget -->
                            <div class="action-bar">
                                <div class="role-filters">
                                    <a href="${pageContext.request.contextPath}/admin/users?action=list&roleId=1"
                                        class="btn btn-sm ${empty currentRoleFilter || currentRoleFilter == 1 ? 'btn-blue' : 'btn-ghost'}">
                                        Customers (Role ID 1)
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/users?action=list&roleId=3"
                                        class="btn btn-sm ${currentRoleFilter == 3 ? 'btn-blue' : 'btn-ghost'}">
                                        Owners (Role ID 3)
                                    </a>
                                </div>

                                <form action="${pageContext.request.contextPath}/admin/users" method="get"
                                    class="search-form">
                                    <input type="hidden" name="action" value="search" />
                                    <input type="text" name="keyword" class="form-control"
                                        placeholder="Search by name, email, phone..."
                                        value="<c:out value='${requestScope.keywordVal}'/>" required />
                                    <button type="submit" class="btn btn-blue btn-sm"
                                        style="padding:0 var(--space-4); height:42px;">Search</button>
                                    <c:if test="${not empty keywordVal}">
                                        <a href="${pageContext.request.contextPath}/admin/users?action=list"
                                            class="btn btn-ghost btn-sm"
                                            style="height:42px; display:flex; align-items:center;">Reset</a>
                                    </c:if>
                                </form>
                            </div>

                            <!-- Users collection mapping () -->
                            <c:choose>
                                <c:when test="${not empty userList}">
                                    <c:forEach var="item" items="${userList}">
                                        <div class="user-row-card">
                                            <div class="user-details">
                                                <div class="user-name">
                                                    <c:out value="${item.fullName}" />
                                                </div>
                                                <div class="user-meta">Email: <strong>
                                                        <c:out value="${item.email}" />
                                                    </strong></div>
                                                <div class="user-meta">Phone:
                                                    <c:out value="${item.phoneNumber}" />
                                                </div>
                                                <div class="user-meta">Role:
                                                    <span style="color:var(--color-blue-light); font-weight:600;">
                                                         <c:out value="${item.roleId == 3 ? 'Customer' : 'Owner'}" />
                                                    </span>
                                                </div>
                                            </div>

                                            <div
                                                style="text-align:right; display:flex; flex-direction:column; gap:var(--space-2); align-items:flex-end;">
                                                <div
                                                    class="status-badge ${item.status == 'Active' ? 'active' : (item.status == 'Suspended' ? 'suspended' : 'blocked')}">
                                                    <c:out value="${item.status}" />
                                                </div>
                                                <a href="${pageContext.request.contextPath}/admin/users?action=detail&id=${item.userId}"
                                                    class="btn btn-outline-blue btn-sm">Inspect Profile</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Empty list state message -->
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="bi bi-people-fill"></i></div>
                                        <div class="empty-state-title">No users available</div>
                                        <p class="text-muted text-sm" style="margin-top:0.5rem;">There are no platform
                                            users matching the selected filters.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </main>
                </div>
                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </body>
            </html>