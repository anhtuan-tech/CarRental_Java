<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Dashboard — Car Owner Portal</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.5" />
                    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
                    <style>
                        /* ── Dashboard-specific overrides ───────────────────── */
                        .admin-container {
                            max-width: 100%;
                            margin: 0 auto;
                            padding: 0 var(--space-4);
                        }

                        .db-welcome {
                            background: var(--white);
                            border: 1px solid var(--border);
                            border-radius: var(--r-xl);
                            padding: var(--sp-6) var(--sp-8);
                            margin-bottom: var(--sp-6);
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            gap: var(--sp-4);
                            box-shadow: var(--shadow-xs);
                        }

                        .db-welcome-text h2 {
                            font-size: var(--text-xl);
                            color: var(--text-primary);
                            margin-bottom: 0.25rem;
                        }

                        .db-welcome-text p {
                            font-size: var(--text-sm);
                            color: var(--text-muted);
                        }

                        .db-welcome-text strong {
                            color: var(--orange);
                        }

                        /* Stats row */
                        .db-stats {
                            display: grid;
                            grid-template-columns: repeat(2, 1fr);
                            gap: var(--sp-5);
                            margin-bottom: var(--sp-6);
                        }

                        .stat-card-sub {
                            font-size: var(--text-xs);
                            color: var(--text-muted);
                            margin-top: var(--sp-1);
                        }

                        .stat-card-sub span {
                            color: var(--orange);
                            font-weight: 600;
                        }

                        .stat-value-highlight {
                            font-size: var(--text-3xl);
                            font-weight: 800;
                            color: var(--orange);
                            font-family: var(--font-display);
                        }

                        /* Split layout (Now single column for chart) */
                        .db-split {
                            display: block;
                            margin-top: var(--sp-5);
                        }

                        /* Chart area */
                        .chart-container {
                            position: relative;
                            height: 300px;
                        }

                        /* Orders table compact */
                        .orders-list {
                            display: flex;
                            flex-direction: column;
                            gap: var(--sp-3);
                        }

                        .order-row {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            gap: var(--sp-3);
                            padding: var(--sp-3) var(--sp-4);
                            background: var(--bg);
                            border: 1px solid var(--border);
                            border-radius: var(--r-lg);
                            transition: var(--t-fast);
                        }

                        .order-row:hover {
                            border-color: var(--orange-border);
                        }

                        .order-car-name {
                            font-weight: 700;
                            font-size: var(--text-sm);
                            color: var(--text-primary);
                        }

                        .order-meta {
                            font-size: var(--text-xs);
                            color: var(--text-muted);
                            margin-top: 1px;
                        }

                        .order-price {
                            font-size: var(--text-sm);
                            font-weight: 700;
                            color: var(--orange);
                            white-space: nowrap;
                        }

                        .order-actions {
                            display: flex;
                            gap: var(--sp-2);
                            flex-shrink: 0;
                        }

                        /* Action Icon Buttons */
                        .btn-icon {
                            width: 34px;
                            height: 34px;
                            padding: 0;
                            border-radius: var(--r-md);
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 1rem;
                            border: none;
                            cursor: pointer;
                            transition: var(--t-fast);
                        }

                        .btn-success-soft {
                            background: var(--success-bg);
                            color: var(--success);
                        }

                        .btn-success-soft:hover {
                            background: var(--success);
                            color: var(--white);
                            transform: translateY(-1px);
                        }

                        .btn-danger-soft {
                            background: var(--error-bg);
                            color: var(--error);
                        }

                        .btn-danger-soft:hover {
                            background: var(--error);
                            color: var(--white);
                            transform: translateY(-1px);
                        }

                        /* Empty state */
                        .db-empty {
                            text-align: center;
                            padding: var(--sp-8) var(--sp-4);
                            color: var(--text-muted);
                            font-size: var(--text-sm);
                        }

                        .db-empty i {
                            font-size: 2rem;
                            color: var(--text-faint);
                            display: block;
                            margin-bottom: var(--sp-2);
                        }

                        @media (max-width: 1024px) {
                            .db-stats {
                                grid-template-columns: 1fr 1fr;
                            }

                            .db-split {
                                grid-template-columns: 1fr;
                            }
                        }

                        @media (max-width: 640px) {
                            .db-stats {
                                grid-template-columns: 1fr;
                            }

                            .db-welcome {
                                flex-direction: column;
                                align-items: flex-start;
                            }
                        }
                    </style>
                </head>

                <body>
                    <% if (session.getAttribute("user")==null) { response.sendRedirect(request.getContextPath()
                        + "/login/owner" ); return; } %>
                        <jsp:include page="/WEB-INF/views/common/header.jsp" />

                        <div class="mgmt-wrapper">
                            <jsp:include page="/WEB-INF/views/owner/ownerSidebar.jsp" />

                            <main class="mgmt-content">
                                <div class="admin-container">

                                    <%-- ── Welcome Banner ────────────────────────────────── --%>
                                        <div class="db-welcome">
                                            <div class="db-welcome-text">
                                                <h2>Welcome back, <strong>
                                                        <c:out value="${sessionScope.user.fullName}" />
                                                    </strong>!</h2>
                                                <p>Here is your business at a glance — fleet performance, rentals, and
                                                    income.</p>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/owner/cars?action=register"
                                                class="btn btn-primary" style="flex-shrink:0;">
                                                <i class="bi bi-plus-circle"></i> Register New Car
                                            </a>
                                        </div>

                                        <%-- ── Quick Stats ─────────────────────────────────────── --%>
                                            <div class="db-stats">

                                                <%-- Card 1: Total Cars --%>
                                                    <div class="stat-card">
                                                        <div class="stat-icon" style="color:var(--orange);">
                                                            <i class="bi bi-car-front-fill"></i>
                                                        </div>
                                                        <div>
                                                            <div class="stat-label">Total Cars</div>
                                                            <div class="stat-value">
                                                                <c:choose>
                                                                    <c:when test="${not empty totalCars}">${totalCars}
                                                                    </c:when>
                                                                    <c:otherwise>—</c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <div class="stat-card-sub">
                                                                <span>
                                                                    <c:out
                                                                        value="${empty activeCars  ? '0' : activeCars}" />
                                                                </span> active&nbsp;&nbsp;•&nbsp;&nbsp;
                                                                <span style="color:var(--warning);">
                                                                    <c:out
                                                                        value="${empty pendingCars ? '0' : pendingCars}" />
                                                                </span> pending
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <%-- Card 3: Monthly Earnings --%>
                                                        <div class="stat-card">
                                                            <div class="stat-icon" style="color:var(--success);">
                                                                <i class="bi bi-wallet2"></i>
                                                            </div>
                                                            <div>
                                                                <div class="stat-label">Monthly Earnings</div>
                                                                <div class="stat-value" style="font-size:1.6rem;">
                                                                    <c:choose>
                                                                        <c:when test="${not empty monthlyEarnings}">
                                                                            <fmt:formatNumber value="${monthlyEarnings}"
                                                                                type="number" groupingUsed="true" /> ₫
                                                                        </c:when>
                                                                        <c:otherwise>— ₫</c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div class="stat-card-sub">Revenue this month</div>
                                                            </div>
                                                        </div>

                                            </div>

                                            <%-- ── Split: Chart (65%) + Pending Orders (35%) ──────── --%>
                                                <div class="db-split">

                                                    <%-- Left: Earnings Chart --%>
                                                        <div class="card">
                                                            <div class="card-header">
                                                                <div class="card-title"><i
                                                                        class="bi bi-bar-chart-line-fill"
                                                                        style="color:var(--orange); margin-right:0.4rem;"></i>Monthly
                                                                    Earnings (Last 6 Months)</div>
                                                            </div>
                                                            <div class="chart-container">
                                                                <!-- Pass data to JS via data attributes to avoid IDE syntax warnings -->
                                                                <div id="chartDataContainer"
                                                                    data-labels='${not empty chartLabels ? chartLabels : "[\"Jan\",\"Feb\",\"Mar\",\"Apr\",\"May\",\"Jun\"]"}'
                                                                    data-values='${not empty chartData ? chartData : "[0,0,0,0,0,0]"}'
                                                                    style="display: none;"></div>
                                                                <canvas id="earningsChart"></canvas>
                                                            </div>
                                                        </div>

                                                </div>
                                </div>
                            </main>
                        </div>

                        <jsp:include page="/WEB-INF/views/common/footer.jsp" />

                        <script>
                            (function () {
                                /* ── Chart.js — Earnings Bar Chart ─────────────────────
                                 Read chart labels and data from the hidden HTML container
                                 ──────────────────────────────────────────────────────── */
                                const container = document.getElementById('chartDataContainer');
                                const labels = JSON.parse(container.getAttribute('data-labels'));
                                const data = JSON.parse(container.getAttribute('data-values'));

                                const ctx = document.getElementById('earningsChart');
                                if (ctx) {
                                    new Chart(ctx, {
                                        type: 'bar',
                                        data: {
                                            labels: labels,
                                            datasets: [{
                                                label: 'Earnings (VND)',
                                                data: data,
                                                backgroundColor: 'rgba(249,115,22,0.18)',
                                                borderColor: 'rgba(249,115,22,0.85)',
                                                borderWidth: 2,
                                                borderRadius: 6,
                                                borderSkipped: false,
                                            }]
                                        },
                                        options: {
                                            responsive: true,
                                            maintainAspectRatio: false,
                                            plugins: {
                                                legend: { display: false },
                                                tooltip: {
                                                    callbacks: {
                                                        label: ctx => new Intl.NumberFormat('vi-VN').format(ctx.raw) + ' ₫'
                                                    }
                                                }
                                            },
                                            scales: {
                                                x: {
                                                    grid: { color: 'rgba(0,0,0,0.04)' },
                                                    ticks: { color: '#6B7280', font: { size: 12 } }
                                                },
                                                y: {
                                                    grid: { color: 'rgba(0,0,0,0.04)' },
                                                    ticks: {
                                                        color: '#6B7280',
                                                        font: { size: 11 },
                                                        callback: v => new Intl.NumberFormat('vi-VN', { notation: 'compact' }).format(v)
                                                    },
                                                    beginAtZero: true
                                                }
                                            }
                                        }
                                    });
                                }
                            })();
                        </script>
                </body>

                </html>