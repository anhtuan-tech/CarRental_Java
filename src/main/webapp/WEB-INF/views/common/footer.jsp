<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer style="background:#F8F9FA; border-top:1px solid #E5E7EB; margin-top:4rem; padding:3rem 2rem 1.5rem;">
    <div style="max-width:1280px; margin:0 auto;">
        <div style="display:grid; grid-template-columns:2fr 1fr 1fr; gap:2rem; margin-bottom:2rem;">
            <div>
                <div style="font-family:'Plus Jakarta Sans',sans-serif; font-size:1.25rem; font-weight:800; color:#111827; margin-bottom:0.75rem;">
                    <i class="bi bi-car-front-fill" style="color:var(--orange);"></i> Car<span style="color:#F97316;">Rental</span>
                </div>
                <p style="font-size:0.875rem; color:#6B7280; line-height:1.7;">
                    Elevate your driving experience. Choose from hundreds of premium models with seamless booking and transparent pricing.
                </p>
            </div>
            <div>
                <h5 style="font-size:0.8rem; font-weight:700; color:#111827; margin-bottom:1rem; text-transform:uppercase; letter-spacing:0.06em;">Explore</h5>
                <ul style="list-style:none; padding:0; margin:0; display:flex; flex-direction:column; gap:0.5rem;">
                    <li><a href="${pageContext.request.contextPath}/cars" style="color:#6B7280; font-size:0.875rem; text-decoration:none; transition:color 0.15s;" onmouseover="this.style.color = '#F97316'" onmouseout="this.style.color = '#6B7280'">Explore Cars</a></li>
                    <li><a href="${pageContext.request.contextPath}/register/owner" style="color:#6B7280; font-size:0.875rem; text-decoration:none;" onmouseover="this.style.color = '#F97316'" onmouseout="this.style.color = '#6B7280'">Become a Host</a></li>
                    <li><a href="${pageContext.request.contextPath}/register/customer" style="color:#6B7280; font-size:0.875rem; text-decoration:none;" onmouseover="this.style.color = '#F97316'" onmouseout="this.style.color = '#6B7280'">Sign Up</a></li>
                </ul>
            </div>
            <div>
                <h5 style="font-size:0.8rem; font-weight:700; color:#111827; margin-bottom:1rem; text-transform:uppercase; letter-spacing:0.06em;">Support</h5>
                <ul style="list-style:none; padding:0; margin:0; display:flex; flex-direction:column; gap:0.5rem;">
                    <li><a href="${pageContext.request.contextPath}/profile" style="color:#6B7280; font-size:0.875rem; text-decoration:none;" onmouseover="this.style.color = '#F97316'" onmouseout="this.style.color = '#6B7280'">Account Center</a></li>
                    <li><a href="#" style="color:#6B7280; font-size:0.875rem; text-decoration:none;">Terms &amp; Services</a></li>
                    <li><a href="#" style="color:#6B7280; font-size:0.875rem; text-decoration:none;">Privacy Policy</a></li>
                </ul>
            </div>
        </div>
        <div style="border-top:1px solid #E5E7EB; padding-top:1.25rem; display:flex; align-items:center; justify-content:space-between; font-size:0.75rem; color:#9CA3AF;">
            <span>&copy; 2026 CarRental. All rights reserved.</span>
        </div>
    </div>
</footer>

<%-- Toast Data Container --%>
<div id="toast-data"
     data-error="<c:out value='${requestScope.errorMsg}'/>"
     data-success="<c:out value='${requestScope.successMsg}'/>"
     data-session-success="<c:out value='${sessionScope.toastSuccessMsg}'/>"
     data-session-error="<c:out value='${sessionScope.toastErrorMsg}'/>"
     style="display:none;"></div>
<%
    session.removeAttribute("toastSuccessMsg");
    session.removeAttribute("toastErrorMsg");
%>
<script src="${pageContext.request.contextPath}/js/toast.js"></script>
<script>
                        (function () {
                            var el = document.getElementById('toast-data');
                            if (el) {
                                var err = el.getAttribute('data-error');
                                var succ = el.getAttribute('data-success');
                                var sessSucc = el.getAttribute('data-session-success');
                                var sessErr = el.getAttribute('data-session-error');
                                if (err && err.trim() !== '')
                                    showToast(err, 'error');
                                if (succ && succ.trim() !== '')
                                    showToast(succ, 'success');
                                if (sessSucc && sessSucc.trim() !== '')
                                    showToast(sessSucc, 'success');
                                if (sessErr && sessErr.trim() !== '')
                                    showToast(sessErr, 'error');
                            }
                        })();
</script>
