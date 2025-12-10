import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart'
    as settings;
import '../../features/chat/presentation/providers/chat_provider.dart';
import '../../features/chat/presentation/providers/chat_sessions_provider.dart';
import '../../features/chat/presentation/widgets/recent_chats_widget.dart';
import '../../features/chat_history/presentation/screens/chat_history_screen.dart';
import '../../features/folders/presentation/providers/folder_provider.dart';
import '../../features/folders/presentation/screens/folder_list_screen.dart';
import '../../features/folders/presentation/screens/create_folder_screen.dart';
import '../../features/folders/presentation/screens/folder_content_screen.dart';
import '../../features/folders/domain/models/folder.dart';
import '../../state/folder_state.dart';
import '../theme/icons.dart';
import '../extensions/context_extensions.dart';
import '../localization/l10n.dart';
import '../providers/sidebar_provider.dart';
import '../../app/app.dart';
import 'dashed_border.dart';

/// القائمة الجانبية الرئيسية للتطبيق
class AppDrawer extends ConsumerStatefulWidget {
  final bool isSidebar;

  const AppDrawer({super.key, this.isSidebar = false});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  String? _drawerDraggingFolderId;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final authState = ref.watch(authProvider);

    // الحصول على اسم المستخدم من loginResponse
    final l10n = context.l10n;
    String userName = l10n.sidebarUserDefault;
    if (authState.loginResponse != null) {
      final loginResponse = authState.loginResponse!;

      // محاولة الحصول من profile
      if (loginResponse.profile != null) {
        final profile = loginResponse.profile!;
        userName =
            profile['fullName'] ??
            profile['FullName'] ??
            profile['full_name'] ??
            l10n.sidebarUserDefault;
      }

      // إذا لم يكن في profile، نستخدم userId كبديل مؤقت
      if (userName == l10n.sidebarUserDefault) {
        userName = loginResponse.userId.isNotEmpty
            ? '${l10n.sidebarUserDefault} ${loginResponse.userId.substring(0, 8)}...'
            : l10n.sidebarUserDefault;
      }
    }

    final userId = authState.userId ?? authState.loginResponse?.userId ?? '';

    final content = SafeArea(
      child: Column(
        children: [
          // رأس القائمة مع الشعار
          _buildHeader(context, theme, ref),

          // معلومات المستخدم
          _buildUserInfo(context, theme, userName, userId, ref),

          // أزرار البحث والمحادثة الجديدة
          _buildActionButtons(context, theme, ref),

          // المحتوى القابل للتمرير
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // قسم المجلدات
                  _buildFoldersSection(context, theme, ref),

                  // قسم المحادثات الأخيرة
                  _buildRecentChatsSection(context, theme, ref),
                ],
              ),
            ),
          ),

          // تذييل القائمة الجانبية
          _buildFooter(context, theme),
        ],
      ),
    );

    // إذا كان sidebar، نعيده كـ Container عادي
    if (widget.isSidebar) {
      return Container(
        width: 400,
        color: theme.colorScheme.surface,
        child: content,
      );
    }

    // وإلا نعيده كـ Drawer عادي
    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      width: 400,
      child: content,
    );
  }

  /// رأس القائمة مع الشعار
  Widget _buildHeader(BuildContext context, ThemeData theme, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withAlpha(25),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/images/mosa3ed_kfu_icon_app.jpg',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.appName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          // زر إغلاق في وضع sidebar
          if (widget.isSidebar)
            IconButton(
              onPressed: () {
                ref.read(sidebarProvider.notifier).close();
              },
              icon: Icon(
                AppIcons.getIcon(AppIcon.close),
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              tooltip: context.l10n.sidebarClose,
            ),
        ],
      ),
    );
  }

  /// معلومات المستخدم وزر الخروج
  Widget _buildUserInfo(
    BuildContext context,
    ThemeData theme,
    String userName,
    String userId,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.colorScheme.secondary),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary,
            child: Icon(
              AppIcons.getIcon(AppIcon.user),
              size: 20,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  userId.isNotEmpty 
                      ? context.l10n.sidebarUserIdDisplay(userId.substring(0, 8))
                      : '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                // الانتقال مباشرة إلى شاشة تسجيل الدخول
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            icon: Icon(
              AppIcons.getIcon(AppIcon.signOut),
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            tooltip: context.l10n.sidebarSignOut,
          ),
        ],
      ),
    );
  }

  /// أزرار البحث والمحادثة الجديدة
  Widget _buildActionButtons(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        children: [
          // زر محادثة جديدة
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (!widget.isSidebar) {
                  Navigator.pop(context);
                }
                ref.read(chatProvider.notifier).createNewChat();
              },
              icon: Icon(AppIcons.getIcon(AppIcon.plus), size: 16),
              label: Text(context.l10n.chatNew),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // زر البحث - هذا هو المهم!
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                if (!widget.isSidebar) {
                  Navigator.pop(context);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              icon: Icon(AppIcons.getIcon(AppIcon.search), size: 16),
              label: Text(context.l10n.sidebarSearchInChats),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// قسم المجلدات
  Widget _buildFoldersSection(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.folder),
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (!widget.isSidebar) {
                        Navigator.pop(context);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FolderListScreen(),
                        ),
                      );
                    },
                    child: Text(
                      context.l10n.foldersTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                // زر فتح شاشة المجلدات
                IconButton(
                  onPressed: () {
                    if (!widget.isSidebar) {
                      Navigator.pop(context);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FolderListScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    AppIcons.getIcon(AppIcon.folder),
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  tooltip: context.l10n.sidebarOpenFoldersScreen,
                ),
                // زر إضافة مجلد جديد
                IconButton(
                  onPressed: () {
                    if (!widget.isSidebar) {
                      Navigator.pop(context);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateFolderScreen(),
                      ),
                    ).then((_) {
                      // تحديث المجلدات بعد إنشاء مجلد جديد
                      ref.read(folderProvider.notifier).refresh();
                    });
                  },
                  icon: Icon(
                    AppIcons.getIcon(AppIcon.plus),
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  tooltip: context.l10n.foldersCreate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _buildFolderList(context, theme, ref),
        ],
      ),
    );
  }

  /// قسم المحادثات الأخيرة
  Widget _buildRecentChatsSection(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(25),
                  width: 1,
                ),
              ),
            ),
            child: InkWell(
              onTap: () {
                if (!widget.isSidebar) {
                  Navigator.pop(context);
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChatHistoryScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Icon(
                    AppIcons.getIcon(AppIcon.chat),
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.chatHistoryFilterRecent,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Icon(
                    AppIcons.getIcon(AppIcon.arrowLeft),
                    size: 12,
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(153),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      ref.read(chatSessionsProvider.notifier).loadRecentChats();
                    },
                    icon: Icon(
                      AppIcons.getIcon(AppIcon.refresh),
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    tooltip: context.l10n.chatHistoryRefresh,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          _buildChatList(context, theme, ref),
        ],
      ),
    );
  }

  /// تذييل القائمة الجانبية
  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withAlpha(25),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildFooterMenuItem(
            theme,
            icon: AppIcons.getIcon(AppIcon.settings),
            title: context.l10n.settingsTitle,
            onTap: () {
              if (!widget.isSidebar) {
                Navigator.pop(context);
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const settings.SettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          _buildFooterMenuItem(
            theme,
            icon: AppIcons.getIcon(AppIcon.help),
            title: context.l10n.helpTitle,
            onTap: () {
              if (!widget.isSidebar) {
                Navigator.pop(context);
              }
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  /// عنصر في تذييل القائمة الجانبية
  Widget _buildFooterMenuItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// قائمة المجلدات
  Widget _buildFolderList(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
  ) {
    final folderState = ref.watch(folderProvider);

    // تحميل المجلدات عند أول بناء
    if (!folderState.hasLoadedInitial && !folderState.isLoadingFolders) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(folderProvider.notifier).loadFolders();
      });
    }

    if (folderState.isLoadingFolders) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (folderState.error != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              AppIcons.getIcon(AppIcon.exclamationTriangle),
              color: theme.colorScheme.error,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              folderState.error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(folderProvider.notifier).refresh();
              },
              child: Text(context.l10n.commonRetry),
            ),
          ],
        ),
      );
    }

    final folders = folderState.visibleFolders;

    if (folders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              AppIcons.getIcon(AppIcon.folder),
              size: 32,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.sidebarNoFolders,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
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
          _drawerDraggingFolderId = folders[index].id;
        });
      },
      onReorderEnd: (_) {
        setState(() {
          _drawerDraggingFolderId = null;
        });
      },
      itemCount: folders.length,
      onReorder: (oldIndex, newIndex) => _handleDrawerFolderReorder(
        folderState,
        folders,
        ref,
        oldIndex,
        newIndex,
      ),
      itemBuilder: (context, index) {
        final folder = folders[index];
        return KeyedSubtree(
          key: ValueKey(folder.id),
          child: _buildDrawerFolderTile(context, theme, folder, ref, index),
        );
      },
    );
  }

  Widget _buildDrawerFolderTile(
    BuildContext context,
    ThemeData theme,
    Folder folder,
    WidgetRef ref,
    int itemIndex,
  ) {
    final isFixedFolder = folder.isFixed;
    final folderColor = _getFolderColor(folder, theme);
    final l10n = context.l10n;
    final protectedTooltip = isFixedFolder
        ? l10n.sidebarFixedFolderTooltip
        : folder.isSystem
        ? l10n.sidebarSystemFolderTooltip
        : l10n.sidebarProtectedFolderTooltip;
    final rowBackgroundColor = isFixedFolder
        ? folderColor.withAlpha(16)
        : Colors.transparent;
    final iconBackgroundColor = isFixedFolder
        ? folderColor.withAlpha(64)
        : folderColor;
    final folderIconColor = isFixedFolder ? folderColor : Colors.white;
    final canShowMenu = !isFixedFolder;
    final isDragging = _drawerDraggingFolderId == folder.id;

    Widget? actionWidget;
    if (canShowMenu) {
      actionWidget = PopupMenuButton<String>(
        onSelected: (value) =>
            _handleFolderMenuAction(context, ref, folder, value),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.edit),
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(l10n.commonEdit),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.delete),
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(l10n.commonDelete, style: TextStyle(color: theme.colorScheme.error)),
              ],
            ),
          ),
        ],
        icon: Icon(
          AppIcons.getIcon(AppIcon.menu),
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    } else if (isFixedFolder) {
      actionWidget = Tooltip(
        message: protectedTooltip,
        child: Icon(
          AppIcons.getIcon(AppIcon.lock),
          size: 16,
          color: folderColor,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: rowBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (!widget.isSidebar) {
              Navigator.pop(context);
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FolderContentScreen(folder: folder),
              ),
            );
          },
          child: DashedBorder(
            show: isDragging,
            color: theme.colorScheme.primary,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDrawerDragHandle(
                      theme: theme,
                      folder: folder,
                      itemIndex: itemIndex,
                      isHandleEnabled: !isFixedFolder,
                      iconBackgroundColor: iconBackgroundColor,
                      iconColor: folderIconColor,
                    ),
                  ),
                  if (actionWidget != null) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(child: actionWidget),
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

  Widget _buildDrawerDragHandle({
    required ThemeData theme,
    required Folder folder,
    required int itemIndex,
    required bool isHandleEnabled,
    required Color iconBackgroundColor,
    required Color iconColor,
  }) {
    final handleContent = Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(folder.icon.iconData, size: 14, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  folder.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (folder.description != null &&
                    folder.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    folder.description!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                folder.chatCount.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (!isHandleEnabled) {
      return handleContent;
    }

    return ReorderableDragStartListener(index: itemIndex, child: handleContent);
  }

  void _handleDrawerFolderReorder(
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

  /// معالجة إجراءات قائمة المجلد
  void _handleFolderMenuAction(
    BuildContext context,
    WidgetRef ref,
    Folder folder,
    String action,
  ) {
    if (action == 'edit') {
      if (!widget.isSidebar) {
        Navigator.pop(context);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateFolderScreen(folderToEdit: folder),
        ),
      ).then((_) {
        // تحديث المجلدات بعد التعديل
        ref.read(folderProvider.notifier).refresh();
      });
    } else if (action == 'delete') {
      _showDeleteConfirmationDialog(context, ref, folder);
    }
  }

  /// عرض حوار تأكيد الحذف
  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    Folder folder,
  ) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sidebarDeleteFolderTitle),
        content: Text(
          l10n.sidebarDeleteFolderMessage(folder.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(folderProvider.notifier).deleteFolder(folder.id);
                final folderState = ref.read(folderProvider);
                if (folderState.deleteError == null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(context.l10n.sidebarFolderDeletedSuccess),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else if (folderState.deleteError != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(folderState.deleteError!),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
  }

  /// قائمة المحادثات
  Widget _buildChatList(BuildContext context, ThemeData theme, WidgetRef ref) {
    return SizedBox(
      height: 300,
      child: RecentChatsWidget(
        selectedSessionId: null, // لا يوجد محادثة محددة في القائمة الجانبية
        onSessionSelected: (sessionId) {
          print('🔥🔥🔥 تم اختيار المحادثة من AppDrawer: $sessionId 🔥🔥🔥');
          if (!widget.isSidebar) {
            Navigator.pop(context);
          }
          // تحميل المحادثة المحددة
          ref.read(chatProvider.notifier).loadChat(sessionId);
          print('✅ تم استدعاء loadChat للمحادثة: $sessionId');
        },
        showRefreshButton: false,
      ),
    );
  }
}
