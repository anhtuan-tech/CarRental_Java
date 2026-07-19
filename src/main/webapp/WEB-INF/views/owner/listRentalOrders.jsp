<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
      String _toastSuccess = null;
      String _toastError = null;
      Object _ts = session.getAttribute("toastSuccessMsg");
      if (_ts != null) { _toastSuccess = _ts.toString(); session.removeAttribute("toastSuccessMsg"); }
      Object _te = session.getAttribute("toastErrorMsg");
      if (_te != null) { _toastError = _te.toString(); session.removeAttribute("toastErrorMsg"); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
      <meta charset="UTF-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <title>Rental Orders Manager - CarRental</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
      <style>
            .orders-container {
                  max-width: 1000px;
                  margin: var(--space-8) auto;
            }
            .order-card {
                  background: var(--color-dark-card);
                  border: 1px solid var(--color-dark-border);
                  border-radius: var(--radius-xl);
                  padding: var(--space-6);
                  margin-bottom: var(--space-4);
                  transition: var(--transition-fast);
            }
            .order-card:hover {
                  border-color: var(--color-blue-border);
            }
            .order-header {
                  display: flex;
                  justify-content: space-between;
                  align-items: center;
                  border-bottom: 1px solid var(--color-dark-border);
                  padding-bottom: var(--space-4);
                  margin-bottom: var(--space-4);
            }
            .order-id {
                  font-family: monospace;
                  font-size: 0.95rem;
                  color: var(--color-blue-light);
            }
            .order-grid {
                  display: grid;
                  grid-template-columns: 2fr 1fr 1.5fr;
                  gap: var(--space-4);
                  align-items: center;
            }
            @media (max-width: 768px) {
                  .order-grid {
                        grid-template-columns: 1fr;
                        gap: var(--space-4);
                  }
            }
            .order-meta-item {
                  font-size: 0.9rem;
                  color: var(--color-white-soft);
            }
            .order-meta-label {
                  font-size: 0.75rem;
                  color: var(--color-gray-light);
                  text-transform: uppercase;
                  display: block;
                  margin-bottom: var(--space-1);
            }
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
      </style>
</head>
<body>

<!-- N   VB   R -->
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="page-wrapper">
      <div class="container">

            <div class="orders-container">
                  
                  <div class="mb-6" style="display:flex; justify-content:space-between; align-items:flex-end;">
                        <div>
                              <h1 class="hero-title" style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">Rental <span>Orders</span></h1>
                              <p class="text-muted text-sm">Monitor client requests and update vehicle handover statuses.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/owner/earnings" class="btn btn-ghost btn-sm">View    Analytics Dashboard →</a>
                  </div>
                  <div class="blue-line" style="margin-bottom: 2rem;"></div>

                  <!-- Orders grid -->
                  <c:choose>
                        <c:when test="${not empty orders}">
                              <c:fo<c:forEach var="ord" items="${orders}">
                                    <div class="order-card">
                                          <div class="order-header">
                                                <div class="order-id">Order ID: #<c:out value="${ord.bookingId}"/></div>
                                                <div class="status-badge ${ord.status == 'Pending' ? 'pending' : (ord.status == 'Confirmed' ? 'confirmed' : (ord.status == '  Active' ? 'active' : (ord.status == 'Completed' ? 'completed' : 'rejected')))}">
                                                      <!-- BR16 dynamic status display -->
                                                      <c:out value="${ord.status}"/>
                                                </div>
                                          </div>

                                          <div class="order-grid">
                                                <div class="order-meta-item">
                                                      <span class="order-meta-label">Customer & Vehicle Context</span>
                                                      <strong><c:out value="${ord.customerName}"/></strong>
                                                </div>

                                                <div class="order-meta-item">
                                                      <span class="order-meta-label">Rental Duration</span>
                                                      <fmt:parseDate value="${ord.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="sDate" type="both"/>
                                                      <fmt:parseDate value="${ord.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="eDate" type="both"/>
                                                      <fmt:formatDate value="${sDate}" pattern="MMM dd"/> - <fmt:formatDate value="${eDate}" pattern="MMM dd, yyyy"/>
                                                      <span style="display:block; font-size:0.75rem; color:var(--color-gray-light);">(<c:out value="${ord.totalDays}"/> days)</span>
                                                </div>

                                                <div class="order-meta-item">
                                                      <!-- BR3: formatted in VND native layout -->
                                                      <span class="order-meta-label">Payout details (VND)</span>
                                                      Rate: <strong><fmt:formatNu<fmt:formatNumber value="${ord.subtotalFee}" type="numtype="number" groupingUsed="true"/></strong> VND
                                                      <span style="display:block; font-size:0.75rem; color:var(--color-blue-light);">
                                                            Earning: <fmt:formatNu<fmt:formatNumber value="${ord.ownerPayout}" type="numtype="number" groupingUsed="true"/> VND
                                                      </span>
                                                </div>
                                          </div>

                                          <!-- Context actions based on state transition rules -->
                                          <c:if test="${ord.status == 'Pending' || ord.status == 'Confirmed' || ord.status == '  Active'}">
                                                <div style="margin-top:var(--space-4); padding-top:var(--space-4); border-top:1px solid var(--color-dark-border);">
                                                      <form action="${pageContext.request.contextPath}/owner/orders?action=update" method="post" style="display:flex; gap:var(--space-3); align-items:center;">
                                                            <input type="hidden" name="bookingId" value="${ord.bookingId}"/>
                                                            
                                                            <div style="flex-grow:1;">
                                                                  <input type="text" name="note" class="form-control" style="height:36px; padding:0 var(--space-3); font-size:0.85rem;" placeholder="Handover / completion notes"/>
                                                            </div>

                                                            <c:choose>
                                                                  <c:when test="${ord.status == 'Pending'}">
                                                                        <button type="submit" name="status" value="Confirmed" class="btn btn-blue btn-sm" style="padding:0 var(--space-4); height:36px;">Confirm Order</button>
                                                                        <button type="submit" name="status" value="Rejected" class="btn btn-ghost btn-sm" style="color:var(--color-red); height:36px;">Reject</button>
                                                                  </c:when>
                                                                  <c:when test="${ord.status == 'Confirmed'}">
                                                                        <button type="submit" name="status" value="  Active" class="btn btn-blue btn-sm" style="padding:0 var(--space-4); height:36px;">Handover Vehicle (  Active)</button>
                                                                  </c:when>
                                                                  <c:when test="${ord.status == '  Active'}">
                                                                        <button type="submit" name="status" value="Completed" class="btn btn-blue btn-sm" style="padding:0 var(--space-4); height:36px;">Mark Return (Completed)</button>
                                                                  </c:when>
                                                            </c:choose>
                                                      </form>
                                                </div>
                                          </c:if>

                                    </div>
                              </c:f</c:forEach>
                        </c:when>
                        <c:otherwise>
                              <!-- Empty list state message -->
                              <div class="empty-state">
                                    <div class="empty-state-icon">ðŸ“‹</div>
                                    <div class="empty-state-title">No rental transactions</div>
                                    <p class="text-muted text-sm" style="margin-top:0.5rem;">Rental orders submitted by clients will appear here.</p>
                              </div>
                        </c:otherwise>
                  </c:choose>

            </div>

      </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
