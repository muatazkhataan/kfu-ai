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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? (onTap ?? _handleTap) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // الأيقونة
                  if (icon != null) ...[
                    _buildIcon(theme),
                    const SizedBox(width: 8),
                  ],

                  // العنوان والتحكم
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isEnabled
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface.withAlpha(128),
                            ),
                          ),
                        ),
                        // التحكم (Switch فقط، dropdown له أيقونة منفصلة)
                        if (type != SettingsItemType.dropdown)
                          _buildControl(context, theme),
                      ],
                    ),
                  ),
                ],
              ),

              // الوصف
              if (subtitle != null) ...[
                Padding(
                  padding: EdgeInsets.only(left: icon != null ? 44 : 0, top: 4),
                  child: Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isEnabled
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurfaceVariant.withAlpha(128),
                    ),
                  ),
                ),
              ],

              // القيمة المختارة للـ dropdown
              if (type == SettingsItemType.dropdown) ...[
                Padding(
                  padding: EdgeInsets.only(left: icon != null ? 44 : 0, top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildDropdownValue(theme)),
                      _buildControl(context, theme),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// بناء الأيقونة
  Widget _buildIcon(ThemeData theme) {
    return Icon(
      icon,
      size: 20,
      color: isEnabled
          ? theme.colorScheme.onSurface
          : theme.colorScheme.onSurface.withAlpha(128),
    );
  }

  /// بناء قيمة الـ dropdown المختارة
  Widget _buildDropdownValue(ThemeData theme) {
    final items = options?['items'] as List<DropdownMenuItem<dynamic>>? ?? [];
    if (items.isEmpty) return const SizedBox.shrink();

    DropdownMenuItem<dynamic>? selectedItem;
    try {
      selectedItem = items.firstWhere((item) => item.value == value);
    } catch (e) {
      selectedItem = items.isNotEmpty ? items.first : null;
    }

    if (selectedItem == null) return const SizedBox.shrink();

    String displayText = '';
    if (selectedItem.child is Text) {
      displayText = (selectedItem.child as Text).data ?? '';
    } else if (selectedItem.child is Builder) {
      // في حالة Builder، نحاول استخراج النص
      displayText = value?.toString() ?? '';
    } else {
      displayText = value?.toString() ?? '';
    }

    return Text(
      displayText,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// بناء عنصر التحكم
  Widget _buildControl(BuildContext context, ThemeData theme) {
    switch (type) {
      case SettingsItemType.toggle:
        return Switch(
          value: value as bool? ?? false,
          onChanged: isEnabled ? (newValue) => onChanged?.call(newValue) : null,
          activeColor: accentColor ?? theme.colorScheme.primary,
        );

      case SettingsItemType.dropdown:
        return _buildDropdown(context, theme);

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

  /// بناء القائمة المنسدلة (أيقونة القائمة)
  Widget _buildDropdown(BuildContext context, ThemeData theme) {
    final items = options?['items'] as List<DropdownMenuItem<dynamic>>? ?? [];

    return PopupMenuButton<dynamic>(
      enabled: isEnabled,
      icon: Icon(
        Icons.more_vert,
        color: isEnabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onSurfaceVariant.withAlpha(128),
      ),
      itemBuilder: (context) => items.map((item) {
        String itemText = '';
        if (item.child is Text) {
          itemText = (item.child as Text).data ?? '';
        } else {
          itemText = item.value?.toString() ?? '';
        }

        return PopupMenuItem<dynamic>(
          value: item.value,
          child: Text(
            itemText,
            style: TextStyle(
              color: item.value == value
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontWeight: item.value == value
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
      onSelected: isEnabled ? (newValue) => onChanged?.call(newValue) : null,
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              // الأيقونة
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: isEnabled
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withAlpha(128),
                ),
                const SizedBox(width: 8),
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
                            : theme.colorScheme.onSurface.withAlpha(128),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isEnabled
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurfaceVariant.withAlpha(
                                  128,
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing widget
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
