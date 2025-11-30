import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/folder.dart';
import '../../domain/models/folder_icon.dart';
import '../providers/folder_provider.dart';
import '../widgets/folder_icon_picker_widget.dart';
import '../widgets/folder_color_picker_widget.dart';
import '../widgets/folder_preview_widget.dart';
import '../../../../core/theme/icons.dart';

/// شاشة تغيير أيقونة المجلد
///
/// مستوحاة من التصميم في _web_design
class ChangeIconScreen extends ConsumerStatefulWidget {
  final Folder folder;

  const ChangeIconScreen({super.key, required this.folder});

  @override
  ConsumerState<ChangeIconScreen> createState() => _ChangeIconScreenState();
}

class _ChangeIconScreenState extends ConsumerState<ChangeIconScreen> {
  late FolderIcon _selectedIcon;
  String? _selectedColor;
  IconCategory _selectedCategory = IconCategory.general;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.folder.icon;
    _selectedColor = widget.folder.color;
    _selectedCategory = widget.folder.icon.category;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final folderState = ref.watch(folderProvider);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // رأس الشاشة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    AppIcons.getIcon(AppIcon.palette),
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تغيير أيقونة المجلد',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // المحتوى
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // معاينة المجلد
                    FolderPreviewWidget(
                      name: widget.folder.name,
                      icon: _selectedIcon,
                      color: _selectedColor,
                    ),
                    const SizedBox(height: 24),

                    // اختيار الأيقونة
                    Text('اختر الأيقونة', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: FolderIconPickerWidget(
                        selectedIcon: _selectedIcon,
                        initialCategory: _selectedCategory,
                        onIconSelected: (icon) {
                          setState(() {
                            _selectedIcon = icon;
                            _selectedCategory = icon.category;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // اختيار اللون
                    FolderColorPickerWidget(
                      selectedColor: _selectedColor,
                      onColorSelected: (color) {
                        setState(() => _selectedColor = color);
                      },
                    ),
                    const SizedBox(height: 24),

                    // عرض الأخطاء
                    if (folderState.updateError != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                folderState.updateError!,
                                style: TextStyle(
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // أزرار الإجراءات
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: folderState.isUpdatingFolder
                          ? null
                          : _handleApply,
                      icon: folderState.isUpdatingFolder
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(AppIcons.getIcon(AppIcon.check)),
                      label: Text(
                        folderState.isUpdatingFolder
                            ? 'جاري التطبيق...'
                            : 'تطبيق "${_selectedIcon.name}"',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApply() async {
    try {
      // تحديث الأيقونة واللون معاً
      await ref
          .read(folderProvider.notifier)
          .updateFolderIcon(
            widget.folder.id,
            _selectedIcon.id,
            color: _selectedColor,
          );

      // التحقق من عدم وجود أخطاء
      final folderState = ref.read(folderProvider);
      if (folderState.updateError != null) {
        // عرض رسالة الخطأ
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(folderState.updateError!)),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else if (mounted) {
        // نجح التحديث
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تم تغيير أيقونة المجلد "${widget.folder.name}" بنجاح',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('خطأ: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
