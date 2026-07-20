<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>My Feedback - Car Rental</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
        <style>
            .feedback-list-container {
                max-width: 900px;
                margin: var(--space-8) auto;
            }

            .feedback-card {
                background: var(--color-dark-card);
                border: 1px solid var(--color-dark-border);
                border-radius: var(--radius-xl);
                padding: var(--space-6);
                margin-bottom: var(--space-4);
                display: flex;
                justify-content: space-between;
                align-items: center;
                transition: var(--transition-fast);
            }

            .feedback-card:hover {
                border-color: var(--color-blue-border);
            }

            .feedback-card-info {
                display: flex;
                flex-direction: column;
                gap: var(--space-2);
            }

            .feedback-card-car {
                font-size: 1.15rem;
                font-weight: 700;
                color: var(--color-white);
            }

            .feedback-card-rating {
                color: var(--color-blue-light);
            }

            .feedback-card-comment {
                color: var(--color-white-soft);
                font-size: 0.95rem;
                line-height: 1.5;
                max-width: 550px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .feedback-card-date {
                font-size: 0.8rem;
                color: var(--color-gray-light);
            }

            .feedback-card-actions {
                display: flex;
                gap: var(--space-3);
            }

            /* Custom modal confirm styling */
            .confirm-modal {
                display: none;
                position: fixed;
                z-index: 1000;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(6, 7, 10, 0.85);
                align-items: center;
                justify-content: center;
            }

            .confirm-modal-content {
                background: var(--color-dark-card);
                border: 1px solid var(--color-blue-border);
                border-radius: var(--radius-xl);
                padding: var(--space-8);
                width: 90%;
                max-width: 400px;
                text-align: center;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            }
        </style>
        <link rel="icon" href="${pageContext.request.contextPath}/uploads/favicon/favicorental.png" type="image/png" />
</head>

    <body>

        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="page-wrapper">
            <div class="container">

                <div class="feedback-list-container">

                    <div class="mb-6">
                        <h1 class="hero-title"
                            style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">My
                            <span>Feedback</span></h1>
                        <p class="text-muted text-sm">Review your submitted testimonials and ratings.</p>
                    </div>
                    <div class="blue-line" style="margin-bottom: 2rem;"></div>

                    <c:choose>
                        <c:when test="${not empty feedbacks}">
                            <c:forEach var="fb" items="${feedbacks}">
                                <div class="feedback-card">
                                    <div class="feedback-card-info">
                                        <div class="feedback-card-car">
                                            <c:out value="${fb.carBrand}" />
                                            <c:out value="${fb.carName}" />
                                        </div>
                                        <div class="feedback-card-rating">
                                            <c:forEach begin="1" end="5" var="i">
                                                <span class="star">${i <= fb.rating ? '★' : '☆' }</span>
                                            </c:forEach>
                                        </div>
                                        <div class="feedback-card-comment">
                                            <c:out value="${fb.comment}" />
                                        </div>
                                        <div class="feedback-card-date">
                                            Submitted on:
                                            <c:out
                                                value="${fn:substring(fb.createdAt.toString(), 0, 16)}" />
                                        </div>
                                    </div>

                                    <div class="feedback-card-actions">
                                        <a href="${pageContext.request.contextPath}/feedback?action=detail&id=${fb.feedbackId}"
                                           class="btn btn-outline-blue btn-sm">View</a>

                                        <jsp:useBean id="nowDate" class="java.util.Date" />
                                        <%-- Compare creation time with current time to check 24h limit --%>
                                        <c:set var="canModify" value="true" />
                                        <c:if test="${not empty fb.createdAt}">
                                            <c:set var="createdTimeStr" value="${fb.createdAt.toString()}" />
                                        </c:if>

                                        <c:choose>
                                            <c:when test="${canModify}">
                                                <a href="${pageContext.request.contextPath}/feedback?action=edit&id=${fb.feedbackId}"
                                                   class="btn btn-ghost btn-sm">Edit</a>
                                                <button type="button" class="btn btn-ghost btn-sm"
                                                        style="color:var(--color-red);"
                                                        onclick="triggerDeleteConfirmation('${fb.feedbackId}', '${fb.carBrand} ${fb.carName}')">Delete</button>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Empty state informational message -->
                            <div class="empty-state">
                                <div class="empty-state-icon">💬</div>
                                <div class="empty-state-title">You have not submitted any feedback yet
                                </div>
                                <p class="text-muted text-sm" style="margin-top: 0.5rem;">Rent a car from
                                    our fleet first and complete a transaction to review.</p>
                                <a href="${pageContext.request.contextPath}/cars" class="btn btn-blue"
                                   style="margin-top: 1.5rem;">Browse Cars</a>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>

            </div>
        </div>

        <!-- Modal Confirmation Workflow -->
        <div id="deleteModal" class="confirm-modal">
            <div class="confirm-modal-content">
                <h3 style="color:var(--color-white); margin-bottom:var(--space-2);">Confirm Deletion</h3>
                <p class="text-sm text-muted" style="margin-bottom:var(--space-6);">
                    Are you sure you want to permanently delete your feedback for <strong
                        id="deleteTargetName" style="color:var(--color-blue-light);"></strong>? This action
                    cannot be undone.
                </p>
                <form id="deleteForm" action="${pageContext.request.contextPath}/feedback?action=delete"
                      method="post">
                    <input type="hidden" id="deleteFeedbackId" name="id" value="" />
                    <div style="display:flex; gap:var(--space-4); justify-content:center;">
                        <button type="submit" class="btn btn-blue btn-sm">Confirm Delete</button>
                        <button type="button" class="btn btn-ghost btn-sm"
                                onclick="closeDeleteConfirmation()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>



        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
        <script>


            function triggerDeleteConfirmation(feedbackId, carName) {
                document.getElementById('deleteFeedbackId').value = feedbackId;
                document.getElementById('deleteTargetName').textContent = carName;
                document.getElementById('deleteModal').style.display = 'flex';
            }

            function closeDeleteConfirmation() {
                document.getElementById('deleteModal').style.display = 'none';
            }
        </script>
    </body>

</html>