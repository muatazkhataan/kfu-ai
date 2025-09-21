import 'package:flutter/material.dart';

/// Image logo widget for splash screen with transparent circle and light rays
class SplashImageLogo extends StatelessWidget {
  final Animation<double> animationController;
  final String imagePath;
  final double logoSize;
  final Color logoColor;

  const SplashImageLogo({
    super.key,
    required this.animationController,
    required this.imagePath,
    this.logoSize = 75.0,
    this.logoColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Light rays animation
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: animationController.value * 2 * 3.14159,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      logoColor.withValues(alpha: 0.3),
                      logoColor.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            );
          },
        ),
        // Main image with container for better control
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: logoColor.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              width: logoSize,
              height: logoSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to a simple icon if image fails to load
                return Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    color: logoColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology,
                    size: logoSize * 0.6,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
