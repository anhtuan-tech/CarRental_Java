<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Earning Analytic — Car Rental Owner</title>
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
                    <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>

                <body>
                    <jsp:include page="/WEB-INF/views/common/header.jsp" />
                    <div class="mgmt-wrapper">
                        <jsp:include page="/WEB-INF/views/owner/ownerSidebar.jsp" />

                        <!-- Main Content -->
                        <main class="mgmt-content">
                            <div class="admin-container">

                                <div class="mb-6">
                                    <h1 class="hero-title"
                                        style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                                        Earnings &amp; <span>Payouts</span>
                                    </h1>
                                    <p class="text-muted text-sm">Analyze revenue, track completed trips, and manage
                                        balance payout logs.</p>
                                </div>
                                <div class="blue-line" style="margin-bottom: 2rem;"></div>

                                <!-- Earnings Hero Card -->
                                <div class="stats-hero">
                                    <span class="text-xs text-muted"
                                        style="text-transform:uppercase; font-weight:700; letter-spacing:1px;">Total Net
                                        Revenue (Completed trips)</span>
                                    <div class="stats-val">
                                        <fmt:formatNumber value="${totalEarnings}" type="number" groupingUsed="true" />
                                        ₫
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
                                                        <div
                                                            style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom: 0.25rem;">
                                                            <div
                                                                style="font-weight: 700; color: var(--color-white); font-size: 0.95rem;">
                                                                Status update
                                                            </div>
                                                            <span class="text-xs text-muted">
                                                                <c:out value="${log.changedAt}" />
                                                            </span>
                                                        </div>
                                                        <p class="text-sm text-muted" style="margin-bottom: 0.5rem;">
                                                            <c:out value="${log.note}" />
                                                        </p>
                                                        <div
                                                            style="display: flex; gap: var(--space-2); align-items: center;">
                                                            <span class="status-pill mutated">
                                                                <c:out value="${log.oldStatus}" />
                                                            </span>
                                                            <span
                                                                style="color:var(--color-gray-light); font-size:0.8rem;">➔</span>
                                                            <span class="status-pill completed">
                                                                <c:out value="${log.newStatus}" />
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>

                                            <!-- Pagination Controls -->
                                            <c:if test="${totalPages > 0}">
                                                <div class="pagination-wrapper"
                                                    style="display:flex; justify-content:space-between; align-items:center; margin-top:2rem;">
                                                    <div class="page-size-selector">
                                                        <form action="${pageContext.request.contextPath}/owner/earnings"
                                                            method="get"
                                                            style="margin:0; display:flex; align-items:center; gap:0.5rem;">
                                                            <span class="text-sm text-muted">Show:</span>
                                                            <select name="size" class="form-control"
                                                                style="width:70px; height:32px; padding:0 0.5rem; background:var(--color-dark-card); border-color:var(--color-dark-border); color:var(--color-white);"
                                                                onchange="this.form.submit()">
                                                                <option value="5" ${pageSize==5 ? 'selected' : '' }>5
                                                                </option>
                                                                <option value="10" ${pageSize==10 ? 'selected' : '' }>10
                                                                </option>
                                                                <option value="15" ${pageSize==15 ? 'selected' : '' }>15
                                                                </option>
                                                                <option value="30" ${pageSize==30 ? 'selected' : '' }>30
                                                                </option>
                                                                <option value="50" ${pageSize==50 ? 'selected' : '' }>50
                                                                </option>
                                                            </select>
                                                            <span class="text-sm text-muted">entries</span>
                                                        </form>
                                                    </div>
                                                    <div class="pagination-links" style="display:flex; gap:0.25rem;">
                                                        <c:set var="prevPage"
                                                            value="${currentPage - 1 > 0 ? currentPage - 1 : 1}" />
                                                        <a href="?size=${pageSize}&page=${prevPage}"
                                                            class="btn btn-sm ${currentPage == 1 ? 'disabled' : ''}"
                                                            style="border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);">&laquo;
                                                            Prev</a>

                                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                                            <a href="?size=${pageSize}&page=${p}" class="btn btn-sm"
                                                                style="${p == currentPage ? 'background:var(--orange); color:white; border-color:var(--orange);' : 'border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);'}">${p}</a>
                                                        </c:forEach>

                                                        <c:set var="nextPage"
                                                            value="${currentPage + 1 <= totalPages ? currentPage + 1 : totalPages}" />
                                                        <a href="?size=${pageSize}&page=${nextPage}"
                                                            class="btn btn-sm ${currentPage == totalPages ? 'disabled' : ''}"
                                                            style="border:1px solid var(--color-dark-border); background:var(--color-dark-card); color:var(--color-white);">Next
                                                            &raquo;</a>
                                                    </div>
                                                </div>
                                            </c:if>

                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-state"
                                                style="padding:var(--space-8) 0; border:none; background:none;">
                                                <div class="empty-state-icon"><i class="bi bi-clock-history"></i></div>
                                                <div class="empty-state-title" style="font-size:1.05rem;">No logs
                                                    recorded yet</div>
                                                <p class="text-muted text-sm" style="margin-top:0.25rem;">Activity log
                                                    details will appear here as rentals complete.</p>
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