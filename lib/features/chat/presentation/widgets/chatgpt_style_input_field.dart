import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/extensions/context_extensions.dart';

/// مكون حقل الإدخال بأسلوب ChatGPT
///
/// يوفر تجربة مشابهة لـ ChatGPT مع التوسع التلقائي والحد الأقصى للأسطر
class ChatGPTStyleInputField extends ConsumerStatefulWidget {
  /// النص الحالي
  final String text;

  /// دالة الاستدعاء عند تغيير النص
  final ValueChanged<String>? onTextChanged;

  /// دالة الاستدعاء عند إرسال الرسالة
  final Function(String message)? onSend;

  /// دالة الاستدعاء عند إرفاق ملف
  final VoidCallback? onAttachFile;

  /// هل الحقل مفعل
  final bool enabled;

  /// نص التلميح
  final String? hintText;

  const ChatGPTStyleInputField({
    super.key,
    this.text = '',
    this.onTextChanged,
    this.onSend,
    this.onAttachFile,
    this.enabled = true,
    this.hintText,
  });

  @override
  ConsumerState<ChatGPTStyleInputField> createState() =>
      _ChatGPTStyleInputFieldState();
}

class _ChatGPTStyleInputFieldState extends ConsumerState<ChatGPTStyleInputField>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _sendButtonController;

  late Animation<double> _sendButtonScaleAnimation;
  late Animation<double> _sendButtonOpacityAnimation;

  // متغيرات التحكم في التوسيع التلقائي
  static const int _maxLines = 6; // الحد الأقصى للأسطر مثل ChatGPT
  static const int _minLines = 1; // الحد الأدنى للأسطر
  static const double _lineHeight = 24.0; // ارتفاع السطر الواحد
  static const double _verticalPadding = 12.0; // الحشو العمودي

  bool _hasText = false;
  final GlobalKey _inputFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _controller = TextEditingController(text: widget.text);
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
  }

  void _initializeControllers() {
    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _sendButtonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.elasticOut),
    );

    _sendButtonOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sendButtonController, curve: Curves.easeIn),
    );
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });

      if (hasText) {
        _sendButtonController.forward();
      } else {
        _sendButtonController.reverse();
      }
    }
    widget.onTextChanged?.call(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _sendButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = context.isRTL;

    return Container(
      key: _inputFieldKey,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(child: _buildInputRow(theme, isRTL)),
    );
  }

  /// بناء صف الإدخال الرئيسي
  Widget _buildInputRow(ThemeData theme, bool isRTL) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24), // أكثر استدارة مثل ChatGPT
      ),
      child: Row(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // زر التكبير في مكان زر الإرفاق (يمين في RTL، يسار في LTR)
          _buildExpandButton(theme),
          const SizedBox(width: 8),

          // حقل النص مع التوسع التلقائي في الوسط
          Expanded(child: _buildAutoResizeTextField(theme, isRTL)),

          // زر الإرسال في الجهة المقابلة
          const SizedBox(width: 8),
          _buildSendButton(theme, isRTL),
        ],
      ),
    );
  }

  /// بناء حقل النص مع التوسع التلقائي
  Widget _buildAutoResizeTextField(ThemeData theme, bool isRTL) {
    return Container(
      constraints: BoxConstraints(
        minHeight: _verticalPadding * 2 + _lineHeight,
        maxHeight: _verticalPadding * 2 + (_maxLines * _lineHeight),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        maxLines: null, // يسمح بعدد أسطر متغير
        minLines: _minLines,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        onChanged: (value) {
          widget.onTextChanged?.call(value);
          setState(() {}); // إعادة بناء للتوسع التلقائي
        },
        onSubmitted: (_) => _sendMessage(),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'اكتب رسالتك هنا...',
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(153),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: _verticalPadding,
          ),
        ),
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.5, // تباعد الأسطر
        ),
      ),
    );
  }

  // تم إخفاء زر الإرفاق حالياً بطلبك؛ إن احتجناه مستقبلاً سنعيده

  /// زر التكبير (يفتح محرّر كامل كشريط سفلي ModalBottomSheet)
  Widget _buildExpandButton(ThemeData theme) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: IconButton(
        onPressed: _openExpandedComposer,
        icon: Align(
          alignment: Alignment.topRight, // في الطرف العلوي الأيمن
          child: Padding(
            padding: const EdgeInsets.only(top: 4, right: 4), // نقل للأعلى
            child: Icon(
              AppIcons.getIcon(AppIcon.upRightAndDownLeftFromCenter),
              size: 12, // أيقونة صغيرة
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        padding: EdgeInsets.zero,
        tooltip: 'تكبير',
      ),
    );
  }

  /// فتح محرّر الكتابة الموسّع (يشبه ChatGPT - أسفل الشاشة، يحترم لوحة المفاتيح)
  void _openExpandedComposer() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final mediaQuery = MediaQuery.of(ctx);
        final bottomInset = mediaQuery.viewInsets.bottom;
        final localFocusNode = FocusNode();
        // نستخدم نفس الcontroller لنستمر بالكتابة بدون نسخ
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SafeArea(
            top: false,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // مقبض علوي صغير ومجموعة أزرار
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).maybePop(),
                        icon: Align(
                          alignment: Alignment.centerRight, // في الطرف الأيمن
                          child: Icon(
                            AppIcons.getIcon(
                              AppIcon.downLeftAndUpRightToCenter,
                            ),
                            size: 12, // أيقونة صغيرة
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        tooltip: 'تصغير',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // محرّر كامل الشاشة تقريباً
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 120,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: localFocusNode,
                        autofocus: true,
                        enabled: widget.enabled,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: widget.hintText ?? 'اكتب رسالتك هنا...',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                        onChanged: widget.onTextChanged,
                        onSubmitted: (_) => _sendFromExpanded(ctx),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // شريط أزرار سفلي: إرسال
                  Row(
                    children: [
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _controller.text.trim().isEmpty
                            ? null
                            : () => _sendFromExpanded(ctx),
                        icon: Icon(
                          AppIcons.getIcon(AppIcon.paperPlane),
                          size: 18,
                        ),
                        label: const Text('إرسال'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _sendFromExpanded(BuildContext ctx) {
    if (_controller.text.trim().isEmpty) return;
    _sendMessage();
    Navigator.of(ctx).maybePop();
  }

  /// بناء زر الإرسال مع الحركات
  Widget _buildSendButton(ThemeData theme, bool isRTL) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _sendButtonScaleAnimation,
        _sendButtonOpacityAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _hasText ? _sendButtonScaleAnimation.value : 0.0,
          child: Opacity(
            opacity: _hasText ? _sendButtonOpacityAnimation.value : 0.0,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(76),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _hasText ? _sendMessage : null,
                icon: Transform(
                  alignment: Alignment.center,
                  transform: isRTL
                      ? (Matrix4.identity()..rotateY(math.pi))
                      : Matrix4.identity(),
                  child: Icon(
                    AppIcons.getIcon(AppIcon.paperPlane),
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                padding: EdgeInsets.zero,
                tooltip: 'إرسال',
              ),
            ),
          ),
        );
      },
    );
  }

  /// إرسال الرسالة
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final message = _controller.text;

      // إرسال الرسالة
      widget.onSend?.call(message);

      // مسح النص وإعادة التركيز
      _controller.clear();
      _focusNode.requestFocus();
    }
  }
}
