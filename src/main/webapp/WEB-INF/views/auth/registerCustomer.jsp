<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta name="description" content="Create a free CarRental Customer account to rent premium cars today." />
            <title>Customer Registration - CarRental</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
        </head>

        <body>

            <div class="auth-page">

                <!-- Left: Visual Panel -->
                <div class="auth-visual">
                    <div class="auth-visual-title">
                        Begin Your Journey<br />
                        <span>In Comfort</span>
                    </div>
                    <p class="auth-visual-subtitle">
                        Create a free account and start renting luxury vehicles in just a few minutes.
                    </p>
                    <div class="auth-features">
                        <div class="auth-feature-item">
                            <div class="auth-feature-icon"><i class="bi bi-check-circle-fill"></i></div>
                            <span>Free & instant registration</span>
                        </div>
                        <div class="auth-feature-item">
                            <div class="auth-feature-icon"><i class="bi bi-car-front-fill"></i></div>
                            <span>Hundreds of luxury cars ready</span>
                        </div>
                        <div class="auth-feature-item">
                            <div class="auth-feature-icon"><i class="bi bi-shield-fill"></i></div>
                            <span>100% secure personal details</span>
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

                        <div class="auth-badge"><i class="bi bi-person-badge-fill"></i> Customer Portal</div>

                        <h1 class="auth-title">Create Account</h1>
                        <p class="auth-subtitle">Provide your details below to get started</p>

                        <form id="registerForm" action="${pageContext.request.contextPath}/register/customer"
                            method="post" novalidate>

                            <div class="form-group">
                                <label for="email" class="form-label">
                                    Email <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <span class="input-icon"><i class="bi bi-envelope-fill"></i></span>
                                    <input type="email" id="email" name="email" class="form-control"
                                        placeholder="example@email.com" value="<c:out value='${requestScope.email}'/>"
                                        autocomplete="email" required />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="phoneNumber" class="form-label">
                                    Phone Number <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <span class="input-icon"><i class="bi bi-telephone-fill"></i></span>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control"
                                        placeholder="0912345678" value="<c:out value='${requestScope.phoneNumber}'/>"
                                        autocomplete="tel" required />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="password" class="form-label">
                                    Password <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                                    <input type="password" id="password" name="password" class="form-control"
                                        placeholder="Min 8 characters" autocomplete="new-password"
                                        oninput="evaluatePasswordStrength(this.value, document.getElementById('pwdBar'))"
                                        required />
                                    <button type="button" class="input-toggle" onclick="togglePasswordVisibility(this)"
                                        aria-label="Toggle password visibility"><i class="bi bi-eye-fill"></i></button>
                                </div>
                                <div class="pwd-strength">
                                    <div class="pwd-strength-bar" id="pwdBar"></div>
                                </div>
                                <span class="form-hint">At least 8 characters. Mix uppercase letters, numbers, and
                                    special characters.</span>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">
                                    Confirm Password <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                                    <input type="password" id="confirmPassword" name="confirmPassword"
                                        class="form-control" placeholder="Re-enter your password"
                                        autocomplete="new-password" required />
                                    <button type="button" class="input-toggle" onclick="togglePasswordVisibility(this)"
                                        aria-label="Toggle visibility"><i class="bi bi-eye-fill"></i></button>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-blue btn-full btn-lg" id="registerBtn">
                                Create Account
                            </button>

                            <p class="text-sm text-muted text-center" style="margin-top:1rem;">
                                By registering, you agree to our
                                <a href="#">Terms of Service</a> and
                                <a href="#">Privacy Policy</a>.
                            </p>
                        </form>

                        <div class="auth-divider">already have an account?</div>

                        <div class="auth-footer">
                            <a href="${pageContext.request.contextPath}/login/customer"
                                class="btn btn-outline-blue btn-full">
                                Login
                            </a>
                        </div>

                    </div>
                </div>
            </div>

            <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            <script>
                

                document.getElementById('registerForm').addEventListener('submit', function (e) {
                    var email = document.getElementById('email').value.trim();
                    var phone = document.getElementById('phoneNumber').value.trim();
                    var password = document.getElementById('password').value;
                    var confirm = document.getElementById('confirmPassword').value;
                    var emailRx = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
                    var phoneRx = /^[0-9]{9,11}$/;

                    if (!email || !emailRx.test(email)) {
                        e.preventDefault();
                        showToast('Invalid email format.', 'error'); return;
                    }
                    if (!phone || !phoneRx.test(phone)) {
                        e.preventDefault();
                        showToast('Invalid phone number (9-11 digits).', 'error'); return;
                    }
                    if (!password || password.length < 8) {
                        e.preventDefault();
                        showToast('Password must be at least 8 characters.', 'error'); return;
                    }
                    if (password !== confirm) {
                        e.preventDefault();
                        showToast('Passwords do not match.', 'error'); return;
                    }

                    var btn = document.getElementById('registerBtn');
                    btn.textContent = 'Creating account...';
                    btn.classList.add('loading');
                });
            </script>
        </body>

        </html>