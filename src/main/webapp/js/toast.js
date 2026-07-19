/**
 * CarRental Toast Notification System
 * Replaces all browser alerts with elegant Black/Gold toasts.
 *
 * Usage:
 *   showToast('Your message here', 'success');   // green accent
 *   showToast('Something went wrong', 'error');   // red accent
 *   showToast('Please note this', 'warning');     // amber accent
 *
 * Auto-dismiss: 4 seconds (configurable via 3rd argument: duration ms)
 */
(function () {
    'use strict';

    const ICONS = {
        success: '✓',
        error:   '✕',
        warning: '⚠'
    };

    const TITLES = {
        success: 'Success',
        error:   'Error',
        warning: 'Warning'
    };

    /**
     * Ensure the toast container exists in the DOM.
     * @returns {HTMLElement}
     */
    function getContainer() {
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'toast-container';
            document.body.appendChild(container);
        }
        return container;
    }

    /**
     * Show a toast notification.
     *
     * @param {string} message  – The message body text
     * @param {string} type     – 'success' | 'error' | 'warning'  (default: 'success')
     * @param {number} duration – Auto-dismiss delay in ms (default: 4500)
     */
    window.showToast = function (message, type, duration) {
        type = type || 'success';
        duration = duration || 4500;

        const container = getContainer();

        const toast = document.createElement('div');
        toast.className = 'toast toast-' + type;
        toast.setAttribute('role', 'alert');
        toast.setAttribute('aria-live', 'polite');

        toast.innerHTML =
            '<div class="toast-icon">' + ICONS[type] + '</div>' +
            '<div class="toast-body">' +
                '<div class="toast-title">' + (TITLES[type] || '') + '</div>' +
                '<div class="toast-message">' + escapeHtml(message) + '</div>' +
            '</div>' +
            '<button class="toast-close" aria-label="Đóng" onclick="dismissToast(this.parentElement)">×</button>';

        container.appendChild(toast);

        // Auto-dismiss
        const timer = setTimeout(function () {
            dismissToast(toast);
        }, duration);

        // Cancel auto-dismiss on hover to let user read
        toast.addEventListener('mouseenter', function () {
            clearTimeout(timer);
        });
        toast.addEventListener('mouseleave', function () {
            setTimeout(function () { dismissToast(toast); }, 1500);
        });
    };

    /**
     * Animate and remove a toast element.
     * @param {HTMLElement} toast
     */
    window.dismissToast = function (toast) {
        if (!toast || toast.classList.contains('dismissing')) return;
        toast.classList.add('dismissing');
        toast.addEventListener('animationend', function () {
            if (toast.parentElement) {
                toast.parentElement.removeChild(toast);
            }
        }, { once: true });
    };

    /**
     * Escape HTML to prevent XSS in toast messages.
     * @param {string} str
     * @returns {string}
     */
    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    // -----------------------------------------------------------------------
    // Password visibility toggle helper
    // -----------------------------------------------------------------------
    window.togglePasswordVisibility = function (toggleBtn) {
        var wrapper = toggleBtn.closest('.input-wrapper');
        var input   = wrapper ? wrapper.querySelector('input') : null;
        if (!input) return;

        if (input.type === 'password') {
            input.type = 'text';
            toggleBtn.textContent = '🙈';
        } else {
            input.type = 'password';
            toggleBtn.textContent = '👁';
        }
    };

    // -----------------------------------------------------------------------
    // Password strength meter helper
    // -----------------------------------------------------------------------
    window.evaluatePasswordStrength = function (password, barElement) {
        if (!barElement) return;
        barElement.className = 'pwd-strength-bar';

        if (!password) return;

        var score = 0;
        if (password.length >= 8)  score++;
        if (password.length >= 12) score++;
        if (/[A-Z]/.test(password)) score++;
        if (/[0-9]/.test(password)) score++;
        if (/[^A-Za-z0-9]/.test(password)) score++;

        if (score <= 2) {
            barElement.classList.add('weak');
        } else if (score <= 3) {
            barElement.classList.add('medium');
        } else {
            barElement.classList.add('strong');
        }
    };

    // -----------------------------------------------------------------------
    // Navbar scroll effect
    // -----------------------------------------------------------------------
    window.addEventListener('scroll', function () {
        var navbar = document.querySelector('.navbar');
        if (!navbar) return;
        if (window.scrollY > 20) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

})();
