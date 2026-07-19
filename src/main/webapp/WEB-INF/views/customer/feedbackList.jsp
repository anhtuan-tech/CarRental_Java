<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <c:forEach var="feedback" items="${requestScope.feedbacks}">
                <div class="review-item">
                    <div class="review-meta">
                        <span class="review-author">
                            <c:out value="${feedback.reviewerName}" />
                        </span>
                        <span class="review-date">
                            <fmt:parseDate value="${feedback.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate"
                                type="both" />
                            <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy" />
                        </span>
                    </div>
                    <div class="review-rating">
                        <c:forEach begin="1" end="5" var="i">
                            <span class="star ${i <= feedback.rating ? 'filled' : ''}">★</span>
                        </c:forEach>
                    </div>
                    <p class="review-comment">
                        <c:out value="${feedback.comment}" />
                    </p>
                    <c:if test="${not empty feedback.ownerReply}">
                        <div class="review-reply">
                            <div class="reply-header">💬 Response from Owner:</div>
                            <p class="reply-content">
                                <c:out value="${feedback.ownerReply}" />
                            </p>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />