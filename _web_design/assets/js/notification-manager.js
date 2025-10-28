/**
 * Advanced Notification Management System
 * نظام إدارة الإشعارات المتقدم
 * 
 * @author KFU Development Team
 * @version 2.0.0
 */

class NotificationManager {
    constructor() {
        this.notifications = [];
        this.maxNotifications = 5;
        this.defaultDuration = 3000;
        this.container = null;
        this.init();
    }

    /**
     * تهيئة النظام
     */
    init() {
        this.createContainer();
        this.setupEventListeners();
    }

    /**
     * إنشاء حاوية الإشعارات
     */
    createContainer() {
        // إنشاء حاوية الإشعارات إذا لم تكن موجودة
        this.container = document.getElementById('notification-container');
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.id = 'notification-container';
            this.container.className = 'notification-container';
            this.container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                display: flex;
                flex-direction: column;
                gap: 10px;
                max-width: 400px;
                pointer-events: none;
            `;
            document.body.appendChild(this.container);
        }
    }

    /**
     * إعداد مستمعي الأحداث
     */
    setupEventListeners() {
        // مراقبة تغييرات الإعدادات
        if (window.settingsManager) {
            window.settingsManager.addObserver('showNotification', (data) => {
                this.show(data.message, data.type || 'info', data.duration);
            });
        }

        // مراقبة تغييرات حجم الخط
        document.addEventListener('fontSizeChanged', (event) => {
            this.updateNotificationFontSizes();
        });
    }

    /**
     * عرض إشعار
     */
    show(message, type = 'info', duration = null) {
        const notification = this.createNotification(message, type);
        this.addNotification(notification);
        
        // إزالة الإشعار تلقائياً
        const autoRemoveDuration = duration || this.defaultDuration;
        if (autoRemoveDuration > 0) {
            setTimeout(() => {
                this.removeNotification(notification);
            }, autoRemoveDuration);
        }

        return notification;
    }

    /**
     * إنشاء عنصر الإشعار
     */
    createNotification(message, type) {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.style.cssText = `
            background: ${this.getTypeColor(type)};
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            transform: translateX(100%);
            opacity: 0;
            transition: all 0.3s ease;
            pointer-events: auto;
            font-size: var(--app-font-size, 1rem);
            max-width: 100%;
            word-wrap: break-word;
        `;

        // إضافة الأيقونة
        const icon = this.getTypeIcon(type);
        notification.innerHTML = `
            <div style="display: flex; align-items: center; gap: 0.5rem;">
                <i class="fas ${icon}" style="font-size: 1.1em;"></i>
                <span style="flex: 1;">${message}</span>
                <button class="notification-close" style="
                    background: none;
                    border: none;
                    color: white;
                    cursor: pointer;
                    padding: 0;
                    font-size: 1.1em;
                    opacity: 0.7;
                    transition: opacity 0.2s ease;
                " onclick="this.parentElement.parentElement.remove()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        `;

        // إضافة مستمعي الأحداث
        const closeBtn = notification.querySelector('.notification-close');
        closeBtn.addEventListener('click', () => {
            this.removeNotification(notification);
        });

        // إضافة تأثير hover
        closeBtn.addEventListener('mouseenter', () => {
            closeBtn.style.opacity = '1';
        });

        closeBtn.addEventListener('mouseleave', () => {
            closeBtn.style.opacity = '0.7';
        });

        return notification;
    }

    /**
     * إضافة إشعار للحاوية
     */
    addNotification(notification) {
        // إزالة الإشعارات الزائدة
        while (this.container.children.length >= this.maxNotifications) {
            this.container.removeChild(this.container.firstChild);
        }

        this.container.appendChild(notification);
        this.notifications.push(notification);

        // تحريك الإشعار للداخل
        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
            notification.style.opacity = '1';
        }, 100);
    }

    /**
     * إزالة إشعار
     */
    removeNotification(notification) {
        if (notification.parentNode) {
            notification.style.transform = 'translateX(100%)';
            notification.style.opacity = '0';
            
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
                const index = this.notifications.indexOf(notification);
                if (index > -1) {
                    this.notifications.splice(index, 1);
                }
            }, 300);
        }
    }

    /**
     * الحصول على لون النوع
     */
    getTypeColor(type) {
        const colors = {
            'success': 'var(--bs-success, #198754)',
            'error': 'var(--bs-danger, #dc3545)',
            'warning': 'var(--bs-warning, #ffc107)',
            'info': 'var(--bs-info, #0dcaf0)',
            'primary': 'var(--bs-primary, #0d6efd)',
            'secondary': 'var(--bs-secondary, #6c757d)'
        };
        return colors[type] || colors['info'];
    }

    /**
     * الحصول على أيقونة النوع
     */
    getTypeIcon(type) {
        const icons = {
            'success': 'fa-check-circle',
            'error': 'fa-exclamation-circle',
            'warning': 'fa-exclamation-triangle',
            'info': 'fa-info-circle',
            'primary': 'fa-info-circle',
            'secondary': 'fa-info-circle'
        };
        return icons[type] || icons['info'];
    }

    /**
     * تحديث أحجام خطوط الإشعارات
     */
    updateNotificationFontSizes() {
        const fontSize = getComputedStyle(document.documentElement).getPropertyValue('--app-font-size');
        if (fontSize) {
            this.notifications.forEach(notification => {
                notification.style.fontSize = fontSize;
            });
        }
    }

    /**
     * إزالة جميع الإشعارات
     */
    clearAll() {
        this.notifications.forEach(notification => {
            this.removeNotification(notification);
        });
    }

    /**
     * عرض إشعار نجاح
     */
    success(message, duration) {
        return this.show(message, 'success', duration);
    }

    /**
     * عرض إشعار خطأ
     */
    error(message, duration) {
        return this.show(message, 'error', duration);
    }

    /**
     * عرض إشعار تحذير
     */
    warning(message, duration) {
        return this.show(message, 'warning', duration);
    }

    /**
     * عرض إشعار معلومات
     */
    info(message, duration) {
        return this.show(message, 'info', duration);
    }

    /**
     * عرض إشعار أساسي
     */
    primary(message, duration) {
        return this.show(message, 'primary', duration);
    }
}

// إنشاء مثيل عالمي لإدارة الإشعارات
window.notificationManager = new NotificationManager();

// دالة مساعدة للتوافق مع النظام القديم
function showSnackbar(message, type = 'info') {
    if (window.notificationManager) {
        return window.notificationManager.show(message, type);
    } else {
        // Fallback للأنظمة القديمة
        console.log(`${type.toUpperCase()}: ${message}`);
    }
}

// دوال مساعدة إضافية
function showSuccessMessage(message) {
    return showSnackbar(message, 'success');
}

function showErrorMessage(message) {
    return showSnackbar(message, 'error');
}

function showWarningMessage(message) {
    return showSnackbar(message, 'warning');
}

function showInfoMessage(message) {
    return showSnackbar(message, 'info');
}
