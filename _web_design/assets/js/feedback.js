// Feedback Page JavaScript

// Global variables
let currentFeedbackSection = 'feedback-form';
let uploadedImages = [];
let feedbackHistory = [];

// Initialize feedback page
document.addEventListener('DOMContentLoaded', function() {
    initializeFeedbackPage();
    setupEventListeners();
    setupSidebarResizer();
    setupImageUpload();
    loadUserInfo();
    loadFeedbackHistory();
    detectBrowserInfo();
});

// Initialize feedback page
function initializeFeedbackPage() {
    console.log('🚀 بدء تحميل صفحة الملاحظات...');
    
    // Set default section
    showFeedbackSection('feedback-form');
    
    // Load saved draft if exists
    loadDraft();
    
    console.log('✅ تم تحميل صفحة الملاحظات بنجاح!');
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

    // Form submission
    const feedbackForm = document.getElementById('feedbackForm');
    if (feedbackForm) {
        feedbackForm.addEventListener('submit', submitFeedback);
    }

    // Auto-save draft
    const formInputs = document.querySelectorAll('#feedbackForm input, #feedbackForm select, #feedbackForm textarea');
    formInputs.forEach(input => {
        input.addEventListener('input', autoSaveDraft);
        input.addEventListener('change', autoSaveDraft);
    });

    // Filters
    const statusFilter = document.getElementById('statusFilter');
    const typeFilter = document.getElementById('typeFilter');
    
    if (statusFilter) {
        statusFilter.addEventListener('change', filterFeedbackHistory);
    }
    if (typeFilter) {
        typeFilter.addEventListener('change', filterFeedbackHistory);
    }
}

// Setup image upload functionality
function setupImageUpload() {
    const imageUploadArea = document.getElementById('imageUploadArea');
    const imageInput = document.getElementById('imageInput');
    const imagePreviewContainer = document.getElementById('imagePreviewContainer');

    if (!imageUploadArea || !imageInput || !imagePreviewContainer) return;

    // Click to upload
    imageUploadArea.addEventListener('click', () => {
        imageInput.click();
    });

    // File selection
    imageInput.addEventListener('change', handleImageSelection);

    // Drag and drop
    imageUploadArea.addEventListener('dragover', (e) => {
        e.preventDefault();
        imageUploadArea.classList.add('dragover');
    });

    imageUploadArea.addEventListener('dragleave', () => {
        imageUploadArea.classList.remove('dragover');
    });

    imageUploadArea.addEventListener('drop', (e) => {
        e.preventDefault();
        imageUploadArea.classList.remove('dragover');
        const files = Array.from(e.dataTransfer.files);
        handleImageFiles(files);
    });
}

// Handle image selection
function handleImageSelection(event) {
    const files = Array.from(event.target.files);
    handleImageFiles(files);
}

// Handle image files
function handleImageFiles(files) {
    const maxFiles = 5;
    const maxSize = 5 * 1024 * 1024; // 5MB

    // Check number of files
    if (uploadedImages.length + files.length > maxFiles) {
        showAlert('يمكنك رفع 5 صور كحد أقصى', 'danger');
        return;
    }

    files.forEach(file => {
        // Check file type
        if (!file.type.startsWith('image/')) {
            showAlert(`الملف ${file.name} ليس صورة صحيحة`, 'danger');
            return;
        }

        // Check file size
        if (file.size > maxSize) {
            showAlert(`الملف ${file.name} أكبر من 5 ميجابايت`, 'danger');
            return;
        }

        // Process image
        processImage(file);
    });
}

// Process image file
function processImage(file) {
    const reader = new FileReader();
    
    reader.onload = function(e) {
        const imageData = {
            id: Date.now() + Math.random(),
            name: file.name,
            size: file.size,
            type: file.type,
            data: e.target.result
        };

        uploadedImages.push(imageData);
        displayImagePreview(imageData);
        updateUploadArea();
    };

    reader.readAsDataURL(file);
}

// Display image preview
function displayImagePreview(imageData) {
    const imagePreviewContainer = document.getElementById('imagePreviewContainer');
    
    const previewItem = document.createElement('div');
    previewItem.className = 'image-preview-item';
    previewItem.innerHTML = `
        <img src="${imageData.data}" alt="${imageData.name}">
        <div class="image-preview-overlay">
            <div class="image-preview-actions">
                <button class="image-preview-btn view" onclick="viewImage('${imageData.id}')" title="عرض">
                    <i class="fas fa-eye"></i>
                </button>
                <button class="image-preview-btn" onclick="removeImage('${imageData.id}')" title="حذف">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        </div>
    `;

    imagePreviewContainer.appendChild(previewItem);
}

// Update upload area
function updateUploadArea() {
    const imageUploadArea = document.getElementById('imageUploadArea');
    const placeholder = imageUploadArea.querySelector('.upload-placeholder');
    
    if (uploadedImages.length >= 5) {
        placeholder.innerHTML = `
            <i class="fas fa-check-circle" style="color: var(--bs-success);"></i>
            <p>تم رفع الحد الأقصى من الصور</p>
            <small class="text-muted">5 صور</small>
        `;
        imageUploadArea.style.cursor = 'not-allowed';
    } else {
        placeholder.innerHTML = `
            <i class="fas fa-cloud-upload-alt"></i>
            <p>اسحب وأفلت الصور هنا أو انقر للاختيار</p>
            <small class="text-muted">الحد الأقصى: 5 صور، كل صورة حتى 5 ميجابايت</small>
        `;
        imageUploadArea.style.cursor = 'pointer';
    }
}

// View image
function viewImage(imageId) {
    const image = uploadedImages.find(img => img.id == imageId);
    if (image) {
        // Create modal to view image
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">${image.name}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center">
                        <img src="${image.data}" alt="${image.name}" style="max-width: 100%; max-height: 70vh;">
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        const bsModal = new bootstrap.Modal(modal);
        bsModal.show();
        
        modal.addEventListener('hidden.bs.modal', () => {
            document.body.removeChild(modal);
        });
    }
}

// Remove image
function removeImage(imageId) {
    uploadedImages = uploadedImages.filter(img => img.id != imageId);
    
    // Remove from DOM
    const previewItems = document.querySelectorAll('.image-preview-item');
    previewItems.forEach(item => {
        const viewBtn = item.querySelector('.view');
        if (viewBtn && viewBtn.onclick.toString().includes(imageId)) {
            item.remove();
        }
    });
    
    updateUploadArea();
}

// Show feedback section
function showFeedbackSection(sectionName) {
    // Hide all sections
    document.querySelectorAll('.feedback-section').forEach(section => {
        section.classList.remove('active');
    });
    
    // Remove active class from all menu items
    document.querySelectorAll('.feedback-menu-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // Show selected section
    const selectedSection = document.getElementById(`${sectionName}-section`);
    if (selectedSection) {
        selectedSection.classList.add('active');
    }
    
    // Add active class to menu item
    const activeMenuItem = document.querySelector(`[onclick="showFeedbackSection('${sectionName}')"]`);
    if (activeMenuItem) {
        activeMenuItem.classList.add('active');
    }
    
    // Update title
    updateFeedbackTitle(sectionName);
    
    // Update current section
    currentFeedbackSection = sectionName;
    
    // Scroll to top
    document.querySelector('.feedback-content').scrollTop = 0;
}

// Update feedback title
function updateFeedbackTitle(sectionName) {
    const titleMap = {
        'feedback-form': 'نموذج الملاحظات',
        'my-feedback': 'ملاحظاتي السابقة',
        'contact-info': 'معلومات التواصل'
    };
    
    const titleElement = document.getElementById('feedbackTitle');
    if (titleElement) {
        titleElement.textContent = titleMap[sectionName] || 'إرسال الملاحظات';
    }
}

// Toggle sidebar
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const mainFeedback = document.querySelector('.main-feedback');
    
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
            mainFeedback.classList.remove('sidebar-collapsed');
        } else {
            sidebar.classList.add('collapsed');
            mainFeedback.classList.add('sidebar-collapsed');
        }
    }
}

// Setup sidebar resizer
function setupSidebarResizer() {
    const resizer = document.getElementById('sidebarResizer');
    const sidebar = document.getElementById('sidebar');
    const mainFeedback = document.querySelector('.main-feedback');
    
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
            mainFeedback.style.marginRight = width + 'px';
        }
    }
    
    function handleMouseUp() {
        isResizing = false;
        document.removeEventListener('mousemove', handleMouseMove);
        document.removeEventListener('mouseup', handleMouseUp);
    }
}

// Submit feedback
function submitFeedback(event) {
    event.preventDefault();
    
    const formData = {
        id: Date.now(),
        name: document.getElementById('feedbackName').value,
        email: document.getElementById('feedbackEmail').value,
        type: document.getElementById('feedbackType').value,
        priority: document.getElementById('feedbackPriority').value,
        subject: document.getElementById('feedbackSubject').value,
        message: document.getElementById('feedbackMessage').value,
        images: uploadedImages,
        browser: document.getElementById('feedbackBrowser').value,
        device: document.getElementById('feedbackDevice').value,
        status: 'pending',
        timestamp: new Date().toISOString(),
        consent: document.getElementById('feedbackConsent').checked
    };
    
    // Validate form
    if (!formData.name || !formData.email || !formData.type || !formData.subject || !formData.message) {
        showAlert('يرجى ملء جميع الحقول المطلوبة', 'danger');
        return;
    }
    
    if (!formData.consent) {
        showAlert('يجب الموافقة على مشاركة المعلومات', 'danger');
        return;
    }
    
    // Add to history
    feedbackHistory.unshift(formData);
    saveFeedbackHistory();
    
    // Clear form
    clearForm();
    
    // Show success message
    showAlert('تم إرسال ملاحظتك بنجاح! سنقوم بالرد عليك في أقرب وقت ممكن.', 'success');
    
    // Switch to history section
    setTimeout(() => {
        showFeedbackSection('my-feedback');
    }, 2000);
}

// Save draft
function saveDraft() {
    const draft = {
        name: document.getElementById('feedbackName').value,
        email: document.getElementById('feedbackEmail').value,
        type: document.getElementById('feedbackType').value,
        priority: document.getElementById('feedbackPriority').value,
        subject: document.getElementById('feedbackSubject').value,
        message: document.getElementById('feedbackMessage').value,
        images: uploadedImages,
        timestamp: new Date().toISOString()
    };
    
    localStorage.setItem('feedbackDraft', JSON.stringify(draft));
    showAlert('تم حفظ المسودة بنجاح', 'info');
}

// Auto-save draft
function autoSaveDraft() {
    // Debounce auto-save
    clearTimeout(window.autoSaveTimeout);
    window.autoSaveTimeout = setTimeout(() => {
        saveDraft();
    }, 2000);
}

// Load draft
function loadDraft() {
    const draft = localStorage.getItem('feedbackDraft');
    if (draft) {
        try {
            const draftData = JSON.parse(draft);
            
            document.getElementById('feedbackName').value = draftData.name || '';
            document.getElementById('feedbackEmail').value = draftData.email || '';
            document.getElementById('feedbackType').value = draftData.type || '';
            document.getElementById('feedbackPriority').value = draftData.priority || 'medium';
            document.getElementById('feedbackSubject').value = draftData.subject || '';
            document.getElementById('feedbackMessage').value = draftData.message || '';
            
            if (draftData.images) {
                uploadedImages = draftData.images;
                uploadedImages.forEach(image => {
                    displayImagePreview(image);
                });
                updateUploadArea();
            }
        } catch (error) {
            console.error('خطأ في تحميل المسودة:', error);
        }
    }
}

// Clear form
function clearForm() {
    document.getElementById('feedbackForm').reset();
    uploadedImages = [];
    
    // Clear image previews
    const imagePreviewContainer = document.getElementById('imagePreviewContainer');
    if (imagePreviewContainer) {
        imagePreviewContainer.innerHTML = '';
    }
    
    updateUploadArea();
    
    // Remove draft
    localStorage.removeItem('feedbackDraft');
}

// Load feedback history
function loadFeedbackHistory() {
    const history = localStorage.getItem('feedbackHistory');
    if (history) {
        try {
            feedbackHistory = JSON.parse(history);
        } catch (error) {
            console.error('خطأ في تحميل تاريخ الملاحظات:', error);
            feedbackHistory = [];
        }
    }
    
    displayFeedbackHistory();
}

// Save feedback history
function saveFeedbackHistory() {
    localStorage.setItem('feedbackHistory', JSON.stringify(feedbackHistory));
}

// Display feedback history
function displayFeedbackHistory() {
    const feedbackList = document.getElementById('feedbackList');
    const feedbackEmpty = document.getElementById('feedbackEmpty');
    
    if (!feedbackList || !feedbackEmpty) return;
    
    if (feedbackHistory.length === 0) {
        feedbackList.style.display = 'none';
        feedbackEmpty.style.display = 'block';
        return;
    }
    
    feedbackList.style.display = 'block';
    feedbackEmpty.style.display = 'none';
    
    feedbackList.innerHTML = '';
    
    feedbackHistory.forEach(feedback => {
        const feedbackItem = createFeedbackItem(feedback);
        feedbackList.appendChild(feedbackItem);
    });
}

// Create feedback item
function createFeedbackItem(feedback) {
    const item = document.createElement('div');
    item.className = 'feedback-item';
    
    const typeText = {
        'bug': 'خطأ',
        'feature': 'ميزة جديدة',
        'improvement': 'تحسين',
        'complaint': 'شكوى',
        'compliment': 'إشادة',
        'other': 'أخرى'
    };
    
    const statusText = {
        'pending': 'في الانتظار',
        'in-progress': 'قيد المعالجة',
        'resolved': 'تم الحل',
        'closed': 'مغلق'
    };
    
    const priorityText = {
        'low': 'منخفضة',
        'medium': 'متوسطة',
        'high': 'عالية',
        'urgent': 'عاجلة'
    };
    
    const imagesHtml = feedback.images && feedback.images.length > 0 
        ? `<div class="feedback-item-images">
            ${feedback.images.map(img => `
                <img src="${img.data}" alt="${img.name}" class="feedback-item-image" onclick="viewImage('${img.id}')">
            `).join('')}
           </div>`
        : '';
    
    item.innerHTML = `
        <div class="feedback-item-header">
            <div>
                <h6 class="feedback-item-title">${feedback.subject}</h6>
                <div class="feedback-item-meta">
                    <span class="feedback-item-type ${feedback.type}">${typeText[feedback.type]}</span>
                    <span class="feedback-item-status ${feedback.status}">${statusText[feedback.status]}</span>
                    <span>الأولوية: ${priorityText[feedback.priority]}</span>
                </div>
            </div>
        </div>
        <div class="feedback-item-content">${feedback.message}</div>
        ${imagesHtml}
        <div class="feedback-item-footer">
            <span>${new Date(feedback.timestamp).toLocaleDateString('ar-SA')}</span>
            <span>${feedback.browser} - ${feedback.device}</span>
        </div>
    `;
    
    return item;
}

// Filter feedback history
function filterFeedbackHistory() {
    const statusFilter = document.getElementById('statusFilter').value;
    const typeFilter = document.getElementById('typeFilter').value;
    
    const filteredHistory = feedbackHistory.filter(feedback => {
        const statusMatch = !statusFilter || feedback.status === statusFilter;
        const typeMatch = !typeFilter || feedback.type === typeFilter;
        return statusMatch && typeMatch;
    });
    
    displayFilteredFeedback(filteredHistory);
}

// Display filtered feedback
function displayFilteredFeedback(filteredHistory) {
    const feedbackList = document.getElementById('feedbackList');
    const feedbackEmpty = document.getElementById('feedbackEmpty');
    
    if (!feedbackList || !feedbackEmpty) return;
    
    if (filteredHistory.length === 0) {
        feedbackList.style.display = 'none';
        feedbackEmpty.style.display = 'block';
        feedbackEmpty.querySelector('h6').textContent = 'لا توجد نتائج';
        feedbackEmpty.querySelector('p').textContent = 'جرب تغيير الفلاتر';
        return;
    }
    
    feedbackList.style.display = 'block';
    feedbackEmpty.style.display = 'none';
    
    feedbackList.innerHTML = '';
    
    filteredHistory.forEach(feedback => {
        const feedbackItem = createFeedbackItem(feedback);
        feedbackList.appendChild(feedbackItem);
    });
}

// Refresh feedback history
function refreshFeedbackHistory() {
    loadFeedbackHistory();
    showAlert('تم تحديث قائمة الملاحظات', 'info');
}

// Detect browser info
function detectBrowserInfo() {
    const browserInfo = getBrowserInfo();
    const deviceInfo = getDeviceInfo();
    
    document.getElementById('feedbackBrowser').value = browserInfo;
    document.getElementById('feedbackDevice').value = deviceInfo;
}

// Get browser info
function getBrowserInfo() {
    const userAgent = navigator.userAgent;
    let browser = 'متصفح غير معروف';
    
    if (userAgent.includes('Chrome')) browser = 'Chrome';
    else if (userAgent.includes('Firefox')) browser = 'Firefox';
    else if (userAgent.includes('Safari')) browser = 'Safari';
    else if (userAgent.includes('Edge')) browser = 'Edge';
    else if (userAgent.includes('Opera')) browser = 'Opera';
    
    return browser;
}

// Get device info
function getDeviceInfo() {
    const userAgent = navigator.userAgent;
    let device = 'حاسوب';
    
    if (/Android/i.test(userAgent)) device = 'Android';
    else if (/iPhone|iPad|iPod/i.test(userAgent)) device = 'iOS';
    else if (/Windows Phone/i.test(userAgent)) device = 'Windows Phone';
    
    return device;
}

// Show alert
function showAlert(message, type = 'info') {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create new alert
    const alert = document.createElement('div');
    alert.className = `alert alert-${type} alert-dismissible fade show`;
    alert.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Insert at the top of the content
    const content = document.querySelector('.feedback-content');
    if (content) {
        content.insertBefore(alert, content.firstChild);
        
        // Auto-dismiss after 5 seconds
        setTimeout(() => {
            if (alert.parentNode) {
                alert.remove();
            }
        }, 5000);
    }
}

// User profile functions moved to user-profile.js

// loadUserInfo function moved to user-profile.js

// Handle window resize
window.addEventListener('resize', function() {
    // Adjust layout for mobile
    if (window.innerWidth <= 768) {
        const sidebar = document.getElementById('sidebar');
        const mainFeedback = document.querySelector('.main-feedback');
        
        if (sidebar && !sidebar.classList.contains('collapsed')) {
            sidebar.classList.add('collapsed');
            mainFeedback.classList.add('sidebar-collapsed');
        }
    }
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + S for save draft
    if ((e.ctrlKey || e.metaKey) && e.key === 's') {
        e.preventDefault();
        saveDraft();
    }
    
    // Escape to close dropdowns
    if (e.key === 'Escape') {
        closeUserDropdown();
    }
});

// Export functions for global access
window.showFeedbackSection = showFeedbackSection;
window.toggleSidebar = toggleSidebar;
window.submitFeedback = submitFeedback;
window.saveDraft = saveDraft;
window.clearForm = clearForm;
window.refreshFeedbackHistory = refreshFeedbackHistory;
window.viewImage = viewImage;
window.removeImage = removeImage;
// User profile functions are now available through user-profile.js
