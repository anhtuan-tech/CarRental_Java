<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Staff &amp; Admin Login — Car Rental</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1"/>
    </head>
    <body>
        <div class="auth-page">
            <div class="auth-visual">
                <div class="auth-visual-title">
                    Admin &amp; Staff<br/><span>Control Portal</span>
                </div>
                <p class="auth-visual-subtitle">
                    Restricted access for staff and administrators. Log in with your corporate credentials.
                </p>
                <div class="auth-features">
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="bi bi-shield-fill"></i></div>
                        <span>Strict role-based access control</span>
                    </div>
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="bi bi-bar-chart-line-fill"></i></div>
                        <span>Comprehensive operations dashboard</span>
                    </div>
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="bi bi-search"></i></div>
                        <span>Full system activity audit logging</span>
                    </div>
                </div>
            </div>
            <div class="auth-form-panel">
                <div class="auth-form-inner">
                    <div class="auth-logo">
                        <div class="auth-logo-icon"><i class="bi bi-shield-fill"></i></div>
                        Car<span>Rental</span>
                    </div>
                    <div class="auth-badge"><i class="bi bi-shield-lock-fill"></i> Staff / Admin Portal</div>
                    <h2 class="auth-title">Secure Login</h2>
                    <p class="auth-subtitle">Enter your corporate credentials to continue.</p>

                    <form id="staffLoginForm" action="${pageContext.request.contextPath}/login/staff" method="post" novalidate>
                        <div class="form-group">
                            <label class="form-label" for="email">Corporate Email <span class="required">*</span></label>
                            <div class="input-wrapper">
                                <span class="input-icon"><i class="bi bi-envelope-fill"></i></span>
                                <input type="email" id="email" name="email" class="form-control" placeholder="staff@carrental.com" autocomplete="email" required/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="password">Password <span class="required">*</span></label>
                            <div class="input-wrapper">
                                <span class="input-icon"><i class="bi bi-lock-fill"></i></span>
                                <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" autocomplete="current-password" required/>
                                <button type="button" class="input-toggle" id="togglePwd"><i class="bi bi-eye-fill"></i></button>
                            </div>
                        </div>
                        <button type="submit" id="staffLoginBtn" class="btn btn-primary btn-full btn-lg">Login</button>
                    </form>

                    <div class="auth-divider">or</div>
                    <div class="auth-footer">
                        Are you a Customer? <a href="${pageContext.request.contextPath}/login/customer">Customer Login</a>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
        <script>
            document.getElementById('togglePwd').addEventListener('click', function () {
                var p = document.getElementById('password');
                p.type = p.type === 'password' ? 'text' : 'password';
            });
            document.getElementById('staffLoginForm').addEventListener('submit', function (e) {
                var email = document.getElementById('email').value.trim();
                var password = document.getElementById('password').value;
                var emailRx = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
                if (!email || !emailRx.test(email)) {
                    e.preventDefault();
                    showToast('Please enter a valid email.', 'error');
                    return;
                }
                if (!password) {
                    e.preventDefault();
                    showToast('Password is required.', 'error');
                    return;
                }
                var btn = document.getElementById('staffLoginBtn');
                btn.textContent = 'Signing in...';
                btn.classList.add('loading');
            });
        </script>
    </body>
</html>