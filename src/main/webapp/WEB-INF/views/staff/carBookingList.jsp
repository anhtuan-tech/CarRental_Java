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
                    .staff-container {
                        max-width: 1000px;
                        margin: var(--space-8) auto;
                    }

                    .search-panel {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-4) var(--space-6);
                        margin-bottom: var(--space-6);
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        gap: var(--space-4);
                    }

                    .search-form {
                        display: flex;
                        gap: var(--space-2);
                        flex-grow: 1;
                        max-width: 500px;
                    }

                    .booking-row-card {
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

                    .booking-row-card:hover {
                        border-color: var(--color-blue-border);
                    }

                    .booking-row-details {
                        display: flex;
                        flex-direction: column;
                        gap: var(--space-1);
                    }

                    .booking-row-id {
                        font-family: monospace;
                        font-size: 0.9rem;
                        color: var(--color-blue-light);
                    }

                    .booking-row-title {
                        font-size: 1.15rem;
                        font-weight: 700;
                        color: var(--color-white);
                    }

                    .booking-row-meta {
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
                </style>
            </head>

            <body>
                <jsp:include page="/WEB-INF/views/common/header.jsp" />
                <div class="mgmt-wrapper">
                    <aside class="mgmt-sidebar">
                        <div class="mgmt-sidebar-header">
                            <div class="mgmt-sidebar-title">💻 Staff Desk</div>
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
                    <main class="mgmt-content">
                        <div class="staff-container">

                            <div class="mb-6">
                                <h1 class="hero-title"
                                    style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">Master
                                    <span>Bookings Log</span></h1>
                                <p class="text-muted text-sm">Review, inspect, and update status for all application
                                    rentals.</p>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                            <!-- Search and Reset widgets -->
                            <div class="search-panel">
                                <form action="${pageContext.request.contextPath}/staff/bookings" method="get"
                                    class="search-form">
                                    <input type="hidden" name="action" value="search" />
                                    <input type="text" name="keyword" class="form-control"
                                        placeholder="Search by customer name, brand, status..."
                                        value="<c:out value='${requestScope.keywordVal}'/>" required />
                                    <button type="submit" class="btn btn-blue btn-sm"
                                        style="padding:0 var(--space-4); height:42px;">Search</button>
                                    <c:if test="${not empty keywordVal}">
                                        <a href="${pageContext.request.contextPath}/staff/bookings?action=list"
                                            class="btn btn-ghost btn-sm"
                                            style="height:42px; display:flex; align-items:center;">Reset</a>
                                    </c:if>
                                </form>
                                <div class="text-xs text-muted">Master collection scope</div>
                            </div>

                            <!-- Bookings List -->
                            <c:choose>
                                <c:when test="${not empty carBookingList}">
                                    <c:forEach var="item" items="${carBookingList}">
                                        <div class="booking-row-card">
                                            <div class="booking-row-details">
                                                <span class="booking-row-id">Booking ID: #
                                                    <c:out value="${item.bookingId}" />
                                                </span>
                                                <div class="booking-row-title">
                                                    <c:out value="${item.customerName}" />
                                                </div>
                                                <div class="booking-row-meta">
                                                    Period:
                                                    <fmt:parseDate value="${item.startDate}"
                                                        pattern="yyyy-MM-dd'T'HH:mm" var="sDate" type="both" />
                                                    <fmt:parseDate value="${item.endDate}" pattern="yyyy-MM-dd'T'HH:mm"
                                                        var="eDate" type="both" />
                                                    <strong>
                                                        <fmt:formatDate value="${sDate}" pattern="MM/dd/yy" />
                                                    </strong> to
                                                    <strong>
                                                        <fmt:formatDate value="${eDate}" pattern="MM/dd/yy" />
                                                    </strong>
                                                      Duration:
                                                    <c:out value="${item.totalDays}" /> days
                                                </div>
                                                <div class="booking-row-meta" style="margin-top:0.25rem;">
                                                    Total Value: <strong style="color:var(--color-white);">
                                                        <fmt:formatNumber value="${item.subtotalFee}" type="number"
                                                            groupingUsed="true" /> VND
                                                    </strong>
                                                </div>
                                            </div>

                                            <div
                                                style="text-align:right; display:flex; flex-direction:column; gap:var(--space-2); align-items:flex-end;">
                                                <div
                                                    class="status-badge ${item.status == 'Pending' ? 'pending' : (item.status == 'Confirmed' ? 'confirmed' : (item.status == 'Active' ? 'active' : (item.status == 'Completed' ? 'completed' : 'rejected')))}">
                                                    <c:out value="${item.status}" />
                                                </div>
                                                <a href="${pageContext.request.contextPath}/staff/bookings?action=detail&id=${item.bookingId}"
                                                    class="btn btn-outline-blue btn-sm">Inspect Details</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Empty list state message () -->
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="bi bi-calendar2-x-fill"></i></div>
                                        <div class="empty-state-title">No car bookings available</div>
                                        <p class="text-muted text-sm" style="margin-top:0.5rem;">There are no car
                                            bookings matching your current filter specs.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </main>
                </div>
                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </body>
            </html>