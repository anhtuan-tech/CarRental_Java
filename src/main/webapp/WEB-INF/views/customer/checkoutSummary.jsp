<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Checkout Summary & VNPAY Payment - CarRental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <style>
        .checkout-card {
            background: var(--color-dark-card);
            border: 1px solid var(--color-dark-border);
            border-radius: var(--radius-xl);
            padding: var(--space-8);
            max-width: 750px;
            margin: var(--space-8) auto;
            position: relative;
        }

        .summary-header {
            border-bottom: 1px solid var(--color-dark-border);
            padding-bottom: var(--space-6);
            margin-bottom: var(--space-6);
        }

        .summary-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--space-6);
            margin-bottom: var(--space-6);
        }

        @media (max-width: 576px) {
            .summary-grid {
                grid-template-columns: 1fr;
            }
        }

        .summary-box {
            background: var(--color-dark-surface);
            border: 1px solid var(--color-dark-border);
            border-radius: var(--radius-lg);
            padding: var(--space-4);
        }

        .summary-label {
            font-size: 0.75rem;
            color: var(--color-gray-light);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            display: block;
            margin-bottom: var(--space-1);
        }

        .summary-value {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--color-white);
        }

        .financial-receipt {
            background: var(--color-dark-surface);
            border: 1px dashed var(--color-gold);
            border-radius: var(--radius-xl);
            padding: var(--space-6);
            margin-bottom: var(--space-8);
        }

        .receipt-row {
            display: flex;
            justify-content: space-between;
            padding: var(--space-2) 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 0.95rem;
            color: var(--color-gray-light);
        }

        .receipt-row:last-child {
            border-bottom: none;
        }

        .receipt-total {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--color-gold);
            padding-top: var(--space-4);
            border-top: 1px solid var(--color-dark-border);
            margin-top: var(--space-2);
        }

        .vnpay-btn {
            background: linear-gradient(135deg, #005baa, #0088ff);
            color: #ffffff;
            border: none;
            border-radius: var(--radius-lg);
            padding: var(--space-4) var(--space-8);
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            transition: var(--transition-fast);
            box-shadow: 0 4px 15px rgba(0, 136, 255, 0.3);
        }

        .vnpay-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 136, 255, 0.5);
        }
    </style>
</head>

<body>

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="page-wrapper">
        <div class="container">
            <div class="checkout-card">

                <div class="summary-header text-center">
                    <span style="font-size: 2.5rem; display: block; margin-bottom: 0.5rem;">💳</span>
                    <h1 style="color: var(--color-white); font-size: 1.75rem; font-weight: 800; margin-bottom: 0.25rem;">
                        Reservation Checkout Summary
                    </h1>
                    <p style="color: var(--color-gray-light); font-size: 0.9rem;">
                        Review your vehicle reservation parameters before initiating secure VNPAY Sandbox payment ().
                    </p>
                </div>

                <!-- Vehicle Info -->
                <div class="summary-grid">
                    <div class="summary-box">
                        <span class="summary-label">Vehicle Selected</span>
                        <div class="summary-value">
                            <c:out value="${car.brand}" /> <c:out value="${car.carName}" />
                        </div>
                        <span style="font-size: 0.8rem; color: var(--color-gray-mid); font-family: monospace;">
                            <c:out value="${car.licensePlate}" />
                        </span>
                    </div>

                    <div class="summary-box">
                        <span class="summary-label">Daily Rental Rate</span>
                        <div class="summary-value" style="color: var(--color-gold);">
                            <fmt:formatNumber value="${car.pricePerDay}" type="number" groupingUsed="true"/> VND / day
                        </div>
                    </div>

                    <div class="summary-box">
                        <span class="summary-label">Pick-up Date & Time</span>
                        <div class="summary-value">
                            <fmt:parseDate value="${startDateStr}" pattern="yyyy-MM-dd'T'HH:mm" var="sDate" type="both" />
                            <fmt:formatDate value="${sDate}" pattern="dd/MM/yyyy HH:mm" />
                        </div>
                    </div>

                    <div class="summary-box">
                        <span class="summary-label">Return Date & Time</span>
                        <div class="summary-value">
                            <fmt:parseDate value="${endDateStr}" pattern="yyyy-MM-dd'T'HH:mm" var="eDate" type="both" />
                            <fmt:formatDate value="${eDate}" pattern="dd/MM/yyyy HH:mm" />
                        </div>
                    </div>
                </div>

                <!-- Financial Calculation Receipt (BR3 & Financial Specifications) -->
                <div class="financial-receipt">
                    <h4 style="color: var(--color-white); font-size: 1.05rem; margin-bottom: 1rem; border-bottom: 1px solid var(--color-dark-border); padding-bottom: 0.5rem;">
                        Financial Breakdown & Platform Fee
                    </h4>

                    <div class="receipt-row">
                        <span>Total Rental Duration:</span>
                        <strong style="color: var(--color-white);"><c:out value="${totalDays}" /> Days</strong>
                    </div>

                    <div class="receipt-row">
                        <span>Rental Subtotal:</span>
                        <span><fmt:formatNumber value="${subtotalFee}" type="number" groupingUsed="true"/> VND</span>
                    </div>

                    <div class="receipt-row">
                        <span>Platform Commission (10% Fee):</span>
                        <span style="color: var(--color-gray-mid);"><fmt:formatNumber value="${platformCommission}" type="number" groupingUsed="true"/> VND</span>
                    </div>

                    <div class="receipt-row">
                        <span>Fleet Owner Net Payout (90%):</span>
                        <span style="color: var(--color-gray-mid);"><fmt:formatNumber value="${ownerPayout}" type="number" groupingUsed="true"/> VND</span>
                    </div>

                    <div class="receipt-row receipt-total">
                        <span style="color: var(--color-white);">Total Advance Payment:</span>
                        <span><fmt:formatNumber value="${subtotalFee}" type="number" groupingUsed="true"/> VND</span>
                    </div>
                </div>

                <!-- Form Submit to Gateway () -->
                <form action="${pageContext.request.contextPath}/customer/bookings" method="post">
                    <input type="hidden" name="action" value="confirmCheckout" />
                    <input type="hidden" name="carId" value="${car.carId}" />
                    <input type="hidden" name="startDate" value="${startDateStr}" />
                    <input type="hidden" name="endDate" value="${endDateStr}" />

                    <button type="submit" class="vnpay-btn">
                        <span>💳</span>
                        <span>Thanh toán qua VNPay</span>
                    </button>
                </form>

                <div class="text-center" style="margin-top: 1rem;">
                    <a href="${pageContext.request.contextPath}/cars?action=detail&carId=${car.carId}" class="btn btn-ghost btn-sm">
                        ← Back to Vehicle Details
                    </a>
                </div>

            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>
