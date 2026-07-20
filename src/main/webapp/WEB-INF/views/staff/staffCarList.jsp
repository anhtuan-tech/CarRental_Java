<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Vehicle Verification Master - CarRental Staff</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
                <style>
                    .admin-container {
                        max-width: 100%;
                        margin: 0 auto;
                        padding: 0 var(--space-4);
                    }

                    /* ── Grid layout ─────────────────────────────────────── */
                    .car-grid {
                        display: grid;
                        grid-template-columns: 70px 90px 2.5fr 1.5fr 2fr 1.5fr 1.5fr 80px;
                        align-items: center;
                        gap: var(--space-4);
                        width: 100%;
                    }

                    .car-row-card {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-4) var(--space-6);
                        margin-bottom: var(--space-4);
                        transition: var(--transition-fast);
                        cursor: pointer;
                        text-decoration: none;
                        display: block;
                    }

                    .car-row-card:hover {
                        border-color: var(--color-blue-border);
                    }

                    .car-thumb {
                        width: 80px;
                        height: 56px;
                        border-radius: var(--radius-lg);
                        object-fit: cover;
                        background: var(--color-dark-surface);
                        border: 1px solid var(--color-dark-border);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.8rem;
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

                    .col-name {
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

                    .status-badge.approved {
                        background: rgba(16, 185, 129, 0.1);
                        color: #10B981;
                        border: 1px solid rgba(16, 185, 129, 0.2);
                    }

                    .status-badge.rejected {
                        background: rgba(239, 68, 68, 0.1);
                        color: #EF4444;
                        border: 1px solid rgba(239, 68, 68, 0.2);
                    }

                    .status-badge.available {
                        background: rgba(16, 185, 129, 0.1);
                        color: #10B981;
                        border: 1px solid rgba(16, 185, 129, 0.2);
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
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/staff/bookings"><i
                                        class="bi bi-calendar2-check-fill"></i> Manage Bookings</a></li>
                            <li class="mgmt-menu-item active"><a href="${pageContext.request.contextPath}/staff/cars"><i
                                        class="bi bi-car-front-fill"></i> Manage Cars</a></li>
                        </ul>
            </aside>

                    <!-- Main Content -->
                    <main class="mgmt-content">
                        <div class="admin-container">

                            <div class="mb-6">
                                <h1 class="hero-title"
                                    style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                                    Manage <span>Cars</span>
                                </h1>
                                <p class="text-muted text-sm">Review, verify registration specs, and approve vehicle
                                    partner applications.</p>
                            </div>

                            <!-- Action bar & search & Filter -->
                            <div class="action-bar"
                                style="display:flex; justify-content:space-between; align-items:center; gap:1.5rem; margin-bottom:1.5rem; flex-wrap:wrap; width:100%;">
                                <!-- Left: Instant Search Input -->
                                <div style="flex-grow:1; max-width:400px; position:relative;">
                                    <form action="${pageContext.request.contextPath}/staff/cars" method="get" style="margin:0;">
                                        <input type="hidden" name="action" value="search" />
                                        <input type="hidden" name="size" value="${pageSize != null ? pageSize : 10}" />
                                        <input type="text" name="keyword" value="${keywordVal}" class="form-control"
                                            placeholder="Search by name, plate, owner name and press Enter..."
                                            style="padding-left:2.5rem; height:42px;" />
                                        <i class="bi bi-search"
                                            style="position:absolute; left:1rem; top:50%; transform:translateY(-50%); color:var(--color-gray-light); font-size:0.95rem;"></i>
                                        <button type="submit" style="display:none;"></button>
                                    </form>
                                </div>

                                <!-- Right: Status filter dropdown -->
                                <div style="display:flex; align-items:center; gap:0.5rem;">
                                    <span class="text-xs text-muted"
                                        style="text-transform:uppercase; font-weight:600;">Status:</span>
                                    <select id="statusFilter" class="form-control"
                                        style="width:220px; height:42px; background:var(--color-dark-card); border-color:var(--color-dark-border); color:var(--color-white); border-radius:var(--radius-lg); padding:0 var(--space-3);">
                                        <option value="ALL" selected>All Statuses</option>
                                        <option value="Pending_Approval">Pending Approval</option>
                                        <option value="Available">Available / Approved</option>
                                        <option value="Rejected">Rejected</option>
                                    </select>
                                </div>
                            </div>

                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                            <!-- Car table -->
                            <c:choose>
                                <c:when test="${not empty carList}">

                                    <!-- Header row -->
                                    <div class="car-grid car-grid-header"
                                        style="padding: var(--space-3) var(--space-6); font-weight: 700; color: var(--color-gray-light); font-size: 0.85rem; text-transform: uppercase; border-bottom: 1px solid var(--color-dark-border); margin-bottom: var(--space-4);">
                                        <div>No.</div>
                                        <div>Photo</div>
                                        <div>Car Name</div>
                                        <div>Plate</div>
                                        <div>Owner</div>
                                        <div>Rate / Day</div>
                                        <div style="text-align:right;">Status</div>
                                        <div style="text-align:center;">Action</div>
                                    </div>

                                    <!-- Data rows -->
                                    <c:forEach var="car" items="${carList}" varStatus="loop">
                                        <a href="${pageContext.request.contextPath}/staff/cars?action=detail&id=${car.carId}"
                                            class="car-row-card" data-status="${car.status}"
                                            data-name="<c:out value='${car.brand} ${car.carName}'/>"
                                            data-plate="<c:out value='${car.licensePlate}'/>"
                                            data-owner="<c:out value='${car.ownerName}'/>">
                                            <div class="car-grid">

                                                <!-- No. -->
                                                <div class="grid-col col-no">#${loop.index + 1}</div>

                                                <!-- Thumbnail -->
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${not empty car.primaryImageUrl}">
                                                            <img src="${pageContext.request.contextPath}${car.primaryImageUrl}" class="car-thumb"
                                                                alt="${car.carName}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="car-thumb"><i class="bi bi-car-front"
                                                                    style="color:var(--color-gray-light);"></i></div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Car Name -->
                                                <div class="grid-col col-name">
                                                    <c:out value="${car.brand}" />
                                                    <c:out value="${car.carName}" />
                                                </div>

                                                <!-- License Plate -->
                                                <div class="grid-col col-meta">
                                                    <strong style="color:var(--color-white);">
                                                        <c:out value="${car.licensePlate}" />
                                                    </strong>
                                                </div>

                                                <!-- Owner -->
                                                <div class="grid-col col-meta">
                                                    <c:out value="${car.ownerName}" />
                                                </div>

                                                <!-- Rate -->
                                                <div class="grid-col" style="color:var(--orange); font-weight:600;">
                                                    <fmt:formatNumber value="${car.pricePerDay}" type="number"
                                                        groupingUsed="true" /> ₫
                                                </div>

                                                <!-- Status only -->
                                                <div style="display:flex; justify-content:flex-end;">
                                                    <span
                                                        class="status-badge ${car.status == 'Approved' ? 'approved' : (car.status == 'Available' ? 'available' : (car.status == 'Rejected' ? 'rejected' : 'pending'))}">
                                                        <c:out value="${car.status}" />
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
                                        </a>
                                    </c:forEach>
                                    
                                    <!-- Pagination Controls -->
                                    <c:if test="${totalPages > 0}">
                                        <div class="pagination-wrapper" style="display:flex; justify-content:space-between; align-items:center; margin-top:2rem;">
                                            <div class="page-size-selector">
                                                <form action="${pageContext.request.contextPath}/staff/cars" method="get" style="margin:0; display:flex; align-items:center; gap:0.5rem;">
                                                    <input type="hidden" name="action" value="${not empty keywordVal ? 'search' : 'list'}" />
                                                    <c:if test="${not empty keywordVal}">
                                                        <input type="hidden" name="keyword" value="${keywordVal}" />
                                                    </c:if>
                                                    <span class="text-sm text-muted">Show:</span>
                                                    <select name="size" class="form-control" style="width:70px; height:32px; padding:0 0.5rem; background:var(--color-dark-card); border-color:var(--color-dark-border); color:var(--color-white);" onchange="this.form.submit()">
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
                                                <a href="?action=${not empty keywordVal ? 'search' : 'list'}&keyword=${keywordVal}&size=${pageSize}&page=${prevPage}" class="btn btn-sm ${currentPage == 1 ? 'disabled' : ''}" style="border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);">&laquo; Prev</a>
                                                
                                                <c:forEach begin="1" end="${totalPages}" var="p">
                                                    <a href="?action=${not empty keywordVal ? 'search' : 'list'}&keyword=${keywordVal}&size=${pageSize}&page=${p}" class="btn btn-sm" style="${p == currentPage ? 'background:var(--orange); color:white; border-color:var(--orange);' : 'border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);'}">${p}</a>
                                                </c:forEach>
                                                
                                                <c:set var="nextPage" value="${currentPage + 1 <= totalPages ? currentPage + 1 : totalPages}" />
                                                <a href="?action=${not empty keywordVal ? 'search' : 'list'}&keyword=${keywordVal}&size=${pageSize}&page=${nextPage}" class="btn btn-sm ${currentPage == totalPages ? 'disabled' : ''}" style="border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);">Next &raquo;</a>
                                            </div>
                                        </div>
                                    </c:if>

                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-state-icon"><i class="bi bi-car-front-fill"></i></div>
                                        <div class="empty-state-title">No cars available</div>
                                        <p class="text-muted text-sm" style="margin-top:0.5rem;">There are no vehicles
                                            currently submitted to the platform.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </main>
                </div>

                <jsp:include page="/WEB-INF/views/common/footer.jsp" />

                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        var statusFilter = document.getElementById("statusFilter");
                        var searchInput = document.getElementById("carSearchInput");
                        var container = document.querySelector(".admin-container");

                        function applyFilter() {
                            var selectedStatus = statusFilter.value;
                            var searchVal = searchInput ? searchInput.value.trim().toLowerCase() : "";
                            var cards = document.querySelectorAll(".car-row-card");
                            var visibleCount = 0;
                            var paginationWrapper = document.querySelector(".pagination-wrapper");

                            cards.forEach(function (card) {
                                var cardStatus = card.getAttribute("data-status");
                                var cardName = card.getAttribute("data-name").toLowerCase();
                                var cardPlate = card.getAttribute("data-plate").toLowerCase();
                                var cardOwner = card.getAttribute("data-owner").toLowerCase();

                                // Status match
                                var isStatusMatch = false;
                                if (selectedStatus === "ALL") {
                                    isStatusMatch = true;
                                } else if (selectedStatus === "Pending_Approval") {
                                    isStatusMatch = (cardStatus === "Pending_Approval" || cardStatus === "Pending");
                                } else if (selectedStatus === "Available") {
                                    isStatusMatch = (cardStatus === "Available" || cardStatus === "Approved");
                                } else {
                                    isStatusMatch = (cardStatus === selectedStatus);
                                }

                                // Search keyword match
                                var isSearchMatch = false;
                                if (!searchVal) {
                                    isSearchMatch = true;
                                } else {
                                    isSearchMatch = (cardName.indexOf(searchVal) !== -1 ||
                                        cardPlate.indexOf(searchVal) !== -1 ||
                                        cardOwner.indexOf(searchVal) !== -1);
                                }

                                // Combine matches
                                if (isStatusMatch && isSearchMatch) {
                                    card.style.display = "";
                                    visibleCount++;
                                } else {
                                    card.style.display = "none";
                                }
                            });

                            var header = document.querySelector(".car-grid-header");
                            var emptyState = document.getElementById("emptyFilterState");

                            if (visibleCount === 0) {
                                if (header) header.style.display = "none";
                                if (paginationWrapper) paginationWrapper.style.display = "none";
                                if (!emptyState) {
                                    emptyState = document.createElement("div");
                                    emptyState.id = "emptyFilterState";
                                    emptyState.className = "empty-state";
                                    emptyState.innerHTML = '<div class="empty-state-icon"><i class="bi bi-funnel-fill"></i></div>' +
                                        '<div class="empty-state-title">No matching vehicles</div>' +
                                        '<p class="text-muted text-sm" style="margin-top:0.5rem;">There are no vehicles matching your search criteria.</p>';
                                    container.appendChild(emptyState);
                                } else {
                                    emptyState.style.display = "";
                                }
                            } else {
                                if (header) header.style.display = "";
                                if (paginationWrapper) paginationWrapper.style.display = "flex";
                                if (emptyState) emptyState.style.display = "none";
                            }
                        }

                        if (statusFilter) {
                            statusFilter.addEventListener("change", applyFilter);
                        }
                        if (searchInput) {
                            searchInput.addEventListener("input", applyFilter);
                        }

                        // Initial filter on load
                        applyFilter();
                    });
                </script>
            </body>

            </html>