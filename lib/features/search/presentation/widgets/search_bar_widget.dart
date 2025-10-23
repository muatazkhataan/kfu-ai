import 'package:flutter/material.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/extensions/context_extensions.dart';

/// شريط بحث مخصص
class SearchBarWidget extends StatefulWidget {
  /// Controller للـ TextField
  final TextEditingController controller;

  /// Focus node للـ TextField
  final FocusNode? focusNode;

  /// Callback عند البحث (Enter أو زر البحث)
  final ValueChanged<String> onSearch;

  /// Callback عند تغيير النص
  final ValueChanged<String>? onChanged;

  /// Hint text
  final String? hintText;

  /// هل البحث قيد التنفيذ
  final bool isSearching;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    this.focusNode,
    this.onChanged,
    this.hintText,
    this.isSearching = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // أيقونة البحث
          Icon(
            AppIcons.getIcon(AppIcon.search),
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),

          // حقل النص
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'ابحث في المحادثات...',
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              textInputAction: TextInputAction.search,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSearch,
            ),
          ),

          // مؤشر التحميل أو زر المسح
          if (widget.isSearching)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            )
          else if (widget.controller.text.isNotEmpty)
            IconButton(
              icon: Icon(AppIcons.getIcon(AppIcon.close), size: 18),
              color: colorScheme.onSurfaceVariant,
              onPressed: () {
                widget.controller.clear();
                if (widget.onChanged != null) {
                  widget.onChanged!('');
                }
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }
}
