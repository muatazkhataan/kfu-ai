import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/folder_icon.dart';
import '../../domain/models/folder.dart';
import '../providers/folder_provider.dart';
import '../widgets/folder_icon_picker_widget.dart';
import '../widgets/folder_color_picker_widget.dart';
import '../widgets/folder_preview_widget.dart';

/// شاشة إنشاء مجلد جديد
class CreateFolderScreen extends ConsumerStatefulWidget {
  final Folder? folderToEdit;

  const CreateFolderScreen({super.key, this.folderToEdit});

  @override
  ConsumerState<CreateFolderScreen> createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends ConsumerState<CreateFolderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  late FolderIcon _selectedIcon;
  String? _selectedColor;
  late IconCategory _selectedCategory;
  bool get _isEditMode => widget.folderToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final folder = widget.folderToEdit!;
      _nameController.text = folder.name;
      _descriptionController.text = folder.description ?? '';
      _selectedIcon = folder.icon;
      _selectedColor = folder.color;
      _selectedCategory = folder.icon.category;
    } else {
      _selectedIcon = FolderIconManager.getIconById('folder_general')!;
      _selectedCategory = IconCategory.general;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final folderState = ref.watch(folderProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final padding = isSmallScreen ? 12.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'تعديل المجلد' : 'إنشاء مجلد جديد',
          style: TextStyle(fontSize: isSmallScreen ? 16 : null),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // معاينة المجلد
              FolderPreviewWidget(
                name: _nameController.text.isEmpty
                    ? 'اسم المجلد'
                    : _nameController.text,
                icon: _selectedIcon,
                color: _selectedColor,
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

              // اسم المجلد
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المجلد *',
                  hintText: 'أدخل اسم المجلد',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'اسم المجلد مطلوب';
                  }
                  if (value.trim().length < 2) {
                    return 'اسم المجلد يجب أن يكون على الأقل حرفين';
                  }
                  if (value.trim().length > 50) {
                    return 'اسم المجلد يجب ألا يتجاوز 50 حرفاً';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // وصف المجلد (اختياري)
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف المجلد (اختياري)',
                  hintText: 'أدخل وصفاً للمجلد',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // اختيار الأيقونة
              Text(
                'اختر الأيقونة',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: isSmallScreen ? 14 : null,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: isSmallScreen ? 250 : 300,
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
              const SizedBox(height: 32),

              // أزرار الإجراءات
              Row(
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
                    child: ElevatedButton(
                      onPressed:
                          (_isEditMode
                              ? folderState.isUpdatingFolder
                              : folderState.isCreatingFolder)
                          ? null
                          : _isEditMode
                          ? _handleUpdate
                          : _handleCreate,
                      child:
                          (_isEditMode
                              ? folderState.isUpdatingFolder
                              : folderState.isCreatingFolder)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _isEditMode ? 'حفظ التعديلات' : 'إنشاء المجلد',
                            ),
                    ),
                  ),
                ],
              ),

              // عرض الأخطاء
              if ((_isEditMode
                      ? folderState.updateError
                      : folderState.createError) !=
                  null) ...[
                const SizedBox(height: 16),
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
                          _isEditMode
                              ? (folderState.updateError ?? '')
                              : (folderState.createError ?? ''),
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
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

  Future<void> _handleCreate() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref
            .read(folderProvider.notifier)
            .createFolder(
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              icon: _selectedIcon,
              color: _selectedColor,
            );

        // التحقق من عدم وجود أخطاء
        final folderState = ref.read(folderProvider);
        if (folderState.createError == null && mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('تم إنشاء المجلد بنجاح'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // الخطأ سيظهر في UI تلقائياً من خلال folderState.createError
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState!.validate() && _isEditMode) {
      try {
        final folder = widget.folderToEdit!;
        final folderNotifier = ref.read(folderProvider.notifier);

        // تحديث الاسم إذا تغير
        if (_nameController.text.trim() != folder.name) {
          await folderNotifier.updateFolderName(
            folder.id,
            _nameController.text.trim(),
          );
        }

        // تحديث الأيقونة واللون إذا تغيرا
        if (_selectedIcon.id != folder.icon.id ||
            _selectedColor != folder.color) {
          await folderNotifier.updateFolderIcon(
            folder.id,
            _selectedIcon.id,
            color: _selectedColor,
          );
        }

        // تحديث الوصف إذا تغير
        final newDescription = _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim();
        if (newDescription != folder.description) {
          await folderNotifier.updateFolder(
            folder.id,
            description: newDescription,
          );
        }

        // التحقق من عدم وجود أخطاء
        final folderState = ref.read(folderProvider);
        if (folderState.updateError == null && mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('تم تحديث المجلد بنجاح'),
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
              content: Text('خطأ: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
