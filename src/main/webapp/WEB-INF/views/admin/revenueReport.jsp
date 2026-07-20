<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Financial Intelligence desk - Car Rental Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
        <style>
            .report-container {
                max-width: 1000px;
                margin: var(--space-8) auto;
            }

            .filter-panel {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-6);
                margin-bottom: var(--space-6);
            }

            .filter-form {
                display: flex;
                align-items: flex-end;
                gap: var(--space-4);
                flex-wrap: wrap;
            }

            .fin-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: var(--space-6);
                margin-bottom: var(--space-8);
            }

            @media (max-width: 768px) {
                .fin-grid {
                    grid-template-columns: 1fr;
                }
            }

            .fin-card {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-6);
                position: relative;
                overflow: hidden;
            }

            .fin-card::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: var(--color-blue-border);
            }

            .fin-card.commission::after {
                background: var(--color-gold);
            }

            .fin-label {
                font-size: 0.8rem;
                text-transform: uppercase;
                color: var(--color-gray-light);
                margin-bottom: var(--space-1);
                display: block;
            }

            .fin-value {
                font-size: 1.65rem;
                font-weight: 800;
                color: var(--color-white);
            }

            .visual-bar-chart {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-6);
                margin-bottom: var(--space-8);
            }

            .chart-placeholder {
                height: 180px;
                display: flex;
                align-items: flex-end;
                gap: 12px;
                padding-top: var(--space-4);
                border-bottom: 2px solid var(--color-dark-border);
            }

            .chart-bar {
                flex-grow: 1;
                background: linear-gradient(180deg, var(--color-blue-light) 0%, rgba(59, 130, 246, 0.2) 100%);
                border-radius: var(--radius-sm) var(--radius-sm) 0 0;
                min-height: 10px;
                transition: var(--transition-slow);
                position: relative;
            }

            .chart-bar:hover {
                opacity: 0.85;
            }

            .report-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: var(--space-4);
            }

            .report-table th,
            .report-table td {
                text-align: left;
                padding: var(--space-4);
                border-bottom: 1px solid var(--color-dark-border);
            }

            .report-table th {
                color: var(--color-gray-light);
                font-size: 0.8rem;
                text-transform: uppercase;
            }
        </style>
    </head>

    <body>

        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="mgmt-wrapper">
            <!-- Admin Sidebar -->
            <aside class="mgmt-sidebar">
                <div class="mgmt-sidebar-header">
                    <div class="mgmt-sidebar-title"><i class="bi bi-shield-fill"></i> Admin Portal</div>
                    <div class="mgmt-sidebar-subtitle">System Control Panel</div>
                </div>
                <ul class="mgmt-menu">
                    <div class="mgmt-menu-section-title">Overview</div>
                    <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                    <div class="mgmt-menu-section-title">Management</div>
                    <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/staff"><i class="bi bi-people-fill"></i> Manage Staff</a></li>
                    <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-person-lines-fill"></i> Manage Users</a></li>
                    <div class="mgmt-menu-section-title">Finance</div>
                    <li class="mgmt-menu-item active"><a href="${pageContext.request.contextPath}/admin/revenue"><i class="bi bi-bar-chart-line-fill"></i> Revenue Report</a></li>
                </ul>
                <div class="mgmt-sidebar-footer">
                    <div class="mgmt-user-info"><i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.email}"/></div>
                    <a href="${pageContext.request.contextPath}/logout" style="display:block; margin-top:0.5rem; font-size:0.8rem; color:#EF4444; text-decoration:none;"><i class="bi bi-box-arrow-right"></i> Logout</a>
                </div>
            </aside>
            <!-- Main Content -->
            <main class="mgmt-content">
                <div class="report-container">

                    <div class="mb-6">
                        <h1 class="hero-title"
                            style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">Financial
                            <span>Intelligence Desk</span>
                        </h1>
                        <p class="text-muted text-sm">Aggregate commission cuts, track payout margins, and
                            audit platform earnings.</p>
                    </div>
                    <div class="blue-line" style="margin-bottom: 2rem;"></div>

                    <!-- Date Range Selectors -->
                    <div class="filter-panel">
                        <form action="${pageContext.request.contextPath}/admin/revenue" method="get"
                              class="filter-form" id="rangeForm">
                            <div class="form-group mb-0" style="flex-grow:1; max-width:250px;">
                                <label for="startDate" class="form-label">Start Period</label>
                                <input type="date" name="startDate" id="startDate" class="form-control"
                                       value="<c:out value='${requestScope.startDateVal}'/>" />
                            </div>
                            <div class="form-group mb-0" style="flex-grow:1; max-width:250px;">
                                <label for="endDate" class="form-label">End Period</label>
                                <input type="date" name="endDate" id="endDate" class="form-control"
                                       value="<c:out value='${requestScope.endDateVal}'/>" />
                            </div>
                            <button type="submit" class="btn btn-blue btn-sm"
                                    style="height:42px; padding:0 var(--space-6);">Compute Insights</button>
                            <c:if test="${not empty startDateVal || not empty endDateVal}">
                                <a href="${pageContext.request.contextPath}/admin/revenue"
                                   class="btn btn-ghost btn-sm"
                                   style="height:42px; display:flex; align-items:center;">Reset Range</a>
                            </c:if>
                        </form>
                    </div>

                    <!-- Financial Summary Cards -->
                    <div class="fin-grid">
                        <div class="fin-card">
                            <span class="fin-label">Total Booking Value</span>
                            <span class="fin-value">
                                <fmt:formatNumber value="${not empty totalSubtotal ? totalSubtotal : 0}"
                                                  type="number" groupingUsed="true" /> VND
                            </span>
                        </div>
                        <div class="fin-card commission">
                            <span class="fin-label" style="color:var(--color-gold);">Platform Commission
                                Cut</span>
                            <span class="fin-value" style="color:var(--color-gold);">
                                <fmt:formatNumber value="${not empty totalCommission ? totalCommission : 0}"
                                                  type="number" groupingUsed="true" /> VND
                            </span>
                        </div>
                        <div class="fin-card">
                            <span class="fin-label">Fleet Owner Payouts</span>
                            <span class="fin-value">
                                <fmt:formatNumber value="${not empty totalPayout ? totalPayout : 0}"
                                                  type="number" groupingUsed="true" /> VND
                            </span>
                        </div>
                    </div>

                    <!-- Visualization analytics mock bar-chart -->
                    <div class="visual-bar-chart">
                        <h3
                            style="color:var(--color-white); font-size:1.05rem; margin-bottom:var(--space-4);">
                            Earnings Velocity Chart</h3>

                        <div class="chart-placeholder">
                            <c:choose>
                                <c:when test="${not empty revenueData}">
                                    <%-- Render up to 11 bars with fixed relative heights based on index
                                    --%>
                                    <c:forEach var="item" items="${revenueData}" varStatus="loop"
                                               end="10">
                                        <c:set var="barH" value="${(loop.index + 1) * 8 + 15}" />
                                        <div class="chart-bar" data-height="${barH}"
                                             title="${item.bookingId}: ${item.subtotalFee} VND"></div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div
                                        style="margin:auto; font-size:0.85rem; color:var(--color-gray-light); padding-bottom: 2rem;">
                                        No reporting items available to map graphical elements.</div>
                                    </c:otherwise>
                                </c:choose>
                        </div>
                        <div
                            style="display:flex; justify-content:space-between; font-size:0.75rem; color:var(--color-gray-light); margin-top:0.5rem;">
                            <span>Past Bookings</span>
                            <span>Latest Transaction</span>
                        </div>
                    </div>

                    <!-- Details Audit Table -->
                    <div
                        style="background:var(--color-dark-card); border:1px solid var(--color-dark-border); border-radius:var(--radius-xl); padding:var(--space-6);">
                        <h3
                            style="color:var(--color-white); font-size:1.05rem; margin-bottom:var(--space-4);">
                            Detailed Ledger Logs</h3>

                        <c:choose>
                            <c:when test="${not empty revenueData}">
                                <table class="report-table">
                                    <thead>
                                        <tr>
                                            <th>Booking Ref</th>
                                            <th>Completed At</th>
                                            <th>Subtotal Value</th>
                                            <th>Platform Cut</th>
                                            <th>Owner Margin</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${revenueData}">
                                            <tr>
                                                <td
                                                    style="font-family:monospace; color:var(--color-blue-light);">
                                                    #
                                                    <c:out value="${item.bookingId}" />
                                                </td>
                                                <td>
                                                    <c:out
                                                        value="${fn:substring(item.createdAt.toString(), 0, 10)}" />
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${item.subtotalFee}"
                                                                      type="number" groupingUsed="true" /> VND
                                                </td>
                                                <td style="color:var(--color-gold); font-weight:600;">
                                                    <fmt:formatNumber value="${item.platformCommission}"
                                                                      type="number" groupingUsed="true" /> VND
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${item.ownerPayout}"
                                                                      type="number" groupingUsed="true" /> VND
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <p class="text-sm text-muted"
                                   style="text-align:center; padding:var(--space-6);">No transaction items
                                    available inside the defined date ranges.</p>
                                </c:otherwise>
                            </c:choose>
                    </div>

                </div>
            </main>
        </div>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        <script>


            document.getElementById('rangeForm').addEventListener('submit', function (e) {
                var start = document.getElementById('startDate').value;
                var end = document.getElementById('endDate').value;

                if (start && end) {
                    var sDate = new Date(start);
                    var eDate = new Date(end);

                    if (eDate < sDate) {
                        e.preventDefault();
                        showToast('Date range sequence error: End date cannot represent a timeline value before Start date.', 'error');
                    }
                }
            });
        </script>
    </body>

</html>