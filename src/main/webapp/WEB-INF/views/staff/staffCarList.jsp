<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Vehicle Verification Master - CarRental Staff</title>
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

                    .car-row-card {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-6);
                        margin-bottom: var(--space-4);
                        display: flex;
                        align-items: center;
                        gap: var(--space-6);
                        transition: var(--transition-fast);
                    }

                    .car-row-card:hover {
                        border-color: var(--color-blue-border);
                    }

                    .car-row-img {
                        width: 110px;
                        height: 80px;
                        border-radius: var(--radius-lg);
                        object-fit: cover;
                        background: var(--color-dark-surface);
                        border: 1px solid var(--color-dark-border);
                    }

                    .car-row-details {
                        flex-grow: 1;
                        display: flex;
                        flex-direction: column;
                        gap: var(--space-1);
                    }

                    .car-row-title {
                        font-size: 1.15rem;
                        font-weight: 700;
                        color: var(--color-white);
                    }

                    .car-row-meta {
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
                            <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/staff/bookings"><i class="bi bi-calendar2-check-fill"></i> Manage Bookings</a></li>
                            <li class="mgmt-menu-item active"><a href="${pageContext.request.contextPath}/staff/cars"><i class="bi bi-car-front-fill"></i> Manage Cars</a></li>

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
                                    <span>Vehicle List</span></h1>
                                <p class="text-muted text-sm">Review, verify registration specs, and approve vehicle
                                    partner applications.</p>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                            <!-- Search bar -->
                            <div class="search-panel">
                                <form action="${pageContext.request.contextPath}/staff/cars" method="get"
                                    class="search-form">
                                    <input type="hidden" name="action" value="search" />
                                    <input type="text" name="keyword" class="form-control"
                                        placeholder="Search by name, plate, owner name, status..."
                                        value="<c:out value='${requestScope.keywordVal}'/>" required />
                                    <button type="submit" class="btn btn-blue btn-sm"
                                        style="padding:0 var(--space-4); height:42px;">Search</button>
                                    <c:if test="${not empty keywordVal}">
                                        <a href="${pageContext.request.contextPath}/staff/cars?action=list"
                                            class="btn btn-ghost btn-sm"
                                            style="height:42px; display:flex; align-items:center;">Reset</a>
                                    </c:if>
                                </form>
                                <div class="text-xs text-muted">Master vehicle scope</div>
                            </div>

                            <!-- Vehicles master list -->
                            <c:choose>
                                <c:when test="${not empty carList}">
                                    <c:forEach var="car" items="${carList}">
                                        <div class="car-row-card">
                                            <c:choose>
                                                <c:when test="${not empty car.primaryImageUrl}">
                                                    <img src="${car.primaryImageUrl}" class="car-row-img"
                                                        alt="${car.carName}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="car-row-img"
                                                        style="display:flex; align-items:center; justify-content:center; font-size:2rem;">
                                                        🚘</div>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="car-row-details">
                                                <div class="car-row-title">
                                                    <c:out value="${car.brand}" />
                                                    <c:out value="${car.carName}" />
                                                </div>
                                                <div class="car-row-meta">
                                                    Plate: <strong>
                                                        <c:out value="${car.licensePlate}" />
                                                    </strong>   Owner:
                                                    <c:out value="${car.ownerName}" />
                                                </div>
                                                <div class="car-row-meta">
                                                    Rate: <strong style="color:var(--color-white);">
                                                        <fmt:formatNumber value="${car.pricePerDay}" type="number"
                                                            groupingUsed="true" /> VND
                                                    </strong>
                                                </div>
                                            </div>

                                            <div
                                                style="text-align:right; display:flex; flex-direction:column; gap:var(--space-2); align-items:flex-end;">
                                                <div
                                                    class="status-badge ${car.status == 'Approved' ? 'approved' : (car.status == 'Rejected' ? 'rejected' : 'pending')}">
                                                    <c:out value="${car.status}" />
                                                </div>
                                                <a href="${pageContext.request.contextPath}/staff/cars?action=detail&id=${car.carId}"
                                                    class="btn btn-outline-blue btn-sm">Verify Specs</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Empty list state message () -->
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
            </body>
            </html>