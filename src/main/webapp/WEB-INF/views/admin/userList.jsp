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
                        max-width: 100%;
                        margin: 0 auto;
                        padding: 0 var(--space-4);
                    }

                    .action-bar {
                        display: flex;
                        justify-content: flex-end;
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

                    .user-row-card {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-4) var(--space-6);
                        margin-bottom: var(--space-4);
                        transition: var(--transition-fast);
                    }

                    .user-row-card:hover {
                        border-color: var(--color-blue-border);
                    }

                    .user-grid {
                        display: grid;
                        grid-template-columns: 70px 60px 2fr 3fr 2fr 2fr 1fr;
                        align-items: center;
                        gap: var(--space-4);
                        width: 100%;
                    }

                    .grid-col {
                        font-size: 0.95rem;
                        color: var(--color-white);
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    .col-no {
                        font-weight: 700;
                        color: var(--orange);
                        font-size: 1.1rem;
                    }

                    .col-avatar {
                        display: flex;
                        align-items: center;
                    }

                    .avatar-img {
                        width: 42px;
                        height: 42px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 2px solid var(--color-dark-border);
                    }

                    .avatar-placeholder {
                        width: 42px;
                        height: 42px;
                        border-radius: 50%;
                        background: #fff;
                        border: 2px solid var(--color-dark-border);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #bbb;
                        font-size: 1.3rem;
                    }

                    .col-name {
                        font-weight: 700;
                        font-size: 1.1rem;
                    }

                    .col-email {
                        color: var(--color-gray-light);
                    }

                    .col-phone {
                        color: var(--color-gray-light);
                    }

                    .col-role {
                        font-weight: 600;
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
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                        class="bi bi-speedometer2"></i> Dashboard</a></li>
                            <div class="mgmt-menu-section-title">Management</div>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/staff"><i
                                        class="bi bi-people-fill"></i> Manage Staff</a></li>
                            <li class="mgmt-menu-item active"><a
                                    href="${pageContext.request.contextPath}/admin/users"><i
                                        class="bi bi-person-lines-fill"></i> Manage Users</a></li>
                            <div class="mgmt-menu-section-title">Finance</div>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/revenue"><i
                                        class="bi bi-bar-chart-line-fill"></i> Revenue Report</a></li>
                        </ul>
                        <div class="mgmt-sidebar-footer">
                            <div class="mgmt-user-info"><i class="bi bi-person-circle"></i>
                                <c:out value="${sessionScope.user.email}" />
                            </div>
                            <a href="${pageContext.request.contextPath}/logout"
                                style="display:block; margin-top:0.5rem; font-size:0.8rem; color:#EF4444; text-decoration:none;"><i
                                    class="bi bi-box-arrow-right"></i> Logout</a>
                        </div>
                    </aside>
                    <main class="mgmt-content">
                        <div class="admin-container">

                            <div class="mb-6">
                                <h1 class="hero-title"
                                    style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">Manage
                                    <span>Platform Users</span>
                                </h1>
                                <p class="text-muted text-sm">Review registered Customer & Car Owner partner account
                                    lifecycles.</p>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                            <div class="action-bar">
                                <div class="search-form">
                                    <input type="text" id="instantSearch" class="form-control"
                                        placeholder="Search users instantly..." style="width:100%;" />
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${not empty userList}">
                                    <div class="user-grid-header"
                                        style="display: grid; grid-template-columns: 70px 60px 2fr 3fr 2fr 2fr 1fr; padding: var(--space-3) var(--space-6); font-weight: 700; color: var(--color-gray-light); font-size: 0.85rem; text-transform: uppercase; border-bottom: 1px solid var(--color-dark-border); margin-bottom: var(--space-4);">
                                        <div>No.</div>
                                        <div>Avatar</div>
                                        <div>Full Name</div>
                                        <div>Email Address</div>
                                        <div>Phone Number</div>
                                        <div>Role</div>
                                        <div style="text-align: right; padding-right: var(--space-4);">Status</div>
                                    </div>
                                    <c:forEach var="item" items="${userList}" varStatus="status">
                                        <div class="user-row-card">
                                            <div class="user-grid">
                                                <div class="grid-col col-no">#${status.count}</div>
                                                <!-- Avatar -->
                                                <div class="grid-col col-avatar">
                                                    <c:choose>
                                                        <c:when test="${not empty item.avatarUrl}">
                                                            <img src="${item.avatarUrl}" class="avatar-img" alt="Avatar" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="avatar-placeholder">
                                                                <i class="bi bi-person-fill"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="grid-col col-name">
                                                    <c:out value="${item.fullName}" />
                                                </div>
                                                <div class="grid-col col-email">
                                                    <c:out value="${item.email}" />
                                                </div>
                                                <div class="grid-col col-phone">
                                                    <c:out value="${item.phoneNumber}" />
                                                </div>
                                                <div class="grid-col col-role" style="color:var(--color-blue-light);">
                                                    <c:choose>
                                                        <c:when test="${item.roleId == 2}">Staff</c:when>
                                                        <c:when test="${item.roleId == 3}">Owner</c:when>
                                                        <c:when test="${item.roleId == 4}">Customer</c:when>
                                                        <c:otherwise>User</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div style="text-align: right;">
                                                    <div
                                                        class="status-badge ${item.status == 'Active' ? 'active' : (item.status == 'Suspended' ? 'suspended' : 'blocked')}">
                                                        <c:out value="${item.status}" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="bi bi-people-fill"></i></div>
                                        <div class="empty-state-title">No users available</div>
                                        <p class="text-muted text-sm" style="margin-top:0.5rem;">There are no platform
                                            users available.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </main>
                </div>
                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
                <script>
                    document.getElementById('instantSearch').addEventListener('input', function () {
                        var query = this.value.toLowerCase().trim();
                        var cards = document.querySelectorAll('.user-row-card');
                        var hasVisible = false;

                        cards.forEach(function (card) {
                            var text = card.textContent.toLowerCase();
                            if (text.indexOf(query) !== -1) {
                                card.style.display = 'flex';
                                hasVisible = true;
                            } else {
                                card.style.display = 'none';
                            }
                        });

                        var emptyState = document.getElementById('emptySearchState');
                        if (!hasVisible) {
                            if (!emptyState) {
                                var container = document.querySelector('.admin-container');
                                emptyState = document.createElement('div');
                                emptyState.id = 'emptySearchState';
                                emptyState.className = 'empty-state';
                                emptyState.innerHTML = '<div class="empty-state-icon"><i class="bi bi-search"></i></div>' +
                                    '<div class="empty-state-title">No user matches your search</div>' +
                                    '<p class="text-muted text-sm" style="margin-top:0.5rem;">Try using another name, email or phone number.</p>';
                                container.appendChild(emptyState);
                            } else {
                                emptyState.style.display = 'block';
                            }
                        } else {
                            if (emptyState) {
                                emptyState.style.display = 'none';
                            }
                        }
                    });
                </script>
            </body>

            </html>