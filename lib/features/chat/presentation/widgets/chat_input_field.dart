import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/icons.dart';

/// مكون حقل إدخال المحادثة
///
/// يوفر واجهة لإدخال الرسائل مع ميزات متقدمة
class ChatInputField extends ConsumerStatefulWidget {
  /// النص الحالي
  final String text;

  /// دالة الاستدعاء عند تغيير النص
  final ValueChanged<String>? onTextChanged;

  /// دالة الاستدعاء عند إرسال الرسالة
  final VoidCallback? onSend;

  /// دالة الاستدعاء عند إرفاق ملف
  final VoidCallback? onAttachFile;

  /// دالة الاستدعاء عند إرسال صورة
  final VoidCallback? onSendImage;

  /// دالة الاستدعاء عند تسجيل صوت
  final VoidCallback? onRecordVoice;

  /// هل الحقل مفعل
  final bool enabled;

  /// نص التلميح
  final String? hintText;

  /// هل يجب عرض أزرار الإرفاق
  final bool showAttachmentButtons;

  /// هل يجب عرض زر الإرسال
  final bool showSendButton;

  /// الحد الأقصى لعدد الأسطر
  final int? maxLines;

  /// الحد الأدنى لعدد الأسطر
  final int? minLines;

  const ChatInputField({
    super.key,
    this.text = '',
    this.onTextChanged,
    this.onSend,
    this.onAttachFile,
    this.onSendImage,
    this.onRecordVoice,
    this.enabled = true,
    this.hintText,
    this.showAttachmentButtons = true,
    this.showSendButton = true,
    this.maxLines,
    this.minLines,
  });

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(ChatInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline..withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isRecording) _buildRecordingIndicator(theme),
            _buildInputRow(theme),
          ],
        ),
      ),
    );
  }

  /// بناء مؤشر التسجيل
  Widget _buildRecordingIndicator(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.microphone),
            color: theme.colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'جاري التسجيل... اضغط لإيقاف',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            onPressed: _stopRecording,
            icon: Icon(
              AppIcons.getIcon(AppIcon.stop),
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء صف الإدخال
  Widget _buildInputRow(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.showAttachmentButtons) ...[
          _buildAttachmentButton(theme),
          const SizedBox(width: 8),
        ],
        Expanded(child: _buildTextField(theme)),
        if (widget.showSendButton) ...[
          const SizedBox(width: 8),
          _buildSendButton(theme),
        ],
      ],
    );
  }

  /// بناء زر الإرفاق
  Widget _buildAttachmentButton(ThemeData theme) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'file':
            widget.onAttachFile?.call();
            break;
          case 'image':
            widget.onSendImage?.call();
            break;
          case 'voice':
            _startRecording();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'file',
          child: Row(
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.link),
                size: 18,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text('إرفاق ملف'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'image',
          child: Row(
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.image),
                size: 18,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text('إرسال صورة'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'voice',
          child: Row(
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.microphone),
                size: 18,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text('تسجيل صوت'),
            ],
          ),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          AppIcons.getIcon(AppIcon.plus),
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }

  /// بناء حقل النص
  Widget _buildTextField(ThemeData theme) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40, maxHeight: 120),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _focusNode.hasFocus
              ? theme.colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        minLines: widget.minLines ?? 1,
        textAlignVertical: TextAlignVertical.center,
        onChanged: widget.onTextChanged,
        onSubmitted: (_) => _sendMessage(),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'اكتب رسالتك هنا...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant..withAlpha(153),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _controller.clear();
                    widget.onTextChanged?.call('');
                  },
                  icon: Icon(
                    AppIcons.getIcon(AppIcon.xmark),
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  /// بناء زر الإرسال
  Widget _buildSendButton(ThemeData theme) {
    final hasText = _controller.text.trim().isNotEmpty;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: hasText
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        onPressed: hasText ? _sendMessage : null,
        icon: Icon(
          AppIcons.getIcon(AppIcon.paperPlane),
          color: hasText
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }

  /// إرسال الرسالة
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend?.call();
      _controller.clear();
      widget.onTextChanged?.call('');
    }
  }

  /// بدء التسجيل
  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    widget.onRecordVoice?.call();
  }

  /// إيقاف التسجيل
  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
  }
}

/// مكون حقل الإدخال المبسط
class SimpleChatInputField extends StatefulWidget {
  /// النص الحالي
  final String text;

  /// دالة الاستدعاء عند تغيير النص
  final ValueChanged<String>? onTextChanged;

  /// دالة الاستدعاء عند إرسال الرسالة
  final VoidCallback? onSend;

  /// هل الحقل مفعل
  final bool enabled;

  /// نص التلميح
  final String? hintText;

  const SimpleChatInputField({
    super.key,
    this.text = '',
    this.onTextChanged,
    this.onSend,
    this.enabled = true,
    this.hintText,
  });

  @override
  State<SimpleChatInputField> createState() => _SimpleChatInputFieldState();
}

class _SimpleChatInputFieldState extends State<SimpleChatInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(SimpleChatInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline..withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.enabled,
                onChanged: widget.onTextChanged,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: widget.hintText ?? 'اكتب رسالتك...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant..withAlpha(153),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _controller.text.trim().isNotEmpty
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: _controller.text.trim().isNotEmpty
                    ? _sendMessage
                    : null,
                icon: Icon(
                  AppIcons.getIcon(AppIcon.paperPlane),
                  color: _controller.text.trim().isNotEmpty
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend?.call();
      _controller.clear();
      widget.onTextChanged?.call('');
    }
  }
}

/// مكون حقل الإدخال المتقدم مع الإكمال التلقائي
class AdvancedChatInputField extends StatefulWidget {
  /// النص الحالي
  final String text;

  /// دالة الاستدعاء عند تغيير النص
  final ValueChanged<String>? onTextChanged;

  /// دالة الاستدعاء عند إرسال الرسالة
  final VoidCallback? onSend;

  /// اقتراحات الإكمال التلقائي
  final List<String> suggestions;

  /// دالة الاستدعاء عند اختيار اقتراح
  final ValueChanged<String>? onSuggestionSelected;

  /// هل الحقل مفعل
  final bool enabled;

  /// نص التلميح
  final String? hintText;

  const AdvancedChatInputField({
    super.key,
    this.text = '',
    this.onTextChanged,
    this.onSend,
    this.suggestions = const [],
    this.onSuggestionSelected,
    this.enabled = true,
    this.hintText,
  });

  @override
  State<AdvancedChatInputField> createState() => _AdvancedChatInputFieldState();
}

class _AdvancedChatInputFieldState extends State<AdvancedChatInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(AdvancedChatInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && widget.suggestions.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showSuggestions) _buildSuggestions(theme),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline..withAlpha(50),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    onChanged: (value) {
                      widget.onTextChanged?.call(value);
                      setState(() {
                        _showSuggestions =
                            _focusNode.hasFocus &&
                            widget.suggestions.isNotEmpty &&
                            value.isNotEmpty;
                      });
                    },
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? 'اكتب رسالتك...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(
                          0.6,
                        ),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _controller.text.trim().isNotEmpty
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    onPressed: _controller.text.trim().isNotEmpty
                        ? _sendMessage
                        : null,
                    icon: Icon(
                      AppIcons.getIcon(AppIcon.paperPlane),
                      color: _controller.text.trim().isNotEmpty
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline..withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = widget.suggestions[index];
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  _controller.text = suggestion;
                  widget.onTextChanged?.call(suggestion);
                  widget.onSuggestionSelected?.call(suggestion);
                  _focusNode.unfocus();
                  setState(() {
                    _showSuggestions = false;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend?.call();
      _controller.clear();
      widget.onTextChanged?.call('');
    }
  }
}
