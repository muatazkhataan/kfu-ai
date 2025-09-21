import 'package:flutter/material.dart';
import '../painters/splash_painters.dart';

/// Neural network effect widget for splash screen
class NeuralNetworkEffect extends StatelessWidget {
  final Animation<double> animation;
  final Color primaryColor;

  const NeuralNetworkEffect({
    super.key,
    required this.animation,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: NeuralNetworkPainter(animation.value, primaryColor),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}
