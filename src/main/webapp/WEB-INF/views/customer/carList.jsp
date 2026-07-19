<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="description" content="Explore and rent luxury cars from CarRental."/>
    <title>Fleet Listing - CarRental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1"/>
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
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="page-wrapper">
    <div class="container mt-4">
        
        <!-- Header -->
        <div class="mb-6">
            <h1 class="hero-title" style="font-size:2rem; margin-bottom: 0.5rem;">Explore <span>Our Fleet</span></h1>
            <p class="text-muted text-sm">Find the perfect luxury ride for your next journey.</p>
        </div>

        <!-- Search & Filter Panel -->
        <div class="filters-panel">
            <div class="filters-form" style="display: flex; align-items: center; gap: var(--space-4); flex-wrap: wrap; width: 100%;">
                <div class="form-group" style="margin-bottom:0; flex: 1; min-width: 200px;">
                    <label for="query" class="form-label">Search Keyword</label>
                    <div class="input-wrapper">
                        <span class="input-icon"><i class="bi bi-search" style="font-size: 0.95rem;"></i></span>
                        <input type="text" id="query" name="query" class="form-control" placeholder="Mercedes, Audi, SUV..." value="<c:out value='${requestScope.queryVal}'/>"/>
                    </div>
                </div>
 
                <div class="form-group" style="margin-bottom:0; flex: 1; min-width: 150px;">
                    <label for="typeId" class="form-label">Car Type</label>
                    <select id="typeId" name="typeId" class="form-control">
                        <option value="">All Types</option>
                        <c:forEach var="type" items="${requestScope.carTypes}">
                            <option value="${type.typeId}" ${type.typeId == requestScope.typeIdVal ? 'selected' : ''}>
                                <c:out value="${type.typeName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
 
                <div class="form-group" style="margin-bottom:0; width: 130px;">
                    <label for="minPrice" class="form-label">Min Price (VND)</label>
                    <input type="number" id="minPrice" name="minPrice" class="form-control" placeholder="Min" value="<c:out value='${requestScope.minPriceVal}'/>"/>
                </div>
 
                <div class="form-group" style="margin-bottom:0; width: 130px;">
                    <label for="maxPrice" class="form-label">Max Price (VND)</label>
                    <input type="number" id="maxPrice" name="maxPrice" class="form-control" placeholder="Max" value="<c:out value='${requestScope.maxPriceVal}'/>"/>
                </div>
            </div>
        </div>

        <!-- Fleet Grid -->
        <div class="section-header">
            <h2 class="section-title">Available <span>Cars</span></h2>
            <span class="text-muted text-sm">
                <c:choose>
                    <c:when test="${totalCars > 0}">${totalCars} cars found</c:when>
                    <c:otherwise>No cars found</c:otherwise>
                </c:choose>
            </span>
        </div>

        <c:choose>
            <c:when test="${not empty cars}">
                <div class="cars-grid">
                    <c:forEach var="car" items="${cars}">
                        <div class="car-card" data-type-id="${car.typeId}" data-price="${car.pricePerDay}" onclick="window.location.href='${pageContext.request.contextPath}/cars?action=detail&id=${car.carId}'">
                            <div class="car-card-image">
                                <c:choose>
                                    <c:when test="${not empty car.primaryImageUrl}">
                                        <img src="${pageContext.request.contextPath}${car.primaryImageUrl}" alt="${car.carName}" loading="lazy"/>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="car-card-placeholder"><i class="bi bi-car-front-fill" style="font-size:2rem; color:var(--color-gray-mid);"></i></div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="car-badge">
                                    <c:out value="${not empty car.typeName ? car.typeName : 'Car'}"/>
                                </span>
                            </div>
                            <div class="car-card-body">
                                <div class="car-card-name"><c:out value="${car.carName}"/></div>
                                <div class="car-card-brand"><c:out value="${car.brand}"/>   <c:out value="${car.model}"/></div>
                                <div class="car-card-footer">
                                    <div class="car-price">
                                        <span class="car-price-value">
                                            <fmt:formatNumber value="${car.pricePerDay}" type="number" groupingUsed="true"/> VND
                                        </span>
                                        <span class="car-price-label">/ day</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/cars?action=detail&id=${car.carId}" class="btn btn-outline-blue btn-sm">Details</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/cars?action=${param.action == 'search' ? 'search' : 'list'}&page=${currentPage - 1}&query=${queryVal}&typeId=${typeIdVal}&minPrice=${minPriceVal}&maxPrice=${maxPriceVal}" class="page-link">«</a>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <a href="${pageContext.request.contextPath}/cars?action=${param.action == 'search' ? 'search' : 'list'}&page=${p}&query=${queryVal}&typeId=${typeIdVal}&minPrice=${minPriceVal}&maxPrice=${maxPriceVal}" class="page-link ${p == currentPage ? 'active' : ''}">${p}</a>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/cars?action=${param.action == 'search' ? 'search' : 'list'}&page=${currentPage + 1}&query=${queryVal}&typeId=${typeIdVal}&minPrice=${minPriceVal}&maxPrice=${maxPriceVal}" class="page-link">»</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon"><i class="bi bi-car-front-fill"></i></div>
                    <div class="empty-state-title">No cars match your search criteria</div>
                    <p class="text-muted text-sm" style="margin-top: 0.5rem;">Try adjusting your query or filters.</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<!-- FOOTER -->
<footer class="site-footer">
    <div class="footer-inner">
        <div>
            <div class="footer-brand">Car<span>Rental</span></div>
            <p class="footer-desc">Premium car rental platform - connecting vehicle owners and customers safely and transparently.</p>
        </div>
        <div class="footer-col">
            <div class="footer-col-title">For Users</div>
            <a href="${pageContext.request.contextPath}/login/customer">Customers</a>
            <a href="${pageContext.request.contextPath}/login/owner">Owners</a>
            <a href="${pageContext.request.contextPath}/login/staff">Staff Portal</a>
        </div>
        <div class="footer-col">
            <div class="footer-col-title">Support</div>
            <a href="#">Terms of Use</a>
            <a href="#">Privacy Policy</a>
            <a href="#">Contact Us</a>
        </div>
    </div>
    <div class="footer-bottom">
        <span>© 2026 CarRental. All rights reserved.</span>
        <span>Made with <i class="bi bi-heart-fill" style="color:var(--color-red);"></i> in Vietnam</span>
    </div>
</footer>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const queryInput = document.getElementById('query');
        const typeSelect = document.getElementById('typeId');
        const minPriceInput = document.getElementById('minPrice');
        const maxPriceInput = document.getElementById('maxPrice');
        const carsGrid = document.querySelector('.cars-grid');
        const countSpan = document.querySelector('.section-header .text-muted');

        function filterCars() {
            const queryVal = queryInput.value.toLowerCase().trim();
            const typeVal = typeSelect.value;
            const minPriceVal = parseFloat(minPriceInput.value) || 0;
            const maxPriceVal = parseFloat(maxPriceInput.value) || Infinity;

            const cards = document.querySelectorAll('.car-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const cardName = card.querySelector('.car-card-name').textContent.toLowerCase();
                const cardBrand = card.querySelector('.car-card-brand').textContent.toLowerCase();
                const cardTypeId = card.getAttribute('data-type-id');
                const cardPrice = parseFloat(card.getAttribute('data-price')) || 0;

                const matchesQuery = cardName.includes(queryVal) || cardBrand.includes(queryVal);
                const matchesType = !typeVal || cardTypeId === typeVal;
                const matchesMinPrice = cardPrice >= minPriceVal;
                const matchesMaxPrice = cardPrice <= maxPriceVal;

                if (matchesQuery && matchesType && matchesMinPrice && matchesMaxPrice) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            // Update count label
            if (countSpan) {
                if (visibleCount > 0) {
                    countSpan.textContent = `${visibleCount} cars found`;
                } else {
                    countSpan.textContent = `No cars found`;
                }
            }

            // Toggle empty state
            let emptyState = document.getElementById('carsGridEmptyState');
            if (visibleCount === 0) {
                if (!emptyState) {
                    emptyState = document.createElement('div');
                    emptyState.id = 'carsGridEmptyState';
                    emptyState.className = 'empty-state';
                    emptyState.style.gridColumn = '1 / -1';
                    emptyState.style.textAlign = 'center';
                    emptyState.style.padding = '3rem';
                    emptyState.innerHTML = `
                        <div class="empty-state-icon" style="font-size:3rem; color:var(--orange);"><i class="bi bi-car-front-fill"></i></div>
                        <div class="empty-state-title" style="color:var(--color-white); font-size:1.25rem; margin-top:1rem; font-weight:700;">No cars match your filter criteria</div>
                        <p class="text-muted text-sm" style="margin-top:0.5rem;">Try adjusting your query or price range.</p>
                    `;
                    if (carsGrid) {
                        carsGrid.appendChild(emptyState);
                    }
                } else {
                    emptyState.style.display = 'block';
                }
            } else {
                if (emptyState) {
                    emptyState.style.display = 'none';
                }
            }
        }

        if (queryInput) queryInput.addEventListener('input', filterCars);
        if (typeSelect) typeSelect.addEventListener('change', filterCars);
        if (minPriceInput) minPriceInput.addEventListener('input', filterCars);
        if (maxPriceInput) maxPriceInput.addEventListener('input', filterCars);
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
