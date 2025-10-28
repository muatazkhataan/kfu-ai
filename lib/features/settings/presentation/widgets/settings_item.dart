import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/models/settings_category.dart';

/// عنصر إعدادات قابل للإعادة الاستخدام
class SettingsItem extends StatelessWidget {
  /// العنوان
  final String title;

  /// الوصف
  final String? subtitle;

  /// الأيقونة
  final IconData? icon;

  /// نوع العنصر
  final SettingsItemType type;

  /// القيمة الحالية
  final dynamic value;

  /// دالة التغيير
  final Function(dynamic)? onChanged;

  /// دالة الضغط (للأزرار)
  final VoidCallback? onTap;

  /// هل العنصر مفعل
  final bool isEnabled;

  /// خيارات إضافية (للقوائم المنسدلة)
  final Map<String, dynamic>? options;

  /// لون مخصص
  final Color? accentColor;

  const SettingsItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.type,
    this.value,
    this.onChanged,
    this.onTap,
    this.isEnabled = true,
    this.options,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? (onTap ?? _handleTap) : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                // الأيقونة
                if (icon != null) ...[
                  _buildIcon(theme),
                  const SizedBox(width: 16),
                ],

                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isEnabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isEnabled
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onSurfaceVariant
                                      .withOpacity(0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // التحكم
                _buildControl(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء الأيقونة
  Widget _buildIcon(ThemeData theme) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: (accentColor ?? theme.colorScheme.primary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 18,
        color: isEnabled
            ? (accentColor ?? theme.colorScheme.primary)
            : (accentColor ?? theme.colorScheme.primary).withOpacity(0.5),
      ),
    );
  }

  /// بناء عنصر التحكم
  Widget _buildControl(ThemeData theme) {
    switch (type) {
      case SettingsItemType.toggle:
        return Switch(
          value: value as bool? ?? false,
          onChanged: isEnabled ? (newValue) => onChanged?.call(newValue) : null,
          activeColor: accentColor ?? theme.colorScheme.primary,
        );

      case SettingsItemType.dropdown:
        return _buildDropdown(theme);

      case SettingsItemType.slider:
        return SizedBox(
          width: 100,
          child: Slider(
            value: (value as num?)?.toDouble() ?? 0.0,
            min: (options?['min'] as num?)?.toDouble() ?? 0.0,
            max: (options?['max'] as num?)?.toDouble() ?? 100.0,
            divisions: options?['divisions'] as int?,
            onChanged: isEnabled
                ? (newValue) => onChanged?.call(newValue)
                : null,
            activeColor: accentColor ?? theme.colorScheme.primary,
          ),
        );

      case SettingsItemType.info:
        return Text(
          value?.toString() ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );

      case SettingsItemType.button:
        return Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        );

      case SettingsItemType.colorPicker:
        return _buildColorPicker(theme);

      default:
        return const SizedBox.shrink();
    }
  }

  /// بناء القائمة المنسدلة
  Widget _buildDropdown(ThemeData theme) {
    final items = options?['items'] as List<DropdownMenuItem<dynamic>>? ?? [];

    return DropdownButton<dynamic>(
      value: value,
      items: items,
      onChanged: isEnabled ? (newValue) => onChanged?.call(newValue) : null,
      underline: const SizedBox.shrink(),
      style: theme.textTheme.bodyMedium,
      dropdownColor: theme.colorScheme.surface,
    );
  }

  /// بناء منتقي الألوان
  Widget _buildColorPicker(ThemeData theme) {
    final selectedColor = value as Color? ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: selectedColor,
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.outline, width: 2),
        ),
      ),
    );
  }

  /// معالجة الضغط الافتراضي
  void _handleTap() {
    if (type == SettingsItemType.toggle) {
      final currentValue = value as bool? ?? false;
      onChanged?.call(!currentValue);
    } else {
      onTap?.call();
    }
  }
}

/// عنصر إعدادات بسيط للنصوص فقط
class SimpleSettingsItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isEnabled;
  final Color? accentColor;

  const SimpleSettingsItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.isEnabled = true,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ListTile(
      leading: icon != null
          ? Icon(
              icon,
              color: isEnabled
                  ? (accentColor ?? theme.colorScheme.primary)
                  : theme.colorScheme.onSurface.withOpacity(0.5),
            )
          : null,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isEnabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isEnabled
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            )
          : null,
      trailing: trailing,
      onTap: isEnabled ? onTap : null,
      enabled: isEnabled,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
