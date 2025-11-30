import 'package:flutter/material.dart';
import '../../domain/models/folder_icon.dart';

/// مكون معاينة المجلد
///
/// يعرض معاينة مباشرة للمجلد قبل الحفظ
class FolderPreviewWidget extends StatelessWidget {
  final String name;
  final FolderIcon icon;
  final String? color;

  const FolderPreviewWidget({
    super.key,
    required this.name,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final folderColor = _getColor(theme);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'معاينة المجلد',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // أيقونة المجلد
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: folderColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // خلفية المجلد
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: folderColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                // الجزء العلوي من المجلد
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: folderColor.withOpacity(0.25),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                // الأيقونة
                Center(
                  child: Icon(
                    icon.iconData,
                    size: 40,
                    color: folderColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // اسم المجلد
          Text(
            name.isEmpty ? 'اسم المجلد' : name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (color != null) ...[
            const SizedBox(height: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _hexToColor(color!),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getColor(ThemeData theme) {
    if (color != null) {
      return _hexToColor(color!);
    }
    return theme.colorScheme.primary;
  }

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}

