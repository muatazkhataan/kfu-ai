import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';
import '../providers/chat_history_provider.dart';
import '../../../chat/domain/models/chat.dart';
import '../../../chat/presentation/providers/chat_provider.dart';

/// Chat history screen widget
class ChatHistoryScreen extends ConsumerStatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  ConsumerState<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends ConsumerState<ChatHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // تحميل المحادثات عند بدء الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatHistoryProvider.notifier).loadChatHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.chatHistoryFilterRecent),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and filter bar
          _buildSearchAndFilterBar(theme),

          // Chat history list
          Expanded(child: _buildChatHistoryList(theme)),
        ],
      ),
    );
  }

  /// Build search and filter bar
  Widget _buildSearchAndFilterBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              // استدعاء البحث من API
              if (value.trim().isEmpty) {
                ref.read(chatHistoryProvider.notifier).searchChats('');
              } else {
                ref.read(chatHistoryProvider.notifier).searchChats(value);
              }
            },
            decoration: InputDecoration(
              hintText: context.l10n.chatHistorySearchPlaceholder,
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                        // إعادة تعيين البحث
                        ref.read(chatHistoryProvider.notifier).searchChats('');
                      },
                      icon: Icon(
                        Icons.clear,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(
                0.3,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter and sort buttons
          Row(
            children: [
              Expanded(flex: 2, child: _buildFilterDropdown(theme)),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildSortDropdown(theme)),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                    0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: _refreshChatHistory,
                  icon: Icon(Icons.refresh, size: 20),
                  color: theme.colorScheme.onSurface,
                  tooltip: context.l10n.chatHistoryRefresh,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build filter dropdown
  Widget _buildFilterDropdown(ThemeData theme) {
    return DropdownButtonFormField<String>(
      initialValue: 'all',
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'تصفية',
        prefixIcon: Icon(
          Icons.filter_list,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        labelStyle: theme.textTheme.bodySmall,
      ),
      style: theme.textTheme.bodySmall,
      items: [
        DropdownMenuItem(
          value: 'all',
          child: Text('الكل', style: theme.textTheme.bodySmall),
        ),
        DropdownMenuItem(
          value: 'recent',
          child: Text('الأخيرة', style: theme.textTheme.bodySmall),
        ),
        DropdownMenuItem(
          value: 'archived',
          child: Text('المؤرشفة', style: theme.textTheme.bodySmall),
        ),
      ],
      onChanged: (value) {
        // TODO: Implement filter logic
      },
    );
  }

  /// Build sort dropdown
  Widget _buildSortDropdown(ThemeData theme) {
    return DropdownButtonFormField<String>(
      initialValue: 'date_desc',
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'ترتيب',
        prefixIcon: Icon(
          Icons.sort,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        labelStyle: theme.textTheme.bodySmall,
      ),
      style: theme.textTheme.bodySmall,
      items: [
        DropdownMenuItem(
          value: 'date_desc',
          child: Text('الأحدث', style: theme.textTheme.bodySmall),
        ),
        DropdownMenuItem(
          value: 'date_asc',
          child: Text('الأقدم', style: theme.textTheme.bodySmall),
        ),
        DropdownMenuItem(
          value: 'title',
          child: Text('العنوان', style: theme.textTheme.bodySmall),
        ),
        DropdownMenuItem(
          value: 'messages',
          child: Text('الرسائل', style: theme.textTheme.bodySmall),
        ),
      ],
      onChanged: (value) {
        // TODO: Implement sort logic
      },
    );
  }

  /// Build chat history list
  Widget _buildChatHistoryList(ThemeData theme) {
    final chatHistoryState = ref.watch(chatHistoryProvider);

    // حالة التحميل الأولي
    if (chatHistoryState.isLoadingChats && !chatHistoryState.hasLoadedInitial) {
      return _buildLoadingState(theme);
    }

    // حالة البحث جاري
    if (chatHistoryState.isSearching) {
      return _buildLoadingState(theme);
    }

    // استخدام المحادثات المفلترة من Provider (التي تأتي من API)
    final filteredChats = chatHistoryState.filteredChats;

    // عرض رسالة خطأ البحث إذا وجدت
    if (chatHistoryState.searchError != null && filteredChats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'خطأ في البحث',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                chatHistoryState.searchError!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (filteredChats.isEmpty) {
      return _buildEmptyState(theme, chatHistoryState.error ?? chatHistoryState.searchError);
    }

    return Column(
      children: [
        // عرض رسالة خطأ إذا وجدت
        if (chatHistoryState.error != null)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.error.withAlpha(76)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    chatHistoryState.error!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // قائمة المحادثات
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.read(chatHistoryProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                final chat = filteredChats[index];
                return _buildChatItem(theme, chat);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Build loading state
  Widget _buildLoadingState(ThemeData theme) {
    return Center(
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
    );
  }

  /// Build individual chat item
  Widget _buildChatItem(ThemeData theme, Chat chat) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: InkWell(
          onTap: () => _openChat(chat),
          onLongPress: () => _showChatMenu(theme, chat),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    if (chat.isPinned) ...[
                      Icon(
                        Icons.push_pin,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (chat.isFavorite) ...[
                      Icon(
                        Icons.favorite,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        chat.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (chat.folderId != null && chat.folderId!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getFolderDisplayName(chat.folderId!),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Preview
                Text(
                  chat.lastMessagePreview ?? 'لا توجد رسائل بعد',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Footer row
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      chat.metadata?['lastActivityText'] ??
                          _formatLastActivity(chat.lastActivityAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${chat.messageCount} ${chat.messageCount == 1 ? 'رسالة' : 'رسالة'}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  /// Get folder display name
  String _getFolderDisplayName(String folderId) {
    // يمكن تحسين هذا بجلب أسماء المجلدات من API
    switch (folderId.toLowerCase()) {
      case 'programming':
        return 'البرمجة';
      case 'academic':
        return 'أكاديمي';
      case 'databases':
        return 'قواعد البيانات';
      case 'algorithms':
        return 'خوارزميات';
      default:
        return folderId;
    }
  }

  /// Format last activity time
  String _formatLastActivity(DateTime? lastActivity) {
    if (lastActivity == null) return 'غير معروف';

    final now = DateTime.now();
    final diff = now.difference(lastActivity);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inDays < 1) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return 'منذ ${(diff.inDays / 7).floor()} أسبوع';
    }
  }

  /// Build empty state
  Widget _buildEmptyState(ThemeData theme, String? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? (error != null
                      ? 'تعذر تحميل المحادثات'
                      : 'لا توجد محادثات بعد')
                : 'لا توجد نتائج للبحث',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'ابدأ محادثة جديدة لإنشاء سجل المحادثات'
                : 'جرب البحث بكلمات مختلفة',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(153),
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: Text(context.l10n.chatHistoryClearFilters),
            ),
          ],
        ],
      ),
    );
  }

  /// Open chat
  void _openChat(Chat chat) {
    Navigator.pop(context);
    // تحميل المحادثة المحددة
    ref.read(chatProvider.notifier).loadChat(chat.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.chatOpeningChat(chat.title))));
  }

  /// Show chat menu
  void _showChatMenu(ThemeData theme, Chat chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                chat.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: theme.colorScheme.error,
              ),
              title: Text(
                chat.isFavorite 
                    ? context.l10n.chatRemoveFromFavorites 
                    : context.l10n.chatAddToFavorites,
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Toggle favorite status
              },
            ),
            ListTile(
              leading: Icon(
                chat.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(chat.isPinned 
                  ? context.l10n.chatUnpin 
                  : context.l10n.chatPin),
              onTap: () {
                Navigator.pop(context);
                // TODO: Toggle pin status
              },
            ),
            ListTile(
              leading: Icon(
                Icons.archive_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(context.l10n.chatHistoryArchive),
              onTap: () {
                Navigator.pop(context);
                // TODO: Archive chat
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(context.l10n.chatShare),
              onTap: () {
                Navigator.pop(context);
                // TODO: Share chat
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
              ),
              title: Text(
                context.l10n.chatHistoryDelete,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(theme, chat);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show delete confirmation
  void _showDeleteConfirmation(ThemeData theme, Chat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.chatHistoryDelete),
        content: Text(context.l10n.chatHistoryConfirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // حذف المحادثة
              ref.read(chatHistoryProvider.notifier).deleteChat(chat.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.chatDeleted(chat.title))),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
  }

  /// Refresh chat history
  void _refreshChatHistory() {
    ref.read(chatHistoryProvider.notifier).refresh();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.chatHistoryUpdated)));
  }
}
