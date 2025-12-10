import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/icons.dart';
import '../../../../services/api/chat/models/session_dto.dart';
import '../../../../features/chat/presentation/providers/chat_sessions_provider.dart';
import '../providers/folder_provider.dart';
import '../../domain/models/folder.dart';

/// مكون قائمة محادثات المجلد
///
/// يعرض قائمة المحادثات مع إمكانية الفلترة والترتيب
class FolderChatListWidget extends ConsumerStatefulWidget {
  final List<SessionDto> chats;
  final Function(SessionDto)? onChatTap;
  final Function(SessionDto)? onChatLongPress;
  final String? searchQuery;
  final VoidCallback? onChatDeletedOrMoved;

  const FolderChatListWidget({
    super.key,
    required this.chats,
    this.onChatTap,
    this.onChatLongPress,
    this.searchQuery,
    this.onChatDeletedOrMoved,
  });

  @override
  ConsumerState<FolderChatListWidget> createState() => _FolderChatListWidgetState();
}

class _FolderChatListWidgetState extends ConsumerState<FolderChatListWidget> {
  List<SessionDto> _filterChats() {
    if (widget.searchQuery == null || widget.searchQuery!.isEmpty) {
      return widget.chats;
    }

    final query = widget.searchQuery!.toLowerCase();
    return widget.chats.where((chat) {
      final title = chat.title.toLowerCase();
      return title.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredChats = _filterChats();

    if (filteredChats.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        return _buildChatItem(context, theme, chat);
      },
    );
  }

  Widget _buildChatItem(BuildContext context, ThemeData theme, SessionDto chat) {
    final title = chat.title.isNotEmpty ? chat.title : 'محادثة بدون عنوان';
    final updatedAt = chat.updatedAt;
    final messageCount = chat.messageCount ?? 0;
    final isArchived = chat.isArchived;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            AppIcons.getIcon(AppIcon.comments),
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'آخر تحديث: ${_formatDate(updatedAt)}',
              style: theme.textTheme.bodySmall,
            ),
            if (isArchived)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'مؤرشف',
                  style: theme.textTheme.labelSmall,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (messageCount > 0)
              Chip(
                label: Text('$messageCount'),
                padding: EdgeInsets.zero,
              ),
            // زر القائمة المنسدلة
            PopupMenuButton<String>(
              icon: Icon(
                AppIcons.getIcon(AppIcon.ellipsisV),
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onSelected: (value) => _handleMenuAction(context, chat, value),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'archive',
                  child: Row(
                    children: [
                      Icon(
                        AppIcons.getIcon(AppIcon.archive),
                        size: 18,
                        color: theme.colorScheme.onSurface,
                      ),
                      const SizedBox(width: 12),
                      const Text('نقل إلى الأرشيف'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'move_to_folder',
                  child: Row(
                    children: [
                      Icon(
                        AppIcons.getIcon(AppIcon.folder),
                        size: 18,
                        color: theme.colorScheme.onSurface,
                      ),
                      const SizedBox(width: 12),
                      const Text('نقل إلى مجلد'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        AppIcons.getIcon(AppIcon.trash),
                        size: 18,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 12),
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
            ),
          ],
        ),
        onTap: () => widget.onChatTap?.call(chat),
        onLongPress: () => widget.onChatLongPress?.call(chat),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, SessionDto session, String action) {
    switch (action) {
      case 'delete':
        _confirmDelete(context, session);
        break;
      case 'archive':
        _archiveSession(context, session);
        break;
      case 'move_to_folder':
        _showFolderSelectionDialog(context, session);
        break;
    }
  }

  Future<void> _confirmDelete(BuildContext context, SessionDto session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المحادثة'),
        content: Text('هل أنت متأكد من حذف المحادثة "${session.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

      if (confirmed == true && context.mounted) {
      final success = await ref.read(chatSessionsProvider.notifier).deleteSession(session.sessionId);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'تم حذف المحادثة بنجاح' : 'فشل حذف المحادثة'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        
        // إعادة تحميل محادثات المجلد بعد الحذف
        if (success && widget.onChatDeletedOrMoved != null) {
          widget.onChatDeletedOrMoved!();
        }
      }
    }
  }

  Future<void> _archiveSession(BuildContext context, SessionDto session) async {
    final success = await ref.read(chatSessionsProvider.notifier).archiveSession(session.sessionId);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'تم نقل المحادثة إلى الأرشيف بنجاح' : 'فشل نقل المحادثة إلى الأرشيف'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _showFolderSelectionDialog(BuildContext context, SessionDto session) async {
    final folderState = ref.read(folderProvider);
    
    // تحميل المجلدات إذا لم تكن محملة
    if (!folderState.hasLoadedInitial) {
      await ref.read(folderProvider.notifier).loadFolders();
    }

    final folders = ref.read(folderProvider).visibleFolders;

    if (context.mounted) {
      final selectedOption = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('نقل إلى مجلد'),
          content: SizedBox(
            width: double.maxFinite,
            child: folders.isEmpty
                ? const Text('لا توجد مجلدات متاحة')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: folders.length + 1, // +1 لخيار "بدون مجلد"
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // خيار "بدون مجلد"
                        return ListTile(
                          leading: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              AppIcons.getIcon(AppIcon.comments),
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text('بدون مجلد'),
                          onTap: () => Navigator.pop(context, 'all'),
                        );
                      }
                      final folder = folders[index - 1];
                      return ListTile(
                        leading: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _getFolderColor(folder, Theme.of(context)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            folder.icon.iconData,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(folder.name),
                        onTap: () => Navigator.pop(context, folder.id),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      );

      if (selectedOption != null && selectedOption.isNotEmpty) {
        final success = await ref.read(chatSessionsProvider.notifier).moveSessionToFolder(
          session.sessionId,
          selectedOption,
        );

        if (context.mounted) {
          final folderName = selectedOption == 'all'
              ? 'بدون مجلد'
              : folders.firstWhere(
                  (f) => f.id == selectedOption,
                  orElse: () => folders.first,
                ).name;
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'تم نقل المحادثة إلى "$folderName" بنجاح'
                    : 'فشل نقل المحادثة',
              ),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
          
          // إعادة تحميل محادثات المجلد بعد النقل
          if (success && widget.onChatDeletedOrMoved != null) {
            widget.onChatDeletedOrMoved!();
          }
        }
      }
    }
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

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.comments),
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            widget.searchQuery != null && widget.searchQuery!.isNotEmpty
                ? 'لا توجد نتائج للبحث'
                : 'لا توجد محادثات',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            widget.searchQuery != null && widget.searchQuery!.isNotEmpty
                ? 'جرب كلمات بحث أخرى'
                : 'هذا المجلد فارغ حالياً',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'اليوم';
      } else if (difference.inDays == 1) {
        return 'أمس';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} أيام';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'غير محدد';
    }
  }
}

