<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Staff Control #ID ${staffDetail.userId} - Car Rental Admin</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
        <style>
            .detail-card {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-8);
                max-width: 700px;
                margin: var(--space-8) auto;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: var(--space-6);
            }

            @media (max-width: 576px) {
                .form-row {
                    grid-template-columns: 1fr;
                }
            }

            .status-badge {
                display: inline-block;
                font-size: 0.75rem;
                font-weight: 600;
                padding: var(--space-1) var(--space-3);
                border-radius: var(--radius-full);
                text-transform: uppercase;
            }

            .status-badge.active {
                background: rgba(16, 185, 129, 0.1);
                color: #10B981;
                border: 1px solid rgba(16, 185, 129, 0.2);
            }

            .status-badge.suspended {
                background: rgba(245, 158, 11, 0.1);
                color: #F59E0B;
                border: 1px solid rgba(245, 158, 11, 0.2);
            }

            .status-badge.blocked {
                background: rgba(239, 68, 68, 0.1);
                color: #EF4444;
                border: 1px solid rgba(239, 68, 68, 0.2);
            }
        </style>
    </head>

    <body>

        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="mgmt-wrapper">
            <!-- Admin Sidebar -->
            <aside class="mgmt-sidebar">
                <div class="mgmt-sidebar-header">
                    <div class="mgmt-sidebar-title"><i class="bi bi-shield-fill"></i> Admin Portal</div>
                    <div class="mgmt-sidebar-subtitle">System Control Panel</div>
                </div>
                <ul class="mgmt-menu">
                    <div class="mgmt-menu-section-title">Overview</div>
                    <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                    <div class="mgmt-menu-section-title">Management</div>
                    <li class="mgmt-menu-item active"><a href="${pageContext.request.contextPath}/admin/staff"><i class="bi bi-people-fill"></i> Manage Staff</a></li>
                    <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-person-lines-fill"></i> Manage Users</a></li>
                    <div class="mgmt-menu-section-title">Finance</div>
                    <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/admin/revenue"><i class="bi bi-bar-chart-line-fill"></i> Revenue Report</a></li>
                </ul>
                <div class="mgmt-sidebar-footer">
                    <div class="mgmt-user-info"><i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.email}"/></div>
                    <a href="${pageContext.request.contextPath}/logout" style="display:block; margin-top:0.5rem; font-size:0.8rem; color:#EF4444; text-decoration:none;"><i class="bi bi-box-arrow-right"></i> Logout</a>
                </div>
            </aside>
            <!-- Main Content -->
            <main class="mgmt-content">
                <div class="admin-container">



                    <c:choose>
                        <c:when test="${not empty staffDetail}">
                            <div class="detail-card">

                                <div class="mb-4"
                                     style="display:flex; justify-content:space-between; align-items:center;">
                                    <div>
                                        <h1 class="hero-title"
                                            style="font-size: 1.75rem; margin-bottom: 0.25rem; text-align: left;">
                                            Manage <span>Staff Profile</span></h1>

                                    </div>
                                    <div
                                        class="status-badge ${staffDetail.status == 'Active' ? 'active' : (staffDetail.status == 'Suspended' ? 'suspended' : 'blocked')}">
                                        <c:out value="${staffDetail.status}" />
                                    </div>
                                </div>
                                <div class="blue-line" style="margin-bottom: 2rem;"></div>

                                <!-- Update Form -->
                                <form action="${pageContext.request.contextPath}/admin/staff?action=update"
                                      method="post" id="updateStaffForm" enctype="multipart/form-data">
                                    <input type="hidden" name="staffId" value="${staffDetail.userId}" />

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="fullName" class="form-label">Full Name <span
                                                    class="required">*</span></label>
                                            <input type="text" name="fullName" id="fullName"
                                                   class="form-control"
                                                   value="<c:out value='${staffDetail.fullName}'/>" required />
                                        </div>

                                        <div class="form-group">
                                            <label for="email" class="form-label">Email Address <span
                                                    class="required">*</span></label>
                                            <input type="email" name="email" id="email" class="form-control"
                                                   value="<c:out value='${staffDetail.email}'/>" required />
                                        </div>
                                    </div>

                                    <div class="form-row" style="margin-top:var(--space-2);">
                                        <div class="form-group">
                                            <label for="phoneNumber" class="form-label">Phone Number <span
                                                    class="required">*</span></label>
                                            <input type="text" name="phoneNumber" id="phoneNumber"
                                                   class="form-control"
                                                   value="<c:out value='${staffDetail.phoneNumber}'/>" required />
                                        </div>

                                        <div class="form-group">
                                            <label for="status" class="form-label">Account Status <span
                                                    class="required">*</span></label>
                                            <select name="status" id="status" class="form-control"
                                                    style="background:var(--color-dark-surface); border-color:var(--color-dark-border); color:var(--color-white);">
                                                <option value="Active" ${staffDetail.status=='Active'
                                                                         ? 'selected' : '' }>Active</option>
                                                <option value="Suspended" ${staffDetail.status=='Suspended'
                                                                            ? 'selected' : '' }>Suspended</option>
                                                <option value="Blocked" ${staffDetail.status=='Blocked'
                                                                          ? 'selected' : '' }>Blocked</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group" style="margin-top:var(--space-2);">
                                        <label for="password" class="form-label">New Password</label>
                                        <input type="password" name="password" id="password"
                                               class="form-control"
                                               placeholder="Leave blank to keep current password" />
                                        <span class="form-hint">Enter new password only if you wish to reset
                                            it.</span>
                                    </div>

                                    <div class="form-group" style="margin-top:var(--space-2);">
                                        <label class="form-label">Avatar Image</label>
                                        <input type="hidden" name="croppedAvatarBase64" id="croppedAvatarBase64" />
                                        <input type="file" name="avatarFile" id="avatarFile" accept="image/png, image/jpeg, image/jpg" style="display:none;" />

                                        <div style="display:flex; align-items:center; gap:1.5rem;">
                                            <div id="headerAvatarBtn" style="position:relative; width:80px; height:80px; cursor:pointer; border-radius:50%; border:3px solid var(--orange); overflow:hidden; background:var(--color-dark-card); display:flex; align-items:center; justify-content:center; transition:transform 0.2s;" title="Click to change avatar">
                                                <c:choose>
                                                    <c:when test="${not empty staffDetail.avatarUrl}">
                                                        <img id="staffAvatarPreview" src="${fn:startsWith(staffDetail.avatarUrl, 'http') || fn:startsWith(staffDetail.avatarUrl, pageContext.request.contextPath) ? staffDetail.avatarUrl : pageContext.request.contextPath.concat(staffDetail.avatarUrl)}" style="width:100%; height:100%; object-fit:cover;" alt="Avatar" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div id="staffAvatarInitials" style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; background:var(--orange-pale); color:var(--orange-dark); font-weight:700; font-size:2rem;">
                                                            <c:out value="${fn:substring(staffDetail.fullName, 0, 1)}"/>
                                                        </div>
                                                        <img id="staffAvatarPreview" style="width:100%; height:100%; object-fit:cover; display:none;" alt="Avatar" />
                                                    </c:otherwise>
                                                </c:choose>
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

                                    <!-- Submit and cancellation actions -->
                                    <div
                                        style="margin-top:2rem; display:flex; justify-content:space-between; align-items:center;">
                                        <div style="display:flex; gap:var(--space-3);">
                                            <button type="submit" class="btn btn-blue btn-sm">Save
                                                Changes</button>
                                            <a href="${pageContext.request.contextPath}/admin/staff?action=list"
                                               class="btn btn-ghost btn-sm"
                                               style="display:flex; align-items:center;">Cancel</a>
                                        </div>
                                    </div>
                                </form>



                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon"><i class="bi bi-shield-slash"></i></div>
                                <div class="empty-state-title">No staff available</div>
                                <p class="text-muted text-sm" style="margin-top:0.5rem;">The requested personnel
                                    profile could not be loaded.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

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
                            showToast("Photo cropped successfully! Click 'Save Changes' to update staff profile.", "success");
                        });

                        document.getElementById('updateStaffForm').addEventListener('submit', function (e) {
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