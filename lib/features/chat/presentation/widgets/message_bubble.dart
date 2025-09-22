import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/message.dart';
import '../../domain/models/message_attachment.dart';
import '../../../../core/theme/icons.dart';

/// مكون فقاعة الرسالة
///
/// يعرض رسالة واحدة مع تصميم مختلف حسب نوع الرسالة
class MessageBubble extends ConsumerWidget {
  /// الرسالة المراد عرضها
  final Message message;

  /// هل يجب عرض معلومات المرسل
  final bool showSenderInfo;

  /// هل يجب عرض الوقت
  final bool showTimestamp;

  /// هل الرسالة مختارة
  final bool isSelected;

  /// هل يمكن تحرير الرسالة
  final bool isEditable;

  /// هل يمكن حذف الرسالة
  final bool isDeletable;

  /// دالة الاستدعاء عند النقر على الرسالة
  final VoidCallback? onTap;

  /// دالة الاستدعاء عند النقر المطول
  final VoidCallback? onLongPress;

  /// دالة الاستدعاء عند تحرير الرسالة
  final Function(String newContent)? onEdit;

  /// دالة الاستدعاء عند حذف الرسالة
  final VoidCallback? onDelete;

  /// دالة الاستدعاء عند الرد على الرسالة
  final VoidCallback? onReply;

  const MessageBubble({
    super.key,
    required this.message,
    this.showSenderInfo = true,
    this.showTimestamp = true,
    this.isSelected = false,
    this.isEditable = false,
    this.isDeletable = false,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDelete,
    this.onReply,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isUser = message.isUserMessage;
    final isAssistant = message.isAssistantMessage;
    final isSystem = message.isSystemMessage;
    final isWelcome = message.isWelcomeMessage;
    final isSuggestion = message.isSuggestionMessage;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: isSystem ? 8 : 4),
      child: _buildMessageContent(
        context,
        theme,
        isUser,
        isAssistant,
        isSystem,
        isWelcome,
        isSuggestion,
      ),
    );
  }

  Widget _buildMessageContent(
    BuildContext context,
    ThemeData theme,
    bool isUser,
    bool isAssistant,
    bool isSystem,
    bool isWelcome,
    bool isSuggestion,
  ) {
    if (isSystem) {
      return _buildSystemMessage(context, theme);
    } else if (isWelcome) {
      return _buildWelcomeMessage(context, theme);
    } else if (isSuggestion) {
      return _buildSuggestionMessage(context, theme);
    } else {
      return _buildChatMessage(context, theme, isUser, isAssistant);
    }
  }

  /// بناء رسالة النظام
  Widget _buildSystemMessage(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant..withAlpha(128),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline..withAlpha(75),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.info),
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.content,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء رسالة الترحيب
  Widget _buildWelcomeMessage(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withAlpha(1175),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  AppIcons.getIcon(AppIcon.lightbulb),
                  size: 20,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'مرحباً بك في مساعد كفو!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء رسالة الاقتراح
  Widget _buildSuggestionMessage(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary..withAlpha(75),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.lightbulb),
                size: 18,
                color: theme.colorScheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'اقتراح',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء رسالة المحادثة العادية
  Widget _buildChatMessage(
    BuildContext context,
    ThemeData theme,
    bool isUser,
    bool isAssistant,
  ) {
    return Row(
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[
          _buildAvatar(theme, isAssistant),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (showSenderInfo && !isUser) ...[
                  Text(
                    message.senderName ?? 'مساعد كفو',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                GestureDetector(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isUser ? 18 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 18),
                      ),
                      border: isSelected
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isUser
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                        if (message.hasAttachments) ...[
                          const SizedBox(height: 8),
                          _buildAttachments(theme),
                        ],
                      ],
                    ),
                  ),
                ),
                if (showTimestamp) ...[
                  const SizedBox(height: 4),
                  Text(
                    message.formattedTime,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (message.state.isFailed) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppIcons.getIcon(AppIcon.exclamation),
                        size: 12,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'فشل الإرسال',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isUser) ...[const SizedBox(width: 8), _buildAvatar(theme, isUser)],
      ],
    );
  }

  /// بناء صورة شخصية المرسل
  Widget _buildAvatar(ThemeData theme, bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser ? theme.colorScheme.primary : theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        isUser
            ? AppIcons.getIcon(AppIcon.user)
            : AppIcons.getIcon(AppIcon.user),
        size: 18,
        color: isUser
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSecondary,
      ),
    );
  }

  /// بناء المرفقات
  Widget _buildAttachments(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: message.attachments.map((attachment) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outline..withAlpha(75)),
          ),
          child: Row(
            children: [
              Icon(
                _getAttachmentIcon(attachment.type),
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.fileName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (attachment.fileSize != null)
                      Text(
                        attachment.formattedFileSize,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: فتح المرفق
                },
                icon: Icon(AppIcons.getIcon(AppIcon.external), size: 16),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// الحصول على أيقونة المرفق
  IconData _getAttachmentIcon(AttachmentType type) {
    switch (type) {
      case AttachmentType.image:
        return AppIcons.getIcon(AppIcon.image);
      case AttachmentType.audio:
        return AppIcons.getIcon(AppIcon.play);
      case AttachmentType.video:
        return AppIcons.getIcon(AppIcon.play);
      case AttachmentType.document:
        return AppIcons.getIcon(AppIcon.file);
      case AttachmentType.archive:
        return AppIcons.getIcon(AppIcon.archive);
      case AttachmentType.other:
        return AppIcons.getIcon(AppIcon.file);
    }
  }
}

/// مكون قائمة الإجراءات للرسالة
class MessageActionsMenu extends StatelessWidget {
  final Message message;
  final bool isEditable;
  final bool isDeletable;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReply;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  const MessageActionsMenu({
    super.key,
    required this.message,
    this.isEditable = false,
    this.isDeletable = false,
    this.onEdit,
    this.onDelete,
    this.onReply,
    this.onCopy,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'reply':
            onReply?.call();
            break;
          case 'copy':
            onCopy?.call();
            break;
          case 'share':
            onShare?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (!message.isSystemMessage) ...[
          PopupMenuItem(
            value: 'reply',
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.arrowTurnUpLeft),
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Text('الرد'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'copy',
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.clipboard),
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Text('نسخ'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'share',
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.share),
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Text('مشاركة'),
              ],
            ),
          ),
        ],
        if (isEditable && message.isUserMessage) ...[
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.edit),
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 12),
                Text('تحرير'),
              ],
            ),
          ),
        ],
        if (isDeletable) ...[
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
                Text('حذف', style: TextStyle(color: theme.colorScheme.error)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
