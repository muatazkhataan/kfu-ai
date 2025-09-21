/**
 * الوظائف المساعدة - مساعد كفو
 * يحتوي على الوظائف العامة والمساعدة
 */

class Utils {
    constructor() {
        this.init();
    }

    // تهيئة النظام
    init() {
        this.bindEvents();
        this.initializeSidebar();
    }

    // ربط الأحداث العامة
    bindEvents() {
        // إغلاق الشريط الجانبي على الهاتف عند النقر خارجه
        document.addEventListener("click", (e) => {
            const sidebar = document.getElementById("sidebar");
            const sidebarToggle = document.querySelector(".sidebar-toggle");

            if (
                window.innerWidth <= 768 &&
                !sidebar.contains(e.target) &&
                !sidebarToggle.contains(e.target) &&
                sidebar.classList.contains("show")
            ) {
                sidebar.classList.remove("show");
            }
        });

        // تم إزالة معالجات القوائم الفرعية القديمة - النظام الجديد في chat-manager.js

        // إضافة معالجات النقر لجميع القوائم الفرعية
        document.addEventListener('DOMContentLoaded', () => {
            this.setupSubmenuHandlers();
        });
    }

    // إعداد معالجات القوائم الفرعية
    setupSubmenuHandlers() {
        // إضافة معالجات النقر لجميع عناصر القوائم الفرعية للمجلدات
        document.querySelectorAll('.folder-dropdown-submenu').forEach(submenu => {
            submenu.addEventListener('click', (event) => {
                event.preventDefault();
                event.stopPropagation();

                // إزالة فئة النقر من جميع القوائم الفرعية الأخرى
                document.querySelectorAll('.folder-dropdown-submenu').forEach(sm => {
                    sm.classList.remove('clicked');
                });

                // إضافة فئة النقر للقائمة الفرعية الحالية
                submenu.classList.add('clicked');

                // البحث عن معرف المجلد من القائمة المنسدلة الأب
                const dropdown = submenu.closest('.folder-dropdown-menu');
                const folderId = dropdown.id.replace('folder-dropdown-', '');

                // إغلاق جميع القوائم المنسدلة والقوائم الفرعية
                document.querySelectorAll('.folder-dropdown-menu.show').forEach(menu => {
                    menu.classList.remove('show');
                });

                document.querySelectorAll('.icon-grid-menu').forEach(submenu => {
                    submenu.classList.remove('show');
                });

                // تبديل القائمة الفرعية الحالية
                const iconSubmenu = submenu.querySelector('.icon-grid-menu');
                if (iconSubmenu) {
                    iconSubmenu.classList.toggle('show');
                }
            });
        });

        // إغلاق القوائم الفرعية عند النقر خارجها
        document.addEventListener('click', (event) => {
            if (!event.target.closest('.folder-dropdown-submenu')) {
                document.querySelectorAll('.folder-dropdown-submenu').forEach(submenu => {
                    submenu.classList.remove('clicked');
                });
                document.querySelectorAll('.icon-grid-menu').forEach(submenu => {
                    submenu.classList.remove('show');
                });
            }
        });
    }

    // تهيئة الشريط الجانبي
    initializeSidebar() {
        const sidebar = document.getElementById("sidebar");
        const mainChat = document.querySelector(".main-chat");
        const sidebarResizer = document.getElementById("sidebarResizer");

        // وظيفة تغيير حجم الشريط الجانبي
        let isResizing = false;
        let startX, startWidth;

        sidebarResizer.addEventListener("mousedown", (e) => {
            isResizing = true;
            startX = e.clientX;
            startWidth = parseInt(getComputedStyle(sidebar).width, 10);
            document.body.style.cursor = "col-resize";
            e.preventDefault();
        });

        document.addEventListener("mousemove", (e) => {
            if (!isResizing) return;

            const width = startWidth + (startX - e.clientX);
            const minWidth = 280;
            const maxWidth = 500;

            if (width >= minWidth && width <= maxWidth) {
                sidebar.style.width = width + "px";
                mainChat.style.marginRight = width + "px";
            }
        });

        document.addEventListener("mouseup", () => {
            if (isResizing) {
                isResizing = false;
                document.body.style.cursor = "";
            }
        });

        // مراقب تغيير الحجم لتحديث هوامش المحادثة الرئيسية
        const resizeObserver = new ResizeObserver((entries) => {
            for (let entry of entries) {
                if (entry.target === sidebar) {
                    const width = entry.contentRect.width;
                    mainChat.style.marginRight = width + "px";
                }
            }
        });

        resizeObserver.observe(sidebar);
    }

    // تبديل الشريط الجانبي
    toggleSidebar() {
        const sidebar = document.getElementById("sidebar");
        const mainChat = document.querySelector(".main-chat");

        if (window.innerWidth <= 768) {
            sidebar.classList.toggle("show");
        } else {
            // على سطح المكتب، تبديل رؤية الشريط الجانبي
            if (sidebar.style.width === "0px" || sidebar.style.display === "none") {
                sidebar.style.width = "320px";
                sidebar.style.display = "flex";
                mainChat.style.marginRight = "320px";
            } else {
                sidebar.style.width = "0px";
                sidebar.style.display = "none";
                mainChat.style.marginRight = "0px";
            }
        }
    }

    // إظهار الإعدادات
    showSettings() {
        alert("سيتم فتح صفحة الإعدادات قريباً");
    }

    // إظهار المساعدة
    showHelp() {
        alert("سيتم فتح صفحة المساعدة قريباً");
    }

    // إظهار الملاحظات
    showFeedback() {
        alert("سيتم فتح نموذج إرسال الملاحظات قريباً");
    }

    // إظهار رسالة نجاح
    showSuccessMessage(message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed';
        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        alertDiv.innerHTML = `
            <i class="fas fa-check-circle me-2"></i>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        document.body.appendChild(alertDiv);

        // إزالة تلقائية بعد 3 ثوان
        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, 3000);
    }

    // إظهار رسالة خطأ
    showErrorMessage(message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-danger alert-dismissible fade show position-fixed';
        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        alertDiv.innerHTML = `
            <i class="fas fa-exclamation-circle me-2"></i>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        document.body.appendChild(alertDiv);

        // إزالة تلقائية بعد 5 ثوان
        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, 5000);
    }

    // إظهار رسالة تحذير
    showWarningMessage(message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-warning alert-dismissible fade show position-fixed';
        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        alertDiv.innerHTML = `
            <i class="fas fa-exclamation-triangle me-2"></i>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        document.body.appendChild(alertDiv);

        // إزالة تلقائية بعد 4 ثوان
        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, 4000);
    }

    // إظهار رسالة معلومات
    showInfoMessage(message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-info alert-dismissible fade show position-fixed';
        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        alertDiv.innerHTML = `
            <i class="fas fa-info-circle me-2"></i>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        document.body.appendChild(alertDiv);

        // إزالة تلقائية بعد 4 ثوان
        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, 4000);
    }

    // تأكيد الإجراء
    confirmAction(message, callback) {
        if (confirm(message)) {
            if (typeof callback === 'function') {
                callback();
            }
            return true;
        }
        return false;
    }

    // تأخير زمني
    delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    // تنسيق التاريخ
    formatDate(date) {
        const options = {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        };
        return new Intl.DateTimeFormat('ar-SA', options).format(date);
    }

    // تنسيق الوقت
    formatTime(date) {
        const options = {
            hour: '2-digit',
            minute: '2-digit'
        };
        return new Intl.DateTimeFormat('ar-SA', options).format(date);
    }

    // تحويل حجم الملف
    formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }

    // التحقق من صحة البريد الإلكتروني
    isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    // التحقق من صحة الرقم
    isValidNumber(value) {
        return !isNaN(value) && isFinite(value);
    }

    // تقصير النص
    truncateText(text, maxLength) {
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    }

    // إنشاء معرف فريد
    generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }

    // نسخ إلى الحافظة
    async copyToClipboard(text) {
        try {
            await navigator.clipboard.writeText(text);
            this.showSuccessMessage('تم النسخ إلى الحافظة بنجاح!');
            return true;
        } catch (err) {
            this.showErrorMessage('فشل في النسخ إلى الحافظة');
            return false;
        }
    }

    // تحميل ملف
    downloadFile(content, filename, type = 'text/plain') {
        const blob = new Blob([content], { type });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    // حفظ في التخزين المحلي
    saveToLocalStorage(key, data) {
        try {
            localStorage.setItem(key, JSON.stringify(data));
            return true;
        } catch (err) {
            this.showErrorMessage('فشل في حفظ البيانات');
            return false;
        }
    }

    // استرجاع من التخزين المحلي
    loadFromLocalStorage(key) {
        try {
            const data = localStorage.getItem(key);
            return data ? JSON.parse(data) : null;
        } catch (err) {
            this.showErrorMessage('فشل في استرجاع البيانات');
            return null;
        }
    }

    // حذف من التخزين المحلي
    removeFromLocalStorage(key) {
        try {
            localStorage.removeItem(key);
            return true;
        } catch (err) {
            this.showErrorMessage('فشل في حذف البيانات');
            return false;
        }
    }

    // مسح التخزين المحلي
    clearLocalStorage() {
        try {
            localStorage.clear();
            this.showSuccessMessage('تم مسح جميع البيانات المحلية بنجاح!');
            return true;
        } catch (err) {
            this.showErrorMessage('فشل في مسح البيانات المحلية');
            return false;
        }
    }

    // دالة اختبار
    test() {
        console.log('✅ نظام الوظائف المساعدة يعمل بشكل صحيح!');
        this.showSuccessMessage('نظام الوظائف المساعدة يعمل بشكل صحيح!');
    }
}

// إنشاء مثيل الوظائف المساعدة
const utils = new Utils();

// تصدير الدوال للاستخدام العام
window.utils = utils;

console.log('✅ نظام الوظائف المساعدة تم تحميله بنجاح!'); 