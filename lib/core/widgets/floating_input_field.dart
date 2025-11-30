import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../generated/l10n/app_localizations.dart';

/// Floating input field with rounded corners and icon
class FloatingInputField extends StatefulWidget {
  final Animation<double> animation;
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final IconData icon;
  final VoidCallback? onNext;
  final String? nextButtonText;
  final bool showNextButton;
  final bool isRTL;

  const FloatingInputField({
    super.key,
    required this.animation,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    required this.icon,
    this.onNext,
    this.nextButtonText,
    this.showNextButton = true,
    this.isRTL = true,
  });

  @override
  State<FloatingInputField> createState() => _FloatingInputFieldState();
}

class _FloatingInputFieldState extends State<FloatingInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  late Animation<double> _focusAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _focusController, curve: Curves.easeInOut),
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  @override
  void dispose() {
    _focusController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            widget.isRTL
                ? -(1 - widget.animation.value) *
                      MediaQuery.of(context).size.width *
                      1.2
                : (1 - widget.animation.value) *
                      MediaQuery.of(context).size.width *
                      1.2,
            0,
          ),
          child: Opacity(
            opacity: widget.animation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Input field with floating label
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 12,
                  ), // Add top padding to prevent clipping
                  child: Stack(
                    clipBehavior:
                        Clip.none, // Allow label to extend outside bounds
                    children: [
                      // Input field
                      TextFormField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        obscureText: widget.isPassword && _obscurePassword,
                        autofillHints: widget.isPassword
                            ? const [AutofillHints.password]
                            : const [AutofillHints.username],
                        keyboardType: widget.isPassword
                            ? TextInputType.visiblePassword
                            : TextInputType.text,
                        textInputAction: widget.isPassword
                            ? TextInputAction.done
                            : TextInputAction.next,
                        enableSuggestions: !widget.isPassword,
                        enableInteractiveSelection: true,
                        enableIMEPersonalizedLearning: true,
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          prefixIcon: Icon(
                            widget.icon,
                            color: _isFocused
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                          suffixIcon: widget.isPassword
                              ? IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 18,
                                  ),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  tooltip: _obscurePassword
                                      ? 'إظهار كلمة المرور'
                                      : 'إخفاء كلمة المرور',
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                      ),
                      // Floating label
                      AnimatedBuilder(
                        animation: _focusAnimation,
                        builder: (context, child) {
                          return Positioned(
                            left: 20,
                            top: _isFocused || widget.controller.text.isNotEmpty
                                ? -8
                                : 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              color: Theme.of(context).colorScheme.surface,
                              child: Text(
                                widget.label,
                                style: TextStyle(
                                  color: _isFocused
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                  fontSize:
                                      _isFocused ||
                                          widget.controller.text.isNotEmpty
                                      ? 12
                                      : 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Next button with arrow
                if (widget.showNextButton && widget.onNext != null)
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width > 600
                                ? 200
                                : double.infinity,
                          ),
                          child: ElevatedButton(
                            onPressed: widget.onNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.nextButtonText ??
                                        AppLocalizations.of(context)!.authNext,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
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
