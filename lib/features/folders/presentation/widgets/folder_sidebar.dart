import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/folder.dart';
import '../providers/folder_provider.dart';
import '../../../../state/folder_state.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/widgets/dashed_border.dart';

/// مكون الشريط الجانبي للمجلدات
///
/// يعرض قائمة المجلدات مع إمكانية التنقل والتفاعل
class FolderSidebar extends ConsumerStatefulWidget {
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
  ConsumerState<FolderSidebar> createState() => _FolderSidebarState();
}

class _FolderSidebarState extends ConsumerState<FolderSidebar> {
  String? _draggingFolderId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final folderState = ref.watch(folderProvider);

    // تحميل المجلدات عند أول بناء
    if (!folderState.hasLoadedInitial && !folderState.isLoadingFolders) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(folderProvider.notifier).loadFolders();
      });
    }

    final folders = _getOrderedFolders(folderState);

    return Container(
      width: widget.width ?? 280,
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
          _buildFoldersList(context, theme, folders, ref, folderState),
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
            onPressed: widget.onCreateFolder,
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
    FolderState folderState,
  ) {
    if (folders.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    return Expanded(
      child: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: folders.length,
        buildDefaultDragHandles: false,
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, childWidget) {
              return DashedBorder(
                show: true,
                color: theme.colorScheme.primary,
                child: childWidget!,
              );
            },
            child: child,
          );
        },
        onReorderStart: (index) {
          setState(() {
            _draggingFolderId = folders[index].id;
          });
        },
        onReorderEnd: (_) {
          setState(() {
            _draggingFolderId = null;
          });
        },
        onReorder: (oldIndex, newIndex) =>
            _handleFolderReorder(folderState, folders, ref, oldIndex, newIndex),
        itemBuilder: (context, index) {
          final folder = folders[index];
          return KeyedSubtree(
            key: ValueKey(folder.id),
            child: _buildFolderItem(context, theme, folder, ref, index),
          );
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
    int itemIndex,
  ) {
    final isSelected = widget.selectedFolderId == folder.id;
    final isPinned = folder.isPinned;
    final isFixedFolder = folder.isFixed;
    final protectedTooltip = isFixedFolder
        ? 'مجلد ثابت لا يمكن تعديله'
        : folder.isSystem
        ? 'مجلد نظامي لا يمكن تعديله'
        : 'هذا المجلد غير قابل للتعديل';
    final baseFolderColor = folder.folderColor.toColor();
    final rowBackgroundColor = isSelected
        ? theme.colorScheme.primaryContainer
        : isFixedFolder
        ? baseFolderColor.withAlpha(32)
        : Colors.transparent;
    final iconBackgroundColor = isFixedFolder
        ? baseFolderColor.withAlpha(64)
        : baseFolderColor;
    final folderIconColor = isFixedFolder ? baseFolderColor : Colors.white;
    final isReorderable = !isFixedFolder;
    final showMenu = !isFixedFolder;
    final isDragging = _draggingFolderId == folder.id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onFolderSelected?.call(folder.id),
          onLongPress: folder.isEditable
              ? () => _showFolderMenu(context, folder, ref)
              : null,
          borderRadius: BorderRadius.circular(12),
          child: DashedBorder(
            show: isDragging,
            color: theme.colorScheme.primary,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: rowBackgroundColor,
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
                  Expanded(
                    child: _buildDragHandle(
                      theme: theme,
                      folder: folder,
                      itemIndex: itemIndex,
                      isSelected: isSelected,
                      showChatCount: widget.showChatCount,
                      isReorderable: isReorderable,
                      iconBackgroundColor: iconBackgroundColor,
                      iconColor: folderIconColor,
                    ),
                  ),
                  if (showMenu) ...[
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: (value) =>
                          _handleMenuAction(context, folder, value, ref),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          enabled: folder.isEditable,
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                AppIcons.getIcon(AppIcon.edit),
                                size: 16,
                                color: theme.colorScheme.onSurface,
                              ),
                              const SizedBox(width: 8),
                              const Text('تحرير'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          enabled: folder.isEditable,
                          value: 'pin',
                          child: Row(
                            children: [
                              Icon(
                                AppIcons.getIcon(AppIcon.star),
                                size: 16,
                                color: theme.colorScheme.onSurface,
                              ),
                              const SizedBox(width: 8),
                              Text(folder.isPinned ? 'إلغاء التثبيت' : 'تثبيت'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          enabled: folder.isDeletable,
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
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
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
                  ] else if (isFixedFolder) ...[
                    const SizedBox(width: 8),
                    Tooltip(
                      message: protectedTooltip,
                      child: Icon(
                        AppIcons.getIcon(AppIcon.lock),
                        size: 16,
                        color: baseFolderColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle({
    required ThemeData theme,
    required Folder folder,
    required int itemIndex,
    required bool isSelected,
    required bool showChatCount,
    required bool isReorderable,
    required Color iconBackgroundColor,
    required Color iconColor,
  }) {
    final dragContent = Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(folder.folderIcon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
                          ? theme.colorScheme.onPrimaryContainer.withAlpha(179)
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (folder.hasChats) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
        ],
      ),
    );

    if (!isReorderable) {
      return dragContent;
    }

    return ReorderableDragStartListener(index: itemIndex, child: dragContent);
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

    if (widget.showPinnedFirst) {
      final pinned = folders.where((folder) => folder.isPinned).toList();
      final others = folders.where((folder) => !folder.isPinned).toList();
      return [...pinned, ...others];
    }

    return folders;
  }

  void _handleFolderReorder(
    FolderState folderState,
    List<Folder> currentOrder,
    WidgetRef ref,
    int oldIndex,
    int newIndex,
  ) {
    if (oldIndex == newIndex) return;

    final updatedVisibleOrder = _reorderNonFixedVisibleFolders(
      currentOrder,
      oldIndex,
      newIndex,
    );

    if (_areOrdersEqual(currentOrder, updatedVisibleOrder)) {
      return;
    }

    final mergedOrder = _mergeVisibleAndHiddenOrders(
      folderState,
      updatedVisibleOrder,
    );

    ref.read(folderProvider.notifier).reorderFolders(mergedOrder);
  }

  List<Folder> _reorderNonFixedVisibleFolders(
    List<Folder> currentOrder,
    int oldIndex,
    int newIndex,
  ) {
    if (currentOrder.isEmpty) return currentOrder;
    var targetIndex = newIndex;
    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }
    targetIndex = targetIndex.clamp(0, currentOrder.length - 1);

    final movingFolder = currentOrder[oldIndex];
    if (movingFolder.isFixed) {
      return currentOrder;
    }

    final nonFixedFolders = currentOrder
        .where((folder) => !folder.isFixed)
        .toList();

    final customOldIndex = currentOrder
        .take(oldIndex)
        .where((f) => !f.isFixed)
        .length;
    final customTargetIndex = currentOrder
        .take(targetIndex)
        .where((f) => !f.isFixed)
        .length;

    final folderToMove = nonFixedFolders.removeAt(customOldIndex);
    final clampedTarget = customTargetIndex.clamp(0, nonFixedFolders.length);
    nonFixedFolders.insert(clampedTarget, folderToMove);

    final updatedOrder = <Folder>[];
    var customPointer = 0;
    for (final folder in currentOrder) {
      if (folder.isFixed) {
        updatedOrder.add(folder);
      } else {
        updatedOrder.add(nonFixedFolders[customPointer++]);
      }
    }

    return updatedOrder;
  }

  List<Folder> _mergeVisibleAndHiddenOrders(
    FolderState folderState,
    List<Folder> visibleOrder,
  ) {
    final merged = <Folder>[];
    var visibleIndex = 0;

    for (final folder in folderState.folders) {
      if (folder.isHidden) {
        merged.add(folder);
      } else {
        merged.add(visibleOrder[visibleIndex++]);
      }
    }

    return merged;
  }

  bool _areOrdersEqual(List<Folder> a, List<Folder> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) {
        return false;
      }
    }
    return true;
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
              widget.onEditFolder?.call(folder);
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
              widget.onDeleteFolder?.call(folder);
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
        widget.onEditFolder?.call(folder);
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
