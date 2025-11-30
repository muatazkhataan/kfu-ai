import 'package:flutter/material.dart';

/// مكون اختيار لون المجلد
///
/// يعرض لوحة ألوان مخصصة
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
  static const List<Map<String, dynamic>> _colors = [
    {'color': '#6c757d', 'name': 'رمادي فاتح'},
    {'color': '#dc3545', 'name': 'أحمر'},
    {'color': '#fd7e14', 'name': 'برتقالي'},
    {'color': '#ffc107', 'name': 'أصفر'},
    {'color': '#198754', 'name': 'أخضر'},
    {'color': '#0dcaf0', 'name': 'أزرق سماوي'},
    {'color': '#6f42c1', 'name': 'بنفسجي'},
    {'color': '#e83e8c', 'name': 'وردي'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor ?? _colors[0]['color'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    // حجم الألوان حسب حجم الشاشة
    final colorSize = isSmallScreen ? 40.0 : 50.0;
    final spacing = isSmallScreen ? 8.0 : 12.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final borderWidth = isSmallScreen ? 2.0 : 3.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر اللون',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: isSmallScreen ? 14 : null,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: _colors.map((colorData) {
            final color = colorData['color'] as String;
            final isSelected = _selectedColor == color;

            return InkWell(
              onTap: () {
                setState(() => _selectedColor = color);
                widget.onColorSelected?.call(color);
              },
              borderRadius: BorderRadius.circular(20),
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
            );
          }).toList(),
        ),
        if (_selectedColor != null) ...[
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final selectedColorData = _colors.firstWhere(
                (c) => c['color'] == _selectedColor,
                orElse: () => {'name': 'غير محدد'},
              );
              return Text(
                'اللون المختار: ${selectedColorData['name']}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: isSmallScreen ? 11 : null,
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}

