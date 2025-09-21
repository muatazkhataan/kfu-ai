/**
 * Theme Switcher - Simple Bootstrap Theme Management
 * نظام تبديل المظهر البسيط باستخدام Bootstrap
 * 
 * @author KFU Development Team
 * @version 1.0.0
 */

class ThemeSwitcher {
    constructor() {
        this.currentTheme = 'auto';
        this.storageKey = 'kfu_theme_preference';
        this.init();
    }

    /**
     * تهيئة النظام
     */
    init() {
        this.loadThemePreference();
        this.applyTheme();
        this.setupEventListeners();
        this.setupSystemThemeListener();
    }

    /**
     * تحميل تفضيل المظهر المحفوظ
     */
    loadThemePreference() {
        try {
            const savedTheme = localStorage.getItem(this.storageKey);
            if (savedTheme) {
                this.currentTheme = savedTheme;
            }
        } catch (error) {
            console.error('خطأ في تحميل تفضيل المظهر:', error);
        }
    }

    /**
     * حفظ تفضيل المظهر
     */
    saveThemePreference() {
        try {
            localStorage.setItem(this.storageKey, this.currentTheme);
        } catch (error) {
            console.error('خطأ في حفظ تفضيل المظهر:', error);
        }
    }

    /**
     * تطبيق المظهر المحدد
     */
    applyTheme() {
        const html = document.documentElement;
        let effectiveTheme = this.currentTheme;
        
        // تحديد المظهر الفعال
        if (this.currentTheme === 'auto') {
            effectiveTheme = this.getSystemTheme();
        }
        
        // تطبيق المظهر باستخدام Bootstrap
        html.setAttribute('data-bs-theme', effectiveTheme);
        
        // تحديث أيقونة المظهر
        this.updateThemeIcon();
        
        // إطلاق حدث تغيير المظهر
        this.dispatchThemeChangeEvent(effectiveTheme);
    }

    /**
     * الحصول على مظهر النظام
     */
    getSystemTheme() {
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            return 'dark';
        }
        return 'light';
    }

    /**
     * تعيين المظهر
     */
    setTheme(theme) {
        this.currentTheme = theme;
        this.applyTheme();
        this.saveThemePreference();
        this.showNotification(`تم تغيير المظهر إلى: ${this.getThemeName(theme)}`);
    }

    /**
     * الحصول على اسم المظهر بالعربية
     */
    getThemeName(theme) {
        const names = {
            'light': 'فاتح',
            'dark': 'داكن',
            'auto': 'تلقائي'
        };
        return names[theme] || theme;
    }

    /**
     * إعداد مستمعي الأحداث
     */
    setupEventListeners() {
        // مستمعي أحداث اختيار المظهر
        document.querySelectorAll('.theme-option').forEach(option => {
            option.addEventListener('click', (e) => {
                const theme = e.currentTarget.dataset.theme;
                this.setTheme(theme);
            });
        });
    }

    /**
     * إعداد مستمع مظهر النظام
     */
    setupSystemThemeListener() {
        if (window.matchMedia) {
            const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
            mediaQuery.addEventListener('change', () => {
                if (this.currentTheme === 'auto') {
                    this.applyTheme();
                }
            });
        }
    }

    /**
     * تحديث أيقونة المظهر
     */
    updateThemeIcon() {
        const themeOptions = document.querySelectorAll('.theme-option');
        themeOptions.forEach(option => {
            option.classList.remove('active');
            if (option.dataset.theme === this.currentTheme) {
                option.classList.add('active');
            }
        });
    }

    /**
     * إطلاق حدث تغيير المظهر
     */
    dispatchThemeChangeEvent(theme) {
        const event = new CustomEvent('themeChanged', {
            detail: {
                theme: theme,
                originalTheme: this.currentTheme,
                timestamp: new Date().toISOString()
            }
        });
        document.dispatchEvent(event);
    }

    /**
     * عرض إشعار
     */
    showNotification(message) {
        // إنشاء عنصر الإشعار
        const notification = document.createElement('div');
        notification.className = 'theme-notification';
        notification.innerHTML = `
            <div class="notification-content">
                <i class="fas fa-check-circle"></i>
                <span>${message}</span>
            </div>
        `;
        
        // إضافة الإشعار للصفحة
        document.body.appendChild(notification);
        
        // إظهار الإشعار
        setTimeout(() => {
            notification.classList.add('show');
        }, 100);
        
        // إخفاء الإشعار بعد 3 ثوان
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }, 3000);
    }

    /**
     * الحصول على المظهر الحالي
     */
    getCurrentTheme() {
        return this.currentTheme;
    }

    /**
     * الحصول على المظهر الفعال
     */
    getEffectiveTheme() {
        if (this.currentTheme === 'auto') {
            return this.getSystemTheme();
        }
        return this.currentTheme;
    }
}

// إنشاء نسخة عالمية من مبدل المظهر
window.themeSwitcher = new ThemeSwitcher();

// تصدير الدوال للاستخدام العام
window.setTheme = (theme) => window.themeSwitcher.setTheme(theme);
