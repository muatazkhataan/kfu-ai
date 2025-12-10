import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../chat/domain/models/chat.dart';
import '../../../chat/domain/models/chat_status.dart';
import '../../../../state/chat_history_state.dart';
import '../../../../services/api/api_manager.dart';
import '../../../../services/api/chat/models/session_dto.dart';
import '../../../../services/api/search/models/search_chats_request.dart';
import '../../../search/domain/models/search_filter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// مزود حالة سجل المحادثات
///
/// يدير حالة سجل المحادثات مع البحث والتصفية والترتيب
class ChatHistoryNotifier extends StateNotifier<ChatHistoryState> {
  final ApiManager _apiManager;

  ChatHistoryNotifier(this._apiManager) : super(ChatHistoryState.initial);

  /// تحميل سجل المحادثات
  Future<void> loadChatHistory() async {
    try {
      state = state.copyWith(isLoadingChats: true, error: null);

      print('[ChatHistory] 🔄 تحميل سجل المحادثات من الخادم...');

      // تحميل جميع جلسات المستخدم من API
      final response = await _apiManager.chat.getUserSessions();

      if (response.success && response.data != null) {
        print(
          '[ChatHistory] ✅ تم تحميل ${response.data!.length} محادثة من الخادم',
        );

        // تحويل SessionDto إلى Chat
        final chats = response.data!
            .map((sessionDto) => _convertSessionDtoToChat(sessionDto))
            .toList();

        state = state.copyWith(
          allChats: chats,
          filteredChats: chats,
          isLoadingChats: false,
          hasLoadedInitial: true,
          error: null,
        );

        print('[ChatHistory] 📋 تم تحميل المحادثات بنجاح');
      } else {
        print('[ChatHistory] ❌ فشل في تحميل المحادثات: ${response.error}');

        // في حالة فشل التحميل، استخدم البيانات الوهمية كبديل
        final mockChats = _generateMockChats();

        state = state.copyWith(
          allChats: mockChats,
          filteredChats: mockChats,
          isLoadingChats: false,
          hasLoadedInitial: true,
          error: 'تعذر تحميل المحادثات من الخادم، عرض بيانات تجريبية',
        );
      }
    } catch (e) {
      print('[ChatHistory] ❌ خطأ في تحميل المحادثات: $e');

      // في حالة وجود خطأ، استخدم البيانات الوهمية
      final mockChats = _generateMockChats();

      state = state.copyWith(
        allChats: mockChats,
        filteredChats: mockChats,
        isLoadingChats: false,
        hasLoadedInitial: true,
        error: 'حدث خطأ في التحميل من الخادم: ${e.toString()}',
      );
    }
  }

  /// البحث في المحادثات باستخدام API
  Future<void> searchChats(String query) async {
    try {
      state = state.copyWith(
        isSearching: true,
        searchQuery: query,
        searchError: null,
      );

      // إذا كان البحث فارغاً، عرض جميع المحادثات
      if (query.trim().isEmpty) {
        final filteredResults = state.applyFilter(state.allChats, state.filter);
        state = state.copyWith(
          filteredChats: filteredResults,
          isSearching: false,
        );
        return;
      }

      // البحث من API باستخدام /api/Search/SearchChats
      print('[ChatHistory] 🔍 البحث في API: "$query"');
      print('[ChatHistory] 📝 Query trimmed: "${query.trim()}"');
      print('[ChatHistory] 📝 Query isEmpty: ${query.trim().isEmpty}');
      
      // التحقق من أن Query ليس فارغاً
      final trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) {
        print('[ChatHistory] ⚠️ Query فارغ بعد trim، عرض جميع المحادثات');
        final filteredResults = state.applyFilter(state.allChats, state.filter);
        state = state.copyWith(
          filteredChats: filteredResults,
          isSearching: false,
        );
        return;
      }
      
      final searchRequest = SearchChatsRequest(
        query: trimmedQuery, // استخدام trimmed query
        type: SearchType.all, // صراحة تحديد النوع
        sortBy: SortBy.relevance, // صراحة تحديد الترتيب
        page: 1,
        pageSize: 100, // جلب عدد كبير من النتائج
      );

      print('[ChatHistory] 📤 Request created: ${searchRequest.toString()}');
      print('[ChatHistory] ✅ Request isValid: ${searchRequest.isValid}');

      final response = await _apiManager.search.searchChats(searchRequest);

      if (response.success && response.data != null) {
        print('[ChatHistory] ✅ تم الحصول على ${response.data!.length} نتيجة من API');
        
        // تحويل SessionDto إلى Chat
        final searchResults = response.data!
            .map((sessionDto) => _convertSessionDtoToChat(sessionDto))
            .toList();

        // تطبيق الفلتر الحالي
        final filteredResults = state.applyFilter(searchResults, state.filter);

        state = state.copyWith(
          filteredChats: filteredResults,
          isSearching: false,
          searchError: null,
        );
      } else {
        print('[ChatHistory] ❌ فشل البحث: ${response.error}');
        state = state.copyWith(
          isSearching: false,
          searchError: response.error ?? 'فشل في البحث',
        );
      }
    } catch (e) {
      print('[ChatHistory] ❌ خطأ في البحث: $e');
      state = state.copyWith(
        isSearching: false,
        searchError: 'فشل في البحث: ${e.toString()}',
      );
    }
  }

  /// تطبيق فلتر على المحادثات
  Future<void> applyFilter(ChatHistoryFilter filter) async {
    try {
      state = state.copyWith(filter: filter);

      List<Chat> filteredChats;
      if (state.searchQuery.isNotEmpty) {
        // إذا كان هناك بحث نشط، طبق الفلتر على نتائج البحث
        filteredChats = state.applyFilter(
          state.searchChats(state.searchQuery),
          filter,
        );
      } else {
        // إذا لم يكن هناك بحث، طبق الفلتر على جميع المحادثات
        filteredChats = state.applyFilter(state.allChats, filter);
      }

      state = state.copyWith(
        filteredChats: filteredChats,
        currentPage: 1, // إعادة تعيين الصفحة
      );
    } catch (e) {
      state = state.copyWith(error: 'فشل في تطبيق الفلتر: ${e.toString()}');
    }
  }

  /// تغيير ترتيب المحادثات
  Future<void> changeSort(ChatHistorySort sort) async {
    try {
      state = state.copyWith(sort: sort);
      // الترتيب يتم تطبيقه تلقائياً في getter
    } catch (e) {
      state = state.copyWith(error: 'فشل في تغيير الترتيب: ${e.toString()}');
    }
  }

  /// الانتقال لصفحة معينة
  void goToPage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      state = state.copyWith(currentPage: page);
    }
  }

  /// الانتقال للصفحة التالية
  void nextPage() {
    if (state.hasNextPage) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  /// الانتقال للصفحة السابقة
  void previousPage() {
    if (state.hasPreviousPage) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  /// تحديث عدد العناصر في الصفحة
  void setItemsPerPage(int itemsPerPage) {
    if (itemsPerPage > 0) {
      state = state.copyWith(
        itemsPerPage: itemsPerPage,
        currentPage: 1, // إعادة تعيين الصفحة
      );
    }
  }

  /// إضافة محادثة جديدة للسجل
  Future<void> addChat(Chat chat) async {
    try {
      final updatedChats = [chat, ...state.allChats];
      state = state.copyWith(allChats: updatedChats);

      // تطبيق البحث والفلتر الحاليين
      await _applyCurrentFilters(updatedChats);
    } catch (e) {
      state = state.copyWith(error: 'فشل في إضافة المحادثة: ${e.toString()}');
    }
  }

  /// تحديث محادثة موجودة
  Future<void> updateChat(Chat updatedChat) async {
    try {
      final updatedChats = state.allChats.map((chat) {
        return chat.id == updatedChat.id ? updatedChat : chat;
      }).toList();

      state = state.copyWith(allChats: updatedChats);

      // تطبيق البحث والفلتر الحاليين
      await _applyCurrentFilters(updatedChats);
    } catch (e) {
      state = state.copyWith(error: 'فشل في تحديث المحادثة: ${e.toString()}');
    }
  }

  /// حذف محادثة
  Future<void> deleteChat(String chatId) async {
    try {
      final updatedChats = state.allChats
          .where((chat) => chat.id != chatId)
          .toList();
      state = state.copyWith(allChats: updatedChats);

      // تطبيق البحث والفلتر الحاليين
      await _applyCurrentFilters(updatedChats);

      // إلغاء تحديد المحادثة إذا كانت محذوفة
      if (state.selectedChat?.id == chatId) {
        state = state.copyWith(selectedChat: null);
      }
    } catch (e) {
      state = state.copyWith(error: 'فشل في حذف المحادثة: ${e.toString()}');
    }
  }

  /// تحديد محادثة
  void selectChat(String chatId) {
    final chat = state.getChatById(chatId);
    if (chat != null) {
      state = state.copyWith(selectedChat: chat);
    }
  }

  /// إلغاء تحديد المحادثة
  void deselectChat() {
    state = state.copyWith(selectedChat: null);
  }

  /// تحديد محادثات متعددة
  void selectMultipleChats(List<String> chatIds) {
    state = state.copyWith(selectedChatIds: chatIds);
  }

  /// إضافة محادثة للتحديد المتعدد
  void addToSelection(String chatId) {
    if (!state.selectedChatIds.contains(chatId)) {
      final updatedSelection = [...state.selectedChatIds, chatId];
      state = state.copyWith(selectedChatIds: updatedSelection);
    }
  }

  /// إزالة محادثة من التحديد المتعدد
  void removeFromSelection(String chatId) {
    final updatedSelection = state.selectedChatIds
        .where((id) => id != chatId)
        .toList();
    state = state.copyWith(selectedChatIds: updatedSelection);
  }

  /// إلغاء التحديد المتعدد
  void clearSelection() {
    state = state.copyWith(selectedChatIds: []);
  }

  /// تبديل تحديد محادثة
  void toggleChatSelection(String chatId) {
    if (state.selectedChatIds.contains(chatId)) {
      removeFromSelection(chatId);
    } else {
      addToSelection(chatId);
    }
  }

  /// نقل محادثات لمجلد
  Future<void> moveChatsToFolder(String folderId, List<String> chatIds) async {
    try {
      final updatedChats = state.allChats.map((chat) {
        if (chatIds.contains(chat.id)) {
          return chat.copyWith(folderId: folderId, updatedAt: DateTime.now());
        }
        return chat;
      }).toList();

      state = state.copyWith(allChats: updatedChats);

      // تطبيق البحث والفلتر الحاليين
      await _applyCurrentFilters(updatedChats);

      // مسح التحديد
      clearSelection();
    } catch (e) {
      state = state.copyWith(error: 'فشل في نقل المحادثات: ${e.toString()}');
    }
  }

  /// أرشفة محادثات
  Future<void> archiveChats(List<String> chatIds) async {
    try {
      final updatedChats = state.allChats.map((chat) {
        if (chatIds.contains(chat.id)) {
          return chat.copyWith(
            status: ChatStatus.archived,
            updatedAt: DateTime.now(),
          );
        }
        return chat;
      }).toList();

      state = state.copyWith(allChats: updatedChats);

      // تطبيق البحث والفلتر الحاليين
      await _applyCurrentFilters(updatedChats);

      // مسح التحديد
      clearSelection();
    } catch (e) {
      state = state.copyWith(error: 'فشل في أرشفة المحادثات: ${e.toString()}');
    }
  }

  /// حذف محادثات
  Future<void> deleteChats(List<String> chatIds) async {
    try {
      final updatedChats = state.allChats.map((chat) {
        if (chatIds.contains(chat.id)) {
          return chat.copyWith(
            status: ChatStatus.deleted,
            updatedAt: DateTime.now(),
          );
        }
        return chat;
      }).toList();

      state = state.copyWith(allChats: updatedChats);

      // تطبيق البحث والفلتر الحاليين
      await _applyCurrentFilters(updatedChats);

      // مسح التحديد
      clearSelection();
    } catch (e) {
      state = state.copyWith(error: 'فشل في حذف المحادثات: ${e.toString()}');
    }
  }

  /// تحديث محادثة بعد إرسال رسالة جديدة
  Future<void> updateChatAfterMessage(
    String chatId,
    String messagePreview,
  ) async {
    try {
      final updatedChats = state.allChats.map((chat) {
        if (chat.id == chatId) {
          return chat.copyWith(
            lastMessagePreview: messagePreview,
            lastActivityAt: DateTime.now(),
            updatedAt: DateTime.now(),
            messageCount: chat.messageCount + 1,
          );
        }
        return chat;
      }).toList();

      state = state.copyWith(allChats: updatedChats);

      // تطبيق البحث والفلتر الحاليين
      await _applyCurrentFilters(updatedChats);
    } catch (e) {
      // يمكن تجاهل هذا الخطأ أو تسجيله
      print('فشل في تحديث المحادثة بعد الرسالة: ${e.toString()}');
    }
  }

  /// تطبيق البحث والفلتر الحاليين
  Future<void> _applyCurrentFilters(List<Chat> chats) async {
    List<Chat> filteredChats = chats;

    // إذا كان هناك بحث نشط، استخدم نتائج البحث من API
    if (state.searchQuery.isNotEmpty) {
      // البحث يتم من خلال searchChats method الذي يستدعي API
      // لذلك لا نحتاج لإعادة البحث هنا
      // فقط نطبق الفلتر على النتائج الحالية
      filteredChats = state.applyFilter(state.filteredChats, state.filter);
    } else {
      // تطبيق الفلتر على جميع المحادثات
      filteredChats = state.applyFilter(chats, state.filter);
    }

    state = state.copyWith(filteredChats: filteredChats);
  }

  /// إعادة تعيين الحالة
  void reset() {
    state = ChatHistoryState.initial;
  }

  /// مسح الأخطاء
  void clearErrors() {
    state = state.copyWith(error: null, searchError: null);
  }

  /// إعادة تحميل السجل
  Future<void> refresh() async {
    await loadChatHistory();
  }

  /// تحويل SessionDto إلى Chat
  Chat _convertSessionDtoToChat(SessionDto sessionDto) {
    final now = DateTime.now();

    // حساب آخر نشاط
    final lastActivity = sessionDto.updatedAt;
    final timeDiff = now.difference(lastActivity);

    String lastActivityText;
    if (timeDiff.inMinutes < 1) {
      lastActivityText = 'الآن';
    } else if (timeDiff.inHours < 1) {
      lastActivityText = 'منذ ${timeDiff.inMinutes} دقيقة';
    } else if (timeDiff.inDays < 1) {
      lastActivityText = 'منذ ${timeDiff.inHours} ساعة';
    } else if (timeDiff.inDays < 7) {
      lastActivityText = 'منذ ${timeDiff.inDays} يوم';
    } else {
      lastActivityText = 'منذ ${(timeDiff.inDays / 7).floor()} أسبوع';
    }

    // استخراج معاينة الرسالة الأخيرة
    String? lastMessagePreview;
    if (sessionDto.messages != null && sessionDto.messages!.isNotEmpty) {
      final lastMessage = sessionDto.messages!.last;
      lastMessagePreview = lastMessage.content.length > 100
          ? '${lastMessage.content.substring(0, 100)}...'
          : lastMessage.content;
    }

    return Chat(
      id: sessionDto.sessionId,
      title: sessionDto.title.isNotEmpty ? sessionDto.title : 'محادثة جديدة',
      description: sessionDto.metadata?['description']
          ?.toString(), // استخراج الوصف من metadata
      userId: 'current_user', // سيتم الحصول عليه من AuthProvider
      folderId: sessionDto.folderId,
      createdAt: sessionDto.createdAt,
      updatedAt: sessionDto.updatedAt,
      lastActivityAt: lastActivity,
      messageCount: sessionDto.messageCount ?? 0,
      lastMessagePreview: lastMessagePreview ?? 'لا توجد رسائل بعد',
      lastMessageType: sessionDto.messages?.isNotEmpty == true
          ? (sessionDto.messages!.last.isFromUser ? 'user' : 'assistant')
          : null,
      lastMessageAt: sessionDto.messages?.isNotEmpty == true
          ? sessionDto.messages!.last.createdAt
          : null,
      lastSenderName: sessionDto.messages?.isNotEmpty == true
          ? (sessionDto.messages!.last.isFromUser ? 'أنت' : 'مساعد كفو')
          : null,
      status: _getChatStatusFromSessionDto(sessionDto),
      // يمكن إضافة خصائص إضافية من metadata إذا كانت متوفرة
      isPinned: sessionDto.metadata?['isPinned'] == true,
      isFavorite: sessionDto.metadata?['isFavorite'] == true,
      metadata: {...?sessionDto.metadata, 'lastActivityText': lastActivityText},
    );
  }

  /// تحويل حالة الجلسة من SessionDto
  ChatStatus _getChatStatusFromSessionDto(SessionDto sessionDto) {
    if (sessionDto.metadata?['isArchived'] == true) {
      return ChatStatus.archived;
    }
    if (sessionDto.metadata?['isDeleted'] == true) {
      return ChatStatus.deleted;
    }
    return ChatStatus.active;
  }

  /// توليد محادثات وهمية للاختبار
  List<Chat> _generateMockChats() {
    final now = DateTime.now();

    return [
      Chat(
        id: 'chat_1',
        title: 'مساعدة في البرمجة',
        description: 'مشكلة في حل خوارزمية',
        userId: 'user_123',
        folderId: 'programming',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        lastActivityAt: now.subtract(const Duration(minutes: 30)),
        messageCount: 15,
        lastMessagePreview: 'شكراً لك على المساعدة!',
        lastMessageType: 'user',
        lastMessageAt: now.subtract(const Duration(minutes: 30)),
        lastSenderName: 'أحمد محمد',
      ),
      Chat(
        id: 'chat_2',
        title: 'استفسار أكاديمي',
        description: 'سؤال حول المناهج الدراسية',
        userId: 'user_123',
        folderId: 'academic',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 3)),
        lastActivityAt: now.subtract(const Duration(hours: 3)),
        messageCount: 8,
        lastMessagePreview: 'هل يمكنك توضيح المزيد؟',
        lastMessageType: 'assistant',
        lastMessageAt: now.subtract(const Duration(hours: 3)),
        lastSenderName: 'مساعد كفو',
      ),
      Chat(
        id: 'chat_3',
        title: 'مشكلة في قاعدة البيانات',
        description: 'خطأ في استعلام SQL',
        userId: 'user_123',
        folderId: 'databases',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
        lastActivityAt: now.subtract(const Duration(days: 1)),
        messageCount: 12,
        lastMessagePreview: 'تم حل المشكلة بنجاح',
        lastMessageType: 'assistant',
        lastMessageAt: now.subtract(const Duration(days: 1)),
        lastSenderName: 'مساعد كفو',
      ),
      Chat(
        id: 'chat_4',
        title: 'مراجعة خوارزمية',
        description: 'تحسين أداء الخوارزمية',
        userId: 'user_123',
        folderId: 'algorithms',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 2)),
        lastActivityAt: now.subtract(const Duration(days: 2)),
        messageCount: 20,
        lastMessagePreview: 'ممتاز! الخوارزمية تعمل بشكل أفضل الآن',
        lastMessageType: 'user',
        lastMessageAt: now.subtract(const Duration(days: 2)),
        lastSenderName: 'أحمد محمد',
        isFavorite: true,
      ),
      Chat(
        id: 'chat_5',
        title: 'مساعدة في الرياضيات',
        description: 'حل معادلة تفاضلية',
        userId: 'user_123',
        folderId: 'academic',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 4)),
        lastActivityAt: now.subtract(const Duration(days: 4)),
        messageCount: 6,
        lastMessagePreview: 'هل هذا الحل صحيح؟',
        lastMessageType: 'user',
        lastMessageAt: now.subtract(const Duration(days: 4)),
        lastSenderName: 'أحمد محمد',
        isPinned: true,
      ),
    ];
  }
}

/// مزود حالة سجل المحادثات
final chatHistoryProvider =
    StateNotifierProvider<ChatHistoryNotifier, ChatHistoryState>((ref) {
      final apiManager = ref.watch(apiManagerProvider);
      return ChatHistoryNotifier(apiManager);
    });

/// مزود قائمة المحادثات
final chatsProvider = Provider<List<Chat>>((ref) {
  return ref.watch(chatHistoryProvider).allChats;
});

/// مزود المحادثات المفلترة
final filteredChatsProvider = Provider<List<Chat>>((ref) {
  return ref.watch(chatHistoryProvider).filteredChats;
});

/// مزود المحادثات المرتبة
final sortedChatsProvider = Provider<List<Chat>>((ref) {
  return ref.watch(chatHistoryProvider).sortedChats;
});

/// مزود المحادثات للصفحة الحالية
final currentPageChatsProvider = Provider<List<Chat>>((ref) {
  return ref.watch(chatHistoryProvider).currentPageChats;
});

/// مزود المحادثة المحددة
final selectedChatProvider = Provider<Chat?>((ref) {
  return ref.watch(chatHistoryProvider).selectedChat;
});

/// مزود المحادثات المحددة
final selectedChatsProvider = Provider<List<String>>((ref) {
  return ref.watch(chatHistoryProvider).selectedChatIds;
});

/// مزود نص البحث
final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(chatHistoryProvider).searchQuery;
});

/// مزود الفلتر الحالي
final currentFilterProvider = Provider<ChatHistoryFilter>((ref) {
  return ref.watch(chatHistoryProvider).filter;
});

/// مزود الترتيب الحالي
final currentSortProvider = Provider<ChatHistorySort>((ref) {
  return ref.watch(chatHistoryProvider).sort;
});

/// مزود معلومات الصفحة
final paginationInfoProvider = Provider<Map<String, dynamic>>((ref) {
  final state = ref.watch(chatHistoryProvider);
  return {
    'currentPage': state.currentPage,
    'totalPages': state.totalPages,
    'itemsPerPage': state.itemsPerPage,
    'totalItems': state.filteredChatCount,
    'hasNextPage': state.hasNextPage,
    'hasPreviousPage': state.hasPreviousPage,
  };
});

/// مزود حالة التحميل
final chatHistoryLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(chatHistoryProvider);
  return state.isLoadingChats || state.isSearching;
});

/// مزود الأخطاء
final chatHistoryErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(chatHistoryProvider);
  return state.error ?? state.searchError;
});
