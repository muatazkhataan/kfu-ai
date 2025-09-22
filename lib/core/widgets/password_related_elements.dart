import 'package:flutter/material.dart';
import 'remember_me_checkbox.dart';
import 'login_navigation_buttons.dart';

/// Widget for password-related elements with proper animations
class PasswordRelatedElements extends StatelessWidget {
  final Animation<double> animation;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback? onPrevious;
  final VoidCallback? onLogin;
  final bool isRTL;

  const PasswordRelatedElements({
    super.key,
    required this.animation,
    required this.rememberMe,
    required this.onRememberMeChanged,
    this.onPrevious,
    this.onLogin,
    this.isRTL = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            isRTL
                ? -(1 - animation.value) *
                      MediaQuery.of(context).size.width *
                      1.2
                : (1 - animation.value) *
                      MediaQuery.of(context).size.width *
                      1.2,
            0,
          ),
          child: Opacity(
            opacity: animation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                // Remember me checkbox
                RememberMeCheckbox(
                  initialValue: rememberMe,
                  onChanged: onRememberMeChanged,
                ),
                const SizedBox(height: 16),
                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: LoginNavigationButtons(
                    showPrevious: true,
                    onPrevious: onPrevious,
                    onLogin: onLogin,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
