/**
 * Advanced Settings Management System
 * نظام إدارة الإعدادات المتقدم
 * 
 * @author KFU Development Team
 * @version 2.0.0
 */

class SettingsManager {
    constructor() {
        this.settings = {};
        this.observers = new Map();
        this.storageKey = 'kfuAssistantSettings';
        this.defaultSettings = this.getDefaultSettings();
        this.init();
    }

    /**
     * تهيئة النظام
     */
    init() {
        this.loadSettings();
        this.setupEventListeners();
        this.applyAllSettings();
    }

    /**
     * الحصول على الإعدادات الافتراضية
     */
    getDefaultSettings() {
        return {
            // General settings
            defaultLanguage: 'ar',
            timezone: 'Asia/Riyadh',
            betaMode: false,
            autoUpdate: true,
            
            // Appearance settings
            theme: 'auto',
            fontSize: 'medium',
            sidebarBehavior: 'always',
            animations: true,
            
            // Chat settings
            responseStyle: 'balanced',
            maxMessages: '100',
            autoResponse: false,
            showSuggestions: true,
            autoCorrect: true,
            
            // Privacy settings
            analytics: true,
            saveChatHistory: true,
            allowSharing: false,
            
            // Notification settings
            enableNotifications: true,
            updateNotifications: true,
            featureNotifications: false,
            notificationSound: false,
            
            // AI settings
            aiModel: 'gpt-3.5',
            creativityLevel: 70,
            contextLength: '10',
            adaptiveLearning: true,
            experimentalAI: false,
            
            // Data settings
            autoBackup: true
        };
    }

    /**
     * تحميل الإعدادات من التخزين المحلي
     */
    loadSettings() {
        try {
            const savedSettings = localStorage.getItem(this.storageKey);
            if (savedSettings) {
                const parsed = JSON.parse(savedSettings);
                this.settings = { ...this.defaultSettings, ...parsed };
            } else {
                this.settings = { ...this.defaultSettings };
            }
        } catch (error) {
            console.error('خطأ في تحميل الإعدادات:', error);
            this.settings = { ...this.defaultSettings };
        }
    }

    /**
     * حفظ الإعدادات إلى التخزين المحلي
     */
    saveSettings() {
        try {
            localStorage.setItem(this.storageKey, JSON.stringify(this.settings));
            this.notifyObservers('settingsSaved', this.settings);
            return true;
        } catch (error) {
            console.error('خطأ في حفظ الإعدادات:', error);
            return false;
        }
    }

    /**
     * الحصول على إعداد معين
     */
    getSetting(key) {
        return this.settings[key];
    }

    /**
     * تعيين إعداد معين
     */
    setSetting(key, value, skipNotification = false) {
        const oldValue = this.settings[key];
        this.settings[key] = value;
        
        // تطبيق التغيير فوراً
        this.applySetting(key, value, skipNotification);
        
        // إشعار المراقبين بالتغيير فقط إذا لم يتم تخطي الإشعار
        if (!skipNotification) {
            this.notifyObservers('settingChanged', { key, oldValue, newValue: value });
        }
        
        return true;
    }

    /**
     * تطبيق إعداد معين
     */
    applySetting(key, value, skipNotification = false) {
        switch (key) {
            case 'fontSize':
                this.applyFontSize(value, skipNotification);
                break;
            case 'theme':
                this.applyTheme(value);
                break;
            case 'animations':
                this.applyAnimations(value);
                break;
            case 'sidebarBehavior':
                this.applySidebarBehavior(value);
                break;
            default:
                // تطبيق عام للإعدادات الأخرى
                break;
        }
    }

    /**
     * تطبيق جميع الإعدادات
     */
    applyAllSettings() {
        Object.entries(this.settings).forEach(([key, value]) => {
            this.applySetting(key, value);
        });
    }

    /**
     * تطبيق حجم الخط
     */
    applyFontSize(size, skipNotification = false) {
        const html = document.documentElement;
        const fontSizes = {
            'small': '0.875rem',
            'medium': '1rem',
            'large': '1.125rem',
            'xlarge': '1.25rem'
        };
        
        const fontSize = fontSizes[size];
        if (fontSize) {
            html.style.fontSize = fontSize;
            // إضافة متغير CSS مخصص
            html.style.setProperty('--app-font-size', fontSize);
            
            // إشعار المراقبين بتغيير حجم الخط فقط إذا لم يتم تخطي الإشعار
            if (!skipNotification) {
                this.notifyObservers('fontSizeChanged', { size, fontSize });
            }
        }
    }

    /**
     * تطبيق المظهر
     */
    applyTheme(theme) {
        if (window.themeSwitcher) {
            window.themeSwitcher.setTheme(theme);
        } else {
            // تطبيق مباشر إذا لم يكن themeSwitcher متاحاً
            const html = document.documentElement;
            let effectiveTheme = theme;
            
            if (theme === 'auto') {
                effectiveTheme = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
            }
            
            html.setAttribute('data-bs-theme', effectiveTheme);
        }
    }

    /**
     * تطبيق الرسوم المتحركة
     */
    applyAnimations(enabled) {
        const html = document.documentElement;
        
        if (enabled) {
            html.classList.remove('no-animations');
            html.classList.add('animations-enabled');
            html.style.setProperty('--animation-duration', '0.3s');
        } else {
            html.classList.remove('animations-enabled');
            html.classList.add('no-animations');
            html.style.setProperty('--animation-duration', '0s');
        }
    }

    /**
     * تطبيق سلوك الشريط الجانبي
     */
    applySidebarBehavior(behavior) {
        const sidebar = document.getElementById('sidebar');
        if (!sidebar) return;
        
        // إزالة الأصناف السابقة
        sidebar.classList.remove('sidebar-hover', 'sidebar-manual');
        
        switch (behavior) {
            case 'hover':
                sidebar.classList.add('sidebar-hover');
                break;
            case 'manual':
                sidebar.classList.add('sidebar-manual');
                break;
            case 'always':
            default:
                // لا حاجة لإضافة أصناف إضافية
                break;
        }
    }

    /**
     * إضافة مراقب للتغييرات
     */
    addObserver(event, callback) {
        if (!this.observers.has(event)) {
            this.observers.set(event, []);
        }
        this.observers.get(event).push(callback);
    }

    /**
     * إزالة مراقب
     */
    removeObserver(event, callback) {
        if (this.observers.has(event)) {
            const callbacks = this.observers.get(event);
            const index = callbacks.indexOf(callback);
            if (index > -1) {
                callbacks.splice(index, 1);
            }
        }
    }

    /**
     * إشعار المراقبين
     */
    notifyObservers(event, data) {
        if (this.observers.has(event)) {
            this.observers.get(event).forEach(callback => {
                try {
                    callback(data);
                } catch (error) {
                    console.error('خطأ في تنفيذ مراقب الإعدادات:', error);
                }
            });
        }
    }

    /**
     * إعداد مستمعي الأحداث
     */
    setupEventListeners() {
        // مراقبة تغييرات النظام للمظهر التلقائي
        if (window.matchMedia) {
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
                if (this.settings.theme === 'auto') {
                    this.applyTheme('auto');
                }
            });
        }

        // مراقبة تغييرات حجم النافذة
        window.addEventListener('resize', () => {
            this.notifyObservers('windowResized', { width: window.innerWidth, height: window.innerHeight });
        });
    }

    /**
     * إعادة تعيين الإعدادات
     */
    resetSettings() {
        this.settings = { ...this.defaultSettings };
        this.applyAllSettings();
        this.saveSettings();
        this.notifyObservers('settingsReset', this.settings);
    }

    /**
     * تصدير الإعدادات
     */
    exportSettings() {
        return {
            settings: this.settings,
            timestamp: new Date().toISOString(),
            version: '2.0.0'
        };
    }

    /**
     * استيراد الإعدادات
     */
    importSettings(data) {
        if (data.settings) {
            this.settings = { ...this.defaultSettings, ...data.settings };
            this.applyAllSettings();
            this.saveSettings();
            this.notifyObservers('settingsImported', this.settings);
            return true;
        }
        return false;
    }
}

// إنشاء مثيل عالمي لإدارة الإعدادات
window.settingsManager = new SettingsManager();
