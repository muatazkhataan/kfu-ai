import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/search_filter.dart';
import '../../domain/repositories/search_repository.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../../../state/search_state.dart';

/// مزود repository البحث
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl();
});

/// مزود حالة البحث
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  return SearchNotifier(ref.read(searchRepositoryProvider));
});

/// مزود الفلتر الحالي
final searchFilterProvider = StateProvider<SearchFilter>((ref) {
  return SearchFilter.defaultFilter();
});

/// Notifier لإدارة حالة البحث
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRepository _repository;

  SearchNotifier(this._repository) : super(SearchState.initial);

  /// البحث في المحادثات
  Future<void> search(String query, {SearchFilter? filter}) async {
    print('[SearchProvider] 🔍 بدء البحث: "$query"');

    if (query.trim().isEmpty) {
      print('[SearchProvider] ⚠️ نص البحث فارغ');
      state = SearchState.initial;
      return;
    }

    try {
      print('[SearchProvider] 🔄 تحديث الحالة إلى searching...');
      state = state.copyWith(
        isSearching: true,
        currentQuery: query,
        currentFilter: filter,
        currentPage: 1,
        clearError: true,
      );

      print('[SearchProvider] 📡 استدعاء repository للبحث...');
      final results = await _repository.searchChats(
        query,
        filter: filter,
        page: 1,
        pageSize: 20,
      );

      print('[SearchProvider] ✅ تم الحصول على ${results.length} نتيجة');
      state = state.copyWith(
        results: results,
        isSearching: false,
        hasSearched: true,
        hasMore:
            results.length >=
            20, // إذا كان عدد النتائج = pageSize، قد يكون هناك المزيد
      );
      print('[SearchProvider] ✅ تم تحديث الحالة بنجاح');
    } catch (e) {
      print('[SearchProvider] ❌ خطأ في البحث: $e');
      state = state.copyWith(
        isSearching: false,
        hasSearched: true,
        error: 'فشل البحث: ${e.toString()}',
      );
    }
  }

  /// تحميل المزيد من النتائج (pagination)
  Future<void> loadMore() async {
    if (!state.canLoadMore || state.currentQuery == null) return;

    try {
      state = state.copyWith(isLoadingMore: true);

      final nextPage = state.currentPage + 1;
      final moreResults = await _repository.searchChats(
        state.currentQuery!,
        filter: state.currentFilter,
        page: nextPage,
        pageSize: 20,
      );

      state = state.copyWith(
        results: [...state.results, ...moreResults],
        currentPage: nextPage,
        isLoadingMore: false,
        hasMore: moreResults.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: 'فشل تحميل المزيد: ${e.toString()}',
      );
    }
  }

  /// البحث مع الفلتر الحالي
  Future<void> searchWithCurrentFilter(String query) async {
    // سيتم تمرير الفلتر من الخارج
    await search(query);
  }

  /// إعادة تعيين البحث
  void reset() {
    state = SearchState.initial;
  }

  /// مسح رسالة الخطأ
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// تحديث الفلتر وإعادة البحث
  Future<void> updateFilterAndSearch(SearchFilter filter) async {
    if (state.currentQuery != null) {
      await search(state.currentQuery!, filter: filter);
    }
  }
}
