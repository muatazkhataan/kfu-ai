import '../../domain/models/search_result.dart';
import '../../domain/models/search_filter.dart';
import '../../domain/models/search_history_item.dart';
import '../../domain/repositories/search_repository.dart';
import '../data_sources/search_remote_data_source.dart';
import '../../../../services/storage/local_storage_service.dart';

/// تطبيق repository للبحث
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;
  final LocalStorageService _localStorage;

  SearchRepositoryImpl({
    SearchRemoteDataSource? remoteDataSource,
    LocalStorageService? localStorage,
  }) : _remoteDataSource = remoteDataSource ?? SearchRemoteDataSource(),
       _localStorage = localStorage ?? LocalStorageService();

  @override
  Future<List<SearchResult>> searchChats(
    String query, {
    SearchFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) async {
    print('[SearchRepository] 🔍 بدء البحث في Repository: "$query"');

    try {
      // التحقق من صحة query
      if (query.trim().isEmpty) {
        print('[SearchRepository] ⚠️ نص البحث فارغ');
        return [];
      }

      print('[SearchRepository] 📡 استدعاء RemoteDataSource...');
      // البحث من API
      final response = await _remoteDataSource.searchChats(
        query,
        filter: filter,
        page: page,
        pageSize: pageSize,
      );

      print('[SearchRepository] 📊 استجابة API: success=${response.success}');
      if (!response.success || response.data == null) {
        print('[SearchRepository] ❌ فشل في API: ${response.error}');
        throw Exception(response.error ?? 'فشل البحث');
      }

      // تحويل SessionDto إلى SearchResult
      final sessions = response.data!;
      final results = sessions.map((session) {
        return SearchResult(
          sessionId: session.sessionId,
          title: session.title,
          snippet: _generateSnippet(session, query),
          folderName: null, // سنحصل عليه من FolderProvider لاحقاً
          folderId: session.folderId,
          createdAt: session.createdAt,
          updatedAt: session.updatedAt,
          messageCount: session.messageCount ?? 0,
          highlightedWords: _extractHighlightWords(query),
          isArchived: session.isArchived,
          relevanceScore: _calculateRelevance(session, query),
        );
      }).toList();

      // ترتيب النتائج حسب الفلتر
      final sortedResults = _sortResults(results, filter?.sortBy);

      // حفظ في التاريخ
      await saveSearchHistory(
        query,
        results.length,
        folderId: filter?.folderId,
        folderName: null, // سنحتاج لتمرير اسم المجلد من الخارج
      );

      return sortedResults;
    } catch (e) {
      // إرجاع قائمة فارغة في حالة الخطأ
      // يمكن إضافة logging هنا
      // ignore: avoid_print
      print('[SearchRepository] خطأ في البحث: $e');
      return [];
    }
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      // حالياً نعتمد على تاريخ البحث للاقتراحات
      final history = await getSearchHistory(limit: 20);

      // فلترة العناصر التي تحتوي على query
      final suggestions = history
          .where(
            (item) =>
                item.query.toLowerCase().contains(query.toLowerCase()) &&
                item.query != query,
          )
          .map((item) => item.query)
          .toSet() // إزالة التكرار
          .toList();

      return suggestions;
    } catch (e) {
      // ignore: avoid_print
      print('[SearchRepository] خطأ في الاقتراحات: $e');
      return [];
    }
  }

  @override
  Future<List<SearchHistoryItem>> getSearchHistory({int limit = 10}) async {
    try {
      final historyData = await _localStorage.getSearchHistory(limit: limit);

      return historyData
          .map((data) => SearchHistoryItem.fromJson(data))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('[SearchRepository] خطأ في تحميل التاريخ: $e');
      return [];
    }
  }

  @override
  Future<void> saveSearchHistory(
    String query,
    int resultCount, {
    String? folderId,
    String? folderName,
  }) async {
    try {
      final item = SearchHistoryItem.create(
        query: query,
        resultCount: resultCount,
        folderId: folderId,
        folderName: folderName,
      );

      await _localStorage.saveSearchHistory(item.id, item.toJson());
    } catch (e) {
      // ignore: avoid_print
      print('[SearchRepository] خطأ في حفظ التاريخ: $e');
      // لا نريد إيقاف التطبيق بسبب فشل حفظ التاريخ
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      await _localStorage.clearSearchHistory();
    } catch (e) {
      // ignore: avoid_print
      print('[SearchRepository] خطأ في مسح التاريخ: $e');
      throw Exception('فشل مسح تاريخ البحث');
    }
  }

  @override
  Future<void> deleteSearchHistoryItem(String itemId) async {
    try {
      await _localStorage.deleteSearchHistoryItem(itemId);
    } catch (e) {
      // ignore: avoid_print
      print('[SearchRepository] خطأ في حذف عنصر التاريخ: $e');
      throw Exception('فشل حذف عنصر التاريخ');
    }
  }

  // ==================== Helper Methods ====================

  /// توليد snippet من المحادثة
  String _generateSnippet(dynamic session, String query) {
    // حالياً نستخدم عنوان المحادثة
    // TODO: في المستقبل، يمكن استخدام محتوى الرسائل
    final title = session.title as String? ?? '';

    if (title.toLowerCase().contains(query.toLowerCase())) {
      return title;
    }

    // إذا لم يكن في العنوان، نرجع وصف افتراضي
    final messageCount = session.messageCount ?? 0;
    if (messageCount > 0) {
      return 'محادثة تحتوي على $messageCount رسالة';
    }

    return 'محادثة';
  }

  /// استخراج الكلمات المفتاحية للتمييز
  List<String> _extractHighlightWords(String query) {
    // تقسيم query إلى كلمات
    return query
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
  }

  /// حساب درجة التطابق
  double _calculateRelevance(dynamic session, String query) {
    final title = (session.title as String? ?? '').toLowerCase();
    final queryLower = query.toLowerCase();

    // تطابق تام في العنوان
    if (title == queryLower) {
      return 100.0;
    }

    // يبدأ بنفس النص
    if (title.startsWith(queryLower)) {
      return 90.0;
    }

    // يحتوي على النص
    if (title.contains(queryLower)) {
      return 80.0;
    }

    // تطابق جزئي للكلمات
    final queryWords = queryLower.split(RegExp(r'\s+'));
    final matchingWords = queryWords
        .where((word) => title.contains(word))
        .length;

    if (matchingWords > 0) {
      return 70.0 * (matchingWords / queryWords.length);
    }

    // تطابق افتراضي منخفض
    return 50.0;
  }

  /// ترتيب النتائج
  List<SearchResult> _sortResults(List<SearchResult> results, SortBy? sortBy) {
    final list = List<SearchResult>.from(results);

    switch (sortBy) {
      case SortBy.dateDesc:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortBy.dateAsc:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortBy.relevance:
        list.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
        break;
      case SortBy.titleAsc:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortBy.titleDesc:
        list.sort((a, b) => b.title.compareTo(a.title));
        break;
      default:
        // ترتيب افتراضي حسب الأهمية
        list.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    }

    return list;
  }
}
