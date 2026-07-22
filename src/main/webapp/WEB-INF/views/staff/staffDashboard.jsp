<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Staff Operations Desk — CarRental</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.5" />
        <style>
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

            .db-stats {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
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
        </style>
        <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>

    <body>
        <% if (session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login/staff"
                );
                return;
            }%>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="mgmt-wrapper">
            <jsp:include page="/WEB-INF/views/common/staffSidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard" />
            </jsp:include>

            <main class="mgmt-content">
                <div class="admin-container">
                    <div class="db-welcome">
                        <div class="db-welcome-text">
                            <h2>Staff <strong>Dashboard</strong></h2>
                            <p>Welcome back, <strong style="color:var(--orange);">
                                    <c:out value="${sessionScope.user.email}" />
                                </strong> — Manage vehicle approvals and booking operations.</p>
                        </div>
                    </div>

                    <div class="db-stats">
                        <div class="stat-card">
                            <div class="stat-icon" style="color:var(--orange);">
                                <i class="bi bi-calendar2-check-fill"></i>
                            </div>
                            <div>
                                <div class="stat-label">Pending Bookings</div>
                                <div class="stat-value"><c:choose><c:when test="${not empty pendingBookings}">${pendingBookings}</c:when><c:otherwise>0</c:otherwise></c:choose></div>
                                    </div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon" style="color:#3B82F6;">
                                        <i class="bi bi-arrow-repeat"></i>
                                    </div>
                                    <div>
                                        <div class="stat-label">Active Rentals</div>
                                            <div class="stat-value"><c:choose><c:when test="${not empty activeRentals}">${activeRentals}</c:when><c:otherwise>0</c:otherwise></c:choose></div>
                                    </div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon" style="color:#10B981;">
                                        <i class="bi bi-car-front-fill"></i>
                                    </div>
                                    <div>
                                        <div class="stat-label">Cars to Review</div>
                                            <div class="stat-value"><c:choose><c:when test="${not empty carsToReview}">${carsToReview}</c:when><c:otherwise>0</c:otherwise></c:choose></div>
                                    </div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon" style="color:#8B5CF6;">
                                        <i class="bi bi-check-circle-fill"></i>
                                    </div>
                                    <div>
                                        <div class="stat-label">Completed</div>
                                            <div class="stat-value"><c:choose><c:when test="${not empty completedBookings}">${completedBookings}</c:when><c:otherwise>0</c:otherwise></c:choose></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Platform Activity Chart -->
                            <div class="card" style="margin-top: 2rem;">
                                <div class="card-header">
                                    <div class="card-title">Platform Activity (Bookings/Month)</div>
                                </div>
                                <div class="card-body">
                                    <div style="position: relative; height: 350px;">
                                        <div id="chartDataContainer"
                                             data-labels='["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]'
                                                 data-values='${monthlyBookingsJson}'
                                    style="display: none;"></div>
                                <canvas id="activityChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
        <script>
                           document.addEventListener("DOMContentLoaded", function () {
                               var container = document.getElementById('chartDataContainer');
                               if (container) {
                                   var rawLabels = container.getAttribute('data-labels');
                                   var rawValues = container.getAttribute('data-values');

                                   if (rawLabels && rawValues) {
                                       var labels = JSON.parse(rawLabels);
                                       var data = JSON.parse(rawValues);

                                       var ctx = document.getElementById('activityChart').getContext('2d');
                                       var chart = new Chart(ctx, {
                                           type: 'bar',
                                           data: {
                                               labels: labels,
                                               datasets: [{
                                                       label: 'Platform Bookings',
                                                       data: data,
                                                       backgroundColor: 'rgba(249, 115, 22, 0.8)',
                                                       borderColor: 'rgba(249, 115, 22, 1)',
                                                       borderWidth: 1,
                                                       borderRadius: 4
                                                   }]
                                           },
                                           options: {
                                               responsive: true,
                                               maintainAspectRatio: false,
                                               plugins: {
                                                   legend: {display: false}
                                               },
                                               scales: {
                                                   y: {beginAtZero: true, ticks: {precision: 0}}
                                               }
                                           }
                                       });
                                   }
                               }
                           });
        </script>
    </body>

</html>