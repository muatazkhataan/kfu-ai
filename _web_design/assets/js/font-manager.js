/**
 * Advanced Font Management System
 * نظام إدارة الخطوط المتقدم
 * 
 * @author KFU Development Team
 * @version 2.0.0
 */

class FontManager {
    constructor() {
        this.fontSizes = {
            'small': '0.875rem',
            'medium': '1rem',
            'large': '1.125rem',
            'xlarge': '1.25rem'
        };
        
        this.fontSizeNames = {
            'small': 'صغير',
            'medium': 'متوسط',
            'large': 'كبير',
            'xlarge': 'كبير جداً'
        };
        
        this.currentSize = 'medium';
        this.init();
    }

    /**
     * تهيئة النظام
     */
    init() {
        this.loadFontSize();
        this.setupEventListeners();
        this.applyFontSize(this.currentSize);
    }

    /**
     * تحميل حجم الخط المحفوظ
     */
    loadFontSize() {
        if (window.settingsManager) {
            this.currentSize = window.settingsManager.getSetting('fontSize') || 'medium';
        } else {
            // احتياطي إذا لم يكن settingsManager متاحاً
            try {
                const savedSize = localStorage.getItem('kfuFontSize');
                if (savedSize && this.fontSizes[savedSize]) {
                    this.currentSize = savedSize;
                }
            } catch (error) {
                console.error('خطأ في تحميل حجم الخط:', error);
            }
        }
    }

    /**
     * حفظ حجم الخط
     */
    saveFontSize(size) {
        if (window.settingsManager) {
            // تخطي الإشعار لتجنب الحلقة اللانهائية
            window.settingsManager.setSetting('fontSize', size, true);
        } else {
            // احتياطي إذا لم يكن settingsManager متاحاً
            try {
                localStorage.setItem('kfuFontSize', size);
            } catch (error) {
                console.error('خطأ في حفظ حجم الخط:', error);
            }
        }
    }

    /**
     * تطبيق حجم الخط
     */
    applyFontSize(size, skipSave = false) {
        if (!this.fontSizes[size]) {
            console.warn('حجم خط غير صالح:', size);
            return;
        }

        this.currentSize = size;
        const fontSize = this.fontSizes[size];
        
        // تطبيق على عنصر HTML
        const html = document.documentElement;
        html.style.fontSize = fontSize;
        
        // إضافة متغيرات CSS مخصصة
        html.style.setProperty('--app-font-size', fontSize);
        html.style.setProperty('--app-font-size-small', this.calculateRelativeSize(fontSize, 0.875));
        html.style.setProperty('--app-font-size-large', this.calculateRelativeSize(fontSize, 1.125));
        html.style.setProperty('--app-font-size-xlarge', this.calculateRelativeSize(fontSize, 1.25));
        
        // تطبيق على عنصر body أيضاً
        const body = document.body;
        if (body) {
            body.style.fontSize = fontSize;
        }
        
        // إشعار المراقبين
        this.notifyFontSizeChange(size, fontSize);
        
        // حفظ الإعداد فقط إذا لم يتم تخطي الحفظ
        if (!skipSave) {
            this.saveFontSize(size);
        }
    }

    /**
     * حساب الحجم النسبي
     */
    calculateRelativeSize(baseSize, multiplier) {
        const baseValue = parseFloat(baseSize);
        const unit = baseSize.replace(/[\d.]/g, '');
        return (baseValue * multiplier) + unit;
    }

    /**
     * زيادة حجم الخط
     */
    increaseFontSize() {
        const sizes = Object.keys(this.fontSizes);
        const currentIndex = sizes.indexOf(this.currentSize);
        
        if (currentIndex < sizes.length - 1) {
            const newSize = sizes[currentIndex + 1];
            this.applyFontSize(newSize);
            this.showNotification(`تم زيادة حجم الخط إلى: ${this.fontSizeNames[newSize]}`);
            return newSize;
        }
        
        return this.currentSize;
    }

    /**
     * تقليل حجم الخط
     */
    decreaseFontSize() {
        const sizes = Object.keys(this.fontSizes);
        const currentIndex = sizes.indexOf(this.currentSize);
        
        if (currentIndex > 0) {
            const newSize = sizes[currentIndex - 1];
            this.applyFontSize(newSize);
            this.showNotification(`تم تقليل حجم الخط إلى: ${this.fontSizeNames[newSize]}`);
            return newSize;
        }
        
        return this.currentSize;
    }

    /**
     * تعيين حجم خط محدد
     */
    setFontSize(size) {
        if (this.fontSizes[size]) {
            this.applyFontSize(size);
            this.showNotification(`تم تغيير حجم الخط إلى: ${this.fontSizeNames[size]}`);
            return true;
        }
        return false;
    }

    /**
     * الحصول على حجم الخط الحالي
     */
    getCurrentFontSize() {
        return this.currentSize;
    }

    /**
     * الحصول على اسم حجم الخط الحالي
     */
    getCurrentFontSizeName() {
        return this.fontSizeNames[this.currentSize];
    }

    /**
     * الحصول على جميع أحجام الخطوط المتاحة
     */
    getAvailableFontSizes() {
        return Object.keys(this.fontSizes);
    }

    /**
     * إعداد مستمعي الأحداث
     */
    setupEventListeners() {
        // مراقبة تغييرات الإعدادات
        if (window.settingsManager) {
            window.settingsManager.addObserver('fontSizeChanged', (data) => {
                // تخطي الحفظ لتجنب الحلقة اللانهائية
                this.applyFontSize(data.size, true);
            });
        }

        // مراقبة تغييرات النظام
        if (window.matchMedia) {
            window.matchMedia('(prefers-reduced-motion: reduce)').addEventListener('change', (e) => {
                this.handleReducedMotion(e.matches);
            });
        }
    }

    /**
     * معالجة تقليل الحركة
     */
    handleReducedMotion(reduced) {
        const html = document.documentElement;
        if (reduced) {
            html.classList.add('reduced-motion');
        } else {
            html.classList.remove('reduced-motion');
        }
    }

    /**
     * إشعار تغيير حجم الخط
     */
    notifyFontSizeChange(size, fontSize) {
        // إطلاق حدث مخصص
        const event = new CustomEvent('fontSizeChanged', {
            detail: {
                size,
                fontSize,
                sizeName: this.fontSizeNames[size]
            }
        });
        document.dispatchEvent(event);
    }

    /**
     * عرض إشعار
     */
    showNotification(message) {
        // استخدام نظام الإشعارات الموجود
        if (window.settingsManager) {
            window.settingsManager.notifyObservers('showNotification', { message, type: 'success' });
        } else {
            // إشعار بسيط
            console.log(message);
        }
    }

    /**
     * تطبيق أحجام خطوط مخصصة على عناصر محددة
     */
    applyCustomFontSizes() {
        const customElements = {
            '.chat-title': 'large',
            '.message-content': 'medium',
            '.sidebar-menu-link': 'medium',
            '.form-label': 'medium',
            '.btn': 'medium',
            '.modal-title': 'large',
            '.card-title': 'large',
            '.help-title': 'large',
            '.feedback-title': 'large'
        };

        Object.entries(customElements).forEach(([selector, size]) => {
            const elements = document.querySelectorAll(selector);
            elements.forEach(element => {
                const relativeSize = this.calculateRelativeSize(this.fontSizes[this.currentSize], 
                    this.fontSizes[size] / this.fontSizes['medium']);
                element.style.fontSize = relativeSize;
            });
        });
    }

    /**
     * تحديث واجهة المستخدم لعرض حجم الخط الحالي
     */
    updateFontSizeDisplay() {
        const displayElements = document.querySelectorAll('[data-font-size-display]');
        displayElements.forEach(element => {
            element.textContent = this.getCurrentFontSizeName();
        });
    }

    /**
     * تطبيق أحجام الخطوط المتجاوبة
     */
    applyResponsiveFontSizes() {
        const breakpoints = {
            'small': 576,
            'medium': 768,
            'large': 992,
            'xlarge': 1200
        };

        const currentWidth = window.innerWidth;
        let responsiveSize = this.currentSize;

        // تعديل الحجم بناءً على حجم الشاشة
        if (currentWidth < breakpoints.small) {
            responsiveSize = 'small';
        } else if (currentWidth < breakpoints.medium) {
            responsiveSize = this.currentSize === 'xlarge' ? 'large' : this.currentSize;
        }

        if (responsiveSize !== this.currentSize) {
            this.applyFontSize(responsiveSize);
        }
    }
}

// إنشاء مثيل عالمي لإدارة الخطوط
window.fontManager = new FontManager();

// تطبيق أحجام الخطوط عند تحميل الصفحة
document.addEventListener('DOMContentLoaded', () => {
    if (window.fontManager) {
        window.fontManager.applyCustomFontSizes();
        window.fontManager.updateFontSizeDisplay();
    }
});

// تطبيق أحجام الخطوط المتجاوبة عند تغيير حجم النافذة
window.addEventListener('resize', () => {
    if (window.fontManager) {
        window.fontManager.applyResponsiveFontSizes();
    }
});
