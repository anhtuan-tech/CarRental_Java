<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Edit Feedback - CarRental</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
            <style>
                .feedback-form-card {
                    background: var(--color-dark-card);
                    border: 1px solid var(--color-dark-border);
                    border-radius: var(--radius-xl);
                    padding: var(--space-8);
                    max-width: 600px;
                    margin: var(--space-8) auto;
                }

                .rating-stars-input {
                    display: flex;
                    gap: var(--space-3);
                    margin-top: var(--space-2);
                    margin-bottom: var(--space-4);
                }

                .rating-star-btn {
                    font-size: 2.25rem;
                    color: var(--color-gray-mid);
                    background: none;
                    border: none;
                    cursor: pointer;
                    padding: 0;
                    transition: var(--transition-fast);
                }

                .rating-star-btn:hover,
                .rating-star-btn.active {
                    color: var(--color-blue-light);
                }
            </style>
        </head>

        <body>

            <jsp:include page="/WEB-INF/views/common/header.jsp" />

            <div class="page-wrapper">
                <div class="container">

                    <!-- Breadcrumbs -->
                    <div class="mb-4">
                        <a href="${pageContext.request.contextPath}/feedback?action=detail&id=${feedback.feedbackId}"
                            style="color:var(--color-gray-light); font-size:0.9rem; font-weight:500;">← Back to
                            Details</a>
                    </div>

                    <div class="feedback-form-card">

                        <div class="mb-4">
                            <h1 class="hero-title" style="font-size: 1.75rem; margin-bottom: 0.5rem; text-align: left;">
                                Edit <span>Review</span></h1>
                            <p class="text-muted text-sm">
                                Modify your feedback details for <strong style="color:var(--color-blue-light);">
                                    <c:out value="${car.brand}" />
                                    <c:out value="${car.carName}" />
                                </strong>.
                            </p>
                        </div>
                        <div class="blue-line" style="margin-bottom: 2rem;"></div>

                        <form id="editFeedbackForm" action="${pageContext.request.contextPath}/feedback?action=edit"
                            method="post" novalidate>
                            <input type="hidden" name="feedbackId" value="${feedback.feedbackId}" />
                            <input type="hidden" id="ratingInput" name="rating"
                                value="<c:out value='${feedback.rating}'/>" />

                            <div class="form-group">
                                <label class="form-label">Rating Score <span class="required">*</span></label>
                                <div class="rating-stars-input">
                                    <c:forEach begin="1" end="5" var="i">
                                        <button type="button" class="rating-star-btn" data-value="${i}"
                                            onclick="setRatingValue(${i})" aria-label="Rate ${i} stars">★</button>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="comment" class="form-label">
                                    Your Feedback Comment <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <textarea id="comment" name="comment" class="form-control"
                                        placeholder="Write about your driving experience..." rows="6"
                                        style="resize:none; padding:var(--space-3);"
                                        required><c:out value='${feedback.comment}'/></textarea>
                                </div>
                                <span class="form-hint" id="charCounter">0 / 500 characters max.</span>
                            </div>

                            <div style="display:flex; gap:var(--space-4); margin-top:2rem;">
                                <button type="submit" class="btn btn-blue" id="submitBtn">
                                    Save Changes
                                </button>
                                <a href="${pageContext.request.contextPath}/feedback?action=detail&id=${feedback.feedbackId}"
                                    class="btn btn-ghost">Cancel</a>
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

                function setRatingValue(val) {
                    document.getElementById('ratingInput').value = val;
                    var stars = document.querySelectorAll('.rating-star-btn');
                    stars.forEach(function (star, index) {
                        if (index < val) {
                            star.classList.add('active');
                        } else {
                            star.classList.remove('active');
                        }
                    });
                }

                // Textarea counter
                var textarea = document.getElementById('comment');
                var counter = document.getElementById('charCounter');

                function updateCounter() {
                    var len = textarea.value.length;
                    counter.textContent = len + ' / 500 characters max.';
                    if (len > 500) {
                        counter.style.color = 'var(--color-red)';
                    } else {
                        counter.style.color = 'var(--color-gray-light)';
                    }
                }
                textarea.addEventListener('input', updateCounter);
                updateCounter(); // initial count

                document.getElementById('editFeedbackForm').addEventListener('submit', function (e) {
                    var rating = document.getElementById('ratingInput').value;
                    var comment = document.getElementById('comment').value.trim();

                    if (!rating || parseInt(rating) < 1 || parseInt(rating) > 5) {
                        e.preventDefault();
                        showToast('Please select a star rating (1-5).', 'error');
                        return;
                    }

                    if (!comment) {
                        e.preventDefault();
                        showToast('Feedback comment text is required.', 'error');
                        return;
                    }

                    if (comment.length > 500) {
                        e.preventDefault();
                        showToast('Feedback comment must not exceed 500 characters.', 'error');
                        return;
                    }

                    var btn = document.getElementById('submitBtn');
                    btn.textContent = 'Saving...';
                    btn.classList.add('loading');
                });
            </script>
        </body>

        </html>