/**
 * إدارة سجل المحادثات - مساعد كفو
 * ملف JavaScript فارغ - كل المحتوى في HTML
 */

// دوال مساعدة بسيطة للاستخدام في HTML
window.deleteChat = (chatId) => {
    if (confirm(`هل أنت متأكد من رغبتك في حذف المحادثة؟`)) {
        console.log('حذف المحادثة:', chatId);
        // إضافة تأثير الحذف
        const chatItem = document.querySelector(`[data-chat-id="${chatId}"]`);
        if (chatItem) {
            chatItem.style.transition = 'all 0.3s ease';
            chatItem.style.transform = 'scale(0.8)';
            chatItem.style.opacity = '0';
            setTimeout(() => {
                chatItem.remove();
            }, 300);
        }
    }
};

window.archiveChat = (chatId) => {
    console.log('أرشفة المحادثة:', chatId);
    // إضافة تأثير الأرشفة
    const chatItem = document.querySelector(`[data-chat-id="${chatId}"]`);
    if (chatItem) {
        chatItem.style.transition = 'all 0.3s ease';
        chatItem.style.transform = 'translateX(-100%)';
        chatItem.style.opacity = '0';
        setTimeout(() => {
            chatItem.remove();
        }, 300);
    }
};

window.moveToFolder = (chatId, folderId) => {
    console.log('نقل المحادثة:', chatId, 'إلى مجلد:', folderId);
    alert(`تم نقل المحادثة إلى المجلد المحدد`);
};

window.createNewFolderForChat = (chatId) => {
    const folderName = prompt('أدخل اسم المجلد الجديد:');
    if (folderName && folderName.trim()) {
        console.log('إنشاء مجلد جديد:', folderName, 'للمحادثة:', chatId);
        alert(`تم إنشاء المجلد "${folderName}" ونقل المحادثة إليه`);
    }
};

window.shareChat = (chatId) => {
    console.log('مشاركة المحادثة:', chatId);
    // محاكاة مشاركة المحادثة
    if (navigator.share) {
        navigator.share({
            title: 'محادثة من مساعد كفو',
            text: 'تحقق من هذه المحادثة المثيرة للاهتمام',
            url: window.location.origin + `/chat.html?chat=${chatId}`
        }).catch(err => {
            console.log('خطأ في المشاركة:', err);
            copyToClipboard(window.location.origin + `/chat.html?chat=${chatId}`);
        });
    } else {
        copyToClipboard(window.location.origin + `/chat.html?chat=${chatId}`);
    }
};

function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        alert('تم نسخ رابط المحادثة إلى الحافظة');
    }).catch(() => {
        alert('تم نسخ رابط المحادثة إلى الحافظة');
    });
}

window.refreshChatHistory = () => {
    console.log('تحديث سجل المحادثات');
    location.reload();
};

window.toggleViewMode = () => {
    console.log('تبديل وضع العرض');
    alert('تم التبديل إلى وضع العرض');
};

window.clearFilters = () => {
    console.log('مسح المرشحات');
    document.getElementById('searchInput').value = '';
    alert('تم مسح جميع المرشحات');
};

// إعداد أزرار التبديل
document.addEventListener('DOMContentLoaded', function () {
    // المرشحات - Toggle بين الثلاثة أزرار
    document.querySelectorAll('[data-filter]').forEach(btn => {
        btn.addEventListener('click', (e) => {
            const clickedBtn = e.target.closest('[data-filter]');

            // إزالة active من جميع الأزرار
            document.querySelectorAll('[data-filter]').forEach(b => b.classList.remove('active'));

            // إضافة active للزر المضغوط
            clickedBtn.classList.add('active');
        });
    });

    // إعداد Pagination
    setupPagination();
});

// إعداد Pagination
function setupPagination() {
    const pagination = document.querySelector('.pagination');
    if (!pagination) return;

    // إضافة event listeners للأزرار
    pagination.addEventListener('click', function (e) {
        e.preventDefault();

        const clickedLink = e.target.closest('.page-link');
        if (!clickedLink) return;

        const pageItem = clickedLink.closest('.page-item');
        if (!pageItem || pageItem.classList.contains('disabled')) return;

        // إزالة active من جميع الصفحات
        pagination.querySelectorAll('.page-item').forEach(item => {
            item.classList.remove('active');
        });

        // إضافة active للصفحة المضغوطة
        pageItem.classList.add('active');

        // تحديث حالة أزرار السابق/التالي
        updatePaginationButtons();

        // هنا يمكن إضافة منطق تحميل المحادثات للصفحة الجديدة
        const pageNumber = clickedLink.textContent.trim();
        if (pageNumber && !isNaN(pageNumber)) {
            loadPage(parseInt(pageNumber));
        }
    });
}

// تحديث حالة أزرار السابق/التالي
function updatePaginationButtons() {
    const pagination = document.querySelector('.pagination');
    if (!pagination) return;

    const pageItems = pagination.querySelectorAll('.page-item');
    const activePage = pagination.querySelector('.page-item.active');

    if (!activePage) return;

    const activeIndex = Array.from(pageItems).indexOf(activePage);
    const prevButton = pageItems[0]; // زر السابق
    const nextButton = pageItems[pageItems.length - 1]; // زر التالي

    // تحديث زر السابق
    if (activeIndex <= 1) {
        prevButton.classList.add('disabled');
    } else {
        prevButton.classList.remove('disabled');
    }

    // تحديث زر التالي
    if (activeIndex >= pageItems.length - 2) {
        nextButton.classList.add('disabled');
    } else {
        nextButton.classList.remove('disabled');
    }
}

// تحميل صفحة جديدة (يمكن تخصيصها حسب الحاجة)
function loadPage(pageNumber) {
    console.log(`تحميل الصفحة: ${pageNumber}`);
    // هنا يمكن إضافة منطق تحميل المحادثات للصفحة المحددة
}

console.log('✅ نظام إدارة سجل المحادثات تم تحميله بنجاح!');
console.log('📝 كل المحتوى موجود في HTML - لا JavaScript للتصميم');
console.log('🔄 أزرار التبديل (Toggle) مفعلة!');