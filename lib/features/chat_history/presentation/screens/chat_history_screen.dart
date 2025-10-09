import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                _searchQuery = value.toLowerCase();
              });
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
              Expanded(child: _buildFilterDropdown(theme)),
              const SizedBox(width: 12),
              Expanded(child: _buildSortDropdown(theme)),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _refreshChatHistory,
                icon: Icon(Icons.refresh, color: theme.colorScheme.onSurface),
                tooltip: context.l10n.chatHistoryRefresh,
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
      value: 'all',
      decoration: InputDecoration(
        labelText: 'تصفية',
        prefixIcon: Icon(
          Icons.filter_list,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        DropdownMenuItem(
          value: 'all',
          child: Text(context.l10n.chatHistoryFilterAll),
        ),
        DropdownMenuItem(
          value: 'recent',
          child: Text(context.l10n.chatHistoryFilterRecent),
        ),
        DropdownMenuItem(
          value: 'archived',
          child: Text(context.l10n.chatHistoryFilterArchived),
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
      value: 'date_desc',
      decoration: InputDecoration(
        labelText: 'ترتيب',
        prefixIcon: Icon(Icons.sort, color: theme.colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        DropdownMenuItem(
          value: 'date_desc',
          child: Text(context.l10n.chatHistorySortDateDesc),
        ),
        DropdownMenuItem(
          value: 'date_asc',
          child: Text(context.l10n.chatHistorySortDateAsc),
        ),
        DropdownMenuItem(
          value: 'title',
          child: Text(context.l10n.chatHistorySortTitle),
        ),
        DropdownMenuItem(
          value: 'messages',
          child: Text(context.l10n.chatHistorySortMessages),
        ),
      ],
      onChanged: (value) {
        // TODO: Implement sort logic
      },
    );
  }

  /// Build chat history list
  Widget _buildChatHistoryList(ThemeData theme) {
    // TODO: Replace with actual data from provider
    final mockChats = _getMockChats();
    final filteredChats = _searchQuery.isEmpty
        ? mockChats
        : mockChats
              .where(
                (chat) =>
                    chat['title'].toLowerCase().contains(_searchQuery) ||
                    chat['preview'].toLowerCase().contains(_searchQuery),
              )
              .toList();

    if (filteredChats.isEmpty) {
      return _buildEmptyState(theme);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        return _buildChatItem(theme, chat);
      },
    );
  }

  /// Build individual chat item
  Widget _buildChatItem(ThemeData theme, Map<String, dynamic> chat) {
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
                    if (chat['isPinned']) ...[
                      Icon(
                        Icons.push_pin,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (chat['isFavorite']) ...[
                      Icon(
                        Icons.favorite,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        chat['title'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (chat['folder'] != null)
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
                          chat['folder'],
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
                  chat['preview'],
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
                      chat['lastActivity'],
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
                        '${chat['messageCount']} رسالة',
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

  /// Build empty state
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? context.l10n.chatHistoryEmptyState
                : context.l10n.commonNoResults,
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
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
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

  /// Get mock chat data
  List<Map<String, dynamic>> _getMockChats() {
    return [
      {
        'id': '1',
        'title': 'مساعدة في الرياضيات',
        'preview': 'كيف يمكنني حل المعادلة التربيعية؟',
        'lastActivity': 'منذ ساعتين',
        'messageCount': 15,
        'folder': 'الرياضيات',
        'isPinned': true,
        'isFavorite': false,
      },
      {
        'id': '2',
        'title': 'أسئلة البرمجة',
        'preview': 'ما الفرق بين Array و List في Python؟',
        'lastActivity': 'منذ 5 ساعات',
        'messageCount': 8,
        'folder': 'البرمجة',
        'isPinned': false,
        'isFavorite': true,
      },
      {
        'id': '3',
        'title': 'مشروع التخرج',
        'preview': 'أحتاج مساعدة في اختيار موضوع مشروع التخرج',
        'lastActivity': 'منذ يوم',
        'messageCount': 23,
        'folder': null,
        'isPinned': false,
        'isFavorite': false,
      },
      {
        'id': '4',
        'title': 'الفيزياء',
        'preview': 'شرح قانون نيوتن الثاني',
        'lastActivity': 'منذ يومين',
        'messageCount': 12,
        'folder': 'العلوم',
        'isPinned': false,
        'isFavorite': false,
      },
    ];
  }

  /// Open chat
  void _openChat(Map<String, dynamic> chat) {
    // TODO: Navigate to chat screen with specific chat
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('فتح المحادثة: ${chat['title']}')));
  }

  /// Show chat menu
  void _showChatMenu(ThemeData theme, Map<String, dynamic> chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                chat['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                color: theme.colorScheme.error,
              ),
              title: Text(
                chat['isFavorite'] ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Toggle favorite status
              },
            ),
            ListTile(
              leading: Icon(
                chat['isPinned'] ? Icons.push_pin : Icons.push_pin_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(chat['isPinned'] ? 'إلغاء التثبيت' : 'تثبيت'),
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
  void _showDeleteConfirmation(ThemeData theme, Map<String, dynamic> chat) {
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
              // TODO: Delete chat
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف المحادثة: ${chat['title']}')),
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
    // TODO: Implement refresh logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تحديث سجل المحادثات')));
  }
}
