import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/extensions/context_extensions.dart';

/// مكون حقل الإدخال المحسن للمحادثة
///
/// يوفر تجربة محسنة مع حركات ناعمة ودعم RTL/LTR
class EnhancedChatInputField extends ConsumerStatefulWidget {
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

  const EnhancedChatInputField({
    super.key,
    this.text = '',
    this.onTextChanged,
    this.onSend,
    this.onAttachFile,
    this.enabled = true,
    this.hintText,
  });

  @override
  ConsumerState<EnhancedChatInputField> createState() =>
      _EnhancedChatInputFieldState();
}

class _EnhancedChatInputFieldState extends ConsumerState<EnhancedChatInputField>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _resizeController;
  late AnimationController _sendButtonController;

  late Animation<double> _resizeAnimation;
  late Animation<double> _sendButtonScaleAnimation;
  late Animation<double> _sendButtonOpacityAnimation;

  bool _isExpanded = false;
  bool _hasText = false;
  GlobalKey _inputFieldKey = GlobalKey();

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
    _resizeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _resizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resizeController, curve: Curves.easeInOut),
    );

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
    _resizeController.dispose();
    _sendButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRTL = context.isRTL;
    final mediaQuery = MediaQuery.of(context);

    return AnimatedBuilder(
      animation: _resizeAnimation,
      builder: (context, child) {
        return Container(
          key: _inputFieldKey,
          height: _isExpanded
              ? mediaQuery.size.height -
                    mediaQuery.viewInsets.bottom -
                    kToolbarHeight -
                    mediaQuery.padding.top -
                    100 // مساحة للتنفس
              : null,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withAlpha(50),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isExpanded) _buildExpandedHeader(theme, isRTL),
                _buildInputRow(theme, isRTL),
              ],
            ),
          ),
        );
      },
    );
  }

  /// بناء رأس الوضع الموسع
  Widget _buildExpandedHeader(ThemeData theme, bool isRTL) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.edit),
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'وضع الكتابة الموسع',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: _toggleExpanded,
            icon: Icon(
              AppIcons.getIcon(AppIcon.anglesDown),
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            tooltip: 'تصغير',
          ),
        ],
      ),
    );
  }

  /// بناء صف الإدخال الرئيسي
  Widget _buildInputRow(ThemeData theme, bool isRTL) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // زر إضافة الملفات (حسب الاتجاه)
          if (isRTL) ...[
            _buildActionButton(theme, isRTL),
            const SizedBox(width: 8),
          ],

          // حقل النص
          Expanded(child: _buildTextField(theme, isRTL)),

          // زر الإرسال والملفات (حسب الاتجاه)
          if (isRTL) ...[
            const SizedBox(width: 8),
            _buildSendButton(theme, isRTL),
          ] else ...[
            const SizedBox(width: 8),
            _buildActionButton(theme, isRTL),
            const SizedBox(width: 8),
            _buildSendButton(theme, isRTL),
          ],
        ],
      ),
    );
  }

  /// بناء حقل النص
  Widget _buildTextField(ThemeData theme, bool isRTL) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 50,
        maxHeight: _isExpanded ? double.infinity : 120,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        maxLines: _isExpanded ? null : 5,
        minLines: 1,
        textAlignVertical: TextAlignVertical.center,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'اكتب رسالتك هنا...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(153),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isRTL ? 16 : 60, // مساحة لزر الإرسال
            vertical: 15,
          ),
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  /// بناء أزرار الإجراءات (الملفات + التوسيع)
  Widget _buildActionButton(ThemeData theme, bool isRTL) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // زر التوسيع
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
          ),
          child: IconButton(
            onPressed: _toggleExpanded,
            icon: Icon(
              AppIcons.getIcon(
                _isExpanded ? AppIcon.anglesDown : AppIcon.anglesUp,
              ),
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            padding: EdgeInsets.zero,
            tooltip: _isExpanded ? 'تصغير' : 'توسيع',
          ),
        ),
        const SizedBox(height: 6),
        // زر الملفات (مخفي مؤقتاً حسب المطلوب)
        // Container(
        //   width: 36,
        //   height: 36,
        //   decoration: BoxDecoration(
        //     color: theme.colorScheme.surfaceContainerHigh,
        //     borderRadius: BorderRadius.circular(18),
        //   ),
        //   child: IconButton(
        //     onPressed: widget.onAttachFile,
        //     icon: Icon(
        //       AppIcons.getIcon(AppIcon.link),
        //       size: 16,
        //       color: theme.colorScheme.onSurfaceVariant,
        //     ),
        //     padding: EdgeInsets.zero,
        //     tooltip: 'إرفاق ملف',
        //   ),
        // ),
      ],
    );
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
                icon: Transform.rotate(
                  angle: isRTL ? 3.14159 : 0, // دوران 180 درجة للعربية
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

  /// تبديل حالة التوسيع
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _resizeController.forward();
      _focusNode.requestFocus();
    } else {
      _resizeController.reverse();
    }
  }

  /// إرسال الرسالة
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final message = _controller.text;

      // إرسال الرسالة
      widget.onSend?.call(message);

      // مسح النص
      _controller.clear();

      // العودة للحجم العادي إذا كان موسعاً
      if (_isExpanded) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _toggleExpanded();
          }
        });
      }
    }
  }
}

/// Mixin للتحكم في الحركات
mixin ChatInputAnimationMixin on TickerProviderStateMixin {
  late AnimationController expansionController;
  late AnimationController sendButtonController;

  void initializeAnimationControllers() {
    expansionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  void disposeAnimationControllers() {
    expansionController.dispose();
    sendButtonController.dispose();
  }
}

/// فئة لإدارة حالة الإدخال
class ChatInputState {
  final bool isExpanded;
  final bool hasText;
  final bool isAnimating;
  final String currentText;

  const ChatInputState({
    this.isExpanded = false,
    this.hasText = false,
    this.isAnimating = false,
    this.currentText = '',
  });

  ChatInputState copyWith({
    bool? isExpanded,
    bool? hasText,
    bool? isAnimating,
    String? currentText,
  }) {
    return ChatInputState(
      isExpanded: isExpanded ?? this.isExpanded,
      hasText: hasText ?? this.hasText,
      isAnimating: isAnimating ?? this.isAnimating,
      currentText: currentText ?? this.currentText,
    );
  }
}

/// مراقب لحالة الإدخال
class ChatInputController extends ChangeNotifier {
  ChatInputState _state = const ChatInputState();

  ChatInputState get state => _state;

  void updateState(ChatInputState newState) {
    _state = newState;
    notifyListeners();
  }

  void toggleExpansion() {
    updateState(_state.copyWith(isExpanded: !_state.isExpanded));
  }

  void updateText(String text) {
    updateState(
      _state.copyWith(currentText: text, hasText: text.trim().isNotEmpty),
    );
  }

  void setAnimating(bool animating) {
    updateState(_state.copyWith(isAnimating: animating));
  }
}
