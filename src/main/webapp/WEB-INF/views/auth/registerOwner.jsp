<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta name="description"
                content="Register an Owner account on CarRental to start earning from your vehicle fleet." />
            <title>Owner Registration - CarRental</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
        </head>

        <body>

            <div class="auth-page">

                <!-- Left: Visual Panel -->
                <div class="auth-visual">
                    <div class="auth-visual-title">
                        Become an<br />
                        <span>Owner on CarRental</span>
                    </div>
                    <p class="auth-visual-subtitle">
                        Rent out your idle cars, generate passive income, and manage flexibly. Join today!
                    </p>
                    <div class="auth-features">
                        <div class="auth-feature-item">
                            <div class="auth-feature-icon"><i class="bi bi-cash-stack"></i></div>
                            <span>Passive income from your fleet</span>
                        </div>
                        <div class="auth-feature-item">
                            <div class="auth-feature-icon"><i class="bi bi-shield-fill-check"></i></div>
                            <span>Full insurance and protection</span>
                        </div>
                        <div class="auth-feature-item">
                            <div class="auth-feature-icon"><i class="bi bi-phone-fill"></i></div>
                            <span>Manage anywhere, anytime</span>
                        </div>
                    </div>
                </div>

                <!-- Right: Form Panel -->
                <div class="auth-form-panel">
                    <div class="auth-form-inner">

                        <div class="auth-logo">
                            <div class="auth-logo-icon"><i class="bi bi-key-fill"></i></div>
                            Car<span>Rental</span>
                        </div>

                        <div class="auth-badge"><i class="bi bi-key-fill"></i> Owner Portal</div>

                        <h1 class="auth-title">Register as Owner</h1>
                        <p class="auth-subtitle">Complete your registration and wait for review from the CarRental team
                        </p>

                        <form id="ownerRegisterForm" action="${pageContext.request.contextPath}/register/owner"
                            method="post" novalidate>

                            <div class="form-group">
                                <label for="email" class="form-label">
                                    Email <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <span class="input-icon"><i class="bi bi-envelope-fill"></i></span>
                                    <input type="email" id="email" name="email" class="form-control"
                                        placeholder="owner@example.com" value="<c:out value='${requestScope.email}'/>"
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
                                <span class="form-hint">At least 8 characters.</span>
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

                            <button type="submit" class="btn btn-blue btn-full btn-lg" id="ownerRegisterBtn">
                                Submit Application
                            </button>

                            <p class="text-sm text-muted text-center" style="margin-top:1rem;">
                                Your account will be reviewed within 24 working hours.
                            </p>
                        </form>

                        <div class="auth-divider">already have an account?</div>

                        <div class="auth-footer">
                            <a href="${pageContext.request.contextPath}/login/owner"
                                class="btn btn-outline-blue btn-full">
                                Login
                            </a>
                        </div>
                        <div class="auth-footer" style="margin-top:0.75rem;">
                            <a href="${pageContext.request.contextPath}/home"
                                style="color:var(--color-gray-light); font-size:0.8rem;">← Back to Home</a>
                        </div>

                    </div>
                </div>
            </div>

            <jsp:include page="/WEB-INF/views/common/footer.jsp" />
                    <script>
                        

                document.getElementById('ownerRegisterForm').addEventListener('submit', function (e) {
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

                    var btn = document.getElementById('ownerRegisterBtn');
                    btn.textContent = 'Submitting...';
                    btn.classList.add('loading');
                });
            </script>
        </body>

        </html>