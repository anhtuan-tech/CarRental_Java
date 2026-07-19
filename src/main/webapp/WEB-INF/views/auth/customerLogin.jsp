<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Customer Login — CarRental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div class="auth-page">
    <!-- Left Visual Panel -->
    <div class="auth-visual">
        <div class="auth-visual-title">
            Welcome Back to<br/>
            <span>CarRental</span>
        </div>
        <p class="auth-visual-subtitle">
            Log in to continue your journey. Explore hundreds of premium vehicles waiting for you.
        </p>
        <div class="auth-features">
            <div class="auth-feature-item">
                <div class="auth-feature-icon">🔒</div>
                <span>Secure multi-layer account protection</span>
            </div>
            <div class="auth-feature-item">
                <div class="auth-feature-icon">⚡</div>
                <span>Book a car in under 60 seconds</span>
            </div>
            <div class="auth-feature-item">
                <div class="auth-feature-icon">💳</div>
                <span>VNPAY secure online payment</span>
            </div>
            <div class="auth-feature-item">
                <div class="auth-feature-icon">💎</div>
                <span>5-star premium experience</span>
            </div>
        </div>
    </div>

    <!-- Right Form Panel -->
    <div class="auth-form-panel">
        <div class="auth-form-inner">
             <div class="auth-logo">
                 <div class="auth-logo-icon"><i class="bi bi-car-front-fill"></i></div>
                 Car<span>Rental</span>
             </div>

             <div class="auth-badge"><i class="bi bi-person-badge-fill"></i> Customer Portal</div>

            <h2 class="auth-title">Sign In</h2>
            <p class="auth-subtitle">Enter your credentials to access your account.</p>

            <form id="loginForm" method="post" action="${pageContext.request.contextPath}/login/customer" novalidate>
                <div class="form-group">
                    <label class="form-label" for="email">Email <span class="required">*</span></label>
                     <div class="input-wrapper">
                         <span class="input-icon"><i class="bi bi-envelope-fill"></i></span>
                         <input type="email" id="email" name="email" class="form-control"
                               placeholder="your@email.com" autocomplete="email" required/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">Password <span class="required">*</span></label>
                     <div class="input-wrapper">
                         <span class="input-icon"><i class="bi bi-lock-fill"></i></span>
                         <input type="password" id="password" name="password" class="form-control"
                                placeholder="Enter your password" autocomplete="current-password" required/>
                         <button type="button" class="input-toggle" id="togglePwd" aria-label="Show/Hide password"><i class="bi bi-eye-fill"></i></button>
                     </div>
                </div>
                <div style="text-align:right; margin-top:-0.75rem; margin-bottom:1.25rem;">
                    <a href="${pageContext.request.contextPath}/forgot-password" style="font-size:0.8rem; color:var(--orange);">Forgot password?</a>
                </div>
                 <button type="submit" id="loginBtn" class="btn btn-primary btn-full btn-lg">Login</button>
            </form>

            <div class="auth-divider">or</div>

            <div class="auth-footer">
                Don't have an account? <a href="${pageContext.request.contextPath}/register/customer">Register now</a>
            </div>
            <div class="auth-footer" style="margin-top:0.5rem;">
                Are you an Owner? <a href="${pageContext.request.contextPath}/login/owner">Login here</a>
            </div>
            <div class="auth-footer" style="margin-top:0.5rem;">
                <a href="${pageContext.request.contextPath}/home" style="color:var(--text-faint); font-size:0.8rem;">← Back to Home</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script>
    document.getElementById('togglePwd').addEventListener('click', function() {
        var p = document.getElementById('password');
        p.type = p.type === 'password' ? 'text' : 'password';
    });

    document.getElementById('loginForm').addEventListener('submit', function(e) {
        var email    = document.getElementById('email').value.trim();
        var password = document.getElementById('password').value;
        var emailRx  = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

        if (!email) { e.preventDefault(); showToast('Email is required.', 'error'); return; }
        if (!emailRx.test(email)) { e.preventDefault(); showToast('Invalid email format.', 'error'); return; }
        if (!password) { e.preventDefault(); showToast('Password is required.', 'error'); return; }

        var btn = document.getElementById('loginBtn');
        btn.textContent = 'Signing in...';
        btn.classList.add('loading');
    });
</script>
</body>
</html>