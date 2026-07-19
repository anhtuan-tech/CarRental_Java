<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>My Profile - CarRental</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
                <style>
                    .profile-card {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-8);
                        max-width: 700px;
                        margin: var(--space-8) auto;
                        position: relative;
                    }

                    .profile-avatar-container {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        margin-bottom: var(--space-8);
                    }

                    .profile-avatar {
                        width: 130px;
                        height: 130px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 3px solid var(--color-blue);
                        background: var(--color-dark-surface);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 3rem;
                        color: var(--color-gray-light);
                        margin-bottom: var(--space-3);
                    }

                    .profile-name {
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: var(--color-white);
                    }

                    .profile-role-badge {
                        display: inline-block;
                        background: var(--color-dark-surface);
                        border: 1px solid var(--color-blue-border);
                        color: var(--color-blue-light);
                        font-size: 0.75rem;
                        font-weight: 600;
                        padding: var(--space-1) var(--space-3);
                        border-radius: var(--radius-full);
                        margin-top: var(--space-2);
                        text-transform: uppercase;
                    }

                    .profile-details {
                        border-top: 1px solid var(--color-dark-border);
                        padding-top: var(--space-6);
                    }

                    .profile-detail-row {
                        display: flex;
                        justify-content: space-between;
                        padding: var(--space-3) 0;
                        border-bottom: 1px solid var(--color-dark-border);
                    }

                    .profile-detail-row:last-child {
                        border-bottom: none;
                    }

                    .profile-detail-label {
                        color: var(--color-gray-light);
                        font-weight: 500;
                    }

                    .profile-detail-value {
                        color: var(--color-white-soft);
                        font-weight: 600;
                    }

                    .profile-actions {
                        display: flex;
                        gap: var(--space-4);
                        justify-content: center;
                        margin-top: var(--space-8);
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/WEB-INF/views/common/header.jsp" />

                <div class="page-wrapper">
                    <div class="container">

                        <div class="profile-card">

                            <!-- Avatar Header -->
                            <div class="profile-avatar-container">
                                <c:choose>
                                    <c:when test="${not empty profile.avatarUrl}">
                                        <img src="${profile.avatarUrl}" class="profile-avatar"
                                            alt="${profile.fullName}" />
                                    </c:when>
                                    <c:otherwise>
                                        <div class="profile-avatar" style="display: flex; align-items: center; justify-content: center;"><i class="bi bi-person-fill" style="font-size: 2.5rem; color: var(--text-muted);"></i></div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="profile-name">
                                    <c:out value="${profile.fullName}" />
                                </div>
                                <div class="profile-role-badge">
                                     <c:choose>
                                         <c:when test="${user.roleId == 1}">Admin</c:when>
                                         <c:when test="${user.roleId == 2}">Staff</c:when>
                                         <c:when test="${user.roleId == 3}">Customer</c:when>
                                         <c:when test="${user.roleId == 4}">Owner</c:when>
                                     </c:choose>
                                </div>
                            </div>

                            <!-- Detailed Stats/Info -->
                            <div class="profile-details">
                                <div class="profile-detail-row">
                                    <span class="profile-detail-label">Email Address</span>
                                    <span class="profile-detail-value">
                                        <c:out value="${user.email}" />
                                    </span>
                                </div>
                                <div class="profile-detail-row">
                                    <span class="profile-detail-label">Phone Number</span>
                                    <span class="profile-detail-value">
                                        <c:out value="${user.phoneNumber}" />
                                    </span>
                                </div>
                                <div class="profile-detail-row">
                                    <span class="profile-detail-label">Driver License</span>
                                    <span class="profile-detail-value">
                                        <c:choose>
                                            <c:when test="${not empty profile.driverLicense}">
                                                <c:out value="${profile.driverLicense}" />
                                            </c:when>
                                            <c:otherwise><em style="color:var(--color-gray-mid);">Not provided</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="profile-detail-row">
                                    <span class="profile-detail-label">ID Card No.</span>
                                    <span class="profile-detail-value">
                                        <c:choose>
                                            <c:when test="${not empty profile.idCardNo}">
                                                <c:out value="${profile.idCardNo}" />
                                            </c:when>
                                            <c:otherwise><em style="color:var(--color-gray-mid);">Not provided</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="profile-detail-row">
                                    <span class="profile-detail-label">Billing Address</span>
                                    <span class="profile-detail-value">
                                        <c:choose>
                                            <c:when test="${not empty profile.address}">
                                                <c:out value="${profile.address}" />
                                            </c:when>
                                            <c:otherwise><em style="color:var(--color-gray-mid);">Not provided</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <!-- Actions buttons -->
                            <div class="profile-actions">
                                <a href="${pageContext.request.contextPath}/profile?action=edit" class="btn btn-blue">
                                    Edit Profile Details
                                </a>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-ghost">
                                    Back to Home
                                </a>
                            </div>

                        </div>

                    </div>
                </div>

                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </body>

            </html>