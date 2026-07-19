<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
      <meta charset="UTF-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <title>Register Vehicle - CarRental</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
      <style>
            .register-card {
                  background: var(--color-dark-card);
                  border: 1px solid var(--color-dark-border);
                  border-radius: var(--radius-xl);
                  padding: var(--space-8);
                  max-width: 700px;
                  margin: var(--space-8) auto;
            }
      </style>
</head>
<body>

<!-- N   VB   R -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="page-wrapper">
      <div class="container">

            <!-- Breadcrumbs -->
            <div class="mb-4">
                  <a href="${pageContext.request.contextPath}/owner/cars?action=list" style="color:var(--color-gray-light); font-size:0.9rem; font-weight:500;">← Back to Fleet</a>
            </div>

            <div class="register-card">
                  
                  <div class="mb-4">
                        <h1 class="hero-title" style="font-size: 1.75rem; margin-bottom: 0.5rem; text-align: left;">Register <span>Vehicle</span></h1>
                        <p class="text-muted text-sm">Submit your vehicle specs and documentation. Reviews take 24 hours.</p>
                  </div>
                  <div class="blue-line" style="margin-bottom: 2rem;"></div>

                  <form id="registerCarForm" action="${pageContext.request.contextPath}/owner/cars?action=register" method="post" novalidate>
                        
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
                                              placeholder="e.g. C-Class,    A4, SantaFe..."
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
                                              placeholder="e.g. Mercedes-Benz,    Audi, Hyundai..."
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
                                    <c:fo<c:forEach var="type" items="${requestScope.carTypes}">
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
                                    Registration Document URL <span class="required">*</span>
                              </label>
                              <div class="input-wrapper">
                                    <span class="input-icon">🔗</span>
                                    <input type="text"
                                              id="documentUrl"
                                              name="documentUrl"
                                              class="form-control"
                                              placeholder="Link to vehicle registration paper PDF / Image"
                                              value="<c:out value='${requestScope.documentUrlVal}'/>"
                                              required/>
                              </div>
                              <span class="form-hint">Registration paper/document file is mandatory.</span>
                        </div>

                        <div class="form-group">
                              <label for="specsJson" class="form-label">Technical Specifications (JSON format)</label>
                              <div class="input-wrapper">
                                    <textarea id="specsJson"
                                                   name="specsJson"
                                                   class="form-control"
                                                   placeholder='e.g. {"fuel": "Gasoline", "seats": 5, "transmission": "  Automatic"}'
                                                   rows="3"
                                                   style="resize:none; padding:var(--space-3);"><c:out value='${requestScope.specsJsonVal}'/></textarea>
                              </div>
                        </div>

                        <div style="display:flex; gap:var(--space-4); margin-top:2rem;">
                              <button type="submit" class="btn btn-blue" id="submitBtn">
                                    Register Car
                              </button>
                              <a href="${pageContext.request.contextPath}/owner/cars?action=list" class="btn btn-ghost">Cancel</a>
                        </div>

                  </form>

            </div>

      </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
                    <script>
                        (function () {
                            var el = document.getElementById('toast-data');
                            if (el) {
                                var err = el.getAttribute('data-error');
                                var succ = el.getAttribute('data-success');
                                var sessSucc = el.getAttribute('data-session-success');
                                var sessErr = el.getAttribute('data-session-error');

                                if (err && err.trim() !== '') showToast(err, 'error');
                                if (succ && succ.trim() !== '') showToast(succ, 'success');
                                if (sessSucc && sessSucc.trim() !== '') showToast(sessSucc, 'success');
                                if (sessErr && sessErr.trim() !== '') showToast(sessErr, 'error');
                            }
                        })();

      document.getElementById('registerCarForm').addEventListener('submit', function(e) {
            var carName = document.getElementById('carName').value.trim();
            var brand = document.getElementById('brand').value.trim();
            var model = document.getElementById('model').value.trim();
            var licensePlate = document.getElementById('licensePlate').value.trim();
            var price = document.getElementById('pricePerDay').value;
            var doc = document.getElementById('documentUrl').value.trim();

            if (!carName || !brand || !model || !licensePlate || !price || !doc) {
                  e.preventDefault();
                  showToast('  All fields marked with * are mandatory.', 'error');
                  return;
            }

            if (parseFloat(price) <= 0) {
                  e.preventDefault();
                  showToast('Price per day must be strictly greater than zero.', 'error');
                  return;
            }

            var btn = document.getElementById('submitBtn');
            btn.textContent = 'Registering...';
            btn.classList.add('loading');
      });
</script>
</body>
</html>
