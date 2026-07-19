<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
    <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
    <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>My Car Bookings - CarRental</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
                <style>
                    .bookings-container {
                        max-width: 1100px;
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
                        align-items: center;
                        gap: var(--space-4);
                        flex-wrap: wrap;
                    }

                    .booking-card {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-6);
                        margin-bottom: var(--space-6);
                        transition: var(--transition-slow);
                        position: relative;
                    }

                    .booking-card:hover {
                        border-color: var(--color-blue-border);
                    }

                    .booking-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        border-bottom: 1px solid var(--color-dark-border);
                        padding-bottom: var(--space-4);
                        margin-bottom: var(--space-4);
                    }

                    .booking-ref {
                        font-family: monospace;
                        font-size: 1rem;
                        font-weight: 700;
                        color: var(--color-blue-light);
                    }

                    .status-badge {
                        padding: var(--space-1) var(--space-3);
                        border-radius: var(--radius-full);
                        font-size: 0.75rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                    }

                    .status-paid {
                        background: rgba(16, 185, 129, 0.15);
                        color: #10b981;
                        border: 1px solid rgba(16, 185, 129, 0.3);
                    }

                    .status-pending {
                        background: rgba(245, 158, 11, 0.15);
                        color: var(--color-gold);
                        border: 1px solid rgba(245, 158, 11, 0.3);
                    }

                    .status-cancelled {
                        background: rgba(239, 68, 68, 0.15);
                        color: var(--color-red);
                        border: 1px solid rgba(239, 68, 68, 0.3);
                    }

                    .status-refunded {
                        background: rgba(59, 130, 246, 0.15);
                        color: var(--color-blue-light);
                        border: 1px solid rgba(59, 130, 246, 0.3);
                    }

                    .booking-grid {
                        display: grid;
                        grid-template-columns: 2fr 1fr 1fr;
                        gap: var(--space-6);
                        align-items: center;
                    }

                    @media (max-width: 768px) {
                        .booking-grid {
                            grid-template-columns: 1fr;
                        }
                    }

                    .car-info-title {
                        font-size: 1.15rem;
                        font-weight: 700;
                        color: var(--color-white);
                        margin-bottom: var(--space-1);
                    }

                    .car-plate-badge {
                        display: inline-block;
                        background: var(--color-dark-surface);
                        border: 1px solid var(--color-dark-border);
                        padding: 2px 8px;
                        border-radius: var(--radius-sm);
                        font-family: monospace;
                        font-size: 0.8rem;
                        color: var(--color-gray-light);
                    }

                    .detail-meta {
                        font-size: 0.85rem;
                        color: var(--color-gray-light);
                        margin-top: var(--space-2);
                    }

                    .amount-val {
                        font-size: 1.35rem;
                        font-weight: 800;
                        color: var(--color-gold);
                    }

                    /* Modal styling */
                    .modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.8);
                        backdrop-filter: blur(4px);
                        display: none;
                        justify-content: center;
                        align-items: center;
                        z-index: 1000;
                    }

                    .modal-content {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-8);
                        max-width: 500px;
                        width: 90%;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/WEB-INF/views/common/header.jsp" />

                <div class="page-wrapper">
                    <div class="container">
                        <div class="bookings-container">

                            <!-- Page Header -->
                            <div class="mb-6">
                                <h1 class="hero-title"
                                    style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                                    My Car <span>Bookings Log</span>
                                </h1>
                                <p class="text-muted text-sm">
                                    Track active reservations, check payment status, and manage automated VNPAY
                                    cancellations ().
                                </p>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                             <!-- Search Input Widget -->
                             <div class="filter-panel" style="margin-bottom: 1.5rem;">
                                 <div class="form-group mb-0" style="width: 100%; position: relative; display: flex; align-items: center;">
                                     <i class="bi bi-search" style="position: absolute; left: var(--space-4); top: 50%; transform: translateY(-50%); color: var(--color-gray-mid); font-size: 1.1rem; pointer-events: none;"></i>
                                     <input type="text" id="bookingSearchInput" class="form-control"
                                         placeholder="Type to filter bookings by vehicle, plate number, date, or status..."
                                         style="height: 46px; padding-left: 2.75rem; border-radius: var(--radius-lg); width: 100%; background: var(--color-dark-surface); border: 1.5px solid var(--color-dark-border); color: var(--color-white); font-size: 0.95rem;" />
                                 </div>
                             </div>

                            <!-- Empty State Banner -->
                            <c:if test="${not empty requestScope.message}">
                                <div
                                    style="background: var(--color-dark-card); border: 1px solid var(--color-dark-border); border-radius: var(--radius-xl); padding: 3rem; text-align: center; margin: 2rem 0;">
                                    <div style="margin-bottom: 1rem;"><i class="bi bi-car-front-fill"
                                            style="font-size: 3rem; color: var(--orange);"></i></div>
                                    <h3 style="color: var(--color-white); font-size: 1.25rem; margin-bottom: 0.5rem;">
                                        <c:out value="${requestScope.message}" />
                                    </h3>
                                    <p style="color: var(--color-gray-mid); font-size: 0.9rem; margin-bottom: 1.5rem;">
                                        Explore our premium fleet and make your next reservation today.
                                    </p>
                                    <a href="${pageContext.request.contextPath}/cars" class="btn btn-blue btn-sm">
                                        Browse Available Vehicles
                                    </a>
                                </div>
                            </c:if>

                            <!-- Bookings Data List -->
                            <c:if test="${not empty requestScope.carBookingList}">
                                <c:forEach var="booking" items="${requestScope.carBookingList}" varStatus="status">
                                    <div class="booking-card" style="display: flex; gap: var(--space-4); align-items: stretch; margin-bottom: 1.5rem; background: var(--color-dark-card); border: 1px solid var(--color-dark-border); border-radius: var(--radius-xl); padding: var(--space-5); color: var(--color-white);">
                                        
                                        <!-- Index Col -->
                                        <div style="display: flex; align-items: center; justify-content: center; background: var(--color-dark-surface); border: 1.5px solid var(--color-dark-border); border-radius: var(--radius-lg); min-width: 48px; height: 48px; font-weight: 800; font-size: 1.2rem; color: var(--orange);">
                                            #${status.count}
                                        </div>

                                        <!-- Info Col -->
                                        <div style="flex: 1; display: flex; flex-direction: column; gap: 0.5rem; justify-content: center;">
                                            <div style="display: flex; align-items: center; gap: 0.75rem; flex-wrap: wrap;">
                                                <h3 style="margin: 0; font-size: 1.15rem; font-weight: 700; color: var(--color-white);">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(booking.carName, booking.brand)}">
                                                            <c:out value="${booking.carName}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${booking.brand}" /> <c:out value="${booking.carName}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h3>
                                                <span class="car-plate-badge" style="margin: 0;"><c:out value="${booking.licensePlate}" /></span>
                                                <span class="text-xs text-muted" style="font-size: 0.8rem; color: var(--color-gray-mid);">
                                                    Reserved on: 
                                                    <fmt:parseDate value="${booking.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="createdDate" type="both" />
                                                    <fmt:formatDate value="${createdDate}" pattern="MMM dd, yyyy HH:mm" />
                                                </span>
                                            </div>

                                            <div style="display: flex; gap: var(--space-6); font-size: 0.85rem; color: var(--color-gray-light); flex-wrap: wrap; margin-top: 0.25rem;">
                                                <div>
                                                    <i class="bi bi-calendar-event-fill" style="color:var(--orange); margin-right: 0.3rem;"></i> Pick-up: 
                                                    <fmt:parseDate value="${booking.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="sDate" type="both" />
                                                    <strong style="color: var(--color-white);"><fmt:formatDate value="${sDate}" pattern="MMM dd, yyyy HH:mm" /></strong>
                                                </div>
                                                <div>
                                                    <i class="bi bi-calendar-check-fill" style="color:var(--orange); margin-right: 0.3rem;"></i> Return: 
                                                    <fmt:parseDate value="${booking.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="eDate" type="both" />
                                                    <strong style="color: var(--color-white);"><fmt:formatDate value="${eDate}" pattern="MMM dd, yyyy HH:mm" /></strong>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Pricing & Actions Col -->
                                        <div style="display: flex; flex-direction: column; align-items: flex-end; justify-content: space-between; min-width: 220px; text-align: right; border-left: 1px solid var(--color-dark-border); padding-left: var(--space-4);">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${booking.status == 'Paid'}">
                                                        <span class="status-badge status-paid"><i class="bi bi-check-circle-fill"></i> Paid</span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Pending Payment'}">
                                                        <span class="status-badge status-pending"><i class="bi bi-hourglass-split"></i> Pending Payment</span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Cancelled'}">
                                                        <span class="status-badge status-cancelled"><i class="bi bi-x-circle-fill"></i> Cancelled</span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Refunded'}">
                                                        <span class="status-badge status-refunded"><i class="bi bi-arrow-counterclockwise"></i> Refunded</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-pending"><c:out value="${booking.status}" /></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div style="margin: 0.35rem 0;">
                                                <span style="font-size: 0.8rem; color: var(--color-gray-light);">
                                                    Duration: <strong style="color: var(--color-white); font-size: 0.9rem;"><c:out value="${booking.totalDays}" /> Days</strong>
                                                </span>
                                                <span style="font-size: 0.75rem; color: var(--color-gray-mid); display: block; margin-top: 0.1rem;">
                                                    (<fmt:formatNumber value="${booking.pricePerDay}" type="number" groupingUsed="true" /> VND/day)
                                                </span>
                                            </div>

                                            <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 0.25rem;">
                                                <span style="font-size: 0.7rem; text-transform: uppercase; color: var(--color-gray-mid);">Total Advance Value</span>
                                                <span class="amount-val" style="font-size: 1.15rem; font-weight: 800; color: var(--orange); line-height: 1.2;">
                                                    <fmt:formatNumber value="${booking.subtotalFee}" type="number" groupingUsed="true" /> VND
                                                </span>
                                                
                                                <div style="display: flex; gap: 0.5rem; margin-top: 0.25rem;">
                                                    <c:if test="${booking.status == 'Pending Payment'}">
                                                        <a href="${pageContext.request.contextPath}/customer/bookings?action=pay&bookingId=${booking.bookingId}" class="btn btn-primary" style="background: var(--orange); border-color: var(--orange); font-size: 0.75rem; padding: 0.25rem 0.5rem; border-radius: var(--radius-md);">
                                                            Pay
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${booking.status == 'Paid' || booking.status == 'Pending Payment'}">
                                                        <button type="button" class="btn btn-ghost btn-sm"
                                                            style="color: var(--color-red); font-size: 0.75rem; padding: 0.25rem 0.5rem;"
                                                            onclick="triggerCancelModal('${booking.bookingId}', '${booking.brand} ${booking.carName}', '${booking.startDate}')">
                                                            Cancel
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </c:forEach>
                            </c:if>

                    </div>
                </div>
                </div>

                <!-- Cancellation Confirmation Modal () -->
                <div id="cancelModal" class="modal-overlay">
                    <div class="modal-content">
                        <h3 style="color: var(--color-white); font-size: 1.25rem; margin-bottom: 0.75rem;">
                            Confirm Booking Cancellation
                        </h3>
                        <p
                            style="color: var(--color-gray-light); font-size: 0.9rem; margin-bottom: 1rem; line-height: 1.5;">
                            Are you sure you want to cancel reservation for <strong id="cancelTargetCar"
                                style="color: var(--color-white);"></strong>?
                        </p>

                        <div
                            style="background: var(--color-dark-surface); border: 1px solid var(--color-dark-border); border-radius: var(--radius-lg); padding: var(--space-4); margin-bottom: 1.5rem; font-size: 0.85rem; color: var(--color-gold);">
                            ℹ️ <strong>VNPAY Automated Refund Policy:</strong>
                            <br />
                            • Cancellations requested <strong>at least 1 hour prior to pickup</strong> are eligible for
                            a 100% automated VNPAY refund.
                            <br />
                            • Cancellations made within less than 1 hour notice are non-refundable.
                        </div>

                        <form action="${pageContext.request.contextPath}/customer/bookings" method="post">
                            <input type="hidden" name="action" value="cancel" />
                            <input type="hidden" name="bookingId" id="cancelBookingId" value="" />

                            <div style="display: flex; justify-content: flex-end; gap: var(--space-3);">
                                <button type="button" class="btn btn-ghost btn-sm" onclick="closeCancelModal()">
                                    Keep Booking
                                </button>
                                <button type="submit" class="btn btn-blue btn-sm"
                                    style="background: var(--color-red); border-color: var(--color-red);">
                                    Confirm Cancellation
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                 <script>
                     function triggerCancelModal(bookingId, carName, startDate) {
                         document.getElementById('cancelBookingId').value = bookingId;
                         document.getElementById('cancelTargetCar').textContent = carName;
                         document.getElementById('cancelModal').style.display = 'flex';
                     }

                     function closeCancelModal() {
                         document.getElementById('cancelModal').style.display = 'none';
                     }

                     // Real-time client-side filter (ghi tới đâu search tới đó)
                     const searchInput = document.getElementById('bookingSearchInput');
                     if (searchInput) {
                         searchInput.addEventListener('input', function () {
                             const filterVal = this.value.toLowerCase().trim();
                             const cards = document.querySelectorAll('.booking-card');
                             let hasMatch = false;

                             cards.forEach(card => {
                                 const textContent = card.textContent.toLowerCase();
                                 if (textContent.includes(filterVal)) {
                                     card.style.display = 'flex';
                                     hasMatch = true;
                                 } else {
                                     card.style.display = 'none';
                                 }
                             });

                             // Hiển thị thông báo trống nếu không tìm thấy
                             let emptySearchMsg = document.getElementById('emptySearchMessage');
                             if (!hasMatch) {
                                 if (!emptySearchMsg) {
                                     emptySearchMsg = document.createElement('div');
                                     emptySearchMsg.id = 'emptySearchMessage';
                                     emptySearchMsg.style.textAlign = 'center';
                                     emptySearchMsg.style.padding = '3rem';
                                     emptySearchMsg.style.background = 'var(--color-dark-card)';
                                     emptySearchMsg.style.border = '1px solid var(--color-dark-border)';
                                     emptySearchMsg.style.borderRadius = 'var(--radius-xl)';
                                     emptySearchMsg.style.margin = '2rem 0';
                                     emptySearchMsg.innerHTML = `
                                         <div style="margin-bottom: 1rem;"><i class="bi bi-search" style="font-size: 3rem; color: var(--color-gray-mid);"></i></div>
                                         <h3 style="color: var(--color-white); font-size: 1.2rem; margin-bottom: 0.5rem;">No bookings match your search</h3>
                                         <p style="color: var(--color-gray-mid); font-size: 0.9rem;">Try adjusting your keywords or clearing the search box.</p>
                                     `;
                                     const filterPanel = document.querySelector('.filter-panel');
                                     filterPanel.parentNode.insertBefore(emptySearchMsg, filterPanel.nextSibling);
                                 } else {
                                     emptySearchMsg.style.display = 'block';
                                 }
                             } else {
                                 if (emptySearchMsg) {
                                     emptySearchMsg.style.display = 'none';
                                 }
                             }
                         });
                     }
                 </script>

                <jsp:include page="/WEB-INF/views/common/footer.jsp" />

            </body>

            </html>