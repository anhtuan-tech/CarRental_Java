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
                        /* Layout & Header Styles */
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

                        /* Stats Grid */
                        .db-stats {
                            display: grid;
                            grid-template-columns: repeat(3, 1fr);
                            gap: var(--sp-5);
                            margin-bottom: var(--sp-6);
                        }

                        @media (max-width: 1024px) {
                            .db-stats {
                                grid-template-columns: repeat(2, 1fr);
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

                        /* Chart Styles */

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
                                <li class="mgmt-menu-item"><a
                                        href="${pageContext.request.contextPath}/admin/dashboard"><i
                                            class="bi bi-speedometer2"></i> Dashboard</a></li>
                                <div class="mgmt-menu-section-title">Management</div>
                                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/staff"><i
                                            class="bi bi-people-fill"></i> Manage Staff</a></li>
                                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/users"><i
                                            class="bi bi-person-lines-fill"></i> Manage Users</a></li>
                                <div class="mgmt-menu-section-title">Finance</div>
                                <li class="mgmt-menu-item active"><a
                                        href="${pageContext.request.contextPath}/admin/revenue"><i
                                            class="bi bi-bar-chart-line-fill"></i> Revenue Report</a></li>
                            </ul>
            </aside>
                        <!-- Main Content -->
                        <main class="mgmt-content">
                            <div class="admin-container">

                                <div class="db-welcome" style="margin-bottom: 2rem;">
                                    <div class="db-welcome-text">
                                        <h2>Revenue <strong>Report</strong></h2>
                                        <p>Aggregate commission cuts, track payout margins, and audit platform earnings.
                                        </p>
                                    </div>
                                </div>

                                <!-- Date Range Selectors -->
                                <div class="action-bar"
                                    style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1.5rem; margin-bottom: 2rem; background: var(--color-surface); padding: var(--space-4) var(--space-6); border: 1px solid var(--color-dark-border); border-radius: var(--radius-lg);">
                                    <form action="${pageContext.request.contextPath}/admin/revenue" method="get"
                                        class="filter-form" id="rangeForm"
                                        style="display:flex; align-items:center; gap: 1.5rem; flex-wrap:wrap; margin:0; width:100%;">

                                        <div style="display:flex; align-items:center; gap:0.75rem;">
                                            <label for="startDate"
                                                style="font-size:0.9rem; font-weight:600; color:var(--color-gray-light); white-space:nowrap;">From:</label>
                                            <input type="date" name="startDate" id="startDate" class="form-control"
                                                value="<c:out value='${requestScope.startDateVal}'/>"
                                                style="height:42px; padding: 0 1rem; cursor:pointer;" />
                                        </div>

                                        <div style="display:flex; align-items:center; gap:0.75rem;">
                                            <label for="endDate"
                                                style="font-size:0.9rem; font-weight:600; color:var(--color-gray-light); white-space:nowrap;">To:</label>
                                            <input type="date" name="endDate" id="endDate" class="form-control"
                                                value="<c:out value='${requestScope.endDateVal}'/>"
                                                style="height:42px; padding: 0 1rem; cursor:pointer;" />
                                        </div>

                                        <button type="submit" class="btn btn-blue btn-sm"
                                            style="height:42px; padding:0 var(--space-6); margin-left:auto;"><i
                                                class="bi bi-funnel-fill"></i> Filter Insights</button>
                                        <c:if test="${not empty startDateVal || not empty endDateVal}">
                                            <a href="${pageContext.request.contextPath}/admin/revenue"
                                                class="btn btn-ghost btn-sm"
                                                style="height:42px; display:flex; align-items:center;"><i
                                                    class="bi bi-arrow-counterclockwise"></i> Reset</a>
                                        </c:if>
                                    </form>
                                </div>

                                <!-- Financial Summary Cards -->
                                <div class="db-stats" style="margin-bottom: 2rem;">
                                    <div class="stat-card">
                                        <div class="stat-icon" style="color:var(--orange);">
                                            <i class="bi bi-wallet2"></i>
                                        </div>
                                        <div>
                                            <div class="stat-label">Total Booking Value</div>
                                            <div class="stat-value">
                                                <fmt:formatNumber value="${not empty totalSubtotal ? totalSubtotal : 0}"
                                                    type="number" groupingUsed="true" /> đ
                                            </div>
                                        </div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-icon" style="color:var(--orange);">
                                            <i class="bi bi-cash-stack"></i>
                                        </div>
                                        <div>
                                            <div class="stat-label" style="color:var(--orange);">Platform Commission Cut
                                            </div>
                                            <div class="stat-value" style="color:var(--orange);">
                                                <fmt:formatNumber
                                                    value="${not empty totalCommission ? totalCommission : 0}"
                                                    type="number" groupingUsed="true" /> đ
                                            </div>
                                        </div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-icon" style="color:#10B981;">
                                            <i class="bi bi-bank"></i>
                                        </div>
                                        <div>
                                            <div class="stat-label">Fleet Owner Payouts</div>
                                            <div class="stat-value">
                                                <fmt:formatNumber value="${not empty totalPayout ? totalPayout : 0}"
                                                    type="number" groupingUsed="true" /> đ
                                            </div>
                                        </div>
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
                                                        <th>No.</th>
                                                        <th>Completed At</th>
                                                        <th>Customer</th>
                                                        <th>Owner</th>
                                                        <th>Subtotal Value</th>
                                                        <th>Platform Cut</th>
                                                        <th>Owner Margin</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="item" items="${revenueData}" varStatus="loop">
                                                        <tr>
                                                            <td
                                                                style="font-family:monospace; color:var(--color-blue-light); font-weight: bold;">
                                                                <c:out value="${loop.index + 1}" />
                                                            </td>
                                                            <td>
                                                                <c:out
                                                                    value="${fn:substring(item.createdAt.toString(), 0, 10)}" />
                                                            </td>
                                                            <td>
                                                                <c:out
                                                                    value="${item.customerName != null ? item.customerName : 'N/A'}" />
                                                            </td>
                                                            <td>
                                                                <c:out
                                                                    value="${item.ownerName != null ? item.ownerName : 'N/A'}" />
                                                            </td>
                                                            <td>
                                                                <fmt:formatNumber value="${item.subtotalFee}"
                                                                    type="number" groupingUsed="true" /> VND
                                                            </td>
                                                            <td style="color:var(--orange); font-weight:600;">
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
                                            
                                            <!-- Pagination Controls -->
                                            <c:if test="${totalPages > 0}">
                                                <div class="pagination-wrapper" style="display:flex; justify-content:space-between; align-items:center; margin-top:2rem;">
                                                    <div class="page-size-selector">
                                                        <form action="${pageContext.request.contextPath}/admin/revenue" method="get" style="margin:0; display:flex; align-items:center; gap:0.5rem;">
                                                            <c:if test="${not empty startDateVal}">
                                                                <input type="hidden" name="startDate" value="${startDateVal}" />
                                                            </c:if>
                                                            <c:if test="${not empty endDateVal}">
                                                                <input type="hidden" name="endDate" value="${endDateVal}" />
                                                            </c:if>
                                                            <span class="text-sm text-muted">Show:</span>
                                                            <select name="size" class="form-control" style="width:70px; height:32px; padding:0 0.5rem;" onchange="this.form.submit()">
                                                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                                                <option value="15" ${pageSize == 15 ? 'selected' : ''}>15</option>
                                                                <option value="30" ${pageSize == 30 ? 'selected' : ''}>30</option>
                                                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                                            </select>
                                                            <span class="text-sm text-muted">entries</span>
                                                        </form>
                                                    </div>
                                                    <div class="pagination-links" style="display:flex; gap:0.25rem;">
                                                        <c:set var="prevPage" value="${currentPage - 1 > 0 ? currentPage - 1 : 1}" />
                                                        <a href="?startDate=${startDateVal}&endDate=${endDateVal}&size=${pageSize}&page=${prevPage}" class="btn btn-sm ${currentPage == 1 ? 'disabled' : ''}" style="border:1px solid var(--border); background:var(--white);">&laquo; Prev</a>
                                                        
                                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                                            <a href="?startDate=${startDateVal}&endDate=${endDateVal}&size=${pageSize}&page=${p}" class="btn btn-sm" style="${p == currentPage ? 'background:var(--orange); color:white; border-color:var(--orange);' : 'border:1px solid var(--border); background:var(--white);'}">${p}</a>
                                                        </c:forEach>
                                                        
                                                        <c:set var="nextPage" value="${currentPage + 1 <= totalPages ? currentPage + 1 : totalPages}" />
                                                        <a href="?startDate=${startDateVal}&endDate=${endDateVal}&size=${pageSize}&page=${nextPage}" class="btn btn-sm ${currentPage == totalPages ? 'disabled' : ''}" style="border:1px solid var(--border); background:var(--white);">Next &raquo;</a>
                                                    </div>
                                                </div>
                                            </c:if>
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