<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Customer Reviews - CarRental Owner</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <style>
        .owner-feedback-container {
            max-width: 950px;
            margin: var(--space-8) auto;
        }

        .feedback-card {
            background: var(--color-dark-card);
            border: 1px solid var(--color-dark-border);
            border-radius: var(--radius-xl);
            padding: var(--space-6);
            margin-bottom: var(--space-5);
            transition: var(--transition-fast);
        }

        .feedback-card:hover {
            border-color: rgba(249, 115, 22, 0.4);
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: var(--space-3);
            border-bottom: 1px dashed var(--color-dark-border);
            padding-bottom: var(--space-3);
        }

        .car-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--color-white);
        }

        .reviewer-info {
            font-size: 0.85rem;
            color: var(--color-gray-light);
            margin-top: 0.2rem;
        }

        .stars-display {
            color: var(--orange);
            font-size: 1.1rem;
        }

        .customer-comment {
            background: var(--color-dark-surface);
            border: 1px solid var(--color-dark-border);
            border-radius: var(--radius-lg);
            padding: var(--space-4);
            color: var(--color-white-soft);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: var(--space-4);
        }

        .owner-reply-box {
            background: rgba(249, 115, 22, 0.06);
            border: 1px solid rgba(249, 115, 22, 0.25);
            border-radius: var(--radius-lg);
            padding: var(--space-4);
            margin-top: var(--space-3);
        }

        .owner-reply-header {
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--orange);
            margin-bottom: 0.4rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }

        .reply-form {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-top: 0.5rem;
        }
    </style>
</head>

<body>

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="page-wrapper">
        <div class="container">

            <div class="owner-feedback-container">

                <div class="mb-6">
                    <h1 class="hero-title" style="font-size: 2rem; margin-bottom: 0.5rem; text-align: left;">
                        Customer <span>Reviews & Ratings</span>
                    </h1>
                    <p class="text-muted text-sm">View customer feedback for your fleet and manage owner responses.</p>
                </div>
                <div class="orange-line" style="height: 3px; background: var(--orange); width: 80px; margin-bottom: 2rem; border-radius: 2px;"></div>

                <c:choose>
                    <c:when test="${not empty feedbacks}">
                        <c:forEach var="fb" items="${feedbacks}">
                            <div class="feedback-card">
                                
                                <div class="feedback-header">
                                    <div>
                                        <div class="car-title">
                                            <i class="bi bi-car-front-fill" style="color: var(--orange); margin-right: 0.4rem;"></i>
                                            <c:out value="${fb.carBrand}" /> <c:out value="${fb.carName}" />
                                        </div>
                                        <div class="reviewer-info">
                                            Reviewed by: <strong style="color: var(--color-white);"><c:out value="${fb.reviewerName}" /></strong>
                                            • <c:out value="${fn:substring(fb.createdAt.toString(), 0, 16)}" />
                                        </div>
                                    </div>

                                    <div class="stars-display">
                                        <c:forEach begin="1" end="5" var="i">
                                            <span>${i <= fb.rating ? '★' : '☆'}</span>
                                        </c:forEach>
                                        <span style="font-size: 0.85rem; color: var(--color-gray-light); margin-left: 0.3rem;">(${fb.rating}/5)</span>
                                    </div>
                                </div>

                                <div class="customer-comment">
                                    <div style="font-size: 0.75rem; text-transform: uppercase; color: var(--color-gray-mid); margin-bottom: 0.25rem;">Customer Review:</div>
                                    "<c:out value="${fb.comment}" />"
                                </div>

                                <!-- Owner Reply Section -->
                                <div class="owner-reply-box">
                                    <div class="owner-reply-header">
                                        <i class="bi bi-reply-fill"></i> Owner Response:
                                    </div>

                                    <c:choose>
                                        <c:when test="${not empty fb.ownerReply}">
                                            <div style="color: var(--color-white); font-size: 0.9rem; line-height: 1.5; margin-bottom: 0.5rem;">
                                                <c:out value="${fb.ownerReply}" />
                                            </div>
                                            <button type="button" class="btn btn-ghost btn-sm" style="color: var(--orange); font-size: 0.8rem; padding: 0;"
                                                    onclick="toggleReplyForm('${fb.feedbackId}')">
                                                <i class="bi bi-pencil-square"></i> Edit Response
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--color-gray-mid); font-size: 0.85rem; font-style: italic;">No response submitted yet.</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Form submit / edit response -->
                                    <form id="replyForm_${fb.feedbackId}" action="${pageContext.request.contextPath}/owner/feedbacks" method="post" 
                                          class="reply-form" style="${not empty fb.ownerReply ? 'display: none;' : ''}">
                                        <input type="hidden" name="feedbackId" value="${fb.feedbackId}" />
                                        
                                        <textarea name="ownerReply" class="form-control" rows="3" 
                                                  placeholder="Type your reply to this customer evaluation..." required
                                                  style="background: var(--color-dark-surface); color: var(--color-white); border: 1px solid var(--color-dark-border); font-size: 0.9rem;"><c:out value="${fb.ownerReply}" /></textarea>
                                        
                                        <div style="display: flex; gap: 0.5rem; justify-content: flex-end;">
                                            <c:if test="${not empty fb.ownerReply}">
                                                <button type="button" class="btn btn-ghost btn-sm" onclick="toggleReplyForm('${fb.feedbackId}')">Cancel</button>
                                            </c:if>
                                            <button type="submit" class="btn btn-primary btn-sm" style="background: var(--orange); border-color: var(--orange);">
                                                Save Response
                                            </button>
                                        </div>
                                    </form>

                                </div>

                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state" style="background: var(--color-dark-card); border: 1px solid var(--color-dark-border); border-radius: var(--radius-xl); padding: 3rem; text-align: center;">
                            <div style="font-size: 3rem; margin-bottom: 1rem;"><i class="bi bi-chat-left-dots-fill" style="color: var(--orange);"></i></div>
                            <h3 style="color: var(--color-white); font-size: 1.25rem; margin-bottom: 0.5rem;">No Customer Reviews Yet</h3>
                            <p style="color: var(--color-gray-mid); font-size: 0.9rem;">
                                Once customers complete reservations for your vehicles, their reviews and ratings will appear here.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>

        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script>
        function toggleReplyForm(feedbackId) {
            var form = document.getElementById('replyForm_' + feedbackId);
            if (form) {
                if (form.style.display === 'none' || form.style.display === '') {
                    form.style.display = 'flex';
                } else {
                    form.style.display = 'none';
                }
            }
        }
    </script>
</body>
</html>
