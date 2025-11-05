import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/l10n.dart';

/// شريط تمرير درجة الإبداع في الذكاء الاصطناعي
class CreativitySlider extends StatelessWidget {
  /// القيمة الحالية (0-100)
  final int value;

  /// دالة التغيير
  final ValueChanged<int> onChanged;

  /// هل الشريط مفعل
  final bool isEnabled;

  const CreativitySlider({
    super.key,
    required this.value,
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
              context.l10n.creativityLevelTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$value%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          context.l10n.creativityLevelSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 12),

        // الشريط
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: _getTrackColor(theme, value),
            inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
            thumbColor: _getThumbColor(theme, value),
            overlayColor: _getTrackColor(theme, value).withOpacity(0.1),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: isEnabled
                ? (newValue) => onChanged(newValue.round())
                : null,
          ),
        ),

        const SizedBox(height: 8),

        // تسميات
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel(context, theme, value <= 30),
            _buildLabel(context, theme, value > 30 && value <= 70, isBalanced: true),
            _buildLabel(context, theme, value > 70, isCreative: true),
          ],
        ),

        const SizedBox(height: 12),

        // وصف الحالة الحالية
        _buildDescription(context, theme, value),
      ],
    );
  }

  /// بناء تسمية
  Widget _buildLabel(BuildContext context, ThemeData theme, bool isActive, {bool isBalanced = false, bool isCreative = false}) {
    String label;
    if (isCreative) {
      label = context.l10n.creativityCreative;
    } else if (isBalanced) {
      label = context.l10n.creativityBalanced;
    } else {
      label = context.l10n.creativityConservative;
    }

    return Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  /// بناء وصف الحالة
  Widget _buildDescription(BuildContext context, ThemeData theme, int value) {
    String description;
    IconData icon;

    if (value <= 30) {
      description = context.l10n.creativityDescriptionConservative;
      icon = Icons.shield_outlined;
    } else if (value <= 70) {
      description = context.l10n.creativityDescriptionBalanced;
      icon = Icons.balance;
    } else {
      description = context.l10n.creativityDescriptionCreative;
      icon = Icons.auto_awesome;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// الحصول على لون المسار
  Color _getTrackColor(ThemeData theme, int value) {
    if (value <= 30) {
      return Colors.blue;
    } else if (value <= 70) {
      return theme.colorScheme.primary;
    } else {
      return Colors.purple;
    }
  }

  /// الحصول على لون المقبض
  Color _getThumbColor(ThemeData theme, int value) {
    return _getTrackColor(theme, value);
  }
}

/// شريط إبداع مبسط
class SimpleCreativitySlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const SimpleCreativitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Text(context.l10n.creativityConservative, style: theme.textTheme.bodySmall),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 100,
            onChanged: (newValue) => onChanged(newValue.round()),
          ),
        ),
        Text(context.l10n.creativityCreative, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
