import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// Remember me toggle switch widget
class RememberMeCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const RememberMeCheckbox({
    super.key,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<RememberMeCheckbox> createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  void didUpdateWidget(RememberMeCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _isChecked = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // النص على الجانب
          Text(
            AppLocalizations.of(context)!.authRememberMe,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          // زر التبديل على الجانب
          Switch(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value;
              });
              widget.onChanged?.call(_isChecked);
            },
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
