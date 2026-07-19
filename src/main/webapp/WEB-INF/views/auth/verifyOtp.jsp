<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Verify OTP - CarRental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
    <style>
        .otp-input-container {
            display: flex;
            justify-content: space-between;
            gap: 0.5rem;
            margin: var(--space-6) 0;
        }

        .otp-digit {
            width: 48px;
            height: 52px;
            font-size: 1.5rem;
            font-weight: 700;
            text-align: center;
            border-radius: var(--radius-md);
            border: 1.5px solid var(--color-dark-border);
            background: var(--color-dark-surface);
            color: var(--color-white);
            transition: var(--transition-fast);
        }

        .otp-digit:focus {
            border-color: var(--orange);
            box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.2);
            outline: none;
        }
    </style>
</head>

<body>

    <div class="auth-page">

        <!-- Left: Visual Panel -->
        <div class="auth-visual">
            <div class="auth-visual-title">
                Confirm Your<br />
                <span>Identity</span>
            </div>
            <p class="auth-visual-subtitle">
                A 6-digit verification code has been sent to your email. Enter the code below to reset your password.
            </p>
            <div class="auth-features">
                <div class="auth-feature-item">
                    <div class="auth-feature-icon"><i class="bi bi-shield-fill-check"></i></div>
                    <span>Secure multi-factor authentication</span>
                </div>
                <div class="auth-feature-item">
                    <div class="auth-feature-icon"><i class="bi bi-clock-fill"></i></div>
                    <span>Codes expire after 5 minutes</span>
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

                <div class="auth-badge"><i class="bi bi-shield-lock"></i> Verification Required</div>

                <h1 class="auth-title">Verify OTP</h1>
                <p class="auth-subtitle">We sent a 6-digit code to: <strong style="color: var(--orange);"><c:out value="${sessionScope.resetEmail}"/></strong></p>


                <form id="otpForm" action="${pageContext.request.contextPath}/verify-otp" method="post" novalidate>
                    <!-- Actual concatenated OTP input -->
                    <input type="hidden" id="otpCode" name="otpCode" />

                    <div class="otp-input-container">
                        <input type="text" maxlength="1" class="otp-digit" pattern="[0-9]" inputmode="numeric" required />
                        <input type="text" maxlength="1" class="otp-digit" pattern="[0-9]" inputmode="numeric" required />
                        <input type="text" maxlength="1" class="otp-digit" pattern="[0-9]" inputmode="numeric" required />
                        <input type="text" maxlength="1" class="otp-digit" pattern="[0-9]" inputmode="numeric" required />
                        <input type="text" maxlength="1" class="otp-digit" pattern="[0-9]" inputmode="numeric" required />
                        <input type="text" maxlength="1" class="otp-digit" pattern="[0-9]" inputmode="numeric" required />
                    </div>

                    <div style="margin-bottom:1.5rem;"></div>

                    <button type="submit" class="btn btn-blue btn-full btn-lg" id="submitBtn">
                        Verify Code →
                    </button>
                </form>

                <div class="auth-divider">or</div>

                <div class="auth-footer">
                    Didn't receive the email? <a href="${pageContext.request.contextPath}/forgot-password">Resend Code</a>
                </div>

            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        // Automatic OTP input navigation
        const digits = document.querySelectorAll('.otp-digit');
        const hiddenInput = document.getElementById('otpCode');

        digits.forEach((digit, idx) => {
            digit.addEventListener('input', (e) => {
                const val = e.target.value;
                if (val.length === 1 && idx < digits.length - 1) {
                    digits[idx + 1].focus();
                }
                updateHiddenInput();
            });

            digit.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !digit.value && idx > 0) {
                    digits[idx - 1].focus();
                }
            });
        });

        function updateHiddenInput() {
            let code = '';
            digits.forEach(d => {
                code += d.value;
            });
            hiddenInput.value = code;
        }

        document.getElementById('otpForm').addEventListener('submit', function (e) {
            updateHiddenInput();
            if (hiddenInput.value.length !== 6) {
                e.preventDefault();
                showToast('Please enter the full 6-digit OTP code.', 'error');
                return;
            }
        });
    </script>
</body>
</html>
