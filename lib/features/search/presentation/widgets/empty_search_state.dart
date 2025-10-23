import 'package:flutter/material.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/extensions/context_extensions.dart';

/// حالة البحث الفارغة
class EmptySearchState extends StatelessWidget {
  /// نص البحث (null إذا لم يتم البحث بعد)
  final String? query;

  const EmptySearchState({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.getIcon(
                query == null || query!.isEmpty
                    ? AppIcon.search
                    : AppIcon.infoCircle,
              ),
              size: 64,
              color: colorScheme.onSurfaceVariant.withAlpha(128),
            ),
            const SizedBox(height: 24),
            Text(
              _getTitle(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _getMessage(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (query != null && query!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'نصائح للبحث:',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildSearchTip(context, '• جرب كلمات مفتاحية مختلفة'),
              _buildSearchTip(context, '• تحقق من الإملاء'),
              _buildSearchTip(context, '• استخدم كلمات أقل أو أكثر عمومية'),
            ],
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    if (query == null || query!.isEmpty) {
      return 'ابدأ البحث';
    }
    return 'لا توجد نتائج';
  }

  String _getMessage() {
    if (query == null || query!.isEmpty) {
      return 'ابحث في جميع محادثاتك باستخدام الكلمات المفتاحية';
    }
    return 'لم نجد أي محادثات تتطابق مع بحثك';
  }

  Widget _buildSearchTip(BuildContext context, String tip) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        tip,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
