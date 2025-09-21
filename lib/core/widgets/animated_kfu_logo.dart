import 'package:flutter/material.dart';

/// Animated KFU logo that slides down from top
class AnimatedKfuLogo extends StatelessWidget {
  final Animation<double> animation;
  final String logoPath;
  final double logoHeight;
  final double top;
  final double left;

  const AnimatedKfuLogo({
    super.key,
    required this.animation,
    required this.logoPath,
    this.logoHeight = 75.0,
    this.top = 50.0,
    this.left = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: top + (animation.value * 50), // Slide down from top
          left: left,
          child: Opacity(
            opacity: animation.value,
            child: Image.asset(
              logoPath,
              height: logoHeight,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
