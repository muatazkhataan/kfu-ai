import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/l10n.dart';
import '../../domain/models/app_settings.dart';

/// محدد حجم الخط
class FontSizeSelector extends StatelessWidget {
  /// حجم الخط المحدد حالياً
  final FontSizeLevel selectedSize;

  /// دالة التغيير
  final ValueChanged<FontSizeLevel> onChanged;

  /// هل المحدد مفعل
  final bool isEnabled;

  const FontSizeSelector({
    super.key,
    required this.selectedSize,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.fontSizeSelectorTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              _getFontSizeLabel(context, selectedSize),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          context.l10n.fontSizeSelectorSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 12),

        // أزرار التحكم
        Row(
          children: [
            // تصغير
            IconButton(
              onPressed: isEnabled && _canDecrease()
                  ? () => _decreaseSize()
                  : null,
              icon: const Icon(Icons.remove),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ),

            // المعاينة والشريط
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // معاينة النص
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        context.l10n.fontSizeExample,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize:
                              (theme.textTheme.bodyMedium?.fontSize ?? 14) *
                              selectedSize.scaleFactor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // شريط التقدم
                    LinearProgressIndicator(
                      value: _getProgressValue(),
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // تكبير
            IconButton(
              onPressed: isEnabled && _canIncrease()
                  ? () => _increaseSize()
                  : null,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),

        // مؤشرات الحجم
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: FontSizeLevel.values.map((size) {
            final isSelected = size == selectedSize;
            return GestureDetector(
              onTap: isEnabled ? () => onChanged(size) : null,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withAlpha(76),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// هل يمكن تصغير الخط
  bool _canDecrease() {
    return selectedSize != FontSizeLevel.values.first;
  }

  /// هل يمكن تكبير الخط
  bool _canIncrease() {
    return selectedSize != FontSizeLevel.values.last;
  }

  /// تصغير حجم الخط
  void _decreaseSize() {
    final currentIndex = FontSizeLevel.values.indexOf(selectedSize);
    if (currentIndex > 0) {
      onChanged(FontSizeLevel.values[currentIndex - 1]);
    }
  }

  /// تكبير حجم الخط
  void _increaseSize() {
    final currentIndex = FontSizeLevel.values.indexOf(selectedSize);
    if (currentIndex < FontSizeLevel.values.length - 1) {
      onChanged(FontSizeLevel.values[currentIndex + 1]);
    }
  }

  /// الحصول على قيمة التقدم (0-1)
  double _getProgressValue() {
    final currentIndex = FontSizeLevel.values.indexOf(selectedSize);
    return currentIndex / (FontSizeLevel.values.length - 1);
  }

  /// الحصول على تسمية حجم الخط من الترجمة
  String _getFontSizeLabel(BuildContext context, FontSizeLevel size) {
    switch (size) {
      case FontSizeLevel.small:
        return context.l10n.fontSizeSmall;
      case FontSizeLevel.medium:
        return context.l10n.fontSizeMedium;
      case FontSizeLevel.large:
        return context.l10n.fontSizeLarge;
      case FontSizeLevel.extraLarge:
        return context.l10n.fontSizeExtraLarge;
    }
  }
}

/// محدد حجم الخط المبسط
class SimpleFontSizeSelector extends StatelessWidget {
  final FontSizeLevel selectedSize;
  final ValueChanged<FontSizeLevel> onChanged;

  const SimpleFontSizeSelector({
    super.key,
    required this.selectedSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DropdownButton<FontSizeLevel>(
      value: selectedSize,
      items: FontSizeLevel.values.map((size) {
        return DropdownMenuItem(
          value: size,
          child: Text(_getFontSizeLabel(context, size)),
        );
      }).toList(),
      onChanged: (newSize) {
        if (newSize != null) {
          onChanged(newSize);
        }
      },
      underline: const SizedBox.shrink(),
      style: theme.textTheme.bodyMedium,
      dropdownColor: theme.colorScheme.surface,
    );
  }

  /// الحصول على تسمية حجم الخط من الترجمة
  String _getFontSizeLabel(BuildContext context, FontSizeLevel size) {
    switch (size) {
      case FontSizeLevel.small:
        return context.l10n.fontSizeSmall;
      case FontSizeLevel.medium:
        return context.l10n.fontSizeMedium;
      case FontSizeLevel.large:
        return context.l10n.fontSizeLarge;
      case FontSizeLevel.extraLarge:
        return context.l10n.fontSizeExtraLarge;
    }
  }
}
