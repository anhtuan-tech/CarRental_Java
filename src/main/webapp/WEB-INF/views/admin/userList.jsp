<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>User Accounts Registry - Car Rental Admin</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
                    <style>
                        .admin-container {
                            max-width: 100%;
                            margin: 0 auto;
                            padding: 0 var(--space-4);
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

                        .user-row-card {
                            background: var(--color-surface);
                            border: 1px solid var(--color-dark-border);
                            border-radius: var(--radius-lg);
                            padding: var(--space-4) var(--space-6);
                            margin-bottom: var(--space-3);
                            transition: var(--transition-fast);
                        }

                        .user-row-card:hover {
                            background: rgba(255, 255, 255, 0.02);
                            border-color: var(--color-gray);
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                        }

                        .user-grid {
                            display: grid;
                            grid-template-columns: 80px 80px 2.5fr 3.5fr 2.5fr 2fr 1.5fr;
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
                            justify-content: flex-start;
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

                        .status-badge.inactive {
                            background: rgba(107, 114, 128, 0.1);
                            color: #6B7280;
                            border: 1px solid rgba(107, 114, 128, 0.2);
                        }
                    </style>
                    <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>

                <body>
                    <jsp:include page="/WEB-INF/views/common/header.jsp" />
                    <div class="mgmt-wrapper">
                        <!-- Admin Sidebar -->
                        <jsp:include page="/WEB-INF/views/common/adminSidebar.jsp">
                            <jsp:param name="activeMenu" value="users" />
                        </jsp:include>

                        <!-- Main Content -->
                        <main class="mgmt-content">
                            <div class="admin-container">

                                <div class="mb-6">
                                    <h1 class="hero-title"
                                        style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                                        Manage <span>Users</span>
                                    </h1>
                                    <p class="text-muted text-sm">Review registered Customer &amp; Car Owner partner
                                        account lifecycles.</p>
                                </div>
                                <div class="blue-line" style="margin-bottom: 2rem;"></div>

                                <!-- Action bar & search -->
                                <div class="action-bar"
                                    style="display:flex; justify-content:space-between; align-items:center; gap:1.5rem; margin-bottom:1.5rem;">
                                    <form action="${pageContext.request.contextPath}/admin/users" method="get" style="flex-grow:1; max-width:400px; position:relative; margin:0;">
                                        <input type="hidden" name="action" value="search" />
                                        <input type="hidden" name="size" value="${pageSize != null ? pageSize : 10}" />
                                        <input type="text" name="keyword" value="${keywordVal}" class="form-control"
                                            placeholder="Search users and press Enter..."
                                            style="padding-left: 2.5rem; height: 42px;" />
                                        <i class="bi bi-search"
                                            style="position:absolute; left:1rem; top:50%; transform:translateY(-50%); color:var(--text-muted);"></i>
                                        <button type="submit" style="display:none;"></button>
                                    </form>
                                </div>

                                <!-- User list -->
                                <div id="userListContainer">
                                    <c:choose>
                                        <c:when test="${not empty userList}">
                                            <div class="user-grid-header"
                                                style="display: grid; grid-template-columns: 80px 80px 2.5fr 3.5fr 2.5fr 2fr 1.5fr; padding: var(--space-3) var(--space-6); font-weight: 700; color: var(--color-gray-light); font-size: 0.85rem; text-transform: uppercase; border-bottom: 1px solid var(--color-dark-border); margin-bottom: var(--space-4);">
                                                <div>No.</div>
                                                <div>Avatar</div>
                                                <div>Full Name</div>
                                                <div>Email Address</div>
                                                <div>Phone Number</div>
                                                <div>Role</div>
                                                <div style="text-align: right; padding-right: var(--space-4);">Status
                                                </div>
                                            </div>
                                            <c:forEach var="item" items="${userList}" varStatus="loop">
                                                <div class="user-row-card" data-name="<c:out value='${item.fullName}'/>"
                                                    data-email="<c:out value='${item.email}'/>"
                                                    data-phone="<c:out value='${item.phoneNumber}'/>">
                                                    <div class="user-grid">
                                                        <!-- No. -->
                                                        <div class="grid-col col-no">#${loop.index + 1}</div>

                                                        <!-- Avatar -->
                                                        <div class="grid-col col-avatar">
                                                            <c:choose>
                                                                <c:when test="${not empty item.avatarUrl}">
                                                                    <img src="${fn:startsWith(item.avatarUrl, 'http') || fn:startsWith(item.avatarUrl, pageContext.request.contextPath) ? item.avatarUrl : pageContext.request.contextPath.concat(item.avatarUrl)}"
                                                                        style="width: 44px; height: 44px; border-radius: 50%; object-fit: cover; border: 2px solid var(--orange-border);"
                                                                        alt="Avatar" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div
                                                                        style="width: 44px; height: 44px; border-radius: 50%; background: #fff; border: 2px solid var(--orange-border); display: flex; align-items: center; justify-content: center; color: #bbb; font-size: 1.3rem;">
                                                                        <i class="bi bi-person-fill"></i>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <!-- Full Name -->
                                                        <div class="grid-col col-name">
                                                            <c:out value="${item.fullName}" />
                                                        </div>

                                                        <!-- Email -->
                                                        <div class="grid-col col-email">
                                                            <c:out value="${item.email}" />
                                                        </div>

                                                        <!-- Phone -->
                                                        <div class="grid-col col-phone">
                                                            <c:out value="${item.phoneNumber}" />
                                                        </div>

                                                        <!-- Role -->
                                                        <div class="grid-col col-role"
                                                            style="color: var(--color-blue-light);">
                                                            <c:choose>
                                                                <c:when test="${item.roleId == 2}">Staff</c:when>
                                                                <c:when test="${item.roleId == 3}">Owner</c:when>
                                                                <c:when test="${item.roleId == 4}">Customer</c:when>
                                                                <c:otherwise>User</c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <!-- Status -->
                                                        <div style="text-align: right; padding-right: var(--space-4);">
                                                            <span
                                                                class="status-badge ${item.status == 'Active' ? 'active' : (item.status == 'Suspended' ? 'suspended' : (item.status == 'Blocked' ? 'blocked' : 'inactive'))}">
                                                                <c:out value="${item.status}" />
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-state">
                                                <div class="empty-state-icon"><i class="bi bi-people-fill"></i></div>
                                                <div class="empty-state-title">No users available</div>
                                                <p class="text-muted text-sm" style="margin-top:0.5rem;">There are no
                                                    platform users available.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                    <!-- Pagination Controls -->
                                    <c:if test="${totalPages > 0}">
                                        <div class="pagination-wrapper" style="display:flex; justify-content:space-between; align-items:center; margin-top:2rem;">
                                            <div class="page-size-selector">
                                                <form action="${pageContext.request.contextPath}/admin/users" method="get" style="margin:0; display:flex; align-items:center; gap:0.5rem;">
                                                    <input type="hidden" name="action" value="${not empty keywordVal ? 'search' : 'list'}" />
                                                    <c:if test="${not empty keywordVal}">
                                                        <input type="hidden" name="keyword" value="${keywordVal}" />
                                                    </c:if>
                                                    <span class="text-sm text-muted">Show:</span>
                                                    <select name="size" class="form-control" style="width:70px; height:32px; padding:0 0.5rem;" onchange="this.form.submit()">
                                                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                                        <option value="15" ${pageSize == 15 ? 'selected' : ''}>15</option>
                                                        <option value="30" ${pageSize == 30 ? 'selected' : ''}>30</option>
                                                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                                    </select>
                                                    <span class="text-sm text-muted">entries</span>
                                                </form>
                                            </div>
                                            <div class="pagination-links" style="display:flex; gap:0.25rem;">
                                                <c:set var="prevPage" value="${currentPage - 1 > 0 ? currentPage - 1 : 1}" />
                                                <a href="?action=${not empty keywordVal ? 'search' : 'list'}&keyword=${keywordVal}&size=${pageSize}&page=${prevPage}" class="btn btn-sm ${currentPage == 1 ? 'disabled' : ''}" style="border:1px solid var(--border); background:var(--white);">&laquo; Prev</a>
                                                
                                                <c:forEach begin="1" end="${totalPages}" var="p">
                                                    <a href="?action=${not empty keywordVal ? 'search' : 'list'}&keyword=${keywordVal}&size=${pageSize}&page=${p}" class="btn btn-sm" style="${p == currentPage ? 'background:var(--orange); color:white; border-color:var(--orange);' : 'border:1px solid var(--border); background:var(--white);'}">${p}</a>
                                                </c:forEach>
                                                
                                                <c:set var="nextPage" value="${currentPage + 1 <= totalPages ? currentPage + 1 : totalPages}" />
                                                <a href="?action=${not empty keywordVal ? 'search' : 'list'}&keyword=${keywordVal}&size=${pageSize}&page=${nextPage}" class="btn btn-sm ${currentPage == totalPages ? 'disabled' : ''}" style="border:1px solid var(--border); background:var(--white);">Next &raquo;</a>
                                            </div>
                                        </div>
                                    </c:if>

                            </div>
                        </main>
                    </div>
                    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
                </body>

                </html>