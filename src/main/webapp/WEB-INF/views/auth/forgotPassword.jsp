<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta name="description" content="Forgot Password - Reset your CarRental account password." />
            <title>Forgot Password - CarRental</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
        </head>

        <body>

            <div class="auth-page">

                <!-- Left: Visual Panel -->
                <div class="auth-visual">
                    <div class="auth-visual-title">
                        Recover Your<br />
                        <span>Account</span>
                    </div>
                    <p class="auth-visual-subtitle">
                        Enter your registered email address below, and we will send you instructions to reset your
                        password.
                    </p>
                    <div class="auth-features">
                        <div class="auth-feature-item">
                            <div class="auth-feature-icon"><i class="bi bi-envelope-fill"></i></div>
                            <span>Password reset link via email</span>
                        </div>
                        <div class="auth-feature-item">
                            <div class="auth-feature-icon"><i class="bi bi-shield-fill"></i></div>
                            <span>Secured recovery session</span>
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

                        <div class="auth-badge"><i class="bi bi-key-fill"></i> Password Recovery</div>

                        <h1 class="auth-title">Forgot Password</h1>
                        <p class="auth-subtitle">We will help you reset it in seconds</p>

                        <form id="forgotForm" action="${pageContext.request.contextPath}/forgotPassword" method="post"
                            novalidate>

                            <div class="form-group">
                                <label for="email" class="form-label">
                                    Email Address <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <span class="input-icon"><i class="bi bi-envelope-fill"></i></span>
                                    <input type="email" id="email" name="email" class="form-control"
                                        placeholder="example@email.com" value="<c:out value='${requestScope.email}'/>"
                                        autocomplete="email" required />
                                </div>
                            </div>

                            <div style="margin-bottom:1.5rem;"></div>

                            <button type="submit" class="btn btn-blue btn-full btn-lg" id="submitBtn">
                                Submit Request →
                            </button>
                        </form>

                        <div class="auth-divider">or</div>

                        <div class="auth-footer">
                            Remember your password?
                            <a href="${pageContext.request.contextPath}/login/customer">Login here</a>
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
                        

                document.getElementById('forgotForm').addEventListener('submit', function (e) {
                    var email = document.getElementById('email').value.trim();
                    var emailRx = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

                    if (!email) {
                        e.preventDefault();
                        showToast('Email is required.', 'error');
                        return;
                    }
                    if (!emailRx.test(email)) {
                        e.preventDefault();
                        showToast('Invalid email format.', 'error');
                        return;
                    }

                    var btn = document.getElementById('submitBtn');
                    btn.textContent = 'Sending request...';
                    btn.classList.add('loading');
                });
            </script>
        </body>

        </html>