import 'package:flutter/material.dart';

/// Animated DELIT logo and text that slides up from bottom
class AnimatedDelitLogo extends StatelessWidget {
  final Animation<double> animation;
  final String logoPath;
  final double logoHeight;
  final String developmentText;
  final String versionText;

  const AnimatedDelitLogo({
    super.key,
    required this.animation,
    required this.logoPath,
    this.logoHeight = 36.0,
    required this.developmentText,
    required this.versionText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          bottom: (animation.value * 50), // Slide up from bottom
          left: 0,
          right: 0,
          child: Opacity(
            opacity: animation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DELIT Logo
                Image.asset(logoPath, height: logoHeight, fit: BoxFit.contain),
                const SizedBox(height: 8),
                // Development text
                Text(
                  developmentText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // Version number
                Text(
                  versionText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 9,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
