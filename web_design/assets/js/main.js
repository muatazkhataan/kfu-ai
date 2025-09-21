// Home Page JS
// -------------------------------------------------

// Chat functionality
document.addEventListener("DOMContentLoaded", function () {
    const chatInput = document.querySelector(".chat-input");
    const sendBtn = document.querySelector(".send-btn");
    const chatMessages = document.querySelector(".chat-messages");
    const typingIndicator = document.querySelector(".typing-indicator");

    function addMessage(content, isUser = false) {
        const messageDiv = document.createElement("div");
        messageDiv.className = `message ${isUser ? "user" : "assistant"}`;

        messageDiv.innerHTML = `
                    <div class="message-avatar">
                        <i class="${isUser ? "fas fa-user" : "kfu-icon"}"></i>
                    </div>
                    <div class="message-content">
                        <p class="mb-0">${content}</p>
                    </div>
                `;

        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function showTyping() {
        typingIndicator.style.display = "flex";
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function hideTyping() {
        typingIndicator.style.display = "none";
    }

    function simulateResponse() {
        const responses = [
            "مرحبا بك! يرجى تسجيل الدخول حتى نتمكن من مساعدتك.",
            "يمكنني مساعدتك في هذا الموضوع. لكن يجب عليك أولًا أن تدخل إلى واجهة المحادثة الرئيسية عبر تسجيل الدخول.",
            "شكراً لسؤالك! يرجى تسجيل الدخول حتى نتمكن من مساعدتك.",
            "أعتقد أنه يجب عليك أولًا أن تدخل إلى واجهة المحادثة الرئيسية. يرجى تسجيل الدخول."
        ];

        const randomResponse = responses[Math.floor(Math.random() * responses.length)];

        setTimeout(() => {
            hideTyping();
            addMessage(randomResponse, false);
        }, 2000);
    }

    function sendMessage() {
        const message = chatInput.value.trim();
        if (message) {
            addMessage(message, true);
            chatInput.value = "";

            showTyping();
            simulateResponse();
        }
    }

    sendBtn.addEventListener("click", sendMessage);

    chatInput.addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            sendMessage();
        }
    });

    // Smooth scrolling for navigation links
    document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
        anchor.addEventListener("click", function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute("href"));
            if (target) {
                target.scrollIntoView({
                    behavior: "smooth",
                    block: "start"
                });
            }
        });
    });

    // Animate stats on scroll
    const observerOptions = {
        threshold: 0.5
    };

    const observer = new IntersectionObserver(function (entries) {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = "1";
                entry.target.style.transform = "translateY(0)";
            }
        });
    }, observerOptions);

    document.querySelectorAll(".stats-card").forEach((card) => {
        card.style.opacity = "0";
        card.style.transform = "translateY(20px)";
        card.style.transition = "all 0.6s ease";
        observer.observe(card);
    });
});
