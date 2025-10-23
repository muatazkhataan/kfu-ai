import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/search_repository.dart';
import '../../../../state/search_history_state.dart';
import 'search_provider.dart';

/// مزود حالة تاريخ البحث
final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, SearchHistoryState>((ref) {
      return SearchHistoryNotifier(ref.read(searchRepositoryProvider));
    });

/// Notifier لإدارة حالة تاريخ البحث
class SearchHistoryNotifier extends StateNotifier<SearchHistoryState> {
  final SearchRepository _repository;

  SearchHistoryNotifier(this._repository) : super(SearchHistoryState.initial) {
    // تحميل التاريخ عند الإنشاء
    loadHistory();
  }

  /// تحميل تاريخ البحث
  Future<void> loadHistory({int limit = 10}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final items = await _repository.getSearchHistory(limit: limit);

      state = state.copyWith(items: items, isLoading: false, hasLoaded: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasLoaded: true,
        error: 'فشل تحميل التاريخ: ${e.toString()}',
      );
    }
  }

  /// إضافة عنصر جديد للتاريخ (يتم استدعاؤه تلقائياً عند البحث)
  Future<void> addHistoryItem(
    String query,
    int resultCount, {
    String? folderId,
    String? folderName,
  }) async {
    try {
      await _repository.saveSearchHistory(
        query,
        resultCount,
        folderId: folderId,
        folderName: folderName,
      );

      // إعادة تحميل التاريخ لتحديث القائمة
      await loadHistory();
    } catch (e) {
      // ignore: avoid_print
      print('[SearchHistory] خطأ في حفظ التاريخ: $e');
      // لا نريد إظهار خطأ للمستخدم هنا
    }
  }

  /// حذف عنصر من التاريخ
  Future<void> deleteItem(String itemId) async {
    try {
      await _repository.deleteSearchHistoryItem(itemId);

      // تحديث القائمة محلياً
      final updatedItems = state.items
          .where((item) => item.id != itemId)
          .toList();

      state = state.copyWith(items: updatedItems);
    } catch (e) {
      state = state.copyWith(error: 'فشل حذف العنصر: ${e.toString()}');
    }
  }

  /// مسح التاريخ بالكامل
  Future<void> clearHistory() async {
    try {
      state = state.copyWith(isLoading: true);

      await _repository.clearSearchHistory();

      state = state.copyWith(items: [], isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل مسح التاريخ: ${e.toString()}',
      );
    }
  }

  /// إعادة تحميل التاريخ
  Future<void> refresh() async {
    await loadHistory();
  }

  /// مسح رسالة الخطأ
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
