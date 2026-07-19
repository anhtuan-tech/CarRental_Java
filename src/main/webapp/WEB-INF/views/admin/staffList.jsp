<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
    <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Personnel Management - CarRental Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
                <style>
                    .admin-container {
                        max-width: 100%;
                        margin: 0 auto;
                        padding: 0 var(--space-4);
                    }

                    .action-bar {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: var(--space-6);
                        gap: var(--space-4);
                        flex-wrap: wrap;
                    }

                    .search-form {
                        display: flex;
                        gap: var(--space-2);
                        flex-grow: 1;
                        max-width: 500px;
                    }

                    .staff-row-card {
                        background: var(--color-dark-card);
                        border: 1px solid var(--color-dark-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-4) var(--space-6);
                        margin-bottom: var(--space-4);
                        transition: var(--transition-fast);
                    }

                    .staff-row-card:hover {
                        border-color: var(--color-blue-border);
                    }

                    .staff-grid {
                        display: grid;
                        grid-template-columns: 80px 80px 2.5fr 3.5fr 2.5fr 1.5fr;
                        align-items: center;
                        gap: var(--space-4);
                        width: 100%;
                    }

                    .grid-col {
                        font-size: 0.95rem;
                        color: var(--color-white);
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    .col-no {
                        font-weight: 700;
                        color: var(--orange);
                        font-size: 1.1rem;
                    }

                    .col-avatar {
                        display: flex;
                        align-items: center;
                        justify-content: flex-start;
                    }

                    .col-name {
                        font-weight: 700;
                        font-size: 1.1rem;
                    }

                    .col-email {
                        color: var(--color-gray-light);
                    }

                    .col-phone {
                        color: var(--color-gray-light);
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

                            <div class="mb-6">
                                <h1 class="hero-title"
                                    style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">Manage <span>Staff
                                        Accounts</span></h1>
                                <p class="text-muted text-sm">Provision internal back-office personnel credentials,
                                    manage activity access, and suspension details.</p>
                            </div>
                            <div class="blue-line" style="margin-bottom: 2rem;"></div>

                             <!-- Action bar & searches -->
                             <div class="action-bar" style="display:flex; justify-content:space-between; align-items:center; gap:1.5rem; margin-bottom:1.5rem;">
                                 <div style="flex-grow:1; max-width:400px; position:relative;">
                                     <input type="text" id="staffSearchInput" class="form-control"
                                            placeholder="Search staff instantly..."
                                            style="padding-left: 2.5rem; height: 42px;" />
                                     <i class="bi bi-search" style="position:absolute; left:1rem; top:50%; transform:translateY(-50%); color:var(--text-muted);"></i>
                                 </div>
                                 <a href="${pageContext.request.contextPath}/admin/staff?action=create"
                                     class="btn btn-blue btn-sm"
                                     style="height:42px; display:inline-flex; align-items:center;"><i class="bi bi-person-plus-fill" style="margin-right:0.5rem;"></i> Add New Staff</a>
                             </div>

                             <!-- Staff indexes list -->
                             <div id="staffListContainer">
                              <c:choose>
                                  <c:when test="${not empty staffList}">
                                      <div class="staff-grid-header" style="display: grid; grid-template-columns: 80px 80px 2.5fr 3.5fr 2.5fr 1.5fr; padding: var(--space-3) var(--space-6); font-weight: 700; color: var(--color-gray-light); font-size: 0.85rem; text-transform: uppercase; border-bottom: 1px solid var(--color-dark-border); margin-bottom: var(--space-4);">
                                          <div>No.</div>
                                          <div>Avatar</div>
                                          <div>Full Name</div>
                                          <div>Email Address</div>
                                          <div>Phone Number</div>
                                          <div style="text-align: right; padding-right: var(--space-4);">Status</div>
                                      </div>
                                      <c:forEach var="staff" items="${staffList}" varStatus="loop">
                                          <div class="staff-row-card"
                                               data-name="<c:out value='${staff.fullName}'/>"
                                               data-email="<c:out value='${staff.email}'/>"
                                               data-phone="<c:out value='${staff.phoneNumber}'/>"
                                               onclick="window.location.href='${pageContext.request.contextPath}/admin/staff?action=detail&id=${staff.userId}'"
                                               style="cursor: pointer;">
                                              <div class="staff-grid">
                                                  <!-- Sequential No. -->
                                                  <div class="grid-col col-no">#${loop.index + 1}</div>
                                                  
                                                  <!-- Round Avatar -->
                                                  <div class="grid-col col-avatar">
                                                       <c:choose>
                                                           <c:when test="${not empty staff.avatarUrl}">
                                                               <img src="${fn:startsWith(staff.avatarUrl, 'http') || fn:startsWith(staff.avatarUrl, pageContext.request.contextPath) ? staff.avatarUrl : pageContext.request.contextPath.concat(staff.avatarUrl)}" style="width: 44px; height: 44px; border-radius: 50%; object-fit: cover; border: 2px solid var(--orange-border);" alt="Avatar" />
                                                           </c:when>
                                                          <c:otherwise>
                                                              <div style="width: 44px; height: 44px; border-radius: 50%; background: var(--orange-pale); border: 2px solid var(--orange-border); display: flex; align-items: center; justify-content: center; color: var(--orange-dark); font-weight: 700; font-size: 1rem;">
                                                                  <c:out value="${fn:substring(staff.fullName, 0, 1)}"/>
                                                              </div>
                                                          </c:otherwise>
                                                      </c:choose>
                                                  </div>
                                                  
                                                  <!-- Staff Info -->
                                                  <div class="grid-col col-name"><c:out value="${staff.fullName}" /></div>
                                                  <div class="grid-col col-email"><c:out value="${staff.email}" /></div>
                                                  <div class="grid-col col-phone"><c:out value="${staff.phoneNumber}" /></div>
                                                  
                                                  <!-- Status Badge only (No button) -->
                                                  <div style="text-align: right;">
                                                      <span class="status-badge ${staff.status == 'Active' ? 'active' : (staff.status == 'Suspended' ? 'suspended' : 'blocked')}">
                                                          <c:out value="${staff.status}" />
                                                      </span>
                                                  </div>
                                              </div>
                                          </div>
                                      </c:forEach>
                                 </c:when>
                                 <c:otherwise>
                                     <!-- Empty list state message -->
                                      <div class="empty-state">
                                          <div class="empty-state-icon"><i class="bi bi-people-fill"></i></div>
                                          <div class="empty-state-title">No staff accounts available</div>
                                         <p class="text-muted text-sm" style="margin-top:0.5rem;">There are no back-office personnel registered.</p>
                                     </div>
                                 </c:otherwise>
                             </c:choose>
                             </div>

                             <div id="noStaffSearchPlaceholder" class="empty-state" style="display:none; padding: 2rem; border: 1px dashed var(--border); border-radius: var(--r-xl); background: var(--white);">
                                 <div class="empty-state-icon" style="color:var(--text-muted);"><i class="bi bi-search"></i></div>
                                 <div class="empty-state-title" style="margin-top:0.5rem; font-weight:600;">No matching staff members</div>
                                 <p class="text-muted text-sm" style="margin-top:0.25rem;">Try searching using different keywords.</p>
                             </div>

                             <script>
                                 document.getElementById('staffSearchInput').addEventListener('input', function() {
                                     var val = this.value.toLowerCase().trim();
                                     var cards = document.querySelectorAll('.staff-row-card');
                                     var foundCount = 0;
                                     cards.forEach(function(card) {
                                         var name = card.getAttribute('data-name').toLowerCase();
                                         var email = card.getAttribute('data-email').toLowerCase();
                                         var phone = card.getAttribute('data-phone').toLowerCase();
                                         if (name.includes(val) || email.includes(val) || phone.includes(val)) {
                                             card.style.setProperty('display', 'flex', 'important');
                                             foundCount++;
                                         } else {
                                             card.style.setProperty('display', 'none', 'important');
                                         }
                                     });

                                     var placeholder = document.getElementById('noStaffSearchPlaceholder');
                                     if (foundCount === 0 && val !== "") {
                                         placeholder.style.display = 'block';
                                     } else {
                                         placeholder.style.display = 'none';
                                     }
                                 });
                             </script>

                        </div>
                    </main>
                </div>
                <jsp:include page="/WEB-INF/views/common/footer.jsp" />
            </body>
            </html>