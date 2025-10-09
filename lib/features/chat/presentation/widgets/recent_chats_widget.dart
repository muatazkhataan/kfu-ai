import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/icons.dart';
import '../../../../services/api/chat/models/session_dto.dart';
import '../providers/chat_sessions_provider.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.clock),
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'المحادثات الأخيرة',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (widget.showRefreshButton)
                IconButton(
                  onPressed: sessionsState.isLoading
                      ? null
                      : () {
                          ref
                              .read(chatSessionsProvider.notifier)
                              .loadRecentChats();
                        },
                  icon: sessionsState.isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        )
                      : Icon(
                          AppIcons.getIcon(AppIcon.refresh),
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                  tooltip: 'تحديث',
                  iconSize: 20,
                ),
            ],
          ),
        ),

        // Content
        Expanded(child: _buildContent(theme, sessionsState)),
      ],
    );
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
                child: const Text('إعادة المحاولة'),
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
                'لا توجد محادثات أخيرة',
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

    // عرض القائمة
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sessionsState.recentSessions.length,
      itemBuilder: (context, index) {
        final session = sessionsState.recentSessions[index];
        return _buildSessionItem(theme, session);
      },
    );
  }

  Widget _buildSessionItem(ThemeData theme, SessionDto session) {
    final isSelected = widget.selectedSessionId == session.sessionId;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onSessionSelected?.call(session.sessionId),
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
                  ],
                ),

                // التاريخ
                const SizedBox(height: 4),
                Text(
                  _formatDate(session.updatedAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer.withAlpha(179)
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} يوم';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
