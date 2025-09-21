/**
 * إدارة أيقونة مساعد كفو المخصصة
 * يوفر دوال مساعدة لاستخدام الأيقونة في التطبيق
 */

class KFUIconManager {
    constructor() {
        this.iconClasses = {
            base: 'kfu-icon',
            colors: {
                white: 'kfu-icon-white',
                primary: 'kfu-icon-primary',
                success: 'kfu-icon-success',
                info: 'kfu-icon-info',
                warning: 'kfu-icon-warning',
                danger: 'kfu-icon-danger',
                dark: 'kfu-icon-dark',
                light: 'kfu-icon-light'
            },
            sizes: {
                sm: 'kfu-icon-sm',
                lg: 'kfu-icon-lg',
                xl: 'kfu-icon-xl',
                '2x': 'kfu-icon-2x',
                '3x': 'kfu-icon-3x'
            }
        };
    }

    /**
     * إنشاء عنصر أيقونة مساعد كفو
     * @param {string} color - لون الأيقونة (white, primary, success, etc.)
     * @param {string} size - حجم الأيقونة (sm, lg, xl, 2x, 3x)
     * @param {string} additionalClasses - فئات CSS إضافية
     * @returns {HTMLElement} عنصر الأيقونة
     */
    createIcon(color = 'primary', size = null, additionalClasses = '') {
        const iconElement = document.createElement('i');
        let classes = [this.iconClasses.base];

        // إضافة لون الأيقونة
        if (color && this.iconClasses.colors[color]) {
            classes.push(this.iconClasses.colors[color]);
        }

        // إضافة حجم الأيقونة
        if (size && this.iconClasses.sizes[size]) {
            classes.push(this.iconClasses.sizes[size]);
        }

        // إضافة فئات إضافية
        if (additionalClasses) {
            classes = classes.concat(additionalClasses.split(' '));
        }

        iconElement.className = classes.join(' ');
        return iconElement;
    }

    /**
     * تحديث لون الأيقونة
     * @param {HTMLElement} iconElement - عنصر الأيقونة
     * @param {string} color - اللون الجديد
     */
    setColor(iconElement, color) {
        // إزالة جميع ألوان الأيقونة
        Object.values(this.iconClasses.colors).forEach(colorClass => {
            iconElement.classList.remove(colorClass);
        });

        // إضافة اللون الجديد
        if (color && this.iconClasses.colors[color]) {
            iconElement.classList.add(this.iconClasses.colors[color]);
        }
    }

    /**
     * تحديث حجم الأيقونة
     * @param {HTMLElement} iconElement - عنصر الأيقونة
     * @param {string} size - الحجم الجديد
     */
    setSize(iconElement, size) {
        // إزالة جميع أحجام الأيقونة
        Object.values(this.iconClasses.sizes).forEach(sizeClass => {
            iconElement.classList.remove(sizeClass);
        });

        // إضافة الحجم الجديد
        if (size && this.iconClasses.sizes[size]) {
            iconElement.classList.add(this.iconClasses.sizes[size]);
        }
    }

    /**
     * استبدال أيقونة FontAwesome بأيقونة مساعد كفو
     * @param {HTMLElement} element - العنصر المراد استبدال أيقونته
     * @param {string} color - لون الأيقونة الجديدة
     * @param {string} size - حجم الأيقونة الجديدة
     */
    replaceWithKFUIcon(element, color = 'primary', size = null) {
        if (element && element.tagName === 'I') {
            const newIcon = this.createIcon(color, size);
            element.className = newIcon.className;
        }
    }

    /**
     * استبدال جميع أيقونات الروبوت بأيقونة مساعد كفو
     * @param {string} color - لون الأيقونة الجديدة
     * @param {string} size - حجم الأيقونة الجديدة
     */
    replaceAllRobotIcons(color = 'white', size = null) {
        const robotIcons = document.querySelectorAll('i.fas.fa-robot');
        robotIcons.forEach(icon => {
            this.replaceWithKFUIcon(icon, color, size);
        });
    }

    /**
     * إنشاء أيقونة مساعد كفو للرسائل
     * @returns {HTMLElement} عنصر الأيقونة
     */
    createMessageIcon() {
        return this.createIcon('white', null, 'message-avatar-icon');
    }

    /**
     * إنشاء أيقونة مساعد كفو للترحيب
     * @returns {HTMLElement} عنصر الأيقونة
     */
    createWelcomeIcon() {
        return this.createIcon('primary', '3x', 'welcome-icon-main');
    }

    /**
     * إنشاء أيقونة مساعد كفو للشريط الجانبي
     * @returns {HTMLElement} عنصر الأيقونة
     */
    createSidebarIcon() {
        return this.createIcon('primary', 'xl', 'sidebar-brand-icon');
    }

    /**
     * إنشاء أيقونة مساعد كفو لمؤشر الكتابة
     * @returns {HTMLElement} عنصر الأيقونة
     */
    createTypingIcon() {
        return this.createIcon('primary', null, 'typing-indicator-icon');
    }
}

// إنشاء نسخة عامة من مدير الأيقونة
window.kfuIconManager = new KFUIconManager();

// دوال مساعدة سريعة
window.KFUIcon = {
    /**
     * إنشاء أيقونة مساعد كفو بسرعة
     * @param {string} color - لون الأيقونة
     * @param {string} size - حجم الأيقونة
     * @returns {HTMLElement} عنصر الأيقونة
     */
    create: (color = 'primary', size = null) => {
        return window.kfuIconManager.createIcon(color, size);
    },

    /**
     * استبدال أيقونة FontAwesome
     * @param {HTMLElement} element - العنصر المراد استبداله
     * @param {string} color - لون الأيقونة الجديدة
     * @param {string} size - حجم الأيقونة الجديدة
     */
    replace: (element, color = 'primary', size = null) => {
        window.kfuIconManager.replaceWithKFUIcon(element, color, size);
    },

    /**
     * استبدال جميع أيقونات الروبوت
     * @param {string} color - لون الأيقونة الجديدة
     * @param {string} size - حجم الأيقونة الجديدة
     */
    replaceAllRobots: (color = 'white', size = null) => {
        window.kfuIconManager.replaceAllRobotIcons(color, size);
    }
};

// تطبيق الأيقونة الجديدة عند تحميل الصفحة
document.addEventListener('DOMContentLoaded', function() {
    console.log('🎨 تحميل نظام أيقونة مساعد كفو...');
    
    // استبدال أيقونات الروبوت الموجودة
    window.KFUIcon.replaceAllRobots('white');
    
    console.log('✅ تم تحميل نظام أيقونة مساعد كفو بنجاح!');
}); 