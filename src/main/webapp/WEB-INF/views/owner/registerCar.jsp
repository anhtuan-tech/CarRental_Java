<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
      <meta charset="UTF-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <title>Register Vehicle — CarRental Owner</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cropper.min.css" />
      <style>
            .admin-container {
                  max-width: 100%;
                  margin: 0 auto;
                  padding: 0 var(--space-4);
            }
            .register-card {
                  background: var(--color-dark-card);
                  border: 1px solid var(--color-dark-border);
                  border-radius: var(--radius-xl);
                  padding: var(--space-8);
                  max-width: 700px;
                  margin: 0 auto;
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
      <!-- Sidebar -->
      <aside class="mgmt-sidebar">
            <div class="mgmt-sidebar-header">
                <div class="mgmt-sidebar-title"><i class="bi bi-key-fill"></i> Owner Hub</div>
                <div class="mgmt-sidebar-subtitle">Fleet Management</div>
            </div>
            <ul class="mgmt-menu">
                <div class="mgmt-menu-section-title">Overview</div>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/owner/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                <div class="mgmt-menu-section-title">My Fleet</div>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/owner/cars"><i class="bi bi-car-front-fill"></i> My Vehicles</a></li>
                <div class="mgmt-menu-section-title">Business</div>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/owner/orders"><i class="bi bi-receipt-cutoff"></i> Rental Orders</a></li>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/owner/earning"><i class="bi bi-wallet2"></i> Earnings &amp; Payouts</a></li>
                <div class="mgmt-menu-section-title">Account</div>
                <li class="mgmt-menu-item"><a href="${pageContext.request.contextPath}/profile"><i class="bi bi-gear-fill"></i> My Profile</a></li>
            </ul>
            <div class="mgmt-sidebar-footer">
                <div class="mgmt-user-info"><i class="bi bi-person-circle"></i> <c:out value="${sessionScope.user.email}"/></div>
                <a href="${pageContext.request.contextPath}/logout" style="display:block; margin-top:0.5rem; font-size:0.8rem; color:#EF4444; text-decoration:none;"><i class="bi bi-box-arrow-right"></i> Logout</a>
            </div>
      </aside>

      <!-- Main Content -->
      <main class="mgmt-content">
            <div class="admin-container" style="padding-top: var(--space-4);">

                  <div class="register-card">
                        
                        <div class="mb-4">
                              <h1 class="hero-title" style="font-size: 1.75rem; margin-bottom: 0.5rem; text-align: left;">Register <span>Vehicle</span></h1>
                              <p class="text-muted text-sm">Submit your vehicle specs and documentation. Reviews take 24 hours.</p>
                        </div>
                        <div class="blue-line" style="margin-bottom: 2rem;"></div>

                        <form id="registerCarForm" action="${pageContext.request.contextPath}/owner/cars?action=register" method="post" novalidate>
                              
                              <!-- Click to Upload Image Preview Box -->
                              <div class="car-image-banner-wrapper" style="position: relative; cursor: pointer; margin-bottom: 2rem;" onclick="changeCarImage()">
                                    <div class="car-placeholder" id="displayCarPlaceholder" style="width: 100%; height: 250px; background: var(--color-dark-surface); border: 1px solid var(--color-dark-border); border-radius: var(--radius-xl); display: flex; align-items: center; justify-content: center; color: var(--color-gray-light); font-size: 3rem; margin-bottom:0;">
                                          <i class="bi bi-car-front-fill"></i>
                                    </div>
                                    <div class="image-overlay" style="position: absolute; top:0; left:0; width:100%; height:250px; background: rgba(0,0,0,0.5); display: flex; flex-direction:column; align-items:center; justify-content:center; border-radius: var(--radius-xl); opacity:0; transition: opacity 0.2s ease;">
                                          <i class="bi bi-camera-fill" style="font-size:2.5rem; color:#FFF; margin-bottom:0.5rem;"></i>
                                          <span style="color:#FFF; font-weight:700; font-size:1rem;">Click to Add Vehicle Photo</span>
                                    </div>
                              </div>

                              <input type="file" id="carImageFileInput" accept="image/*" style="display:none;" />

                              <!-- Cropper Modal -->
                              <div id="cropperModal" class="image-cropper-modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.85); z-index:9999; align-items:center; justify-content:center;">
                                  <div class="image-cropper-modal-content" style="background:var(--color-dark-card); border:1px solid var(--color-dark-border); border-radius:var(--radius-xl); width:90%; max-width:600px; padding:2rem; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.5); box-sizing:border-box;">
                                      <h3 style="color:var(--color-white); font-weight:700; margin-bottom:1rem; display:flex; align-items:center; gap:0.5rem; text-align:left; margin-top:0;">
                                          <i class="bi bi-crop" style="color:var(--color-blue-light);"></i> Crop Vehicle Photo
                                      </h3>
                                      <p style="color:var(--color-gray-light); font-size:0.85rem; margin-bottom:1.5rem; text-align:left;">Drag and resize the box to crop your vehicle image perfectly.</p>
                                      
                                      <div class="img-container" style="max-height:350px; overflow:hidden; background:#000; border-radius:var(--radius-lg); display:flex; align-items:center; justify-content:center;">
                                          <img id="cropperImageSource" src="" style="max-width:100%; max-height:350px;" />
                                      </div>
                                      
                                      <div style="display:flex; justify-content:flex-end; gap:1rem; margin-top:2rem;">
                                          <button type="button" class="btn btn-ghost" onclick="closeCropperModal()">Cancel</button>
                                          <button type="button" class="btn btn-blue" id="btnPerformCrop">Crop & Save Image</button>
                                      </div>
                                  </div>
                              </div>

                              <input type="hidden" id="primaryImageUrl" name="primaryImageUrl" value="<c:out value='${requestScope.primaryImageUrlVal}'/>" />

                              <div class="form-group">
                                    <label for="carName" class="form-label">
                                          Vehicle Name <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                          <span class="input-icon">🚘</span>
                                          <input type="text"
                                                    id="carName"
                                                    name="carName"
                                                    class="form-control"
                                                    placeholder="e.g. C-Class, A4, SantaFe..."
                                                    value="<c:out value='${requestScope.carNameVal}'/>"
                                                    required/>
                                    </div>
                              </div>

                              <div class="form-group">
                                    <label for="brand" class="form-label">
                                          Brand <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                          <span class="input-icon">🏢</span>
                                          <input type="text"
                                                    id="brand"
                                                    name="brand"
                                                    class="form-control"
                                                    placeholder="e.g. Mercedes-Benz, Audi, Hyundai..."
                                                    value="<c:out value='${requestScope.brandVal}'/>"
                                                    required/>
                                    </div>
                              </div>

                              <div class="form-group">
                                    <label for="model" class="form-label">
                                          Model Year <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                          <span class="input-icon">📅</span>
                                          <input type="text"
                                                    id="model"
                                                    name="model"
                                                    class="form-control"
                                                    placeholder="e.g. 2023, 2024..."
                                                    value="<c:out value='${requestScope.modelVal}'/>"
                                                    required/>
                                    </div>
                              </div>

                              <div class="form-group">
                                    <label for="licensePlate" class="form-label">
                                          License Plate <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                          <span class="input-icon">🪪</span>
                                          <input type="text"
                                                    id="licensePlate"
                                                    name="licensePlate"
                                                    class="form-control"
                                                    placeholder="e.g. 30F-12345 (Unique plate constraint)"
                                                    value="<c:out value='${requestScope.licensePlateVal}'/>"
                                                    required/>
                                    </div>
                                    <span class="form-hint">Unique constraint applies.</span>
                              </div>

                              <div class="form-group">
                                    <label for="typeId" class="form-label">Vehicle Category <span class="required">*</span></label>
                                    <select id="typeId" name="typeId" class="form-control" required>
                                          <c:forEach var="type" items="${requestScope.carTypes}">
                                                <option value="${type.typeId}" ${type.typeId == requestScope.typeIdVal ? 'selected' : ''}>
                                                      <c:out value="${type.typeName}"/>
                                                </option>
                                          </c:forEach>
                                    </select>
                              </div>

                              <div class="form-group">
                                    <label for="pricePerDay" class="form-label">
                                          Rental Rate per day (VND) <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                          <span class="input-icon"><i class="bi bi-cash-stack"></i></span>
                                          <input type="number"
                                                    id="pricePerDay"
                                                    name="pricePerDay"
                                                    class="form-control"
                                                    placeholder="e.g. 1000000"
                                                    value="<c:out value='${requestScope.priceVal}'/>"
                                                    required/>
                                    </div>
                                    <span class="form-hint">Must be strictly greater than zero.</span>
                              </div>

                              <div class="form-group">
                                    <label for="documentUrl" class="form-label">
                                          Registration Document URL
                                    </label>
                                    <div class="input-wrapper">
                                          <span class="input-icon">🔗</span>
                                          <input type="text"
                                                    id="documentUrl"
                                                    name="documentUrl"
                                                    class="form-control"
                                                    placeholder="Link to vehicle registration paper PDF / Image (Optional)"
                                                    value="<c:out value='${requestScope.documentUrlVal}'/>" />
                                    </div>
                                    <span class="form-hint">Optional registration paper/document file.</span>
                              </div>

                              <!-- Visual Specifications Fields -->
                              <div style="margin: 1.5rem 0; padding: 1rem; background: var(--color-dark-surface); border: 1px solid var(--color-dark-border); border-radius: var(--radius-lg);">
                                    <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--color-white); margin-bottom: 1rem; text-transform: uppercase; letter-spacing: 0.5px;">Vehicle Specs Detail</h4>
                                    
                                    <div class="form-group">
                                          <label for="specTransmission" class="form-label" style="font-size: 0.8rem;">Transmission</label>
                                          <select id="specTransmission" class="form-control" style="height: 44px;">
                                                <option value="Automatic">Automatic</option>
                                                <option value="Manual">Manual</option>
                                          </select>
                                    </div>
                                    
                                    <div class="form-group">
                                          <label for="specFuel" class="form-label" style="font-size: 0.8rem;">Fuel Type</label>
                                          <select id="specFuel" class="form-control" style="height: 44px;">
                                                <option value="Gasoline">Gasoline</option>
                                                <option value="Diesel">Diesel</option>
                                          </select>
                                    </div>
                                    
                                    <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 0;">
                                          <div>
                                                <label for="specSeats" class="form-label" style="font-size: 0.8rem;">Seats</label>
                                                <input type="number" id="specSeats" class="form-control" style="height: 38px;" min="2" max="50" value="5" />
                                          </div>
                                          <div>
                                                <label for="specConsumption" class="form-label" style="font-size: 0.8rem;">Consumption</label>
                                                <input type="text" id="specConsumption" class="form-control" style="height: 38px;" placeholder="e.g. 6.5L/100km" />
                                          </div>
                                    </div>
                              </div>

                              <!-- Hidden input for specs JSON -->
                              <input type="hidden" id="specsJson" name="specsJson" value="<c:out value='${requestScope.specsJsonVal}'/>" />

                              <div style="display:flex; gap:var(--space-4); margin-top:2rem;">
                                    <button type="submit" class="btn btn-blue" id="submitBtn">
                                          Register Car
                                    </button>
                                    <a href="${pageContext.request.contextPath}/owner/cars?action=list" class="btn btn-ghost">Cancel</a>
                              </div>

                        </form>

                  </div>

            </div>
      </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script>
      document.addEventListener("DOMContentLoaded", function() {
            var specsJsonInput = document.getElementById("specsJson");
            var specTransmission = document.getElementById("specTransmission");
            var specFuel = document.getElementById("specFuel");
            var specSeats = document.getElementById("specSeats");
            var specConsumption = document.getElementById("specConsumption");

            var primaryImageUrlInput = document.getElementById("primaryImageUrl");
            if (primaryImageUrlInput && primaryImageUrlInput.value) {
                var initialUrl = primaryImageUrlInput.value.trim();
                if (initialUrl) {
                    var wrapper = document.querySelector(".car-image-banner-wrapper");
                    wrapper.innerHTML = `
                        <div class="car-image-banner" style="margin-bottom:0; width:100%; height:250px; border-radius: var(--radius-xl); overflow:hidden; border:1px solid var(--color-dark-border);">
                            <img id="displayCarImg" src="${initialUrl}" style="width:100%; height:100%; object-fit:cover;" alt="Vehicle Image" />
                        </div>
                        <div class="image-overlay" style="position: absolute; top:0; left:0; width:100%; height:250px; background: rgba(0,0,0,0.5); display: flex; flex-direction:column; align-items:center; justify-content:center; border-radius: var(--radius-xl); opacity:0; transition: opacity 0.2s ease;">
                            <i class="bi bi-camera-fill" style="font-size:2.5rem; color:#FFF; margin-bottom:0.5rem;"></i>
                            <span style="color:#FFF; font-weight:700; font-size:1rem;">Click to Change Image</span>
                        </div>
                    `;
                }
            }

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
                } catch(e) {
                    console.log("Error parsing spec JSON: ", e);
                }
            }

            document.getElementById('registerCarForm').addEventListener('submit', function(e) {
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
                        showToast('Price per day must be strictly greater than zero.', 'error');
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

                  var btn = document.getElementById('submitBtn');
                  btn.textContent = 'Registering...';
                  btn.classList.add('loading');
            });
      });

</script>
<script src="${pageContext.request.contextPath}/js/cropper.min.js"></script>
<script>
      let cropperInstance = null;

      function changeCarImage() {
          document.getElementById("carImageFileInput").click();
      }

      document.getElementById("carImageFileInput").addEventListener("change", function(e) {
          const files = e.target.files;
          if (files && files.length > 0) {
              const file = files[0];
              const reader = new FileReader();
              reader.onload = function(event) {
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

      document.getElementById("btnPerformCrop").addEventListener("click", function() {
          if (!cropperInstance) return;
          
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
                  return response.text().then(text => { throw new Error("HTTP " + response.status + ": " + text) });
              }
              return response.text();
          })
          .then(text => {
              try {
                  return JSON.parse(text);
              } catch(e) {
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
                  const height = "250px";
                  
                  wrapper.innerHTML = 
                      '<div class="car-image-banner" style="margin-bottom:0; width:100%; height:' + height + '; border-radius: var(--radius-xl); overflow:hidden; border:1px solid var(--color-dark-border);">' +
                          '<img id="displayCarImg" src="' + base64Image + '" style="width:100%; height:100%; object-fit:cover;" alt="Vehicle Image" />' +
                      '</div>' +
                      '<div class="image-overlay" style="position: absolute; top:0; left:0; width:100%; height:' + height + '; background: rgba(0,0,0,0.5); display: flex; flex-direction:column; align-items:center; justify-content:center; border-radius: var(--radius-xl); opacity:0; transition: opacity 0.2s ease;">' +
                          '<i class="bi bi-camera-fill" style="font-size:2.5rem; color:#FFF; margin-bottom:0.5rem;"></i>' +
                          '<span style="color:#FFF; font-weight:700; font-size:1rem;">Click to Change Image</span>' +
                      '</div>';
                  
                  closeCropperModal();
                  showToast("Photo cropped and uploaded successfully!", "success");
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
