import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Logo widget for splash screen with transparent circle and light rays
class SplashLogo extends StatelessWidget {
  final Animation<double> animationController;
  final String logoPath;
  final double logoSize;
  final Color logoColor;

  const SplashLogo({
    super.key,
    required this.animationController,
    required this.logoPath,
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
        // Main icon
        SvgPicture.asset(
          logoPath,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
        ),
      ],
    );
  }
}
