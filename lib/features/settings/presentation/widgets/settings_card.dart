import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';

/// بطاقة إعدادات قابلة للإعادة الاستخدام
class SettingsCard extends StatelessWidget {
  /// العنوان الرئيسي
  final String title;

  /// الوصف
  final String? description;

  /// الأيقونة
  final IconData? icon;

  /// لون مخصص للبطاقة
  final Color? accentColor;

  /// محتوى البطاقة
  final List<Widget> children;

  /// هل البطاقة قابلة للطي
  final bool isCollapsible;

  /// هل البطاقة مفتوحة افتراضياً
  final bool initiallyExpanded;

  /// دالة عند التوسع/الطي
  final ValueChanged<bool>? onExpansionChanged;

  const SettingsCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.accentColor,
    required this.children,
    this.isCollapsible = false,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isRTL = context.isRTL;

    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // رأس البطاقة
        _buildHeader(theme, isRTL),

        // المحتوى
        if (!isCollapsible || initiallyExpanded) ...[
          const SizedBox(height: 8),
          ...children,
        ],
      ],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
        child: isCollapsible
            ? ExpansionTile(
                title: _buildTitle(theme),
                subtitle: description != null ? _buildDescription(theme) : null,
                leading: icon != null ? _buildIcon(theme) : null,
                initiallyExpanded: initiallyExpanded,
                onExpansionChanged: onExpansionChanged,
                childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                children: children,
              )
            : Padding(padding: const EdgeInsets.all(12), child: cardContent),
      ),
    );
  }

  /// بناء رأس البطاقة
  Widget _buildHeader(ThemeData theme, bool isRTL) {
    if (isCollapsible) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // الأيقونة
            if (icon != null) ...[_buildIcon(theme), const SizedBox(width: 12)],

            // العنوان
            Expanded(child: _buildTitle(theme)),
          ],
        ),

        // الوصف
        if (description != null) ...[
          const SizedBox(height: 4),
          _buildDescription(theme),
        ],
      ],
    );
  }

  /// بناء العنوان
  Widget _buildTitle(ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: accentColor ?? theme.colorScheme.primary,
      ),
    );
  }

  /// بناء الوصف
  Widget _buildDescription(ThemeData theme) {
    return Text(
      description!,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// بناء الأيقونة
  Widget _buildIcon(ThemeData theme) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: (accentColor ?? theme.colorScheme.primary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 20,
        color: accentColor ?? theme.colorScheme.primary,
      ),
    );
  }
}

/// بطاقة إعدادات بسيطة بدون تعقيد
class SimpleSettingsCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const SimpleSettingsCard({
    super.key,
    required this.children,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        color: backgroundColor ?? theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
