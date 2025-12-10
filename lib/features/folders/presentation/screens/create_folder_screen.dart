import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/folder_icon.dart';
import '../../domain/models/folder.dart';
import '../providers/folder_provider.dart';
import '../widgets/folder_icon_picker_widget.dart';
import '../widgets/folder_color_picker_widget.dart';
import '../widgets/folder_preview_widget.dart';
import '../../../../core/localization/l10n.dart';

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
          _isEditMode
              ? context.l10n.chatEditFolderTitle
              : context.l10n.chatCreateFolderTitle,
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
                    ? context.l10n.folderNamePlaceholder
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
                decoration: InputDecoration(
                  labelText: context.l10n.folderNameLabel,
                  hintText: context.l10n.folderNameHint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.folderNameRequired;
                  }
                  if (value.trim().length < 2) {
                    return context.l10n.folderNameMinLength;
                  }
                  if (value.trim().length > 50) {
                    return context.l10n.folderNameMaxLength;
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),

              // اختيار الأيقونة
              Text(
                context.l10n.folderSelectIcon,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: isSmallScreen ? 14 : null,
                ),
              ),
              const SizedBox(height: 12),
              // شبكة الأيقونات - تتمدد إلى أسفل بدون سكرول
              FolderIconPickerWidget(
                selectedIcon: _selectedIcon,
                initialCategory: _selectedCategory,
                onIconSelected: (icon) {
                  setState(() {
                    _selectedIcon = icon;
                    _selectedCategory = icon.category;
                  });
                },
              ),
              const SizedBox(height: 32),

              // أزرار الإجراءات - عرض ثابت 100 بكسل في وسط الشاشة
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 200,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.l10n.commonCancel),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 200,
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isEditMode
                                    ? context.l10n.folderSaveChanges
                                    : context.l10n.folderCreate,
                              ),
                      ),
                    ),
                  ],
                ),
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
              description: null,
              icon: _selectedIcon,
              color: _selectedColor,
            );

        // التحقق من عدم وجود أخطاء
        final folderState = ref.read(folderProvider);
        if (folderState.createError == null && mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(context.l10n.folderCreatedSuccess),
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
              content: Text(context.l10n.chatError(e.toString())),
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

        // التحقق من عدم وجود أخطاء
        final folderState = ref.read(folderProvider);
        if (folderState.updateError == null && mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(context.l10n.folderUpdatedSuccess),
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
              content: Text(context.l10n.chatError(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
