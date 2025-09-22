import '../features/chat/domain/models/chat.dart';
import '../features/chat/domain/models/chat_status.dart';

/// حالة سجل المحادثات
///
/// يمثل هذا الكلاس حالة سجل المحادثات مع البحث والتصفية والترتيب
class ChatHistoryState {
  /// قائمة جميع المحادثات
  final List<Chat> allChats;

  /// قائمة المحادثات المفلترة
  final List<Chat> filteredChats;

  /// نص البحث
  final String searchQuery;

  /// نوع التصفية
  final ChatHistoryFilter filter;

  /// نوع الترتيب
  final ChatHistorySort sort;

  /// الصفحة الحالية
  final int currentPage;

  /// عدد العناصر في الصفحة
  final int itemsPerPage;

  /// هل يتم تحميل المحادثات
  final bool isLoadingChats;

  /// هل يتم البحث
  final bool isSearching;

  /// هل يوجد المزيد من المحادثات للتحميل
  final bool hasMoreChats;

  /// خطأ في تحميل المحادثات
  final String? error;

  /// خطأ في البحث
  final String? searchError;

  /// هل تم تحميل المحادثات لأول مرة
  final bool hasLoadedInitial;

  /// المحادثة المحددة
  final Chat? selectedChat;

  /// المحادثات المحددة (للعمليات المتعددة)
  final List<String> selectedChatIds;

  const ChatHistoryState({
    this.allChats = const [],
    this.filteredChats = const [],
    this.searchQuery = '',
    this.filter = ChatHistoryFilter.all,
    this.sort = ChatHistorySort.dateDesc,
    this.currentPage = 1,
    this.itemsPerPage = 20,
    this.isLoadingChats = false,
    this.isSearching = false,
    this.hasMoreChats = true,
    this.error,
    this.searchError,
    this.hasLoadedInitial = false,
    this.selectedChat,
    this.selectedChatIds = const [],
  });

  /// إنشاء نسخة من الحالة مع تعديلات
  ChatHistoryState copyWith({
    List<Chat>? allChats,
    List<Chat>? filteredChats,
    String? searchQuery,
    ChatHistoryFilter? filter,
    ChatHistorySort? sort,
    int? currentPage,
    int? itemsPerPage,
    bool? isLoadingChats,
    bool? isSearching,
    bool? hasMoreChats,
    String? error,
    String? searchError,
    bool? hasLoadedInitial,
    Chat? selectedChat,
    List<String>? selectedChatIds,
  }) {
    return ChatHistoryState(
      allChats: allChats ?? this.allChats,
      filteredChats: filteredChats ?? this.filteredChats,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      isLoadingChats: isLoadingChats ?? this.isLoadingChats,
      isSearching: isSearching ?? this.isSearching,
      hasMoreChats: hasMoreChats ?? this.hasMoreChats,
      error: error ?? this.error,
      searchError: searchError ?? this.searchError,
      hasLoadedInitial: hasLoadedInitial ?? this.hasLoadedInitial,
      selectedChat: selectedChat ?? this.selectedChat,
      selectedChatIds: selectedChatIds ?? this.selectedChatIds,
    );
  }

  /// الحالة الأولية
  static const ChatHistoryState initial = ChatHistoryState();

  /// التحقق من وجود محادثات
  bool get hasChats => allChats.isNotEmpty;

  /// التحقق من وجود محادثات مفلترة
  bool get hasFilteredChats => filteredChats.isNotEmpty;

  /// التحقق من وجود بحث نشط
  bool get hasActiveSearch => searchQuery.isNotEmpty;

  /// التحقق من وجود خطأ
  bool get hasError => error != null || searchError != null;

  /// التحقق من كون المحادثات محملة
  bool get isLoaded => hasLoadedInitial && !isLoadingChats;

  /// التحقق من كون المحادثات جاهزة للاستخدام
  bool get isReady => isLoaded && !hasError;

  /// التحقق من وجود عمليات جارية
  bool get hasOngoingOperations => isLoadingChats || isSearching;

  /// التحقق من وجود محادثة محددة
  bool get hasSelectedChat => selectedChat != null;

  /// التحقق من وجود محادثات محددة
  bool get hasSelectedChats => selectedChatIds.isNotEmpty;

  /// الحصول على عدد المحادثات
  int get chatCount => allChats.length;

  /// الحصول على عدد المحادثات المفلترة
  int get filteredChatCount => filteredChats.length;

  /// الحصول على عدد المحادثات المحددة
  int get selectedChatCount => selectedChatIds.length;

  /// الحصول على المحادثات النشطة
  List<Chat> get activeChats =>
      allChats.where((chat) => chat.isActive).toList();

  /// الحصول على المحادثات المؤرشفة
  List<Chat> get archivedChats =>
      allChats.where((chat) => chat.isArchivedStatus).toList();

  /// الحصول على المحادثات المحذوفة
  List<Chat> get deletedChats =>
      allChats.where((chat) => chat.isDeleted).toList();

  /// الحصول على المحادثات المفضلة
  List<Chat> get favoriteChats =>
      allChats.where((chat) => chat.isFavorite).toList();

  /// الحصول على المحادثات المقيدة
  List<Chat> get pinnedChats =>
      allChats.where((chat) => chat.isPinned).toList();

  /// الحصول على المحادثات في مجلد معين
  List<Chat> getChatsByFolder(String folderId) {
    return allChats.where((chat) => chat.folderId == folderId).toList();
  }

  /// الحصول على المحادثات حسب النوع
  List<Chat> getChatsByStatus(ChatStatus status) {
    return allChats.where((chat) => chat.status == status).toList();
  }

  /// الحصول على المحادثات المرتبة حسب الترتيب المحدد
  List<Chat> get sortedChats {
    final chats = List<Chat>.from(filteredChats);

    switch (sort) {
      case ChatHistorySort.dateDesc:
        chats.sort(
          (a, b) => (b.lastActivityAt ?? b.updatedAt).compareTo(
            a.lastActivityAt ?? a.updatedAt,
          ),
        );
        break;
      case ChatHistorySort.dateAsc:
        chats.sort(
          (a, b) => (a.lastActivityAt ?? a.updatedAt).compareTo(
            b.lastActivityAt ?? b.updatedAt,
          ),
        );
        break;
      case ChatHistorySort.title:
        chats.sort((a, b) => a.title.compareTo(b.title));
        break;
      case ChatHistorySort.messageCount:
        chats.sort((a, b) => b.messageCount.compareTo(a.messageCount));
        break;
    }

    return chats;
  }

  /// الحصول على المحادثات للصفحة الحالية
  List<Chat> get currentPageChats {
    final sortedChats = this.sortedChats;
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= sortedChats.length) return [];

    return sortedChats.sublist(
      startIndex,
      endIndex > sortedChats.length ? sortedChats.length : endIndex,
    );
  }

  /// الحصول على عدد الصفحات الإجمالي
  int get totalPages {
    return (filteredChatCount / itemsPerPage).ceil();
  }

  /// التحقق من وجود صفحة تالية
  bool get hasNextPage => currentPage < totalPages;

  /// التحقق من وجود صفحة سابقة
  bool get hasPreviousPage => currentPage > 1;

  /// الحصول على المحادثة بالمعرف
  Chat? getChatById(String id) {
    try {
      return allChats.firstWhere((chat) => chat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// البحث في المحادثات
  List<Chat> searchChats(String query) {
    if (query.isEmpty) return allChats;

    final lowercaseQuery = query.toLowerCase();
    return allChats.where((chat) {
      return chat.title.toLowerCase().contains(lowercaseQuery) ||
          chat.description?.toLowerCase().contains(lowercaseQuery) == true ||
          chat.lastMessagePreview?.toLowerCase().contains(lowercaseQuery) ==
              true;
    }).toList();
  }

  /// تطبيق التصفية على المحادثات
  List<Chat> applyFilter(List<Chat> chats, ChatHistoryFilter filter) {
    switch (filter) {
      case ChatHistoryFilter.all:
        return chats;
      case ChatHistoryFilter.active:
        return chats.where((chat) => chat.isActive).toList();
      case ChatHistoryFilter.archived:
        return chats.where((chat) => chat.isArchivedStatus).toList();
      case ChatHistoryFilter.favorite:
        return chats.where((chat) => chat.isFavorite).toList();
      case ChatHistoryFilter.pinned:
        return chats.where((chat) => chat.isPinned).toList();
      case ChatHistoryFilter.recent:
        final now = DateTime.now();
        final oneWeekAgo = now.subtract(const Duration(days: 7));
        return chats
            .where(
              (chat) =>
                  (chat.lastActivityAt ?? chat.updatedAt).isAfter(oneWeekAgo),
            )
            .toList();
    }
  }

  /// الحصول على معاينة الحالة
  String get preview {
    if (hasActiveSearch) {
      return 'البحث: "$searchQuery" - ${filteredChatCount} نتيجة';
    } else if (filter != ChatHistoryFilter.all) {
      return '${filter.displayName}: ${filteredChatCount} محادثة';
    } else if (hasChats) {
      return '${chatCount} محادثة';
    } else if (isLoadingChats) {
      return 'جاري تحميل المحادثات...';
    } else if (hasError) {
      return 'خطأ في تحميل المحادثات';
    } else {
      return 'لا توجد محادثات';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHistoryState &&
          runtimeType == other.runtimeType &&
          allChats == other.allChats &&
          filteredChats == other.filteredChats &&
          searchQuery == other.searchQuery &&
          filter == other.filter &&
          sort == other.sort &&
          currentPage == other.currentPage &&
          itemsPerPage == other.itemsPerPage &&
          isLoadingChats == other.isLoadingChats &&
          isSearching == other.isSearching &&
          hasMoreChats == other.hasMoreChats &&
          error == other.error &&
          searchError == other.searchError &&
          hasLoadedInitial == other.hasLoadedInitial &&
          selectedChat == other.selectedChat &&
          selectedChatIds == other.selectedChatIds;

  @override
  int get hashCode {
    return Object.hash(
      allChats,
      filteredChats,
      searchQuery,
      filter,
      sort,
      currentPage,
      itemsPerPage,
      isLoadingChats,
      isSearching,
      hasMoreChats,
      error,
      searchError,
      hasLoadedInitial,
      selectedChat,
      selectedChatIds,
    );
  }

  @override
  String toString() {
    return 'ChatHistoryState(chatCount: $chatCount, filteredCount: $filteredChatCount, searchQuery: $searchQuery, filter: $filter, sort: $sort)';
  }
}

/// أنواع تصفية سجل المحادثات
enum ChatHistoryFilter {
  /// جميع المحادثات
  all('all', 'جميع المحادثات'),

  /// المحادثات النشطة
  active('active', 'المحادثات النشطة'),

  /// المحادثات المؤرشفة
  archived('archived', 'المحادثات المؤرشفة'),

  /// المحادثات المفضلة
  favorite('favorite', 'المحادثات المفضلة'),

  /// المحادثات المقيدة
  pinned('pinned', 'المحادثات المقيدة'),

  /// المحادثات الأخيرة
  recent('recent', 'المحادثات الأخيرة');

  const ChatHistoryFilter(this.value, this.displayName);

  /// القيمة النصية للفلتر
  final String value;

  /// اسم الفلتر للعرض
  final String displayName;

  /// التحويل من نص إلى فلتر
  static ChatHistoryFilter fromString(String value) {
    return ChatHistoryFilter.values.firstWhere(
      (filter) => filter.value == value,
      orElse: () => ChatHistoryFilter.all,
    );
  }
}

/// أنواع ترتيب سجل المحادثات
enum ChatHistorySort {
  /// الأحدث أولاً
  dateDesc('dateDesc', 'الأحدث أولاً'),

  /// الأقدم أولاً
  dateAsc('dateAsc', 'الأقدم أولاً'),

  /// حسب الاسم
  title('title', 'الاسم'),

  /// حسب عدد الرسائل
  messageCount('messageCount', 'عدد الرسائل');

  const ChatHistorySort(this.value, this.displayName);

  /// القيمة النصية للترتيب
  final String value;

  /// اسم الترتيب للعرض
  final String displayName;

  /// التحويل من نص إلى ترتيب
  static ChatHistorySort fromString(String value) {
    return ChatHistorySort.values.firstWhere(
      (sort) => sort.value == value,
      orElse: () => ChatHistorySort.dateDesc,
    );
  }
}
