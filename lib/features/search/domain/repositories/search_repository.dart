import '../models/search_result.dart';
import '../models/search_filter.dart';
import '../models/search_history_item.dart';

/// واجهة repository للبحث
abstract class SearchRepository {
  /// البحث في المحادثات
  ///
  /// [query] نص البحث
  /// [filter] فلتر البحث (اختياري)
  /// [page] رقم الصفحة (للـ pagination)
  /// [pageSize] عدد النتائج في الصفحة
  ///
  /// Returns قائمة بنتائج البحث
  Future<List<SearchResult>> searchChats(
    String query, {
    SearchFilter? filter,
    int page = 1,
    int pageSize = 20,
  });

  /// الحصول على اقتراحات البحث
  ///
  /// [query] نص البحث الجزئي
  ///
  /// Returns قائمة باقتراحات البحث
  Future<List<String>> getSearchSuggestions(String query);

  /// الحصول على تاريخ البحث
  ///
  /// [limit] عدد العناصر المطلوبة (افتراضي 10)
  ///
  /// Returns قائمة بتاريخ البحث
  Future<List<SearchHistoryItem>> getSearchHistory({int limit = 10});

  /// حفظ عملية بحث في التاريخ
  ///
  /// [query] نص البحث
  /// [resultCount] عدد النتائج
  /// [folderId] معرف المجلد (اختياري)
  /// [folderName] اسم المجلد (اختياري)
  Future<void> saveSearchHistory(
    String query,
    int resultCount, {
    String? folderId,
    String? folderName,
  });

  /// مسح تاريخ البحث بالكامل
  Future<void> clearSearchHistory();

  /// حذف عنصر واحد من تاريخ البحث
  ///
  /// [itemId] معرف العنصر
  Future<void> deleteSearchHistoryItem(String itemId);
}
