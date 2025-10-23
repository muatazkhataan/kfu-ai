import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_results_list.dart';
import '../widgets/empty_search_state.dart';
import '../widgets/search_history_list.dart';
import '../providers/search_provider.dart';
import '../providers/search_filter_provider.dart' as filter_provider;
import '../widgets/search_filter_sheet.dart';
import '../../domain/models/search_filter.dart';

/// شاشة البحث
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    print('[SearchScreen] 🚀 تم تهيئة SearchScreen');
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    // Focus تلقائي عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('[SearchScreen] 🎯 طلب التركيز على حقل البحث');
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('[SearchScreen] 🎨 بناء واجهة SearchScreen');
    final searchState = ref.watch(searchProvider);
    final searchFilter = ref.watch(filter_provider.searchFilterProvider);
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('البحث في المحادثات'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(AppIcons.getIcon(AppIcon.filter)),
                if (searchFilter.hasActiveFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => _showFilterSheet(context, searchFilter),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          SearchBarWidget(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onSearch: _performSearch,
            onChanged: _onSearchChanged,
            isSearching: searchState.isSearching,
          ),

          // المحتوى
          Expanded(child: _buildContent(searchState)),
        ],
      ),
    );
  }

  Widget _buildContent(dynamic searchState) {
    // حالة البحث جاري
    if (searchState.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    // حالة وجود خطأ
    if (searchState.hasError) {
      return _buildErrorState(searchState.error);
    }

    // حالة وجود نتائج
    if (searchState.hasResults) {
      return SearchResultsList(
        results: searchState.results,
        onResultTap: (result) {
          // الانتقال لشاشة المحادثة
          Navigator.pop(context);
          // TODO: Navigate to chat screen
        },
      );
    }

    // حالة لا توجد نتائج بعد البحث
    if (searchState.hasNoResults) {
      return EmptySearchState(query: _searchController.text);
    }

    // حالة افتراضية: عرض تاريخ البحث
    return SearchHistoryList(
      onHistoryItemTap: (query) {
        _searchController.text = query;
        _performSearch(query);
      },
    );
  }

  Widget _buildErrorState(String? error) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.getIcon(AppIcon.error),
              size: 64,
              color: colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'حدث خطأ',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error ?? 'فشل البحث',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                _performSearch(_searchController.text);
              },
              icon: Icon(AppIcons.getIcon(AppIcon.refresh)),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      return;
    }

    final filter = ref.read(filter_provider.searchFilterProvider);
    ref.read(searchProvider.notifier).search(query, filter: filter);
  }

  void _onSearchChanged(String query) {
    // يمكن إضافة debounce للبحث التلقائي هنا
    if (query.isEmpty) {
      ref.read(searchProvider.notifier).reset();
    }
  }

  void _showFilterSheet(BuildContext context, SearchFilter currentFilter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SearchFilterSheet(
        currentFilter: currentFilter,
        onApply: (newFilter) {
          ref
              .read(filter_provider.searchFilterProvider.notifier)
              .updateFilter(newFilter);
          // إعادة البحث مع الفلاتر الجديدة
          if (_searchController.text.isNotEmpty) {
            _performSearch(_searchController.text);
          }
        },
      ),
    );
  }
}
