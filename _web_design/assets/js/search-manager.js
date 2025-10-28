/**
 * Search Manager - إدارة البحث في المحادثات
 */
class SearchManager {
    constructor() {
        this.searchModal = null;
        this.searchInput = null;
        this.clearSearchBtn = null;
        this.recentChatsList = null;
        this.searchResultsList = null;
        this.searchTabs = null;
        this.searchPanels = null;
        this.currentTab = 'recent';
        this.searchTimeout = null;
        this.recentChats = [];
        this.searchResults = [];
        
        this.init();
    }

    init() {
        // تهيئة العناصر
        this.searchModal = new bootstrap.Modal(document.getElementById('searchModal'));
        this.searchInput = document.getElementById('searchInput');
        this.clearSearchBtn = document.getElementById('clearSearchBtn');
        this.recentChatsList = document.getElementById('recentChatsList');
        this.searchResultsList = document.getElementById('searchResultsList');
        this.searchTabs = document.querySelectorAll('.search-tab');
        this.searchPanels = document.querySelectorAll('.search-panel');

        // ربط الأحداث
        this.bindEvents();
        
        // تحميل المحادثات الأخيرة
        this.loadRecentChats();
    }

    bindEvents() {
        // حدث البحث
        this.searchInput.addEventListener('input', (e) => {
            this.handleSearch(e.target.value);
        });

        // زر مسح البحث
        this.clearSearchBtn.addEventListener('click', () => {
            this.clearSearch();
        });

        // تبديل التبويبات
        this.searchTabs.forEach(tab => {
            tab.addEventListener('click', (e) => {
                this.switchTab(e.target.dataset.tab);
            });
        });

        // إغلاق المودال
        document.getElementById('searchModal').addEventListener('hidden.bs.modal', () => {
            this.clearSearch();
        });

        // البحث عند الضغط على Enter
        this.searchInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                this.performSearch();
            }
        });
    }

    // فتح مودال البحث
    openSearchModal() {
        this.searchModal.show();
        // تركيز على صندوق البحث بعد فتح المودال
        setTimeout(() => {
            if (this.searchInput) {
                this.searchInput.focus();
            }
        }, 300);
        this.loadRecentChats();
    }

    // تبديل التبويبات
    switchTab(tabName) {
        // إزالة التفعيل من جميع التبويبات
        this.searchTabs.forEach(tab => {
            tab.classList.remove('active');
        });
        this.searchPanels.forEach(panel => {
            panel.classList.remove('active');
        });

        // تفعيل التبويب المحدد
        document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');
        document.getElementById(`panel-${tabName}`).classList.add('active');
        
        this.currentTab = tabName;

        // إذا كان التبويب "البحث الشامل" وكان هناك نص بحث، قم بالبحث
        if (tabName === 'all' && this.searchInput.value.trim()) {
            this.performSearch();
        }
    }

    // معالجة البحث
    handleSearch(query) {
        // إلغاء البحث السابق
        if (this.searchTimeout) {
            clearTimeout(this.searchTimeout);
        }

        // البحث بعد 300ms من توقف الكتابة
        this.searchTimeout = setTimeout(() => {
            if (query.trim()) {
                this.performSearch();
            } else {
                this.clearSearchResults();
            }
        }, 300);
    }

    // تنفيذ البحث
    async performSearch() {
        const query = this.searchInput.value.trim();
        if (!query) return;

        try {
            // البحث في المحادثات المحلية
            this.searchResults = this.searchLocalChats(query);
            this.displaySearchResults();

            // البحث في الذاكرة (سيتم تطويره لاحقاً)
            // await this.searchInMemory(query);
            
        } catch (error) {
            console.error('خطأ في البحث:', error);
            this.showSearchError('حدث خطأ أثناء البحث');
        }
    }

    // البحث في المحادثات المحلية
    searchLocalChats(query) {
        const results = [];
        const searchTerm = query.toLowerCase();

        // البحث في المحادثات الأخيرة
        this.recentChats.forEach(chat => {
            if (this.matchesSearch(chat, searchTerm)) {
                results.push({
                    ...chat,
                    matchType: 'recent',
                    relevance: this.calculateRelevance(chat, searchTerm)
                });
            }
        });

        // البحث في المجلدات
        const folders = document.querySelectorAll('.folder-item');
        folders.forEach(folder => {
            const folderName = folder.querySelector('.folder-name')?.textContent || '';
            if (folderName.toLowerCase().includes(searchTerm)) {
                results.push({
                    id: folder.id,
                    name: folderName,
                    type: 'folder',
                    matchType: 'folder',
                    relevance: this.calculateRelevance({ name: folderName }, searchTerm)
                });
            }
        });

        // ترتيب النتائج حسب الأهمية
        return results.sort((a, b) => b.relevance - a.relevance);
    }

    // التحقق من تطابق البحث
    matchesSearch(chat, searchTerm) {
        return (
            chat.name?.toLowerCase().includes(searchTerm) ||
            chat.content?.toLowerCase().includes(searchTerm) ||
            chat.folder?.toLowerCase().includes(searchTerm)
        );
    }

    // حساب أهمية النتيجة
    calculateRelevance(item, searchTerm) {
        let relevance = 0;
        const name = item.name?.toLowerCase() || '';
        const content = item.content?.toLowerCase() || '';

        // تطابق في العنوان
        if (name.startsWith(searchTerm)) relevance += 10;
        else if (name.includes(searchTerm)) relevance += 5;

        // تطابق في المحتوى
        if (content.includes(searchTerm)) relevance += 3;

        // تطابق في المجلد
        if (item.folder?.toLowerCase().includes(searchTerm)) relevance += 2;

        return relevance;
    }

    // عرض نتائج البحث
    displaySearchResults() {
        if (this.searchResults.length === 0) {
            this.searchResultsList.innerHTML = `
                <div class="text-center text-muted py-4">
                    <i class="fas fa-search fa-2x mb-3"></i>
                    <p>لم يتم العثور على نتائج</p>
                </div>
            `;
            return;
        }

        const resultsHTML = this.searchResults.map(result => {
            if (result.type === 'folder') {
                return this.createFolderResultHTML(result);
            } else {
                return this.createChatResultHTML(result);
            }
        }).join('');

        this.searchResultsList.innerHTML = resultsHTML;
    }

    // إنشاء HTML لنتيجة مجلد
    createFolderResultHTML(folder) {
        return `
            <div class="search-result-item folder-result" data-folder-id="${folder.id}">
                <div class="result-icon">
                    <i class="fas fa-folder text-warning"></i>
                </div>
                <div class="result-content">
                    <div class="result-title">${folder.name}</div>
                    <div class="result-meta">مجلد</div>
                </div>
                <div class="result-actions">
                    <button class="btn btn-sm btn-outline-primary" onclick="searchManager.openFolder('${folder.id}')">
                        <i class="fas fa-folder-open"></i>
                        فتح
                    </button>
                </div>
            </div>
        `;
    }

    // إنشاء HTML لنتيجة محادثة
    createChatResultHTML(chat) {
        return `
            <div class="search-result-item chat-result" data-chat-id="${chat.id}">
                <div class="result-icon">
                    <i class="fas fa-comment text-primary"></i>
                </div>
                <div class="result-content">
                    <div class="result-title">${chat.name || 'محادثة بدون عنوان'}</div>
                    <div class="result-preview">${this.truncateText(chat.content || '', 100)}</div>
                    <div class="result-meta">
                        <span class="folder-name">${chat.folder || 'بدون مجلد'}</span>
                        <span class="chat-date">${chat.date || ''}</span>
                    </div>
                </div>
                <div class="result-actions">
                    <button class="btn btn-sm btn-outline-primary" onclick="searchManager.openChat('${chat.id}')">
                        <i class="fas fa-external-link-alt"></i>
                        فتح
                    </button>
                </div>
            </div>
        `;
    }

    // تقصير النص
    truncateText(text, maxLength) {
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    }

    // مسح نتائج البحث
    clearSearchResults() {
        this.searchResults = [];
        this.searchResultsList.innerHTML = '';
    }

    // مسح البحث
    clearSearch() {
        this.searchInput.value = '';
        this.clearSearchResults();
        this.searchInput.focus();
    }

    // تحميل المحادثات الأخيرة
    loadRecentChats() {
        // محاكاة تحميل المحادثات الأخيرة (سيتم تطويره لاحقاً)
        this.recentChats = [
            {
                id: 'chat1',
                name: 'محادثة حول البرمجة',
                content: 'كيف يمكنني تعلم JavaScript؟',
                folder: 'البرمجة',
                date: '2024-01-15'
            },
            {
                id: 'chat2',
                name: 'أسئلة الرياضيات',
                content: 'شرح معادلة من الدرجة الثانية',
                folder: 'الرياضيات',
                date: '2024-01-14'
            },
            {
                id: 'chat3',
                name: 'مشروع العلوم',
                content: 'تجربة كيميائية بسيطة',
                folder: 'العلوم',
                date: '2024-01-13'
            }
        ];

        this.displayRecentChats();
    }

    // عرض المحادثات الأخيرة
    displayRecentChats() {
        if (this.recentChats.length === 0) {
            this.recentChatsList.innerHTML = `
                <div class="text-center text-muted py-4">
                    <i class="fas fa-comments fa-2x mb-3"></i>
                    <p>لا توجد محادثات حديثة</p>
                </div>
            `;
            return;
        }

        const chatsHTML = this.recentChats.map(chat => `
            <a href="#" class="chat-item" onclick="searchManager.openChat('${chat.id}')">
                <div class="chat-item-icon">
                    <i class="fa-duotone fa-light fa-comments"></i>
                </div>
                <div class="chat-item-content">
                    <div class="chat-item-title">${chat.name}</div>
                    <div class="chat-item-preview">${this.truncateText(chat.content, 50)}</div>
                </div>
            </a>
        `).join('');

        this.recentChatsList.innerHTML = chatsHTML;
    }

    // فتح مجلد
    openFolder(folderId) {
        // إغلاق مودال البحث
        this.searchModal.hide();
        
        // البحث عن المجلد وفتحه
        const folder = document.getElementById(folderId);
        if (folder) {
            folder.click();
        }
    }

    // فتح محادثة
    openChat(chatId) {
        // إغلاق مودال البحث
        this.searchModal.hide();
        
        // فتح المحادثة (سيتم تطويره لاحقاً)
        console.log('فتح المحادثة:', chatId);
        
        // يمكن إضافة منطق فتح المحادثة هنا
        // مثل تحميل المحادثة من الذاكرة أو قاعدة البيانات
    }

    // عرض خطأ البحث
    showSearchError(message) {
        this.searchResultsList.innerHTML = `
            <div class="text-center text-danger py-4">
                <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                <p>${message}</p>
            </div>
        `;
    }
}

// إنشاء مثيل من مدير البحث
const searchManager = new SearchManager();
