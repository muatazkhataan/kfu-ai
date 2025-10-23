# 🔍 المرحلة 1: البحث وإدارة المحادثات - خطة تفصيلية

## 📊 نظرة عامة

**الهدف:** تطوير نظام بحث متقدم وإدارة كاملة للمحادثات

**الوقت المتوقع:** 4-5 أيام

**الأولوية:** 🔴 عالية جداً

---

## 🎯 الميزات المطلوبة

### 1️⃣ البحث في المحادثات

#### ✅ الوظائف الأساسية:
- [x] زر البحث في القائمة الجانبية (موجود)
- [ ] شاشة البحث الكاملة
- [ ] البحث في العناوين والمحتوى
- [ ] عرض النتائج مع تمييز الكلمات
- [ ] فلترة النتائج (المجلد، التاريخ)

#### ✅ الوظائف المتقدمة:
- [ ] حفظ تاريخ البحث
- [ ] اقتراحات البحث التلقائية
- [ ] البحث الصوتي (مستقبلاً)

---

### 2️⃣ إدارة المحادثات

#### ✅ العمليات المطلوبة:
- [ ] أرشفة المحادثة
- [ ] استعادة من الأرشيف
- [ ] حذف المحادثة
- [ ] نقل إلى مجلد
- [ ] تعديل العنوان
- [ ] نسخ رابط المحادثة

---

## 🏗️ البنية التفصيلية

### 📁 الهيكل الكامل للملفات:

```
lib/features/search/
  ├── data/
  │   ├── repositories/
  │   │   └── search_repository_impl.dart
  │   └── data_sources/
  │       └── search_remote_data_source.dart
  │
  ├── domain/
  │   ├── models/
  │   │   ├── search_result.dart
  │   │   ├── search_filter.dart
  │   │   └── search_history_item.dart
  │   └── repositories/
  │       └── search_repository.dart
  │
  └── presentation/
      ├── providers/
      │   ├── search_provider.dart
      │   ├── search_filter_provider.dart
      │   └── search_history_provider.dart
      │
      ├── screens/
      │   └── search_screen.dart
      │
      └── widgets/
          ├── search_bar_widget.dart
          ├── search_results_list.dart
          ├── search_result_item.dart
          ├── search_filter_sheet.dart
          ├── search_history_list.dart
          └── empty_search_state.dart

lib/features/chat/presentation/
  └── widgets/
      ├── chat_options_menu.dart
      ├── chat_action_button.dart
      ├── delete_confirmation_dialog.dart
      ├── archive_confirmation_dialog.dart
      ├── move_to_folder_sheet.dart
      └── edit_title_dialog.dart
```

---

## 📝 خطوات التنفيذ التفصيلية

### **الخطوة 1: إنشاء نماذج البحث (Models)**

#### 1.1 SearchResult Model
```dart
// lib/features/search/domain/models/search_result.dart

class SearchResult {
  final String sessionId;
  final String title;
  final String snippet;          // مقتطف من المحادثة
  final String? folderName;
  final DateTime createdAt;
  final int messageCount;
  final List<String> highlightedWords; // الكلمات المميزة
  
  // Constructor, fromJson, toJson
}
```

#### 1.2 SearchFilter Model
```dart
// lib/features/search/domain/models/search_filter.dart

class SearchFilter {
  final String? folderId;
  final DateTime? startDate;
  final DateTime? endDate;
  final SearchType type; // all, archived, unarchived
  final SortBy sortBy;   // date, relevance, title
  
  // Constructor, copyWith, toMap
}
```

#### 1.3 SearchHistoryItem Model
```dart
// lib/features/search/domain/models/search_history_item.dart

class SearchHistoryItem {
  final String query;
  final DateTime timestamp;
  final int resultCount;
  
  // Constructor, fromJson, toJson
}
```

**⏱️ الوقت:** 1-2 ساعة

---

### **الخطوة 2: إنشاء Repository و Data Source**

#### 2.1 SearchRepository (Interface)
```dart
// lib/features/search/domain/repositories/search_repository.dart

abstract class SearchRepository {
  Future<List<SearchResult>> searchChats(String query, SearchFilter? filter);
  Future<List<String>> getSearchSuggestions(String query);
  Future<List<SearchHistoryItem>> getSearchHistory();
  Future<void> saveSearchHistory(String query, int resultCount);
  Future<void> clearSearchHistory();
}
```

#### 2.2 SearchRemoteDataSource
```dart
// lib/features/search/data/data_sources/search_remote_data_source.dart

class SearchRemoteDataSource {
  final ApiManager _apiManager;
  
  Future<List<SearchResultDto>> searchChats(
    String query, 
    Map<String, dynamic> filters,
  ) async {
    // استخدام: /api/Search/SearchChats
    final response = await _apiManager.search.searchChats(
      query: query,
      filters: filters,
    );
    return response;
  }
}
```

#### 2.3 SearchRepositoryImpl
```dart
// lib/features/search/data/repositories/search_repository_impl.dart

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;
  final LocalStorageService _localStorage;
  
  @override
  Future<List<SearchResult>> searchChats(
    String query, 
    SearchFilter? filter,
  ) async {
    // تنفيذ البحث
    // معالجة النتائج
    // حفظ في التاريخ
  }
  
  // تنفيذ باقي الدوال...
}
```

**⏱️ الوقت:** 2-3 ساعات

---

### **الخطوة 3: إنشاء Providers**

#### 3.1 SearchProvider
```dart
// lib/features/search/presentation/providers/search_provider.dart

@riverpod
class Search extends _$Search {
  @override
  AsyncValue<List<SearchResult>> build() {
    return const AsyncValue.data([]);
  }
  
  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    
    try {
      final results = await ref
          .read(searchRepositoryProvider)
          .searchChats(query, null);
          
      state = AsyncValue.data(results);
      
      // حفظ في التاريخ
      await _saveToHistory(query, results.length);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> searchWithFilter(
    String query, 
    SearchFilter filter,
  ) async {
    // البحث مع الفلتر
  }
}
```

#### 3.2 SearchFilterProvider
```dart
// lib/features/search/presentation/providers/search_filter_provider.dart

@riverpod
class SearchFilterNotifier extends _$SearchFilterNotifier {
  @override
  SearchFilter build() {
    return SearchFilter(
      type: SearchType.all,
      sortBy: SortBy.relevance,
    );
  }
  
  void updateFilter(SearchFilter newFilter) {
    state = newFilter;
  }
  
  void resetFilter() {
    state = SearchFilter(
      type: SearchType.all,
      sortBy: SortBy.relevance,
    );
  }
}
```

#### 3.3 SearchHistoryProvider
```dart
// lib/features/search/presentation/providers/search_history_provider.dart

@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  Future<List<SearchHistoryItem>> build() async {
    return await ref
        .read(searchRepositoryProvider)
        .getSearchHistory();
  }
  
  Future<void> clearHistory() async {
    await ref
        .read(searchRepositoryProvider)
        .clearSearchHistory();
        
    ref.invalidateSelf();
  }
}
```

**⏱️ الوقت:** 2-3 ساعات

---

### **الخطوة 4: إنشاء Widgets**

#### 4.1 SearchBarWidget
```dart
// lib/features/search/presentation/widgets/search_bar_widget.dart

class SearchBarWidget extends ConsumerStatefulWidget {
  final Function(String) onSearch;
  final Function(String) onChanged;
  
  // TextField مع:
  // - أيقونة بحث
  // - زر مسح
  // - Auto-focus
  // - Submit on enter
}
```

#### 4.2 SearchResultItem
```dart
// lib/features/search/presentation/widgets/search_result_item.dart

class SearchResultItem extends StatelessWidget {
  final SearchResult result;
  final List<String> highlightedWords;
  
  // عرض:
  // - العنوان مع highlight
  // - المقتطف مع highlight
  // - اسم المجلد
  // - التاريخ
  // - عدد الرسائل
  // - أيقونة السهم
}
```

#### 4.3 SearchFilterSheet
```dart
// lib/features/search/presentation/widgets/search_filter_sheet.dart

class SearchFilterSheet extends ConsumerWidget {
  // Bottom sheet مع:
  // - اختيار المجلد
  // - اختيار النطاق الزمني
  // - اختيار النوع (الكل، المؤرشف، غير المؤرشف)
  // - اختيار الترتيب
  // - زر تطبيق
  // - زر إعادة تعيين
}
```

#### 4.4 SearchHistoryList
```dart
// lib/features/search/presentation/widgets/search_history_list.dart

class SearchHistoryList extends ConsumerWidget {
  final Function(String) onHistoryItemTap;
  
  // عرض:
  // - قائمة تاريخ البحث
  // - أيقونة ساعة لكل عنصر
  // - عدد النتائج
  // - زر حذف لكل عنصر
  // - زر مسح الكل
}
```

#### 4.5 EmptySearchState
```dart
// lib/features/search/presentation/widgets/empty_search_state.dart

class EmptySearchState extends StatelessWidget {
  final String? query;
  
  // عرض:
  // - رسالة "لا توجد نتائج" إذا كان هناك query
  // - رسالة "ابدأ البحث" إذا لم يكن هناك query
  // - أيقونة مناسبة
  // - اقتراحات
}
```

**⏱️ الوقت:** 3-4 ساعات

---

### **الخطوة 5: إنشاء SearchScreen**

#### 5.1 SearchScreen
```dart
// lib/features/search/presentation/screens/search_screen.dart

class SearchScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchFocusNode.requestFocus();
  }
  
  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchProvider);
    final searchHistory = ref.watch(searchHistoryProvider);
    final currentFilter = ref.watch(searchFilterProvider);
    
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // شريط البحث
          SearchBarWidget(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onSearch: _onSearch,
            onChanged: _onSearchChanged,
          ),
          
          // زر الفلتر
          _buildFilterButton(),
          
          // المحتوى
          Expanded(
            child: searchResults.when(
              data: (results) {
                if (results.isEmpty) {
                  return _buildEmptyState();
                }
                return SearchResultsList(results: results);
              },
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),
        ],
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('البحث في المحادثات'),
      actions: [
        IconButton(
          icon: Icon(AppIcons.getIcon(AppIcon.filter)),
          onPressed: _showFilterSheet,
        ),
      ],
    );
  }
  
  Widget _buildFilterButton() {
    final filter = ref.watch(searchFilterProvider);
    final hasActiveFilter = filter.folderId != null ||
        filter.startDate != null ||
        filter.type != SearchType.all;
        
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (hasActiveFilter)
            Chip(
              label: const Text('الفلتر نشط'),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                ref.read(searchFilterProvider.notifier).resetFilter();
                _onSearch(_searchController.text);
              },
            ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    if (_searchController.text.isEmpty) {
      // عرض تاريخ البحث
      return SearchHistoryList(
        onHistoryItemTap: (query) {
          _searchController.text = query;
          _onSearch(query);
        },
      );
    } else {
      // عرض "لا توجد نتائج"
      return EmptySearchState(query: _searchController.text);
    }
  }
  
  void _onSearch(String query) {
    if (query.isEmpty) return;
    
    final filter = ref.read(searchFilterProvider);
    ref.read(searchProvider.notifier).searchWithFilter(query, filter);
  }
  
  void _onSearchChanged(String query) {
    // يمكن إضافة debounce للبحث التلقائي
  }
  
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SearchFilterSheet(
        currentFilter: ref.read(searchFilterProvider),
        onApply: (newFilter) {
          ref.read(searchFilterProvider.notifier).updateFilter(newFilter);
          _onSearch(_searchController.text);
          Navigator.pop(context);
        },
      ),
    );
  }
}
```

**⏱️ الوقت:** 2-3 ساعات

---

### **الخطوة 6: إدارة المحادثات - Widgets**

#### 6.1 ChatOptionsMenu
```dart
// lib/features/chat/presentation/widgets/chat_options_menu.dart

class ChatOptionsMenu extends ConsumerWidget {
  final String sessionId;
  final String sessionTitle;
  final bool isArchived;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<ChatAction>(
      icon: Icon(AppIcons.getIcon(AppIcon.moreVert)),
      onSelected: (action) => _handleAction(action, context, ref),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ChatAction.rename,
          child: Row(
            children: [
              Icon(AppIcons.getIcon(AppIcon.edit)),
              const SizedBox(width: 8),
              const Text('تعديل العنوان'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ChatAction.moveToFolder,
          child: Row(
            children: [
              Icon(AppIcons.getIcon(AppIcon.folder)),
              const SizedBox(width: 8),
              const Text('نقل إلى مجلد'),
            ],
          ),
        ),
        if (!isArchived)
          PopupMenuItem(
            value: ChatAction.archive,
            child: Row(
              children: [
                Icon(AppIcons.getIcon(AppIcon.archive)),
                const SizedBox(width: 8),
                const Text('أرشفة'),
              ],
            ),
          )
        else
          PopupMenuItem(
            value: ChatAction.restore,
            child: Row(
              children: [
                Icon(AppIcons.getIcon(AppIcon.unarchive)),
                const SizedBox(width: 8),
                const Text('استعادة'),
              ],
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: ChatAction.delete,
          child: Row(
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.delete),
                color: context.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                'حذف',
                style: TextStyle(color: context.colorScheme.error),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Future<void> _handleAction(
    ChatAction action,
    BuildContext context,
    WidgetRef ref,
  ) async {
    switch (action) {
      case ChatAction.rename:
        await _showRenameDialog(context, ref);
        break;
      case ChatAction.moveToFolder:
        await _showMoveToFolderSheet(context, ref);
        break;
      case ChatAction.archive:
        await _archiveChat(context, ref);
        break;
      case ChatAction.restore:
        await _restoreChat(context, ref);
        break;
      case ChatAction.delete:
        await _showDeleteDialog(context, ref);
        break;
    }
  }
}
```

#### 6.2 EditTitleDialog
```dart
// lib/features/chat/presentation/widgets/edit_title_dialog.dart

class EditTitleDialog extends StatefulWidget {
  final String currentTitle;
  final Function(String) onSave;
  
  // Dialog مع:
  // - TextField للعنوان الجديد
  // - زر حفظ
  // - زر إلغاء
  // - Validation
}
```

#### 6.3 MoveToFolderSheet
```dart
// lib/features/chat/presentation/widgets/move_to_folder_sheet.dart

class MoveToFolderSheet extends ConsumerWidget {
  final String sessionId;
  final String? currentFolderId;
  
  // Bottom sheet مع:
  // - قائمة المجلدات
  // - خيار "بدون مجلد"
  // - تمييز المجلد الحالي
  // - زر نقل
}
```

#### 6.4 DeleteConfirmationDialog
```dart
// lib/features/chat/presentation/widgets/delete_confirmation_dialog.dart

class DeleteConfirmationDialog extends StatelessWidget {
  final String sessionTitle;
  final VoidCallback onConfirm;
  
  // Dialog تأكيد مع:
  // - رسالة تحذيرية
  // - اسم المحادثة
  // - زر حذف (أحمر)
  // - زر إلغاء
}
```

**⏱️ الوقت:** 3-4 ساعات

---

### **الخطوة 7: إضافة دوال الإدارة في ChatProvider**

```dart
// تحديث lib/features/chat/presentation/providers/chat_provider.dart

class ChatNotifier extends StateNotifier<ChatState> {
  // ... existing code ...
  
  /// أرشفة محادثة
  Future<void> archiveChat(String sessionId) async {
    try {
      await _apiManager.chat.archiveSession(sessionId);
      
      // تحديث الحالة المحلية
      state = state.copyWith(
        recentChats: state.recentChats
            .where((chat) => chat.id != sessionId)
            .toList(),
      );
      
      _showSuccessMessage('تم أرشفة المحادثة بنجاح');
    } catch (e) {
      _showErrorMessage('فشل أرشفة المحادثة: $e');
    }
  }
  
  /// استعادة محادثة من الأرشيف
  Future<void> restoreChat(String sessionId) async {
    try {
      await _apiManager.chat.restoreSession(sessionId);
      
      // إعادة تحميل المحادثات
      await loadRecentChats();
      
      _showSuccessMessage('تم استعادة المحادثة بنجاح');
    } catch (e) {
      _showErrorMessage('فشل استعادة المحادثة: $e');
    }
  }
  
  /// حذف محادثة
  Future<void> deleteChat(String sessionId) async {
    try {
      await _apiManager.chat.deleteSession(sessionId);
      
      // تحديث الحالة المحلية
      state = state.copyWith(
        recentChats: state.recentChats
            .where((chat) => chat.id != sessionId)
            .toList(),
      );
      
      _showSuccessMessage('تم حذف المحادثة بنجاح');
    } catch (e) {
      _showErrorMessage('فشل حذف المحادثة: $e');
    }
  }
  
  /// نقل محادثة إلى مجلد
  Future<void> moveChatToFolder(String sessionId, String folderId) async {
    try {
      await _apiManager.chat.moveSessionToFolder(sessionId, folderId);
      
      // إعادة تحميل المحادثات
      await loadRecentChats();
      
      _showSuccessMessage('تم نقل المحادثة بنجاح');
    } catch (e) {
      _showErrorMessage('فشل نقل المحادثة: $e');
    }
  }
  
  /// تعديل عنوان محادثة
  Future<void> updateChatTitle(String sessionId, String newTitle) async {
    try {
      await _apiManager.chat.updateSessionTitle(sessionId, newTitle);
      
      // تحديث الحالة المحلية
      state = state.copyWith(
        recentChats: state.recentChats.map((chat) {
          if (chat.id == sessionId) {
            return chat.copyWith(title: newTitle);
          }
          return chat;
        }).toList(),
      );
      
      _showSuccessMessage('تم تحديث العنوان بنجاح');
    } catch (e) {
      _showErrorMessage('فشل تحديث العنوان: $e');
    }
  }
}
```

**⏱️ الوقت:** 2 ساعة

---

### **الخطوة 8: تحديث ChatScreen لإضافة قائمة الخيارات**

```dart
// تحديث lib/features/chat/presentation/screens/chat_screen.dart

// في _buildChatList و _buildRecentChatsSection:

ListTile(
  // ... existing properties ...
  trailing: ChatOptionsMenu(
    sessionId: chat.id,
    sessionTitle: chat.title,
    isArchived: chat.isArchived,
  ),
)
```

**⏱️ الوقت:** 30 دقيقة

---

### **الخطوة 9: ربط زر البحث بالشاشة الجديدة**

```dart
// تحديث lib/features/chat/presentation/screens/chat_screen.dart

// في زر البحث:
OutlinedButton.icon(
  onPressed: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );
  },
  icon: Icon(AppIcons.getIcon(AppIcon.search), size: 16),
  label: const Text('بحث في المحادثات'),
  // ... existing style ...
),
```

**⏱️ الوقت:** 15 دقيقة

---

### **الخطوة 10: تحديث API Service**

```dart
// تحديث lib/services/api/search/search_api_service.dart (إنشاء إذا لم يكن موجوداً)

class SearchApiService {
  final ApiClient _client;
  
  SearchApiService(this._client);
  
  /// البحث في المحادثات
  Future<ApiResponse<List<SearchResultDto>>> searchChats({
    required String query,
    String? folderId,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = {
      'query': query,
      'page': page,
      'pageSize': pageSize,
      if (folderId != null) 'folderId': folderId,
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
      if (type != null) 'type': type,
      if (sortBy != null) 'sortBy': sortBy,
    };
    
    return _client.get(
      '/api/Search/SearchChats',
      queryParameters: queryParams,
      fromJson: (json) => (json as List)
          .map((item) => SearchResultDto.fromJson(item))
          .toList(),
    );
  }
}
```

**⏱️ الوقت:** 1 ساعة

---

## ✅ Checklist النهائي

### قبل البدء:
- [ ] مراجعة جميع API endpoints المطلوبة
- [ ] التأكد من توفر الـ tokens والـ permissions
- [ ] إنشاء branch جديد في Git

### خلال التطوير:
- [ ] إنشاء جميع الـ models
- [ ] إنشاء الـ repository والـ data source
- [ ] إنشاء الـ providers
- [ ] إنشاء جميع الـ widgets
- [ ] إنشاء الـ screens
- [ ] ربط كل شيء معاً
- [ ] اختبار كل ميزة على حدة

### بعد الانتهاء:
- [ ] اختبار شامل لجميع الميزات
- [ ] اختبار على أجهزة مختلفة
- [ ] مراجعة الكود
- [ ] توثيق الميزات الجديدة
- [ ] Commit & Push
- [ ] إنشاء Pull Request

---

## 🧪 سيناريوهات الاختبار

### البحث:
1. [ ] البحث في العناوين فقط
2. [ ] البحث في المحتوى
3. [ ] البحث بدون نتائج
4. [ ] البحث مع فلتر المجلد
5. [ ] البحث مع فلتر التاريخ
6. [ ] حفظ وعرض تاريخ البحث
7. [ ] مسح تاريخ البحث

### إدارة المحادثات:
1. [ ] أرشفة محادثة
2. [ ] استعادة محادثة مؤرشفة
3. [ ] حذف محادثة
4. [ ] تأكيد الحذف
5. [ ] نقل محادثة إلى مجلد
6. [ ] تعديل عنوان المحادثة
7. [ ] عرض رسائل النجاح/الفشل

---

## 📊 المقاييس المتوقعة

- **عدد الملفات الجديدة:** ~25 ملف
- **عدد الأسطر المتوقعة:** ~2000-2500 سطر
- **عدد الـ Widgets:** ~15 widget
- **عدد الـ Providers:** 5-6 providers
- **عدد الـ Models:** 4-5 models

---

## 🚀 بعد الانتهاء من المرحلة 1

### ✅ ما سيتم إنجازه:
- نظام بحث متقدم وكامل
- إدارة شاملة للمحادثات
- تجربة مستخدم محسّنة
- قاعدة قوية للمراحل القادمة

### ➡️ الخطوة التالية:
- الانتقال إلى **المرحلة 2: إدارة المجلدات**

---

**📅 تاريخ الإنشاء:** 2025-10-21
**✍️ الإصدار:** 1.0
**🎯 الحالة:** جاهز للتنفيذ

