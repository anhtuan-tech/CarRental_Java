<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<nav class="navbar">
    <c:choose>

        <%-- ADMIN (Role 1) --%>
        <c:when test="${sessionScope.user != null && sessionScope.user.roleId == 1}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">
                <i class="bi bi-car-front-fill" style="color:var(--orange);"></i>
                Car<span>Rental</span>
            </a>
            <ul class="navbar-nav">

                <%-- User Dropdown --%>
                <li class="nav-user-dropdown">
                    <button class="nav-user-trigger" id="navUserBtn"
                            onclick="toggleUserDropdown(event)" aria-expanded="false">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.avatarUrl}">
                                <img src="${fn:startsWith(sessionScope.user.avatarUrl, 'http') ? sessionScope.user.avatarUrl : pageContext.request.contextPath.concat(sessionScope.user.avatarUrl)}"
                                     class="nav-avatar" alt="Avatar" />
                            </c:when>
                            <c:otherwise>
                                <span class="nav-avatar-placeholder"><i
                                        class="bi bi-person-fill"></i></span>
                                </c:otherwise>
                            </c:choose>
                        <span class="nav-username">
                            <c:out
                                value="${not empty sessionScope.user.fullName ? sessionScope.user.fullName : sessionScope.user.email}" />
                        </span>
                        <i class="bi bi-chevron-down nav-chevron"></i>
                    </button>
                    <div class="nav-dropdown-menu" id="navDropdownMenu">
                        <a href="${pageContext.request.contextPath}/profile"
                           class="nav-dropdown-item"><i class="bi bi-person-circle"></i> My
                            Profile</a>
                        <div class="nav-dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/logout"
                           class="nav-dropdown-item nav-dropdown-item--danger"><i
                                class="bi bi-box-arrow-right"></i> Logout</a>
                    </div>
                </li>
            </ul>
        </c:when>

        <%-- STAFF (Role 2) --%>
        <c:when test="${sessionScope.user != null && sessionScope.user.roleId == 2}">
            <a href="${pageContext.request.contextPath}/staff/dashboard" class="navbar-brand">
                <i class="bi bi-car-front-fill" style="color:var(--orange);"></i>
                Car<span>Rental</span>
            </a>
            <ul class="navbar-nav">

                <%-- User Dropdown --%>
                <li class="nav-user-dropdown">
                    <button class="nav-user-trigger" id="navUserBtn"
                            onclick="toggleUserDropdown(event)" aria-expanded="false">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.avatarUrl}">
                                <img src="${fn:startsWith(sessionScope.user.avatarUrl, 'http') ? sessionScope.user.avatarUrl : pageContext.request.contextPath.concat(sessionScope.user.avatarUrl)}"
                                     class="nav-avatar" alt="Avatar" />
                            </c:when>
                            <c:otherwise>
                                <span class="nav-avatar-placeholder"><i
                                        class="bi bi-person-fill"></i></span>
                                </c:otherwise>
                            </c:choose>
                        <span class="nav-username">
                            <c:out
                                value="${not empty sessionScope.user.fullName ? sessionScope.user.fullName : sessionScope.user.email}" />
                        </span>
                        <i class="bi bi-chevron-down nav-chevron"></i>
                    </button>
                    <div class="nav-dropdown-menu" id="navDropdownMenu">
                        <a href="${pageContext.request.contextPath}/profile"
                           class="nav-dropdown-item"><i class="bi bi-person-circle"></i> My
                            Profile</a>
                        <div class="nav-dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/logout"
                           class="nav-dropdown-item nav-dropdown-item--danger"><i
                                class="bi bi-box-arrow-right"></i> Logout</a>
                    </div>
                </li>
            </ul>
        </c:when>

        <%-- OWNER (Role 4) --%>
        <c:when test="${sessionScope.user != null && sessionScope.user.roleId == 4}">
            <a href="${pageContext.request.contextPath}/owner/dashboard" class="navbar-brand">
                <i class="bi bi-car-front-fill" style="color:var(--orange);"></i>
                Car<span>Rental</span>
            </a>
            <ul class="navbar-nav">

                <%-- User Dropdown --%>
                <li class="nav-user-dropdown">
                    <button class="nav-user-trigger" id="navUserBtn"
                            onclick="toggleUserDropdown(event)" aria-expanded="false">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.avatarUrl}">
                                <img src="${fn:startsWith(sessionScope.user.avatarUrl, 'http') ? sessionScope.user.avatarUrl : pageContext.request.contextPath.concat(sessionScope.user.avatarUrl)}"
                                     class="nav-avatar" alt="Avatar" />
                            </c:when>
                            <c:otherwise>
                                <span class="nav-avatar-placeholder"><i
                                        class="bi bi-person-fill"></i></span>
                                </c:otherwise>
                            </c:choose>
                        <span class="nav-username">
                            <c:out
                                value="${not empty sessionScope.user.fullName ? sessionScope.user.fullName : sessionScope.user.email}" />
                        </span>
                        <i class="bi bi-chevron-down nav-chevron"></i>
                    </button>
                    <div class="nav-dropdown-menu" id="navDropdownMenu">
                        <a href="${pageContext.request.contextPath}/profile"
                           class="nav-dropdown-item"><i class="bi bi-person-circle"></i> My
                            Profile</a>
                        <div class="nav-dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/logout"
                           class="nav-dropdown-item nav-dropdown-item--danger"><i
                                class="bi bi-box-arrow-right"></i> Logout</a>
                    </div>
                </li>
            </ul>
        </c:when>

        <%-- CUSTOMER (Role 3) & GUEST --%>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
                <i class="bi bi-car-front-fill" style="color:var(--orange);"></i>
                Car<span>Rental</span>
            </a>
            <ul class="navbar-nav navbar-nav--centered">
                <li><a href="${pageContext.request.contextPath}/home" class="nav-link"
                       data-navkey="home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/cars" class="nav-link"
                       data-navkey="cars">Explore Cars</a></li>
            </ul>
            <ul class="navbar-nav navbar-nav--right">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <%-- Logged-in customer: avatar + dropdown --%>
                        <li class="nav-user-dropdown">
                            <button class="nav-user-trigger" id="navUserBtn"
                                    onclick="toggleUserDropdown(event)"
                                    aria-expanded="false">
                                <c:choose>
                                    <c:when
                                        test="${not empty sessionScope.user.avatarUrl}">
                                        <img src="${fn:startsWith(sessionScope.user.avatarUrl, 'http') ? sessionScope.user.avatarUrl : pageContext.request.contextPath.concat(sessionScope.user.avatarUrl)}"
                                             class="nav-avatar" alt="Avatar" />
                                    </c:when>
                                    <c:otherwise>
                                        <span class="nav-avatar-placeholder"><i
                                                class="bi bi-person-fill"></i></span>
                                        </c:otherwise>
                                    </c:choose>
                                <span class="nav-username">
                                    <c:out
                                        value="${not empty sessionScope.user.fullName ? sessionScope.user.fullName : sessionScope.user.email}" />
                                </span>
                                <i class="bi bi-chevron-down nav-chevron"></i>
                            </button>
                            <div class="nav-dropdown-menu" id="navDropdownMenu">
                                <a href="${pageContext.request.contextPath}/profile"
                                   class="nav-dropdown-item"><i
                                        class="bi bi-person-circle"></i> My Profile</a>
                                <a href="${pageContext.request.contextPath}/customer/bookings"
                                   class="nav-dropdown-item"><i
                                        class="bi bi-calendar2-check"></i> My
                                    Bookings</a>
                                <a href="${pageContext.request.contextPath}/feedback"
                                   class="nav-dropdown-item"><i class="bi bi-star"></i>
                                    My Feedback</a>
                                <div class="nav-dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/logout"
                                   class="nav-dropdown-item nav-dropdown-item--danger"><i
                                        class="bi bi-box-arrow-right"></i> Logout</a>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <%-- Guest: login + register --%>
                        <li><a href="${pageContext.request.contextPath}/login/customer"
                               class="nav-link">Login</a></li>
                        <li><a href="${pageContext.request.contextPath}/register/customer"
                               class="btn btn-primary btn-sm">Register</a></li>
                        </c:otherwise>
                    </c:choose>
            </ul>
        </c:otherwise>

    </c:choose>
</nav>

<script>
    // ── Active nav link: match by browser URL path ────────────────────────
    (function () {
        var path = window.location.pathname;
        document.querySelectorAll('[data-navkey]').forEach(function (link) {
            var key = link.getAttribute('data-navkey');
            if (key && path.indexOf('/' + key) !== -1) {
                link.classList.add('active');
            }
        });
    })();

    // ── User dropdown ─────────────────────────────────────────────────────
    function toggleUserDropdown(e) {
        e.stopPropagation();
        const btn = document.getElementById('navUserBtn');
        const menu = document.getElementById('navDropdownMenu');
        if (!btn || !menu)
            return;
        const isOpen = menu.classList.contains('open');
        menu.classList.toggle('open', !isOpen);
        btn.setAttribute('aria-expanded', String(!isOpen));
    }

    document.addEventListener('click', function () {
        const menu = document.getElementById('navDropdownMenu');
        const btn = document.getElementById('navUserBtn');
        if (menu)
            menu.classList.remove('open');
        if (btn)
            btn.setAttribute('aria-expanded', 'false');
    });
</script>