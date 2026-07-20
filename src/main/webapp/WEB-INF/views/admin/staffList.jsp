<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Personnel Management - Car Rental Admin</title>
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

            .staff-row-card {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-4) var(--space-6);
                margin-bottom: var(--space-4);
                transition: var(--transition-fast);
            }

            .staff-row-card:hover {
                border-color: var(--color-blue-border);
            }

            .staff-grid {
                display: grid;
                grid-template-columns: 80px 80px 2.5fr 3.5fr 2.5fr 1.5fr 80px;
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
                    <div class="action-bar" style="display:flex; justify-content:space-between; align-items:center; gap:1.5rem; margin-bottom:1.5rem;">
                        <form action="${pageContext.request.contextPath}/admin/staff" method="get" style="flex-grow:1; max-width:400px; position:relative; margin:0;">
                            <input type="hidden" name="action" value="search" />
                            <input type="hidden" name="size" value="${pageSize != null ? pageSize : 10}" />
                            <input type="text" name="keyword" value="${keywordVal}" class="form-control"
                                   placeholder="Search staff and press Enter..."
                                   style="padding-left: 2.5rem; height: 42px;" />
                            <i class="bi bi-search" style="position:absolute; left:1rem; top:50%; transform:translateY(-50%); color:var(--text-muted);"></i>
                            <button type="submit" style="display:none;"></button>
                        </form>
                        <a href="${pageContext.request.contextPath}/admin/staff?action=create"
                           class="btn btn-blue btn-sm"
                           style="height:42px; display:inline-flex; align-items:center;"><i class="bi bi-person-plus-fill" style="margin-right:0.5rem;"></i> Add New Staff</a>
                    </div>

                    <!-- Staff indexes list -->
                    <div id="staffListContainer">
                        <c:choose>
                            <c:when test="${not empty staffList}">
                                <div class="staff-grid-header" style="display: grid; grid-template-columns: 80px 80px 2.5fr 3.5fr 2.5fr 1.5fr 80px; padding: var(--space-3) var(--space-6); font-weight: 700; color: var(--color-gray-light); font-size: 0.85rem; text-transform: uppercase; border-bottom: 1px solid var(--color-dark-border); margin-bottom: var(--space-4);">
                                    <div>No.</div>
                                    <div>Avatar</div>
                                    <div>Full Name</div>
                                    <div>Email Address</div>
                                    <div>Phone Number</div>
                                    <div style="text-align: right; padding-right: var(--space-4);">Status</div>
                                    <div style="text-align: center;">Action</div>
                                </div>
                                <c:forEach var="staff" items="${staffList}" varStatus="loop">
                                    <div class="staff-row-card"
                                         data-name="<c:out value='${staff.fullName}'/>"
                                         data-email="<c:out value='${staff.email}'/>"
                                         data-phone="<c:out value='${staff.phoneNumber}'/>"
                                         onclick="window.location.href = '${pageContext.request.contextPath}/admin/staff?action=detail&id=${staff.userId}'"
                                         style="cursor: pointer;">
                                        <div class="staff-grid">
                                            <!-- Sequential No. -->
                                            <div class="grid-col col-no">#${loop.index + 1}</div>

                                            <!-- Round Avatar -->
                                            <div class="grid-col col-avatar">
                                                <c:choose>
                                                    <c:when test="${not empty staff.avatarUrl}">
                                                        <img src="${fn:startsWith(staff.avatarUrl, 'http') || fn:startsWith(staff.avatarUrl, pageContext.request.contextPath) ? staff.avatarUrl : pageContext.request.contextPath.concat(staff.avatarUrl)}" style="width: 44px; height: 44px; border-radius: 50%; object-fit: cover; border: 2px solid var(--orange-border);" alt="Avatar" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div style="width: 44px; height: 44px; border-radius: 50%; background: var(--orange-pale); border: 2px solid var(--orange-border); display: flex; align-items: center; justify-content: center; color: var(--orange-dark); font-weight: 700; font-size: 1rem;">
                                                            <c:out value="${fn:substring(staff.fullName, 0, 1)}"/>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Staff Info -->
                                            <div class="grid-col col-name"><c:out value="${staff.fullName}" /></div>
                                            <div class="grid-col col-email"><c:out value="${staff.email}" /></div>
                                            <div class="grid-col col-phone"><c:out value="${staff.phoneNumber}" /></div>

                                            <!-- Status Badge only (No button) -->
                                            <div style="text-align: right; padding-right: var(--space-4);">
                                                <span class="status-badge ${staff.status == 'Active' ? 'active' : (staff.status == 'Suspended' ? 'suspended' : 'blocked')}">
                                                    <c:out value="${staff.status}" />
                                                </span>
                                            </div>

                                            <!-- Action -->
                                            <div class="grid-col" style="text-align:center;">
                                                <div style="display:inline-flex; align-items:center; justify-content:center; width:34px; height:34px; border-radius:8px; background:rgba(249,115,22,0.1); color:var(--orange); transition:0.2s;"
                                                     onmouseover="this.style.background='var(--orange)'; this.style.color='white';"
                                                     onmouseout="this.style.background='rgba(249,115,22,0.1)'; this.style.color='var(--orange)';">
                                                    <i class="bi bi-eye-fill" style="font-size:1.1rem;"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Empty list state message -->
                                <div class="empty-state">
                                    <div class="empty-state-icon"><i class="bi bi-people-fill"></i></div>
                                    <div class="empty-state-title">No staff accounts available</div>
                                    <p class="text-muted text-sm" style="margin-top:0.5rem;">There are no back-office personnel registered.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Pagination Controls -->
                    <c:if test="${totalPages > 0}">
                        <div class="pagination-wrapper" style="display:flex; justify-content:space-between; align-items:center; margin-top:2rem;">
                            <div class="page-size-selector">
                                <form action="${pageContext.request.contextPath}/admin/staff" method="get" style="margin:0; display:flex; align-items:center; gap:0.5rem;">
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