import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painter for animated particles
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i * 0.1 + animationValue)) % size.width;
      final y = (size.height * (i * 0.15 + animationValue * 0.5)) % size.height;
      final radius = 2.0 + (i % 3);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for neural network effect
class NeuralNetworkPainter extends CustomPainter {
  final double animationValue;
  final Color networkColor;

  NeuralNetworkPainter(this.animationValue, this.networkColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = networkColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final nodePaint = Paint()
      ..color = networkColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Create neural network nodes
    final nodes = <Offset>[];
    final nodeCount = 15;

    for (int i = 0; i < nodeCount; i++) {
      final x = (size.width * (i * 0.1 + animationValue * 0.2)) % size.width;
      final y =
          size.height * 0.77 +
          math.sin(i * 0.5 + animationValue * 2 * math.pi) * 40 +
          math.sin(i * 0.3 + animationValue * 3 * math.pi) * 25;
      nodes.add(Offset(x, y));
    }

    // Draw connections between nodes
    for (int i = 0; i < nodes.length - 1; i++) {
      final distance = (nodes[i] - nodes[i + 1]).distance;
      if (distance < 150) {
        final alpha = (1.0 - distance / 150) * 0.3;
        paint.color = networkColor.withValues(alpha: alpha);
        canvas.drawLine(nodes[i], nodes[i + 1], paint);
      }
    }

    // Draw nodes
    for (final node in nodes) {
      canvas.drawCircle(node, 3.0, nodePaint);
    }

    // Add floating data particles
    final dataPaint = Paint()
      ..color = networkColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final x = (size.width * (i * 0.15 + animationValue * 0.3)) % size.width;
      final y =
          size.height * 0.8 +
          math.sin(i * 0.7 + animationValue * 4 * math.pi) * 30;
      final particleSize =
          2.0 + math.sin(i + animationValue * 2 * math.pi) * 1.0;
      canvas.drawCircle(Offset(x, y), particleSize, dataPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
