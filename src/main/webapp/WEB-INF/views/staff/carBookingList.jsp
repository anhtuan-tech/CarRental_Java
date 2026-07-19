<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
                            <div class="mgmt-sidebar-title"><i class="bi bi-clipboard2-check-fill"></i> Staff Desk</div>
                            <div class="mgmt-sidebar-subtitle">Operations Panel</div>
                        </div>
                        <ul class="mgmt-menu">
                            <div class="mgmt-menu-section-title">Overview</div>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/staff/dashboard"><i
                                        class="bi bi-speedometer2"></i> Dashboard</a></li>
                            <div class="mgmt-menu-section-title">Operations</div>
                            <li class="mgmt-menu-item active"><a
                                    href="${pageContext.request.contextPath}/staff/bookings"><i
                                        class="bi bi-calendar2-check-fill"></i> Manage Bookings</a></li>
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/staff/cars"><i
                                        class="bi bi-car-front-fill"></i> Manage Cars</a></li>
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

                            <!-- Instant Search Input -->
                            <div style="margin-bottom:1.5rem; max-width:420px; position:relative;">
                                <input type="text" id="bookingSearchInput" class="form-control"
                                    placeholder="Search by customer, owner, car name, status..."
                                    style="padding-left:2.5rem; height:42px;" />
                                <i class="bi bi-search"
                                    style="position:absolute; left:1rem; top:50%; transform:translateY(-50%); color:var(--color-gray-light); font-size:0.95rem;"></i>
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
                                           class="booking-row-card"
                                           data-status="<c:out value='${item.status}'/>"
                                           data-customer="<c:out value='${item.customerName}'/>"
                                           data-owner="<c:out value='${item.ownerName}'/>"
                                           data-car="<c:out value='${item.brand} ${item.carName}'/>">
                                            <div class="booking-grid">

                                                <!-- No. -->
                                                <div class="grid-col col-no">#${loop.index + 1}</div>

                                                <!-- Customer & Owner names -->
                                                <div class="grid-col col-customer">
                                                    <div style="font-weight: 700; color: var(--color-white);"><c:out value="${item.customerName}" /></div>
                                                    <c:if test="${not empty item.ownerName}">
                                                        <div style="font-size: 0.78rem; color: var(--color-gray-light); margin-top: 2px; font-weight: 500;">
                                                            <i class="bi bi-key-fill" style="color: var(--orange);"></i> Owner: <c:out value="${item.ownerName}" />
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

                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        var searchInput = document.getElementById("bookingSearchInput");
                        var cards = document.querySelectorAll(".booking-row-card");
                        var container = document.querySelector(".admin-container");

                        function applyBookingFilter() {
                            var searchVal = searchInput ? searchInput.value.trim().toLowerCase() : "";
                            var visibleCount = 0;

                            cards.forEach(function (card) {
                                var status = (card.getAttribute("data-status") || "").toLowerCase();
                                var customer = (card.getAttribute("data-customer") || "").toLowerCase();
                                var owner = (card.getAttribute("data-owner") || "").toLowerCase();
                                var car = (card.getAttribute("data-car") || "").toLowerCase();

                                // Keyword match
                                var matchSearch = !searchVal ||
                                    customer.indexOf(searchVal) !== -1 ||
                                    owner.indexOf(searchVal) !== -1 ||
                                    car.indexOf(searchVal) !== -1 ||
                                    status.indexOf(searchVal) !== -1;

                                if (matchSearch) {
                                    card.style.display = "";
                                    visibleCount++;
                                } else {
                                    card.style.display = "none";
                                }
                            });

                            var emptyState = document.getElementById("emptyBookingFilterState");

                            if (visibleCount === 0) {
                                if (!emptyState) {
                                    emptyState = document.createElement("div");
                                    emptyState.id = "emptyBookingFilterState";
                                    emptyState.className = "empty-state";
                                    emptyState.innerHTML = '<div class="empty-state-icon"><i class="bi bi-funnel-fill"></i></div>' +
                                        '<div class="empty-state-title">No matching bookings found</div>' +
                                        '<p class="text-muted text-sm" style="margin-top:0.5rem;">There are no rental bookings matching your search criteria.</p>';
                                    container.appendChild(emptyState);
                                } else {
                                    emptyState.style.display = "";
                                }
                            } else {
                                if (emptyState) emptyState.style.display = "none";
                            }
                        }

                        if (searchInput) searchInput.addEventListener("input", applyBookingFilter);
                    });
                </script>
            </body>

            </html>