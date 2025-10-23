import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/search_result.dart';
import 'search_result_item.dart';

/// قائمة نتائج البحث
class SearchResultsList extends ConsumerWidget {
  /// نتائج البحث
  final List<SearchResult> results;

  /// Callback عند النقر على نتيجة
  final Function(SearchResult)? onResultTap;

  const SearchResultsList({super.key, required this.results, this.onResultTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];

        return SearchResultItem(
          result: result,
          onTap: () {
            if (onResultTap != null) {
              onResultTap!(result);
            } else {
              // الانتقال لشاشة المحادثة
              Navigator.pop(context);
              // TODO: Navigate to chat screen with session ID
            }
          },
        );
      },
    );
  }
}
