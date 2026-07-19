<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Account Management - CarRental</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cropper.min.css" />
                <style>
                    .profile-container {
                        max-width: 1200px;
                        margin: var(--sp-8) auto;
                        padding: 0 var(--sp-4);
                    }

                    .profile-header-card {
                        background: var(--white);
                        border: 1px solid var(--border);
                        border-radius: var(--r-xl);
                        padding: var(--sp-6);
                        display: flex;
                        align-items: center;
                        gap: var(--sp-6);
                        margin-bottom: var(--sp-6);
                        box-shadow: var(--shadow-sm);
                    }

                    .profile-header-avatar {
                        width: 100px;
                        height: 100px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 3.5px solid var(--orange);
                        background: var(--bg-alt);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 2.5rem;
                        color: var(--text-muted);
                        transition: transform 0.2s ease, box-shadow 0.2s ease;
                    }

                    .profile-header-avatar:hover {
                        transform: scale(1.03);
                        box-shadow: 0 0 15px rgba(249, 115, 22, 0.35);
                    }

                    .profile-header-info {
                        display: flex;
                        flex-direction: column;
                        gap: var(--sp-1);
                    }

                    .profile-header-name {
                        font-size: var(--text-2xl);
                        font-weight: 800;
                        color: var(--text-primary);
                    }

                    .profile-header-badge {
                        align-self: flex-start;
                        background: var(--orange-pale);
                        border: 1.5px solid var(--orange-border);
                        color: var(--orange);
                        font-size: var(--text-xs);
                        font-weight: 700;
                        padding: var(--sp-1) var(--sp-3);
                        border-radius: var(--r-full);
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .profile-grid {
                        display: grid;
                        grid-template-columns: 1.2fr 0.8fr;
                        gap: var(--sp-6);
                        align-items: start;
                    }

                    @media (max-width: 992px) {
                        .profile-grid {
                            grid-template-columns: 1fr;
                        }

                        .profile-header-card {
                            flex-direction: column;
                            text-align: center;
                            gap: var(--sp-3);
                        }

                        .profile-header-badge {
                            align-self: center;
                        }
                    }

                    .profile-card {
                        background: var(--white);
                        border: 1px solid var(--border);
                        border-radius: var(--r-xl);
                        padding: var(--sp-6);
                        box-shadow: var(--shadow-sm);
                    }

                    .profile-card-title {
                        font-size: var(--text-xl);
                        font-weight: 700;
                        color: var(--text-primary);
                        margin-bottom: var(--sp-1);
                    }

                    .profile-card-subtitle {
                        font-size: var(--text-sm);
                        color: var(--text-muted);
                        margin-bottom: var(--sp-4);
                    }

                    .form-group {
                        margin-bottom: var(--sp-4);
                    }

                    .form-label {
                        display: block;
                        font-size: var(--text-sm);
                        font-weight: 600;
                        color: var(--text-primary);
                        margin-bottom: var(--sp-2);
                    }

                    .form-label span.required {
                        color: var(--error);
                    }

                    .input-wrapper {
                        position: relative;
                        display: flex;
                        align-items: center;
                    }

                    .input-icon {
                        position: absolute;
                        left: var(--sp-3);
                        color: var(--text-faint);
                        font-size: 1.1rem;
                        pointer-events: none;
                    }

                    .form-control {
                        width: 100%;
                        padding: 0.75rem var(--sp-3) 0.75rem 2.5rem;
                        font-family: var(--font-body);
                        font-size: var(--text-sm);
                        color: var(--text-body);
                        background: var(--white);
                        border: 1.5px solid var(--border);
                        border-radius: var(--r-md);
                        transition: var(--t-fast);
                    }

                    .form-control:focus {
                        outline: none;
                        border-color: var(--orange);
                        box-shadow: 0 0 0 3px var(--orange-glow);
                    }

                    .form-control:disabled {
                        background: var(--bg-alt);
                        color: var(--text-muted);
                        cursor: not-allowed;
                    }

                    .input-toggle {
                        position: absolute;
                        right: var(--sp-3);
                        background: none;
                        border: none;
                        color: var(--text-muted);
                        cursor: pointer;
                        font-size: 1rem;
                    }

                    .form-hint {
                        display: block;
                        font-size: var(--text-xs);
                        color: var(--text-muted);
                        margin-top: var(--sp-1);
                    }

                    .avatar-upload-preview {
                        display: flex;
                        align-items: center;
                        gap: var(--sp-4);
                        margin-bottom: var(--sp-5);
                        background: var(--bg-alt);
                        padding: var(--sp-4);
                        border-radius: var(--r-lg);
                        border: 1px dashed var(--border);
                        transition: border-color 0.2s ease, background 0.2s ease;
                    }

                    .avatar-upload-preview:hover {
                        border-color: var(--orange);
                        background: var(--orange-glow);
                    }

                    .upload-preview-img {
                        width: 70px;
                        height: 70px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 2px solid var(--orange);
                    }

                    .upload-preview-placeholder {
                        width: 70px;
                        height: 70px;
                        border-radius: 50%;
                        background: var(--white);
                        border: 2px solid var(--border);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: var(--text-faint);
                    }

                    /* Image Cropper Modal styling */
                    .image-cropper-modal {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.75);
                        z-index: 9999;
                        align-items: center;
                        justify-content: center;
                    }

                    .image-cropper-modal-content {
                        background: var(--white);
                        border: 1px solid var(--border);
                        border-radius: var(--r-xl);
                        width: 90%;
                        max-width: 500px;
                        padding: var(--sp-6);
                        box-shadow: var(--shadow-xl);
                        box-sizing: border-box;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/WEB-INF/views/common/header.jsp" />

                <div class="page-wrapper">
                    <div class="profile-container">

                        <!-- Profile Header -->
                        <div class="profile-header-card">
                            <div id="headerAvatarBtn" class="profile-header-avatar"
                                style="cursor:pointer; position:relative;" title="Click to change avatar">
                                <c:choose>
                                    <c:when test="${not empty profile.avatarUrl}">
                                        <img id="headerAvatarPreview" src="${profile.avatarUrl}"
                                            style="width:100%; height:100%; border-radius:50%; object-fit:cover;"
                                            alt="${profile.fullName}" />
                                    </c:when>
                                    <c:otherwise>
                                        <i id="headerAvatarIcon" class="bi bi-person-fill"></i>
                                        <img id="headerAvatarPreview"
                                            style="width:100%; height:100%; border-radius:50%; object-fit:cover; display:none;"
                                            alt="Avatar" />
                                    </c:otherwise>
                                </c:choose>
                                <div
                                    style="position:absolute; bottom:0; right:0; background:var(--orange); border-radius:50%; width:26px; height:26px; display:flex; align-items:center; justify-content:center; border:2px solid var(--white); color:#FFF; font-size:0.8rem;">
                                    <i class="bi bi-camera-fill"></i>
                                </div>
                            </div>
                            <div class="profile-header-info">
                                <div class="profile-header-name">
                                    <c:out value="${not empty profile.fullName ? profile.fullName : 'Welcome!'}" />
                                </div>
                                <div class="profile-header-badge">
                                    <c:choose>
                                        <c:when test="${user.roleId == 1}">Admin</c:when>
                                        <c:when test="${user.roleId == 2}">Staff</c:when>
                                        <c:when test="${user.roleId == 3}">Customer</c:when>
                                        <c:when test="${user.roleId == 4}">Owner</c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Profile Grid -->
                        <div class="profile-grid">

                            <!-- Left Side: Profile Form -->
                            <div class="profile-card">
                                <div class="profile-card-title">Personal Details</div>
                                <div class="profile-card-subtitle">Manage your personal credentials, contact info, and
                                    documents.</div>
                                <div class="blue-line" style="margin-bottom: 1.5rem;"></div>

                                <form id="profileForm" action="${pageContext.request.contextPath}/profile?action=edit"
                                    method="post" enctype="multipart/form-data" novalidate>

                                    <input type="file" id="avatarFile" name="avatarFile"
                                        accept="image/png, image/jpeg, image/jpg" style="display:none;" />
                                    <input type="hidden" id="croppedAvatarBase64" name="croppedAvatarBase64" />

                                    <!-- Email (Disabled) -->
                                    <div class="form-group">
                                        <label class="form-label">Email Address</label>
                                        <div class="input-wrapper">
                                            <span class="input-icon"><i class="bi bi-envelope-fill"></i></span>
                                            <input type="text" class="form-control"
                                                value="<c:out value='${user.email}'/>" disabled />
                                        </div>
                                    </div>

                                    <!-- Full Name (Required) -->
                                    <div class="form-group">
                                        <label for="fullName" class="form-label">Full Name <span
                                                class="required">*</span></label>
                                        <div class="input-wrapper">
                                            <span class="input-icon"><i class="bi bi-person-fill"></i></span>
                                            <input type="text" id="fullName" name="fullName" class="form-control"
                                                placeholder="Enter your full name"
                                                value="<c:out value='${profile.fullName}'/>" required />
                                        </div>
                                    </div>

                                    <!-- Phone Number (Required) -->
                                    <div class="form-group">
                                        <label for="phoneNumber" class="form-label">Phone Number <span
                                                class="required">*</span></label>
                                        <div class="input-wrapper">
                                            <span class="input-icon"><i class="bi bi-telephone-fill"></i></span>
                                            <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control"
                                                placeholder="e.g. 0912345678"
                                                value="<c:out value='${user.phoneNumber}'/>" required />
                                        </div>
                                    </div>

                                    <!-- Driver License -->
                                    <div class="form-group">
                                        <label for="driverLicense" class="form-label">Driver License No.</label>
                                        <div class="input-wrapper">
                                            <span class="input-icon"><i class="bi bi-card-heading"></i></span>
                                            <input type="text" id="driverLicense" name="driverLicense"
                                                class="form-control" placeholder="Enter your driver license number"
                                                value="<c:out value='${profile.driverLicense}'/>" />
                                        </div>
                                    </div>

                                    <!-- ID Card No -->
                                    <div class="form-group">
                                        <label for="idCardNo" class="form-label">ID Card No. / National ID</label>
                                        <div class="input-wrapper">
                                            <span class="input-icon"><i
                                                    class="bi bi-credit-card-2-front-fill"></i></span>
                                            <input type="text" id="idCardNo" name="idCardNo" class="form-control"
                                                placeholder="Enter your national ID number"
                                                value="<c:out value='${profile.idCardNo}'/>" />
                                        </div>
                                    </div>

                                    <!-- Address -->
                                    <div class="form-group">
                                        <label for="address" class="form-label">Address</label>
                                        <div class="input-wrapper">
                                            <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                                            <input type="text" id="address" name="address" class="form-control"
                                                placeholder="Enter your home address"
                                                value="<c:out value='${profile.address}'/>" />
                                        </div>
                                    </div>

                                    <div style="margin-top: var(--sp-6); display: flex; gap: var(--sp-4);">
                                        <button type="submit" class="btn btn-blue" id="saveProfileBtn">
                                            Save Changes
                                        </button>
                                        <a href="${pageContext.request.contextPath}/home" class="btn btn-ghost">
                                            Back to Home
                                        </a>
                                    </div>
                                </form>
                            </div>

                            <!-- Right Side: Change Password Form -->
                            <div class="profile-card">
                                <div class="profile-card-title">Change Password</div>
                                <div class="profile-card-subtitle">Reset your account login password.</div>
                                <div class="blue-line" style="margin-bottom: 1.5rem;"></div>

                                <form id="passwordForm"
                                    action="${pageContext.request.contextPath}/profile?action=changePassword"
                                    method="post" novalidate>

                                    <!-- Current Password -->
                                    <div class="form-group">
                                        <label for="currentPassword" class="form-label">Current Password <span
                                                class="required">*</span></label>
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

                                    <!-- New Password -->
                                    <div class="form-group">
                                        <label for="newPassword" class="form-label">New Password <span
                                                class="required">*</span></label>
                                        <div class="input-wrapper">
                                            <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                                            <input type="password" id="newPassword" name="newPassword"
                                                class="form-control" placeholder="Min 8 characters"
                                                autocomplete="new-password" required />
                                            <button type="button" class="input-toggle"
                                                onclick="togglePasswordVisibility(this)"
                                                aria-label="Toggle visibility">👁</button>
                                        </div>
                                        <span class="form-hint">At least 8 characters complexity.</span>
                                    </div>

                                    <!-- Confirm Password -->
                                    <div class="form-group">
                                        <label for="confirmPassword" class="form-label">Confirm New Password <span
                                                class="required">*</span></label>
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

                                    <button type="submit" class="btn btn-blue" id="changePasswordBtn"
                                        style="width: 100%; margin-top: var(--sp-4);">
                                        Update Password
                                    </button>
                                </form>
                            </div>

                        </div>

                    </div>
                </div>

                <!-- Image Cropper Modal -->
                <div id="cropperModal" class="image-cropper-modal">
                    <div class="image-cropper-modal-content">
                        <h3
                            style="font-family:var(--font-display); font-weight:700; font-size:1.25rem; color:var(--text-primary); display:flex; align-items:center; gap:0.5rem; margin-bottom:0.5rem;">
                            <i class="bi bi-crop" style="color:var(--orange);"></i> Crop Avatar Image
                        </h3>
                        <p style="color:var(--text-muted); font-size:0.85rem; margin-bottom:1.5rem; text-align:left;">
                            Drag and resize the box to crop your avatar perfectly.</p>
                        <div
                            style="max-width:100%; max-height:300px; overflow:hidden; display:flex; justify-content:center; align-items:center; background:#000; border-radius:var(--r-md); margin-bottom:1.5rem;">
                            <img id="cropperImageSource" src="" style="max-width:100%; max-height:300px;" />
                        </div>
                        <div style="display:flex; justify-content:flex-end; gap:var(--sp-2);">
                            <button type="button" class="btn btn-ghost" onclick="closeCropperModal()">Cancel</button>
                            <button type="button" class="btn btn-blue" id="btnPerformCrop">Crop & Save</button>
                        </div>
                    </div>
                </div>

                <jsp:include page="/WEB-INF/views/common/footer.jsp" />

                <script src="${pageContext.request.contextPath}/js/cropper.min.js"></script>
                <script>
                    let cropperInstance = null;

                    // Click handlers on Avatar items to trigger hidden file selection
                    document.getElementById('headerAvatarBtn').addEventListener('click', function () {
                        document.getElementById('avatarFile').click();
                    });

                    // Close Cropper Modal Helper
                    function closeCropperModal() {
                        document.getElementById("cropperModal").style.display = "none";
                        if (cropperInstance) {
                            cropperInstance.destroy();
                            cropperInstance = null;
                        }
                        document.getElementById('avatarFile').value = ''; // clear input
                    }

                    // Toggle password visibility helper
                    function togglePasswordVisibility(btn) {
                        var input = btn.previousElementSibling;
                        if (input.type === 'password') {
                            input.type = 'text';
                            btn.textContent = '🙈';
                        } else {
                            input.type = 'password';
                            btn.textContent = '👁';
                        }
                    }

                    // Preview uploaded avatar image dynamically + crop integration
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
                                // Open cropper modal
                                document.getElementById("cropperModal").style.display = "flex";
                                const cropperImg = document.getElementById("cropperImageSource");
                                cropperImg.src = evt.target.result;

                                if (cropperInstance) {
                                    cropperInstance.destroy();
                                }

                                cropperInstance = new Cropper(cropperImg, {
                                    aspectRatio: 1.0,
                                    viewMode: 1,
                                    dragMode: 'move',
                                    autoCropArea: 0.9,
                                    restore: false,
                                    guides: true,
                                    center: true,
                                    highlight: false,
                                    cropBoxMovable: true,
                                    cropBoxResizable: true,
                                    toggleDragModeOnDblclick: false
                                });
                            };
                            reader.readAsDataURL(file);
                        }
                    });

                    // Perform crop click handler
                    document.getElementById("btnPerformCrop").addEventListener("click", function () {
                        if (!cropperInstance) return;

                        const canvas = cropperInstance.getCroppedCanvas({
                            width: 300,
                            height: 300,
                            imageSmoothingEnabled: true,
                            imageSmoothingQuality: 'high'
                        });

                        const base64Image = canvas.toDataURL("image/jpeg", 0.9);

                        // Store in hidden input field
                        document.getElementById("croppedAvatarBase64").value = base64Image;

                        // Update previews

                        var headerPreview = document.getElementById('headerAvatarPreview');
                        var headerIcon = document.getElementById('headerAvatarIcon');
                        headerPreview.src = base64Image;
                        headerPreview.style.display = 'block';
                        if (headerIcon) {
                            headerIcon.style.display = 'none';
                        }

                        closeCropperModal();
                        showToast("Photo cropped successfully! Click 'Save Changes' to update your account.", "success");
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