// Settings Page JavaScript - Updated for Advanced Settings Management

// Global variables
let currentSettings = {};
let settingsChanged = false;

// Initialize settings page
document.addEventListener('DOMContentLoaded', function() {
    // تهيئة نظام إدارة الإعدادات المتقدم
    if (!window.settingsManager) {
        console.warn('Settings Manager not found, initializing fallback...');
        initializeSettings();
        loadSavedSettings();
    } else {
        // استخدام النظام المتقدم
        currentSettings = window.settingsManager.settings;
        settingsChanged = false;
    }
    

    
    setupEventListeners();
    setupSidebarResizer();
    applySettingsToUI();
    

});

// Initialize settings
function initializeSettings() {
    // Set default settings
    currentSettings = {
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

// Load saved settings from localStorage
function loadSavedSettings() {
    const savedSettings = localStorage.getItem('kfuAssistantSettings');
    if (savedSettings) {
        try {
            const parsed = JSON.parse(savedSettings);
            currentSettings = { ...currentSettings, ...parsed };
        } catch (error) {
            console.error('Error loading settings:', error);
        }
    }
    
    // Apply settings to UI
    applySettingsToUI();
    
    // تحميل إعدادات المظهر من نظام تبديل المظهر
    if (window.themeSwitcher) {
        currentSettings.theme = window.themeSwitcher.getCurrentTheme();
        setThemeOption(currentSettings.theme);
    }
}

// Apply settings to UI elements
function applySettingsToUI() {
    // General settings
    document.getElementById('defaultLanguage').value = currentSettings.defaultLanguage;
    document.getElementById('timezone').value = currentSettings.timezone;
    document.getElementById('betaMode').checked = currentSettings.betaMode;
    document.getElementById('autoUpdate').checked = currentSettings.autoUpdate;
    
    // Appearance settings
    setThemeOption(currentSettings.theme);
    setFontSizeDisplay(currentSettings.fontSize);
    document.getElementById('sidebarBehavior').value = currentSettings.sidebarBehavior;
    document.getElementById('animations').checked = currentSettings.animations;
    
    // Chat settings
    document.getElementById('responseStyle').value = currentSettings.responseStyle;
    document.getElementById('maxMessages').value = currentSettings.maxMessages;
    document.getElementById('autoResponse').checked = currentSettings.autoResponse;
    document.getElementById('showSuggestions').checked = currentSettings.showSuggestions;
    document.getElementById('autoCorrect').checked = currentSettings.autoCorrect;
    
    // Privacy settings
    document.getElementById('analytics').checked = currentSettings.analytics;
    document.getElementById('saveChatHistory').checked = currentSettings.saveChatHistory;
    document.getElementById('allowSharing').checked = currentSettings.allowSharing;
    
    // Notification settings
    document.getElementById('enableNotifications').checked = currentSettings.enableNotifications;
    document.getElementById('updateNotifications').checked = currentSettings.updateNotifications;
    document.getElementById('featureNotifications').checked = currentSettings.featureNotifications;
    document.getElementById('notificationSound').checked = currentSettings.notificationSound;
    
    // AI settings
    document.getElementById('aiModel').value = currentSettings.aiModel;
    document.getElementById('creativityLevel').value = currentSettings.creativityLevel;
    document.getElementById('contextLength').value = currentSettings.contextLength;
    document.getElementById('adaptiveLearning').checked = currentSettings.adaptiveLearning;
    document.getElementById('experimentalAI').checked = currentSettings.experimentalAI;
    
    // Data settings
    document.getElementById('autoBackup').checked = currentSettings.autoBackup;
}

// Setup event listeners
function setupEventListeners() {
    // Theme selector
    document.querySelectorAll('.theme-option').forEach(option => {
        option.addEventListener('click', function() {
            const theme = this.dataset.theme;
            setThemeOption(theme);
            currentSettings.theme = theme;
            settingsChanged = true;
            applyTheme(theme);
        });
    });
    
    // Form controls
    document.querySelectorAll('input, select').forEach(element => {
        element.addEventListener('change', function() {
            const settingName = this.id;
            let value = this.type === 'checkbox' ? this.checked : this.value;
            
            // Convert string numbers to actual numbers
            if (this.type === 'range' || (this.tagName === 'SELECT' && !isNaN(value))) {
                value = parseInt(value);
            }
            
            currentSettings[settingName] = value;
            settingsChanged = true;
            
            // Apply immediate changes
            applyImmediateSetting(settingName, value);
        });
    });
    
    // Creativity slider
    document.getElementById('creativityLevel').addEventListener('input', function() {
        updateCreativityDisplay(this.value);
    });
}

// Set theme option
function setThemeOption(theme) {
    document.querySelectorAll('.theme-option').forEach(option => {
        option.classList.remove('active');
    });
    
    const activeOption = document.querySelector(`[data-theme="${theme}"]`);
    if (activeOption) {
        activeOption.classList.add('active');
    }
}

// Apply theme
function applyTheme(theme) {
    const body = document.body;
    
    // Remove existing theme classes
    body.classList.remove('theme-light', 'theme-dark');
    
    if (theme === 'light') {
        body.classList.add('theme-light');
    } else if (theme === 'dark') {
        body.classList.add('theme-dark');
    } else if (theme === 'auto') {
        // Auto theme based on system preference
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            body.classList.add('theme-dark');
        } else {
            body.classList.add('theme-light');
        }
    }
}

// Set font size display
function setFontSizeDisplay(size) {
    const display = document.getElementById('fontSizeDisplay');
    const sizeMap = {
        'small': 'صغير',
        'medium': 'متوسط',
        'large': 'كبير',
        'xlarge': 'كبير جداً'
    };
    display.textContent = sizeMap[size] || 'متوسط';
}

// Update creativity display
function updateCreativityDisplay(value) {
    const creativitySlider = document.getElementById('creativityLevel');
    if (creativitySlider) {
        // You can add visual feedback here if needed
        console.log('Creativity level:', value);
    }
}

// Apply immediate setting changes
function applyImmediateSetting(settingName, value) {
    switch (settingName) {
        case 'fontSize':
            setFontSizeDisplay(value);
            applyFontSize(value);
            break;
        case 'animations':
            applyAnimations(value);
            break;
        case 'theme':
            applyTheme(value);
            break;
        // Add more immediate applications as needed
    }
}

// Apply font size
function applyFontSize(size) {
    const body = document.body;
    const sizeMap = {
        'small': '0.875rem',
        'medium': '1rem',
        'large': '1.125rem',
        'xlarge': '1.25rem'
    };
    
    body.style.fontSize = sizeMap[size] || '1rem';
}

// Apply animations
function applyAnimations(enabled) {
    const body = document.body;
    if (enabled) {
        body.style.setProperty('--animation-duration', '0.3s');
    } else {
        body.style.setProperty('--animation-duration', '0s');
    }
}

// Show settings section
function showSettingsSection(sectionName) {
    // Hide all sections
    document.querySelectorAll('.settings-section').forEach(section => {
        section.classList.remove('active');
    });
    
    // Remove active class from all menu items
    document.querySelectorAll('.settings-menu-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // Show selected section
    const selectedSection = document.getElementById(`${sectionName}-section`);
    if (selectedSection) {
        selectedSection.classList.add('active');
    }
    
    // Add active class to menu item
    const activeMenuItem = document.querySelector(`[onclick="showSettingsSection('${sectionName}')"]`);
    if (activeMenuItem) {
        activeMenuItem.classList.add('active');
    }
    
    // Update title
    updateSettingsTitle(sectionName);
}

// Update settings title
function updateSettingsTitle(sectionName) {
    const titleMap = {
        'general': 'الإعدادات العامة',
        'appearance': 'إعدادات المظهر',
        'chat': 'إعدادات المحادثة',
        'privacy': 'إعدادات الخصوصية',
        'notifications': 'إعدادات الإشعارات',
        'ai': 'إعدادات الذكاء الاصطناعي',
        'data': 'البيانات والنسخ الاحتياطية',
        'about': 'حول التطبيق'
    };
    
    const titleElement = document.getElementById('settingsTitle');
    if (titleElement) {
        titleElement.textContent = titleMap[sectionName] || 'الإعدادات';
    }
}

// Toggle sidebar
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const mainSettings = document.querySelector('.main-settings');
    
    if (window.innerWidth <= 768) {
        // Mobile behavior
        if (sidebar.classList.contains('show')) {
            sidebar.classList.remove('show');
        } else {
            sidebar.classList.add('show');
        }
    } else {
        // Desktop behavior
        if (sidebar.classList.contains('collapsed')) {
            sidebar.classList.remove('collapsed');
            mainSettings.classList.remove('sidebar-collapsed');
        } else {
            sidebar.classList.add('collapsed');
            mainSettings.classList.add('sidebar-collapsed');
        }
    }
}

// Setup sidebar resizer
function setupSidebarResizer() {
    const resizer = document.getElementById('sidebarResizer');
    const sidebar = document.getElementById('sidebar');
    const mainSettings = document.querySelector('.main-settings');
    
    if (!resizer) return;
    
    let isResizing = false;
    let startX, startWidth;
    
    resizer.addEventListener('mousedown', function(e) {
        isResizing = true;
        startX = e.clientX;
        startWidth = parseInt(getComputedStyle(sidebar).width, 10);
        
        document.addEventListener('mousemove', handleMouseMove);
        document.addEventListener('mouseup', handleMouseUp);
        
        e.preventDefault();
    });
    
    function handleMouseMove(e) {
        if (!isResizing) return;
        
        const width = startWidth - (e.clientX - startX);
        const minWidth = 280;
        const maxWidth = 500;
        
        if (width >= minWidth && width <= maxWidth) {
            sidebar.style.width = width + 'px';
            mainSettings.style.marginRight = width + 'px';
        }
    }
    
    function handleMouseUp() {
        isResizing = false;
        document.removeEventListener('mousemove', handleMouseMove);
        document.removeEventListener('mouseup', handleMouseUp);
    }
}

// Save settings - Updated for Advanced Settings Management
function saveSettings() {
    if (window.settingsManager) {
        const success = window.settingsManager.saveSettings();
        if (success) {
            settingsChanged = false;
            showSuccessMessage('تم حفظ الإعدادات بنجاح');
        } else {
            showErrorMessage('حدث خطأ أثناء حفظ الإعدادات');
        }
    } else {
        // Fallback for old system
        try {
            localStorage.setItem('kfuAssistantSettings', JSON.stringify(currentSettings));
            settingsChanged = false;
            showSuccessMessage('تم حفظ الإعدادات بنجاح');
        } catch (error) {
            console.error('Error saving settings:', error);
            showErrorMessage('حدث خطأ أثناء حفظ الإعدادات');
        }
    }
}

// Reset settings
function resetSettings() {
    if (confirm('هل أنت متأكد من إعادة تعيين جميع الإعدادات؟')) {
        localStorage.removeItem('kfuAssistantSettings');
        initializeSettings();
        applySettingsToUI();
        settingsChanged = false;
        showSuccessMessage('تم إعادة تعيين الإعدادات');
    }
}

// Clear all data
function clearAllData() {
    if (confirm('هل أنت متأكد من حذف جميع البيانات المحفوظة؟ هذا الإجراء لا يمكن التراجع عنه.')) {
        try {
            // Clear all localStorage data
            localStorage.clear();
            
            // Clear other stored data
            sessionStorage.clear();
            
            // Clear IndexedDB if used
            if ('indexedDB' in window) {
                indexedDB.databases().then(databases => {
                    databases.forEach(db => {
                        indexedDB.deleteDatabase(db.name);
                    });
                });
            }
            
            showSuccessMessage('تم حذف جميع البيانات بنجاح');
            
            // Reload page after a short delay
            setTimeout(() => {
                window.location.reload();
            }, 1500);
            
        } catch (error) {
            console.error('Error clearing data:', error);
            showErrorMessage('حدث خطأ أثناء حذف البيانات');
        }
    }
}

// Export data
function exportData() {
    try {
        const data = {
            settings: currentSettings,
            timestamp: new Date().toISOString(),
            version: '1.0.0'
        };
        
        const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        
        const a = document.createElement('a');
        a.href = url;
        a.download = `kfu-assistant-backup-${new Date().toISOString().split('T')[0]}.json`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        
        showSuccessMessage('تم تصدير البيانات بنجاح');
    } catch (error) {
        console.error('Error exporting data:', error);
        showErrorMessage('حدث خطأ أثناء تصدير البيانات');
    }
}

// Import data
function importData() {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.json';
    
    input.onchange = function(e) {
        const file = e.target.files[0];
        if (!file) return;
        
        const reader = new FileReader();
        reader.onload = function(e) {
            try {
                const data = JSON.parse(e.target.result);
                
                if (data.settings) {
                    currentSettings = { ...currentSettings, ...data.settings };
                    applySettingsToUI();
                    settingsChanged = true;
                    showSuccessMessage('تم استيراد البيانات بنجاح');
                } else {
                    showErrorMessage('ملف غير صالح');
                }
            } catch (error) {
                console.error('Error importing data:', error);
                showErrorMessage('حدث خطأ أثناء استيراد البيانات');
            }
        };
        
        reader.readAsText(file);
    };
    
    input.click();
}

// Font size controls - Updated for Advanced Font Management
function increaseFontSize() {
    if (window.fontManager) {
        const newSize = window.fontManager.increaseFontSize();
        updateFontSizeUI(newSize);
        settingsChanged = true;
    } else {
        // Fallback for old system
        const sizes = ['small', 'medium', 'large', 'xlarge'];
        const currentSize = currentSettings.fontSize;
        const currentIndex = sizes.indexOf(currentSize);
        
        if (currentIndex < sizes.length - 1) {
            const newSize = sizes[currentIndex + 1];
            currentSettings.fontSize = newSize;
            if (document.getElementById('fontSize')) {
                document.getElementById('fontSize').value = newSize;
            }
            setFontSizeDisplay(newSize);
            applyFontSize(newSize);
            settingsChanged = true;
            showNotification('تم زيادة حجم الخط بنجاح');
        }
    }
}

function decreaseFontSize() {
    if (window.fontManager) {
        const newSize = window.fontManager.decreaseFontSize();
        updateFontSizeUI(newSize);
        settingsChanged = true;
    } else {
        // Fallback for old system
        const sizes = ['small', 'medium', 'large', 'xlarge'];
        const currentSize = currentSettings.fontSize;
        const currentIndex = sizes.indexOf(currentSize);
        
        if (currentIndex > 0) {
            const newSize = sizes[currentIndex - 1];
            currentSettings.fontSize = newSize;
            if (document.getElementById('fontSize')) {
                document.getElementById('fontSize').value = newSize;
            }
            setFontSizeDisplay(newSize);
            applyFontSize(newSize);
            settingsChanged = true;
            showNotification('تم تقليل حجم الخط بنجاح');
        }
    }
}

// تحديث واجهة المستخدم لحجم الخط
function updateFontSizeUI(size) {
    if (document.getElementById('fontSize')) {
        document.getElementById('fontSize').value = size;
    }
    setFontSizeDisplay(size);
    
    // تحديث الإعدادات
    if (window.settingsManager) {
        window.settingsManager.setSetting('fontSize', size);
    } else {
        currentSettings.fontSize = size;
    }
}

// تطبيق حجم الخط - Updated
function applyFontSize(size) {
    if (window.fontManager) {
        window.fontManager.setFontSize(size);
    } else {
        // Fallback for old system
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
        }
    }
}



// تطبيق سلوك الشريط الجانبي
function applySidebarBehavior() {
    const sidebar = document.getElementById('sidebar');
    if (!sidebar) return;
    
    // إزالة الأصناف السابقة
    sidebar.classList.remove('sidebar-hover', 'sidebar-manual');
    
    switch (currentSettings.sidebarBehavior) {
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

// تطبيق الرسوم المتحركة
function applyAnimations() {
    const html = document.documentElement;
    
    if (currentSettings.animations) {
        html.classList.remove('no-animations');
        html.classList.add('animations-enabled');
    } else {
        html.classList.remove('animations-enabled');
        html.classList.add('no-animations');
    }
}

// عرض إشعار
function showNotification(message) {
    if (window.themeSwitcher) {
        window.themeSwitcher.showNotification(message);
    } else {
        showSnackbar(message, 'success');
    }
}

// Show messages
function showSuccessMessage(message) {
    showSnackbar(message, 'success');
}

function showErrorMessage(message) {
    showSnackbar(message, 'error');
}

function showSnackbar(message, type = 'info') {
    // Create snackbar element
    const snackbar = document.createElement('div');
    snackbar.className = `snackbar snackbar-${type}`;
    snackbar.innerHTML = `
        <div class="snackbar-content">
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
            <span>${message}</span>
        </div>
    `;
    
    // Add styles
    snackbar.style.cssText = `
        position: fixed;
        bottom: 2rem;
        left: 2rem;
        background: ${type === 'success' ? 'var(--bs-success)' : type === 'error' ? 'var(--bs-danger)' : 'var(--bs-info)'};
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 0.5rem;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        z-index: 9999;
        transform: translateY(100px);
        opacity: 0;
        transition: all 0.3s ease;
    `;
    
    document.body.appendChild(snackbar);
    
    // Animate in
    setTimeout(() => {
        snackbar.style.transform = 'translateY(0)';
        snackbar.style.opacity = '1';
    }, 100);
    
    // Remove after 3 seconds
    setTimeout(() => {
        snackbar.style.transform = 'translateY(100px)';
        snackbar.style.opacity = '0';
        setTimeout(() => {
            document.body.removeChild(snackbar);
        }, 300);
    }, 3000);
}

// About page functions
function showPrivacyPolicy() {
    alert('سياسة الخصوصية - سيتم إضافة المحتوى قريباً');
}

function showTermsOfService() {
    alert('شروط الاستخدام - سيتم إضافة المحتوى قريباً');
}

function showHelp() {
    alert('المساعدة والدعم - سيتم إضافة المحتوى قريباً');
}

function showFeedback() {
    alert('إرسال ملاحظات - سيتم إضافة المحتوى قريباً');
}

// Warn before leaving if settings changed
window.addEventListener('beforeunload', function(e) {
    if (settingsChanged) {
        e.preventDefault();
        e.returnValue = 'لديك تغييرات غير محفوظة. هل تريد المغادرة؟';
    }
});

// Handle window resize
window.addEventListener('resize', function() {
    // Adjust layout for mobile
    if (window.innerWidth <= 768) {
        const sidebar = document.getElementById('sidebar');
        const mainSettings = document.querySelector('.main-settings');
        
        if (sidebar && !sidebar.classList.contains('collapsed')) {
            sidebar.classList.add('collapsed');
            mainSettings.classList.add('sidebar-collapsed');
        }
    }
});

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function(e) {
    if (window.innerWidth <= 768) {
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.querySelector('.sidebar-toggle');
        
        if (sidebar && sidebar.classList.contains('show') && 
            !sidebar.contains(e.target) && 
            !sidebarToggle.contains(e.target)) {
            sidebar.classList.remove('show');
        }
    }
});
