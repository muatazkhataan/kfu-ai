import 'package:flutter/material.dart';
import '../../../../core/localization/l10n.dart';

/// مكون اختيار لون المجلد
///
/// يعرض لوحة ألوان مخصصة مع تمرير أفقي
class FolderColorPickerWidget extends StatefulWidget {
  final String? selectedColor;
  final ValueChanged<String>? onColorSelected;

  const FolderColorPickerWidget({
    super.key,
    this.selectedColor,
    this.onColorSelected,
  });

  @override
  State<FolderColorPickerWidget> createState() => _FolderColorPickerWidgetState();
}

class _FolderColorPickerWidgetState extends State<FolderColorPickerWidget> {
  String? _selectedColor;

  // الألوان المتاحة (مستوحاة من التصميم)
  static final List<Map<String, dynamic>> _colors = [
    {'color': '#6c757d', 'nameKey': 'folderColorGray'},
    {'color': '#dc3545', 'nameKey': 'folderColorRed'},
    {'color': '#fd7e14', 'nameKey': 'folderColorOrange'},
    {'color': '#ffc107', 'nameKey': 'folderColorYellow'},
    {'color': '#198754', 'nameKey': 'folderColorGreen'},
    {'color': '#0dcaf0', 'nameKey': 'folderColorCyan'},
    {'color': '#6f42c1', 'nameKey': 'folderColorPurple'},
    {'color': '#e83e8c', 'nameKey': 'folderColorPink'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor ?? _colors[0]['color'] as String;
  }

  @override
  void didUpdateWidget(FolderColorPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedColor != oldWidget.selectedColor) {
      _selectedColor = widget.selectedColor ?? _colors[0]['color'] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth >= 600;
    
    // حجم الألوان حسب حجم الشاشة
    final colorSize = isTabletOrDesktop ? 50.0 : 40.0;
    final spacing = isTabletOrDesktop ? 12.0 : 8.0;
    final iconSize = isTabletOrDesktop ? 24.0 : 20.0;
    final borderWidth = isTabletOrDesktop ? 3.0 : 2.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.folderSelectColor,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: isTabletOrDesktop ? null : 14,
          ),
        ),
        const SizedBox(height: 12),
        // تمرير أفقي للألوان في المنتصف
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _colors.map((colorData) {
                final color = colorData['color'] as String;
                final isSelected = _selectedColor == color;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedColor = color);
                      widget.onColorSelected?.call(color);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Tooltip(
                      message: _getColorName(context, colorData['nameKey'] as String),
                      child: Container(
                        width: colorSize,
                        height: colorSize,
                        decoration: BoxDecoration(
                          color: _hexToColor(color),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: theme.colorScheme.primary,
                                  width: borderWidth,
                                )
                              : Border.all(
                                  color: theme.colorScheme.outline.withOpacity(0.3),
                                  width: 1,
                                ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: _hexToColor(color).withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: iconSize,
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (_selectedColor != null) ...[
          const SizedBox(height: 12),
          Center(
            child: Builder(
              builder: (context) {
                final selectedColorData = _colors.firstWhere(
                  (c) => c['color'] == _selectedColor,
                  orElse: () => {'nameKey': 'folderColorUndefined'},
                );
                final colorName = _getColorName(
                  context,
                  selectedColorData['nameKey'] as String,
                );
                return Text(
                  context.l10n.folderSelectedColor(colorName),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: isTabletOrDesktop ? null : 11,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  String _getColorName(BuildContext context, String key) {
    switch (key) {
      case 'folderColorGray':
        return context.l10n.folderColorGray;
      case 'folderColorRed':
        return context.l10n.folderColorRed;
      case 'folderColorOrange':
        return context.l10n.folderColorOrange;
      case 'folderColorYellow':
        return context.l10n.folderColorYellow;
      case 'folderColorGreen':
        return context.l10n.folderColorGreen;
      case 'folderColorCyan':
        return context.l10n.folderColorCyan;
      case 'folderColorPurple':
        return context.l10n.folderColorPurple;
      case 'folderColorPink':
        return context.l10n.folderColorPink;
      default:
        return context.l10n.folderColorUndefined;
    }
  }

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
