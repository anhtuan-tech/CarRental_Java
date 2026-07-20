<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Booking Desk Master - CarRental Staff</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
                    <style>
                        .admin-container {
                            max-width: 100%;
                            margin: 0 auto;
                            padding: 0 var(--space-4);
                        }

                        /* ── Grid layout ─────────────────────────────────────── */
                        .booking-grid {
                            display: grid;
                            grid-template-columns: 70px 2fr 2fr 1.5fr 1.5fr 1.5fr 1.5fr;
                            align-items: center;
                            gap: var(--space-4);
                            width: 100%;
                        }

                        .booking-row-card {
                            display: block;
                            text-decoration: none;
                            background: var(--color-dark-card);
                            border: 1px solid var(--color-dark-border);
                            border-radius: var(--radius-xl);
                            padding: var(--space-4) var(--space-6);
                            margin-bottom: var(--space-4);
                            transition: all 0.2s ease;
                            cursor: pointer;
                        }

                        .booking-row-card:hover {
                            border-color: rgba(249, 115, 22, 0.4);
                            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
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

                        .col-customer {
                            font-weight: 700;
                            font-size: 1.05rem;
                        }

                        .col-meta {
                            color: var(--color-gray-light);
                            font-size: 0.88rem;
                        }

                        /* ── Status badges ───────────────────────────────────── */
                        .status-badge {
                            display: inline-block;
                            font-size: 0.75rem;
                            font-weight: 600;
                            padding: var(--space-1) var(--space-3);
                            border-radius: var(--radius-full);
                            text-transform: uppercase;
                        }

                        .status-badge.pending {
                            background: rgba(245, 158, 11, 0.1);
                            color: #F59E0B;
                            border: 1px solid rgba(245, 158, 11, 0.2);
                        }

                        .status-badge.confirmed {
                            background: rgba(59, 130, 246, 0.1);
                            color: #3B82F6;
                            border: 1px solid rgba(59, 130, 246, 0.2);
                        }

                        .status-badge.active {
                            background: rgba(139, 92, 246, 0.1);
                            color: #8B5CF6;
                            border: 1px solid rgba(139, 92, 246, 0.2);
                        }

                        .status-badge.completed {
                            background: rgba(16, 185, 129, 0.1);
                            color: #10B981;
                            border: 1px solid rgba(16, 185, 129, 0.2);
                        }

                        .status-badge.rejected {
                            background: rgba(239, 68, 68, 0.1);
                            color: #EF4444;
                            border: 1px solid rgba(239, 68, 68, 0.2);
                        }

                        .status-badge.approved {
                            background: rgba(16, 185, 129, 0.1);
                            color: #10B981;
                            border: 1px solid rgba(16, 185, 129, 0.2);
                        }

                        .status-badge.cancelled {
                            background: rgba(107, 114, 128, 0.1);
                            color: #6B7280;
                            border: 1px solid rgba(107, 114, 128, 0.2);
                        }
                    </style>
                </head>

                <body>
                    <jsp:include page="/WEB-INF/views/common/header.jsp" />
                    <div class="mgmt-wrapper">
                        <!-- Sidebar -->
                        <aside class="mgmt-sidebar">
                            <div class="mgmt-sidebar-header">
                                <div class="mgmt-sidebar-title"><i class="bi bi-clipboard2-check-fill"></i> Staff Desk
                                </div>
                                <div class="mgmt-sidebar-subtitle">Operations Panel</div>
                            </div>
                            <ul class="mgmt-menu">
                                <div class="mgmt-menu-section-title">Overview</div>
                                <li class="mgmt-menu-item"><a
                                        href="${pageContext.request.contextPath}/staff/dashboard"><i
                                            class="bi bi-speedometer2"></i> Dashboard</a></li>
                                <div class="mgmt-menu-section-title">Operations</div>
                                <li class="mgmt-menu-item active"><a
                                        href="${pageContext.request.contextPath}/staff/bookings"><i
                                            class="bi bi-calendar2-check-fill"></i> Manage Bookings</a></li>
                                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/staff/cars"><i
                                            class="bi bi-car-front-fill"></i> Manage Cars</a></li>
                            </ul>
                        </aside>

                        <!-- Main Content -->
                        <main class="mgmt-content">
                            <div class="admin-container">

                                <div class="mb-6">
                                    <h1 class="hero-title"
                                        style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                                        Master <span>Bookings Log</span>
                                    </h1>
                                    <p class="text-muted text-sm">Review, inspect, and update status for all application
                                        rentals.</p>
                                </div>
                                <div class="blue-line" style="margin-bottom: 2rem;"></div>

                                <!-- Server-side Search Form -->
                                <div style="margin-bottom:1.5rem; max-width:420px;">
                                    <form action="${pageContext.request.contextPath}/staff/bookings" method="get"
                                        style="position:relative; margin:0;">
                                        <input type="hidden" name="action" value="search">
                                        <input type="text" name="keyword" class="form-control"
                                            placeholder="Search by customer, owner, car name, status..."
                                            value="${fn:escapeXml(keywordVal)}"
                                            style="padding-left:2.5rem; height:42px; border-radius: var(--radius-lg); background: var(--color-dark-card); border: 1px solid var(--color-dark-border); color: var(--color-white); width: 100%;" />
                                        <i class="bi bi-search"
                                            style="position:absolute; left:1rem; top:50%; transform:translateY(-50%); color:var(--color-gray-light); font-size:0.95rem;"></i>
                                        <button type="submit" style="display:none;">Search</button>
                                    </form>
                                </div>

                                <!-- Booking table -->
                                <c:choose>
                                    <c:when test="${not empty carBookingList}">

                                        <!-- Header row -->
                                        <div class="booking-grid"
                                            style="padding: var(--space-3) var(--space-6); font-weight: 700; color: var(--color-gray-light); font-size: 0.85rem; text-transform: uppercase; border-bottom: 1px solid var(--color-dark-border); margin-bottom: var(--space-4);">
                                            <div>No.</div>
                                            <div>Customer / Owner</div>
                                            <div>Car / Brand</div>
                                            <div>Start Date</div>
                                            <div>End Date</div>
                                            <div>Total Value</div>
                                            <div style="text-align:right;">Status</div>
                                        </div>

                                        <!-- Data rows -->
                                        <c:forEach var="item" items="${carBookingList}" varStatus="loop">
                                            <c:catch var="dateErr">
                                                <fmt:parseDate value="${item.startDate}" pattern="yyyy-MM-dd'T'HH:mm"
                                                    var="sDate" type="both" />
                                                <fmt:parseDate value="${item.endDate}" pattern="yyyy-MM-dd'T'HH:mm"
                                                    var="eDate" type="both" />
                                            </c:catch>
                                            <a href="${pageContext.request.contextPath}/staff/bookings?action=detail&id=${item.bookingId}"
                                                class="booking-row-card" data-status="<c:out value='${item.status}'/>"
                                                data-customer="<c:out value='${item.customerName}'/>"
                                                data-owner="<c:out value='${item.ownerName}'/>"
                                                data-car="<c:out value='${item.brand} ${item.carName}'/>">
                                                <div class="booking-grid">

                                                    <!-- No. -->
                                                    <div class="grid-col col-no">#${loop.index + 1}</div>

                                                    <!-- Customer & Owner names -->
                                                    <div class="grid-col col-customer">
                                                        <div style="font-weight: 700; color: var(--color-white);">
                                                            <c:out value="${item.customerName}" />
                                                        </div>
                                                        <c:if test="${not empty item.ownerName}">
                                                            <div
                                                                style="font-size: 0.78rem; color: var(--color-gray-light); margin-top: 2px; font-weight: 500;">
                                                                <i class="bi bi-key-fill"
                                                                    style="color: var(--orange);"></i> Owner:
                                                                <c:out value="${item.ownerName}" />
                                                            </div>
                                                        </c:if>
                                                    </div>

                                                    <!-- Car brand & Car Name -->
                                                    <div class="grid-col col-meta">
                                                        <c:choose>
                                                            <c:when test="${not empty item.brand}">
                                                                <c:out value="${item.brand}" />
                                                                <c:if test="${not empty item.carName}">
                                                                    <c:out value="${item.carName}" />
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:out value="${item.carName}" default="—" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <!-- Start date -->
                                                    <div class="grid-col col-meta">
                                                        <c:choose>
                                                            <c:when test="${not empty sDate}">
                                                                <fmt:formatDate value="${sDate}"
                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:out value="${item.startDate}" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <!-- End date -->
                                                    <div class="grid-col col-meta">
                                                        <c:choose>
                                                            <c:when test="${not empty eDate}">
                                                                <fmt:formatDate value="${eDate}"
                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:out value="${item.endDate}" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <!-- Total value -->
                                                    <div class="grid-col" style="color:var(--orange); font-weight:600;">
                                                        <fmt:formatNumber value="${item.subtotalFee}" type="number"
                                                            groupingUsed="true" /> ₫
                                                    </div>

                                                    <!-- Status -->
                                                    <div style="display:flex; justify-content:flex-end;">
                                                        <span
                                                            class="status-badge ${item.status == 'Pending' ? 'pending' : (item.status == 'Confirmed' ? 'confirmed' : (item.status == 'Active' ? 'active' : (item.status == 'Completed' ? 'completed' : (item.status == 'Approved' ? 'approved' : (item.status == 'Cancelled' ? 'cancelled' : 'rejected')))))}">
                                                            <c:out value="${item.status}" />
                                                        </span>
                                                    </div>

                                                </div>
                                            </a>
                                        </c:forEach>

                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state"
                                            style="padding:var(--space-8) 0; border:1px solid var(--color-dark-border); background:var(--color-dark-card); text-align:center; border-radius:var(--radius-xl);">
                                            <div class="empty-state-icon"
                                                style="font-size:3rem; margin-bottom:1rem; color:var(--orange);"><i
                                                    class="bi bi-inbox-fill"></i></div>
                                            <div class="empty-state-title"
                                                style="font-size:1.25rem; font-weight:700; color:var(--color-white); margin-bottom:0.5rem;">
                                                No bookings found</div>
                                            <p class="text-muted text-sm">There are no rental bookings matching your
                                                criteria.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Pagination Controls -->
                                <c:if test="${totalPages > 0}">
                                    <div class="pagination-wrapper"
                                        style="display:flex; justify-content:space-between; align-items:center; margin-top:2rem;">
                                        <div class="page-size-selector">
                                            <form action="${pageContext.request.contextPath}/staff/bookings"
                                                method="get"
                                                style="margin:0; display:flex; align-items:center; gap:0.5rem;">
                                                <input type="hidden" name="action"
                                                    value="${not empty keywordVal ? 'search' : 'list'}">
                                                <c:if test="${not empty keywordVal}">
                                                    <input type="hidden" name="keyword"
                                                        value="${fn:escapeXml(keywordVal)}">
                                                </c:if>
                                                <span class="text-sm text-muted">Show:</span>
                                                <select name="size" class="form-control"
                                                    style="width:70px; height:32px; padding:0 0.5rem; background:var(--color-dark-card); border-color:var(--color-dark-border); color:var(--color-white);"
                                                    onchange="this.form.submit()">
                                                    <option value="5" ${pageSize==5 ? 'selected' : '' }>5</option>
                                                    <option value="10" ${pageSize==10 ? 'selected' : '' }>10</option>
                                                    <option value="15" ${pageSize==15 ? 'selected' : '' }>15</option>
                                                    <option value="30" ${pageSize==30 ? 'selected' : '' }>30</option>
                                                    <option value="50" ${pageSize==50 ? 'selected' : '' }>50</option>
                                                </select>
                                                <span class="text-sm text-muted">entries</span>
                                            </form>
                                        </div>
                                        <div class="pagination-links" style="display:flex; gap:0.25rem;">
                                            <c:set var="prevPage"
                                                value="${currentPage - 1 > 0 ? currentPage - 1 : 1}" />
                                            <a href="?action=${not empty keywordVal ? 'search' : 'list'}${not empty keywordVal ? '&keyword='.concat(fn:escapeXml(keywordVal)) : ''}&size=${pageSize}&page=${prevPage}"
                                                class="btn btn-sm ${currentPage == 1 ? 'disabled' : ''}"
                                                style="border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);">&laquo;
                                                Prev</a>

                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <a href="?action=${not empty keywordVal ? 'search' : 'list'}${not empty keywordVal ? '&keyword='.concat(fn:escapeXml(keywordVal)) : ''}&size=${pageSize}&page=${p}"
                                                    class="btn btn-sm"
                                                    style="${p == currentPage ? 'background:var(--orange); color:white; border-color:var(--orange);' : 'border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);'}">${p}</a>
                                            </c:forEach>

                                            <c:set var="nextPage"
                                                value="${currentPage + 1 <= totalPages ? currentPage + 1 : totalPages}" />
                                            <a href="?action=${not empty keywordVal ? 'search' : 'list'}${not empty keywordVal ? '&keyword='.concat(fn:escapeXml(keywordVal)) : ''}&size=${pageSize}&page=${nextPage}"
                                                class="btn btn-sm ${currentPage == totalPages ? 'disabled' : ''}"
                                                style="border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);">Next
                                                &raquo;</a>
                                        </div>
                                    </div>
                                </c:if>

                            </div>
                        </main>
                    </div>
                    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

                </body>

                </html>