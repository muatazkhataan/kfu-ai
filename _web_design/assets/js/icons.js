/**
 * نظام الأيقونات المركزي - مساعد كفو
 * يحتوي على 100 أيقونة تعليمية منظمة في فئات
 */

// مصفوفة الأيقونات المركزية
const ICONS_DATA = {
    // البرمجة والتقنية (20 أيقونة)
    programming: [
        { class: 'fa-duotone fa-light fa-code', name: 'برمجة', emoji: '💻' },
        { class: 'fa-duotone fa-light fa-laptop-code', name: 'تطوير', emoji: '💻' },
        { class: 'fa-duotone fa-light fa-terminal', name: 'سطر أوامر', emoji: '⌨️' },
        { class: 'fa-duotone fa-light fa-bug', name: 'تصحيح أخطاء', emoji: '🐛' },
        { class: 'fa-duotone fa-light fa-cogs', name: 'إعدادات', emoji: '⚙️' },
        { class: 'fa-duotone fa-light fa-microchip', name: 'معالجات', emoji: '🖥️' },
        { class: 'fa-duotone fa-light fa-server', name: 'خوادم', emoji: '🖥️' },
        { class: 'fa-duotone fa-light fa-network-wired', name: 'شبكات', emoji: '🌐' },
        { class: 'fa-duotone fa-light fa-shield-alt', name: 'أمان', emoji: '🔒' },
        { class: 'fa-duotone fa-light fa-key', name: 'مفاتيح', emoji: '🔑' },
        { class: 'fa-duotone fa-light fa-database', name: 'قاعدة بيانات', emoji: '🗄️' },
        { class: 'fa-duotone fa-light fa-table', name: 'جداول', emoji: '📊' },
        { class: 'fa-duotone fa-light fa-chart-bar', name: 'رسوم بيانية', emoji: '📈' },
        { class: 'fa-duotone fa-light fa-mobile-alt', name: 'تطبيقات', emoji: '📱' },
        { class: 'fa-duotone fa-light fa-globe', name: 'ويب', emoji: '🌍' },
        { class: 'fa-duotone fa-light fa-cloud', name: 'سحابة', emoji: '☁️' },
        { class: 'fa-duotone fa-light fa-robot', name: 'ذكاء اصطناعي', emoji: '🤖' },
        { class: 'fa-duotone fa-light fa-brain', name: 'خوارزميات', emoji: '🧠' },
        { class: 'fa-duotone fa-light fa-sitemap', name: 'هياكل بيانات', emoji: '🔗' },
        { class: 'fa-duotone fa-light fa-project-diagram', name: 'مخططات', emoji: '📋' },
        { class: 'fa-duotone fa-light fa-file-code', name: 'ملفات كود', emoji: '📄' },
        { class: 'fa-duotone fa-light fa-code-branch', name: 'فروع الكود', emoji: '🌿' },
        { class: 'fa-duotone fa-light fa-code-merge', name: 'الإصدارات', emoji: '📚' },
        { class: 'fa-duotone fa-light fa-code-compare', name: 'مقارنة الكود', emoji: '📚' },
    ], 
    // الرياضيات والإحصائيات (20 أيقونة)
    mathematics: [
        { class: 'fa-duotone fa-light fa-calculator', name: 'حاسبة', emoji: '🧮' },
        { class: 'fa-duotone fa-light fa-square-root-alt', name: 'جذر تربيعي', emoji: '√' },
        { class: 'fa-duotone fa-light fa-infinity', name: 'لانهاية', emoji: '∞' },
        { class: 'fa-duotone fa-light fa-percentage', name: 'نسب مئوية', emoji: '%' },
        { class: 'fa-duotone fa-light fa-chart-line', name: 'إحصائيات', emoji: '📈' },
        { class: 'fa-duotone fa-light fa-chart-pie', name: 'رسوم دائرية', emoji: '🥧' },
        { class: 'fa-duotone fa-light fa-chart-area', name: 'مناطق', emoji: '📊' },
        { class: 'fa-duotone fa-light fa-sort-numeric-up', name: 'ترتيب رقمي', emoji: '🔢' },
        { class: 'fa-duotone fa-light fa-sort-numeric-down', name: 'ترتيب عكسي', emoji: '🔢' },
        { class: 'fa-duotone fa-light fa-equals', name: 'مساواة', emoji: '=' },
        { class: 'fa-duotone fa-light fa-plus', name: 'جمع', emoji: '+' },
        { class: 'fa-duotone fa-light fa-minus', name: 'طرح', emoji: '-' },
        { class: 'fa-duotone fa-light fa-times', name: 'ضرب', emoji: '×' },
        { class: 'fa-duotone fa-light fa-divide', name: 'قسمة', emoji: '÷' },
        { class: 'fa-duotone fa-light fa-superscript', name: 'أس', emoji: 'ⁿ' },
        { class: 'fa-duotone fa-light fa-subscript', name: 'أس سفلي', emoji: 'ₙ' },
        { class: 'fa-duotone fa-light fa-sigma', name: 'سيجما', emoji: 'Σ' },
        { class: 'fa-duotone fa-light fa-pi', name: 'باي', emoji: 'π' },
        { class: 'fa-duotone fa-light fa-function', name: 'دالة', emoji: 'ƒ' },
        { class: 'fa-duotone fa-light fa-integral', name: 'تكامل', emoji: '∫' },
        { class: 'fa-duotone fa-light fa-triangle', name: 'دلتا', emoji: 'Δ' },
        { class: 'fa-duotone fa-light fa-omega', name: 'أوميغا', emoji: 'Ω' },
        { class: 'fa-duotone fa-light fa-theta', name: 'ثيتا', emoji: 'θ' }
    ],

    // العلوم والكيمياء (20 أيقونة)
    science: [
        { class: 'fa-duotone fa-light fa-atom', name: 'ذرة', emoji: '⚛️' },
        { class: 'fa-duotone fa-light fa-flask', name: 'مختبر', emoji: '🧪' },
        { class: 'fa-duotone fa-light fa-microscope', name: 'ميكروسكوب', emoji: '🔬' },
        { class: 'fa-duotone fa-light fa-dna', name: 'حمض نووي', emoji: '🧬' },
        { class: 'fa-duotone fa-light fa-leaf', name: 'بيولوجيا', emoji: '🌿' },
        { class: 'fa-duotone fa-light fa-seedling', name: 'نباتات', emoji: '🌱' },
        { class: 'fa-duotone fa-light fa-droplet', name: 'سوائل', emoji: '💧' },
        { class: 'fa-duotone fa-light fa-fire', name: 'كيمياء', emoji: '🔥' },
        { class: 'fa-duotone fa-light fa-bolt', name: 'كهرباء', emoji: '⚡' },
        { class: 'fa-duotone fa-light fa-magnet', name: 'مغناطيسية', emoji: '🧲' },
        { class: 'fa-duotone fa-light fa-satellite', name: 'فضاء', emoji: '🛰️' },
        { class: 'fa-duotone fa-light fa-rocket', name: 'صواريخ', emoji: '🚀' },
        { class: 'fa-duotone fa-light fa-sun', name: 'فيزياء', emoji: '☀️' },
        { class: 'fa-duotone fa-light fa-moon', name: 'فلك', emoji: '🌙' },
        { class: 'fa-duotone fa-light fa-star', name: 'نجوم', emoji: '⭐' },
        { class: 'fa-duotone fa-light fa-telescope', name: 'تلسكوب', emoji: '🔭' },
        { class: 'fa-duotone fa-light fa-vial', name: 'أنبوب اختبار', emoji: '🧪' },
        { class: 'fa-duotone fa-light fa-pills', name: 'أدوية', emoji: '💊' },
        { class: 'fa-duotone fa-light fa-stethoscope', name: 'سماعة طبية', emoji: '🩺' },
        { class: 'fa-duotone fa-light fa-heartbeat', name: 'نبض', emoji: '💓' },
        { class: 'fa-duotone fa-light fa-brain', name: 'دماغ', emoji: '🧠' },
        { class: 'fa-duotone fa-light fa-eye', name: 'عين', emoji: '👁️' },
        { class: 'fa-duotone fa-light fa-ear', name: 'أذن', emoji: '👂' }
    ],

    // الدراسة والأكاديمية (20 أيقونة)
    study: [
        { class: 'fa-duotone fa-light fa-graduation-cap', name: 'أكاديمي', emoji: '🎓' },
        { class: 'fa-duotone fa-light fa-book', name: 'كتاب', emoji: '📚' },
        { class: 'fa-duotone fa-light fa-book-open', name: 'كتاب مفتوح', emoji: '📖' },
        { class: 'fa-duotone fa-light fa-pen', name: 'قلم', emoji: '✒️' },
        { class: 'fa-duotone fa-light fa-pencil-alt', name: 'قلم رصاص', emoji: '✏️' },
        { class: 'fa-duotone fa-light fa-highlighter', name: 'قلم تمييز', emoji: '🖍️' },
        { class: 'fa-duotone fa-light fa-sticky-note', name: 'ملاحظات', emoji: '📝' },
        { class: 'fa-duotone fa-light fa-clipboard', name: 'لوحة', emoji: '📋' },
        { class: 'fa-duotone fa-light fa-file-alt', name: 'ملف', emoji: '📄' },
        { class: 'fa-duotone fa-light fa-folder', name: 'مجلد', emoji: '📁' },
        { class: 'fa-duotone fa-light fa-archive', name: 'أرشيف', emoji: '📦' },
        { class: 'fa-duotone fa-light fa-calendar-alt', name: 'تقويم', emoji: '📅' },
        { class: 'fa-duotone fa-light fa-clock', name: 'وقت', emoji: '⏰' },
        { class: 'fa-duotone fa-light fa-stopwatch', name: 'ساعة إيقاف', emoji: '⏱️' },
        { class: 'fa-duotone fa-light fa-hourglass-half', name: 'ساعة رملية', emoji: '⏳' },
        { class: 'fa-duotone fa-light fa-bell', name: 'تنبيهات', emoji: '🔔' },
        { class: 'fa-duotone fa-light fa-flag', name: 'أهداف', emoji: '🎯' },
        { class: 'fa-duotone fa-light fa-trophy', name: 'إنجازات', emoji: '🏆' },
        { class: 'fa-duotone fa-light fa-medal', name: 'ميداليات', emoji: '🥇' },
        { class: 'fa-duotone fa-light fa-certificate', name: 'شهادات', emoji: '📜' },
        { class: 'fa-duotone fa-light fa-award', name: 'جوائز', emoji: '🏅' },
        { class: 'fa-duotone fa-light fa-user-graduate', name: 'خريج', emoji: '🎓' },
        { class: 'fa-duotone fa-light fa-chalkboard-teacher', name: 'معلم', emoji: '👨‍🏫' },
        { class: 'fa-duotone fa-light fa-chalkboard', name: 'سبورة', emoji: '📝' },
        { class: 'fa-duotone fa-light fa-search', name: 'بحث', emoji: '🔍' },
        { class: 'fa-duotone fa-light fa-question-circle', name: 'أسئلة', emoji: '❓' },
        { class: 'fa-duotone fa-light fa-lightbulb', name: 'أفكار', emoji: '💡' }
    ],

    // الإبداع والتصميم (20 أيقونة)
    creativity: [
        { class: 'fa-duotone fa-light fa-palette', name: 'تصميم', emoji: '🎨' },
        { class: 'fa-duotone fa-light fa-paint-brush', name: 'فرشاة', emoji: '🖌️' },
        { class: 'fa-duotone fa-light fa-lightbulb', name: 'أفكار', emoji: '💡' },
        { class: 'fa-duotone fa-light fa-magic', name: 'سحر', emoji: '✨' },
        { class: 'fa-duotone fa-light fa-sparkles', name: 'تألق', emoji: '✨' },
        { class: 'fa-duotone fa-light fa-eye', name: 'رؤية', emoji: '👁️' },
        { class: 'fa-duotone fa-light fa-eye-dropper', name: 'قطارة', emoji: '👁️' },
        { class: 'fa-duotone fa-light fa-camera', name: 'كاميرا', emoji: '📷' },
        { class: 'fa-duotone fa-light fa-video', name: 'فيديو', emoji: '🎥' },
        { class: 'fa-duotone fa-light fa-music', name: 'موسيقى', emoji: '🎵' },
        { class: 'fa-duotone fa-light fa-headphones', name: 'سماعات', emoji: '🎧' },
        { class: 'fa-duotone fa-light fa-gamepad', name: 'ألعاب', emoji: '🎮' },
        { class: 'fa-duotone fa-light fa-dice', name: 'احتمالات', emoji: '🎲' },
        { class: 'fa-duotone fa-light fa-puzzle-piece', name: 'ألغاز', emoji: '🧩' },
        { class: 'fa-duotone fa-light fa-cube', name: 'ثلاثي الأبعاد', emoji: '🧊' },
        { class: 'fa-duotone fa-light fa-star', name: 'نجمة', emoji: '⭐' },
        { class: 'fa-duotone fa-light fa-heart', name: 'قلب', emoji: '❤️' },
        { class: 'fa-duotone fa-light fa-gem', name: 'جوهرة', emoji: '💎' },
        { class: 'fa-duotone fa-light fa-crown', name: 'تاج', emoji: '👑' },
        { class: 'fa-duotone fa-light fa-trophy', name: 'كأس', emoji: '🏆' },
        { class: 'fa-duotone fa-light fa-medal', name: 'ميدالية', emoji: '🥇' },
        { class: 'fa-duotone fa-light fa-award', name: 'جائزة', emoji: '🏅' },
        { class: 'fa-duotone fa-light fa-certificate', name: 'شهادة', emoji: '📜' },
        { class: 'fa-duotone fa-light fa-ribbon', name: 'شريط', emoji: '🎗️' },
        { class: 'fa-duotone fa-light fa-flag', name: 'علم', emoji: '🏁' }
    ],

    // العمل الجماعي والتواصل (20 أيقونة)
    collaboration: [
        { class: 'fa-duotone fa-light fa-users', name: 'فريق', emoji: '👥' },
        { class: 'fa-duotone fa-light fa-user-friends', name: 'أصدقاء', emoji: '👫' },
        { class: 'fa-duotone fa-light fa-handshake', name: 'تعاون', emoji: '🤝' },
        { class: 'fa-duotone fa-light fa-comments', name: 'محادثات', emoji: '💬' },
        { class: 'fa-duotone fa-light fa-comment-dots', name: 'رسائل', emoji: '💭' },
        { class: 'fa-duotone fa-light fa-envelope', name: 'بريد', emoji: '✉️' },
        { class: 'fa-duotone fa-light fa-phone', name: 'هاتف', emoji: '📞' },
        { class: 'fa-duotone fa-light fa-video-camera', name: 'مكالمة فيديو', emoji: '📹' },
        { class: 'fa-duotone fa-light fa-share-alt', name: 'مشاركة', emoji: '📤' },
        { class: 'fa-duotone fa-light fa-link', name: 'روابط', emoji: '🔗' },
        { class: 'fa-duotone fa-light fa-sync', name: 'تحديث', emoji: '🔄' },
        { class: 'fa-duotone fa-light fa-download', name: 'تحميل', emoji: '⬇️' },
        { class: 'fa-duotone fa-light fa-upload', name: 'رفع', emoji: '⬆️' },
        { class: 'fa-duotone fa-light fa-print', name: 'طباعة', emoji: '🖨️' },
        { class: 'fa-duotone fa-light fa-copy', name: 'نسخ', emoji: '📋' },
        { class: 'fa-duotone fa-light fa-paper-plane', name: 'طائرة ورقية', emoji: '✈️' },
        { class: 'fa-duotone fa-light fa-inbox', name: 'صندوق وارد', emoji: '📥' },
        { class: 'fa-duotone fa-light fa-send', name: 'إرسال', emoji: '📤' },
        { class: 'fa-duotone fa-light fa-bell', name: 'جرس', emoji: '🔔' },
        { class: 'fa-duotone fa-light fa-bell-slash', name: 'جرس مكتوم', emoji: '🔕' },
        { class: 'fa-duotone fa-light fa-calendar-alt', name: 'تقويم', emoji: '📅' },
        { class: 'fa-duotone fa-light fa-clock', name: 'ساعة', emoji: '⏰' },
        { class: 'fa-duotone fa-light fa-stopwatch', name: 'ساعة إيقاف', emoji: '⏱️' },
        { class: 'fa-duotone fa-light fa-hourglass-half', name: 'ساعة رملية', emoji: '⏳' }
    ]
};

// دالة الحصول على جميع الأيقونات
function getAllIcons() {
    const allIcons = [];
    Object.values(ICONS_DATA).forEach(category => {
        allIcons.push(...category);
    });
    return allIcons;
}

// دالة الحصول على أيقونات فئة معينة
function getIconsByCategory(category) {
    return ICONS_DATA[category] || [];
}

// دالة البحث في الأيقونات
function searchIcons(query) {
    const allIcons = getAllIcons();
    const searchTerm = query.toLowerCase();
    
    return allIcons.filter(icon => 
        icon.name.toLowerCase().includes(searchTerm) ||
        icon.class.toLowerCase().includes(searchTerm) ||
        icon.emoji.includes(searchTerm)
    );
}

// دالة الحصول على أيقونات عشوائية
function getRandomIcons(count = 10) {
    const allIcons = getAllIcons();
    const shuffled = allIcons.sort(() => 0.5 - Math.random());
    return shuffled.slice(0, count);
}

// دالة الحصول على أيقونات شائعة الاستخدام
function getPopularIcons() {
    return [
        { class: 'fa-duotone fa-light fa-folder', name: 'مجلد عادي', emoji: '📁' },
        { class: 'fa-duotone fa-light fa-code', name: 'برمجة', emoji: '💻' },
        { class: 'fa-duotone fa-light fa-database', name: 'قاعدة بيانات', emoji: '🗄️' },
        { class: 'fa-duotone fa-light fa-brain', name: 'خوارزميات', emoji: '🧠' },
        { class: 'fa-duotone fa-light fa-sitemap', name: 'هياكل بيانات', emoji: '🔗' },
        { class: 'fa-duotone fa-light fa-graduation-cap', name: 'أكاديمي', emoji: '🎓' },
        { class: 'fa-duotone fa-light fa-book', name: 'دراسة', emoji: '📚' },
        { class: 'fa-duotone fa-light fa-lightbulb', name: 'أفكار', emoji: '💡' },
        { class: 'fa-duotone fa-light fa-star', name: 'مهم', emoji: '⭐' },
        { class: 'fa-duotone fa-light fa-heart', name: 'مفضل', emoji: '❤️' }
    ];
}

// دالة الحصول على أيقونة عشوائية
function getRandomIcon() {
    const allIcons = getAllIcons();
    return allIcons[Math.floor(Math.random() * allIcons.length)];
}

// دالة الحصول على أيقونات مفضلة (الأكثر استخداماً)
function getFavoriteIcons() {
    return [
        { class: 'fa-duotone fa-light fa-folder', name: 'مجلد عادي', emoji: '📁' },
        { class: 'fa-duotone fa-light fa-code', name: 'برمجة', emoji: '💻' },
        { class: 'fa-duotone fa-light fa-database', name: 'قاعدة بيانات', emoji: '🗄️' },
        { class: 'fa-duotone fa-light fa-brain', name: 'خوارزميات', emoji: '🧠' },
        { class: 'fa-duotone fa-light fa-sitemap', name: 'هياكل بيانات', emoji: '🔗' },
        { class: 'fa-duotone fa-light fa-graduation-cap', name: 'أكاديمي', emoji: '🎓' },
        { class: 'fa-duotone fa-light fa-book', name: 'دراسة', emoji: '📚' },
        { class: 'fa-duotone fa-light fa-lightbulb', name: 'أفكار', emoji: '💡' },
        { class: 'fa-duotone fa-light fa-star', name: 'مهم', emoji: '⭐' },
        { class: 'fa-duotone fa-light fa-heart', name: 'مفضل', emoji: '❤️' },
        { class: 'fa-duotone fa-light fa-fire', name: 'عاجل', emoji: '🔥' },
        { class: 'fa-duotone fa-light fa-rocket', name: 'مشاريع', emoji: '🚀' },
        { class: 'fa-duotone fa-light fa-palette', name: 'تصميم', emoji: '🎨' },
        { class: 'fa-duotone fa-light fa-chart-line', name: 'إحصائيات', emoji: '📈' },
        { class: 'fa-duotone fa-light fa-users', name: 'فريق', emoji: '👥' },
        { class: 'fa-duotone fa-light fa-calculator', name: 'رياضيات', emoji: '🧮' },
        { class: 'fa-duotone fa-light fa-flask', name: 'تجارب', emoji: '🧪' },
        { class: 'fa-duotone fa-light fa-pencil-alt', name: 'كتابة', emoji: '✏️' },
        { class: 'fa-duotone fa-light fa-search', name: 'بحث', emoji: '🔍' },
        { class: 'fa-duotone fa-light fa-clock', name: 'مواعيد', emoji: '⏰' },
        { class: 'fa-duotone fa-light fa-archive', name: 'أرشيف', emoji: '📦' },
        { class: 'fa-duotone fa-light fa-inbox', name: 'جميع المحادثات', emoji: '📥' }
    ];
}

// دالة إنشاء HTML للأيقونة
function createIconHTML(icon, onClick = null) {
    const clickHandler = onClick ? `onclick="${onClick}"` : '';
    return `
        <div class="icon-item" ${clickHandler}>
            <i class="${icon.class}"></i>
            <span>${icon.name}</span>
        </div>
    `;
}

// دالة إنشاء قائمة الأيقونات كاملة
function createFullIconGrid(folderId) {
    const allIcons = getAllIcons();
    let html = '<div class="icon-grid">';
    
    allIcons.forEach(icon => {
        html += createIconHTML(icon, `changeFolderIcon('${folderId}', '${icon.class}')`);
    });
    
    html += '</div>';
    return html;
}

// دالة إنشاء قائمة الأيقونات المفضلة
function createFavoriteIconGrid(folderId) {
    const favoriteIcons = getFavoriteIcons();
    let html = '<div class="icon-grid">';
    
    favoriteIcons.forEach(icon => {
        html += createIconHTML(icon, `changeFolderIcon('${folderId}', '${icon.class}')`);
    });
    
    html += '</div>';
    return html;
}

// دالة إنشاء قائمة الأيقونات حسب الفئة
function createCategoryIconGrid(folderId, category) {
    const categoryIcons = getIconsByCategory(category);
    let html = '<div class="icon-grid">';
    
    categoryIcons.forEach(icon => {
        html += createIconHTML(icon, `changeFolderIcon('${folderId}', '${icon.class}')`);
    });
    
    html += '</div>';
    return html;
}

// تصدير الدوال للاستخدام في الملفات الأخرى
window.IconSystem = {
    getAllIcons,
    getIconsByCategory,
    searchIcons,
    getRandomIcon,
    getRandomIcons,
    getFavoriteIcons,
    getPopularIcons,
    createIconHTML,
    createFullIconGrid,
    createFavoriteIconGrid,
    createCategoryIconGrid,
    ICONS_DATA
};

// رسالة تأكيد تحميل النظام
console.log('✅ نظام الأيقونات المركزي تم تحميله بنجاح!');
console.log(`📊 تم تحميل ${Object.keys(ICONS_DATA).length} فئة أيقونات`);
console.log(`🎯 إجمالي عدد الأيقونات: ${getAllIcons().length} أيقونة`);

console.log('✅ نظام الأيقونات تم تحميله بنجاح!');
console.log('📊 إجمالي الأيقونات المتاحة:', getAllIcons().length);
console.log('📁 الفئات المتاحة:', Object.keys(ICONS_DATA)); 