import 'package:flutter/material.dart';
import '../../domain/models/search_result.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/extensions/context_extensions.dart';

/// عنصر نتيجة بحث
class SearchResultItem extends StatelessWidget {
  /// نتيجة البحث
  final SearchResult result;

  /// Callback عند النقر
  final VoidCallback onTap;

  const SearchResultItem({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colorScheme.outline, width: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (result.isArchived)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      AppIcons.getIcon(AppIcon.archive),
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            // المقتطف
            if (result.snippet.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  result.snippet,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // معلومات إضافية
            Row(
              children: [
                if (result.folderName != null) ...[
                  Icon(
                    AppIcons.getIcon(AppIcon.folder),
                    size: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    result.folderName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Icon(
                  AppIcons.getIcon(AppIcon.clock),
                  size: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  result.formattedDate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  AppIcons.getIcon(AppIcon.message),
                  size: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${result.messageCount}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
