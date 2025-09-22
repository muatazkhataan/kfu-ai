import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../chat/domain/models/chat.dart';
import '../providers/chat_history_provider.dart';
import '../../../folders/presentation/providers/folder_provider.dart';
import '../../../../state/chat_history_state.dart';
import '../../../../state/folder_state.dart';
import '../../../../core/theme/icons.dart';

/// مكون الشريط الجانبي لقائمة المحادثات
///
/// يعرض قائمة المحادثات مع البحث والتصفية والترتيب
class ChatListSidebar extends ConsumerStatefulWidget {
  /// المحادثة المحددة حالياً
  final String? selectedChatId;

  /// دالة الاستدعاء عند تحديد محادثة
  final ValueChanged<String?>? onChatSelected;

  /// دالة الاستدعاء عند إنشاء محادثة جديدة
  final VoidCallback? onCreateChat;

  /// دالة الاستدعاء عند البحث
  final ValueChanged<String>? onSearch;

  /// دالة الاستدعاء عند تغيير الفلتر
  final ValueChanged<ChatHistoryFilter>? onFilterChanged;

  /// دالة الاستدعاء عند تغيير الترتيب
  final ValueChanged<ChatHistorySort>? onSortChanged;

  /// عرض الشريط الجانبي
  final double? width;

  /// هل يجب عرض شريط البحث
  final bool showSearchBar;

  /// هل يجب عرض أزرار الفلتر
  final bool showFilterButtons;

  /// هل يجب عرض أزرار الترتيب
  final bool showSortButtons;

  const ChatListSidebar({
    super.key,
    this.selectedChatId,
    this.onChatSelected,
    this.onCreateChat,
    this.onSearch,
    this.onFilterChanged,
    this.onSortChanged,
    this.width,
    this.showSearchBar = true,
    this.showFilterButtons = true,
    this.showSortButtons = true,
  });

  @override
  ConsumerState<ChatListSidebar> createState() => _ChatListSidebarState();
}

class _ChatListSidebarState extends ConsumerState<ChatListSidebar> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatHistoryState = ref.watch(chatHistoryProvider);
    final folderState = ref.watch(folderProvider);

    return Container(
      width: widget.width ?? 320,
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
          if (widget.showSearchBar) _buildHeader(context, theme),
          if (widget.showFilterButtons || widget.showSortButtons)
            _buildFilterBar(context, theme, chatHistoryState),
          _buildChatsList(context, theme, chatHistoryState, folderState),
        ],
      ),
    );
  }

  /// بناء رأس الشريط الجانبي
  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant..withAlpha(128),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline..withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.message),
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'المحادثات',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onCreateChat,
                icon: Icon(
                  AppIcons.getIcon(AppIcon.plus),
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'محادثة جديدة',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSearchBar(theme),
        ],
      ),
    );
  }

  /// بناء شريط البحث
  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      onChanged: (value) {
        widget.onSearch?.call(value);
        ref.read(chatHistoryProvider.notifier).searchChats(value);
      },
      decoration: InputDecoration(
        hintText: 'البحث في المحادثات...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant..withAlpha(153),
        ),
        prefixIcon: Icon(
          AppIcons.getIcon(AppIcon.search),
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  widget.onSearch?.call('');
                  ref.read(chatHistoryProvider.notifier).searchChats('');
                },
                icon: Icon(
                  AppIcons.getIcon(AppIcon.close),
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  /// بناء شريط الفلترة والترتيب
  Widget _buildFilterBar(
    BuildContext context,
    ThemeData theme,
    ChatHistoryState chatHistoryState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant..withAlpha(75),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline..withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.showFilterButtons) ...[
            Expanded(child: _buildFilterDropdown(theme, chatHistoryState)),
            const SizedBox(width: 8),
          ],
          if (widget.showSortButtons) ...[
            Expanded(child: _buildSortDropdown(theme, chatHistoryState)),
          ],
        ],
      ),
    );
  }

  /// بناء قائمة الفلتر
  Widget _buildFilterDropdown(
    ThemeData theme,
    ChatHistoryState chatHistoryState,
  ) {
    return DropdownButton<ChatHistoryFilter>(
      value: chatHistoryState.filter,
      onChanged: (filter) {
        if (filter != null) {
          widget.onFilterChanged?.call(filter);
          ref.read(chatHistoryProvider.notifier).applyFilter(filter);
        }
      },
      isExpanded: true,
      underline: Container(),
      items: ChatHistoryFilter.values.map((filter) {
        return DropdownMenuItem(
          value: filter,
          child: Text(filter.displayName, style: theme.textTheme.bodySmall),
        );
      }).toList(),
    );
  }

  /// بناء قائمة الترتيب
  Widget _buildSortDropdown(
    ThemeData theme,
    ChatHistoryState chatHistoryState,
  ) {
    return DropdownButton<ChatHistorySort>(
      value: chatHistoryState.sort,
      onChanged: (sort) {
        if (sort != null) {
          widget.onSortChanged?.call(sort);
          ref.read(chatHistoryProvider.notifier).changeSort(sort);
        }
      },
      isExpanded: true,
      underline: Container(),
      items: ChatHistorySort.values.map((sort) {
        return DropdownMenuItem(
          value: sort,
          child: Text(sort.displayName, style: theme.textTheme.bodySmall),
        );
      }).toList(),
    );
  }

  /// بناء قائمة المحادثات
  Widget _buildChatsList(
    BuildContext context,
    ThemeData theme,
    ChatHistoryState chatHistoryState,
    FolderState folderState,
  ) {
    if (chatHistoryState.isLoadingChats) {
      return _buildLoadingState(theme);
    }

    if (chatHistoryState.filteredChats.isEmpty) {
      return _buildEmptyState(theme, chatHistoryState);
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: chatHistoryState.filteredChats.length,
        itemBuilder: (context, index) {
          final chat = chatHistoryState.filteredChats[index];
          return _buildChatItem(context, theme, chat, folderState);
        },
      ),
    );
  }

  /// بناء عنصر محادثة
  Widget _buildChatItem(
    BuildContext context,
    ThemeData theme,
    Chat chat,
    FolderState folderState,
  ) {
    final isSelected = widget.selectedChatId == chat.id;
    final folder = chat.folderId != null
        ? folderState.getFolderById(chat.folderId!)
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onChatSelected?.call(chat.id),
          onLongPress: () => _showChatMenu(context, chat),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
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
                Row(
                  children: [
                    if (chat.isPinned) ...[
                      Icon(
                        AppIcons.getIcon(AppIcon.star),
                        size: 12,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                    ],
                    if (chat.isFavorite) ...[
                      Icon(
                        AppIcons.getIcon(AppIcon.heart),
                        size: 12,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        chat.title,
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
                    if (folder != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          folder.name,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                if (chat.hasLastMessage) ...[
                  Text(
                    chat.lastMessagePreview!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer.withOpacity(
                              0.7,
                            )
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Text(
                      chat.formattedLastActivity,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer.withOpacity(
                                0.6,
                              )
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    if (chat.hasMessages) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          chat.messageCount.toString(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء حالة التحميل
  Widget _buildLoadingState(ThemeData theme) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'جاري تحميل المحادثات...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء حالة فارغة
  Widget _buildEmptyState(ThemeData theme, ChatHistoryState chatHistoryState) {
    String title;
    String subtitle;
    AppIcon icon;

    if (chatHistoryState.hasActiveSearch) {
      title = 'لا توجد نتائج';
      subtitle = 'جرب البحث بكلمات مختلفة';
      icon = AppIcon.search;
    } else {
      title = 'لا توجد محادثات';
      subtitle = 'اضغط على + لإنشاء محادثة جديدة';
      icon = AppIcon.chat;
    }

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.getIcon(icon),
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(1175),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// عرض قائمة المحادثة
  void _showChatMenu(BuildContext context, Chat chat) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                AppIcons.getIcon(AppIcon.heart),
                color: chat.isFavorite
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              title: Text(
                chat.isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: تبديل حالة المفضلة
              },
            ),
            ListTile(
              leading: Icon(
                AppIcons.getIcon(AppIcon.star),
                color: theme.colorScheme.primary,
              ),
              title: Text(chat.isPinned ? 'إلغاء التثبيت' : 'تثبيت'),
              onTap: () {
                Navigator.pop(context);
                // TODO: تبديل حالة التثبيت
              },
            ),
            ListTile(
              leading: Icon(
                AppIcons.getIcon(AppIcon.archive),
                color: theme.colorScheme.primary,
              ),
              title: Text('أرشفة'),
              onTap: () {
                Navigator.pop(context);
                ref.read(chatHistoryProvider.notifier).archiveChats([chat.id]);
              },
            ),
            ListTile(
              leading: Icon(
                AppIcons.getIcon(AppIcon.trash),
                color: theme.colorScheme.error,
              ),
              title: Text(
                'حذف',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteChat(context, chat);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// تأكيد حذف المحادثة
  void _confirmDeleteChat(BuildContext context, Chat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف المحادثة'),
        content: Text('هل أنت متأكد من حذف المحادثة "${chat.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(chatHistoryProvider.notifier).deleteChat(chat.id);
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
}
