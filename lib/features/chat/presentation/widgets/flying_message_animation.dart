import 'package:flutter/material.dart';
import '../../../../core/theme/icons.dart';

/// Widget للحركة الوهمية عند إرسال الرسالة
///
/// يعرض تأثير طيران الرسالة من صندوق الإدخال إلى شاشة المحادثة
class FlyingMessageAnimation extends StatefulWidget {
  /// النص المرسل
  final String message;

  /// الموقع الابتدائي للحركة
  final Offset startPosition;

  /// الموقع النهائي للحركة
  final Offset endPosition;

  /// مدة الحركة
  final Duration duration;

  /// دالة الاستدعاء عند انتهاء الحركة
  final VoidCallback? onComplete;

  /// هل يجب عرض الحركة
  final bool isVisible;

  const FlyingMessageAnimation({
    super.key,
    required this.message,
    required this.startPosition,
    required this.endPosition,
    this.duration = const Duration(milliseconds: 800),
    this.onComplete,
    this.isVisible = true,
  });

  @override
  State<FlyingMessageAnimation> createState() => _FlyingMessageAnimationState();
}

class _FlyingMessageAnimationState extends State<FlyingMessageAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.isVisible) {
      _startAnimation();
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    // حركة الموقع - منحنى طيران طبيعي
    _positionAnimation = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // حركة التحجيم - يبدأ عادي ثم يصغر
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInCubic),
      ),
    );

    // حركة الشفافية - يختفي تدريجياً
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    // حركة الدوران - دوران خفيف
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  void _startAnimation() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FlyingMessageAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.reset();
      _startAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(225),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(76),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppIcons.getIcon(AppIcon.paperPlane),
                        color: theme.colorScheme.onPrimary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.message.length > 50
                              ? '${widget.message.substring(0, 50)}...'
                              : widget.message,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// مدير الحركات الوهمية للرسائل
class FlyingMessageManager extends StatefulWidget {
  /// قائمة الرسائل المرسلة
  final List<FlyingMessage> messages;

  /// دالة الاستدعاء عند انتهاء حركة رسالة
  final Function(String messageId)? onMessageComplete;

  const FlyingMessageManager({
    super.key,
    required this.messages,
    this.onMessageComplete,
  });

  @override
  State<FlyingMessageManager> createState() => _FlyingMessageManagerState();
}

class _FlyingMessageManagerState extends State<FlyingMessageManager> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.messages.map((flyingMessage) {
        return FlyingMessageAnimation(
          key: ValueKey(flyingMessage.id),
          message: flyingMessage.text,
          startPosition: flyingMessage.startPosition,
          endPosition: flyingMessage.endPosition,
          duration: flyingMessage.duration,
          isVisible: flyingMessage.isVisible,
          onComplete: () {
            widget.onMessageComplete?.call(flyingMessage.id);
          },
        );
      }).toList(),
    );
  }
}

/// نموذج بيانات الرسالة الطائرة
class FlyingMessage {
  /// معرف فريد للرسالة
  final String id;

  /// نص الرسالة
  final String text;

  /// الموقع الابتدائي
  final Offset startPosition;

  /// الموقع النهائي
  final Offset endPosition;

  /// مدة الحركة
  final Duration duration;

  /// هل الرسالة مرئية
  final bool isVisible;

  /// وقت الإنشاء
  final DateTime createdAt;

  const FlyingMessage({
    required this.id,
    required this.text,
    required this.startPosition,
    required this.endPosition,
    this.duration = const Duration(milliseconds: 800),
    this.isVisible = true,
    required this.createdAt,
  });

  FlyingMessage copyWith({
    String? id,
    String? text,
    Offset? startPosition,
    Offset? endPosition,
    Duration? duration,
    bool? isVisible,
    DateTime? createdAt,
  }) {
    return FlyingMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      startPosition: startPosition ?? this.startPosition,
      endPosition: endPosition ?? this.endPosition,
      duration: duration ?? this.duration,
      isVisible: isVisible ?? this.isVisible,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlyingMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// مولد الحركات الوهمية للرسائل
class FlyingMessageBuilder {
  /// إنشاء رسالة طائرة
  static FlyingMessage createFlyingMessage({
    required String text,
    required Offset startPosition,
    Offset? endPosition,
    Duration? duration,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // الموقع النهائي الافتراضي (وسط الشاشة)
    final defaultEndPosition = endPosition ?? const Offset(200, 100);

    return FlyingMessage(
      id: id,
      text: text,
      startPosition: startPosition,
      endPosition: defaultEndPosition,
      duration: duration ?? const Duration(milliseconds: 800),
      createdAt: DateTime.now(),
    );
  }

  /// حساب المسار المنحني للحركة
  static List<Offset> calculateCurvedPath({
    required Offset start,
    required Offset end,
    int steps = 20,
  }) {
    final List<Offset> path = [];

    // نقطة التحكم للمنحنى (أعلى من النقطتين)
    final controlPoint = Offset(
      (start.dx + end.dx) / 2,
      (start.dy + end.dy) / 2 - 100, // ارتفاع المنحنى
    );

    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final point = _calculateBezierPoint(start, controlPoint, end, t);
      path.add(point);
    }

    return path;
  }

  /// حساب نقطة في منحنى بيزييه التربيعي
  static Offset _calculateBezierPoint(
    Offset start,
    Offset control,
    Offset end,
    double t,
  ) {
    final u = 1 - t;
    final tt = t * t;
    final uu = u * u;

    final x = uu * start.dx + 2 * u * t * control.dx + tt * end.dx;
    final y = uu * start.dy + 2 * u * t * control.dy + tt * end.dy;

    return Offset(x, y);
  }
}

/// Provider لإدارة حالة الرسائل الطائرة
class FlyingMessageProvider extends ChangeNotifier {
  final List<FlyingMessage> _messages = [];

  List<FlyingMessage> get messages => List.unmodifiable(_messages);

  /// إضافة رسالة طائرة جديدة
  void addFlyingMessage(FlyingMessage message) {
    _messages.add(message);
    notifyListeners();

    // إزالة الرسالة تلقائياً بعد انتهاء مدة الحركة
    Future.delayed(message.duration + const Duration(milliseconds: 100), () {
      removeFlyingMessage(message.id);
    });
  }

  /// إزالة رسالة طائرة
  void removeFlyingMessage(String messageId) {
    _messages.removeWhere((message) => message.id == messageId);
    notifyListeners();
  }

  /// مسح جميع الرسائل الطائرة
  void clearAllMessages() {
    _messages.clear();
    notifyListeners();
  }

  /// إنشاء وإضافة رسالة طائرة
  void sendFlyingMessage({
    required String text,
    required Offset startPosition,
    Offset? endPosition,
    Duration? duration,
  }) {
    final message = FlyingMessageBuilder.createFlyingMessage(
      text: text,
      startPosition: startPosition,
      endPosition: endPosition,
      duration: duration,
    );

    addFlyingMessage(message);
  }
}
