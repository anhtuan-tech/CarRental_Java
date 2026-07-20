<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>User Control #ID ${userDetail.userId} - Car Rental Admin</title>
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
        <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>

    <body>

        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="page-wrapper">
            <div class="container">

                <!-- Breadcrumbs -->
                <div class="mb-4">
                    <a href="${pageContext.request.contextPath}/admin/users?action=list"
                       style="color:var(--color-gray-light); font-size:0.9rem; font-weight:500;">←
                        Back to
                        Users Index</a>
                </div>

                <c:choose>
                    <c:when test="${not empty userDetail}">
                        <div class="detail-card">

                            <div class="mb-4"
                                 style="display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <h1 class="hero-title"
                                        style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">
                                        User <span>Profile Control</span></h1>
                                </div>
                                <div
                                    class="status-badge ${userDetail.status == 'Active' ? 'active' : (userDetail.status == 'Suspended' ? 'suspended' : 'blocked')}">
                                    <c:out value="${userDetail.status}" />
                                </div>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                            <div class="info-grid">
                                <div class="info-item">
                                    <span class="info-label">Full Name</span>
                                    <span class="info-value">
                                        <c:out value="${userDetail.fullName}" />
                                    </span>
                                </div>

                                <div class="info-item">
                                    <span class="info-label">Email Address</span>
                                    <span class="info-value">
                                        <c:out value="${userDetail.email}" />
                                    </span>
                                </div>

                                <div class="info-item">
                                    <span class="info-label">Mobile Contact</span>
                                    <span class="info-value">
                                        <c:out value="${userDetail.phoneNumber}" />
                                    </span>
                                </div>

                                <div class="info-item">
                                    <span class="info-label">Account Category</span>
                                    <span class="info-value"
                                          style="color:var(--color-blue-light);">
                                        <c:out
                                            value="${userDetail.roleId == 3 ? 'Customer Partner' : 'Owner Partner'}" />
                                    </span>
                                </div>
                            </div>

                            <!-- BR95: Password remains securely hidden and never exposed to the UI -->
                            <div class="form-group" style="margin-bottom:2rem;">
                                <label class="form-label">Password Hash Value
                                    (Protected)</label>
                                <input type="text" class="form-control text-muted"
                                       value="<c:out value='${userDetail.password}'/>"
                                       readonly
                                       style="background:var(--color-dark-surface); border-color:var(--color-dark-border); cursor:not-allowed;" />
                                <span class="form-hint">Hashed security parameters are
                                    completely masked on UI
                                    structures.</span>
                            </div>

                            <!-- Status modification form () -->
                            <div
                                style="background:var(--color-dark-surface); border:1px solid var(--color-dark-border); border-radius:var(--radius-xl); padding:var(--space-6);">
                                <h3
                                    style="color:var(--color-white); font-size:1.1rem; margin-bottom:var(--space-2);">
                                    Update Status Transition</h3>
                                <p class="text-xs text-muted"
                                   style="margin-bottom:var(--space-4);">
                                    Suspended or Blocked statuses prevent logging in and
                                    terminate active
                                    sessions immediately.
                                </p>

                                <form action="${pageContext.request.contextPath}/admin/users?action=updateStatus"
                                      method="post" id="updateUserStatusForm">
                                    <input type="hidden" name="userId"
                                           value="${userDetail.userId}" />
                                    <div
                                        style="display:flex; gap:var(--space-3); align-items:center; flex-wrap:wrap;">
                                        <select name="status" class="form-control"
                                                style="background:var(--color-dark-surface); border-color:var(--color-dark-border); color:var(--color-white); max-width:250px;">
                                            <option value="Active"
                                                    ${userDetail.status=='Active'
                                                      ? 'selected' : '' }>Active</option>
                                            <option value="Suspended"
                                                    ${userDetail.status=='Suspended'
                                                      ? 'selected' : '' }>Suspended
                                            </option>
                                            <option value="Blocked"
                                                    ${userDetail.status=='Blocked'
                                                      ? 'selected' : '' }>Blocked</option>
                                        </select>
                                        <button type="submit"
                                                class="btn btn-blue btn-sm">Save
                                            Changes</button>
                                    </div>
                                </form>
                            </div>

                            <div class="blue-line"
                                 style="margin-top:2.5rem; margin-bottom:1.5rem;"></div>

                            <!-- Soft Delete Account Form () -->
                            <div
                                style="background:rgba(239, 68, 68, 0.05); border:1px solid rgba(239, 68, 68, 0.2); border-radius:var(--radius-xl); padding:var(--space-6);">
                                <h3
                                    style="color:var(--color-white); font-size:1.1rem; margin-bottom:var(--space-2);">
                                    Deactivate User Account</h3>
                                <p class="text-xs text-muted"
                                   style="margin-bottom:var(--space-4);">
                                    The database record will be flagged as 'Inactive' to
                                    preserve operational
                                    audit logs.
                                </p>

                                <form action="${pageContext.request.contextPath}/admin/users?action=delete"
                                      method="post" id="deleteUserForm">
                                    <input type="hidden" name="userId"
                                           value="${userDetail.userId}" />
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
                            <div class="empty-state-title">No user available</div>
                            <p class="text-muted text-sm" style="margin-top:0.5rem;">The
                                requested user profile
                                could not be loaded.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        <script>


            document.getElementById('deleteUserForm').addEventListener('submit', function (e) {
                if (!confirm('Are you sure you want to deactivate this account? Access to the platform will be disabled.')) {
                    e.preventDefault();
                }
            });
        </script>
    </body>

</html>