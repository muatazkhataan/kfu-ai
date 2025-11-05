import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/message.dart';
import '../../domain/models/message_type.dart';
import '../../domain/models/chat_status.dart';
import '../../../../state/chat_state.dart';
import '../../../../services/api/api_manager.dart';
import '../../../../services/api/chat/models/send_message_request.dart';
import '../../../../services/api/chat/models/create_session_request.dart';
import '../../../../services/api/chat/models/message_dto.dart';
import '../../../../services/api/chat/models/update_session_title_request.dart';

/// مزود حالة المحادثة الرئيسي
///
/// يدير حالة المحادثة الحالية مع جميع العمليات المرتبطة بها
class ChatNotifier extends StateNotifier<ChatState> {
  final ApiManager _apiManager;

  ChatNotifier({ApiManager? apiManager})
    : _apiManager = apiManager ?? ApiManager(),
      super(ChatState.initial);

  /// تحميل محادثة من API
  Future<void> loadChat(String sessionId) async {
    try {
      state = state.copyWith(isLoadingChat: true, error: null);

      // ignore: avoid_print
      print('[ChatNotifier] 📥 تحميل المحادثة: $sessionId');

      // تحميل الجلسة من API
      final response = await _apiManager.chat.getSession(sessionId);

      if (!response.success || response.data == null) {
        state = state.copyWith(
          isLoadingChat: false,
          error: response.error ?? 'فشل في تحميل المحادثة',
        );
        return;
      }

      final sessionDto = response.data!;

      // ignore: avoid_print
      print('[ChatNotifier] ✅ تم تحميل الجلسة: ${sessionDto.title}');

      // تحويل SessionDto إلى Chat
      final chat = Chat(
        id: sessionDto.sessionId,
        title: sessionDto.title,
        userId: 'current_user', // سنحصل عليه من AuthProvider
        folderId: sessionDto.folderId,
        status: _getChatStatusFromDto(sessionDto),
        createdAt: sessionDto.createdAt,
        updatedAt: sessionDto.updatedAt,
        messageCount: sessionDto.messageCount ?? 0,
      );

      state = state.copyWith(currentChat: chat, isLoadingChat: false);

      // تحميل الرسائل
      await loadMessages(sessionId);
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[ChatNotifier] ❌ خطأ في تحميل المحادثة: $e');
      // ignore: avoid_print
      print('[ChatNotifier] Stack: $stackTrace');

      state = state.copyWith(
        isLoadingChat: false,
        error: 'فشل في تحميل المحادثة: ${e.toString()}',
      );
    }
  }

  /// تحويل حالة الجلسة من DTO
  ChatStatus _getChatStatusFromDto(dynamic sessionDto) {
    // إذا كانت الجلسة مؤرشفة
    if (sessionDto.metadata != null &&
        sessionDto.metadata['isArchived'] == true) {
      return ChatStatus.archived;
    }

    // إذا كانت محذوفة
    if (sessionDto.metadata != null &&
        sessionDto.metadata['isDeleted'] == true) {
      return ChatStatus.deleted;
    }

    // نشطة بشكل افتراضي
    return ChatStatus.active;
  }

  /// تحميل الرسائل للمحادثة الحالية
  Future<void> loadMessages(String sessionId) async {
    try {
      state = state.copyWith(isLoadingMessages: true, messageError: null);

      // ignore: avoid_print
      print('[ChatNotifier] 📥 تحميل رسائل الجلسة: $sessionId');

      // تحميل الجلسة مع الرسائل من API
      final response = await _apiManager.chat.getSession(sessionId);

      if (!response.success || response.data == null) {
        // في حالة فشل التحميل، نعرض قائمة فارغة
        state = state.copyWith(messages: [], isLoadingMessages: false);
        return;
      }

      final sessionDto = response.data!;

      // تحويل MessageDto إلى Message
      final messages = <Message>[];
      if (sessionDto.messages != null && sessionDto.messages!.isNotEmpty) {
        for (final messageDto in sessionDto.messages!) {
          // تحديد المرسل بناءً على isFromUser
          final senderName = messageDto.isFromUser
              ? 'أنت'
              : (messageDto.aiProvider ?? 'مساعد كفو');

          messages.add(
            Message(
              id: messageDto.messageId,
              content: messageDto.content,
              type: _getMessageTypeFromDto(messageDto),
              chatId: sessionId,
              senderId:
                  messageDto.senderId ??
                  (messageDto.isFromUser ? 'user' : 'assistant'),
              senderName: senderName,
              createdAt: messageDto.createdAt,
              state: MessageState.sent,
            ),
          );
        }

        // ignore: avoid_print
        print('[ChatNotifier] ✅ تم تحميل ${messages.length} رسالة');
        // ignore: avoid_print
        print(
          '[ChatNotifier] 📋 أول رسالة: ${messages.first.content.substring(0, messages.first.content.length > 50 ? 50 : messages.first.content.length)}...',
        );
      } else {
        // ignore: avoid_print
        print('[ChatNotifier] ℹ️ لا توجد رسائل في الجلسة');
      }

      state = state.copyWith(
        messages: messages,
        isLoadingMessages: false,
        lastMessageId: messages.isNotEmpty ? messages.last.id : null,
      );
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[ChatNotifier] ❌ خطأ في تحميل الرسائل: $e');
      // ignore: avoid_print
      print('[ChatNotifier] Stack: $stackTrace');

      state = state.copyWith(
        isLoadingMessages: false,
        messageError: 'فشل في تحميل الرسائل: ${e.toString()}',
      );
    }
  }

  /// تحديد نوع الرسالة من DTO
  MessageType _getMessageTypeFromDto(MessageDto messageDto) {
    // استخدام حقل type من DTO
    if (messageDto.isAssistantMessage) {
      return MessageType.assistant;
    } else if (messageDto.isSystemMessage) {
      return MessageType.system;
    }

    // رسالة من المستخدم بشكل افتراضي
    return MessageType.user;
  }

  /// إرسال رسالة جديدة - مع إنشاء تلقائي للمحادثة
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    try {
      // إذا لم تكن هناك محادثة حالية، إنشاء واحدة جديدة
      if (state.currentChat == null) {
        // ignore: avoid_print
        print('[ChatNotifier] 📝 لا توجد محادثة حالية - إنشاء محادثة جديدة...');

        await createNewChat(title: _generateChatTitleFromMessage(content));

        // التأكد من نجاح إنشاء المحادثة
        if (state.currentChat == null) {
          state = state.copyWith(messageError: 'فشل في إنشاء محادثة جديدة');
          return;
        }

        // ignore: avoid_print
        print(
          '[ChatNotifier] ✅ تم إنشاء محادثة جديدة بنجاح: ${state.currentChat!.id}',
        );
      }

      state = state.copyWith(isSendingMessage: true, messageError: null);

      // إنشاء رسالة محلية مؤقتة
      final tempMessageId = _generateMessageId();
      final tempMessage = Message(
        id: tempMessageId,
        content: content.trim(),
        type: MessageType.user,
        chatId: state.currentChat!.id,
        senderId: 'current_user',
        senderName: 'أنت',
        createdAt: DateTime.now(),
        state: MessageState.sending,
      );

      // إضافة الرسالة المؤقتة للحالة
      final updatedMessages = [...state.messages, tempMessage];
      state = state.copyWith(messages: updatedMessages);

      // ignore: avoid_print
      print(
        '[ChatNotifier] 📤 إرسال رسالة إلى الجلسة: ${state.currentChat!.id}',
      );

      // إرسال الرسالة عبر API
      final request = SendMessageRequest(
        sessionId: state.currentChat!.id,
        content: content.trim(),
      );

      final response = await _apiManager.chat.sendMessage(request);

      if (!response.success || response.data == null) {
        // تحديث حالة الرسالة لفشل الإرسال
        final failedMessages = state.messages.map((m) {
          if (m.id == tempMessageId) {
            return m.copyWith(state: MessageState.failed);
          }
          return m;
        }).toList();

        state = state.copyWith(
          messages: failedMessages,
          isSendingMessage: false,
          messageError: response.error ?? 'فشل في إرسال الرسالة',
        );
        return;
      }

      final messageDto = response.data!;

      // ignore: avoid_print
      print('[ChatNotifier] ✅ تم إرسال الرسالة بنجاح');

      // تحديث الرسالة المؤقتة بالبيانات الفعلية مع حماية من محتوى فارغ
      final sentMessages = state.messages.map((m) {
        if (m.id == tempMessageId) {
          return Message(
            id: messageDto.messageId,
            content: (messageDto.content.isNotEmpty)
                ? messageDto.content
                : m.content,
            type: MessageType.user,
            chatId: state.currentChat!.id,
            senderId: messageDto.senderId ?? 'current_user',
            senderName: messageDto.senderName ?? 'أنت',
            createdAt: messageDto.createdAt,
            state: MessageState.sent,
          );
        }
        return m;
      }).toList();

      state = state.copyWith(messages: sentMessages, isSendingMessage: false);

      // تحديث إحصائيات المحادثة
      final updatedChat = state.currentChat!.copyWith(
        messageCount: state.currentChat!.messageCount + 1,
        updatedAt: DateTime.now(),
        lastMessagePreview: content.trim().length > 50
            ? '${content.trim().substring(0, 50)}...'
            : content.trim(),
        lastActivityAt: DateTime.now(),
      );
      state = state.copyWith(currentChat: updatedChat);

      // إذا كان هذا أول إرسال للمحادثة وكان العنوان افتراضيًا، حدّث العنوان من أول رسالة
      if ((state.currentChat?.messageCount ?? 0) <= 1) {
        final generatedTitle = _generateChatTitleFromMessage(content);
        _ensureSessionTitleUpdated(state.currentChat!.id, generatedTitle);
      }

      // عرض مؤشر الكتابة ثم بدء الاستطلاع لجلب رد المساعد وتدفقه
      startTyping();
      _pollForAssistantResponse();
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[ChatNotifier] ❌ خطأ في إرسال الرسالة: $e');
      // ignore: avoid_print
      print('[ChatNotifier] Stack: $stackTrace');

      state = state.copyWith(
        isSendingMessage: false,
        messageError: 'فشل في إرسال الرسالة: ${e.toString()}',
      );
    }
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

  /// استطلاع دوري لجلب رد المساعد وإظهاره بتدفق تدريجي
  Future<void> _pollForAssistantResponse() async {
    // حماية: يجب أن توجد محادثة
    if (state.currentChat == null) return;

    final String sessionId = state.currentChat!.id;

    // سنحاول لعدد محدد من المحاولات
    const int maxAttempts = 30; // ~30 ثانية بانتظار الرد
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(const Duration(seconds: 1));

      try {
        final response = await _apiManager.chat.getSession(sessionId);
        if (response.success && response.data != null) {
          final sessionDto = response.data!;

          // إذا وصلت رسالة مساعد جديدة غير موجودة محليًا
          if ((sessionDto.messages?.isNotEmpty ?? false)) {
            final lastDto = sessionDto.messages!.last;
            final isAssistant = lastDto.isAssistantMessage;
            final notExists =
                state.messages.indexWhere((m) => m.id == lastDto.messageId) ==
                -1;

            if (isAssistant && notExists) {
              // أنشئ رسالة مساعد محلية فارغة ثم قم بتعبئتها تدريجيًا
              final assistantMsgId = lastDto.messageId;
              final fullText = lastDto.content;

              // أضف رسالة فارغة أولاً
              final assistantMessage = Message(
                id: assistantMsgId,
                content: '',
                type: MessageType.assistant,
                chatId: sessionId,
                senderId: lastDto.senderId ?? 'assistant',
                senderName: lastDto.aiProvider ?? 'مساعد كفو',
                createdAt: lastDto.createdAt,
                state: MessageState.sent,
              );

              state = state.copyWith(
                messages: [...state.messages, assistantMessage],
              );

              // نفذ بثًا تدريجيًا للنص
              await _animateAssistantStreaming(assistantMsgId, fullText);

              // أوقف مؤشر الكتابة بعد اكتمال الرد
              stopTyping();
              return;
            }
          }
        }
      } catch (_) {
        // تجاهل أخطاء الاستطلاع المؤقتة
      }
    }

    // في حال عدم وصول رد خلال الزمن المحدد، أوقف مؤشر الكتابة
    stopTyping();
  }

  /// بث النص تدريجيًا داخل رسالة المساعد المحددة
  Future<void> _animateAssistantStreaming(
    String messageId,
    String fullText,
  ) async {
    // قسّم النص إلى كلمات لإظهارها على دفعات
    final words = fullText.split(' ');
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      if (i > 0) buffer.write(' ');
      buffer.write(words[i]);

      // حدث محتوى الرسالة في الحالة
      final updated = state.messages.map((m) {
        if (m.id == messageId) {
          return m.copyWith(
            content: buffer.toString(),
            updatedAt: DateTime.now(),
          );
        }
        return m;
      }).toList();

      state = state.copyWith(messages: updated);

      // مهلة قصيرة بين كل دفعة
      await Future.delayed(const Duration(milliseconds: 35));
    }
  }

  /// ضمان تحديث عنوان الجلسة على الخادم والمحلي
  Future<void> _ensureSessionTitleUpdated(
    String sessionId,
    String newTitle,
  ) async {
    if (newTitle.trim().isEmpty) return;
    try {
      // تحديث محلي
      if (state.currentChat?.id == sessionId) {
        state = state.copyWith(
          currentChat: state.currentChat!.copyWith(title: newTitle.trim()),
        );
      }

      // استدعاء API لتحديث العنوان إن توفر
      try {
        // يوجد موديل UpdateSessionTitleRequest
        final req = UpdateSessionTitleRequest(
          sessionId: sessionId,
          title: newTitle.trim(),
        );
        await _apiManager.chat.updateSessionTitle(req);
      } catch (_) {
        // تجاهل فشل الشبكة، على الأقل العنوان محدث محليًا
      }
    } catch (_) {
      // تجاهل الأخطاء غير الحرجة
    }
  }

  /// إنشاء محادثة جديدة
  Future<void> createNewChat({String? title, String? folderId}) async {
    try {
      state = state.copyWith(isLoadingChat: true, error: null);

      // إنشاء طلب إنشاء جلسة جديدة
      final request = CreateSessionRequest(title: title ?? 'محادثة جديدة');

      // إرسال الطلب للخادم
      final response = await _apiManager.chat.createSession(request);

      if (!response.success || response.data == null) {
        state = state.copyWith(
          isLoadingChat: false,
          error: response.error ?? 'فشل في إنشاء المحادثة',
        );
        return;
      }

      final sessionDto = response.data!;

      // تحويل SessionDto إلى Chat
      final chat = Chat(
        id: sessionDto.sessionId,
        title: sessionDto.title,
        userId: 'user_123', // قيمة افتراضية - SessionDto لا يحتوي على userId
        folderId: sessionDto.folderId,
        createdAt: sessionDto.createdAt,
        updatedAt: sessionDto.updatedAt,
        status: ChatStatus.active,
        messageCount: sessionDto.messageCount ?? 0,
        lastActivityAt: sessionDto.updatedAt,
      );

      // تحديث الحالة مع المحادثة الجديدة
      state = state.copyWith(
        currentChat: chat,
        messages: [],
        isLoadingChat: false,
        error: null,
      );

      // ignore: avoid_print
      print('[ChatNotifier] ✅ تم إنشاء المحادثة الجديدة: ${chat.id}');
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[ChatNotifier] ❌ خطأ في إنشاء المحادثة: $e');
      // ignore: avoid_print
      print('[ChatNotifier] Stack: $stackTrace');

      state = state.copyWith(
        isLoadingChat: false,
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

  // ==================== إدارة المحادثات ====================

  /// أرشفة محادثة
  Future<void> archiveSession(String sessionId) async {
    try {
      // TODO: استدعاء API لأرشفة المحادثة
      // await _apiManager.chat.archiveSession(sessionId);

      // ignore: avoid_print
      print('[ChatNotifier] ✅ تم أرشفة المحادثة: $sessionId');
    } catch (e) {
      // ignore: avoid_print
      print('[ChatNotifier] ❌ خطأ في أرشفة المحادثة: $e');
      rethrow;
    }
  }

  /// استعادة محادثة من الأرشيف
  Future<void> restoreSession(String sessionId) async {
    try {
      // TODO: استدعاء API لاستعادة المحادثة
      // await _apiManager.chat.restoreSession(sessionId);

      // ignore: avoid_print
      print('[ChatNotifier] ✅ تم استعادة المحادثة: $sessionId');
    } catch (e) {
      // ignore: avoid_print
      print('[ChatNotifier] ❌ خطأ في استعادة المحادثة: $e');
      rethrow;
    }
  }

  /// حذف محادثة
  Future<void> deleteSession(String sessionId) async {
    try {
      // TODO: استدعاء API لحذف المحادثة
      // await _apiManager.chat.deleteSession(sessionId);

      // ignore: avoid_print
      print('[ChatNotifier] ✅ تم حذف المحادثة: $sessionId');
    } catch (e) {
      // ignore: avoid_print
      print('[ChatNotifier] ❌ خطأ في حذف المحادثة: $e');
      rethrow;
    }
  }

  /// تحديث عنوان محادثة
  Future<void> updateSessionTitle(String sessionId, String newTitle) async {
    try {
      // TODO: استدعاء API لتحديث العنوان
      // await _apiManager.chat.updateSessionTitle(sessionId, newTitle);

      // تحديث الحالة المحلية
      if (state.currentChat?.id == sessionId) {
        state = state.copyWith(
          currentChat: state.currentChat!.copyWith(title: newTitle),
        );
      }

      // ignore: avoid_print
      print('[ChatNotifier] ✅ تم تحديث عنوان المحادثة: $sessionId');
    } catch (e) {
      // ignore: avoid_print
      print('[ChatNotifier] ❌ خطأ في تحديث العنوان: $e');
      rethrow;
    }
  }

  /// توليد معرف فريد للرسالة
  String _generateMessageId() {
    return 'msg_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000).toString().padLeft(3, '0')}';
  }

  /// إنشاء عنوان ذكي للمحادثة من الرسالة الأولى
  String _generateChatTitleFromMessage(String message) {
    final cleanMessage = message.trim();

    // إذا كانت الرسالة قصيرة، استخدمها كعنوان
    if (cleanMessage.length <= 30) {
      return cleanMessage;
    }

    // خذ أول 30 حرف مع إضافة "..."
    return '${cleanMessage.substring(0, 30)}...';
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
