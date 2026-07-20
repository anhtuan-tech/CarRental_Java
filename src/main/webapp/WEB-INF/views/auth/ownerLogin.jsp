<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Owner Login — Car Rental</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1"/>
    </head>
    <body>
        <div class="auth-page">
            <div class="auth-visual">
                <div class="auth-visual-title">
                    Owner Portal<br/><span>Car Rental</span>
                </div>
                <p class="auth-visual-subtitle">
                    Manage your fleet, track bookings, and optimize your revenue anywhere, anytime.
                </p>
                <div class="auth-features">
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="bi bi-car-front-fill"></i></div>
                        <span>Easy fleet management dashboard</span>
                    </div>
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="bi bi-cash-stack"></i></div>
                        <span>Real-time revenue tracking</span>
                    </div>
                    <div class="auth-feature-item">
                        <div class="auth-feature-icon"><i class="bi bi-calendar-event"></i></div>
                        <span>Smart booking scheduler</span>
                    </div>
                </div>
            </div>
            <div class="auth-form-panel">
                <div class="auth-form-inner">
                    <div class="auth-logo">
                        <div class="auth-logo-icon"><i class="bi bi-key-fill"></i></div>
                        Car<span>Rental</span>
                    </div>
                    <div class="auth-badge"><i class="bi bi-key-fill"></i> Owner Portal</div>
                    <h2 class="auth-title">Owner Login</h2>
                    <p class="auth-subtitle">Access your partner fleet dashboard.</p>

                    <form id="ownerLoginForm" action="${pageContext.request.contextPath}/login/owner" method="post" novalidate>
                        <div class="form-group">
                            <label class="form-label" for="email">Email <span class="required">*</span></label>
                            <div class="input-wrapper">
                                <span class="input-icon"><i class="bi bi-envelope-fill"></i></span>
                                <input type="email" id="email" name="email" class="form-control" placeholder="owner@email.com" autocomplete="email" required/>
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
                        <button type="submit" id="ownerLoginBtn" class="btn btn-primary btn-full btn-lg">Login</button>
                    </form>

                    <div class="auth-divider">or</div>
                    <div class="auth-footer">
                        Are you a Customer? <a href="${pageContext.request.contextPath}/login/customer">Login here</a>
                    </div>
                    <div class="auth-footer" style="margin-top:0.5rem;">
                        New here? <a href="${pageContext.request.contextPath}/register/owner">Register as Owner</a>
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
            document.getElementById('ownerLoginForm').addEventListener('submit', function (e) {
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
                var btn = document.getElementById('ownerLoginBtn');
                btn.textContent = 'Signing in...';
                btn.classList.add('loading');
            });
        </script>
    </body>
</html>