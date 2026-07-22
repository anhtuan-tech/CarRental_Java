<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Car Detail - CarRental Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1"/>
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
        .admin-container {
            max-width: 100%;
            margin: 0 auto;
            padding: 0 var(--space-4);
        }
    </style>
    <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="mgmt-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/common/staffSidebar.jsp">
        <jsp:param name="activeMenu" value="cars" />
    </jsp:include>

    <!-- Main Content -->
    <main class="mgmt-content">
        <div class="admin-container">



        <c:choose>
            <c:when test="${not empty carDetail}">
                <div class="detail-card">
                    
                    <div class="mb-4" style="display:flex; justify-content:space-between; align-items:center;">
                        <div>
                            <h1 class="hero-title" style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">Car <span>Detail</span></h1>
                        </div>
                        <div class="status-badge ${carDetail.status == 'Approved' ? 'approved' : (carDetail.status == 'Rejected' ? 'rejected' : 'pending')}">
                            <c:out value="${carDetail.status}"/>
                        </div>
                    </div>
                    <div class="blue-line" style="margin-bottom: 2rem;"></div>

                    <!-- Car Image Banner -->
                    <c:choose>
                        <c:when test="${not empty carDetail.primaryImageUrl}">
                            <div style="margin-bottom: 2rem; border-radius: var(--radius-xl); overflow: hidden; border: 1px solid var(--color-dark-border); box-shadow: var(--shadow-md);">
                                <img src="${pageContext.request.contextPath}${carDetail.primaryImageUrl}" style="width: 100%; height: 380px; object-fit: cover; display: block;" alt="Car Image" />
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="margin-bottom: 2rem; border-radius: var(--radius-xl); height: 200px; background: var(--color-dark-surface); border: 1px solid var(--color-dark-border); display: flex; align-items: center; justify-content: center; color: var(--color-gray-light); font-size: 3rem;">
                                <i class="bi bi-car-front-fill"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>

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
                            <span class="info-label">Car Category</span>
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

                    <!-- Specs parsed from JSON -->
                    <div class="form-group" style="margin-top: var(--space-2);">
                        <span class="info-label" style="margin-bottom:0.5rem; display:block;">Vehicle Specifications</span>
                        <!-- Raw JSON stored for JS to parse -->
                        <script type="application/json" id="specsData">${carDetail.specsJson}</script>
                        <div id="specsGrid" class="info-grid" style="margin-bottom:0; margin-top:0.5rem;"></div>
                    </div>
                    <!-- Verification status mutation workflows -->
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
                                <button type="submit" name="status" value="Available" class="btn btn-blue btn-sm" onclick="setRejectRequired(false)">Approve & Make Available</button>
                                <button type="button" class="btn btn-ghost btn-sm" style="color:var(--color-red);" id="rejectTriggerBtn" onclick="toggleRejectionView()">Reject Application</button>
                                <button type="submit" name="status" value="Rejected" class="btn btn-blue btn-sm" style="background:var(--color-red); color:var(--color-white); display:none;" id="submitRejectBtn" onclick="setRejectRequired(true)">Confirm Rejection</button>
                            </div>
                        </form>
                    </div>

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
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
                    <script>
                        

    var rejectRequired = false;

    function setRejectRequired(val) {
        rejectRequired = val;
    }

    function toggleRejectionView() {
        document.getElementById('rejectionField').style.display = 'block';
        document.getElementById('rejectTriggerBtn').style.display = 'none';
        document.getElementById('submitRejectBtn').style.display = 'inline-block';
    }

    // Parse specs JSON and render as key-value grid
    (function() {
        var scriptEl = document.getElementById('specsData');
        var container = document.getElementById('specsGrid');
        if (!scriptEl || !container) return;
        var friendlyLabels = {
            'Transmission': 'Transmission',
            'Fuel': 'Fuel Type',
            'Seats': 'Seats',
            'Consumption': 'Fuel Consumption',
            'Color': 'Color',
            'Year': 'Production Year',
            'Engine': 'Engine',
            'Drive': 'Drivetrain'
        };
        try {
            var specs = JSON.parse(scriptEl.textContent || scriptEl.innerHTML);
            Object.keys(specs).forEach(function(key) {
                var item = document.createElement('div');
                item.className = 'info-item';
                var label = friendlyLabels[key] || key;
                item.innerHTML = '<span class="info-label">' + label + '</span>' +
                                  '<span class="info-value">' + specs[key] + '</span>';
                container.appendChild(item);
            });
        } catch(e) {
            container.innerHTML = '<p class="text-muted text-sm">No specifications available.</p>';
        }
    })();

    // Verification form guard (only exists when status is Pending)
    var form = document.getElementById('verificationForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            if (rejectRequired) {
                var reason = document.getElementById('reason').value.trim();
                if (!reason) {
                    e.preventDefault();
                    showToast('A reason note is required to reject vehicle applications.', 'error');
                }
            }
        });
    }
</script>
</body>
</html>
