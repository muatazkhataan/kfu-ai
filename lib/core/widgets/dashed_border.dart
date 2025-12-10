import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

/// Widget helper to draw a dashed border around its child.
class DashedBorder extends StatelessWidget {
  final Widget child;
  final bool show;
  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  const DashedBorder({
    super.key,
    required this.child,
    required this.show,
    required this.color,
    this.borderRadius = 12,
    this.strokeWidth = 1.5,
    this.dashWidth = 6,
    this.dashGap = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return child;

    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: color,
        borderRadius: borderRadius,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashGap: dashGap,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = _dashPath(path, dashWidth, dashGap);
    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(Path source, double dashWidth, double dashGap) {
    final Path dest = Path();
    for (final ui.PathMetric pathMetric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final double next = math.min(dashWidth, pathMetric.length - distance);
        dest.addPath(
          pathMetric.extractPath(distance, distance + next),
          Offset.zero,
        );
        distance += dashWidth + dashGap;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap;
  }
}
