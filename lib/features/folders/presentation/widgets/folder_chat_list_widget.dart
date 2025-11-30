import 'package:flutter/material.dart';
import '../../../../core/theme/icons.dart';

/// مكون قائمة محادثات المجلد
///
/// يعرض قائمة المحادثات مع إمكانية الفلترة والترتيب
class FolderChatListWidget extends StatelessWidget {
  final List<dynamic> chats;
  final Function(dynamic)? onChatTap;
  final Function(dynamic)? onChatLongPress;
  final String? searchQuery;

  const FolderChatListWidget({
    super.key,
    required this.chats,
    this.onChatTap,
    this.onChatLongPress,
    this.searchQuery,
  });

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

  Widget _buildChatItem(BuildContext context, ThemeData theme, dynamic chat) {
    final title = chat['Title'] ?? chat['title'] ?? 'محادثة بدون عنوان';
    final updatedAt = chat['UpdatedAt'] ?? chat['updatedAt'];
    final messageCount = chat['MessageCount'] ?? chat['messageCount'] ?? 0;
    final isArchived = chat['IsArchived'] ?? chat['isArchived'] ?? false;

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
        trailing: messageCount > 0
            ? Chip(
                label: Text('$messageCount'),
                padding: EdgeInsets.zero,
              )
            : null,
        onTap: () => onChatTap?.call(chat),
        onLongPress: () => onChatLongPress?.call(chat),
      ),
    );
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
            searchQuery != null && searchQuery!.isNotEmpty
                ? 'لا توجد نتائج للبحث'
                : 'لا توجد محادثات',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery != null && searchQuery!.isNotEmpty
                ? 'جرب كلمات بحث أخرى'
                : 'هذا المجلد فارغ حالياً',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  List<dynamic> _filterChats() {
    if (searchQuery == null || searchQuery!.isEmpty) {
      return chats;
    }

    final query = searchQuery!.toLowerCase();
    return chats.where((chat) {
      final title = (chat['Title'] ?? chat['title'] ?? '').toString().toLowerCase();
      return title.contains(query);
    }).toList();
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'غير محدد';
    try {
      final dateTime = date is String ? DateTime.parse(date) : date as DateTime;
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return 'اليوم';
      } else if (difference.inDays == 1) {
        return 'أمس';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} أيام';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'غير محدد';
    }
  }
}

