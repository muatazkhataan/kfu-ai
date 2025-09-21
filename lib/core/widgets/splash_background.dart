import 'package:flutter/material.dart';
import '../painters/splash_painters.dart';

/// Background widget for splash screen with gradient and animated particles
class SplashBackground extends StatelessWidget {
  final Animation<double> particleAnimation;
  final Widget child;

  const SplashBackground({
    super.key,
    required this.particleAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.0,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            Colors.white,
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated background particles
          AnimatedBuilder(
            animation: particleAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(particleAnimation.value),
                size: Size.infinite,
              );
            },
          ),
          // Child content
          child,
        ],
      ),
    );
  }
}
