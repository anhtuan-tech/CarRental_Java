<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Earning Analytics — CarRental Owner</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
    <style>
        .admin-container {
            max-width: 100%;
            margin: 0 auto;
            padding: 0 var(--space-4);
        }

        .stats-hero {
            background: var(--color-dark-card);
            border: 1px solid var(--color-dark-border);
            border-radius: var(--radius-xl);
            padding: var(--space-8);
            text-align: center;
            margin-bottom: var(--space-8);
            position: relative;
            overflow: hidden;
        }

        .stats-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--color-blue), var(--color-blue-light));
        }

        .stats-val {
            font-size: 2.75rem;
            font-weight: 800;
            color: var(--color-white);
            margin-top: var(--space-2);
            text-shadow: 0 0 20px rgba(59, 130, 246, 0.2);
        }

        .timeline-wrapper {
            background: var(--color-dark-card);
            border: 1px solid var(--color-dark-border);
            border-radius: var(--radius-xl);
            padding: var(--space-8);
        }

        .timeline-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--color-white);
            margin-bottom: var(--space-6);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .timeline-item {
            display: flex;
            gap: var(--space-4);
            padding-bottom: var(--space-6);
            margin-bottom: var(--space-6);
            border-bottom: 1px solid var(--color-dark-border);
        }

        .timeline-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .timeline-badge {
            width: 42px;
            height: 42px;
            border-radius: var(--radius-full);
            background: rgba(59, 130, 246, 0.1);
            color: var(--color-blue-light);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
            border: 1px solid rgba(59, 130, 246, 0.2);
            flex-shrink: 0;
        }

        .status-pill {
            display: inline-block;
            font-size: 0.72rem;
            font-weight: 600;
            padding: var(--space-0-5) var(--space-2);
            border-radius: var(--radius-full);
            text-transform: uppercase;
        }

        .status-pill.completed {
            background: rgba(16, 185, 129, 0.1);
            color: #10B981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .status-pill.mutated {
            background: rgba(59, 130, 246, 0.1);
            color: var(--color-blue-light);
            border: 1px solid rgba(59, 130, 246, 0.2);
        }
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <div class="mgmt-wrapper">
        <!-- Sidebar -->
        <aside class="mgmt-sidebar">
            <div class="mgmt-sidebar-header">
                <div class="mgmt-sidebar-title"><i class="bi bi-key-fill"></i> Owner Hub</div>
                <div class="mgmt-sidebar-subtitle">Fleet Management</div>
            </div>
            <ul class="mgmt-menu">
                <div class="mgmt-menu-section-title">Overview</div>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/owner/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                <div class="mgmt-menu-section-title">My Fleet</div>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/owner/cars"><i class="bi bi-car-front-fill"></i> My Vehicles</a></li>
                <div class="mgmt-menu-section-title">Business</div>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/owner/orders"><i class="bi bi-receipt-cutoff"></i> Rental Orders</a></li>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/owner/feedbacks"><i class="bi bi-star-fill"></i> Customer Reviews</a></li>
                <li class="mgmt-menu-item active"><a href="${pageContext.request.contextPath}/owner/earning"><i class="bi bi-wallet2"></i> Earnings &amp; Payouts</a></li>
            </ul>
            <div class="mgmt-sidebar-footer">
                <div class="mgmt-user-info"><i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.email}"/></div>
                <a href="${pageContext.request.contextPath}/logout" style="display:block; margin-top:0.5rem; font-size:0.8rem; color:#EF4444; text-decoration:none;"><i class="bi bi-box-arrow-right"></i> Logout</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="mgmt-content">
            <div class="admin-container">

                <div class="mb-6">
                    <h1 class="hero-title" style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                        Earnings &amp; <span>Payouts</span>
                    </h1>
                    <p class="text-muted text-sm">Analyze revenue, track completed trips, and manage balance payout logs.</p>
                </div>
                <div class="blue-line" style="margin-bottom: 2rem;"></div>

                <!-- Earnings Hero Card -->
                <div class="stats-hero">
                    <span class="text-xs text-muted" style="text-transform:uppercase; font-weight:700; letter-spacing:1px;">Total Net Revenue (Completed trips)</span>
                    <div class="stats-val">
                        <fmt:formatNumber value="${totalEarnings}" type="number" groupingUsed="true" /> ₫
                    </div>
                </div>

                <!-- Audit Timeline History -->
                <div class="timeline-wrapper">
                    <div class="timeline-title">
                        <i class="bi bi-clock-history" style="color:var(--color-blue-light);"></i>
                        Trip Activity &amp; Payout Log
                    </div>

                    <c:choose>
                        <c:when test="${not empty bookingHistory}">
                            <c:forEach var="log" items="${bookingHistory}">
                                <div class="timeline-item">
                                    <div class="timeline-badge">
                                        #${log.bookingId}
                                    </div>
                                    <div style="flex-grow: 1;">
                                        <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom: 0.25rem;">
                                            <div style="font-weight: 700; color: var(--color-white); font-size: 0.95rem;">
                                                Status update
                                            </div>
                                            <span class="text-xs text-muted">
                                                <c:out value="${log.changedAt}"/>
                                            </span>
                                        </div>
                                        <p class="text-sm text-muted" style="margin-bottom: 0.5rem;"><c:out value="${log.note}"/></p>
                                        <div style="display: flex; gap: var(--space-2); align-items: center;">
                                            <span class="status-pill mutated"><c:out value="${log.oldStatus}"/></span>
                                            <span style="color:var(--color-gray-light); font-size:0.8rem;">➔</span>
                                            <span class="status-pill completed"><c:out value="${log.newStatus}"/></span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state" style="padding:var(--space-8) 0; border:none; background:none;">
                                <div class="empty-state-icon"><i class="bi bi-clock-history"></i></div>
                                <div class="empty-state-title" style="font-size:1.05rem;">No logs recorded yet</div>
                                <p class="text-muted text-sm" style="margin-top:0.25rem;">Activity log details will appear here as rentals complete.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>
    </div>
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>

</html>
