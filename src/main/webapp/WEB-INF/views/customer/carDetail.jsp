<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta name="description" content="Renting details of ${car.carName}."/>
        <title>${car.carName} - Details - Car Rental</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1"/>
        <style>
            /* Details specific layouts */
            .detail-grid {
                display: grid;
                grid-template-columns: 7fr 5fr;
                gap: var(--space-8);
                margin-top: var(--space-6);
            }
            @media (max-width: 992px) {
                .detail-grid {
                    grid-template-columns: 1fr;
                }
            }
            .gallery-main {
                width: 100%;
                height: 450px;
                border-radius: var(--radius-xl);
                overflow: hidden;
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                position: relative;
            }
            .gallery-main img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .gallery-thumbs {
                display: flex;
                gap: var(--space-3);
                margin-top: var(--space-3);
                overflow-x: auto;
                padding-bottom: var(--space-2);
            }
            .thumb-item {
                width: 100px;
                height: 70px;
                border-radius: var(--radius-md);
                overflow: hidden;
                border: 2px solid transparent;
                cursor: pointer;
                flex-shrink: 0;
                transition: var(--transition-fast);
            }
            .thumb-item img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .thumb-item.active {
                border-color: var(--color-blue);
            }
            .spec-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: var(--space-4);
            }
            .spec-table td {
                padding: var(--space-3) 0;
                border-bottom: 1px solid var(--color-dark-border);
                color: var(--color-white-soft);
            }
            .spec-table td.label {
                color: var(--color-gray-light);
                font-weight: 500;
                width: 40%;
            }
            /* Sticky Booking Panel */
            .booking-panel {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-8);
                position: sticky;
                top: calc(var(--navbar-height) + var(--space-6));
            }
            /* Reviews Section styling */
            .reviews-section {
                margin-top: var(--space-16);
                border-top: 1px solid var(--color-dark-border);
                padding-top: var(--space-10);
            }
            .review-item {
                border-bottom: 1px solid var(--color-dark-border);
                padding: var(--space-6) 0;
            }
            .review-item:last-child {
                border-bottom: none;
            }
            .review-meta {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: var(--font-size-sm);
                margin-bottom: var(--space-2);
            }
            .review-author {
                font-weight: 600;
                color: var(--color-white);
            }
            .review-date {
                color: var(--color-gray-light);
            }
            .review-rating {
                color: var(--color-gray-mid);
                margin-bottom: var(--space-3);
            }
            .review-rating .star {
                font-size: 1.1rem;
                margin-right: 2px;
            }
            .review-rating .star.filled {
                color: var(--color-blue-light);
            }
            .review-comment {
                color: var(--color-white-soft);
                font-size: var(--font-size-base);
                line-height: 1.6;
            }
            .review-reply {
                margin-top: var(--space-4);
                background: var(--color-dark-surface);
                border-left: 3px solid var(--color-blue);
                padding: var(--space-4);
                border-radius: 0 var(--radius-md) var(--radius-md) 0;
            }
            .reply-header {
                font-size: var(--font-size-xs);
                font-weight: 600;
                color: var(--color-blue-light);
                margin-bottom: var(--space-1);
            }
            .reply-content {
                color: var(--color-gray-light);
                font-size: var(--font-size-sm);
            }
            .load-more-container {
                display: flex;
                justify-content: center;
                margin-top: var(--space-8);
            }
        </style>
        <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>
    <body>

        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="page-wrapper">
            <div class="container mt-4">



                <h1 class="hero-title" style="font-size: 2.25rem; margin-bottom: 0.5rem; text-align: left;">
                    <c:out value="${car.carName}"/>
                </h1>
                <p class="text-muted text-sm" style="margin-bottom: var(--space-4);">
                    <strong style="color:var(--color-blue-light);"><c:out value="${car.typeName}"/></strong>   License Plate: <c:out value="${car.licensePlate}"/>
                </p>

                <!-- Main Detail Grid -->
                <div class="detail-grid">

                    <!-- Left Panel: Media and specs -->
                    <div>
                        <div class="gallery-main">
                            <c:choose>
                                <c:when test="${not empty carImages}">
                                    <img id="mainGalleryImg" src="${pageContext.request.contextPath}${carImages[0].imageUrl}" alt="${car.carName}"/>
                                </c:when>
                                <c:otherwise>
                                    <div class="car-card-placeholder"><i class="bi bi-car-front-fill" style="font-size:3rem; color:var(--color-gray-mid);"></i></div>
                                    </c:otherwise>
                                </c:choose>
                        </div>

                        <c:if test="${not empty carImages and carImages.size() > 1}">
                            <div class="gallery-thumbs">
                                <c:forEach var="img" items="${carImages}" varStatus="status">
                                    <div class="thumb-item ${status.index == 0 ? 'active' : ''}" onclick="swapGalleryImage(this, '${pageContext.request.contextPath}${img.imageUrl}')">
                                        <img src="${pageContext.request.contextPath}${img.imageUrl}" alt="Thumbnail ${status.index}"/>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <h3 style="margin-top: var(--space-10); margin-bottom: var(--space-4);">Specifications</h3>
                        <div class="blue-line"></div>

                        <table class="spec-table">
                            <tr>
                                <td class="label">Brand</td>
                                <td><c:out value="${car.brand}"/></td>
                            </tr>
                            <tr>
                                <td class="label">Model Year</td>
                                <td><c:out value="${car.model}"/></td>
                            </tr>
                            <tr>
                                <td class="label">License Plate</td>
                                <td><c:out value="${car.licensePlate}"/></td>
                            </tr>
                            <tr>
                                <td class="label">Availability Status</td>
                                <td>
                                    <span class="car-badge" style="position:static; padding:var(--space-1) var(--space-3);">
                                        <c:out value="${car.status}"/>
                                    </span>
                                </td>
                        </table>
                        <script type="application/json" id="specsData">${car.specsJson}</script>
                    </div>

                    <!-- Right Panel: Sticky Booking card -->
                    <div>
                        <div class="booking-panel">
                            <h3 style="font-size: 1.25rem; margin-bottom: var(--space-2);">Rental Rates</h3>
                            <div style="font-size: 2.25rem; font-weight: 800; color: var(--color-blue-light); margin-bottom: var(--space-1);">
                                <fmt:formatNumber value="${car.pricePerDay}" type="number" groupingUsed="true"/> VND
                            </div>
                            <p class="text-muted text-sm" style="margin-bottom: var(--space-8);">/ day</p>

                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <form action="${pageContext.request.contextPath}/customer/bookings" method="post" style="display: flex; flex-direction: column; gap: var(--space-4);">
                                        <input type="hidden" name="action" value="submit" />
                                        <input type="hidden" name="carId" value="${car.carId}" />

                                        <div class="form-group mb-0">
                                            <label class="form-label" style="color: var(--color-white); font-size: 0.85rem;">Pick-up Date & Time</label>
                                            <input type="datetime-local" name="startDate" id="startDateInput" class="form-control" required style="height: 42px;" />
                                        </div>

                                        <div class="form-group mb-0">
                                            <label class="form-label" style="color: var(--color-white); font-size: 0.85rem;">Return Date & Time</label>
                                            <input type="datetime-local" name="endDate" id="endDateInput" class="form-control" required style="height: 42px;" />
                                        </div>

                                        <button type="submit" class="btn btn-blue btn-full btn-lg" style="margin-top: var(--space-2);">
                                            <i class="bi bi-credit-card-fill"></i> Reserve This Car
                                        </button>
                                    </form>

                                    <script>
                                        (function () {
                                            var now = new Date();
                                            now.setHours(now.getHours() + 1);
                                            var startIso = now.toISOString().slice(0, 16);

                                            var end = new Date(now);
                                            end.setDate(end.getDate() + 1);
                                            var endIso = end.toISOString().slice(0, 16);

                                            var sEl = document.getElementById('startDateInput');
                                            var eEl = document.getElementById('endDateInput');
                                            if (sEl && !sEl.value)
                                                sEl.value = startIso;
                                            if (eEl && !eEl.value)
                                                eEl.value = endIso;
                                        })();
                                    </script>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login/customer" class="btn btn-blue btn-full btn-lg">Login to Book Now</a>
                                </c:otherwise>
                            </c:choose>

                            <p class="text-sm text-muted text-center" style="margin-top: var(--space-4);">
                                Secured booking platform. 24/7 client protection.
                            </p>
                        </div>
                    </div>

                </div>

                <!-- Reviews Section -->
                <div class="reviews-section" id="reviews-section">
                    <h3 style="margin-bottom: var(--space-3);">Reviews (${totalFeedbacks})</h3>
                    <div class="blue-line"></div>

                    <div id="reviewsContainer" style="margin-top: var(--space-6);">
                        <c:choose>
                            <c:when test="${not empty feedbacks}">
                                <c:forEach var="feedback" items="${feedbacks}">
                                    <div class="review-item">
                                        <div class="review-meta">
                                            <span class="review-author">
                                                <c:out value="${feedback.reviewerName}"/>
                                            </span>
                                            <span class="review-date">
                                                <fmt:parseDate value="${feedback.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                                                <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy"/>
                                            </span>
                                        </div>
                                        <div class="review-rating">
                                            <c:forEach begin="1" end="5" var="i">
                                                <span class="star ${i <= feedback.rating ? 'filled' : ''}">★</span>
                                            </c:forEach>
                                        </div>
                                        <p class="review-comment">
                                            <c:out value="${feedback.comment}"/>
                                        </p>
                                        <c:if test="${not empty feedback.ownerReply}">
                                            <div class="review-reply">
                                                <div class="reply-header">💬 Response from Owner:</div>
                                                <p class="reply-content"><c:out value="${feedback.ownerReply}"/></p>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: var(--space-8) 0; text-align: left;">
                                    <div class="empty-state-title" style="font-size: var(--font-size-base);">No reviews yet</div>
                                    <p class="text-muted text-sm">Be the first to rent this vehicle and leave a feedback!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Load More reviews button -->
                    <c:if test="${totalFeedbacks > 5}">
                        <div class="load-more-container">
                            <button type="button" class="btn btn-ghost" id="loadMoreReviewsBtn">
                                Load More Reviews
                            </button>
                        </div>
                    </c:if>
                </div>

            </div>
        </div>



        <script>
            (function () {
                var scriptEl = document.getElementById('specsData');
                var table = document.querySelector('.spec-table');
                if (!scriptEl || !table)
                    return;
                var friendlyLabels = {
                    'Transmission': 'Transmission',
                    'Fuel': 'Fuel Type',
                    'Seats': 'Seats',
                    'Consumption': 'Fuel Consumption'
                };
                try {
                    var specs = JSON.parse(scriptEl.textContent || scriptEl.innerHTML);
                    Object.keys(specs).forEach(function (key) {
                        if (specs[key]) {
                            var row = document.createElement('tr');
                            var label = friendlyLabels[key] || key;
                            var val = specs[key];
                            row.innerHTML = '<td class="label">' + label + '</td>' +
                                    '<td>' + val + '</td>';
                            table.appendChild(row);
                        }
                    });
                } catch (e) {
                    console.log("No extra specs parsed", e);
                }
            })();
        </script>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </body>
</html>
