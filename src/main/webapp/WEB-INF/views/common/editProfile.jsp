<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Edit Profile & Security - CarRental</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
            <style>
                .edit-grid {
                    display: grid;
                    grid-template-columns: 3fr 2fr;
                    gap: var(--space-8);
                    margin: var(--space-8) auto;
                    max-width: 1100px;
                    align-items: start;
                }

                @media (max-width: 992px) {
                    .edit-grid {
                        grid-template-columns: 1fr;
                    }
                }

                .edit-card {
                    background: var(--color-dark-card);
                    border: 1px solid var(--color-dark-border);
                    border-radius: var(--radius-xl);
                    padding: var(--space-8);
                }

                .edit-title-group {
                    margin-bottom: var(--space-6);
                }

                .edit-title {
                    font-size: 1.25rem;
                    font-weight: 700;
                    color: var(--color-white);
                    margin-bottom: var(--space-1);
                }

                .edit-subtitle {
                    font-size: 0.85rem;
                    color: var(--color-gray-light);
                }

                .avatar-upload-preview {
                    display: flex;
                    align-items: center;
                    gap: var(--space-4);
                    margin-bottom: var(--space-6);
                    background: var(--color-dark-surface);
                    padding: var(--space-4);
                    border-radius: var(--radius-lg);
                    border: 1px dashed var(--color-dark-border);
                }

                .upload-preview-img {
                    width: 80px;
                    height: 80px;
                    border-radius: 50%;
                    object-fit: cover;
                    border: 2px solid var(--color-blue);
                }

                .upload-preview-placeholder {
                    width: 80px;
                    height: 80px;
                    border-radius: 50%;
                    background: var(--color-dark-card);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 2rem;
                    color: var(--color-gray-light);
                    border: 2px solid var(--color-dark-border);
                }
            </style>
        </head>

        <body>

            <jsp:include page="/WEB-INF/views/common/header.jsp" />

            <div class="page-wrapper">
                <div class="container">

                    <!-- Breadcrumbs -->
                    <div class="mb-4">
                        <a href="${pageContext.request.contextPath}/profile"
                            style="color:var(--color-gray-light); font-size:0.9rem; font-weight:500;">← Back to
                            Profile</a>
                    </div>

                    <div class="edit-grid">

                        <!-- Left Side: Edit Profile Details -->
                        <div class="edit-card">
                            <div class="edit-title-group">
                                <h2 class="edit-title">Edit Profile Information</h2>
                                <p class="edit-subtitle">Update your personal account credentials and document tags.</p>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                            <form id="profileForm" action="${pageContext.request.contextPath}/profile?action=edit"
                                method="post" enctype="multipart/form-data" novalidate>

                                <!-- Avatar Preview & Input -->
                                <div class="avatar-upload-preview">
                                    <c:choose>
                                        <c:when test="${not empty profile.avatarUrl}">
                                            <img id="avatarPreview" src="${profile.avatarUrl}"
                                                class="upload-preview-img" alt="Avatar" />
                                        </c:when>
                                        <c:otherwise>
                                            <div id="avatarPlaceholder" class="upload-preview-placeholder"><i class="bi bi-person-fill" style="font-size: 2rem;"></i></div>
                                            <img id="avatarPreview" class="upload-preview-img" style="display:none;"
                                                alt="Avatar" />
                                        </c:otherwise>
                                    </c:choose>
                                    <div>
                                        <label for="avatarFile" class="form-label"
                                            style="margin-bottom:var(--space-1);">Upload New Avatar</label>
                                        <input type="file" id="avatarFile" name="avatarFile"
                                            accept="image/png, image/jpeg, image/jpg"
                                            style="font-size:0.85rem; color:var(--color-gray-light);" />
                                        <span class="form-hint" style="display:block; margin-top:0.25rem;">PNG/JPG
                                            format only, max 5MB</span>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="fullName" class="form-label">
                                        Full Name <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <span class="input-icon"><i class="bi bi-person-fill"></i></span>
                                        <input type="text" id="fullName" name="fullName" class="form-control"
                                            placeholder="Enter your full name"
                                            value="<c:out value='${profile.fullName}'/>" required />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="phoneNumber" class="form-label">
                                        Phone Number <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <span class="input-icon"><i class="bi bi-telephone-fill"></i></span>
                                        <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control"
                                            placeholder="e.g. 0912345678" value="<c:out value='${user.phoneNumber}'/>"
                                            required />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="driverLicense" class="form-label">Driver License ID</label>
                                    <div class="input-wrapper">
                                        <span class="input-icon"><i class="bi bi-card-heading"></i></span>
                                        <input type="text" id="driverLicense" name="driverLicense" class="form-control"
                                            placeholder="Enter your driver license number"
                                            value="<c:out value='${profile.driverLicense}'/>" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="idCardNo" class="form-label">ID Card No. / National ID</label>
                                    <div class="input-wrapper">
                                        <span class="input-icon"><i class="bi bi-credit-card-2-front-fill"></i></span>
                                        <input type="text" id="idCardNo" name="idCardNo" class="form-control"
                                            placeholder="Enter your card identifier number"
                                            value="<c:out value='${profile.idCardNo}'/>" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="address" class="form-label">Address</label>
                                    <div class="input-wrapper">
                                        <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                                        <input type="text" id="address" name="address" class="form-control"
                                            placeholder="Enter your current billing address"
                                            value="<c:out value='${profile.address}'/>" />
                                    </div>
                                </div>

                                <div style="margin-top: 2rem; display: flex; gap: var(--space-4);">
                                    <button type="submit" class="btn btn-blue" id="saveProfileBtn">
                                        Save Changes
                                    </button>
                                    <a href="${pageContext.request.contextPath}/profile"
                                        class="btn btn-ghost">Cancel</a>
                                </div>
                            </form>
                        </div>

                        <!-- Right Side: Change Password Panel -->
                        <div class="edit-card">
                            <div class="edit-title-group">
                                <h2 class="edit-title">Change Password</h2>
                                <p class="edit-subtitle">Reset your account security keys.</p>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                            <!-- Forms passwords are kept empty on load -->
                            <form id="passwordForm"
                                action="${pageContext.request.contextPath}/profile?action=changePassword" method="post"
                                novalidate>

                                <div class="form-group">
                                    <label for="currentPassword" class="form-label">
                                        Current Password <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                                        <input type="password" id="currentPassword" name="currentPassword"
                                            class="form-control" placeholder="Enter current password"
                                            autocomplete="current-password" required />
                                        <button type="button" class="input-toggle"
                                            onclick="togglePasswordVisibility(this)"
                                            aria-label="Toggle visibility">👁</button>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="newPassword" class="form-label">
                                        New Password <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                                        <input type="password" id="newPassword" name="newPassword" class="form-control"
                                            placeholder="Min 8 characters" autocomplete="new-password" required />
                                        <button type="button" class="input-toggle"
                                            onclick="togglePasswordVisibility(this)"
                                            aria-label="Toggle visibility">👁</button>
                                    </div>
                                    <span class="form-hint">At least 8 characters complexity.</span>
                                </div>

                                <div class="form-group">
                                    <label for="confirmPassword" class="form-label">
                                        Confirm New Password <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                                        <input type="password" id="confirmPassword" name="confirmPassword"
                                            class="form-control" placeholder="Re-enter new password"
                                            autocomplete="new-password" required />
                                        <button type="button" class="input-toggle"
                                            onclick="togglePasswordVisibility(this)"
                                            aria-label="Toggle visibility">👁</button>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-blue btn-full" id="changePasswordBtn"
                                    style="margin-top: 1.5rem;">
                                    Update Security Key
                                </button>
                            </form>
                        </div>

                    </div>

                </div>
            </div>

            <jsp:include page="/WEB-INF/views/common/footer.jsp" />
                    <script>
                        

                    // Preview uploaded avatar image dynamically + validation
                    document.getElementById('avatarFile').addEventListener('change', function (e) {
                        var file = e.target.files[0];
                        if (file) {
                            // Validate size (BR11 - 5MB)
                            if (file.size > 5 * 1024 * 1024) {
                                showToast('Avatar image size must not exceed 5MB.', 'error');
                                e.target.value = ''; // clear input
                                return;
                            }
                            // Validate extension
                            var type = file.type;
                            if (type !== 'image/png' && type !== 'image/jpeg' && type !== 'image/jpg') {
                                showToast('Only PNG or JPG files are allowed.', 'error');
                                e.target.value = ''; // clear input
                                return;
                            }

                            var reader = new FileReader();
                            reader.onload = function (evt) {
                                var preview = document.getElementById('avatarPreview');
                                var placeholder = document.getElementById('avatarPlaceholder');
                                preview.src = evt.target.result;
                                preview.style.display = 'block';
                                if (placeholder) {
                                    placeholder.style.display = 'none';
                                }
                            };
                            reader.readAsDataURL(file);
                        }
                    });

                    // Client-side Profile Form validation
                    document.getElementById('profileForm').addEventListener('submit', function (e) {
                        var fullName = document.getElementById('fullName').value.trim();
                        var phone = document.getElementById('phoneNumber').value.trim();

                        if (!fullName || !phone) {
                            e.preventDefault();
                            showToast('Full Name and Phone Number are mandatory.', 'error');
                            return;
                        }

                        var btn = document.getElementById('saveProfileBtn');
                        btn.textContent = 'Saving...';
                        btn.classList.add('loading');
                    });

                    // Client-side Password Form validation
                    document.getElementById('passwordForm').addEventListener('submit', function (e) {
                        var currentPwd = document.getElementById('currentPassword').value;
                        var newPwd = document.getElementById('newPassword').value;
                        var confirmPwd = document.getElementById('confirmPassword').value;

                        if (!currentPwd || !newPwd || !confirmPwd) {
                            e.preventDefault();
                            showToast('All password fields are required.', 'error');
                            return;
                        }
                        if (newPwd.length < 8) {
                            e.preventDefault();
                            showToast('New password must be at least 8 characters.', 'error');
                            return;
                        }
                        if (currentPwd === newPwd) {
                            e.preventDefault();
                            showToast('New password cannot be identical to the current password.', 'error');
                            return;
                        }
                        if (newPwd !== confirmPwd) {
                            e.preventDefault();
                            showToast('New password and confirmation password do not match.', 'error');
                            return;
                        }

                        var btn = document.getElementById('changePasswordBtn');
                        btn.textContent = 'Updating...';
                        btn.classList.add('loading');
                    });
                </script>
        </body>

        </html>