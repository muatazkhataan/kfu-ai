import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/message.dart';
import '../../domain/models/message_type.dart';
import '../../domain/models/chat_status.dart';
import '../../../../state/chat_state.dart';

/// مزود حالة المحادثة الرئيسي
///
/// يدير حالة المحادثة الحالية مع جميع العمليات المرتبطة بها
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState.initial);

  /// تحميل محادثة جديدة
  Future<void> loadChat(String chatId) async {
    try {
      state = state.copyWith(isLoadingChat: true, error: null);

      // TODO: تحميل المحادثة من قاعدة البيانات
      await Future.delayed(const Duration(milliseconds: 500));

      // محادثة وهمية للاختبار
      final chat = Chat.createWelcome(userId: 'user_123', folderId: null);

      state = state.copyWith(currentChat: chat, isLoadingChat: false);

      // تحميل الرسائل
      await loadMessages(chatId);
    } catch (e) {
      state = state.copyWith(
        isLoadingChat: false,
        error: 'فشل في تحميل المحادثة: ${e.toString()}',
      );
    }
  }

  /// تحميل الرسائل للمحادثة الحالية
  Future<void> loadMessages(String chatId) async {
    try {
      state = state.copyWith(isLoadingMessages: true, messageError: null);

      // TODO: تحميل الرسائل من قاعدة البيانات
      await Future.delayed(const Duration(milliseconds: 300));

      // رسائل وهمية للاختبار
      final messages = _generateMockMessages(chatId);

      state = state.copyWith(
        messages: messages,
        isLoadingMessages: false,
        lastMessageId: messages.isNotEmpty ? messages.last.id : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMessages: false,
        messageError: 'فشل في تحميل الرسائل: ${e.toString()}',
      );
    }
  }

  /// إرسال رسالة جديدة
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || state.currentChat == null) return;

    try {
      state = state.copyWith(isSendingMessage: true);

      // إنشاء رسالة جديدة
      final message = Message(
        id: _generateMessageId(),
        content: content.trim(),
        type: MessageType.user,
        chatId: state.currentChat!.id,
        senderId: 'user_123',
        senderName: 'أحمد محمد',
        createdAt: DateTime.now(),
        state: MessageState.sending,
      );

      // إضافة الرسالة للحالة
      final updatedMessages = [...state.messages, message];
      state = state.copyWith(
        messages: updatedMessages,
        isSendingMessage: false,
      );

      // محاكاة استجابة المساعد
      await _simulateAssistantResponse();
    } catch (e) {
      state = state.copyWith(
        isSendingMessage: false,
        messageError: 'فشل في إرسال الرسالة: ${e.toString()}',
      );
    }
  }

  /// محاكاة استجابة المساعد
  Future<void> _simulateAssistantResponse() async {
    // عرض مؤشر الكتابة
    startTyping();

    // انتظار لمحاكاة وقت المعالجة
    await Future.delayed(const Duration(seconds: 2));

    // إيقاف مؤشر الكتابة
    stopTyping();

    // إضافة رد المساعد
    final assistantMessage = Message(
      id: _generateMessageId(),
      content: 'شكراً لك على رسالتك. كيف يمكنني مساعدتك اليوم؟',
      type: MessageType.assistant,
      chatId: state.currentChat!.id,
      senderId: 'assistant',
      senderName: 'مساعد كفو',
      createdAt: DateTime.now(),
      state: MessageState.sent,
    );

    final updatedMessages = [...state.messages, assistantMessage];
    state = state.copyWith(messages: updatedMessages);
  }

  /// بدء مؤشر الكتابة
  void startTyping() {
    state = state.copyWith(
      isTyping: true,
      typingUserId: 'assistant',
      typingStartedAt: DateTime.now(),
    );
  }

  /// إيقاف مؤشر الكتابة
  void stopTyping() {
    state = state.copyWith(
      isTyping: false,
      typingUserId: null,
      typingStartedAt: null,
    );
  }

  /// إنشاء محادثة جديدة
  Future<void> createNewChat({String? title, String? folderId}) async {
    try {
      final chat = Chat.create(
        title: title ?? 'محادثة جديدة',
        userId: 'user_123',
        folderId: folderId,
      );

      // إنشاء محادثة فارغة بدون رسائل
      state = state.copyWith(
        currentChat: chat,
        messages: [], // قائمة رسائل فارغة
        isLoadingMessages: false,
        messageError: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'فشل في إنشاء محادثة جديدة: ${e.toString()}',
      );
    }
  }

  /// تحديث عنوان المحادثة
  Future<void> updateChatTitle(String newTitle) async {
    if (state.currentChat == null || newTitle.trim().isEmpty) return;

    try {
      final updatedChat = state.currentChat!.copyWith(
        title: newTitle.trim(),
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(currentChat: updatedChat);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        error: 'فشل في تحديث عنوان المحادثة: ${e.toString()}',
      );
    }
  }

  /// نقل المحادثة لمجلد آخر
  Future<void> moveChatToFolder(String? folderId) async {
    if (state.currentChat == null) return;

    try {
      final updatedChat = state.currentChat!.copyWith(
        folderId: folderId,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(currentChat: updatedChat);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(error: 'فشل في نقل المحادثة: ${e.toString()}');
    }
  }

  /// أرشفة المحادثة
  Future<void> archiveChat() async {
    if (state.currentChat == null) return;

    try {
      final updatedChat = state.currentChat!.copyWith(
        status: ChatStatus.archived,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(currentChat: updatedChat);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(error: 'فشل في أرشفة المحادثة: ${e.toString()}');
    }
  }

  /// حذف المحادثة
  Future<void> deleteChat() async {
    if (state.currentChat == null) return;

    try {
      final updatedChat = state.currentChat!.copyWith(
        status: ChatStatus.deleted,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(currentChat: updatedChat);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(error: 'فشل في حذف المحادثة: ${e.toString()}');
    }
  }

  /// مسح المحادثة (إزالة جميع الرسائل)
  Future<void> clearChat() async {
    if (state.currentChat == null) return;

    try {
      state = state.copyWith(messages: [], lastMessageId: null);

      // TODO: حذف الرسائل من قاعدة البيانات
    } catch (e) {
      state = state.copyWith(error: 'فشل في مسح المحادثة: ${e.toString()}');
    }
  }

  /// تحديث حالة رسالة
  Future<void> updateMessageState(
    String messageId,
    MessageState newState,
  ) async {
    try {
      final updatedMessages = state.messages.map((message) {
        if (message.id == messageId) {
          return message.copyWith(state: newState, updatedAt: DateTime.now());
        }
        return message;
      }).toList();

      state = state.copyWith(messages: updatedMessages);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        messageError: 'فشل في تحديث حالة الرسالة: ${e.toString()}',
      );
    }
  }

  /// حذف رسالة
  Future<void> deleteMessage(String messageId) async {
    try {
      final updatedMessages = state.messages.map((message) {
        if (message.id == messageId) {
          return message.copyWith(
            isDeleted: true,
            deletedAt: DateTime.now(),
            deletionReason: 'حذف من قبل المستخدم',
          );
        }
        return message;
      }).toList();

      state = state.copyWith(messages: updatedMessages);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        messageError: 'فشل في حذف الرسالة: ${e.toString()}',
      );
    }
  }

  /// تحرير رسالة
  Future<void> editMessage(String messageId, String newContent) async {
    try {
      final updatedMessages = state.messages.map((message) {
        if (message.id == messageId) {
          return message.copyWith(
            content: newContent.trim(),
            updatedAt: DateTime.now(),
          );
        }
        return message;
      }).toList();

      state = state.copyWith(messages: updatedMessages);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        messageError: 'فشل في تحرير الرسالة: ${e.toString()}',
      );
    }
  }

  /// إعادة تعيين الحالة
  void reset() {
    state = ChatState.initial;
  }

  /// مسح الأخطاء
  void clearErrors() {
    state = state.copyWith(error: null, messageError: null);
  }

  /// توليد رسائل وهمية للاختبار
  List<Message> _generateMockMessages(String chatId) {
    final now = DateTime.now();

    return [
      Message(
        id: 'msg_1',
        content: 'مرحباً بك في مساعد كفو! كيف يمكنني مساعدتك اليوم؟',
        type: MessageType.welcome,
        chatId: chatId,
        senderId: 'assistant',
        senderName: 'مساعد كفو',
        createdAt: now.subtract(const Duration(minutes: 10)),
        state: MessageState.sent,
      ),
      Message(
        id: 'msg_2',
        content: 'أريد مساعدة في حل مشكلة برمجية',
        type: MessageType.user,
        chatId: chatId,
        senderId: 'user_123',
        senderName: 'أحمد محمد',
        createdAt: now.subtract(const Duration(minutes: 8)),
        state: MessageState.sent,
      ),
      Message(
        id: 'msg_3',
        content:
            'بالطبع! سأكون سعيداً لمساعدتك في حل مشكلتك البرمجية. هل يمكنك وصف المشكلة التي تواجهها؟',
        type: MessageType.assistant,
        chatId: chatId,
        senderId: 'assistant',
        senderName: 'مساعد كفو',
        createdAt: now.subtract(const Duration(minutes: 7)),
        state: MessageState.sent,
      ),
    ];
  }

  /// توليد معرف فريد للرسالة
  String _generateMessageId() {
    return 'msg_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000).toString().padLeft(3, '0')}';
  }
}

/// مزود حالة المحادثة
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

/// مزود المحادثة الحالية
final currentChatProvider = Provider<Chat?>((ref) {
  return ref.watch(chatProvider).currentChat;
});

/// مزود الرسائل الحالية
final currentMessagesProvider = Provider<List<Message>>((ref) {
  return ref.watch(chatProvider).messages;
});

/// مزود مؤشر الكتابة
final typingIndicatorProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).isTyping;
});

/// مزود حالة التحميل
final chatLoadingProvider = Provider<bool>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.isLoadingChat || chatState.isLoadingMessages;
});

/// مزود الأخطاء
final chatErrorProvider = Provider<String?>((ref) {
  final chatState = ref.watch(chatProvider);
  return chatState.error ?? chatState.messageError;
});
