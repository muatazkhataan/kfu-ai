import '../features/chat/domain/models/chat.dart';
import '../features/chat/domain/models/message.dart';

/// حالة المحادثة الحالية
///
/// يمثل هذا الكلاس حالة المحادثة الحالية مع جميع المعلومات المرتبطة بها
class ChatState {
  /// المحادثة الحالية
  final Chat? currentChat;

  /// قائمة الرسائل في المحادثة الحالية
  final List<Message> messages;

  /// هل يتم تحميل الرسائل
  final bool isLoadingMessages;

  /// هل يتم إرسال رسالة
  final bool isSendingMessage;

  /// هل يتم تحميل المحادثة
  final bool isLoadingChat;

  /// خطأ في المحادثة
  final String? error;

  /// خطأ في الرسائل
  final String? messageError;

  /// هل يوجد المزيد من الرسائل للتحميل
  final bool hasMoreMessages;

  /// معرف آخر رسالة محملة
  final String? lastMessageId;

  /// هل يتم عرض مؤشر الكتابة
  final bool isTyping;

  /// معرف المستخدم الذي يكتب
  final String? typingUserId;

  /// تاريخ بداية الكتابة
  final DateTime? typingStartedAt;

  const ChatState({
    this.currentChat,
    this.messages = const [],
    this.isLoadingMessages = false,
    this.isSendingMessage = false,
    this.isLoadingChat = false,
    this.error,
    this.messageError,
    this.hasMoreMessages = true,
    this.lastMessageId,
    this.isTyping = false,
    this.typingUserId,
    this.typingStartedAt,
  });

  /// إنشاء نسخة من الحالة مع تعديلات
  ChatState copyWith({
    Chat? currentChat,
    List<Message>? messages,
    bool? isLoadingMessages,
    bool? isSendingMessage,
    bool? isLoadingChat,
    String? error,
    String? messageError,
    bool? hasMoreMessages,
    String? lastMessageId,
    bool? isTyping,
    String? typingUserId,
    DateTime? typingStartedAt,
  }) {
    return ChatState(
      currentChat: currentChat ?? this.currentChat,
      messages: messages ?? this.messages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isLoadingChat: isLoadingChat ?? this.isLoadingChat,
      error: error ?? this.error,
      messageError: messageError ?? this.messageError,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      isTyping: isTyping ?? this.isTyping,
      typingUserId: typingUserId ?? this.typingUserId,
      typingStartedAt: typingStartedAt ?? this.typingStartedAt,
    );
  }

  /// الحالة الأولية
  static const ChatState initial = ChatState();

  /// التحقق من وجود محادثة نشطة
  bool get hasActiveChat => currentChat != null && currentChat!.isActive;

  /// التحقق من وجود رسائل
  bool get hasMessages => messages.isNotEmpty;

  /// التحقق من وجود خطأ
  bool get hasError => error != null || messageError != null;

  /// التحقق من كون المحادثة فارغة
  bool get isEmpty => !hasActiveChat && messages.isEmpty;

  /// التحقق من كون المحادثة محملة
  bool get isLoaded => hasActiveChat && !isLoadingChat && !isLoadingMessages;

  /// التحقق من كون المحادثة جاهزة للاستخدام
  bool get isReady => isLoaded && !hasError;

  /// الحصول على عدد الرسائل
  int get messageCount => messages.length;

  /// الحصول على آخر رسالة
  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;

  /// الحصول على الرسائل المرئية فقط (غير محذوفة)
  List<Message> get visibleMessages =>
      messages.where((message) => !message.isDeleted).toList();

  /// الحصول على عدد الرسائل المرئية
  int get visibleMessageCount => visibleMessages.length;

  /// التحقق من وجود مؤشر كتابة نشط
  bool get hasActiveTyping => isTyping && typingUserId != null;

  /// الحصول على مدة الكتابة
  Duration? get typingDuration {
    if (!hasActiveTyping || typingStartedAt == null) return null;
    return DateTime.now().difference(typingStartedAt!);
  }

  /// الحصول على الرسائل من المستخدم
  List<Message> get userMessages =>
      messages.where((message) => message.isUserMessage).toList();

  /// الحصول على الرسائل من المساعد
  List<Message> get assistantMessages =>
      messages.where((message) => message.isAssistantMessage).toList();

  /// الحصول على الرسائل النظامية
  List<Message> get systemMessages =>
      messages.where((message) => message.isSystemMessage).toList();

  /// الحصول على الرسائل مع المرفقات
  List<Message> get messagesWithAttachments =>
      messages.where((message) => message.hasAttachments).toList();

  /// الحصول على معاينة المحادثة
  String get preview {
    if (hasActiveChat) {
      return currentChat!.preview;
    } else if (hasMessages) {
      return lastMessage?.preview ?? 'محادثة جديدة';
    } else {
      return 'لا توجد محادثة نشطة';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatState &&
          runtimeType == other.runtimeType &&
          currentChat == other.currentChat &&
          messages == other.messages &&
          isLoadingMessages == other.isLoadingMessages &&
          isSendingMessage == other.isSendingMessage &&
          isLoadingChat == other.isLoadingChat &&
          error == other.error &&
          messageError == other.messageError &&
          hasMoreMessages == other.hasMoreMessages &&
          lastMessageId == other.lastMessageId &&
          isTyping == other.isTyping &&
          typingUserId == other.typingUserId &&
          typingStartedAt == other.typingStartedAt;

  @override
  int get hashCode {
    return Object.hash(
      currentChat,
      messages,
      isLoadingMessages,
      isSendingMessage,
      isLoadingChat,
      error,
      messageError,
      hasMoreMessages,
      lastMessageId,
      isTyping,
      typingUserId,
      typingStartedAt,
    );
  }

  @override
  String toString() {
    return 'ChatState(currentChat: $currentChat, messageCount: $messageCount, isLoading: $isLoadingMessages, hasError: $hasError)';
  }
}
