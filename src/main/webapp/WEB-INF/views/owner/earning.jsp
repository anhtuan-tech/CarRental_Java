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
      <title>Earning Analytics - CarRental</title>
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
      <style>
            .earning-container {
                  max-width: 900px;
                  margin: var(--space-8) auto;
            }
            .stats-hero {
                  background: var(--color-dark-card);
                  border: 1px solid var(--color-dark-border);
                  border-radius: var(--radius-xl);
                  padding: var(--space-8);
                  text-align: center;
                  margin-bottom: var(--space-8);
                  position: relative;
                  overflow: hidden;
            }
            .stats-hero::before {
                  content: '';
                  position: absolute;
                  top: 0;
                  left: 0;
                  width: 100%;
                  height: 4px;
                  background: linear-gradient(90deg, var(--color-blue), var(--color-blue-light));
            }
            .stats-val {
                  font-size: 2.75rem;
                  font-weight: 800;
                  color: var(--color-white);
                  margin-top: var(--space-2);
                  text-shadow: 0 0 20px rgba(59, 130, 246, 0.2);
            }
            .timeline-wrapper {
                  background: var(--color-dark-card);
                  border: 1px solid var(--color-dark-border);
                  border-radius: var(--radius-xl);
                  padding: var(--space-8);
            }
            .timeline-item {
                  display: flex;
                  gap: var(--space-4);
                  padding-bottom: var(--space-6);
                  margin-bottom: var(--space-6);
                  border-bottom: 1px solid var(--color-dark-border);
            }
            .timeline-item:last-child {
                  border-bottom: none;
                  margin-bottom: 0;
                  padding-bottom: 0;
            }
            .timeline-badge {
                  width: 42px;
                  height: 42px;
                  border-radius: var(--radius-full);
                  background: rgba(59, 130, 246, 0.1);
                  color: var(--color-blue-light);
                  display: flex;
                  align-items: center;
                  justify-content: center;
                  font-weight: 700;
                  font-size: 0.9rem;
                  border: 1px solid rgba(59, 130, 246, 0.2);
                  flex-shrink: 0;
            }
            .status-pill {
                  display: inline-block;
                  font-size: 0.75rem;
                  font-weight: 600;
                  padding: var(--space-1) var(--space-3);
                  border-radius: var(--radius-full);
                  text-transform: uppercase;
            }
            .status-pill.completed { background: rgba(16, 185, 129, 0.1); color: #10B981; border: 1px solid rgba(16, 185, 129, 0.2); }
            .status-pill.mutated    { background: rgba(59, 130, 246, 0.1); color: var(--color-blue-light); border: 1px solid rgba(59, 130, 246, 0.2); }
      </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>
