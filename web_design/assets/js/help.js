// Help Page JavaScript

// Global variables
let currentHelpSection = 'getting-started';

// Initialize help page
document.addEventListener('DOMContentLoaded', function() {
    initializeHelpPage();
    setupEventListeners();
    setupSidebarResizer();
    loadUserInfo();
});

// Initialize help page
function initializeHelpPage() {
    console.log('🚀 بدء تحميل صفحة المساعدة...');
    
    // Set default section
    showHelpSection('getting-started');
    
    console.log('✅ تم تحميل صفحة المساعدة بنجاح!');
}

// Setup event listeners
function setupEventListeners() {
    // Close dropdowns when clicking outside
    document.addEventListener("click", function (e) {
        // Close user dropdown
        if (!e.target.closest('.user-profile-section')) {
            closeUserDropdown();
        }
    });
}

// Show help section
function showHelpSection(sectionName) {
    // Hide all sections
    document.querySelectorAll('.help-section').forEach(section => {
        section.classList.remove('active');
    });
    
    // Remove active class from all menu items
    document.querySelectorAll('.help-menu-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // Show selected section
    const selectedSection = document.getElementById(`${sectionName}-section`);
    if (selectedSection) {
        selectedSection.classList.add('active');
    }
    
    // Add active class to menu item
    const activeMenuItem = document.querySelector(`[onclick="showHelpSection('${sectionName}')"]`);
    if (activeMenuItem) {
        activeMenuItem.classList.add('active');
    }
    
    // Update title
    updateHelpTitle(sectionName);
    
    // Update current section
    currentHelpSection = sectionName;
    
    // Scroll to top
    document.querySelector('.help-content').scrollTop = 0;
}

// Update help title
function updateHelpTitle(sectionName) {
    const titleMap = {
        'getting-started': 'البدء السريع',
        'features': 'الميزات الرئيسية',
        'chat-guide': 'دليل المحادثة',
        'folders': 'إدارة المجلدات',
        'settings': 'الإعدادات',
        'faq': 'الأسئلة الشائعة'
    };
    
    const titleElement = document.getElementById('helpTitle');
    if (titleElement) {
        titleElement.textContent = titleMap[sectionName] || 'المساعدة';
    }
}

// Toggle sidebar
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const mainHelp = document.querySelector('.main-help');
    
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
            mainHelp.classList.remove('sidebar-collapsed');
        } else {
            sidebar.classList.add('collapsed');
            mainHelp.classList.add('sidebar-collapsed');
        }
    }
}

// Setup sidebar resizer
function setupSidebarResizer() {
    const resizer = document.getElementById('sidebarResizer');
    const sidebar = document.getElementById('sidebar');
    const mainHelp = document.querySelector('.main-help');
    
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
            mainHelp.style.marginRight = width + 'px';
        }
    }
    
    function handleMouseUp() {
        isResizing = false;
        document.removeEventListener('mousemove', handleMouseMove);
        document.removeEventListener('mouseup', handleMouseUp);
    }
}

// Toggle FAQ item
function toggleFAQ(element) {
    const faqItem = element.closest('.faq-item');
    
    if (faqItem.classList.contains('active')) {
        faqItem.classList.remove('active');
    } else {
        // Close all other FAQ items
        document.querySelectorAll('.faq-item').forEach(item => {
            item.classList.remove('active');
        });
        
        // Open current FAQ item
        faqItem.classList.add('active');
    }
}

// Search help
function searchHelp() {
    const searchTerm = prompt('أدخل كلمة البحث:');
    
    if (searchTerm && searchTerm.trim()) {
        // Simple search implementation
        const searchResults = performHelpSearch(searchTerm.trim());
        
        if (searchResults.length > 0) {
            showSearchResults(searchResults);
        } else {
            alert('لم يتم العثور على نتائج لبحثك. حاول استخدام كلمات مختلفة.');
        }
    }
}

// Perform help search
function performHelpSearch(searchTerm) {
    const results = [];
    const searchableContent = [
        {
            section: 'getting-started',
            title: 'البدء السريع',
            content: 'خطوات البدء السريع محادثة جديدة طرح سؤال احصل على الإجابة نظم محادثاتك'
        },
        {
            section: 'features',
            title: 'الميزات الرئيسية',
            content: 'ذكاء اصطناعي متقدم إدارة المجلدات البحث المتقدم تصدير المحادثات تصميم متجاوب خصوصية وأمان'
        },
        {
            section: 'chat-guide',
            title: 'دليل المحادثة',
            content: 'كيفية بدء محادثة نصائح للحصول على إجابات أفضل أمثلة على الأسئلة المفيدة'
        },
        {
            section: 'folders',
            title: 'إدارة المجلدات',
            content: 'إنشاء مجلد جديد إضافة محادثة إلى مجلد إدارة المجلدات نصائح لتنظيم المجلدات'
        },
        {
            section: 'settings',
            title: 'الإعدادات',
            content: 'الإعدادات العامة إعدادات المظهر إعدادات المحادثة إعدادات الخصوصية'
        },
        {
            section: 'faq',
            title: 'الأسئلة الشائعة',
            content: 'كيف يمكنني بدء محادثة جديدة حفظ محادثة البحث في المحادثات تغيير مظهر التطبيق حذف محادثة مشاركة محادثة استخدام التطبيق بدون إنترنت تغيير إعدادات الذكاء الاصطناعي'
        }
    ];
    
    const lowerSearchTerm = searchTerm.toLowerCase();
    
    searchableContent.forEach(item => {
        if (item.content.toLowerCase().includes(lowerSearchTerm) || 
            item.title.toLowerCase().includes(lowerSearchTerm)) {
            results.push(item);
        }
    });
    
    return results;
}

// Show search results
function showSearchResults(results) {
    let message = 'نتائج البحث:\n\n';
    
    results.forEach((result, index) => {
        message += `${index + 1}. ${result.title}\n`;
    });
    
    message += '\nانقر على "موافق" للانتقال إلى أول نتيجة.';
    
    if (confirm(message)) {
        showHelpSection(results[0].section);
    }
}



// User profile functions moved to user-profile.js

// logout and loadUserInfo functions moved to user-profile.js

// Add event listener for contact form
document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', submitContactForm);
    }
});

// Handle window resize
window.addEventListener('resize', function() {
    // Adjust layout for mobile
    if (window.innerWidth <= 768) {
        const sidebar = document.getElementById('sidebar');
        const mainHelp = document.querySelector('.main-help');
        
        if (sidebar && !sidebar.classList.contains('collapsed')) {
            sidebar.classList.add('collapsed');
            mainHelp.classList.add('sidebar-collapsed');
        }
    }
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + K for search
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        searchHelp();
    }
    
    // Escape to close dropdowns
    if (e.key === 'Escape') {
        closeUserDropdown();
    }
});

// Export functions for global access
window.showHelpSection = showHelpSection;
window.toggleFAQ = toggleFAQ;
window.searchHelp = searchHelp;

window.toggleSidebar = toggleSidebar;
// User profile functions are now available through user-profile.js
