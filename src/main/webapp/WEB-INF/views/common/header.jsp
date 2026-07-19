<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar">
    <c:choose>

        <%-- ADMIN --%>
        <c:when test="${sessionScope.user != null && sessionScope.user.roleId == 1}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">
                <i class="bi bi-shield-fill" style="color:var(--orange);"></i> Admin<span>Portal</span>
            </a>
            <ul class="navbar-nav">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff" class="nav-link"><i class="bi bi-people-fill"></i> Manage Staff</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users" class="nav-link"><i class="bi bi-person-lines-fill"></i> Manage Users</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/revenue" class="nav-link"><i class="bi bi-bar-chart-line-fill"></i> Revenue</a></li>
                <li class="navbar-divider"></li>
                <li><span class="nav-link" style="color:var(--text-muted); cursor:default; font-size:0.8rem;">
                    <i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.email}"/>
                </span></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
            </ul>
        </c:when>

        <%-- STAFF --%>
        <c:when test="${sessionScope.user != null && sessionScope.user.roleId == 2}">
            <a href="${pageContext.request.contextPath}/staff/dashboard" class="navbar-brand">
                <i class="bi bi-clipboard2-check-fill" style="color:var(--orange);"></i> Staff<span>Desk</span>
            </a>
            <ul class="navbar-nav">
                <li><a href="${pageContext.request.contextPath}/staff/dashboard" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/bookings" class="nav-link"><i class="bi bi-calendar2-check-fill"></i> Manage Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/cars" class="nav-link"><i class="bi bi-car-front-fill"></i> Manage Cars</a></li>
                <li class="navbar-divider"></li>
                <li><span class="nav-link" style="color:var(--text-muted); cursor:default; font-size:0.8rem;">
                    <i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.email}"/>
                </span></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
            </ul>
        </c:when>

        <%-- OWNER --%>
        <c:when test="${sessionScope.user != null && sessionScope.user.roleId == 4}">
            <a href="${pageContext.request.contextPath}/owner/dashboard" class="navbar-brand">
                <i class="bi bi-key-fill" style="color:var(--orange);"></i> Owner<span>Hub</span>
            </a>
            <ul class="navbar-nav">
                <li><a href="${pageContext.request.contextPath}/owner/dashboard" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/owner/cars" class="nav-link"><i class="bi bi-car-front-fill"></i> My Fleet</a></li>
                <li><a href="${pageContext.request.contextPath}/owner/orders" class="nav-link"><i class="bi bi-receipt-cutoff"></i> Rental Orders</a></li>
                <li><a href="${pageContext.request.contextPath}/owner/earning" class="nav-link"><i class="bi bi-wallet2"></i> Earnings</a></li>
                <li class="navbar-divider"></li>
                <li><a href="${pageContext.request.contextPath}/profile" class="nav-link" style="color:var(--text-muted);">
                    <i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.fullName != null ? sessionScope.user.fullName : sessionScope.user.email}"/>
                </a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
            </ul>
        </c:when>

        <%-- CUSTOMER & GUEST --%>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
                <i class="bi bi-car-front-fill" style="color:var(--orange);"></i> Car<span>Rental</span>
            </a>
            <ul class="navbar-nav">
                <li><a href="${pageContext.request.contextPath}/home" class="nav-link"><i class="bi bi-house-fill"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/cars" class="nav-link"><i class="bi bi-car-front-fill"></i> Browse Cars</a></li>
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <li><a href="${pageContext.request.contextPath}/customer/bookings" class="nav-link"><i class="bi bi-calendar2-check"></i> My Bookings</a></li>
                        <li><a href="${pageContext.request.contextPath}/feedbacks" class="nav-link"><i class="bi bi-star-fill"></i> My Reviews</a></li>
                        <li class="navbar-divider"></li>
                        <li><a href="${pageContext.request.contextPath}/profile" class="nav-link" style="color:var(--text-muted);">
                            <i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.fullName != null ? sessionScope.user.fullName : sessionScope.user.email}"/>
                        </a></li>
                        <li><a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="navbar-divider"></li>
                        <li><a href="${pageContext.request.contextPath}/login/customer" class="nav-link"><i class="bi bi-person-fill"></i> Login</a></li>
                        <li><a href="${pageContext.request.contextPath}/register/customer" class="btn btn-primary btn-sm">Get Started</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </c:otherwise>

    </c:choose>
</nav>