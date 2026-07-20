<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <meta name="description"
                    content="CarRental — Discover hundreds of premium vehicles with seamless booking and transparent pricing." />
                <title>Car Rental — Elevate Your Driving Experience</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.2" />
            </head>

            <body>
                <jsp:include page="/WEB-INF/views/common/header.jsp" />
                <div class="page-wrapper">

                    <!-- ============================================================ HERO -->
                    <section class="hero-section">
                        <p class="hero-eyebrow" style="visibility: hidden;">&#9733; Premium Car Rental</p>
                        <h1 class="hero-title">
                            Elevate Your Driving <span>Experience</span>
                        </h1>
                        <p class="hero-subtitle">
                            Choose from hundreds of premium models with a seamless booking experience and transparent
                            pricing. Your next adventure starts here.
                        </p>
                        <c:if test="${not empty sessionScope.user}">
                            <div class="hero-actions">
                                <a href="${pageContext.request.contextPath}/cars" class="btn btn-blue btn-lg">Browse Our
                                    Fleet</a>
                            </div>
                        </c:if>
                    </section>

                    <!-- ============================================================ CARS -->
                    <section class="cars-section" id="cars-section">
                        <div class="section-header">
                            <div>
                                <h2 class="section-title">Most Popular <span>Cars</span></h2>
                                <div class="blue-line"></div>
                            </div>
                            <span class="text-muted text-sm">
                                Top picks for your perfect journey.
                            </span>
                        </div>

                        <c:choose>
                            <c:when test="${not empty cars}">
                                <div class="cars-grid">
                                    <c:forEach var="car" items="${cars}">
                                        <div class="car-card"
                                            onclick="window.location.href = '${pageContext.request.contextPath}/cars?action=detail&id=${car.carId}'">
                                            <div class="car-card-image">
                                                <c:choose>
                                                    <c:when test="${not empty car.primaryImageUrl}">
                                                        <img src="${pageContext.request.contextPath}${car.primaryImageUrl}"
                                                            alt="${car.carName}" loading="lazy" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="car-card-placeholder"><i
                                                                class="bi bi-car-front"></i></div>
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
                                                <div class="car-card-specs">
                                                    <c:choose>
                                                        <c:when test="${not empty car.brand && not empty car.model}">
                                                            <c:out value="${car.brand}" /> &bull;
                                                            <c:out value="${car.model}" />
                                                        </c:when>
                                                        <c:when test="${not empty car.brand}">
                                                            <c:out value="${car.brand}" />
                                                        </c:when>
                                                        <c:when test="${not empty car.model}">
                                                            <c:out value="${car.model}" />
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                                <div class="car-card-footer"
                                                    style="display:flex; flex-direction:column; gap:0.5rem; width:100%;">
                                                    <div
                                                        style="display:flex; justify-content:space-between; align-items:center; width:100%;">
                                                        <div class="car-price">
                                                            <span class="car-price-value">
                                                                <fmt:formatNumber value="${car.pricePerDay}"
                                                                    type="number" groupingUsed="true" /> VND
                                                            </span>
                                                            <span class="car-price-label">/ day</span>
                                                        </div>
                                                    </div>
                                                    <c:if
                                                        test="${sessionScope.user != null && sessionScope.user.roleId == 3}">
                                                        <a href="${pageContext.request.contextPath}/cars?action=detail&id=${car.carId}"
                                                            class="btn btn-blue btn-sm"
                                                            style="width:100%; text-align:center;"
                                                            onclick="event.stopPropagation()">Book Now</a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-state-icon"><i class="bi bi-car-front-fill"></i></div>
                                    <div class="empty-state-title">No cars available right now</div>
                                    <p class="text-muted text-sm" style="margin-top: 0.5rem;">Please check back later.
                                    </p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                </div>

                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </body>

            </html>