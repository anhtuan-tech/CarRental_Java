<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>My Car — Car Rental</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
        <style>
            /* ── Layout & Container ──────────────────────────────── */
            .admin-container {
                max-width: 100%;
                margin: 0 auto;
                padding: 0 var(--space-4);
            }

            /* ── Filter Area ─────────────────────────────────────── */
            .filter-bar {
                display: flex;
                gap: var(--sp-4);
                margin-bottom: var(--sp-6);
                align-items: center;
            }
            .search-wrapper {
                position: relative;
                flex-grow: 1;
                max-width: 400px;
            }
            .search-wrapper input {
                width: 100%;
                padding: 0.6rem 1rem 0.6rem 2.5rem;
                border: 1px solid var(--border);
                border-radius: var(--r-md);
                font-size: var(--text-sm);
                transition: var(--t-fast);
                background: var(--white);
            }
            .search-wrapper input:focus {
                border-color: var(--orange);
                outline: none;
                box-shadow: 0 0 0 3px var(--orange-glow);
            }
            .search-wrapper i {
                position: absolute;
                left: 1rem;
                top: 50%;
                transform: translateY(-50%);
                color: var(--text-faint);
            }
            .status-select {
                padding: 0.6rem 2.5rem 0.6rem 1rem;
                border: 1px solid var(--border);
                border-radius: var(--r-md);
                font-size: var(--text-sm);
                background-color: var(--white);
                color: var(--text-primary);
                cursor: pointer;
                outline: none;
                transition: var(--t-fast);
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%236B7280'%3E%3Cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 0.75rem center;
                background-size: 16px 12px;
            }
            .status-select:focus {
                border-color: var(--orange);
            }

            /* ── List Area ───────────────────────────────────────── */
            .car-list-container {
                background: var(--white);
                border: 1px solid var(--border);
                border-radius: var(--r-lg);
                overflow: hidden;
                box-shadow: var(--shadow-sm);
            }
            .car-list-header {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr 100px;
                gap: var(--sp-4);
                padding: var(--sp-3) var(--sp-6);
                background: var(--bg);
                border-bottom: 1px solid var(--border);
                font-size: 0.75rem;
                font-weight: 700;
                color: var(--text-muted);
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .car-list-row {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr 100px;
                gap: var(--sp-4);
                padding: var(--sp-4) var(--sp-6);
                align-items: center;
                border-bottom: 1px solid var(--border);
                transition: var(--t-fast);
            }
            .car-list-row:last-child {
                border-bottom: none;
            }
            .car-list-row:hover {
                background: var(--bg-alt);
            }

            /* Column 1: Info */
            .col-info {
                display: flex;
                align-items: center;
                gap: var(--sp-4);
            }
            .car-thumb {
                width: 72px;
                height: 50px;
                border-radius: var(--r-md);
                object-fit: cover;
                background: var(--bg);
                border: 1px solid var(--border);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                color: var(--text-faint);
                flex-shrink: 0;
            }
            .car-details {
                display: flex;
                flex-direction: column;
                gap: 0.15rem;
            }
            .car-name {
                font-size: var(--text-sm);
                font-weight: 700;
                color: #111827;
            }
            .car-meta {
                font-size: var(--text-xs);
                color: var(--text-muted);
            }

            /* Column 2: Rate */
            .col-rate {
                font-size: var(--text-sm);
                font-weight: 700;
                color: #374151; /* Dark Gray */
            }
            .col-rate span {
                font-weight: 400;
                color: var(--text-muted);
                font-size: var(--text-xs);
            }

            /* Column 3: Status */
            .status-badge {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 0.7rem;
                font-weight: 600;
                padding: 0.2rem 0.6rem;
                border-radius: 9999px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .status-badge.available {
                background: var(--success-bg);
                color: var(--success);
            }
            .status-badge.pending   {
                background: var(--warning-bg);
                color: var(--warning);
            }
            .status-badge.approved  {
                background: var(--success-bg);
                color: var(--success);
            }
            .status-badge.rejected  {
                background: var(--error-bg);
                color: var(--error);
            }

            /* Column 4: Actions */
            .col-actions {
                display: flex;
                justify-content: flex-end;
                gap: var(--sp-2);
            }
            .btn-action {
                width: 32px;
                height: 32px;
                border-radius: var(--r-md);
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border: 1px solid transparent;
                background: transparent;
                color: var(--text-muted);
                cursor: pointer;
                transition: var(--t-fast);
                text-decoration: none;
            }
            .btn-action:hover {
                background: var(--white);
                border-color: var(--border-dark);
                color: var(--text-primary);
            }
            .btn-action.delete:hover {
                background: var(--error-bg);
                border-color: transparent;
                color: var(--error);
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <div class="mgmt-wrapper">
            <jsp:include page="/WEB-INF/views/owner/ownerSidebar.jsp"/>

            <!-- Main Content -->
            <main class="mgmt-content">
                <div class="admin-container">

                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem; flex-wrap:wrap; gap:1rem;">
                        <div>
                            <h1 class="hero-title" style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                                Manage My <span>Cars</span>
                            </h1>
                            <p class="text-muted text-sm">Manage, register and monitor active cars in your rental fleet.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/owner/cars?action=register" class="btn btn-primary" style="height:42px; display:flex; align-items:center; gap:0.5rem;">
                            <i class="bi bi-plus-circle"></i> Register New Car
                        </a>
                    </div>
                    <div class="blue-line" style="margin-bottom: 2rem;"></div>

                    <!-- Filter Area -->
                    <div class="filter-bar">
                        <div class="search-wrapper">
                            <input type="text" id="carSearchInput" placeholder="Search by car name or plate..." />
                            <i class="bi bi-search"></i>
                        </div>
                        <select id="statusFilter" class="status-select">
                            <option value="all">All</option>
                            <option value="available">Available</option>
                            <option value="pending">Pending</option>
                            <option value="approved">Approved</option>
                            <option value="rejected">Rejected</option>
                        </select>
                    </div>

                    <!-- Car List -->
                    <c:choose>
                        <c:when test="${not empty carList}">
                            <div class="car-list-container">
                                <!-- Header row -->
                                <div class="car-list-header">
                                    <div>Car Information</div>
                                    <div>Rate</div>
                                    <div>Status</div>
                                    <div style="text-align:right;">Actions</div>
                                </div>

                                <!-- Data rows -->
                                <c:forEach var="car" items="${carList}">
                                    <div class="car-list-row"
                                         data-name="<c:out value='${car.brand} ${car.carName}'/>"
                                         data-plate="<c:out value='${car.licensePlate}'/>"
                                         data-status="<c:out value='${fn:toLowerCase(car.status == "Pending_Approval" ? "pending" : car.status)}'/>">

                                        <!-- Column 1: Info -->
                                        <div class="col-info">
                                            <c:choose>
                                                <c:when test="${not empty car.primaryImageUrl}">
                                                    <img src="${pageContext.request.contextPath}${car.primaryImageUrl}" class="car-thumb" alt="${car.carName}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="car-thumb"><i class="bi bi-car-front"></i></div>
                                                    </c:otherwise>
                                                </c:choose>
                                            <div class="car-details">
                                                <div class="car-name"><c:out value="${car.brand}" /> <c:out value="${car.carName}" /></div>
                                                <div class="car-meta">Plate: <c:out value="${car.licensePlate}" /></div>
                                            </div>
                                        </div>

                                        <!-- Column 2: Rate -->
                                        <div class="col-rate">
                                            <fmt:formatNumber value="${car.pricePerDay}" type="number" groupingUsed="true" /> ₫ <span>/ day</span>
                                        </div>

                                        <!-- Column 3: Status -->
                                        <div>
                                            <span class="status-badge ${car.status == 'Approved' ? 'approved' : (car.status == 'Available' ? 'available' : (car.status == 'Rejected' ? 'rejected' : 'pending'))}">
                                                <c:out value="${car.status == 'Pending_Approval' ? 'Pending' : car.status}" />
                                            </span>
                                        </div>

                                        <!-- Column 4: Actions -->
                                        <div class="col-actions">
                                            <a href="${pageContext.request.contextPath}/owner/cars?action=detail&id=${car.carId}" class="btn-action edit" title="Edit Car">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <button class="btn-action delete" title="Delete Car" onclick="deleteCar(event, '${car.carId}', '<c:out value="${car.brand} ${car.carName}"/>')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="db-empty" style="background:var(--white); border:1px solid var(--border); border-radius:var(--r-lg); padding:4rem 2rem; text-align:center;">
                                <i class="bi bi-car-front-fill" style="font-size:2.5rem; color:var(--text-faint); margin-bottom:1rem; display:block;"></i>
                                <div style="font-weight:700; color:var(--text-primary); font-size:1.1rem;">No registered cars found</div>
                                <p style="color:var(--text-muted); font-size:var(--text-sm); margin-top:0.25rem;">Start by registering your first vehicle on the platform.</p>
                                <a href="${pageContext.request.contextPath}/owner/cars?action=register" class="btn btn-primary" style="margin-top: 1.5rem;">Register Now</a>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </main>
        </div>

        <!-- Delete hidden form -->
        <form id="deleteForm" action="${pageContext.request.contextPath}/owner/cars?action=delete" method="post" style="display:none;">
            <input type="hidden" name="carId" id="deleteCarId" />
        </form>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />

        <script>
            function deleteCar(event, carId, carName) {
                event.preventDefault();
                event.stopPropagation();
                if (confirm("Are you sure you want to remove the vehicle '" + carName + "'? This action will mark it as deleted and cancel future operations.")) {
                    document.getElementById('deleteCarId').value = carId;
                    document.getElementById('deleteForm').submit();
                }
            }

            document.addEventListener("DOMContentLoaded", function () {
                var searchInput = document.getElementById("carSearchInput");
                var statusFilter = document.getElementById("statusFilter");

                function applyFilter() {
                    var searchVal = searchInput.value.trim().toLowerCase();
                    var statusVal = statusFilter.value.toLowerCase();
                    var rows = document.querySelectorAll(".car-list-row");
                    var visibleCount = 0;

                    rows.forEach(function (row) {
                        var cardName = row.getAttribute("data-name").toLowerCase();
                        var cardPlate = row.getAttribute("data-plate").toLowerCase();
                        var cardStatus = row.getAttribute("data-status");

                        var isSearchMatch = (!searchVal) || (cardName.indexOf(searchVal) !== -1 || cardPlate.indexOf(searchVal) !== -1);
                        var isStatusMatch = (statusVal === "all") || (cardStatus === statusVal);

                        if (isSearchMatch && isStatusMatch) {
                            row.style.display = "";
                            visibleCount++;
                        } else {
                            row.style.display = "none";
                        }
                    });

                    var header = document.querySelector(".car-list-header");
                    var emptyState = document.getElementById("emptyFilterState");

                    if (visibleCount === 0) {
                        if (header)
                            header.style.display = "none";
                        if (!emptyState) {
                            var container = document.querySelector(".car-list-container") || document.querySelector(".admin-container");
                            emptyState = document.createElement("div");
                            emptyState.id = "emptyFilterState";
                            emptyState.style.padding = "3rem 1rem";
                            emptyState.style.textAlign = "center";
                            emptyState.innerHTML = '<i class="bi bi-funnel-fill" style="font-size:2rem; color:var(--text-faint);"></i>' +
                                    '<div style="font-weight:700; color:var(--text-primary); margin-top:1rem;">No matching vehicles</div>' +
                                    '<p style="color:var(--text-muted); font-size:var(--text-sm); margin-top:0.25rem;">Try adjusting your filters.</p>';
                            container.appendChild(emptyState);
                        } else {
                            emptyState.style.display = "";
                        }
                    } else {
                        if (header)
                            header.style.display = "";
                        if (emptyState)
                            emptyState.style.display = "none";
                    }
                }

                if (searchInput)
                    searchInput.addEventListener("input", applyFilter);
                if (statusFilter)
                    statusFilter.addEventListener("change", applyFilter);
            });
        </script>
    </body>

</html>
