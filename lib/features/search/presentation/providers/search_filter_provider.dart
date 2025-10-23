import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/search_filter.dart';

/// مزود حالة فلتر البحث
final searchFilterProvider =
    StateNotifierProvider<SearchFilterNotifier, SearchFilter>((ref) {
      return SearchFilterNotifier();
    });

/// Notifier لإدارة فلتر البحث
class SearchFilterNotifier extends StateNotifier<SearchFilter> {
  SearchFilterNotifier() : super(SearchFilter.defaultFilter());

  /// تحديث الفلتر
  void updateFilter(SearchFilter newFilter) {
    state = newFilter;
  }

  /// إعادة تعيين الفلتر
  void resetFilter() {
    state = SearchFilter.defaultFilter();
  }

  /// تحديث فلتر المجلد
  void updateFolderFilter(String? folderId) {
    state = state.copyWith(folderId: folderId);
  }

  /// تحديث فلتر التاريخ
  void updateDateFilter(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
  }

  /// تحديث نوع المحادثات
  void updateTypeFilter(SearchType type) {
    state = state.copyWith(type: type);
  }

  /// تحديث طريقة الترتيب
  void updateSortBy(SortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  /// تحديث فلتر عدد الرسائل
  void updateMessageCountFilter(int? minCount, int? maxCount) {
    state = state.copyWith(
      minMessageCount: minCount,
      maxMessageCount: maxCount,
    );
  }

  /// مسح فلتر المجلد
  void clearFolderFilter() {
    state = state.copyWith(clearFolderId: true);
  }

  /// مسح فلتر التاريخ
  void clearDateFilter() {
    state = state.copyWith(clearStartDate: true, clearEndDate: true);
  }

  /// مسح فلتر عدد الرسائل
  void clearMessageCountFilter() {
    state = state.copyWith(
      clearMinMessageCount: true,
      clearMaxMessageCount: true,
    );
  }

  /// التحقق من وجود فلاتر نشطة
  bool get hasActiveFilters => state.hasActiveFilters;

  /// الحصول على وصف الفلاتر النشطة
  String get activeFiltersDescription => state.activeFiltersDescription;
}
