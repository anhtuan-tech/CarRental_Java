<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <meta name="description"
                    content="CarRental - Nền tảng thuê xe cao cấp hàng đầu Việt Nam. Khám phá hàng trăm mẫu xe sang trọng." />
                <title>CarRental - Thuê Xe Cao Cấp</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
            </head>

            <body>
                <jsp:include page="/WEB-INF/views/common/header.jsp" />
                <div class="page-wrapper">

                    <!-- ============================================================ HERO -->
                    <section class="hero-section">
                        <div class="hero-eyebrow"><i class="bi bi-star-fill"></i> Premium Car Rental Platform #1 in Vietnam</div>
                        <h1 class="hero-title">
                            Experience Excellence<br />
                            On Every <span>Road</span>
                        </h1>
                        <p class="hero-subtitle">
                            Hundreds of luxury models, simple booking procedure, and completely transparent pricing.
                            Rent today and enjoy the ultimate driving journey.
                        </p>
                        <c:if test="${not empty sessionScope.user}">
                            <div class="hero-actions">
                                <a href="${pageContext.request.contextPath}/cars" class="btn btn-blue btn-lg">Explore Cars</a>
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
                                Our top rented vehicles
                            </span>
                        </div>

                        <c:choose>
                            <c:when test="${not empty cars}">
                                <div class="cars-grid">
                                    <c:forEach var="car" items="${cars}">
                                        <div class="car-card">
                                            <div class="car-card-image">
                                                <c:choose>
                                                    <c:when test="${not empty car.primaryImageUrl}">
                                                        <img src="${pageContext.request.contextPath}${car.primaryImageUrl}" alt="${car.carName}"
                                                            loading="lazy" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="car-card-placeholder"><i class="bi bi-car-front"></i></div>
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
                                                <div class="car-card-footer" style="display:flex; flex-direction:column; gap:0.5rem; width:100%;">
                                                    <div style="display:flex; justify-content:space-between; align-items:center; width:100%;">
                                                        <div class="car-price">
                                                            <span class="car-price-value">
                                                                <fmt:formatNumber value="${car.pricePerDay}" type="number"
                                                                    groupingUsed="true" /> VND
                                                            </span>
                                                            <span class="car-price-label">/ day</span>
                                                        </div>
                                                        <a href="${pageContext.request.contextPath}/cars?action=detail&id=${car.carId}" class="btn btn-outline-blue btn-sm">Details</a>
                                                    </div>
                                                    <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 3}">
                                                        <a href="${pageContext.request.contextPath}/customer/booking?carId=${car.carId}" class="btn btn-blue btn-sm" style="width:100%; text-align:center;">Book Now</a>
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