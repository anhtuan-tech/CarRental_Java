<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Booking Desk Master - CarRental Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
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
            background: var(--color-dark-card);
            border: 1px solid var(--color-dark-border);
            border-radius: var(--radius-xl);
            padding: var(--space-4) var(--space-6);
            margin-bottom: var(--space-4);
            transition: var(--transition-fast);
        }

        .booking-row-card:hover {
            border-color: var(--color-blue-border);
        }

        .grid-col {
            font-size: 0.95rem;
            color: var(--color-white);
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .col-no { font-weight: 700; color: var(--orange); font-size: 1.1rem; }
        .col-customer { font-weight: 700; font-size: 1.05rem; }
        .col-meta { color: var(--color-gray-light); font-size: 0.88rem; }

        /* ── Status badges ───────────────────────────────────── */
        .status-badge {
            display: inline-block;
            font-size: 0.75rem;
            font-weight: 600;
            padding: var(--space-1) var(--space-3);
            border-radius: var(--radius-full);
            text-transform: uppercase;
        }
        .status-badge.pending   { background:rgba(245,158,11,0.1);  color:#F59E0B; border:1px solid rgba(245,158,11,0.2); }
        .status-badge.confirmed { background:rgba(59,130,246,0.1);  color:#3B82F6; border:1px solid rgba(59,130,246,0.2); }
        .status-badge.active    { background:rgba(139,92,246,0.1);  color:#8B5CF6; border:1px solid rgba(139,92,246,0.2); }
        .status-badge.completed { background:rgba(16,185,129,0.1);  color:#10B981; border:1px solid rgba(16,185,129,0.2); }
        .status-badge.rejected  { background:rgba(239,68,68,0.1);   color:#EF4444; border:1px solid rgba(239,68,68,0.2); }
        .status-badge.approved  { background:rgba(16,185,129,0.1);  color:#10B981; border:1px solid rgba(16,185,129,0.2); }
        .status-badge.cancelled { background:rgba(107,114,128,0.1); color:#6B7280; border:1px solid rgba(107,114,128,0.2); }
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <div class="mgmt-wrapper">
        <!-- Sidebar -->
        <aside class="mgmt-sidebar">
            <div class="mgmt-sidebar-header">
                <div class="mgmt-sidebar-title"><i class="bi bi-clipboard2-check-fill"></i> Staff Desk</div>
                <div class="mgmt-sidebar-subtitle">Operations Panel</div>
            </div>
            <ul class="mgmt-menu">
                <div class="mgmt-menu-section-title">Overview</div>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                <div class="mgmt-menu-section-title">Operations</div>
                <li class="mgmt-menu-item active"><a href="${pageContext.request.contextPath}/staff/bookings"><i class="bi bi-calendar2-check-fill"></i> Manage Bookings</a></li>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/staff/cars"><i class="bi bi-car-front-fill"></i> Manage Cars</a></li>
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
                    <h1 class="hero-title" style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                        Master <span>Bookings Log</span>
                    </h1>
                    <p class="text-muted text-sm">Review, inspect, and update status for all application rentals.</p>
                </div>
                <div class="blue-line" style="margin-bottom: 2rem;"></div>

                <!-- Search bar -->
                <div style="display:flex; justify-content:space-between; align-items:center; gap:1.5rem; margin-bottom:1.5rem;">
                    <div style="flex-grow:1; max-width:400px; position:relative;">
                        <form action="${pageContext.request.contextPath}/staff/bookings" method="get" style="display:flex; gap:0.5rem;">
                            <input type="hidden" name="action" value="search" />
                            <input type="text" name="keyword" class="form-control"
                                   placeholder="Search by customer name, status..."
                                   value="<c:out value='${requestScope.keywordVal}'/>"
                                   style="padding-left:1rem; height:42px;" />
                            <button type="submit" class="btn btn-blue btn-sm" style="padding:0 var(--space-4); height:42px;">Search</button>
                            <c:if test="${not empty keywordVal}">
                                <a href="${pageContext.request.contextPath}/staff/bookings?action=list"
                                   class="btn btn-ghost btn-sm" style="height:42px; display:flex; align-items:center;">Reset</a>
                            </c:if>
                        </form>
                    </div>
                </div>

                <!-- Booking table -->
                <c:choose>
                    <c:when test="${not empty carBookingList}">

                        <!-- Header row -->
                        <div class="booking-grid"
                             style="padding: var(--space-3) var(--space-6); font-weight: 700; color: var(--color-gray-light); font-size: 0.85rem; text-transform: uppercase; border-bottom: 1px solid var(--color-dark-border); margin-bottom: var(--space-4);">
                            <div>No.</div>
                            <div>Customer</div>
                            <div>Car / Brand</div>
                            <div>Start Date</div>
                            <div>End Date</div>
                            <div>Total Value</div>
                            <div style="text-align:right;">Status / Action</div>
                        </div>

                        <!-- Data rows -->
                        <c:forEach var="item" items="${carBookingList}" varStatus="loop">
                            <fmt:parseDate value="${item.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="sDate" type="both" />
                            <fmt:parseDate value="${item.endDate}"   pattern="yyyy-MM-dd'T'HH:mm" var="eDate" type="both" />
                            <div class="booking-row-card">
                                <div class="booking-grid">

                                    <!-- No. -->
                                    <div class="grid-col col-no">#${loop.index + 1}</div>

                                    <!-- Customer name -->
                                    <div class="grid-col col-customer">
                                        <c:out value="${item.customerName}" />
                                    </div>

                                    <!-- Car brand (carModel if available, else bookingId placeholder) -->
                                    <div class="grid-col col-meta">
                                        <c:choose>
                                            <c:when test="${not empty item.carBrand}">
                                                <c:out value="${item.carBrand}" />
                                                <c:if test="${not empty item.carModel}"> <c:out value="${item.carModel}" /></c:if>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Start date -->
                                    <div class="grid-col col-meta">
                                        <fmt:formatDate value="${sDate}" pattern="dd/MM/yy" />
                                    </div>

                                    <!-- End date -->
                                    <div class="grid-col col-meta">
                                        <fmt:formatDate value="${eDate}" pattern="dd/MM/yy" />
                                    </div>

                                    <!-- Total value -->
                                    <div class="grid-col" style="color:var(--orange); font-weight:600;">
                                        <fmt:formatNumber value="${item.subtotalFee}" type="number" groupingUsed="true" /> ₫
                                    </div>

                                    <!-- Status + Action -->
                                    <div style="display:flex; flex-direction:column; align-items:flex-end; gap:var(--space-2);">
                                        <span class="status-badge ${item.status == 'Pending' ? 'pending' : (item.status == 'Confirmed' ? 'confirmed' : (item.status == 'Active' ? 'active' : (item.status == 'Completed' ? 'completed' : (item.status == 'Approved' ? 'approved' : (item.status == 'Cancelled' ? 'cancelled' : 'rejected')))))}">
                                            <c:out value="${item.status}" />
                                        </span>
                                        <a href="${pageContext.request.contextPath}/staff/bookings?action=detail&id=${item.bookingId}"
                                           class="btn btn-outline-blue btn-sm">Inspect Details</a>
                                    </div>

                                </div>
                            </div>
                        </c:forEach>

                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon"><i class="bi bi-calendar2-x-fill"></i></div>
                            <div class="empty-state-title">No car bookings available</div>
                            <p class="text-muted text-sm" style="margin-top:0.5rem;">There are no car bookings matching your current filter specs.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </main>
    </div>
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>

</html>