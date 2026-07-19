<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Provision Staff - CarRental Admin</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
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

                    <!-- Breadcrumbs -->
                    <div class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin/staff?action=list"
                            style="color:var(--color-gray-light); font-size:0.9rem; font-weight:500;">← Back to Staff
                            Index</a>
                    </div>

                    <div class="form-card">

                        <div class="mb-4">
                            <h1 class="hero-title"
                                style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">Provision
                                <span>New Staff</span></h1>
                            <p class="text-muted text-sm">Register new back-office personnel. A secure default hashed
                                temporary password will be assigned.</p>
                        </div>
                        <div class="blue-line" style="margin-bottom: 2rem;"></div>

                        <form action="${pageContext.request.contextPath}/admin/staff?action=create" method="post"
                            id="createStaffForm">

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