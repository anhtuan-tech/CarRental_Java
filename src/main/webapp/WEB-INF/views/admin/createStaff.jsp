<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Provision Staff - Car Rental Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
        <style>
            .form-card {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-8);
                max-width: 600px;
                margin: var(--space-8) auto;
            }
        </style>
        <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>

    <body>

        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="mgmt-wrapper">
            <!-- Admin Sidebar -->
            <jsp:include page="/WEB-INF/views/common/adminSidebar.jsp">
                <jsp:param name="activeMenu" value="staff" />
            </jsp:include>
            <!-- Main Content -->
            <main class="mgmt-content">
                <div class="admin-container">



                    <div class="form-card">

                        <div class="mb-4">
                            <h1 class="hero-title"
                                style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">
                                <span>New Staff</span>
                            </h1>
                            <p class="text-muted text-sm">Register new back-office personnel. A secure default hashed
                                temporary password will be assigned.</p>
                        </div>
                        <div class="blue-line" style="margin-bottom: 2rem;"></div>

                        <form action="${pageContext.request.contextPath}/admin/staff?action=create" method="post"
                              id="createStaffForm" enctype="multipart/form-data">

                            <div class="form-group">
                                <label for="fullName" class="form-label">Full Name <span
                                        class="required">*</span></label>
                                <input type="text" name="fullName" id="fullName" class="form-control"
                                       placeholder="Enter staff full name..."
                                       value="<c:out value='${requestScope.fullNameVal}'/>" required />
                            </div>

                            <div class="form-group">
                                <label for="email" class="form-label">Email Address <span
                                        class="required">*</span></label>
                                <input type="email" name="email" id="email" class="form-control"
                                       placeholder="staff.name@carrental.com"
                                       value="<c:out value='${requestScope.emailVal}'/>" required />
                                <span class="form-hint">Must be strictly unique across the platform database.</span>
                            </div>

                            <div class="form-group">
                                <label for="phoneNumber" class="form-label">Phone Number <span
                                        class="required">*</span></label>
                                <input type="text" name="phoneNumber" id="phoneNumber" class="form-control"
                                       placeholder="Enter mobile contact number..."
                                       value="<c:out value='${requestScope.phoneVal}'/>" required />
                                <span class="form-hint">Enter 10-11 digit telephone numeric context.</span>
                            </div>

                            <div class="form-group">
                                <label for="password" class="form-label">Account Password <span
                                        class="required">*</span></label>
                                <input type="password" name="password" id="password" class="form-control"
                                       placeholder="Enter account password..." required />
                                <span class="form-hint">Password complexity rules apply.</span>
                            </div>

                            <div class="form-group" style="margin-top:var(--space-2);">
                                <label class="form-label">Avatar Image</label>
                                <input type="hidden" name="croppedAvatarBase64" id="croppedAvatarBase64" />
                                <input type="file" name="avatarFile" id="avatarFile" accept="image/png, image/jpeg, image/jpg" style="display:none;" />

                                <div style="display:flex; align-items:center; gap:1.5rem;">
                                    <div id="headerAvatarBtn" style="position:relative; width:80px; height:80px; cursor:pointer; border-radius:50%; border:3px solid var(--orange); overflow:hidden; background:var(--color-dark-card); display:flex; align-items:center; justify-content:center; transition:transform 0.2s;" title="Click to change avatar">
                                        <div id="staffAvatarInitials" style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; background:var(--orange-pale); color:var(--orange-dark); font-weight:700; font-size:2rem;">
                                            <i class="bi bi-person-fill"></i>
                                        </div>
                                        <img id="staffAvatarPreview" style="width:100%; height:100%; object-fit:cover; display:none;" alt="Avatar" />
                                        <div style="position:absolute; bottom:0; width:100%; background:rgba(0,0,0,0.6); color:#fff; text-align:center; font-size:0.65rem; padding:2px 0;">
                                            <i class="bi bi-camera-fill"></i>
                                        </div>
                                    </div>
                                    <div>
                                        <button type="button" class="btn btn-outline-blue btn-sm" onclick="document.getElementById('avatarFile').click();">
                                            <i class="bi bi-cloud-arrow-up-fill"></i> Choose New Photo
                                        </button>
                                        <div class="form-hint" style="margin-top:0.4rem;">Click avatar or button to upload & crop. JPG/PNG max 5MB.</div>
                                    </div>
                                </div>
                            </div>

                            <div style="margin-top:2rem; display:flex; gap:var(--space-3);">
                                <button type="submit" class="btn btn-blue btn-sm">Create Staff Account</button>
                                <a href="${pageContext.request.contextPath}/admin/staff?action=list"
                                   class="btn btn-ghost btn-sm" style="display:flex; align-items:center;">Cancel</a>
                            </div>
                        </form>

                    </div>

                </div>
            </main>
        </div>

        <!-- Cropper Modal -->
        <div id="cropperModal" class="modal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.8); justify-content:center; align-items:center;">
            <div class="modal-content" style="background:var(--color-dark-card); border:1px solid var(--color-dark-border); border-radius:var(--radius-xl); padding:1.5rem; width:90%; max-width:500px; text-align:center;">
                <h3 style="margin-bottom:0.5rem; color:var(--color-white); font-size:1.25rem;">
                    <i class="bi bi-crop" style="color:var(--orange);"></i> Crop Staff Avatar
                </h3>
                <p style="color:var(--color-gray-light); font-size:0.85rem; margin-bottom:1.5rem;">
                    Drag and resize the box to crop the avatar image.</p>
                <div style="max-width:100%; max-height:300px; overflow:hidden; display:flex; justify-content:center; align-items:center; background:#000; border-radius:var(--radius-lg); margin-bottom:1.5rem;">
                    <img id="cropperImageSource" src="" style="max-width:100%; max-height:300px;" />
                </div>
                <div style="display:flex; justify-content:flex-end; gap:0.5rem;">
                    <button type="button" class="btn btn-ghost" onclick="closeCropperModal()">Cancel</button>
                    <button type="button" class="btn btn-blue" id="btnPerformCrop">Crop & Save</button>
                </div>
            </div>
        </div>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cropper.min.css" />
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        <script src="${pageContext.request.contextPath}/js/cropper.min.js"></script>

        <script>
                        let cropperInstance = null;

                        document.getElementById('headerAvatarBtn').addEventListener('click', function () {
                            document.getElementById('avatarFile').click();
                        });

                        function closeCropperModal() {
                            document.getElementById("cropperModal").style.display = "none";
                            if (cropperInstance) {
                                cropperInstance.destroy();
                                cropperInstance = null;
                            }
                            document.getElementById('avatarFile').value = '';
                        }

                        document.getElementById('avatarFile').addEventListener('change', function (e) {
                            var file = e.target.files[0];
                            if (file) {
                                if (file.size > 5 * 1024 * 1024) {
                                    showToast('Avatar image size must not exceed 5MB.', 'error');
                                    e.target.value = '';
                                    return;
                                }
                                var type = file.type;
                                if (type !== 'image/png' && type !== 'image/jpeg' && type !== 'image/jpg') {
                                    showToast('Only PNG or JPG files are allowed.', 'error');
                                    e.target.value = '';
                                    return;
                                }

                                var reader = new FileReader();
                                reader.onload = function (evt) {
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

                        document.getElementById("btnPerformCrop").addEventListener("click", function () {
                            if (!cropperInstance)
                                return;

                            const canvas = cropperInstance.getCroppedCanvas({
                                width: 300,
                                height: 300,
                                imageSmoothingEnabled: true,
                                imageSmoothingQuality: 'high'
                            });

                            const base64Image = canvas.toDataURL("image/jpeg", 0.9);

                            document.getElementById("croppedAvatarBase64").value = base64Image;

                            var preview = document.getElementById('staffAvatarPreview');
                            var initials = document.getElementById('staffAvatarInitials');
                            if (preview) {
                                preview.src = base64Image;
                                preview.style.display = 'block';
                            }
                            if (initials) {
                                initials.style.display = 'none';
                            }

                            closeCropperModal();
                            showToast("Photo cropped successfully! Click 'Create Staff Account' to finish.", "success");
                        });


                        document.getElementById('createStaffForm').addEventListener('submit', function (e) {
                            var email = document.getElementById('email').value.trim();
                            var phone = document.getElementById('phoneNumber').value.trim();
                            var name = document.getElementById('fullName').value.trim();

                            if (!email || !phone || !name) {
                                e.preventDefault();
                                showToast('All fields marked with an asterisk (*) are mandatory.', 'error');
                                return;
                            }

                            var phonePattern = /^[0-9]{10,11}$/;
                            if (!phonePattern.test(phone)) {
                                e.preventDefault();
                                showToast('Invalid phone number format. Please insert 10 or 11 numeric digits.', 'error');
                            }
                        });
        </script>
    </body>

</html>