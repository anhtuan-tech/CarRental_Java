<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <meta name="description" content="Explore and rent luxury cars from CarRental." />
                <title>Browse Cars - Car Rental</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
                <style>
                    /* Extra filters panel styling */
                    .filters-panel {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-6);
                        margin-bottom: var(--space-8);
                    }

                    .filters-form {
                        display: grid;
                        grid-template-columns: 2fr 1fr 1fr 1fr auto;
                        gap: var(--space-4);
                        align-items: flex-end;
                    }

                    @media (max-width: 992px) {
                        .filters-form {
                            grid-template-columns: 1fr 1fr;
                        }
                    }

                    @media (max-width: 576px) {
                        .filters-form {
                            grid-template-columns: 1fr;
                        }
                    }

                    .pagination-container {
                        display: flex;
                        justify-content: center;
                        margin-top: var(--space-12);
                    }

                    .pagination {
                        display: flex;
                        gap: var(--space-2);
                    }

                    .page-link {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        min-width: 40px;
                        height: 40px;
                        border-radius: var(--radius-md);
                        background: var(--color-dark-surface);
                        border: 1px solid var(--color-dark-border);
                        color: var(--color-gray-light);
                        font-weight: 600;
                        transition: var(--transition-fast);
                    }

                    .page-link:hover {
                        border-color: var(--color-blue);
                        color: var(--color-white);
                        background: var(--color-blue-glow);
                    }

                    .page-link.active {
                        background: var(--color-blue);
                        border-color: var(--color-blue);
                        color: var(--color-white);
                    }
                </style>
                <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>

            <body>

                <jsp:include page="/WEB-INF/views/common/header.jsp" />

                <div class="page-wrapper">
                    <div class="container mt-4">

                        <!-- Header -->
                        <div class="mb-6">
                            <h1 class="hero-title" style="font-size:2rem; margin-bottom: 0.5rem;">Choose <span>Your
                                    Car</span></h1>
                            <p class="text-muted text-sm">Discover the perfect vehicle for your next exceptional
                                journey.</p>
                        </div>

                        <!-- Search & Filter Panel -->
                        <div class="filters-panel">
                            <form action="${pageContext.request.contextPath}/cars" method="get" class="filters-form"
                                style="display: grid; grid-template-columns: 2fr 1fr 1fr 1fr auto; gap: var(--space-4); align-items: flex-end; width: 100%;">
                                <input type="hidden" name="action" value="search">
                                <c:if test="${not empty pageSize}">
                                    <input type="hidden" name="size" value="${pageSize}">
                                </c:if>

                                <div class="form-group" style="margin-bottom:0;">
                                    <label for="query" class="form-label">Search</label>
                                    <div class="input-wrapper">
                                        <span class="input-icon"><i class="bi bi-search"
                                                style="font-size: 0.95rem;"></i></span>
                                        <input type="text" id="query" name="query" class="form-control"
                                            placeholder="Mercedes, Audi, SUV..."
                                            value="<c:out value='${requestScope.queryVal}'/>" />
                                    </div>
                                </div>

                                <div class="form-group" style="margin-bottom:0;">
                                    <label for="typeId" class="form-label">Car Type</label>
                                    <select id="typeId" name="typeId" class="form-control">
                                        <option value="">All Types</option>
                                        <c:forEach var="type" items="${requestScope.carTypes}">
                                            <option value="${type.typeId}" ${type.typeId==requestScope.typeIdVal
                                                ? 'selected' : '' }>
                                                <c:out value="${type.typeName}" />
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group" style="margin-bottom:0;">
                                    <label for="minPrice" class="form-label">Min Price</label>
                                    <input type="number" id="minPrice" name="minPrice" class="form-control"
                                        placeholder="Min" value="<c:out value='${requestScope.minPriceVal}'/>" />
                                </div>

                                <div class="form-group" style="margin-bottom:0;">
                                    <label for="maxPrice" class="form-label">Max Price</label>
                                    <input type="number" id="maxPrice" name="maxPrice" class="form-control"
                                        placeholder="Max" value="<c:out value='${requestScope.maxPriceVal}'/>" />
                                </div>

                                <div class="form-group" style="margin-bottom:0;">
                                    <button type="submit" class="btn btn-primary"
                                        style="height: 42px; width: 100%;">Filter</button>
                                </div>
                            </form>
                        </div>

                        <!-- Fleet Grid -->
                        <div class="section-header">
                            <h2 class="section-title">Available <span>Cars</span></h2>
                            <span class="text-muted text-sm">
                                <c:choose>
                                    <c:when test="${totalCars > 0}">Showing ${totalCars} results</c:when>
                                    <c:otherwise>No cars found</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <c:choose>
                            <c:when test="${not empty cars}">
                                <div class="cars-grid">
                                    <c:forEach var="car" items="${cars}">
                                        <div class="car-card" data-type-id="${car.typeId}"
                                            data-price="${car.pricePerDay}"
                                            onclick="window.location.href = '${pageContext.request.contextPath}/cars?action=detail&id=${car.carId}'">
                                            <div class="car-card-image">
                                                <c:choose>
                                                    <c:when test="${not empty car.primaryImageUrl}">
                                                        <img src="${pageContext.request.contextPath}${car.primaryImageUrl}"
                                                            alt="${car.carName}" loading="lazy" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="car-card-placeholder"><i
                                                                class="bi bi-car-front-fill"
                                                                style="font-size:2rem; color:var(--color-gray-mid);"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="car-badge">
                                                    <c:out value="${not empty car.typeName ? car.typeName : 'Car'}" />
                                                </span>
                                            </div>
                                            <div class="car-card-body">
                                                <div class="car-card-name">
                                                    <c:out value="${car.carName}" />
                                                </div>
                                                <div class="car-card-brand">
                                                    <c:out value="${car.brand}" />
                                                    <c:out value="${car.model}" />
                                                </div>
                                                <div class="car-card-footer">
                                                    <div class="car-price">
                                                        <span class="car-price-value">
                                                            <fmt:formatNumber value="${car.pricePerDay}" type="number"
                                                                groupingUsed="true" /> VND
                                                        </span>
                                                        <span class="car-price-label">/ day</span>
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/cars?action=detail&id=${car.carId}"
                                                        class="btn btn-outline-blue btn-sm">View Details</a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 0}">
                                    <div class="pagination-wrapper"
                                        style="display:flex; justify-content:space-between; align-items:center; margin-top:2rem;">
                                        <div class="page-size-selector">
                                            <form action="${pageContext.request.contextPath}/cars" method="get"
                                                style="margin:0; display:flex; align-items:center; gap:0.5rem;">
                                                <input type="hidden" name="action"
                                                    value="${param.action == 'search' ? 'search' : 'list'}">
                                                <c:if test="${not empty queryVal}">
                                                    <input type="hidden" name="query" value="${queryVal}">
                                                </c:if>
                                                <c:if test="${not empty typeIdVal}">
                                                    <input type="hidden" name="typeId" value="${typeIdVal}">
                                                </c:if>
                                                <c:if test="${not empty minPriceVal}">
                                                    <input type="hidden" name="minPrice" value="${minPriceVal}">
                                                </c:if>
                                                <c:if test="${not empty maxPriceVal}">
                                                    <input type="hidden" name="maxPrice" value="${maxPriceVal}">
                                                </c:if>
                                                <span class="text-sm text-muted">Show:</span>
                                                <select name="size" class="form-control"
                                                    style="width:70px; height:32px; padding:0 0.5rem; background:var(--color-dark-card); border-color:var(--color-dark-border); color:var(--color-white);"
                                                    onchange="this.form.submit()">
                                                    <option value="5" ${pageSize==5 ? 'selected' : '' }>5</option>
                                                    <option value="10" ${pageSize==10 ? 'selected' : '' }>10</option>
                                                    <option value="15" ${pageSize==15 || empty pageSize ? 'selected' : '' }>15</option>
                                                    <option value="30" ${pageSize==30 ? 'selected' : '' }>30</option>
                                                    <option value="50" ${pageSize==50 ? 'selected' : '' }>50</option>
                                                </select>
                                                <span class="text-sm text-muted">entries</span>
                                            </form>
                                        </div>
                                        <div class="pagination-links" style="display:flex; gap:0.25rem;">
                                            <c:set var="prevPage"
                                                value="${currentPage - 1 > 0 ? currentPage - 1 : 1}" />
                                            <a href="${pageContext.request.contextPath}/cars?action=${param.action == 'search' ? 'search' : 'list'}&page=${prevPage}&size=${pageSize}&query=${queryVal}&typeId=${typeIdVal}&minPrice=${minPriceVal}&maxPrice=${maxPriceVal}"
                                                class="btn btn-sm ${currentPage <= 1 ? 'disabled' : ''}"
                                                style="border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);">&laquo;
                                                Prev</a>

                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <a href="${pageContext.request.contextPath}/cars?action=${param.action == 'search' ? 'search' : 'list'}&page=${p}&size=${pageSize}&query=${queryVal}&typeId=${typeIdVal}&minPrice=${minPriceVal}&maxPrice=${maxPriceVal}"
                                                    class="btn btn-sm"
                                                    style="${p == currentPage ? 'background:var(--orange); color:white; border-color:var(--orange);' : 'border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);'}">${p}</a>
                                            </c:forEach>

                                            <c:set var="nextPage"
                                                value="${currentPage + 1 <= totalPages ? currentPage + 1 : totalPages}" />
                                            <a href="${pageContext.request.contextPath}/cars?action=${param.action == 'search' ? 'search' : 'list'}&page=${nextPage}&size=${pageSize}&query=${queryVal}&typeId=${typeIdVal}&minPrice=${minPriceVal}&maxPrice=${maxPriceVal}"
                                                class="btn btn-sm ${currentPage >= totalPages ? 'disabled' : ''}"
                                                style="border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);">Next
                                                &raquo;</a>
                                        </div>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-state-icon"><i class="bi bi-car-front-fill"></i></div>
                                    <div class="empty-state-title">No cars match your search criteria</div>
                                    <p class="text-muted text-sm" style="margin-top: 0.5rem;">Try adjusting your query
                                        or filters.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                    </div>
                </div>

                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </body>

            </html>