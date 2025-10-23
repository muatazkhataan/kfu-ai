import '../features/search/domain/models/search_result.dart';
import '../features/search/domain/models/search_filter.dart';

/// حالة البحث
class SearchState {
  /// نتائج البحث الحالية
  final List<SearchResult> results;

  /// نص البحث الحالي
  final String? currentQuery;

  /// الفلتر الحالي
  final SearchFilter? currentFilter;

  /// هل يتم تحميل نتائج البحث
  final bool isSearching;

  /// هل تم البحث من قبل
  final bool hasSearched;

  /// رسالة خطأ (إن وجدت)
  final String? error;

  /// الصفحة الحالية (للـ pagination)
  final int currentPage;

  /// هل يوجد المزيد من النتائج
  final bool hasMore;

  /// هل يتم تحميل المزيد من النتائج
  final bool isLoadingMore;

  const SearchState({
    this.results = const [],
    this.currentQuery,
    this.currentFilter,
    this.isSearching = false,
    this.hasSearched = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  /// حالة ابتدائية
  static const SearchState initial = SearchState();

  /// إنشاء نسخة مع تعديلات
  SearchState copyWith({
    List<SearchResult>? results,
    String? currentQuery,
    SearchFilter? currentFilter,
    bool? isSearching,
    bool? hasSearched,
    String? error,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    bool clearQuery = false,
    bool clearFilter = false,
    bool clearError = false,
  }) {
    return SearchState(
      results: results ?? this.results,
      currentQuery: clearQuery ? null : (currentQuery ?? this.currentQuery),
      currentFilter: clearFilter ? null : (currentFilter ?? this.currentFilter),
      isSearching: isSearching ?? this.isSearching,
      hasSearched: hasSearched ?? this.hasSearched,
      error: clearError ? null : (error ?? this.error),
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  /// التحقق من وجود نتائج
  bool get hasResults => results.isNotEmpty;

  /// التحقق من عدم وجود نتائج بعد البحث
  bool get hasNoResults => hasSearched && results.isEmpty && !isSearching;

  /// التحقق من وجود خطأ
  bool get hasError => error != null && error!.isNotEmpty;

  /// التحقق من إمكانية تحميل المزيد
  bool get canLoadMore => hasMore && !isLoadingMore && !isSearching;

  @override
  String toString() {
    return 'SearchState(results: ${results.length}, query: $currentQuery, '
        'isSearching: $isSearching, hasSearched: $hasSearched, hasError: $hasError)';
  }
}
