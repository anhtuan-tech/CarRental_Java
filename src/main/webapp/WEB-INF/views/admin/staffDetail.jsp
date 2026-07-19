<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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



                            <c:choose>
                                <c:when test="${not empty staffDetail}">
                                    <div class="detail-card">

                                        <div class="mb-4"
                                            style="display:flex; justify-content:space-between; align-items:center;">
                                            <div>
                                                <h1 class="hero-title"
                                                    style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">
                                                    Manage <span>Staff Profile</span></h1>

                                            </div>
                                            <div
                                                class="status-badge ${staffDetail.status == 'Active' ? 'active' : (staffDetail.status == 'Suspended' ? 'suspended' : 'blocked')}">
                                                <c:out value="${staffDetail.status}" />
                                            </div>
                                        </div>
                                        <div class="blue-line" style="margin-bottom: 2rem;"></div>

                                        <!-- Update Form -->
                                        <form action="${pageContext.request.contextPath}/admin/staff?action=update"
                                            method="post" id="updateStaffForm" enctype="multipart/form-data">
                                            <input type="hidden" name="staffId" value="${staffDetail.userId}" />

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label for="fullName" class="form-label">Full Name <span
                                                            class="required">*</span></label>
                                                    <input type="text" name="fullName" id="fullName"
                                                        class="form-control"
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
                                                        <option value="Active" ${staffDetail.status=='Active'
                                                            ? 'selected' : '' }>Active</option>
                                                        <option value="Suspended" ${staffDetail.status=='Suspended'
                                                            ? 'selected' : '' }>Suspended</option>
                                                        <option value="Blocked" ${staffDetail.status=='Blocked'
                                                            ? 'selected' : '' }>Blocked</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-group" style="margin-top:var(--space-2);">
                                                <label for="password" class="form-label">New Password</label>
                                                <input type="password" name="password" id="password"
                                                    class="form-control"
                                                    placeholder="Leave blank to keep current password" />
                                                <span class="form-hint">Enter new password only if you wish to reset
                                                    it.</span>
                                            </div>

                                            <div class="form-group" style="margin-top:var(--space-2);">
                                                <label class="form-label">Avatar Image</label>
                                                <div style="display:flex; align-items:center; gap:1rem; margin-bottom:0.5rem;">
                                                    <c:choose>
                                                        <c:when test="${not empty staffDetail.avatarUrl}">
                                                            <img src="${staffDetail.avatarUrl}" style="width:60px; height:60px; border-radius:50%; object-fit:cover; border:2px solid var(--orange-border);" alt="Avatar" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div style="width:60px; height:60px; border-radius:50%; background:var(--orange-pale); border:2px solid var(--orange-border); display:flex; align-items:center; justify-content:center; color:var(--orange-dark); font-weight:700; font-size:1.5rem;">
                                                                <c:out value="${fn:substring(staffDetail.fullName, 0, 1)}"/>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <input type="file" name="avatarFile" id="avatarFile" class="form-control" accept="image/png, image/jpeg, image/jpg" style="flex-grow:1;" />
                                                </div>
                                                <span class="form-hint">Upload PNG/JPG to change avatar. Leave empty to keep.</span>
                                            </div>

                                            <!-- Submit and cancellation actions -->
                                            <div
                                                style="margin-top:2rem; display:flex; justify-content:space-between; align-items:center;">
                                                <div style="display:flex; gap:var(--space-3);">
                                                    <button type="submit" class="btn btn-blue btn-sm">Save
                                                        Changes</button>
                                                    <a href="${pageContext.request.contextPath}/admin/staff?action=list"
                                                        class="btn btn-ghost btn-sm"
                                                        style="display:flex; align-items:center;">Cancel</a>
                                                </div>
                                            </div>
                                        </form>



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


                    </script>
                </body>

                </html>