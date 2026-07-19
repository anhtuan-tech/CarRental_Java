<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Staff Control #ID ${staffDetail.userId} - CarRental Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
                <style>
                    .detail-card {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-8);
                        max-width: 700px;
                        margin: var(--space-8) auto;
                    }

                    .form-row {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: var(--space-6);
                    }

                    @media (max-width: 576px) {
                        .form-row {
                            grid-template-columns: 1fr;
                        }
                    }

                    .status-badge {
                        display: inline-block;
                        font-size: 0.75rem;
                        font-weight: 600;
                        padding: var(--space-1) var(--space-3);
                        border-radius: var(--radius-full);
                        text-transform: uppercase;
                    }

                    .status-badge.active {
                        background: rgba(16, 185, 129, 0.1);
                        color: #10B981;
                        border: 1px solid rgba(16, 185, 129, 0.2);
                    }

                    .status-badge.suspended {
                        background: rgba(245, 158, 11, 0.1);
                        color: #F59E0B;
                        border: 1px solid rgba(245, 158, 11, 0.2);
                    }

                    .status-badge.blocked {
                        background: rgba(239, 68, 68, 0.1);
                        color: #EF4444;
                        border: 1px solid rgba(239, 68, 68, 0.2);
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/WEB-INF/views/common/header.jsp" />

                <div class="page-wrapper">
                    <div class="container">

                        <!-- Breadcrumbs -->
                        <div class="mb-4">
                            <a href="${pageContext.request.contextPath}/admin/staff?action=list"
                                style="color:var(--color-gray-light); font-size:0.9rem; font-weight:500;">← Back to
                                Staff Index</a>
                        </div>

                        <c:choose>
                            <c:when test="${not empty staffDetail}">
                                <div class="detail-card">

                                    <div class="mb-4"
                                        style="display:flex; justify-content:space-between; align-items:center;">
                                        <div>
                                            <h1 class="hero-title"
                                                style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">
                                                Manage <span>Staff Profile</span></h1>
                                            <p class="text-muted text-sm">Account Reference ID: #
                                                <c:out value="${staffDetail.userId}" />
                                            </p>
                                        </div>
                                        <div
                                            class="status-badge ${staffDetail.status == 'Active' ? 'active' : (staffDetail.status == 'Suspended' ? 'suspended' : 'blocked')}">
                                            <c:out value="${staffDetail.status}" />
                                        </div>
                                    </div>
                                    <div class="blue-line" style="margin-bottom: 2rem;"></div>

                                    <!-- Update Form () -->
                                    <form action="${pageContext.request.contextPath}/admin/staff?action=update"
                                        method="post" id="updateStaffForm">
                                        <input type="hidden" name="staffId" value="${staffDetail.userId}" />

                                        <div class="form-row">
                                            <div class="form-group">
                                                <label for="fullName" class="form-label">Full Name <span
                                                        class="required">*</span></label>
                                                <input type="text" name="fullName" id="fullName" class="form-control"
                                                    value="<c:out value='${staffDetail.fullName}'/>" required />
                                            </div>

                                            <div class="form-group">
                                                <label for="email" class="form-label">Email Address <span
                                                        class="required">*</span></label>
                                                <input type="email" name="email" id="email" class="form-control"
                                                    value="<c:out value='${staffDetail.email}'/>" required />
                                            </div>
                                        </div>

                                        <div class="form-row" style="margin-top:var(--space-2);">
                                            <div class="form-group">
                                                <label for="phoneNumber" class="form-label">Phone Number <span
                                                        class="required">*</span></label>
                                                <input type="text" name="phoneNumber" id="phoneNumber"
                                                    class="form-control"
                                                    value="<c:out value='${staffDetail.phoneNumber}'/>" required />
                                            </div>

                                            <div class="form-group">
                                                <label for="status" class="form-label">Account Status <span
                                                        class="required">*</span></label>
                                                <select name="status" id="status" class="form-control"
                                                    style="background:var(--color-dark-surface); border-color:var(--color-dark-border); color:var(--color-white);">
                                                    <option value="Active" ${staffDetail.status=='Active' ? 'selected'
                                                        : '' }>Active</option>
                                                    <option value="Suspended" ${staffDetail.status=='Suspended'
                                                        ? 'selected' : '' }>Suspended</option>
                                                    <option value="Blocked" ${staffDetail.status=='Blocked' ? 'selected'
                                                        : '' }>Blocked</option>
                                                </select>
                                            </div>
                                        </div>

                                        <!-- BR95: Password remains securely hidden and never exposed to the UI -->
                                        <div class="form-group" style="margin-top:var(--space-2);">
                                            <label class="form-label">Account Password</label>
                                            <input type="text" class="form-control text-muted"
                                                value="<c:out value='${staffDetail.password}'/>" readonly
                                                style="background:var(--color-dark-surface); border-color:var(--color-dark-border); cursor:not-allowed;" />
                                            <span class="form-hint">Admin security note: Password hashing matches
                                                SHA-256 standards and cannot be read.</span>
                                        </div>

                                        <!-- Submit and cancellation actions -->
                                        <div
                                            style="margin-top:2rem; display:flex; justify-content:space-between; align-items:center;">
                                            <div style="display:flex; gap:var(--space-3);">
                                                <button type="submit" class="btn btn-blue btn-sm">Save Changes</button>
                                                <a href="${pageContext.request.contextPath}/admin/staff?action=list"
                                                    class="btn btn-ghost btn-sm"
                                                    style="display:flex; align-items:center;">Cancel</a>
                                            </div>
                                        </div>
                                    </form>

                                    <div class="blue-line" style="margin-top:2.5rem; margin-bottom:1.5rem;"></div>

                                    <!-- Soft Delete Account Form () -->
                                    <div
                                        style="background:rgba(239, 68, 68, 0.05); border:1px solid rgba(239, 68, 68, 0.2); border-radius:var(--radius-xl); padding:var(--space-6);">
                                        <h3
                                            style="color:var(--color-white); font-size:1.1rem; margin-bottom:var(--space-2);">
                                            Deactivate Staff Account</h3>
                                        <p class="text-xs text-muted" style="margin-bottom:var(--space-4);">
                                            Soft-delete setting limits access immediately. The database record will be
                                            flagged as 'Inactive' to preserve system audit logs.
                                        </p>

                                        <form action="${pageContext.request.contextPath}/admin/staff?action=delete"
                                            method="post" id="deleteStaffForm">
                                            <input type="hidden" name="staffId" value="${staffDetail.userId}" />
                                            <!-- BR92 check built into form submission warning -->
                                            <button type="submit" class="btn btn-sm"
                                                style="background:var(--color-red); color:var(--color-white);">Deactivate
                                                Account</button>
                                        </form>
                                    </div>

                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-state-icon"><i class="bi bi-shield-slash"></i></div>
                                    <div class="empty-state-title">No staff available</div>
                                    <p class="text-muted text-sm" style="margin-top:0.5rem;">The requested personnel
                                        profile could not be loaded.</p>
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

                    document.getElementById('updateStaffForm').addEventListener('submit', function (e) {
                        var email = document.getElementById('email').value.trim();
                        var phone = document.getElementById('phoneNumber').value.trim();
                        var name = document.getElementById('fullName').value.trim();

                        if (!email || !phone || !name) {
                            e.preventDefault();
                            showToast('All fields marked with an asterisk (*) are mandatory.', 'error');
                            return;
                        }

                        var phonePattern = /^[0-9]{10,11}$/;
                        if (!phonePattern.test(phone)) {
                            e.preventDefault();
                            showToast('Invalid phone number format. Please insert 10 or 11 numeric digits.', 'error');
                        }
                    });

                    document.getElementById('deleteStaffForm').addEventListener('submit', function (e) {
                        if (!confirm('Are you sure you want to deactivate this staff account? Access to the dashboard will be disabled.')) {
                            e.preventDefault();
                        }
                    });
                </script>
            </body>

            </html>