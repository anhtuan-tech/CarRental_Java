<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Reset Password - Car Rental</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
        <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>

    <body>

        <div class="auth-page">

            <!-- Left: Visual Panel -->
            <div class="auth-visual">
                <div class="auth-visual-title">
                    Set a New<br />
                    <span>Password</span>
                </div>
                <p class="auth-visual-subtitle">
                    Please enter a secure password that you don't use anywhere else. Make sure it's at least 6 characters long.
                </p>
                <div class="auth-features">
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="bi bi-shield-lock-fill"></i></div>
                        <span>Secure encryption updates</span>
                    </div>
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="bi bi-check-circle-fill"></i></div>
                        <span>Instant access activation</span>
                    </div>
                </div>
            </div>

            <!-- Right: Form Panel -->
            <div class="auth-form-panel">
                <div class="auth-form-inner">

                    <div class="auth-logo">
                        <div class="auth-logo-icon"><i class="bi bi-car-front-fill"></i></div>
                        Car<span>Rental</span>
                    </div>

                    <div class="auth-badge"><i class="bi bi-shield-key"></i> Security Center</div>

                    <h1 class="auth-title">Reset Password</h1>
                    <p class="auth-subtitle" style="margin-bottom:1.5rem;">Update password for: <strong style="color: var(--orange);"><c:out value="${sessionScope.resetEmail}"/></strong></p>

                    <form id="resetForm" action="${pageContext.request.contextPath}/reset-password" method="post" novalidate>

                        <div class="form-group">
                            <label for="password" class="form-label">
                                New Password <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                                <input type="password" id="password" name="password" class="form-control"
                                       placeholder="Min 6 characters" required />
                                <i class="bi bi-eye-slash" id="togglePwd" style="position: absolute; right: var(--space-4); cursor: pointer; color: var(--color-gray-mid); top:50%; transform:translateY(-50%);"></i>
                            </div>
                        </div>

                        <div class="form-group" style="margin-top: 1.25rem;">
                            <label for="confirmPassword" class="form-label">
                                Confirm New Password <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                                       placeholder="Repeat new password" required />
                                <i class="bi bi-eye-slash" id="toggleConfirmPwd" style="position: absolute; right: var(--space-4); cursor: pointer; color: var(--color-gray-mid); top:50%; transform:translateY(-50%);"></i>
                            </div>
                        </div>

                        <div style="margin-bottom:1.5rem;"></div>

                        <button type="submit" class="btn btn-blue btn-full btn-lg" id="submitBtn">
                            Save New Password
                        </button>
                    </form>

                    <div class="auth-divider">or</div>

                    <div class="auth-footer">
                        Back to <a href="${pageContext.request.contextPath}/login/customer">Login here</a>
                    </div>

                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/common/footer.jsp" />

        <script>
            // Toggle view passwords
            document.getElementById('togglePwd').addEventListener('click', function () {
                var pwd = document.getElementById('password');
                if (pwd.type === 'password') {
                    pwd.type = 'text';
                    this.classList.replace('bi-eye-slash', 'bi-eye');
                } else {
                    pwd.type = 'password';
                    this.classList.replace('bi-eye', 'bi-eye-slash');
                }
            });

            document.getElementById('toggleConfirmPwd').addEventListener('click', function () {
                var cpwd = document.getElementById('confirmPassword');
                if (cpwd.type === 'password') {
                    cpwd.type = 'text';
                    this.classList.replace('bi-eye-slash', 'bi-eye');
                } else {
                    cpwd.type = 'password';
                    this.classList.replace('bi-eye', 'bi-eye-slash');
                }
            });

            document.getElementById('resetForm').addEventListener('submit', function (e) {
                var pwd = document.getElementById('password').value;
                var cpwd = document.getElementById('confirmPassword').value;

                if (!pwd || pwd.length < 6) {
                    e.preventDefault();
                    showToast('Password must be at least 6 characters.', 'error');
                    return;
                }

                if (pwd !== cpwd) {
                    e.preventDefault();
                    showToast('Confirm password does not match.', 'error');
                    return;
                }
            });
        </script>
    </body>
</html>
