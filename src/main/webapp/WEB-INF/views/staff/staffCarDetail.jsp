<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Verify Specs #ID ${carDetail.carId} - CarRental Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        .detail-card {
            background: var(--color-dark-card);
            border: 1px solid var(--color-dark-border);
            border-radius: var(--radius-xl);
            padding: var(--space-8);
            max-width: 750px;
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
        .status-badge.approved {
            background: rgba(16, 185, 129, 0.1);
            color: #10B981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        .status-badge.rejected {
            background: rgba(239, 68, 68, 0.1);
            color: #EF4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
        .reason-field {
            display: none;
            margin-top: var(--space-4);
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="page-wrapper">
    <div class="container">

        <!-- Breadcrumbs -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/staff/cars?action=list" style="color:var(--color-gray-light); font-size:0.9rem; font-weight:500;">← Back to Master List</a>
        </div>

        <c:choose>
            <c:when test="${not empty carDetail}">
                <div class="detail-card">
                    
                    <div class="mb-4" style="display:flex; justify-content:space-between; align-items:center;">
                        <div>
                            <h1 class="hero-title" style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">Vehicle <span>Verification</span></h1>
                            <p class="text-muted text-sm">Vehicle Reference ID: #<c:out value="${carDetail.carId}"/></p>
                        </div>
                        <div class="status-badge ${carDetail.status == 'Approved' ? 'approved' : (carDetail.status == 'Rejected' ? 'rejected' : 'pending')}">
                            <c:out value="${carDetail.status}"/>
                        </div>
                    </div>
                    <div class="blue-line" style="margin-bottom: 2rem;"></div>

                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Vehicle Name & Brand</span>
                            <span class="info-value"><c:out value="${carDetail.brand}"/> <c:out value="${carDetail.carName}"/></span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">License Plate</span>
                            <span class="info-value"><c:out value="${carDetail.licensePlate}"/></span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Partner Owner</span>
                            <span class="info-value"><c:out value="${carDetail.ownerName}"/></span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Category Category</span>
                            <span class="info-value"><c:out value="${carDetail.typeName}"/></span>
                        </div>

                        <div class="info-item">
                            <span class="info-label">Rental Price Rate</span>
                            <span class="info-value"><fmt:formatNumber value="${carDetail.pricePerDay}" type="number" groupingUsed="true"/> VND / day</span>
                        </div>

                        <!-- BR84: Original unmasked vehicle registration link strictly visible for admins -->
                        <div class="info-item">
                            <span class="info-label">Unmasked Registration Document</span>
                            <span class="info-value">
                                <a href="<c:out value='${carDetail.documentUrl}'/>" target="_blank" style="color:var(--color-blue-light); text-decoration:underline; font-size:0.95rem;">
                                    View Registration Document 🔗
                                </a>
                            </span>
                        </div>
                    </div>

                    <div class="form-group">
                        <span class="info-label" style="margin-bottom:0.25rem;">Specs Attributes (JSON)</span>
                        <div style="background:var(--color-dark-surface); border:1px solid var(--color-dark-border); border-radius:var(--radius-lg); padding:var(--space-4); font-family:monospace; font-size:0.85rem; color:var(--color-white-soft);">
                            <c:out value="${carDetail.specsJson}"/>
                        </div>
                    </div>

                    <!-- Verification status mutation workflows -->
                    <c:choose>
                        <c:when test="${carDetail.status == 'Pending_Approval' || carDetail.status == 'Pending'}">
                            <div style="background:var(--color-dark-surface); border:1px solid var(--color-dark-border); border-radius:var(--radius-xl); padding:var(--space-6); margin-top:2rem;">
                                <h3 style="color:var(--color-white); font-size:1.1rem; margin-bottom:var(--space-2);">Process Application</h3>
                                <p class="text-xs text-muted" style="margin-bottom:var(--space-4);">Evaluate documentation and set approval resolution state.</p>
                                
                                <form action="${pageContext.request.contextPath}/staff/cars?action=update" method="post" id="verificationForm">
                                    <input type="hidden" name="carId" value="${carDetail.carId}"/>
                                    
                                    <!-- Rejection Reason note required on reject -->
                                    <div id="rejectionField" class="form-group reason-field" style="display:none; margin-top: var(--space-4);">
                                        <label for="reason" class="form-label" style="color:var(--color-red);">Rejection Reason Note <span class="required">*</span></label>
                                        <textarea name="reason" id="reason" class="form-control" rows="3" placeholder="Explain missing papers, duplicate license plates, incorrect specification values..." style="resize:none; padding:var(--space-3); border-color:rgba(239, 68, 68, 0.4);"></textarea>
                                        <span class="form-hint" style="color:var(--color-red);">Reason note is mandatory on application rejection.</span>
                                    </div>

                                    <div style="display:flex; gap:var(--space-3); margin-top:1.5rem;">
                                        <!-- Submit button changes targetStatus -->
                                        <button type="submit" name="status" value="Approved" class="btn btn-blue btn-sm" onclick="setRejectRequired(false)">Approve Vehicle</button>
                                        <button type="button" class="btn btn-ghost btn-sm" style="color:var(--color-red);" id="rejectTriggerBtn" onclick="toggleRejectionView()">Reject Application</button>
                                        <button type="submit" name="status" value="Rejected" class="btn btn-blue btn-sm" style="background:var(--color-red); color:var(--color-white); display:none;" id="submitRejectBtn" onclick="setRejectRequired(true)">Confirm Rejection</button>
                                    </div>
                                </form>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align:center; padding:var(--space-6); background:var(--color-dark-surface); border:1px solid var(--color-dark-border); border-radius:var(--radius-lg); color:var(--color-gray-light); font-size:0.9rem; margin-top:2rem;">
                                Verification has been completed for this vehicle application. Status is locked.
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon"><i class="bi bi-shield-slash"></i></div>
                    <div class="empty-state-title">No car available</div>
                    <p class="text-muted text-sm" style="margin-top:0.5rem;">The requested vehicle specifications could not be resolved.</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
                    <script>
                        (function () {
                            var el = document.getElementById('toast-data');
                            if (el) {
                                var err = el.getAttribute('data-error');
                                var succ = el.getAttribute('data-success');
                                var sessSucc = el.getAttribute('data-session-success');
                                var sessErr = el.getAttribute('data-session-error');

                                if (err && err.trim() !== '') showToast(err, 'error');
                                if (succ && succ.trim() !== '') showToast(succ, 'success');
                                if (sessSucc && sessSucc.trim() !== '') showToast(sessSucc, 'success');
                                if (sessErr && sessErr.trim() !== '') showToast(sessErr, 'error');
                            }
                        })();

    var rejectRequired = false;

    function setRejectRequired(val) {
        rejectRequired = val;
    }

    function toggleRejectionView() {
        document.getElementById('rejectionField').style.display = 'block';
        document.getElementById('rejectTriggerBtn').style.display = 'none';
        document.getElementById('submitRejectBtn').style.display = 'inline-block';
    }

    document.getElementById('verificationForm').addEventListener('submit', function(e) {
        if (rejectRequired) {
            var reason = document.getElementById('reason').value.trim();
            if (!reason) {
                e.preventDefault();
                showToast('A reason note is required to reject vehicle applications.', 'error');
            }
        }
    });
</script>
</body>
</html>
