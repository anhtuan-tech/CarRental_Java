<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Provision Staff - Car Rental Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
        <style>
            .form-card {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-8);
                max-width: 600px;
                margin: var(--space-8) auto;
            }
        </style>
    </head>

    <body>

        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="page-wrapper">
            <div class="container">



                <div class="form-card">

                    <div class="mb-4">
                        <h1 class="hero-title"
                            style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">Provision
                            <span>New Staff</span>
                        </h1>
                        <p class="text-muted text-sm">Register new back-office personnel. A secure default hashed
                            temporary password will be assigned.</p>
                    </div>
                    <div class="blue-line" style="margin-bottom: 2rem;"></div>

                    <form action="${pageContext.request.contextPath}/admin/staff?action=create" method="post"
                          id="createStaffForm" enctype="multipart/form-data">

                        <div class="form-group">
                            <label for="fullName" class="form-label">Full Name <span
                                    class="required">*</span></label>
                            <input type="text" name="fullName" id="fullName" class="form-control"
                                   placeholder="Enter staff full name..."
                                   value="<c:out value='${requestScope.fullNameVal}'/>" required />
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">Email Address <span
                                    class="required">*</span></label>
                            <input type="email" name="email" id="email" class="form-control"
                                   placeholder="staff.name@carrental.com"
                                   value="<c:out value='${requestScope.emailVal}'/>" required />
                            <span class="form-hint">Must be strictly unique across the platform database.</span>
                        </div>

                        <div class="form-group">
                            <label for="phoneNumber" class="form-label">Phone Number <span
                                    class="required">*</span></label>
                            <input type="text" name="phoneNumber" id="phoneNumber" class="form-control"
                                   placeholder="Enter mobile contact number..."
                                   value="<c:out value='${requestScope.phoneVal}'/>" required />
                            <span class="form-hint">Enter 10-11 digit telephone numeric context.</span>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Account Password <span
                                    class="required">*</span></label>
                            <input type="password" name="password" id="password" class="form-control"
                                   placeholder="Enter account password..." required />
                            <span class="form-hint">Password complexity rules apply.</span>
                        </div>

                        <div class="form-group" style="margin-top:var(--space-2);">
                            <label class="form-label">Avatar Image</label>
                            <div style="display:flex; align-items:center; gap:1rem; margin-bottom:0.5rem;">
                                <div style="width:60px; height:60px; border-radius:50%; background:var(--orange-pale); border:2px solid var(--orange-border); display:flex; align-items:center; justify-content:center;">
                                    <i class="bi bi-person-fill" style="font-size:1.75rem; color:var(--orange);"></i>
                                </div>
                                <input type="file" name="avatarFile" id="avatarFile" class="form-control"
                                       accept="image/png, image/jpeg, image/jpg" style="flex-grow:1;" />
                            </div>
                            <span class="form-hint">Upload PNG/JPG to set avatar. Leave empty to keep.</span>
                        </div>

                        <div style="margin-top:2rem; display:flex; gap:var(--space-3);">
                            <button type="submit" class="btn btn-blue btn-sm">Create Staff Account</button>
                            <a href="${pageContext.request.contextPath}/admin/staff?action=list"
                               class="btn btn-ghost btn-sm" style="display:flex; align-items:center;">Cancel</a>
                        </div>
                    </form>

                </div>

            </div>
        </div>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        <script>


            document.getElementById('createStaffForm').addEventListener('submit', function (e) {
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