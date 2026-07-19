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
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
            </head>

            <body>

                <!-- ============================================================ NAVBAR -->
                <nav class="navbar" id="mainNavbar">
                    <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
                        <i class="bi bi-car-front-fill" style="color:var(--orange);"></i>
                        Car<span>Rental</span>
                    </a>

                    <ul class="navbar-nav">
                        <li><a href="${pageContext.request.contextPath}/home" class="nav-link active">Home</a></li>
                        <li><a href="#cars-section" class="nav-link">Our Fleet</a></li>

                        <li class="navbar-divider"></li>

                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <li>
                                    <a href="${pageContext.request.contextPath}/profile" class="nav-link"
                                        style="color: var(--color-blue-light);">
                                        <i class="bi bi-person-fill"></i> ${sessionScope.user.email}
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">
                                        Logout
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/login/customer"
                                        class="btn btn-outline-blue btn-sm">Login</a></li>
                                <li><a href="${pageContext.request.contextPath}/register/customer"
                                        class="btn btn-blue btn-sm">Register</a></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>

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
                        <div class="hero-actions">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <a href="#cars-section" class="btn btn-blue btn-lg">Explore Cars</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/register/customer"
                                        class="btn btn-blue btn-lg">Get Started</a>
                                    <a href="${pageContext.request.contextPath}/login/customer"
                                        class="btn btn-outline-blue btn-lg">Login</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>

                    <!-- ============================================================ CARS -->
                    <section class="cars-section" id="cars-section">
                        <div class="section-header">
                            <div>
                                <h2 class="section-title">Available <span>Fleet</span></h2>
                                <div class="blue-line"></div>
                            </div>
                            <span class="text-muted text-sm">
                                <c:choose>
                                    <c:when test="${not empty cars}">${cars.size()} cars available</c:when>
                                    <c:otherwise>No cars available</c:otherwise>
                                </c:choose>
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
                                                        <img src="${car.primaryImageUrl}" alt="${car.carName}"
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
                                                <div class="car-card-footer">
                                                    <div class="car-price">
                                                        <span class="car-price-value">
                                                            <fmt:formatNumber value="${car.pricePerDay}" type="number"
                                                                groupingUsed="true" /> VND
                                                        </span>
                                                        <span class="car-price-label">/ day</span>
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.user}">
                                                            <a href="#" class="btn btn-blue btn-sm">Book Now</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/login/customer"
                                                                class="btn btn-outline-blue btn-sm">Login</a>
                                                        </c:otherwise>
                                                    </c:choose>
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

                <!-- ============================================================ FOOTER -->
                <footer class="site-footer">
                    <div class="footer-inner">
                        <div>
                            <div class="footer-brand">Car<span>Rental</span></div>
                            <p class="footer-desc">Vietnam's leading premium car rental platform - connecting owners and
                                customers safely and transparently.</p>
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
                        <span>Made with ❤️ in Vietnam</span>
                    </div>
                </footer>

                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </body>

            </html>