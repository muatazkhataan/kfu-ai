import '../features/search/domain/models/search_history_item.dart';

/// حالة تاريخ البحث
class SearchHistoryState {
  /// عناصر تاريخ البحث
  final List<SearchHistoryItem> items;

  /// هل يتم التحميل
  final bool isLoading;

  /// رسالة خطأ (إن وجدت)
  final String? error;

  /// هل تم التحميل من قبل
  final bool hasLoaded;

  const SearchHistoryState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.hasLoaded = false,
  });

  /// حالة ابتدائية
  static const SearchHistoryState initial = SearchHistoryState();

  /// إنشاء نسخة مع تعديلات
  SearchHistoryState copyWith({
    List<SearchHistoryItem>? items,
    bool? isLoading,
    String? error,
    bool? hasLoaded,
    bool clearError = false,
  }) {
    return SearchHistoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      hasLoaded: hasLoaded ?? this.hasLoaded,
    );
  }

  /// التحقق من وجود عناصر
  bool get hasItems => items.isNotEmpty;

  /// التحقق من وجود خطأ
  bool get hasError => error != null && error!.isNotEmpty;

  /// التحقق من كون القائمة فارغة
  bool get isEmpty => items.isEmpty && hasLoaded && !isLoading;

  @override
  String toString() {
    return 'SearchHistoryState(items: ${items.length}, isLoading: $isLoading, '
        'hasError: $hasError)';
  }
}
