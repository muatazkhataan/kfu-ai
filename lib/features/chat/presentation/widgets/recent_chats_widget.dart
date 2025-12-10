import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/icons.dart';
import '../../../../core/localization/l10n.dart';
import '../../../../services/api/chat/models/session_dto.dart';
import '../providers/chat_sessions_provider.dart';
import '../../../../features/folders/presentation/providers/folder_provider.dart';
import '../../../../features/folders/domain/models/folder.dart';
import '../../../../features/chat_history/presentation/screens/chat_history_screen.dart';

/// Widget لعرض المحادثات الأخيرة من API
class RecentChatsWidget extends ConsumerStatefulWidget {
  /// المحادثة المحددة حالياً
  final String? selectedSessionId;

  /// دالة الاستدعاء عند تحديد محادثة
  final ValueChanged<String>? onSessionSelected;

  /// عرض زر التحديث
  final bool showRefreshButton;

  const RecentChatsWidget({
    super.key,
    this.selectedSessionId,
    this.onSessionSelected,
    this.showRefreshButton = true,
  });

  @override
  ConsumerState<RecentChatsWidget> createState() => _RecentChatsWidgetState();
}

class _RecentChatsWidgetState extends ConsumerState<RecentChatsWidget> {
  @override
  void initState() {
    super.initState();
    // تحميل المحادثات الأخيرة عند بدء التشغيل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatSessionsProvider.notifier).loadRecentChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionsState = ref.watch(chatSessionsProvider);

    return _buildContent(theme, sessionsState);
  }

  Widget _buildContent(ThemeData theme, ChatSessionsState sessionsState) {
    // حالة التحميل
    if (sessionsState.isLoading && sessionsState.recentSessions.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      );
    }

    // حالة الخطأ
    if (sessionsState.error != null && sessionsState.recentSessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.warning),
                color: theme.colorScheme.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                sessionsState.error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(chatSessionsProvider.notifier).loadRecentChats();
                },
                child: Text(context.l10n.commonRetry),
              ),
            ],
          ),
        ),
      );
    }

    // حالة فارغة
    if (sessionsState.recentSessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.message),
                color: theme.colorScheme.onSurfaceVariant,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.chatHistoryEmptyState,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // عرض القائمة (10 محادثات فقط)
    final displaySessions = sessionsState.recentSessions.take(10).toList();
    final hasMore = sessionsState.recentSessions.length > 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: displaySessions.length,
            itemBuilder: (context, index) {
              final session = displaySessions[index];
              return _buildSessionItem(theme, session);
            },
          ),
        ),
        // زر "... المزيد"
        if (hasMore)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatHistoryScreen(),
                  ),
                );
              },
              icon: Icon(AppIcons.getIcon(AppIcon.arrowLeft), size: 16),
              label: Text(context.l10n.chatMore),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSessionItem(ThemeData theme, SessionDto session) {
    final isSelected = widget.selectedSessionId == session.sessionId;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onSessionSelected?.call(session.sessionId),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 1)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان
                Row(
                  children: [
                    Icon(
                      AppIcons.getIcon(AppIcon.message),
                      size: 14,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        session.title,
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
                    ),
                    if (session.messageCount != null &&
                        session.messageCount! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${session.messageCount}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(width: 4),
                    // زر القائمة المنسدلة
                    PopupMenuButton<String>(
                      icon: Icon(
                        AppIcons.getIcon(AppIcon.ellipsisV),
                        size: 16,
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: theme.colorScheme.outline.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      elevation: 16,
                      shadowColor: theme.colorScheme.shadow.withOpacity(0.3),
                      onSelected: (value) =>
                          _handleMenuAction(context, session, value),
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
                              Text(context.l10n.chatMoveToArchive),
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
                              Text(context.l10n.chatMoveToFolder),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    SessionDto session,
    String action,
  ) {
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
        title: Text(context.l10n.chatDeleteChatTitle),
        content: Text(context.l10n.chatDeleteChatMessage(session.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(chatSessionsProvider.notifier)
          .deleteSession(session.sessionId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? context.l10n.chatDeleteSuccess
                  : context.l10n.chatDeleteFailed,
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _archiveSession(BuildContext context, SessionDto session) async {
    final success = await ref
        .read(chatSessionsProvider.notifier)
        .archiveSession(session.sessionId);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? context.l10n.chatArchiveSuccess
                : context.l10n.chatArchiveFailed,
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _showFolderSelectionDialog(
    BuildContext context,
    SessionDto session,
  ) async {
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
          title: Text(context.l10n.chatMoveToFolderTitle),
          content: SizedBox(
            width: double.maxFinite,
            child: folders.isEmpty
                ? Text(context.l10n.chatNoFoldersAvailable)
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
                          title: Text(context.l10n.chatNoFolder),
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
              child: Text(context.l10n.commonCancel),
            ),
          ],
        ),
      );

      if (selectedOption != null && selectedOption.isNotEmpty) {
        final success = await ref
            .read(chatSessionsProvider.notifier)
            .moveSessionToFolder(session.sessionId, selectedOption);

        if (context.mounted) {
          final folderName = selectedOption == 'all'
              ? context.l10n.chatNoFolder
              : folders
                    .firstWhere(
                      (f) => f.id == selectedOption,
                      orElse: () => folders.first,
                    )
                    .name;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? context.l10n.chatMoveToFolderSuccess(folderName)
                    : context.l10n.chatMoveToFolderFailed,
              ),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
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
}
