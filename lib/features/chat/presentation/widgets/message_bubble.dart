import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/models/message.dart';
import '../../domain/models/message_attachment.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/utils/html_utils.dart';
import '../../../../core/localization/l10n.dart';

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
        color: theme.colorScheme.surfaceContainerHighest..withAlpha(128),
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
    // رسالة المستخدم: أيقونة على اليسار، فقاعة على اليمين
    // رسالة المساعد: أيقونة على اليمين، فقاعة على اليسار
    if (isUser) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onTap,
                    onLongPress: onLongPress,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(
                          128,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(4),
                          topRight: const Radius.circular(18),
                          bottomLeft: const Radius.circular(18),
                          bottomRight: const Radius.circular(18),
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
                          // عرض المحتوى (HTML أو نص عادي)
                          _buildMessageText(
                            context,
                            theme,
                            isUser,
                            isAssistant,
                            message.content,
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
          const SizedBox(width: 8),
          // أيقونة المستخدم على اليسار
          _buildAvatar(theme, isUser),
        ],
      );
    } else {
      // رسالة المساعد
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // أيقونة المساعد على اليمين
          _buildAvatar(theme, isUser),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showSenderInfo && !isUser) ...[
                    Text(
                      // تجاهل أي اسم قادم من الـ API وعرض الاسم المترجم دائماً
                      context.l10n.appNameShort,
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
                        color: Colors.white, // أبيض
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: const Radius.circular(4),
                          bottomRight: const Radius.circular(18),
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
                          // عرض المحتوى (HTML أو نص عادي)
                          _buildMessageText(
                            context,
                            theme,
                            isUser,
                            isAssistant,
                            message.content,
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
        ],
      );
    }
  }

  /// بناء محتوى الرسالة (HTML أو نص عادي)
  Widget _buildMessageText(
    BuildContext context,
    ThemeData theme,
    bool isUser,
    bool isAssistant,
    String content,
  ) {
    // التحقق من وجود HTML في المحتوى
    final hasHtml = HtmlUtils.containsHtml(content);

    // إذا كانت رسالة المساعد تحتوي على HTML، استخدم Html widget
    if (isAssistant && hasHtml) {
      // استخراج المصادر قبل التنظيف
      final sources = HtmlUtils.extractSources(content);

      // تنظيف HTML من div المصادر
      final cleanedHtml = HtmlUtils.cleanHtml(content);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Html(
            data: cleanedHtml,
            style: {
              'body': Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(14),
                color: Colors.black, // نص أسود
                lineHeight: const LineHeight(1.4),
                textAlign: TextAlign.right, // محاذاة لليمين
              ),
              'p': Style(
                margin: Margins.only(bottom: 8),
                padding: HtmlPaddings.zero,
                textAlign: TextAlign.right, // محاذاة لليمين
              ),
              'strong': Style(fontWeight: FontWeight.bold),
            },
          ),
          // عرض المصادر إن وجدت
          if (sources.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSources(context, theme, sources),
          ],
        ],
      );
    }

    // إذا كان نص عادي أو رسالة من المستخدم، استخدم Text widget
    final displayText = hasHtml
        ? HtmlUtils.htmlToFormattedText(content)
        : content;

    return Text(
      displayText,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: Colors.black, // نص أسود في كلا الحالتين
        height: 1.4,
      ),
      textAlign: TextAlign.right, // محاذاة لليمين
    );
  }

  /// بناء قسم المصادر - في صف واحد مع العنوان
  Widget _buildSources(
    BuildContext context,
    ThemeData theme,
    List<SourceInfo> sources,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.85,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // حساب العرض المتاح (نطرح البادينج الأفقي: 12 * 2 = 24)
          final availableWidth = constraints.maxWidth - 24;

          // حساب عرض العناصر الثابتة (الأيقونة + النص + المسافات)
          final iconWidth = 14.0 + 4.0; // حجم الأيقونة + المسافة
          final textWidth = _measureTextWidth(
            'المصادر',
            theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ) ??
                const TextStyle(),
          );
          final fixedElementsWidth =
              iconWidth + textWidth + 8.0; // 8 للمسافات الإضافية

          // حساب عدد الأيقونات التي يمكن عرضها
          // كل أيقونة تأخذ حوالي 20 بكسل (14 للأيقونة + 4 للبادينج + 2 للمسافة)
          final iconSize = 20.0;
          final maxIcons = ((availableWidth - fixedElementsWidth) / iconSize)
              .floor()
              .clamp(0, sources.length);
          final visibleSources = sources.take(maxIcons).toList();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: theme.colorScheme.outline.withAlpha(75),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.bookOpen,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _showSourcesDrawer(context, theme, sources),
                  child: Text(
                    'المصادر',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                ...visibleSources.asMap().entries.expand((entry) {
                  final index = entry.key;
                  final source = entry.value;
                  if (index == visibleSources.length - 1) {
                    return [_buildSourceChip(theme, source)];
                  }
                  return [
                    _buildSourceChip(theme, source),
                    const SizedBox(width: 2),
                  ];
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  /// حساب عرض النص
  double _measureTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.rtl,
      maxLines: 1,
      textScaleFactor: 1.0,
    );
    textPainter.layout(maxWidth: double.infinity);
    return textPainter.size.width;
  }

  /// عرض قائمة المصادر الجانبية من اليسار
  void _showSourcesDrawer(
    BuildContext context,
    ThemeData theme,
    List<SourceInfo> sources,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'إغلاق',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _buildSourcesDrawer(context, theme, sources);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
    );
  }

  /// بناء قائمة المصادر الجانبية
  Widget _buildSourcesDrawer(
    BuildContext context,
    ThemeData theme,
    List<SourceInfo> sources,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                // العنوان
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.bookOpen,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'المصادر',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          AppIcons.getIcon(AppIcon.close),
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // قائمة المصادر
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sources.length,
                    itemBuilder: (context, index) {
                      final source = sources[index];
                      return _buildSourceListItem(context, theme, source);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء عنصر في قائمة المصادر - تصميم بسيط
  Widget _buildSourceListItem(
    BuildContext context,
    ThemeData theme,
    SourceInfo source,
  ) {
    // تحديد الأيقونة واللون حسب نوع الملف
    IconData icon;
    Color iconColor;

    switch (source.fileType) {
      case 'ppt':
        icon = FontAwesomeIcons.filePowerpoint;
        iconColor = Colors.deepOrange;
        break;
      case 'pdf':
        icon = FontAwesomeIcons.filePdf;
        iconColor = Colors.red;
        break;
      case 'word':
        icon = FontAwesomeIcons.fileWord;
        iconColor = Colors.blue;
        break;
      case 'excel':
        icon = FontAwesomeIcons.fileExcel;
        iconColor = Colors.green;
        break;
      default:
        icon = FontAwesomeIcons.file;
        iconColor = theme.colorScheme.primary;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // يمكن إضافة إجراء عند الضغط هنا لاحقاً
        },
        borderRadius: BorderRadius.circular(8),
        hoverColor: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
        splashColor: theme.colorScheme.primary.withAlpha(50),
        highlightColor: theme.colorScheme.primary.withAlpha(30),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الأيقونة صغيرة في الأعلى
              FaIcon(icon, size: 16, color: iconColor),
              const SizedBox(height: 8),
              // عنوان المصدر
              Text(
                source.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // نوع الملف
              if (source.fileType.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  source.fileType.toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// بناء chip للمصدر - أيقونة بسيطة وملتصقة مع tooltip
  Widget _buildSourceChip(ThemeData theme, SourceInfo source) {
    // تحديد الأيقونة واللون حسب نوع الملف
    IconData icon;
    Color iconColor;

    switch (source.fileType) {
      case 'ppt':
        icon = FontAwesomeIcons.filePowerpoint;
        iconColor = Colors.deepOrange;
        break;
      case 'pdf':
        icon = FontAwesomeIcons.filePdf;
        iconColor = Colors.red;
        break;
      case 'word':
        icon = FontAwesomeIcons.fileWord;
        iconColor = Colors.blue;
        break;
      case 'excel':
        icon = FontAwesomeIcons.fileExcel;
        iconColor = Colors.green;
        break;
      default:
        icon = FontAwesomeIcons.file;
        iconColor = theme.colorScheme.primary;
    }

    return Tooltip(
      message: source.title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // يمكن إضافة إجراء عند الضغط هنا لاحقاً
          },
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: FaIcon(icon, size: 14, color: iconColor),
          ),
        ),
      ),
    );
  }

  /// بناء صورة شخصية المرسل
  Widget _buildAvatar(ThemeData theme, bool isUser) {
    if (isUser) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          AppIcons.getIcon(AppIcon.user),
          size: 18,
          color: theme.colorScheme.onPrimary,
        ),
      );
    }

    // أيقونة المساعد بصورة التطبيق
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        color: theme.colorScheme.secondary,
        child: Image.asset(
          'assets/images/mosa3ed_kfu_icon_app.jpg',
          fit: BoxFit.cover,
        ),
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
                icon: Icon(AppIcons.getIcon(AppIcon.link), size: 16),
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
