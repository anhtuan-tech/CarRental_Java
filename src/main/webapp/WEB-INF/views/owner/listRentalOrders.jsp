<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Rental Orders — Car Rental Owner</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
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
                padding: var(--space-5);
                margin-bottom: var(--space-4);
                transition: var(--transition-fast);
            }

            .order-card:hover {
                border-color: rgba(249, 115, 22, 0.4);
            }

            .order-stt-badge {
                display: flex;
                align-items: center;
                justify-content: center;
                background: var(--color-dark-surface);
                border: 1.5px solid var(--color-dark-border);
                border-radius: var(--radius-lg);
                min-width: 48px;
                height: 48px;
                font-weight: 800;
                font-size: 1.2rem;
                color: var(--orange);
            }

            .order-grid-new {
                display: flex;
                gap: var(--space-5);
                align-items: center;
                justify-content: space-between;
                flex-wrap: wrap;
            }

            .order-info-col {
                flex: 2;
                display: flex;
                flex-direction: column;
                gap: 0.3rem;
                min-width: 260px;
            }

            .order-time-col {
                flex: 1.5;
                display: flex;
                flex-direction: column;
                gap: 0.25rem;
                min-width: 200px;
            }

            .order-payout-col {
                flex: 1.2;
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                text-align: right;
                min-width: 180px;
            }

            /* ── Status badges ───────────────────────────────────── */
            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.3rem;
                font-size: 0.75rem;
                font-weight: 700;
                padding: 0.25rem 0.6rem;
                border-radius: 20px;
                text-transform: uppercase;
            }

            .status-badge.pending {
                background: rgba(245, 158, 11, 0.15);
                color: #F59E0B;
                border: 1px solid rgba(245, 158, 11, 0.3);
            }

            .status-badge.paid {
                background: rgba(34, 197, 94, 0.15);
                color: #22C55E;
                border: 1px solid rgba(34, 197, 94, 0.3);
            }

            .status-badge.confirmed {
                background: rgba(59, 130, 246, 0.15);
                color: #3B82F6;
                border: 1px solid rgba(59, 130, 246, 0.3);
            }

            .status-badge.active {
                background: rgba(139, 92, 246, 0.15);
                color: #8B5CF6;
                border: 1px solid rgba(139, 92, 246, 0.3);
            }

            .status-badge.completed {
                background: rgba(16, 185, 129, 0.15);
                color: #10B981;
                border: 1px solid rgba(16, 185, 129, 0.3);
            }

            .status-badge.rejected {
                background: rgba(239, 68, 68, 0.15);
                color: #EF4444;
                border: 1px solid rgba(239, 68, 68, 0.3);
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <div class="mgmt-wrapper">
            <jsp:include page="/WEB-INF/views/owner/ownerSidebar.jsp"/>

            <!-- Main Content -->
            <main class="mgmt-content">
                <div class="admin-container">

                    <div class="mb-6">
                        <h1 class="hero-title"
                            style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                            Rental <span>Orders</span>
                        </h1>
                        <p class="text-muted text-sm">Monitor client requests and update vehicle handover
                            statuses.</p>
                    </div>

                    <!-- Orders list -->
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="ord" items="${orders}" varStatus="status">
                                <div class="order-card">

                                    <div class="order-grid-new">

                                        <!-- STT Badge -->
                                        <div class="order-stt-badge">
                                            #${status.count}
                                        </div>

                                        <!-- Vehicle & Customer Info -->
                                        <div class="order-info-col">
                                            <div
                                                style="display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap;">
                                                <h3
                                                    style="margin: 0; font-size: 1.1rem; font-weight: 700; color: var(--color-white);">
                                                    <i class="bi bi-car-front-fill"
                                                       style="color: var(--orange); margin-right: 0.2rem;"></i>
                                                    <c:choose>
                                                        <c:when
                                                            test="${not empty ord.brand && fn:startsWith(ord.carName, ord.brand)}">
                                                            <c:out value="${ord.carName}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${ord.brand}" />
                                                            <c:out value="${ord.carName}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h3>
                                                <c:if test="${not empty ord.licensePlate}">
                                                    <span class="car-plate-badge"
                                                          style="margin: 0; font-size: 0.75rem;">
                                                        <c:out value="${ord.licensePlate}" />
                                                    </span>
                                                </c:if>
                                            </div>

                                            <div
                                                style="font-size: 0.9rem; color: var(--color-gray-light); margin-top: 0.2rem;">
                                                Customer: <strong style="color: var(--color-white);">
                                                    <c:out value="${ord.customerName}" />
                                                </strong>
                                            </div>
                                        </div>

                                        <!-- Duration & Schedule -->
                                        <div class="order-time-col">
                                            <span
                                                style="font-size: 0.75rem; color: var(--color-gray-mid); text-transform: uppercase; font-weight: 600;">Rental
                                                Period</span>
                                            <div style="font-size: 0.88rem; color: var(--color-white);">
                                                <i class="bi bi-calendar-event"
                                                   style="color: var(--orange); margin-right: 0.2rem;"></i>
                                                <fmt:parseDate value="${ord.startDate}"
                                                               pattern="yyyy-MM-dd'T'HH:mm" var="sDate" type="both" />
                                                <fmt:parseDate value="${ord.endDate}"
                                                               pattern="yyyy-MM-dd'T'HH:mm" var="eDate" type="both" />
                                                <fmt:formatDate value="${sDate}" pattern="MMM dd, yyyy" /> -
                                                <fmt:formatDate value="${eDate}" pattern="MMM dd, yyyy" />
                                            </div>
                                            <span
                                                style="font-size: 0.8rem; color: var(--color-gray-light);">
                                                Duration: <strong style="color: var(--color-white);">
                                                    <c:out value="${ord.totalDays}" /> Days
                                                </strong>
                                            </span>
                                        </div>

                                        <!-- Payout & Status -->
                                        <div class="order-payout-col">
                                            <div style="margin-bottom: 0.3rem;">
                                                <span
                                                    class="status-badge ${ord.status == 'Pending' ? 'pending' : (ord.status == 'Paid' ? 'paid' : (ord.status == 'Confirmed' ? 'confirmed' : (ord.status == 'Active' ? 'active' : (ord.status == 'Completed' ? 'completed' : 'rejected'))))}">
                                                    <c:out value="${ord.status}" />
                                                </span>
                                            </div>

                                            <div style="font-size: 0.8rem; color: var(--color-gray-light);">
                                                Paid: <strong style="color: var(--color-white);">
                                                    <fmt:formatNumber value="${ord.subtotalFee}"
                                                                      type="number" groupingUsed="true" /> ₫
                                                </strong>
                                            </div>
                                            <div
                                                style="font-size: 0.95rem; font-weight: 700; color: var(--orange); margin-top: 0.1rem;">
                                                Earning:
                                                <fmt:formatNumber value="${ord.ownerPayout}" type="number"
                                                                  groupingUsed="true" /> ₫
                                            </div>
                                        </div>

                                    </div>

                                    <!-- Context actions based on state transition rules -->
                                    <c:if
                                        test="${ord.status == 'Pending' || ord.status == 'Paid' || ord.status == 'Approved' || ord.status == 'Confirmed' || ord.status == 'Active'}">
                                        <div
                                            style="margin-top:var(--space-4); padding-top:var(--space-4); border-top:1px solid var(--color-dark-border);">
                                            <form
                                                action="${pageContext.request.contextPath}/owner/orders?action=update"
                                                method="post"
                                                style="display:flex; gap:var(--space-3); align-items:center;">
                                                <input type="hidden" name="bookingId"
                                                       value="${ord.bookingId}" />

                                                <div style="flex-grow:1;">
                                                    <input type="text" name="note" class="form-control"
                                                           style="height:36px; padding:0 var(--space-3); font-size:0.85rem;"
                                                           placeholder="Handover / completion notes..." />
                                                </div>

                                                <c:choose>
                                                    <c:when test="${ord.status == 'Pending'}">
                                                        <button type="submit" name="status"
                                                                value="Confirmed" class="btn btn-blue btn-sm"
                                                                style="padding:0 var(--space-4); height:36px;">Confirm
                                                            Order</button>
                                                        <button type="submit" name="status" value="Rejected"
                                                                class="btn btn-ghost btn-sm"
                                                                style="color:var(--color-red); height:36px;">Reject</button>
                                                    </c:when>
                                                    <c:when
                                                        test="${ord.status == 'Paid' || ord.status == 'Approved' || ord.status == 'Confirmed'}">
                                                        <button type="submit" name="status" value="Active"
                                                                class="btn btn-blue btn-sm"
                                                                style="padding:0 var(--space-4); height:36px; background: #8B5CF6; border-color: #8B5CF6;">Handover
                                                            Vehicle (Active)</button>
                                                        <button type="submit" name="status"
                                                                value="Completed" class="btn btn-primary btn-sm"
                                                                style="padding:0 var(--space-4); height:36px; background: var(--orange); border-color: var(--orange);">Mark
                                                            Return (Completed)</button>
                                                        </c:when>
                                                        <c:when test="${ord.status == 'Active'}">
                                                        <button type="submit" name="status"
                                                                value="Completed" class="btn btn-primary btn-sm"
                                                                style="padding:0 var(--space-4); height:36px; background: var(--orange); border-color: var(--orange);">Mark
                                                            Return (Completed)</button>
                                                        </c:when>
                                                    </c:choose>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state"
                                 style="background: var(--color-dark-card); border: 1px solid var(--color-dark-border); border-radius: var(--radius-xl); padding: 3rem; text-align: center;">
                                <div style="font-size: 3rem; margin-bottom: 1rem;"><i
                                        class="bi bi-receipt-cutoff" style="color: var(--orange);"></i>
                                </div>
                                <h3
                                    style="color: var(--color-white); font-size: 1.25rem; margin-bottom: 0.5rem;">
                                    No rental transactions</h3>
                                <p style="color: var(--color-gray-mid); font-size: 0.9rem;">Rental orders
                                    submitted by clients will appear here.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </main>
        </div>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </body>

</html>