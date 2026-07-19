<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Rental Orders — CarRental Owner</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <style>
        .admin-container {
            max-width: 100%;
            margin: 0 auto;
            padding: 0 var(--space-4);
        }

        .order-card {
            background: var(--color-dark-card);
            border: 1px solid var(--color-dark-border);
            border-radius: var(--radius-xl);
            padding: var(--space-6);
            margin-bottom: var(--space-4);
            transition: var(--transition-fast);
        }

        .order-card:hover {
            border-color: var(--color-blue-border);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--color-dark-border);
            padding-bottom: var(--space-4);
            margin-bottom: var(--space-4);
        }

        .order-id {
            font-family: monospace;
            font-size: 0.95rem;
            color: var(--color-blue-light);
            font-weight: 600;
        }

        .order-grid {
            display: grid;
            grid-template-columns: 2fr 1.5fr 1.5fr;
            gap: var(--space-6);
            align-items: center;
        }

        @media (max-width: 768px) {
            .order-grid {
                grid-template-columns: 1fr;
                gap: var(--space-4);
            }
        }

        .order-meta-item {
            font-size: 0.9rem;
            color: var(--color-white-soft);
        }

        .order-meta-label {
            font-size: 0.75rem;
            color: var(--color-gray-light);
            text-transform: uppercase;
            display: block;
            margin-bottom: var(--space-1);
            font-weight: 600;
        }

        /* ── Status badges ───────────────────────────────────── */
        .status-badge {
            display: inline-block;
            font-size: 0.75rem;
            font-weight: 600;
            padding: var(--space-1) var(--space-3);
            border-radius: var(--radius-full);
            text-transform: uppercase;
        }
        .status-badge.pending   { background:rgba(245,158,11,0.1);  color:#F59E0B; border:1px solid rgba(245,158,11,0.2); }
        .status-badge.confirmed { background:rgba(59,130,246,0.1);  color:#3B82F6; border:1px solid rgba(59,130,246,0.2); }
        .status-badge.active    { background:rgba(139,92,246,0.1);  color:#8B5CF6; border:1px solid rgba(139,92,246,0.2); }
        .status-badge.completed { background:rgba(16,185,129,0.1);  color:#10B981; border:1px solid rgba(16,185,129,0.2); }
        .status-badge.rejected  { background:rgba(239,68,68,0.1);   color:#EF4444; border:1px solid rgba(239,68,68,0.2); }
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
                <li class="mgmt-menu-item active"><a href="${pageContext.request.contextPath}/owner/orders"><i class="bi bi-receipt-cutoff"></i> Rental Orders</a></li>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/owner/earning"><i class="bi bi-wallet2"></i> Earnings &amp; Payouts</a></li>
                <div class="mgmt-menu-section-title">Account</div>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/profile"><i class="bi bi-gear-fill"></i> My Profile</a></li>
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
                        Rental <span>Orders</span>
                    </h1>
                    <p class="text-muted text-sm">Monitor client requests and update vehicle handover statuses.</p>
                </div>
                <div class="blue-line" style="margin-bottom: 2rem;"></div>

                <!-- Orders list -->
                <c:choose>
                    <c:when test="${not empty orders}">
                        <c:forEach var="ord" items="${orders}">
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-id">Order ID: #<c:out value="${ord.bookingId}"/></div>
                                    <span class="status-badge ${ord.status == 'Pending' ? 'pending' : (ord.status == 'Confirmed' ? 'confirmed' : (ord.status == 'Active' ? 'active' : (ord.status == 'Completed' ? 'completed' : 'rejected')))}">
                                        <c:out value="${ord.status}"/>
                                    </span>
                                </div>

                                <div class="order-grid">
                                    <div class="order-meta-item">
                                        <span class="order-meta-label">Customer Name</span>
                                        <strong><c:out value="${ord.customerName}"/></strong>
                                    </div>

                                    <div class="order-meta-item">
                                        <span class="order-meta-label">Rental Duration</span>
                                        <fmt:parseDate value="${ord.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="sDate" type="both"/>
                                        <fmt:parseDate value="${ord.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="eDate" type="both"/>
                                        <fmt:formatDate value="${sDate}" pattern="MMM dd"/> - <fmt:formatDate value="${eDate}" pattern="MMM dd, yyyy"/>
                                        <span style="display:block; font-size:0.75rem; color:var(--color-gray-light); margin-top:0.25rem;">(<c:out value="${ord.totalDays}"/> days)</span>
                                    </div>

                                    <div class="order-meta-item">
                                        <span class="order-meta-label">Payout details</span>
                                        Total Paid: <strong><fmt:formatNumber value="${ord.subtotalFee}" type="number" groupingUsed="true"/></strong> ₫
                                        <span style="display:block; font-size:0.75rem; color:var(--color-blue-light); margin-top:0.25rem;">
                                            Earning: <fmt:formatNumber value="${ord.ownerPayout}" type="number" groupingUsed="true"/> ₫
                                        </span>
                                    </div>
                                </div>

                                <!-- Context actions based on state transition rules -->
                                <c:if test="${ord.status == 'Pending' || ord.status == 'Confirmed' || ord.status == 'Active'}">
                                    <div style="margin-top:var(--space-4); padding-top:var(--space-4); border-top:1px solid var(--color-dark-border);">
                                        <form action="${pageContext.request.contextPath}/owner/orders?action=update" method="post" style="display:flex; gap:var(--space-3); align-items:center;">
                                            <input type="hidden" name="bookingId" value="${ord.bookingId}"/>
                                            
                                            <div style="flex-grow:1;">
                                                <input type="text" name="note" class="form-control" style="height:36px; padding:0 var(--space-3); font-size:0.85rem;" placeholder="Handover / completion notes"/>
                                            </div>

                                            <c:choose>
                                                <c:when test="${ord.status == 'Pending'}">
                                                    <button type="submit" name="status" value="Confirmed" class="btn btn-blue btn-sm" style="padding:0 var(--space-4); height:36px;">Confirm Order</button>
                                                    <button type="submit" name="status" value="Rejected" class="btn btn-ghost btn-sm" style="color:var(--color-red); height:36px;">Reject</button>
                                                </c:when>
                                                <c:when test="${ord.status == 'Confirmed'}">
                                                    <button type="submit" name="status" value="Active" class="btn btn-blue btn-sm" style="padding:0 var(--space-4); height:36px;">Handover Vehicle (Active)</button>
                                                </c:when>
                                                <c:when test="${ord.status == 'Active'}">
                                                    <button type="submit" name="status" value="Completed" class="btn btn-blue btn-sm" style="padding:0 var(--space-4); height:36px;">Mark Return (Completed)</button>
                                                </c:when>
                                            </c:choose>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon"><i class="bi bi-receipt-cutoff"></i></div>
                            <div class="empty-state-title">No rental transactions</div>
                            <p class="text-muted text-sm" style="margin-top:0.5rem;">Rental orders submitted by clients will appear here.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </main>
    </div>
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>

</html>
