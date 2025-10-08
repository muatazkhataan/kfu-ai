import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/folder.dart';
import '../providers/folder_provider.dart';
import '../../../../state/folder_state.dart';
import '../../../../core/theme/icons.dart';

/// مكون الشريط الجانبي للمجلدات
///
/// يعرض قائمة المجلدات مع إمكانية التنقل والتفاعل
class FolderSidebar extends ConsumerWidget {
  /// المجلد المحدد حالياً
  final String? selectedFolderId;

  /// دالة الاستدعاء عند تحديد مجلد
  final ValueChanged<String?>? onFolderSelected;

  /// دالة الاستدعاء عند إنشاء مجلد جديد
  final VoidCallback? onCreateFolder;

  /// دالة الاستدعاء عند تعديل مجلد
  final ValueChanged<Folder>? onEditFolder;

  /// دالة الاستدعاء عند حذف مجلد
  final ValueChanged<Folder>? onDeleteFolder;

  /// هل يجب عرض المجلدات المقيدة في الأعلى
  final bool showPinnedFirst;

  /// هل يجب عرض عدد المحادثات
  final bool showChatCount;

  /// عرض الشريط الجانبي
  final double? width;

  const FolderSidebar({
    super.key,
    this.selectedFolderId,
    this.onFolderSelected,
    this.onCreateFolder,
    this.onEditFolder,
    this.onDeleteFolder,
    this.showPinnedFirst = true,
    this.showChatCount = true,
    this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final folderState = ref.watch(folderProvider);
    final folders = _getOrderedFolders(folderState);

    return Container(
      width: width ?? 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outline..withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context, theme),
          _buildFoldersList(context, theme, folders, ref),
          _buildFooter(context, theme),
        ],
      ),
    );
  }

  /// بناء رأس الشريط الجانبي
  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest..withAlpha(128),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline..withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.folder),
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'المجلدات',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: onCreateFolder,
            icon: Icon(
              AppIcons.getIcon(AppIcon.plus),
              size: 20,
              color: theme.colorScheme.primary,
            ),
            tooltip: 'إنشاء مجلد جديد',
          ),
        ],
      ),
    );
  }

  /// بناء قائمة المجلدات
  Widget _buildFoldersList(
    BuildContext context,
    ThemeData theme,
    List<Folder> folders,
    WidgetRef ref,
  ) {
    if (folders.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return _buildFolderItem(context, theme, folder, ref);
        },
      ),
    );
  }

  /// بناء عنصر مجلد
  Widget _buildFolderItem(
    BuildContext context,
    ThemeData theme,
    Folder folder,
    WidgetRef ref,
  ) {
    final isSelected = selectedFolderId == folder.id;
    final isPinned = folder.isPinned;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onFolderSelected?.call(folder.id),
          onLongPress: folder.isEditable
              ? () => _showFolderMenu(context, folder, ref)
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 1)
                  : null,
            ),
            child: Row(
              children: [
                if (isPinned) ...[
                  Icon(
                    AppIcons.getIcon(AppIcon.star),
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                ],
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: folder.folderColor.toColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(folder.folderIcon, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folder.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (showChatCount && folder.hasChats) ...[
                        const SizedBox(height: 2),
                        Text(
                          folder.formattedChatCount,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                      .withOpacity(0.7)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (folder.hasChats) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      folder.chatCount.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (folder.isEditable) ...[
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleMenuAction(context, folder, value, ref),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              AppIcons.getIcon(AppIcon.edit),
                              size: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                            const SizedBox(width: 8),
                            Text('تحرير'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'pin',
                        child: Row(
                          children: [
                            Icon(
                              folder.isPinned
                                  ? AppIcons.getIcon(AppIcon.star)
                                  : AppIcons.getIcon(AppIcon.star),
                              size: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                            const SizedBox(width: 8),
                            Text(folder.isPinned ? 'إلغاء التثبيت' : 'تثبيت'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              AppIcons.getIcon(AppIcon.trash),
                              size: 16,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'حذف',
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: Icon(
                      AppIcons.getIcon(AppIcon.ellipsis),
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء حالة فارغة
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.getIcon(AppIcon.folder),
              size: 64,
              color: theme.colorScheme.onSurfaceVariant..withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد مجلدات',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'اضغط على + لإنشاء مجلد جديد',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(1175),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء تذييل الشريط الجانبي
  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest..withAlpha(128),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline..withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.settings),
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'إعدادات المجلدات',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: فتح إعدادات المجلدات
            },
            icon: Icon(
              AppIcons.getIcon(AppIcon.chevronRight),
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// الحصول على المجلدات مرتبة
  List<Folder> _getOrderedFolders(FolderState folderState) {
    final folders = List<Folder>.from(folderState.visibleFolders);

    if (showPinnedFirst) {
      folders.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return a.name.compareTo(b.name);
      });
    } else {
      folders.sort((a, b) => a.name.compareTo(b.name));
    }

    return folders;
  }

  /// عرض قائمة المجلد
  void _showFolderMenu(BuildContext context, Folder folder, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFolderMenu(context, folder, ref),
    );
  }

  /// بناء قائمة المجلد
  Widget _buildFolderMenu(BuildContext context, Folder folder, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              AppIcons.getIcon(AppIcon.edit),
              color: theme.colorScheme.primary,
            ),
            title: Text('تحرير المجلد'),
            onTap: () {
              Navigator.pop(context);
              onEditFolder?.call(folder);
            },
          ),
          ListTile(
            leading: Icon(
              folder.isPinned
                  ? AppIcons.getIcon(AppIcon.star)
                  : AppIcons.getIcon(AppIcon.star),
              color: theme.colorScheme.primary,
            ),
            title: Text(folder.isPinned ? 'إلغاء التثبيت' : 'تثبيت'),
            onTap: () {
              Navigator.pop(context);
              ref.read(folderProvider.notifier).toggleFolderPin(folder.id);
            },
          ),
          ListTile(
            leading: Icon(
              AppIcons.getIcon(AppIcon.trash),
              color: theme.colorScheme.error,
            ),
            title: Text(
              'حذف المجلد',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () {
              Navigator.pop(context);
              _confirmDeleteFolder(context, folder, ref);
            },
          ),
        ],
      ),
    );
  }

  /// تأكيد حذف المجلد
  void _confirmDeleteFolder(
    BuildContext context,
    Folder folder,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف المجلد'),
        content: Text('هل أنت متأكد من حذف مجلد "${folder.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(folderProvider.notifier).deleteFolder(folder.id);
              onDeleteFolder?.call(folder);
            },
            child: Text(
              'حذف',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  /// معالجة إجراءات القائمة
  void _handleMenuAction(
    BuildContext context,
    Folder folder,
    String action,
    WidgetRef ref,
  ) {
    switch (action) {
      case 'edit':
        onEditFolder?.call(folder);
        break;
      case 'pin':
        ref.read(folderProvider.notifier).toggleFolderPin(folder.id);
        break;
      case 'delete':
        _confirmDeleteFolder(context, folder, ref);
        break;
    }
  }
}

/// امتداد لتحويل String إلى Color
extension StringColorExtension on String {
  Color toColor() {
    try {
      return Color(int.parse(replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
