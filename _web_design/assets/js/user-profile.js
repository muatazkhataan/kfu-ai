/**
 * User Profile Manager
 * إدارة الملف الشخصي للمستخدم والفوتر الجانبي
 */

class UserProfileManager {
    constructor() {
        this.isInitialized = false;
        this.footerState = false;

        // انتظار تحميل DOM
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                this.init();
            });
        } else {
            this.init();
        }
    }

    /**
     * تهيئة مدير الملف الشخصي
     */
    init() {
        if (this.isInitialized) return;

        this.setupEventListeners();
        this.loadUserInfo();
        this.initializeFooter();
        this.isInitialized = true;
    }

    /**
     * إعداد مستمعي الأحداث
     */
    setupEventListeners() {
        // إعداد النقر على الملف الشخصي
        const userProfile = document.querySelector('.user-profile');

        if (userProfile) {
            userProfile.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                this.toggleFooter();
            });
        }

        // إعداد إغلاق الفوتر عند النقر خارجه
        document.addEventListener('click', (e) => {
            const footer = document.getElementById('sidebarFooterNew');
            const userProfile = document.querySelector('.user-profile');

            if (footer && footer.style.display !== 'none') {
                if (!footer.contains(e.target) && !userProfile.contains(e.target)) {
                    this.closeFooter();
                }
            }
        });

        // إغلاق الفوتر عند الضغط على Escape
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.closeFooter();
            }
        });
    }

    /**
     * تحميل معلومات المستخدم
     */
    loadUserInfo() {
        try {
            const userInfo = localStorage.getItem('userInfo');
            if (userInfo) {
                const user = JSON.parse(userInfo);
                this.updateUserDisplay(user);
            } else {
                // معلومات افتراضية
                this.updateUserDisplay({
                    name: 'أحمد محمد',
                    role: 'طالب'
                });
            }
        } catch (error) {
            console.error('خطأ في تحميل معلومات المستخدم:', error);
            this.updateUserDisplay({
                name: 'مستخدم',
                role: 'طالب'
            });
        }
    }

    /**
     * تحديث عرض معلومات المستخدم
     */
    updateUserDisplay(user) {
        const userNameElement = document.getElementById('userName');
        const userRoleElement = document.querySelector('.user-role');

        if (userNameElement) {
            userNameElement.textContent = user.name || 'مستخدم';
        }

        if (userRoleElement) {
            userRoleElement.textContent = user.role || 'طالب';
        }
    }

    /**
     * حفظ معلومات المستخدم
     */
    saveUserInfo(userInfo) {
        try {
            localStorage.setItem('userInfo', JSON.stringify(userInfo));
            this.updateUserDisplay(userInfo);
            console.log('✅ تم حفظ معلومات المستخدم');
        } catch (error) {
            console.error('خطأ في حفظ معلومات المستخدم:', error);
        }
    }

    /**
     * تبديل حالة الفوتر
     */
    toggleFooter() {
        const footer = document.getElementById('sidebarFooterNew');
        const userProfile = document.querySelector('.user-profile');

        if (!footer || !userProfile) {
            console.error('❌ لم يتم العثور على عناصر الفوتر أو الملف الشخصي!');
            return;
        }

        const isVisible = footer.style.display !== 'none';
        this.footerState = !isVisible;

        if (this.footerState) {
            this.showFooter();
        } else {
            this.closeFooter();
        }

        // حفظ الحالة
        localStorage.setItem('kfu_acc_footer', this.footerState);
    }

    /**
     * إظهار الفوتر
     */
    showFooter() {
        const footer = document.getElementById('sidebarFooterNew');
        const userProfile = document.querySelector('.user-profile');

        if (footer) {
            footer.style.display = 'block';
            footer.classList.add('show');
        }

        if (userProfile) {
            userProfile.classList.add('active');
        }

        this.footerState = true;
    }

    /**
     * إغلاق الفوتر
     */
    closeFooter() {
        const footer = document.getElementById('sidebarFooterNew');
        const userProfile = document.querySelector('.user-profile');

        if (footer) {
            footer.style.display = 'none';
            footer.classList.remove('show');
        }

        if (userProfile) {
            userProfile.classList.remove('active');
        }

        this.footerState = false;
        localStorage.setItem('kfu_acc_footer', false);
    }

    /**
     * تهيئة الفوتر
     */
    initializeFooter() {
        const footer = document.getElementById('sidebarFooterNew');

        if (footer) {
            // تعيين الفوتر مغلق بشكل افتراضي
            footer.style.display = 'none';

            // تحميل الحالة المحفوظة
            const savedState = localStorage.getItem('kfu_acc_footer');

            if (savedState === 'true') {
                this.showFooter();
            }
        }
    }

    /**
     * إعادة تعيين حالة الفوتر
     */
    resetFooterState() {
        const footer = document.getElementById('sidebarFooterNew');
        if (footer && footer.style.display === 'none') {
            this.showFooter();
        }
    }

    /**
     * عرض الملف الشخصي
     */
    showUserProfile() {
        this.closeFooter();
        // يمكن توجيه المستخدم إلى صفحة الملف الشخصي هنا
        console.log('عرض الملف الشخصي');
        // window.location.href = 'profile.html';
    }

    /**
     * عرض إعدادات الحساب
     */
    showAccountSettings() {
        this.closeFooter();
        // يمكن توجيه المستخدم إلى صفحة إعدادات الحساب هنا
        console.log('عرض إعدادات الحساب');
        // window.location.href = 'account-settings.html';
    }

    /**
     * تسجيل الخروج
     */
    logout() {
        this.closeFooter();

        // تأكيد تسجيل الخروج
        if (confirm('هل أنت متأكد من تسجيل الخروج؟')) {
            // مسح البيانات المحلية
            localStorage.removeItem('userInfo');
            localStorage.removeItem('kfu_acc_footer');

            // توجيه إلى صفحة تسجيل الدخول
            console.log('تسجيل الخروج');
            // window.location.href = 'login.html';
        }
    }

    /**
     * تحديث معلومات المستخدم
     */
    updateUser(userInfo) {
        this.saveUserInfo(userInfo);
    }

    /**
     * الحصول على معلومات المستخدم الحالية
     */
    getCurrentUser() {
        try {
            const userInfo = localStorage.getItem('userInfo');
            return userInfo ? JSON.parse(userInfo) : null;
        } catch (error) {
            console.error('خطأ في الحصول على معلومات المستخدم:', error);
            return null;
        }
    }

    /**
     * التحقق من حالة الفوتر
     */
    isFooterOpen() {
        return this.footerState;
    }

    /**
     * تدمير المدير وإزالة مستمعي الأحداث
     */
    destroy() {
        // إزالة مستمعي الأحداث
        const userProfile = document.querySelector('.user-profile');
        if (userProfile) {
            userProfile.removeEventListener('click', this.toggleFooter);
        }

        this.isInitialized = false;
        console.log('🗑️ تم تدمير مدير الملف الشخصي');
    }
}

// إنشاء مثيل عالمي
const userProfileManager = new UserProfileManager();

// دالة بسيطة للتوافق مع الكود الموجود
function toggleFooter() {
    userProfileManager.toggleFooter();
}

// ربط الدالة بـ window للاستخدام من HTML
window.toggleFooter = toggleFooter;

// ربط الدالة بـ folderManager للتوافق
if (typeof window.folderManager === 'undefined') {
    window.folderManager = {};
}
window.folderManager.toggleFooterAccordion = toggleFooter;

// تصدير المدير للاستخدام في ملفات أخرى
if (typeof module !== 'undefined' && module.exports) {
    module.exports = UserProfileManager;
}
