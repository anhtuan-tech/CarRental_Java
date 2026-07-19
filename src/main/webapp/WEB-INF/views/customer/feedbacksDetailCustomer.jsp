<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Feedback Details - CarRental</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2026.1" />
                    <style>
                        .feedback-detail-card {
                            background: var(--color-dark-card);
                            border: 1px solid var(--color-dark-border);
                            border-radius: var(--radius-xl);
                            padding: var(--space-8);
                            max-width: 650px;
                            margin: var(--space-8) auto;
                        }

                        .read-only-box {
                            background: var(--color-dark-surface);
                            border: 1px solid var(--color-dark-border);
                            border-radius: var(--radius-lg);
                            padding: var(--space-4);
                            color: var(--color-white-soft);
                            line-height: 1.6;
                            margin-bottom: var(--space-4);
                        }

                        .stars-display {
                            font-size: 1.5rem;
                            color: var(--color-blue-light);
                            margin-bottom: var(--space-4);
                        }
                    </style>
                </head>

                <body>

                    <jsp:include page="/WEB-INF/views/common/header.jsp" />

                    <div class="page-wrapper">
                        <div class="container">

                            <!-- Breadcrumbs -->
                            <div class="mb-4">
                                <a href="${pageContext.request.contextPath}/feedback?action=list"
                                    style="color:var(--color-gray-light); font-size:0.9rem; font-weight:500;">← Back to
                                    My Feedbacks</a>
                            </div>

                            <div class="feedback-detail-card">

                                <div class="mb-4">
                                    <h1 class="hero-title"
                                        style="font-size: 1.75rem; margin-bottom: 0.5rem; text-align: left;">Feedback
                                        <span>Details</span></h1>
                                    <p class="text-muted text-sm">
                                        Read-only submission spec for <strong style="color:var(--color-blue-light);">
                                            <c:out value="${car.brand}" />
                                            <c:out value="${car.carName}" />
                                        </strong>
                                    </p>
                                </div>
                                <div class="blue-line" style="margin-bottom: 2rem;"></div>

                                <!-- Read Only Spec Details -->
                                <div class="stars-display">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span class="star">${i <= feedback.rating ? '★' : '☆' }</span>
                                    </c:forEach>
                                </div>

                                <div class="form-group">
                                    <span class="form-label" style="display:block; margin-bottom:0.25rem;">Feedback
                                        Content</span>
                                    <div class="read-only-box">
                                        <c:out value="${feedback.comment}" />
                                    </div>
                                </div>

                                <c:if test="${not empty feedback.ownerReply}">
                                    <div class="form-group">
                                        <span class="form-label"
                                            style="display:block; margin-bottom:0.25rem; color:var(--color-blue-light);">Owner
                                            Reply</span>
                                        <div class="read-only-box" style="border-color:var(--color-blue-border);">
                                            <c:out value="${feedback.ownerReply}" />
                                        </div>
                                    </div>
                                </c:if>

                                <div class="form-group">
                                    <span class="form-label" style="display:block; margin-bottom:0.25rem;">Submission
                                        Timestamp</span>
                                    <div class="read-only-box" style="font-size:0.85rem; font-family:monospace;">
                                        <c:out value="${fn:substring(feedback.createdAt.toString(), 0, 19)}" />
                                    </div>
                                </div>

                                <div style="display:flex; gap:var(--space-4); margin-top:2rem;">
                                    <a href="${pageContext.request.contextPath}/feedback?action=edit&id=${feedback.feedbackId}"
                                        class="btn btn-blue">
                                        Edit Review
                                    </a>
                                    <a href="${pageContext.request.contextPath}/feedback?action=list"
                                        class="btn btn-ghost">Back to List</a>
                                </div>

                            </div>

                        </div>
                    </div>

                    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
                </body>

                </html>