<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Booking Inspection #ID ${carBookingDetail.bookingId} - CarRental Staff</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
                <style>
                    .detail-card {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-8);
                        max-width: 700px;
                        margin: var(--space-8) auto;
                    }

                    .info-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: var(--space-6);
                        margin-bottom: var(--space-6);
                    }

                    @media (max-width: 576px) {
                        .info-grid {
                            grid-template-columns: 1fr;
                        }
                    }

                    .info-item {
                        background: var(--color-dark-surface);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-lg);
                        padding: var(--space-4);
                    }

                    .info-label {
                        font-size: 0.75rem;
                        color: var(--color-gray-light);
                        text-transform: uppercase;
                        display: block;
                        margin-bottom: var(--space-1);
                    }

                    .info-value {
                        font-size: 1.05rem;
                        font-weight: 700;
                        color: var(--color-white);
                    }

                    .status-badge {
                        display: inline-block;
                        font-size: 0.75rem;
                        font-weight: 600;
                        padding: var(--space-1) var(--space-3);
                        border-radius: var(--radius-full);
                        text-transform: uppercase;
                    }

                    .status-badge.pending {
                        background: rgba(245, 158, 11, 0.1);
                        color: #F59E0B;
                        border: 1px solid rgba(245, 158, 11, 0.2);
                    }

                    .status-badge.confirmed {
                        background: rgba(59, 130, 246, 0.1);
                        color: #3B82F6;
                        border: 1px solid rgba(59, 130, 246, 0.2);
                    }

                    .status-badge.active {
                        background: rgba(139, 92, 246, 0.1);
                        color: #8B5CF6;
                        border: 1px solid rgba(139, 92, 246, 0.2);
                    }

                    .status-badge.completed {
                        background: rgba(16, 185, 129, 0.1);
                        color: #10B981;
                        border: 1px solid rgba(16, 185, 129, 0.2);
                    }

                    .status-badge.rejected {
                        background: rgba(239, 68, 68, 0.1);
                        color: #EF4444;
                        border: 1px solid rgba(239, 68, 68, 0.2);
                    }
                </style>
                <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>

            <body>

                <jsp:include page="/WEB-INF/views/common/header.jsp" />

                <div class="page-wrapper">
                    <div class="container">

                        <!-- Breadcrumbs -->
                        <div class="mb-4">
                            <a href="${pageContext.request.contextPath}/staff/bookings?action=list"
                                style="color:var(--color-gray-light); font-size:0.9rem; font-weight:500;">â† Back to
                                Master List</a>
                        </div>

                        <c:choose>
                            <c:when test="${not empty carBookingDetail}">
                                <div class="detail-card">

                                    <div class="mb-4"
                                        style="display:flex; justify-content:space-between; align-items:center;">
                                        <div>
                                            <h1 class="hero-title"
                                                style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">
                                                Booking <span>Inspection</span></h1>
                                            <p class="text-muted text-sm">Booking Reference ID: #
                                                <c:out value="${carBookingDetail.bookingId}" />
                                            </p>
                                        </div>
                                        <div
                                            class="status-badge ${carBookingDetail.status == 'Pending' ? 'pending' : (carBookingDetail.status == 'Confirmed' ? 'confirmed' : (carBookingDetail.status == 'Active' ? 'active' : (carBookingDetail.status == 'Completed' ? 'completed' : 'rejected')))}">
                                            <c:out value="${carBookingDetail.status}" />
                                        </div>
                                    </div>
                                    <div class="blue-line" style="margin-bottom: 2rem;"></div>

                                    <div class="info-grid">
                                        <div class="info-item">
                                            <span class="info-label">Customer Contact & Details</span>
                                            <span class="info-value">
                                                <c:out value="${carBookingDetail.customerName}" />
                                            </span>
                                        </div>

                                        <div class="info-item">
                                            <span class="info-label">Rental Duration Range</span>
                                            <span class="info-value">
                                                <fmt:parseDate value="${carBookingDetail.startDate}"
                                                    pattern="yyyy-MM-dd'T'HH:mm" var="sDate" type="both" />
                                                <fmt:parseDate value="${carBookingDetail.endDate}"
                                                    pattern="yyyy-MM-dd'T'HH:mm" var="eDate" type="both" />
                                                <fmt:formatDate value="${sDate}" pattern="MMM dd, yyyy" /> -
                                                <fmt:formatDate value="${eDate}" pattern="MMM dd, yyyy" />
                                            </span>
                                            <span
                                                style="display:block; font-size:0.8rem; color:var(--color-gray-light); margin-top:0.25rem;">
                                                Duration:
                                                <c:out value="${carBookingDetail.totalDays}" /> days
                                            </span>
                                        </div>

                                        <div class="info-item">
                                            <span class="info-label">Master Payout Metrics</span>
                                            <span class="info-value">
                                                <fmt:formatNumber value="${carBookingDetail.subtotalFee}" type="number"
                                                    groupingUsed="true" /> VND
                                            </span>
                                            <span
                                                style="display:block; font-size:0.8rem; color:var(--color-blue-light); margin-top:0.25rem;">
                                                Owner Payout:
                                                <fmt:formatNumber value="${carBookingDetail.ownerPayout}" type="number"
                                                    groupingUsed="true" /> VND
                                            </span>
                                        </div>

                                        <div class="info-item">
                                            <span class="info-label">System Platform Cut</span>
                                            <span class="info-value" style="color:var(--color-blue-light);">
                                                <fmt:formatNumber value="${carBookingDetail.platformCommission}"
                                                    type="number" groupingUsed="true" /> VND
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Status transition mutation forms -->
                                    <c:choose>
                                        <c:when
                                            test="${carBookingDetail.status == 'Pending' || carBookingDetail.status == 'Confirmed' || carBookingDetail.status == 'Active'}">
                                            <div
                                                style="background:var(--color-dark-surface); border:1px solid var(--color-dark-border); border-radius:var(--radius-xl); padding:var(--space-6); margin-top:2rem;">
                                                <h3
                                                    style="color:var(--color-white); font-size:1.1rem; margin-bottom:var(--space-2);">
                                                    Update Status Transition</h3>
                                                <p class="text-xs text-muted" style="margin-bottom:var(--space-4);">
                                                    Valid transitions enforce strict workflow parameters.</p>

                                                <form
                                                    action="${pageContext.request.contextPath}/staff/bookings?action=update"
                                                    method="post" id="statusTransitionForm">
                                                    <input type="hidden" name="bookingId"
                                                        value="${carBookingDetail.bookingId}" />

                                                    <div class="form-group">
                                                        <label for="note" class="form-label">Audit Note Description
                                                            <span class="required">*</span></label>
                                                        <input type="text" name="note" id="note" class="form-control"
                                                            placeholder="Specify handover keys, return details, or reject reasons..."
                                                            required />
                                                        <span class="form-hint">Staff Audit trace logs notes to
                                                            BookingHistory.</span>
                                                    </div>

                                                    <div style="display:flex; gap:var(--space-3); margin-top:1.5rem;">
                                                        <c:choose>
                                                            <c:when test="${carBookingDetail.status == 'Pending'}">
                                                                <button type="submit" name="status" value="Confirmed"
                                                                    class="btn btn-blue btn-sm">Confirm Booking</button>
                                                                <button type="submit" name="status" value="Rejected"
                                                                    class="btn btn-ghost btn-sm"
                                                                    style="color:var(--color-red);">Reject</button>
                                                            </c:when>
                                                            <c:when test="${carBookingDetail.status == 'Confirmed'}">
                                                                <button type="submit" name="status" value="Active"
                                                                    class="btn btn-blue btn-sm">Handover Vehicle
                                                                    (Active)</button>
                                                            </c:when>
                                                            <c:when test="${carBookingDetail.status == 'Active'}">
                                                                <button type="submit" name="status" value="Completed"
                                                                    class="btn btn-blue btn-sm">Mark Completed</button>
                                                            </c:when>
                                                        </c:choose>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div
                                                style="text-align:center; padding:var(--space-6); background:var(--color-dark-surface); border:1px solid var(--color-dark-border); border-radius:var(--radius-lg); color:var(--color-gray-light); font-size:0.9rem; margin-top:2rem;">
                                                This rental order has completed its operational lifecycle. Status is
                                                locked.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Detail not found layout state -->
                                <div class="empty-state">
                                    <div class="empty-state-icon">ðŸ›¡ï¸</div>
                                    <div class="empty-state-title">No car booking available</div>
                                    <p class="text-muted text-sm" style="margin-top:0.5rem;">The requested car booking
                                        could not be loaded or retrieved.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                    </div>
                </div>

                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
                    <script>
                        

                    var form = document.getElementById('statusTransitionForm');
                    if (form) {
                        form.addEventListener('submit', function (e) {
                            var note = document.getElementById('note').value.trim();
                            if (!note) {
                                e.preventDefault();
                                showToast('Audit note description is required to transition booking state.', 'error');
                            }
                        });
                    }
                </script>
            </body>

            </html>