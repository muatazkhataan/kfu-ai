import 'dart:math';
import 'package:flutter/material.dart';

/// مكون مؤشر الكتابة
///
/// يعرض مؤشر متحرك عندما يكون المساعد يكتب رداً
class TypingIndicator extends StatefulWidget {
  /// اسم المستخدم الذي يكتب
  final String? userName;

  /// لون المؤشر
  final Color? color;

  /// حجم المؤشر
  final double size;

  const TypingIndicator({
    super.key,
    this.userName,
    this.color,
    this.size = 4.0,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.2, 1.0, curve: Curves.easeInOut),
        ),
      );
    });

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.userName != null) ...[
            Text(
              '${widget.userName} يكتب',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 8),
          ],
          _buildTypingDots(color),
        ],
      ),
    );
  }

  Widget _buildTypingDots(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _animations.asMap().entries.map((entry) {
        final index = entry.key;
        final animation = entry.value;

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.only(
                right: index < _animations.length - 1 ? 4 : 0,
              ),
              child: Transform.scale(
                scale: 0.5 + (animation.value * 0.5),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3 + (animation.value * 0.7)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

/// مكون مؤشر الكتابة المخصص
class CustomTypingIndicator extends StatefulWidget {
  /// اسم المستخدم الذي يكتب
  final String? userName;

  /// لون المؤشر
  final Color? color;

  /// حجم المؤشر
  final double size;

  /// سرعة الحركة
  final Duration duration;

  const CustomTypingIndicator({
    super.key,
    this.userName,
    this.color,
    this.size = 6.0,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<CustomTypingIndicator> createState() => _CustomTypingIndicatorState();
}

class _CustomTypingIndicatorState extends State<CustomTypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _waveController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _waveController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.userName != null) ...[
            Text(
              '${widget.userName} يكتب',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 12),
          ],
          _buildWaveIndicator(color),
        ],
      ),
    );
  }

  Widget _buildWaveIndicator(Color color) {
    return SizedBox(
      width: widget.size * 4,
      height: widget.size * 2,
      child: AnimatedBuilder(
        animation: Listenable.merge([_waveController, _pulseController]),
        builder: (context, child) {
          return CustomPaint(
            painter: WavePainter(
              progress: _waveController.value,
              pulse: _pulseController.value,
              color: color,
              dotSize: widget.size,
            ),
          );
        },
      ),
    );
  }
}

/// رسام موجة الكتابة
class WavePainter extends CustomPainter {
  final double progress;
  final double pulse;
  final Color color;
  final double dotSize;

  WavePainter({
    required this.progress,
    required this.pulse,
    required this.color,
    required this.dotSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final spacing = size.width / 3;

    for (int i = 0; i < 3; i++) {
      final x = i * spacing + spacing / 2;
      final waveOffset = (progress * 2 * 3.14159) + (i * 0.5);
      final y = centerY + (sin(waveOffset) * 4 * pulse);
      final radius = dotSize * (0.5 + (pulse * 0.5));

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulse != pulse ||
        oldDelegate.color != color ||
        oldDelegate.dotSize != dotSize;
  }
}

/// مكون مؤشر الكتابة البسيط
class SimpleTypingIndicator extends StatefulWidget {
  /// لون المؤشر
  final Color? color;

  /// حجم المؤشر
  final double size;

  const SimpleTypingIndicator({super.key, this.color, this.size = 4.0});

  @override
  State<SimpleTypingIndicator> createState() => _SimpleTypingIndicatorState();
}

class _SimpleTypingIndicatorState extends State<SimpleTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.onSurfaceVariant;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = (_animation.value - delay).clamp(0.0, 1.0);
            final opacity = (1.0 - value).clamp(0.0, 1.0);

            return Container(
              margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// مكون مؤشر الكتابة مع النص
class TypingIndicatorWithText extends StatelessWidget {
  /// النص المراد عرضه
  final String text;

  /// لون النص
  final Color? textColor;

  /// لون المؤشر
  final Color? indicatorColor;

  /// نوع المؤشر
  final TypingIndicatorType type;

  const TypingIndicatorWithText({
    super.key,
    required this.text,
    this.textColor,
    this.indicatorColor,
    this.type = TypingIndicatorType.dots,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = this.textColor ?? theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 12),
          _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    switch (type) {
      case TypingIndicatorType.dots:
        return SimpleTypingIndicator(color: indicatorColor);
      case TypingIndicatorType.wave:
        return CustomTypingIndicator(color: indicatorColor);
      case TypingIndicatorType.pulse:
        return SimpleTypingIndicator(color: indicatorColor);
    }
  }
}

/// أنواع مؤشر الكتابة
enum TypingIndicatorType {
  /// نقاط متحركة
  dots,

  /// موجة
  wave,

  /// نبضة
  pulse,
}
