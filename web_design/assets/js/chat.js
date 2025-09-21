/**
 * الملف الرئيسي للمحادثة - مساعد كفو
 * يقوم بتحميل وربط جميع الأنظمة الفرعية
 */

// انتظار تحميل الصفحة
document.addEventListener("DOMContentLoaded", function () {
    console.log('🚀 بدء تحميل نظام مساعد كفو...');

    // التحقق من وجود جميع الملفات المطلوبة
    if (!window.IconSystem) {
        console.error('❌ نظام الأيقونات غير متوفر!');
        return;
    }

    if (!window.kfuIconManager) {
        console.error('❌ نظام أيقونة مساعد كفو غير متوفر!');
        return;
    }

    if (!window.folderManager) {
        console.error('❌ نظام إدارة المجلدات غير متوفر!');
        return;
    }

    if (!window.chatManager) {
        console.error('❌ نظام إدارة المحادثات غير متوفر!');
        return;
    }

    if (!window.utils) {
        console.error('❌ نظام الوظائف المساعدة غير متوفر!');
        return;
    }

    // تهيئة النظام الرئيسي
    initializeMainSystem();

    // إظهار رسالة الترحيب
    showWelcomeMessage();

    console.log('✅ تم تحميل جميع الأنظمة بنجاح!');
    console.log('🎨 أيقونة مساعد كفو جاهزة للاستخدام!');
});

/**
 * تهيئة النظام الرئيسي
 */
function initializeMainSystem() {
    // ربط الأحداث العامة
    bindGlobalEvents();

    // تهيئة النافذة المنبثقة
    initializeModal();

    // التركيز على حقل الإدخال
    const chatInput = document.getElementById("chatInput");
    if (chatInput) {
        chatInput.focus();
    }

    console.log('✅ تم تهيئة النظام الرئيسي بنجاح!');
}

/**
 * ربط الأحداث العامة
 */
function bindGlobalEvents() {
    // إغلاق النافذة المنبثقة عند إغلاقها
    document.getElementById('addFolderModal').addEventListener('hidden.bs.modal', function () {
        window.pendingChatForNewFolder = null;
    });

    // إغلاق القوائم المنسدلة عند النقر خارجها
    document.addEventListener("click", function (e) {
        // إغلاق قوائم المحادثات المنسدلة
        if (!e.target.closest('.chat-item-actions')) {
            document.querySelectorAll('.chat-dropdown-menu').forEach(menu => {
                menu.classList.remove('show');
            });
        }

        // إغلاق قوائم المجلدات المنسدلة
        if (!e.target.closest('.folder-actions')) {
            document.querySelectorAll('.folder-dropdown-menu').forEach(menu => {
                menu.classList.remove('show');
            });
        }

        // إغلاق قائمة المستخدم المنسدلة
        if (!e.target.closest('.user-profile-section')) {
            closeUserDropdown();
        }
    });
}

/**
 * تهيئة النافذة المنبثقة
 */
function initializeModal() {
    // تحديث قائمة الأيقونات في النافذة المنبثقة
    const folderIconSelect = document.getElementById('folderIcon');
    if (folderIconSelect && window.IconSystem) {
        const favoriteIcons = window.IconSystem.getFavoriteIcons();

        // مسح الخيارات الحالية
        folderIconSelect.innerHTML = '';

        // إضافة الأيقونات المفضلة
        favoriteIcons.forEach(icon => {
            const option = document.createElement('option');
            option.value = icon.class;
            option.textContent = `${icon.emoji} ${icon.name}`;
            folderIconSelect.appendChild(option);
        });
    }
}

// ===== دوال الواجهة العامة =====

/**
 * بدء محادثة جديدة
 */
function startNewChat() {
    if (window.chatManager) {
        window.chatManager.startNewChat();
    }
}

/**
 * تحميل محادثة
 */
function loadChat(chatId, event) {
    if (window.chatManager) {
        window.chatManager.loadChat(chatId, event);
    }
}

/**
 * إرسال رسالة
 */
function sendMessage() {
    if (window.chatManager) {
        window.chatManager.sendMessage();
    }
}

/**
 * طرح سؤال
 */
function askQuestion(question) {
    if (window.chatManager) {
        window.chatManager.askQuestion(question);
    }
}

/**
 * إرسال اقتراح
 */
function sendSuggestion(suggestion) {
    if (window.chatManager) {
        window.chatManager.sendSuggestion(suggestion);
    }
}

// تم نقل جميع دوال تأثير الكتابة إلى chat-manager.js لتوحيد النظام

/**
 * إغلاق قائمة المستخدم المنسدلة (Footer)
 */
function closeUserDropdown() {
    // استخدام UserProfileManager لإغلاق الفوتر
    if (window.userProfileManager) {
        const footer = document.getElementById('sidebarFooterNew');
        if (footer && footer.classList.contains('show')) {
            window.userProfileManager.toggleFooter();
        }
    }
}

/**
 * إظهار رسالة الترحيب عند تحميل الصفحة
 */
function showWelcomeMessage() {
    // التأكد من أن الصفحة محملة بالكامل
    if (document.readyState === 'complete' && window.chatManager) {
        setTimeout(() => {
            const welcomeMessage = "مرحباً! أنا مساعد كفو، المساعد الذكي لطلبة جامعة الملك فيصل. كيف يمكنني مساعدتك اليوم؟";
            window.chatManager.addMessageWithTyping(welcomeMessage, false, 30);
        }, 1000); // تأخير قصير لضمان تحميل كل شيء
    }
}

/**
 * محاكاة إجابة الذكاء الصناعي مع تأثير الكتابة ودعم HTML
 */
function simulateAIResponse(userMessage) {
    // استخدام chat-manager بدلاً من الدوال المكررة
    if (window.chatManager) {
        // إضافة رسالة المستخدم أولاً
        window.chatManager.addMessage(userMessage, true);

        // محاكاة وقت التفكير
        setTimeout(() => {
            // إجابة مختلفة حسب نوع السؤال مع دعم HTML
            let response = "";

            if (userMessage.includes("برمجة") || userMessage.includes("كود")) {
                response = `أهلاً بك! يمكنني مساعدتك في <strong>البرمجة</strong>. أنا متخصص في لغات البرمجة المختلفة مثل:<br><br>
                • <code>Python</code> - للذكاء الاصطناعي وتحليل البيانات<br>
                • <code>JavaScript</code> - لتطوير الويب والتطبيقات<br>
                • <code>Java</code> - للتطبيقات الكبيرة<br>
                • <code>C++</code> - للبرمجة عالية الأداء<br><br>
                ما هو المشروع الذي تعمل عليه؟ أو هل لديك سؤال محدد في البرمجة؟`;
            } else if (userMessage.includes("رياضيات") || userMessage.includes("حساب")) {
                response = `مرحباً! أنا هنا لمساعدتك في <strong>الرياضيات</strong>. يمكنني مساعدتك في:<br><br>
                📐 <em>الجبر</em> - المعادلات والمتغيرات<br>
                📏 <em>الهندسة</em> - الأشكال والمساحات<br>
                📊 <em>التفاضل والتكامل</em> - النهايات والمشتقات<br>
                🔢 <em>الإحصاء</em> - التحليل والاحتمالات<br><br>
                ما هو الموضوع الرياضي الذي تريد المساعدة فيه؟`;
            } else if (userMessage.includes("امتحان") || userMessage.includes("دراسة")) {
                response = `أفهم أنك تريد المساعدة في <strong>الدراسة والامتحانات</strong>. يمكنني مساعدتك في:<br><br>
                📚 إنشاء خطة دراسية منظمة<br>
                💡 شرح المفاهيم الصعبة<br>
                🎯 نصائح للتحضير للامتحانات<br>
                ⏰ إدارة الوقت بفعالية<br><br>
                ما هو المقرر الذي تريد التركيز عليه؟`;
            } else {
                response = `شكراً لسؤالك! أنا هنا لمساعدتك في جميع <strong>المجالات الأكاديمية</strong>. يمكنني مساعدتك في:<br><br>
                💻 البرمجة والتطوير<br>
                🧮 الرياضيات والعلوم<br>
                📖 الدراسة والامتحانات<br>
                🎓 الشؤون الأكاديمية<br><br>
                هل يمكنك توضيح سؤالك أكثر حتى أتمكن من تقديم أفضل مساعدة ممكنة؟`;
            }

            // إضافة الإجابة مع تأثير الكتابة ودعم HTML باستخدام chat-manager
            window.chatManager.addMessageWithTyping(response, false, 20);
        }, 1000);
    }
}

// تم نقل دالة addUserMessage إلى chat-manager.js لتوحيد النظام

/**
 * فتح مجلد
 */
function openFolder(folderId, event) {
    if (window.folderManager) {
        window.folderManager.openFolder(folderId, event);
    }
}

/**
 * تبديل الشريط الجانبي
 */
function toggleSidebar() {
    if (window.utils) {
        window.utils.toggleSidebar();
    }
}

// ===== دوال إدارة المجلدات =====

/**
 * تبديل القائمة المنسدلة للمجلد
 */
function toggleFolderDropdown(event, folderId) {
    if (window.folderManager) {
        window.folderManager.toggleFolderDropdown(event, folderId);
    }
}

/**
 * إعادة تسمية المجلد
 */
function renameFolder(folderId) {
    if (window.folderManager) {
        window.folderManager.renameFolder(folderId);
    }
}

/**
 * تغيير أيقونة المجلد
 */
function changeFolderIcon(folderId, newIconClass) {
    if (window.folderManager) {
        window.folderManager.changeFolderIcon(folderId, newIconClass);
    }
}

/**
 * حذف المجلد
 */
function deleteFolder(folderId) {
    if (window.folderManager) {
        window.folderManager.deleteFolder(folderId);
    }
}

/**
 * إضافة مجلد جديد
 */
function addNewFolder() {
    if (window.folderManager) {
        window.folderManager.addNewFolder();
    }
}

/**
 * إنشاء مجلد جديد
 */
function createNewFolder() {
    if (window.folderManager) {
        window.folderManager.createNewFolder();
    }
}

/**
 * تبديل القائمة الفرعية للأيقونات
 */
function toggleIconSubmenu(event, folderId) {
    if (window.folderManager) {
        window.folderManager.toggleIconSubmenu(event, folderId);
    }
}

// ===== دوال إدارة المحادثات =====

/**
 * تبديل القائمة المنسدلة للمحادثة
 */
function toggleChatDropdown(event, chatId) {
    if (window.chatManager) {
        window.chatManager.toggleChatDropdown(event, chatId);
    }
}

/**
 * مشاركة عنصر المحادثة
 */
function shareChatItem(chatId) {
    if (window.chatManager) {
        window.chatManager.shareChatItem(chatId);
    }
}

/**
 * إعادة تسمية المحادثة
 */
function renameChat(chatId) {
    if (window.chatManager) {
        window.chatManager.renameChat(chatId);
    }
}

/**
 * إضافة إلى مجلد
 */
function addToFolder(chatId, folderType) {
    if (window.chatManager) {
        window.chatManager.addToFolder(chatId, folderType);
    }
}

/**
 * أرشفة المحادثة
 */
function archiveChat(chatId) {
    if (window.chatManager) {
        window.chatManager.archiveChat(chatId);
    }
}

/**
 * حذف المحادثة
 */
function deleteChat(event, chatId) {
    if (window.chatManager) {
        window.chatManager.deleteChat(event, chatId);
    }
}

// ===== دوال إجراءات المحادثة =====

/**
 * مسح المحادثة
 */
function clearChat() {
    if (window.chatManager) {
        window.chatManager.clearChat();
    }
}

/**
 * تصدير المحادثة
 */
function exportChat() {
    if (window.chatManager) {
        window.chatManager.exportChat();
    }
}

/**
 * مشاركة المحادثة
 */
function shareChat() {
    if (window.chatManager) {
        window.chatManager.shareChat();
    }
}

// ===== دوال إجراءات الإدخال =====

/**
 * إرفاق ملف
 */
function attachFile() {
    if (window.chatManager) {
        window.chatManager.attachFile();
    }
}

/**
 * تسجيل صوتي
 */
function recordVoice() {
    if (window.chatManager) {
        window.chatManager.recordVoice();
    }
}

// ===== دوال إجراءات الرسائل =====

/**
 * نسخ رسالة
 */
function copyMessage(button) {
    if (window.chatManager) {
        window.chatManager.copyMessage(button);
    }
}

/**
 * إعجاب برسالة
 */
function likeMessage(button) {
    if (window.chatManager) {
        window.chatManager.likeMessage(button);
    }
}

// ===== دوال الواجهة =====

/**
 * إظهار الإعدادات
 */
function showSettings() {
    if (window.utils) {
        window.utils.showSettings();
    }
}

/**
 * إظهار المساعدة
 */
function showHelp() {
    if (window.utils) {
        window.utils.showHelp();
    }
}

/**
 * إظهار الملاحظات
 */
function showFeedback() {
    if (window.utils) {
        window.utils.showFeedback();
    }
}

// ===== دوال الاختبار =====

/**
 * اختبار النظام
 */
window.testSystem = function () {
    console.log('🧪 بدء اختبار النظام...');

    // اختبار نظام الأيقونات
    if (window.IconSystem) {
        console.log('✅ نظام الأيقونات:', window.IconSystem.getAllIcons().length, 'أيقونة');
    }

    // اختبار نظام المجلدات
    if (window.folderManager) {
        console.log('✅ نظام المجلدات:', window.folderManager.folders.size, 'مجلد');
    }

    // اختبار نظام المحادثات
    if (window.chatManager) {
        console.log('✅ نظام المحادثات:', window.chatManager.chats.size, 'محادثة');
    }

    // اختبار نظام الوظائف المساعدة
    if (window.utils) {
        window.utils.test();
    }

    console.log('🎉 انتهى اختبار النظام بنجاح!');
};

/**
 * اختبار تغيير الأيقونة
 */
window.testIconChange = function (folderId = 'all') {
    console.log('🧪 اختبار تغيير الأيقونة للمجلد:', folderId);

    if (window.folderManager) {
        const randomIcon = window.IconSystem ? window.IconSystem.getRandomIcon() : null;
        if (randomIcon) {
            window.folderManager.changeFolderIcon(folderId, randomIcon.class);
        } else {
            window.folderManager.changeFolderIcon(folderId, 'fas fa-heart');
        }
    } else {
        alert('نظام إدارة المجلدات غير متوفر!');
    }
};

// ===== معلومات النظام =====

console.log('📋 معلومات النظام:');
console.log('📁 الملفات المطلوبة:');
console.log('  - icons.js (نظام الأيقونات)');
console.log('  - folders.js (إدارة المجلدات)');
console.log('  - chat-manager.js (إدارة المحادثات)');
console.log('  - utils.js (الوظائف المساعدة)');
console.log('  - chat.js (الملف الرئيسي)');

console.log('🔧 دوال الاختبار المتاحة:');
console.log('  - testSystem() - اختبار النظام بالكامل');
console.log('  - testIconChange(folderId) - اختبار تغيير الأيقونة');
console.log('  - utils.test() - اختبار الوظائف المساعدة');

console.log('🎯 النظام جاهز للاستخدام!');

// ===== دوال الملف الشخصي للمستخدم =====
// تم نقل هذه الدوال إلى user-profile.js لتحسين التنظيم والأداء