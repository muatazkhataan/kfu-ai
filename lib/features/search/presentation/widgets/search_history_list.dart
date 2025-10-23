import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/search_history_item.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/search_history_provider.dart';

/// قائمة تاريخ البحث
class SearchHistoryList extends ConsumerWidget {
  /// Callback عند النقر على عنصر
  final ValueChanged<String>? onHistoryItemTap;

  const SearchHistoryList({super.key, this.onHistoryItemTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(searchHistoryProvider);
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    if (historyState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (historyState.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.getIcon(AppIcon.history),
              size: 48,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا يوجد تاريخ بحث',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // عنوان + زر مسح الكل
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'عمليات بحث سابقة',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _showClearConfirmation(context, ref);
                },
                icon: Icon(AppIcons.getIcon(AppIcon.delete), size: 16),
                label: const Text('مسح الكل'),
              ),
            ],
          ),
        ),

        // القائمة
        Expanded(
          child: ListView.builder(
            itemCount: historyState.items.length,
            itemBuilder: (context, index) {
              final item = historyState.items[index];
              return _SearchHistoryTile(
                item: item,
                onTap: () {
                  if (onHistoryItemTap != null) {
                    onHistoryItemTap!(item.query);
                  }
                },
                onDelete: () {
                  ref.read(searchHistoryProvider.notifier).deleteItem(item.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح التاريخ'),
        content: const Text('هل تريد مسح جميع عمليات البحث السابقة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              ref.read(searchHistoryProvider.notifier).clearHistory();
              Navigator.pop(context);
            },
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }
}

class _SearchHistoryTile extends StatelessWidget {
  final SearchHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SearchHistoryTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return ListTile(
      leading: Icon(
        AppIcons.getIcon(AppIcon.history),
        color: colorScheme.onSurfaceVariant,
      ),
      title: Text(item.query, style: theme.textTheme.bodyLarge),
      subtitle: Text(
        '${item.formattedResultCount} • ${item.formattedTimestamp}',
        style: theme.textTheme.bodySmall,
      ),
      trailing: IconButton(
        icon: Icon(AppIcons.getIcon(AppIcon.close), size: 18),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}
