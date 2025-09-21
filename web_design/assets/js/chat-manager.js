/**
 * إدارة المحادثات - مساعد كفو
 * يحتوي على جميع وظائف إدارة المحادثات
 */

class ChatManager {
    constructor() {
        this.currentChatId = null;
        this.isTyping = false;
        this.chats = new Map();
        this.init();
    }

    // تهيئة النظام
    init() {
        this.loadDefaultChats();
        this.bindEvents();
        this.initializeNewChat();
    }

    // تحميل المحادثات الافتراضية
    loadDefaultChats() {
        const defaultChats = [
            {
                id: 'chat1',
                title: 'مساعدة في البرمجة',
                icon: ' fa-duotone fa-code',
                preview: 'أحتاج مساعدة في حل مشكلة برمجية...',
                folder: 'programming'
            },
            {
                id: 'chat2',
                title: 'مراجعة هياكل البيانات',
                icon: ' fa-duotone fa-sitemap',
                preview: 'شرح الأشجار الثنائية والبحث...',
                folder: 'datastructures'
            },
            {
                id: 'chat3',
                title: 'المواعيد الأكاديمية',
                icon: ' fa-duotone fa-calendar',
                preview: 'متى موعد التسجيل للفصل القادم؟',
                folder: 'academic'
            },
            {
                id: 'chat4',
                title: 'نصائح البرمجة',
                icon: ' fa-duotone fa-brain',
                preview: 'كيف أحسن مهاراتي في البرمجة؟',
                folder: 'academic'
            }
        ];

        defaultChats.forEach(chat => {
            this.chats.set(chat.id, chat);
        });
    }

    // ربط الأحداث
    bindEvents() {
        const chatInput = document.getElementById("chatInput");
        const sendBtn = document.getElementById("sendBtn");

        // تغيير حجم textarea تلقائياً
        chatInput.addEventListener("input", () => {
            chatInput.style.height = "auto";
            chatInput.style.height = Math.min(chatInput.scrollHeight, 120) + "px";
            sendBtn.disabled = chatInput.value.trim() === "";
        });

        // إرسال الرسالة عند الضغط على Enter
        chatInput.addEventListener("keydown", (e) => {
            if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                this.sendMessage();
            }
        });

        // إغلاق القوائم المنسدلة عند النقر خارجها
        document.addEventListener("click", (e) => {
            if (e.target && e.target.closest && !e.target.closest('.chat-item-actions')) {
                console.log('🖱️ النقر خارج chat-item-actions، إغلاق القوائم');
                this.closeAllChatDropdowns();
            }
        });
    }

    // بدء محادثة جديدة
    startNewChat() {
        this.currentChatId = "new-" + Date.now();
        document.getElementById("chatTitle").textContent = "محادثة جديدة";
        document.getElementById("welcomeMessage").style.display = "block";
        document.getElementById("messagesContainer").style.display = "none";
        document.getElementById("chatInput").value = "";
        document.getElementById("sendBtn").disabled = true;

        // إزالة الفئة النشطة من جميع العناصر
        document.querySelectorAll(".chat-item, .folder-item").forEach((item) => {
            item.classList.remove("active");
        });

        // إعادة تعيين رسالة الترحيب
        const welcomeTitle = document.querySelector('.welcome-title');
        const welcomeText = document.querySelector('.welcome-text');
        welcomeTitle.textContent = 'مرحباً بك في مساعد كفو!';
        welcomeText.textContent = 'أنا مساعدك الذكي. يمكنني مساعدتك في المذاكرة، الشؤون الأكاديمية، وحل المشاكل الدراسية.';
    }

    // تهيئة محادثة جديدة
    initializeNewChat() {
        this.startNewChat();
    }

    // تحميل محادثة
    loadChat(chatId, event) {
        this.currentChatId = chatId;
        document.getElementById("welcomeMessage").style.display = "none";
        document.getElementById("messagesContainer").style.display = "block";

        // إزالة الفئة النشطة من جميع العناصر
        document.querySelectorAll(".chat-item, .folder-item").forEach((item) => {
            item.classList.remove("active");
        });

        // إضافة الفئة النشطة للمحادثة المحددة
        const chatItem = event ? event.target.closest(".chat-item") :
            document.querySelector(`[onclick*="loadChat('${chatId}')"]`);

        if (chatItem) {
            chatItem.classList.add("active");

            // تحديث عنوان المحادثة
            const chatTitle = chatItem.querySelector(".chat-item-title").textContent;
            document.getElementById("chatTitle").textContent = chatTitle;
        }
    }

    // إرسال رسالة
    sendMessage() {
        const chatInput = document.getElementById("chatInput");
        const message = chatInput.value.trim();

        if (!message || this.isTyping) return;

        // إخفاء رسالة الترحيب إذا كانت ظاهرة
        document.getElementById("welcomeMessage").style.display = "none";
        document.getElementById("messagesContainer").style.display = "block";

        // إضافة رسالة المستخدم
        this.addMessage(message, true);

        // مسح الإدخال
        chatInput.value = "";
        chatInput.style.height = "auto";
        document.getElementById("sendBtn").disabled = true;

        // إظهار مؤشر الكتابة
        this.showTyping();

        // محاكاة رد الذكاء الاصطناعي
        setTimeout(() => {
            this.hideTyping();
            const responses = [
                `أفهم سؤالك! دعني أساعدك في ذلك. يمكنني تقديم <strong>شرح مفصل</strong> أو حل للمشكلة التي تواجهها.<br><br>
                💡 <em>نصائح إضافية:</em><br>
                • راجع المادة بعناية<br>
                • استخدم <code>أمثلة عملية</code> للفهم<br>
                • لا تتردد في السؤال عن التفاصيل`,

                `هذا سؤال ممتاز! إليك <strong>الإجابة التفصيلية</strong> التي قد تساعدك في فهم الموضوع بشكل أفضل.<br><br>
                📚 <em>الخطوات المطلوبة:</em><br>
                • فهم الأساسيات أولاً<br>
                • تطبيق المفاهيم عملياً<br>
                • مراجعة النتائج`,

                `يمكنني مساعدتك في هذا الموضوع. إليك ما تحتاج معرفته مع بعض <strong>الأمثلة العملية</strong>.<br><br>
                🔧 <em>الأدوات المطلوبة:</em><br>
                • <code>محرر النصوص</code><br>
                • <code>متصفح الويب</code><br>
                • <code>أدوات التطوير</code>`,

                `شكراً لسؤالك! هذا ما يمكنني إخبارك به بناءً على <strong>خبرتي في المجال الأكاديمي</strong>.<br><br>
                🎓 <em>المجالات المتاحة:</em><br>
                • البرمجة والتطوير<br>
                • الرياضيات والعلوم<br>
                • الشؤون الأكاديمية`,

                `أعتقد أن هذا ما تبحث عنه. إليك <strong>التفاصيل الكاملة</strong> مع بعض النصائح الإضافية.<br><br>
                ⭐ <em>نصائح مهمة:</em><br>
                • اقرأ التعليمات بعناية<br>
                • جرب الحلول خطوة بخطوة<br>
                • اطلب المساعدة عند الحاجة`
            ];

            const randomResponse = responses[Math.floor(Math.random() * responses.length)];
            this.addMessageWithTyping(randomResponse, false, 25);
        }, 2000);
    }

    // إضافة رسالة
    addMessage(content, isUser = false) {
        const messagesContainer = document.getElementById("messagesContainer");
        const welcomeMessage = document.getElementById("welcomeMessage");

        // إخفاء رسالة الترحيب
        if (welcomeMessage) {
            welcomeMessage.style.display = 'none';
        }

        // إظهار حاوية الرسائل
        if (messagesContainer) {
            messagesContainer.style.display = 'block';
        }

        const messageDiv = document.createElement("div");
        messageDiv.className = `message ${isUser ? "user" : "assistant"}`;

        if (isUser) {
            // رسائل المستخدم - مع message-actions محدودة
            messageDiv.innerHTML = `
                <div class="message-avatar">
                    <i class="fa-duotone fa-user"></i>
                </div>
                <div class="message-content">
                    <p class="mb-0">${content}</p>
                    <div class="message-actions">
                        <button class="message-action-btn" onclick="chatManager.copyMessage(this)" title="نسخ المحتوى">
                            <i class="fa-regular fa-copy"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.editMessage(this)" title="تحرير الرسالة">
                            <i class="fa-regular fa-edit"></i>
                        </button>
                    </div>
                </div>
            `;
        } else {
            // رسائل المساعد - مع message-actions
            messageDiv.innerHTML = `
                <div class="message-avatar">
                    <i class="kfu-icon kfu-icon-primary"></i>
                </div>
                <div class="message-content">
                    <p class="mb-0">${content}</p>
                    <div class="message-actions">
                        <button class="message-action-btn" onclick="chatManager.copyMessage(this)" title="نسخ المحتوى">
                            <i class="fa-regular fa-copy"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.likeMessage(this)" title="رد جيد">
                            <i class="fa-solid fa-thumbs-up"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.dislikeMessage(this)" title="رد سيء">
                            <i class="fa-regular fa-thumbs-down"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.shareMessage(this)" title="مشاركة">
                            <i class="fa-regular fa-share"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.retryMessage(this)" title="حاول مرة أخرى">
                            <i class="fa-regular fa-redo"></i>
                        </button>
                        <div class="dropdown">
                            <button class="message-action-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" title="المزيد">
                                <i class="fa-regular fa-ellipsis-v"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="#" onclick="chatManager.branchInNewChat(this)">
                                    <i class="fa-regular fa-code-branch me-2"></i>فرع في دردشة جديدة
                                </a></li>
                                <li><a class="dropdown-item" href="#" onclick="chatManager.readAloud(this)">
                                    <i class="fa-regular fa-volume-up me-2"></i>قراءة بصوت
                                </a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            `;
        }

        messagesContainer.appendChild(messageDiv);
        this.scrollToBottom();
    }

    // إضافة رسالة مع تأثير الكتابة
    addMessageWithTyping(content, isUser = false, speed = 30) {
        const messagesContainer = document.getElementById("messagesContainer");
        const welcomeMessage = document.getElementById("welcomeMessage");

        // إخفاء رسالة الترحيب
        if (welcomeMessage) {
            welcomeMessage.style.display = 'none';
        }

        // إظهار حاوية الرسائل
        if (messagesContainer) {
            messagesContainer.style.display = 'block';
        }

        const messageDiv = document.createElement("div");
        messageDiv.className = `message ${isUser ? "user" : "assistant"} typing`;

        if (isUser) {
            // رسائل المستخدم - مع message-actions محدودة
            messageDiv.innerHTML = `
                <div class="message-avatar">
                    <i class="fa-duotone fa-user"></i>
                </div>
                <div class="message-content">
                    <div class="typing-effect-container">
                        <div class="mb-0"></div>
                    </div>
                    <div class="message-actions">
                        <button class="message-action-btn" onclick="chatManager.copyMessage(this)" title="نسخ المحتوى">
                            <i class="fa-regular fa-copy"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.editMessage(this)" title="تحرير الرسالة">
                            <i class="fa-regular fa-edit"></i>
                        </button>
                    </div>
                </div>
            `;
        } else {
            // رسائل المساعد - مع message-actions
            messageDiv.innerHTML = `
                <div class="message-avatar">
                    <i class="kfu-icon kfu-icon-primary"></i>
                </div>
                <div class="message-content">
                    <div class="typing-effect-container">
                        <div class="mb-0"></div>
                    </div>
                    <div class="message-actions">
                        <button class="message-action-btn" onclick="chatManager.copyMessage(this)" title="نسخ المحتوى">
                            <i class="fa-regular fa-copy"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.likeMessage(this)" title="رد جيد">
                            <i class="fa-regular fa-thumbs-up"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.dislikeMessage(this)" title="رد سيء">
                            <i class="fa-regular fa-thumbs-down"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.shareMessage(this)" title="مشاركة">
                            <i class="fa-regular fa-share"></i>
                        </button>
                        <button class="message-action-btn" onclick="chatManager.retryMessage(this)" title="حاول مرة أخرى">
                            <i class="fa-regular fa-redo"></i>
                        </button>
                        <div class="dropdown">
                            <button class="message-action-btn dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" title="المزيد">
                                <i class="fa-regular fa-ellipsis-v"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="#" onclick="chatManager.branchInNewChat(this)">
                                    <i class="fa-regular fa-code-branch me-2"></i>فرع في دردشة جديدة
                                </a></li>
                                <li><a class="dropdown-item" href="#" onclick="chatManager.readAloud(this)">
                                    <i class="fa-regular fa-volume-up me-2"></i>قراءة بصوت
                                </a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            `;
        }

        messagesContainer.appendChild(messageDiv);

        // الحصول على عنصر النص
        const textElement = messageDiv.querySelector('.typing-effect-container div');

        // بدء تأثير الكتابة
        this.typeTextWithHTML(textElement, content, speed).then(() => {
            // إزالة كلاس typing بعد انتهاء الكتابة
            messageDiv.classList.remove('typing');

            // إزالة مؤشر الكتابة
            const typingContainer = messageDiv.querySelector('.typing-effect-container');
            if (typingContainer) {
                typingContainer.classList.remove('typing-effect-container');
            }

            // تمرير إلى أسفل
            this.scrollToBottom();
        });

        return messageDiv;
    }

    // تأثير الكتابة التدريجية مع دعم HTML
    typeTextWithHTML(element, text, speed = 30) {
        return new Promise((resolve) => {
            // تحليل النص لفصل HTML عن النص العادي
            const parts = this.parseTextWithHTML(text);
            let currentIndex = 0;
            element.innerHTML = '';

            const typeNextPart = () => {
                if (currentIndex >= parts.length) {
                    resolve();
                    return;
                }

                const part = parts[currentIndex];

                if (part.type === 'html') {
                    // إضافة HTML مباشرة
                    element.innerHTML += part.content;
                    currentIndex++;
                    setTimeout(typeNextPart, speed * 2); // تأخير أطول للـ HTML
                } else {
                    // كتابة النص تدريجياً
                    let charIndex = 0;
                    const textInterval = setInterval(() => {
                        if (charIndex < part.content.length) {
                            element.innerHTML += part.content.charAt(charIndex);
                            charIndex++;
                        } else {
                            clearInterval(textInterval);
                            currentIndex++;
                            setTimeout(typeNextPart, speed);
                        }
                    }, speed);
                }
            };

            typeNextPart();
        });
    }

    // تحليل النص لفصل HTML عن النص العادي
    parseTextWithHTML(text) {
        const parts = [];
        let currentIndex = 0;

        while (currentIndex < text.length) {
            const htmlStart = text.indexOf('<', currentIndex);

            if (htmlStart === -1) {
                // لا يوجد المزيد من HTML tags
                if (currentIndex < text.length) {
                    parts.push({
                        type: 'text',
                        content: text.substring(currentIndex)
                    });
                }
                break;
            }

            // إضافة النص قبل HTML tag
            if (htmlStart > currentIndex) {
                parts.push({
                    type: 'text',
                    content: text.substring(currentIndex, htmlStart)
                });
            }

            // العثور على نهاية HTML tag
            const htmlEnd = text.indexOf('>', htmlStart);
            if (htmlEnd === -1) {
                // HTML tag غير مكتمل، اعتباره نص عادي
                parts.push({
                    type: 'text',
                    content: text.substring(htmlStart)
                });
                break;
            }

            // إضافة HTML tag
            parts.push({
                type: 'html',
                content: text.substring(htmlStart, htmlEnd + 1)
            });

            currentIndex = htmlEnd + 1;
        }

        return parts;
    }

    // إظهار مؤشر الكتابة
    showTyping() {
        this.isTyping = true;
        document.getElementById("typingIndicator").style.display = "flex";
        this.scrollToBottom();
    }

    // إخفاء مؤشر الكتابة
    hideTyping() {
        this.isTyping = false;
        document.getElementById("typingIndicator").style.display = "none";
    }

    // التمرير إلى الأسفل
    scrollToBottom() {
        const chatMessages = document.getElementById("chatMessages");
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    // طرح سؤال (الإجراءات السريعة)
    askQuestion(question) {
        document.getElementById("chatInput").value = question;
        this.sendMessage();
    }

    // إرسال اقتراح
    sendSuggestion(suggestion) {
        document.getElementById("chatInput").value = suggestion;
        this.sendMessage();
    }

    // إجراءات الرسائل
    copyMessage(button) {
        const messageContentElement = button.closest(".message-content");
        if (!messageContentElement) {
            this.showCopyError(button);
            return;
        }

        // البحث عن النص في عناصر مختلفة (تجاهل message-actions)
        let messageElement = messageContentElement.querySelector("p");
        if (!messageElement) {
            // إذا لم نجد <p>، نبحث في typing-effect-container
            messageElement = messageContentElement.querySelector(".typing-effect-container div");
        }
        if (!messageElement) {
            // إذا لم نجد أي منهما، نستخدم message-content لكن نستبعد message-actions
            messageElement = messageContentElement;
        }

        // استخراج النص مع استبعاد محتوى الأزرار
        let messageContent = '';

        if (messageElement.tagName === 'P' || messageElement.classList.contains('typing-effect-container')) {
            // إذا كان العنصر هو <p> أو typing-effect-container، نأخذ نصه مباشرة
            messageContent = messageElement.textContent || messageElement.innerText || '';
        } else {
            // إذا كان message-content، نستبعد message-actions
            const tempElement = messageContentElement.cloneNode(true);
            const actionsElement = tempElement.querySelector('.message-actions');
            if (actionsElement) {
                actionsElement.remove();
            }
            messageContent = tempElement.textContent || tempElement.innerText || '';
        }

        // تنظيف النص من المسافات الزائدة
        messageContent = messageContent.trim();

        if (!messageContent) {
            this.showCopyError(button);
            return;
        }

        // محاولة نسخ النص العادي أولاً
        if (navigator.clipboard && window.isSecureContext) {
            // استخدام Clipboard API الحديث
            navigator.clipboard.writeText(messageContent).then(() => {
                this.showCopySuccess(button);
            }).catch(() => {
                // Fallback: استخدام الطريقة القديمة
                this.fallbackCopyToClipboard(messageContent, button);
            });
        } else {
            // Fallback للمتصفحات القديمة أو غير الآمنة
            this.fallbackCopyToClipboard(messageContent, button);
        }
    }

    // طريقة بديلة للنسخ للمتصفحات القديمة
    fallbackCopyToClipboard(text, button) {
        const textArea = document.createElement("textarea");
        textArea.value = text;
        textArea.style.position = "fixed";
        textArea.style.left = "-999999px";
        textArea.style.top = "-999999px";
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();

        try {
            const successful = document.execCommand('copy');
            if (successful) {
                this.showCopySuccess(button);
            } else {
                this.showCopyError(button);
            }
        } catch (err) {
            this.showCopyError(button);
        }

        document.body.removeChild(textArea);
    }

    // إظهار تأكيد النجاح
    showCopySuccess(button) {
        const originalIcon = button.innerHTML;
        const originalTitle = button.getAttribute('title');

        button.innerHTML = '<i class="fa-duotone fa-check text-success"></i>';
        button.setAttribute('title', 'تم النسخ!');
        button.style.color = 'var(--bs-success)';

        setTimeout(() => {
            button.innerHTML = originalIcon;
            button.setAttribute('title', originalTitle);
            button.style.color = '';
        }, 1500);
    }

    // إظهار رسالة خطأ
    showCopyError(button) {
        const originalIcon = button.innerHTML;
        const originalTitle = button.getAttribute('title');

        button.innerHTML = '<i class="fa-duotone fa-times text-danger"></i>';
        button.setAttribute('title', 'فشل النسخ');
        button.style.color = 'var(--bs-danger)';

        setTimeout(() => {
            button.innerHTML = originalIcon;
            button.setAttribute('title', originalTitle);
            button.style.color = '';
        }, 1500);
    }

    likeMessage(button) {
        const icon = button.querySelector("i");
        if (icon.classList.contains("fa-thumbs-up")) {
            icon.classList.remove("fa-thumbs-up");
            icon.classList.add("fa-thumbs-up", "text-primary");
        } else {
            icon.classList.remove("text-primary");
        }
    }

    dislikeMessage(button) {
        const icon = button.querySelector("i");
        if (icon.classList.contains("fa-thumbs-down")) {
            icon.classList.remove("fa-thumbs-down");
            icon.classList.add("fa-thumbs-down", "text-danger");
        } else {
            icon.classList.remove("text-danger");
        }
    }

    shareMessage(button) {
        const messageContent = button.closest(".message-content").querySelector("p").textContent;
        if (navigator.share) {
            navigator.share({
                title: "رسالة من مساعد كفو",
                text: messageContent
            });
        } else {
            // Fallback: نسخ إلى الحافظة
            navigator.clipboard.writeText(messageContent).then(() => {
                // إظهار تأكيد
                const originalIcon = button.innerHTML;
                button.innerHTML = '<i class="fa-duotone fa-check"></i>';
                setTimeout(() => {
                    button.innerHTML = originalIcon;
                }, 1000);
            });
        }
    }

    retryMessage(button) {
        const messageElement = button.closest(".message");
        const messageContent = messageElement.querySelector(".message-content p").textContent;

        // إزالة الرسالة الحالية
        messageElement.remove();

        // إعادة إرسال الرسالة
        this.addMessageWithTyping(messageContent, false, 30);
    }

    branchInNewChat(link) {
        const messageContent = link.closest(".message").querySelector(".message-content p").textContent;

        // إنشاء محادثة جديدة
        this.startNewChat();

        // إضافة الرسالة إلى المحادثة الجديدة
        setTimeout(() => {
            this.addMessage(messageContent, true);
            this.addMessageWithTyping("تم إنشاء فرع جديد من هذه الرسالة. كيف يمكنني مساعدتك؟", false, 30);
        }, 500);
    }

    readAloud(link) {
        const messageContent = link.closest(".message").querySelector(".message-content p").textContent;

        if ('speechSynthesis' in window) {
            // إيقاف أي قراءة سابقة
            speechSynthesis.cancel();

            const utterance = new SpeechSynthesisUtterance(messageContent);
            utterance.lang = 'ar-SA';
            utterance.rate = 0.8;
            utterance.pitch = 1;

            speechSynthesis.speak(utterance);

            // إظهار تأكيد
            const originalIcon = link.querySelector("i");
            const originalText = link.textContent;
            link.innerHTML = '<i class="fa-duotone fa-stop me-2"></i>إيقاف';

            utterance.onend = () => {
                link.innerHTML = originalText;
            };
        } else {
            alert("عذراً، المتصفح لا يدعم قراءة النص بصوت عالي.");
        }
    }

    // إجراءات المحادثة
    clearChat() {
        if (confirm("هل أنت متأكد من رغبتك في مسح هذه المحادثة؟")) {
            document.getElementById("messagesContainer").innerHTML = "";
            document.getElementById("welcomeMessage").style.display = "block";
            document.getElementById("messagesContainer").style.display = "none";
        }
    }

    exportChat() {
        const messages = document.querySelectorAll(".message");
        let exportText = "محادثة مساعد كفو\n\n";

        messages.forEach((message) => {
            const isUser = message.classList.contains("user");
            const content = message.querySelector("p").textContent;
            exportText += `${isUser ? "أنت" : "مساعد كفو"}: ${content}\n\n`;
        });

        const blob = new Blob([exportText], { type: "text/plain" });
        const url = URL.createObjectURL(blob);
        const a = document.createElement("a");
        a.href = url;
        a.download = "محادثة-كفو.txt";
        a.click();
        URL.revokeObjectURL(url);
    }

    shareChat() {
        if (navigator.share) {
            navigator.share({
                title: "محادثة مساعد كفو",
                text: "شاهد هذه المحادثة المثيرة مع مساعد كفو!",
                url: window.location.href
            });
        } else {
            // بديل: نسخ الرابط
            navigator.clipboard.writeText(window.location.href);
            alert("تم نسخ رابط المحادثة إلى الحافظة");
        }
    }

    // إدارة القوائم المنسدلة للمحادثات
    toggleChatDropdown(event, chatId) {
        event.preventDefault();
        event.stopPropagation();

        console.log('🔄 toggleChatDropdown تم استدعاؤها لـ:', chatId);

        // إغلاق جميع القوائم المنسدلة الأخرى
        this.closeAllChatDropdowns();

        // تبديل القائمة المنسدلة الحالية
        const dropdown = document.getElementById(`dropdown-${chatId}`);
        const button = event.target.closest('.btn');
        const buttonRect = button.getBoundingClientRect();

        if (dropdown.classList.contains('show')) {
            console.log('❌ إغلاق القائمة المنسدلة:', chatId);
            dropdown.classList.remove('show');
        } else {
            console.log('✅ فتح القائمة المنسدلة:', chatId);
            // تحديد موقع القائمة المنسدلة
            dropdown.style.top = (buttonRect.bottom + 5) + 'px';
            dropdown.style.right = (window.innerWidth - buttonRect.right) + 'px';
            dropdown.classList.add('show');

            // إضافة معالجات الأحداث للقائمة الجديدة
            this.setupDropdownEvents(dropdown);
        }
    }

    closeAllChatDropdowns() {
        console.log('🔒 closeAllChatDropdowns تم استدعاؤها');
        document.querySelectorAll('.chat-dropdown-menu').forEach(menu => {
            console.log('❌ إغلاق قائمة:', menu.id);
            menu.classList.remove('show');
        });
    }

    // إعداد معالجات الأحداث للقائمة المنسدلة
    setupDropdownEvents(dropdown) {
        let closeTimeout;

        // إغلاق القائمة عند خروج الماوس منها
        dropdown.addEventListener('mouseleave', () => {
            console.log('🚪 mouseleave من القائمة الرئيسية');
            closeTimeout = setTimeout(() => {
                dropdown.classList.remove('show');
                console.log('⏰ تم إغلاق القائمة الرئيسية');
            }, 300);
        });

        // إلغاء الإغلاق عند عودة الماوس للقائمة
        dropdown.addEventListener('mouseenter', () => {
            console.log('🖱️ mouseenter للقائمة الرئيسية');
            clearTimeout(closeTimeout);
        });

        // معالجة القوائم الفرعية
        const submenuItems = dropdown.querySelectorAll('.chat-dropdown-submenu');
        submenuItems.forEach(submenuItem => {
            let submenuCloseTimeout;

            // إظهار القائمة الفرعية عند المرور عليها
            submenuItem.addEventListener('mouseenter', () => {
                console.log('🖱️ mouseenter على submenu');
                clearTimeout(submenuCloseTimeout);
                const submenu = submenuItem.querySelector('.chat-dropdown-menu');
                if (submenu) {
                    // تحديد موضع القائمة الفرعية
                    const parentRect = submenuItem.getBoundingClientRect();
                    const submenuWidth = 180; // عرض القائمة الفرعية
                    const submenuHeight = submenu.scrollHeight || 200; // ارتفاع القائمة الفرعية

                    // تحديد الموضع العمودي - محاذاة مع العنصر الأب
                    let topPosition = parentRect.top;

                    // التحقق من أن القائمة لا تخرج من أسفل الشاشة
                    if (topPosition + submenuHeight > window.innerHeight) {
                        // إذا كانت ستخرج من أسفل الشاشة، حركها لأعلى
                        topPosition = window.innerHeight - submenuHeight - 10; // 10px مسافة من أسفل الشاشة
                    }

                    // التحقق من أن القائمة لا تخرج من أعلى الشاشة
                    if (topPosition < 10) {
                        topPosition = 10; // 10px مسافة من أعلى الشاشة
                    }

                    submenu.style.top = topPosition + 'px';

                    // تحديد الموضع الأفقي - القائمة الفرعية تظهر على الجانب الأيمن
                    let rightPosition = window.innerWidth - parentRect.right + submenuWidth + 5;

                    // التحقق من أن القائمة لا تخرج من الجانب الأيمن من الشاشة
                    if (rightPosition < 10) {
                        // إذا كانت ستخرج من الجانب الأيمن، حركها لليسار
                        rightPosition = 10; // 10px مسافة من الجانب الأيمن
                    }

                    // التحقق من أن القائمة لا تخرج من الجانب الأيسر من الشاشة
                    const leftPosition = window.innerWidth - rightPosition - submenuWidth;
                    if (leftPosition < 10) {
                        // إذا كانت ستخرج من الجانب الأيسر، حركها لليمين
                        rightPosition = window.innerWidth - submenuWidth - 10; // 10px مسافة من الجانب الأيسر
                    }

                    submenu.style.right = rightPosition + 'px';
                    submenu.style.left = 'auto'; // إزالة left

                    submenu.classList.add('show');
                    console.log('✅ تم إظهار القائمة الفرعية في الموضع:', topPosition);
                }
            });

            // إخفاء القائمة الفرعية عند خروج الماوس منها
            submenuItem.addEventListener('mouseleave', () => {
                console.log('🚪 mouseleave من submenu');
                const submenu = submenuItem.querySelector('.chat-dropdown-menu');
                if (submenu) {
                    submenuCloseTimeout = setTimeout(() => {
                        submenu.classList.remove('show');
                        console.log('⏰ تم إخفاء القائمة الفرعية');
                    }, 200);
                }
            });
        });
    }

    // مشاركة عنصر المحادثة
    shareChatItem(chatId) {
        const chatItem = document.querySelector(`[onclick*="loadChat('${chatId}')"]`);
        const chatTitle = chatItem.querySelector('.chat-item-title').textContent;

        if (navigator.share) {
            navigator.share({
                title: `محادثة: ${chatTitle}`,
                text: `شاهد هذه المحادثة المثيرة مع مساعد كفو!`,
                url: window.location.href
            });
        } else {
            // بديل: نسخ إلى الحافظة
            navigator.clipboard.writeText(`${chatTitle} - ${window.location.href}`);
            alert("تم نسخ رابط المحادثة إلى الحافظة");
        }

        // إغلاق القائمة المنسدلة
        document.getElementById(`dropdown-${chatId}`).classList.remove('show');
    }

    // إعادة تسمية المحادثة
    renameChat(chatId) {
        const chatItem = document.querySelector(`[onclick*="loadChat('${chatId}')"]`);
        const titleElement = chatItem.querySelector('.chat-item-title');
        const currentTitle = titleElement.textContent;

        const newTitle = prompt("أدخل الاسم الجديد للمحادثة:", currentTitle);
        if (newTitle && newTitle.trim() !== '') {
            titleElement.textContent = newTitle.trim();

            // تحديث البيانات المحلية
            if (this.chats.has(chatId)) {
                this.chats.get(chatId).title = newTitle.trim();
            }
        }

        // إغلاق القائمة المنسدلة
        document.getElementById(`dropdown-${chatId}`).classList.remove('show');
    }

    // إضافة إلى مجلد
    addToFolder(chatId, folderType) {
        const chatItem = document.querySelector(`[onclick*="loadChat('${chatId}')"]`);
        const chatTitle = chatItem.querySelector('.chat-item-title').textContent;

        if (folderType === 'new') {
            // تخزين معلومات المحادثة للاستخدام لاحقاً
            window.pendingChatForNewFolder = {
                chatId: chatId,
                chatTitle: chatTitle
            };

            // مسح النموذج وإظهار النافذة المنبثقة
            document.getElementById('folderName').value = '';
            document.getElementById('folderIcon').value = 'fa-duotone fa-folder';

            const modal = new bootstrap.Modal(document.getElementById('addFolderModal'));
            modal.show();

            // إغلاق قائمة المحادثة المنسدلة
            document.getElementById(`dropdown-${chatId}`).classList.remove('show');
        } else {
            const folderNames = {
                'programming': 'البرمجة',
                'datastructures': 'هياكل البيانات',
                'algorithms': 'الخوارزميات',
                'databases': 'قواعد البيانات',
                'academic': 'الشؤون الأكاديمية'
            };

            // الحصول على اسم المجلد ديناميكياً للمجلدات المخصصة
            if (folderType.startsWith('folder-')) {
                const folderItem = document.querySelector(`[onclick*="openFolder('${folderType}')"]`);
                if (folderItem) {
                    folderNames[folderType] = folderItem.querySelector('.folder-name').textContent;
                }
            }

            // تحديث عدد المحادثات في المجلد
            const folderItem = document.querySelector(`[onclick*="openFolder('${folderType}')"]`);
            if (folderItem) {
                const countElement = folderItem.querySelector('.folder-count');
                const currentText = countElement.textContent;
                const currentCount = parseInt(currentText.match(/\d+/)[0]) || 0;
                countElement.textContent = `${currentCount + 1} محادثة`;
            }

            alert(`تم إضافة المحادثة "${chatTitle}" إلى مجلد "${folderNames[folderType]}"`);
        }

        // إغلاق القائمة المنسدلة
        document.getElementById(`dropdown-${chatId}`).classList.remove('show');
    }

    // أرشفة المحادثة
    archiveChat(chatId) {
        const chatItem = document.querySelector(`[onclick*="loadChat('${chatId}')"]`);
        const chatTitle = chatItem.querySelector('.chat-item-title').textContent;

        if (confirm(`هل أنت متأكد من رغبتك في أرشفة المحادثة "${chatTitle}"؟`)) {
            chatItem.style.opacity = '0.5';
            chatItem.style.backgroundColor = 'var(--bs-gray-100)';
            alert(`تم أرشفة المحادثة "${chatTitle}"`);
        }

        // إغلاق القائمة المنسدلة
        document.getElementById(`dropdown-${chatId}`).classList.remove('show');
    }

    // حذف المحادثة
    deleteChat(event, chatId) {
        event.preventDefault();
        event.stopPropagation();

        const chatItem = event.target.closest(".chat-item");
        const chatTitle = chatItem.querySelector('.chat-item-title').textContent;

        if (confirm(`هل أنت متأكد من رغبتك في حذف المحادثة "${chatTitle}"؟`)) {
            chatItem.remove();
            this.chats.delete(chatId);
        }

        // إغلاق القائمة المنسدلة
        document.getElementById(`dropdown-${chatId}`).classList.remove('show');
    }

    // إجراءات الإدخال
    attachFile() {
        const input = document.createElement("input");
        input.type = "file";
        input.accept = ".pdf,.doc,.docx,.txt,.jpg,.png";
        input.onchange = (e) => {
            const file = e.target.files[0];
            if (file) {
                this.addMessage(`تم إرفاق الملف: ${file.name}`, true);
            }
        };
        input.click();
    }

    recordVoice() {
        alert("سيتم تفعيل التسجيل الصوتي قريباً");
    }

    // تحرير رسالة المستخدم
    editMessage(button) {
        const messageElement = button.closest(".message");
        const messageContent = messageElement.querySelector(".message-content p");
        
        if (!messageContent) {
            console.error('لم يتم العثور على محتوى الرسالة');
            return;
        }

        const currentText = messageContent.textContent || messageContent.innerText || '';
        
        // إنشاء عنصر الإدخال للتحرير
        const editInput = document.createElement('textarea');
        editInput.className = 'form-control edit-input';
        editInput.value = currentText;
        editInput.rows = Math.max(2, currentText.split('\n').length);
        editInput.style.resize = 'vertical';
        editInput.style.minHeight = '60px';
        
        // حفظ العنصر الأصلي
        const originalContent = messageContent.outerHTML;
        
        // استبدال المحتوى بعنصر الإدخال
        messageContent.parentNode.replaceChild(editInput, messageContent);
        
        // التركيز على حقل الإدخال
        editInput.focus();
        editInput.select();
        
        // إضافة أزرار الإجراءات
        const actionsDiv = messageElement.querySelector('.message-actions');
        if (actionsDiv) {
            const saveBtn = document.createElement('button');
            saveBtn.className = 'btn btn-success btn-sm me-2';
            saveBtn.innerHTML = '<i class="fa-regular fa-check me-1"></i>حفظ';
            saveBtn.onclick = () => this.saveEditedMessage(editInput, messageElement, actionsDiv);
            
            const cancelBtn = document.createElement('button');
            cancelBtn.className = 'btn btn-secondary btn-sm';
            cancelBtn.innerHTML = '<i class="fa-regular fa-times me-1"></i>إلغاء';
            cancelBtn.onclick = () => this.cancelEdit(originalContent, messageElement, actionsDiv);
            
            // إخفاء الأزرار الأصلية مؤقتاً
            actionsDiv.style.display = 'none';
            
            // إضافة الأزرار الجديدة
            const editActionsDiv = document.createElement('div');
            editActionsDiv.className = 'message-actions edit-actions';
            editActionsDiv.style.position = 'absolute';
            editActionsDiv.style.top = '-0.5rem';
            editActionsDiv.style.right = '0.5rem';
            editActionsDiv.style.background = 'var(--bs-body-bg)';
            editActionsDiv.style.border = '1px solid var(--bs-gray-200)';
            editActionsDiv.style.borderRadius = '0.5rem';
            editActionsDiv.style.padding = '0.5rem';
            editActionsDiv.style.boxShadow = '0 0.125rem 0.25rem rgba(0, 0, 0, 0.075)';
            editActionsDiv.style.zIndex = '10';
            editActionsDiv.style.display = 'flex';
            editActionsDiv.style.gap = '0.5rem';
            editActionsDiv.appendChild(saveBtn);
            editActionsDiv.appendChild(cancelBtn);
            
            messageElement.querySelector('.message-content').appendChild(editActionsDiv);
        }
        
        // حفظ التغييرات عند الضغط على Enter
        editInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                this.saveEditedMessage(editInput, messageElement, actionsDiv);
            } else if (e.key === 'Escape') {
                e.preventDefault();
                this.cancelEdit(originalContent, messageElement, actionsDiv);
            }
        });
    }

    // حفظ الرسالة المحررة
    saveEditedMessage(editInput, messageElement, originalActionsDiv) {
        const newText = editInput.value.trim();
        
        if (!newText) {
            alert('لا يمكن ترك الرسالة فارغة');
            return;
        }
        
        // إنشاء عنصر المحتوى الجديد
        const newContent = document.createElement('p');
        newContent.className = 'mb-0';
        newContent.textContent = newText;
        
        // استبدال حقل الإدخال بالمحتوى الجديد
        editInput.parentNode.replaceChild(newContent, editInput);
        
        // إزالة أزرار التحرير
        const editActionsDiv = messageElement.querySelector('.edit-actions');
        if (editActionsDiv) {
            editActionsDiv.remove();
        }
        
        // إظهار الأزرار الأصلية مرة أخرى
        if (originalActionsDiv) {
            originalActionsDiv.style.display = 'flex';
        }
        
        // إظهار رسالة نجاح
        this.showEditSuccess(messageElement);
        
        // تمرير إلى أسفل
        this.scrollToBottom();
    }

    // إلغاء التحرير
    cancelEdit(originalContent, messageElement, originalActionsDiv) {
        // استعادة المحتوى الأصلي
        const editInput = messageElement.querySelector('.edit-input');
        if (editInput) {
            editInput.outerHTML = originalContent;
        }
        
        // إزالة أزرار التحرير
        const editActionsDiv = messageElement.querySelector('.edit-actions');
        if (editActionsDiv) {
            editActionsDiv.remove();
        }
        
        // إظهار الأزرار الأصلية مرة أخرى
        if (originalActionsDiv) {
            originalActionsDiv.style.display = 'flex';
        }
    }

    // إظهار رسالة نجاح التحرير
    showEditSuccess(messageElement) {
        const messageContent = messageElement.querySelector('.message-content p');
        if (!messageContent) return;
        
        const originalText = messageContent.textContent;
        const originalColor = messageContent.style.color;
        
        messageContent.textContent = 'تم حفظ التعديلات بنجاح!';
        messageContent.style.color = 'var(--bs-success)';
        messageContent.style.fontWeight = 'bold';
        
        setTimeout(() => {
            messageContent.textContent = originalText;
            messageContent.style.color = originalColor;
            messageContent.style.fontWeight = '';
        }, 2000);
    }
}

// إنشاء مثيل مدير المحادثات
const chatManager = new ChatManager();

// تصدير الدوال للاستخدام العام
window.chatManager = chatManager;

console.log('✅ نظام إدارة المحادثات تم تحميله بنجاح!'); 