import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/l10n.dart';

/// محدد المظهر مع معاينة بصرية
class ThemeSelector extends StatelessWidget {
  /// الوضع المحدد حالياً
  final ThemeMode selectedMode;

  /// دالة التغيير
  final ValueChanged<ThemeMode> onChanged;

  /// هل المحدد مفعل
  final bool isEnabled;

  const ThemeSelector({
    super.key,
    required this.selectedMode,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.themeSelectorTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.themeSelectorSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),

        // خيارات المظهر
        Row(
          children: [
            Expanded(
              child: _ThemeOption(
                mode: ThemeMode.light,
                title: context.l10n.settingsThemeLight,
                isSelected: selectedMode == ThemeMode.light,
                onTap: isEnabled ? () => onChanged(ThemeMode.light) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ThemeOption(
                mode: ThemeMode.system,
                title: context.l10n.settingsThemeAuto,
                isSelected: selectedMode == ThemeMode.system,
                onTap: isEnabled ? () => onChanged(ThemeMode.system) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ThemeOption(
                mode: ThemeMode.dark,
                title: context.l10n.settingsThemeDark,
                isSelected: selectedMode == ThemeMode.dark,
                onTap: isEnabled ? () => onChanged(ThemeMode.dark) : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// خيار مظهر واحد مع معاينة
class _ThemeOption extends StatelessWidget {
  final ThemeMode mode;
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ThemeOption({
    required this.mode,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withAlpha(76),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // معاينة المظهر
            _buildPreview(theme),
            const SizedBox(height: 8),

            // العنوان
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء معاينة المظهر
  Widget _buildPreview(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _getPreviewContent(theme),
      ),
    );
  }

  /// الحصول على محتوى المعاينة حسب النوع
  Widget _getPreviewContent(ThemeData theme) {
    switch (mode) {
      case ThemeMode.light:
        return _LightThemePreview();

      case ThemeMode.dark:
        return _DarkThemePreview();

      case ThemeMode.system:
        return _SystemThemePreview();
    }
  }
}

/// معاينة المظهر الفاتح
class _LightThemePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // شريط علوي فاتح
          Container(
            height: 20,
            color: const Color(0xFFF5F5F5),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B8354),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          // محتوى فاتح
          Expanded(
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF333333),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 30,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF666666),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// معاينة المظهر الداكن
class _DarkThemePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF104631),
      child: Column(
        children: [
          // شريط علوي داكن
          Container(
            height: 20,
            color: const Color(0xFF171a21),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF104631),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          // محتوى داكن
          Expanded(
            child: Container(
              color: const Color(0xFF104631),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFe6e8ea),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 30,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFa0a6ad),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// معاينة المظهر التلقائي
class _SystemThemePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // نصف فاتح
        Expanded(child: _LightThemePreview()),
        // خط فاصل
        Container(width: 1, color: Colors.grey),
        // نصف داكن
        Expanded(child: _DarkThemePreview()),
      ],
    );
  }
}
