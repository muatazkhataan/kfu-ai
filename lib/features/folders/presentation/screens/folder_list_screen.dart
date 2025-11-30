import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/folder.dart';
import '../providers/folder_provider.dart';
import 'create_folder_screen.dart';
import 'change_icon_screen.dart';
import 'folder_content_screen.dart';
import '../../../../state/folder_state.dart';
import '../../../../core/theme/icons.dart';

/// شاشة قائمة المجلدات
///
/// تعرض قائمة المجلدات مع إمكانية التنقل والتفاعل
class FolderListScreen extends ConsumerStatefulWidget {
  const FolderListScreen({super.key});

  @override
  ConsumerState<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends ConsumerState<FolderListScreen> {
  String? _selectedFolderId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // تحميل المجلدات عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final folderState = ref.read(folderProvider);
      if (!folderState.hasLoadedInitial && !folderState.isLoadingFolders) {
        ref.read(folderProvider.notifier).loadFolders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final folderState = ref.watch(folderProvider);
    final folders = _getFilteredFolders(folderState);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المجلدات'),
        actions: [
          IconButton(
            icon: Icon(AppIcons.getIcon(AppIcon.plus)),
            onPressed: () => _showCreateFolderDialog(context),
            tooltip: 'إنشاء مجلد جديد',
          ),
          IconButton(
            icon: Icon(AppIcons.getIcon(AppIcon.refresh)),
            onPressed: () => ref.read(folderProvider.notifier).refresh(),
            tooltip: 'تحديث',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث في المجلدات...',
                prefixIcon: Icon(AppIcons.getIcon(AppIcon.search)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
        ),
      ),
      body: folderState.isLoadingFolders
          ? const Center(child: CircularProgressIndicator())
          : folderState.error != null
              ? _buildErrorState(context, theme, folderState.error!)
              : folders.isEmpty
                  ? _buildEmptyState(context, theme)
                  : _buildFoldersList(context, theme, folders),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.exclamationTriangle),
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(folderProvider.notifier).refresh(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.folder),
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد مجلدات',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على + لإنشاء مجلد جديد',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showCreateFolderDialog(context),
            icon: Icon(AppIcons.getIcon(AppIcon.plus)),
            label: const Text('إنشاء مجلد جديد'),
          ),
        ],
      ),
    );
  }

  Widget _buildFoldersList(
    BuildContext context,
    ThemeData theme,
    List<Folder> folders,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: folders.length,
      itemBuilder: (context, index) {
        final folder = folders[index];
        final isSelected = _selectedFolderId == folder.id;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface,
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getFolderColor(folder, theme),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                folder.icon.iconData,
                color: Colors.white,
                size: 24,
              ),
            ),
            title: Text(folder.name),
            subtitle: folder.description != null
                ? Text(
                    folder.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (folder.chatCount > 0)
                  Chip(
                    label: Text('${folder.chatCount}'),
                    padding: EdgeInsets.zero,
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(context, folder, value),
                  itemBuilder: (context) => [
                    if (folder.isEditable)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('تحرير'),
                          ],
                        ),
                      ),
                    if (folder.isIconChangeable)
                      const PopupMenuItem(
                        value: 'change_icon',
                        child: Row(
                          children: [
                            Icon(Icons.palette, size: 20),
                            SizedBox(width: 8),
                            Text('تغيير الأيقونة'),
                          ],
                        ),
                      ),
                    if (folder.isDeletable)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('حذف', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            onTap: () {
              setState(() => _selectedFolderId = folder.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FolderContentScreen(folder: folder),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getFolderColor(Folder folder, ThemeData theme) {
    if (folder.color != null) {
      try {
        return Color(int.parse(folder.color!.replaceAll('#', '0xFF')));
      } catch (e) {
        return theme.colorScheme.primary;
      }
    }
    return theme.colorScheme.primary;
  }

  List<Folder> _getFilteredFolders(FolderState folderState) {
    var folders = folderState.visibleFolders;

    if (_searchQuery.isNotEmpty) {
      folders = folders.where((folder) {
        return folder.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (folder.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    // ترتيب: المقيدة أولاً، ثم حسب الاسم
    folders.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return a.name.compareTo(b.name);
    });

    return folders;
  }

  void _handleMenuAction(BuildContext context, Folder folder, String action) {
    switch (action) {
      case 'edit':
        _showEditFolderDialog(context, folder);
        break;
      case 'change_icon':
        _openChangeIconScreen(context, folder);
        break;
      case 'delete':
        _confirmDelete(context, folder);
        break;
    }
  }

  void _showEditFolderDialog(BuildContext context, Folder folder) {
    final nameController = TextEditingController(text: folder.name);
    final descriptionController = TextEditingController(text: folder.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحرير المجلد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المجلد',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف المجلد (اختياري)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
              ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(folderProvider.notifier).updateFolder(
                      folder.id,
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                    );
                if (mounted) {
                  Navigator.pop(context);
                  _showSuccessMessage(context, 'تم تحديث المجلد بنجاح');
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
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _openChangeIconScreen(BuildContext context, Folder folder) {
    showDialog(
      context: context,
      builder: (context) => ChangeIconScreen(folder: folder),
    );
  }

  void _confirmDelete(BuildContext context, Folder folder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المجلد'),
        content: Text('هل أنت متأكد من حذف مجلد "${folder.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(folderProvider.notifier).deleteFolder(folder.id);
                if (mounted) {
                  _showSuccessMessage(context, 'تم حذف المجلد بنجاح');
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
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateFolderScreen(),
      ),
    ).then((_) {
      // تحديث القائمة بعد إنشاء مجلد جديد
      if (mounted) {
        ref.read(folderProvider.notifier).refresh();
      }
    });
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

