<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Vehicle Details — Car Rental Owner</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cropper.min.css" />
        <style>
            .admin-container {
                max-width: 100%;
                margin: 0 auto;
                padding: 0 var(--space-4);
            }

            .detail-grid {
                display: grid;
                grid-template-columns: 1fr 1.1fr;
                gap: var(--space-8);
                margin-top: var(--space-4);
            }

            @media (max-width: 992px) {
                .detail-grid {
                    grid-template-columns: 1fr;
                }
            }

            .car-image-banner {
                width: 100%;
                height: 350px;
                border-radius: var(--radius-xl);
                overflow: hidden;
                border: 1px solid var(--color-dark-border);
                box-shadow: var(--shadow-md);
                margin-bottom: var(--space-6);
            }

            .car-image-banner img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
            }

            .car-placeholder {
                width: 100%;
                height: 350px;
                border-radius: var(--radius-xl);
                background: var(--color-dark-surface);
                border: 1px solid var(--color-dark-border);
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--color-gray-light);
                font-size: 4rem;
                margin-bottom: var(--space-6);
            }

            .update-card {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-6);
                position: sticky;
                top: calc(var(--navbar-height) + var(--space-6));
            }

            .history-card {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-6);
                margin-top: var(--space-6);
            }

            .history-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 0.9rem;
                margin-top: var(--space-4);
            }

            .history-table th,
            .history-table td {
                padding: var(--space-3);
                text-align: left;
                border-bottom: 1px solid var(--color-dark-border);
            }

            .history-table th {
                color: var(--color-gray-light);
                font-weight: 600;
                font-size: 0.8rem;
                text-transform: uppercase;
            }

            .history-table td {
                color: var(--color-white);
            }

            /* ── Status badges ───────────────────────────────────── */
            .status-badge {
                display: inline-block;
                font-size: 0.75rem;
                font-weight: 600;
                padding: var(--space-1) var(--space-3);
                border-radius: var(--radius-full);
                text-transform: uppercase;
            }

            .status-badge.pending {
                background: rgba(245, 158, 11, 0.1);
                color: #F59E0B;
                border: 1px solid rgba(245, 158, 11, 0.2);
            }

            .status-badge.confirmed {
                background: rgba(59, 130, 246, 0.1);
                color: #3B82F6;
                border: 1px solid rgba(59, 130, 246, 0.2);
            }

            .status-badge.active {
                background: rgba(139, 92, 246, 0.1);
                color: #8B5CF6;
                border: 1px solid rgba(139, 92, 246, 0.2);
            }

            .status-badge.completed {
                background: rgba(16, 185, 129, 0.1);
                color: #10B981;
                border: 1px solid rgba(16, 185, 129, 0.2);
            }

            .status-badge.rejected {
                background: rgba(239, 68, 68, 0.1);
                color: #EF4444;
                border: 1px solid rgba(239, 68, 68, 0.2);
            }

            .car-status-label {
                display: inline-block;
                font-size: 0.8rem;
                font-weight: 600;
                padding: 0.2rem 0.6rem;
                border-radius: 4px;
                text-transform: uppercase;
            }

            .car-status-label.available {
                background: rgba(16, 185, 129, 0.1);
                color: #10B981;
                border: 1px solid rgba(16, 185, 129, 0.2);
            }

            .car-status-label.pending {
                background: rgba(245, 158, 11, 0.1);
                color: #F59E0B;
                border: 1px solid rgba(245, 158, 11, 0.2);
            }

            .car-status-label.rejected {
                background: rgba(239, 68, 68, 0.1);
                color: #EF4444;
                border: 1px solid rgba(239, 68, 68, 0.2);
            }

            .car-image-banner-wrapper:hover .image-overlay {
                opacity: 1 !important;
            }

            .image-cropper-modal {
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                background: rgba(0, 0, 0, 0.85);
                z-index: 99999;
                display: none;
                align-items: center;
                justify-content: center;
                backdrop-filter: blur(4px);
            }

            .image-cropper-modal-content {
                background: #111827;
                border: 1px solid #374151;
                border-radius: 12px;
                width: 90%;
                max-width: 650px;
                padding: 2rem;
                box-sizing: border-box;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            }

            .img-container {
                width: 100%;
                max-height: 400px;
                margin-top: 1rem;
                background-color: #000;
                overflow: hidden;
                border-radius: 8px;
            }

            .img-container img {
                display: block;
                max-width: 100%;
                height: auto;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <div class="mgmt-wrapper">
            <jsp:include page="/WEB-INF/views/owner/ownerSidebar.jsp"/>

            <!-- Main Content -->
            <main class="mgmt-content">
                <div class="admin-container" style="padding-top: var(--space-4);">

                    <div
                        style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
                        <div>
                            <h1 class="hero-title"
                                style="font-size: 2rem; margin-bottom: 0.25rem; text-align: left;">
                                <c:out value="${car.brand}" /> <span>
                                    <c:out value="${car.carName}" />
                                </span>
                            </h1>
                            <p class="text-muted text-sm">
                                License Plate: <strong style="color:var(--color-white);">
                                    <c:out value="${car.licensePlate}" />
                                </strong> &bull;
                                Category: <span style="color:var(--color-blue-light);">
                                    <c:out value="${car.typeName}" />
                                </span>
                            </p>
                        </div>
                        <div>
                            <span
                                class="car-status-label ${car.status == 'Available' || car.status == 'Approved' ? 'available' : (car.status == 'Rejected' ? 'rejected' : 'pending')}">
                                <c:out value="${car.status == 'Pending_Approval' ? 'Pending' : car.status}" />
                            </span>
                        </div>
                    </div>
                    <div class="blue-line" style="margin-bottom: 2rem;"></div>

                    <div class="detail-grid">
                        <!-- Left: Media Banner & Rental History -->
                        <div>
                            <div class="car-image-banner-wrapper"
                                 style="position: relative; cursor: pointer; margin-bottom: var(--space-6);"
                                 onclick="changeCarImage()">
                                <c:choose>
                                    <c:when test="${not empty car.primaryImageUrl}">
                                        <div class="car-image-banner" style="margin-bottom:0;">
                                            <img id="displayCarImg" src="${pageContext.request.contextPath}${car.primaryImageUrl}"
                                                 alt="${car.carName}" />
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="car-placeholder" id="displayCarPlaceholder"
                                             style="margin-bottom:0;">
                                            <i class="bi bi-car-front-fill"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="image-overlay"
                                     style="position: absolute; top:0; left:0; width:100%; height:350px; background: rgba(0,0,0,0.5); display: flex; flex-direction:column; align-items:center; justify-content:center; border-radius: var(--radius-xl); opacity:0; transition: opacity 0.2s ease;">
                                    <i class="bi bi-camera-fill"
                                       style="font-size:2.5rem; color:#FFF; margin-bottom:0.5rem;"></i>
                                    <span style="color:#FFF; font-weight:700; font-size:1rem;">Click to Change
                                        Image</span>
                                </div>
                            </div>

                            <input type="file" id="carImageFileInput" accept="image/*" style="display:none;" />

                            <!-- Cropper Modal -->
                            <div id="cropperModal" class="image-cropper-modal"
                                 style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.85); z-index:9999; align-items:center; justify-content:center;">
                                <div class="image-cropper-modal-content"
                                     style="background:var(--color-dark-card); border:1px solid var(--color-dark-border); border-radius:var(--radius-xl); width:90%; max-width:600px; padding:2rem; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.5); box-sizing:border-box;">
                                    <h3
                                        style="color:var(--color-white); font-weight:700; margin-bottom:1rem; display:flex; align-items:center; gap:0.5rem; text-align:left; margin-top:0;">
                                        <i class="bi bi-crop" style="color:var(--color-blue-light);"></i> Crop
                                        Vehicle Photo
                                    </h3>
                                    <p
                                        style="color:var(--color-gray-light); font-size:0.85rem; margin-bottom:1.5rem; text-align:left;">
                                        Drag and resize the box to crop your vehicle image perfectly.</p>

                                    <div class="img-container"
                                         style="max-height:350px; overflow:hidden; background:#000; border-radius:var(--radius-lg); display:flex; align-items:center; justify-content:center;">
                                        <img id="cropperImageSource" src=""
                                             style="max-width:100%; max-height:350px;" />
                                    </div>

                                    <div
                                        style="display:flex; justify-content:flex-end; gap:1rem; margin-top:2rem;">
                                        <button type="button" class="btn btn-ghost"
                                                onclick="closeCropperModal()">Cancel</button>
                                        <button type="button" class="btn btn-blue" id="btnPerformCrop">Crop &
                                            Save Image</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Rental History Log -->
                            <div class="history-card">
                                <h3
                                    style="font-size:1.15rem; font-weight:700; color:var(--color-white); display:flex; align-items:center; gap:0.5rem;">
                                    <i class="bi bi-calendar3" style="color:var(--color-blue-light);"></i>
                                    Rental History
                                </h3>
                                <c:choose>
                                    <c:when test="${not empty history}">
                                        <table class="history-table">
                                            <thead>
                                                <tr>
                                                    <th>Order ID</th>
                                                    <th>Customer</th>
                                                    <th>Duration</th>
                                                    <th>Total Fee</th>
                                                    <th>Status</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${history}">
                                                    <tr>
                                                        <td>#
                                                            <c:out value="${item.bookingId}" />
                                                        </td>
                                                        <td>
                                                            <c:out value="${item.customerName}" />
                                                        </td>
                                                        <td>
                                                            <span style="font-size:0.8rem;">
                                                                <c:out value="${item.startDate}" /> -
                                                                <c:out value="${item.endDate}" />
                                                            </span>
                                                            <span
                                                                style="display:block; font-size:0.7rem; color:var(--color-gray-light);">(
                                                                <c:out value="${item.totalDays}" /> days)
                                                            </span>
                                                        </td>
                                                        <td style="color:var(--orange); font-weight:600;">
                                                            <fmt:formatNumber value="${item.subtotalFee}"
                                                                              type="number" groupingUsed="true" /> ₫
                                                        </td>
                                                        <td>
                                                            <span
                                                                class="status-badge ${item.status == 'Pending' ? 'pending' : (item.status == 'Confirmed' ? 'confirmed' : (item.status == 'Active' ? 'active' : (item.status == 'Completed' ? 'completed' : 'rejected')))}">
                                                                <c:out value="${item.status}" />
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-sm text-muted" style="margin-top: 1rem;">No rental
                                            records found for this vehicle.</p>
                                        </c:otherwise>
                                    </c:choose>
                            </div>
                        </div>

                        <!-- Right: Form Update Info -->
                        <div>
                            <div class="update-card">
                                <h3
                                    style="font-size:1.15rem; font-weight:700; color:var(--color-white); margin-bottom:var(--space-1); display:flex; align-items:center; gap:0.5rem;">
                                    <i class="bi bi-pencil-square" style="color:var(--color-blue-light);"></i>
                                    Update Specifications
                                </h3>
                                <p class="text-xs text-muted" style="margin-bottom:var(--space-6);">Keep
                                    information current. Biometric plates cannot change after approval.</p>

                                <form id="updateCarForm"
                                      action="${pageContext.request.contextPath}/owner/cars?action=update"
                                      method="post" novalidate>
                                    <input type="hidden" name="carId" value="${car.carId}" />

                                    <div class="form-group">
                                        <label for="carName" class="form-label">Vehicle Name</label>
                                        <input type="text" id="carName" name="carName" class="form-control"
                                               value="<c:out value='${car.carName}'/>" required />
                                    </div>

                                    <div class="form-group">
                                        <label for="brand" class="form-label">Brand</label>
                                        <input type="text" id="brand" name="brand" class="form-control"
                                               value="<c:out value='${car.brand}'/>" required />
                                    </div>

                                    <div class="form-group">
                                        <label for="model" class="form-label">Model Year</label>
                                        <input type="text" id="model" name="model" class="form-control"
                                               value="<c:out value='${car.model}'/>" required />
                                    </div>

                                    <div class="form-group">
                                        <label for="licensePlate" class="form-label">License Plate</label>
                                        <input type="text" id="licensePlate" name="licensePlate"
                                               class="form-control" value="<c:out value='${car.licensePlate}'/>"
                                               ${(car.status=='Approved' || car.status=='Available' )
                                                 ? 'readonly style="background:var(--color-dark-surface); color:var(--color-gray-light);"'
                                                 : '' } required />
                                    </div>

                                    <div class="form-group">
                                        <label for="typeId" class="form-label">Category</label>
                                        <select id="typeId" name="typeId" class="form-control" required>
                                            <c:forEach var="type" items="${carTypes}">
                                                <option value="${type.typeId}" ${type.typeId==car.typeId
                                                                 ? 'selected' : '' }>
                                                        <c:out value="${type.typeName}" />
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="pricePerDay" class="form-label">Rental Rate (VND /
                                            Day)</label>
                                        <input type="number" id="pricePerDay" name="pricePerDay"
                                               class="form-control" value="${car.pricePerDay}" required />
                                    </div>

                                    <div class="form-group">
                                        <label for="documentUrl" class="form-label">Registration Document
                                            URL</label>
                                        <input type="text" id="documentUrl" name="documentUrl"
                                               class="form-control" value="<c:out value='${car.documentUrl}'/>" />
                                        <c:if test="${not empty car.documentUrl}">
                                            <span class="form-hint"><a
                                                    href="<c:out value='${car.documentUrl}'/>" target="_blank"
                                                    style="color:var(--color-blue-light); text-decoration:underline;">View
                                                    current document paper 🔗</a></span>
                                                </c:if>
                                    </div>

                                    <input type="hidden" id="primaryImageUrl" name="primaryImageUrl"
                                           value="<c:out value='${car.primaryImageUrl}'/>" />

                                    <!-- Visual Specifications Fields -->
                                    <div
                                        style="margin: 1.5rem 0; padding: 1rem; background: var(--color-dark-surface); border: 1px solid var(--color-dark-border); border-radius: var(--radius-lg);">
                                        <h4
                                            style="font-size: 0.9rem; font-weight: 700; color: var(--color-white); margin-bottom: 1rem; text-transform: uppercase; letter-spacing: 0.5px;">
                                            Vehicle Specs Detail</h4>

                                        <div class="form-group">
                                            <label for="specTransmission" class="form-label"
                                                   style="font-size: 0.8rem;">Transmission</label>
                                            <select id="specTransmission" class="form-control"
                                                    style="height: 44px;">
                                                <option value="Automatic">Automatic</option>
                                                <option value="Manual">Manual</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="specFuel" class="form-label"
                                                   style="font-size: 0.8rem;">Fuel Type</label>
                                            <select id="specFuel" class="form-control" style="height: 44px;">
                                                <option value="Gasoline">Gasoline</option>
                                                <option value="Diesel">Diesel</option>
                                            </select>
                                        </div>

                                        <div class="form-group"
                                             style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 0;">
                                            <div>
                                                <label for="specSeats" class="form-label"
                                                       style="font-size: 0.8rem;">Seats</label>
                                                <input type="number" id="specSeats" class="form-control"
                                                       style="height: 38px;" min="2" max="50" value="5" />
                                            </div>
                                            <div>
                                                <label for="specConsumption" class="form-label"
                                                       style="font-size: 0.8rem;">Consumption</label>
                                                <input type="text" id="specConsumption" class="form-control"
                                                       style="height: 38px;" placeholder="e.g. 6.5L/100km" />
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Hidden input for actual Specs JSON -->
                                    <input type="hidden" id="specsJson" name="specsJson"
                                           value="<c:out value='${car.specsJson}'/>" />

                                    <button type="submit" class="btn btn-blue btn-full"
                                            style="margin-top:var(--space-4);">
                                        Save Specification Changes
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                </div>
            </main>
        </div>
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Parse existing JSON specs and prepopulate inputs
                var specsJsonInput = document.getElementById("specsJson");
                var specTransmission = document.getElementById("specTransmission");
                var specFuel = document.getElementById("specFuel");
                var specSeats = document.getElementById("specSeats");
                var specConsumption = document.getElementById("specConsumption");

                if (specsJsonInput && specsJsonInput.value) {
                    try {
                        var specs = JSON.parse(specsJsonInput.value);

                        if (specs.Transmission) {
                            specTransmission.value = specs.Transmission;
                        }

                        if (specs.Fuel) {
                            specFuel.value = specs.Fuel;
                        }

                        if (specs.Seats) {
                            specSeats.value = specs.Seats;
                        }

                        if (specs.Consumption) {
                            specConsumption.value = specs.Consumption;
                        }
                    } catch (e) {
                        console.log("Error parsing specs JSON: ", e);
                    }
                }

                document.getElementById('updateCarForm').addEventListener('submit', function (e) {
                    var carName = document.getElementById('carName').value.trim();
                    var brand = document.getElementById('brand').value.trim();
                    var model = document.getElementById('model').value.trim();
                    var licensePlate = document.getElementById('licensePlate').value.trim();
                    var price = document.getElementById('pricePerDay').value;

                    if (!carName || !brand || !model || !licensePlate || !price) {
                        e.preventDefault();
                        showToast('All fields marked with * are mandatory.', 'error');
                        return;
                    }

                    if (parseFloat(price) <= 0) {
                        e.preventDefault();
                        showToast('Rental price must be strictly greater than zero.', 'error');
                        return;
                    }

                    // Pack visual spec inputs back to specsJson hidden input
                    var specsObj = {
                        "Transmission": specTransmission.value,
                        "Fuel": specFuel.value,
                        "Seats": parseInt(specSeats.value) || 5,
                        "Consumption": specConsumption.value.trim()
                    };
                    specsJsonInput.value = JSON.stringify(specsObj);
                });
            });

        </script>

        <script src="${pageContext.request.contextPath}/js/cropper.min.js"></script>
        <script>
            let cropperInstance = null;

            function changeCarImage() {
                document.getElementById("carImageFileInput").click();
            }

            document.getElementById("carImageFileInput").addEventListener("change", function (e) {
                const files = e.target.files;
                if (files && files.length > 0) {
                    const file = files[0];
                    const reader = new FileReader();
                    reader.onload = function (event) {
                        document.getElementById("cropperModal").style.display = "flex";
                        const cropperImg = document.getElementById("cropperImageSource");
                        cropperImg.src = event.target.result;

                        if (cropperInstance) {
                            cropperInstance.destroy();
                        }

                        cropperInstance = new Cropper(cropperImg, {
                            aspectRatio: 16 / 9,
                            viewMode: 1,
                            background: false
                        });
                    };
                    reader.readAsDataURL(file);
                }
            });

            function closeCropperModal() {
                document.getElementById("cropperModal").style.display = "none";
                document.getElementById("carImageFileInput").value = "";
                if (cropperInstance) {
                    cropperInstance.destroy();
                    cropperInstance = null;
                }
            }

            document.getElementById("btnPerformCrop").addEventListener("click", function () {
                if (!cropperInstance)
                    return;

                const canvas = cropperInstance.getCroppedCanvas({
                    width: 1280,
                    height: 720,
                    imageSmoothingEnabled: true,
                    imageSmoothingQuality: 'high'
                });

                const base64Image = canvas.toDataURL("image/jpeg", 0.85);

                const btn = document.getElementById("btnPerformCrop");
                const originalText = btn.textContent;
                btn.textContent = "Uploading...";
                btn.disabled = true;

                const formData = new URLSearchParams();
                formData.append("action", "uploadImage");
                formData.append("base64Image", base64Image);

                fetch("${pageContext.request.contextPath}/owner/cars", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: formData.toString()
                })
                        .then(response => {
                            if (!response.ok) {
                                return response.text().then(text => {
                                    throw new Error("HTTP " + response.status + ": " + text)
                                });
                            }
                            return response.text();
                        })
                        .then(text => {
                            try {
                                return JSON.parse(text);
                            } catch (e) {
                                console.error("Server response was not JSON:", text);
                                throw new Error("Invalid response form from server. Check console.");
                            }
                        })
                        .then(data => {
                            btn.textContent = originalText;
                            btn.disabled = false;

                            if (data.success) {
                                document.getElementById("primaryImageUrl").value = data.imageUrl;

                                const wrapper = document.querySelector(".car-image-banner-wrapper");
                                const height = "350px";

                                wrapper.innerHTML =
                                        '<div class="car-image-banner" style="margin-bottom:0; width:100%; height:' + height + '; border-radius: var(--radius-xl); overflow:hidden; border:1px solid var(--color-dark-border);">' +
                                        '<img id="displayCarImg" src="' + base64Image + '" style="width:100%; height:100%; object-fit:cover;" alt="Vehicle Image" />' +
                                        '</div>' +
                                        '<div class="image-overlay" style="position: absolute; top:0; left:0; width:100%; height:' + height + '; background: rgba(0,0,0,0.5); display: flex; flex-direction:column; align-items:center; justify-content:center; border-radius: var(--radius-xl); opacity:0; transition: opacity 0.2s ease;">' +
                                        '<i class="bi bi-camera-fill" style="font-size:2.5rem; color:#FFF; margin-bottom:0.5rem;"></i>' +
                                        '<span style="color:#FFF; font-weight:700; font-size:1rem;">Click to Change Image</span>' +
                                        '</div>';

                                closeCropperModal();
                                showToast("Photo cropped and uploaded successfully! Remember to save changes below.", "success");
                            } else {
                                showToast("Failed to upload image: " + data.message, "error");
                            }
                        })
                        .catch(error => {
                            btn.textContent = originalText;
                            btn.disabled = false;
                            showToast("Error uploading photo: " + error, "error");
                        });
            });
        </script>
    </body>

</html>