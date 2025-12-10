import 'package:flutter/material.dart';
import '../models/folder_icon.dart';
import '../../../../core/localization/l10n.dart';

/// Extension for IconCategory localization
extension IconCategoryLocalizationExtension on IconCategory {
  /// Get localized category name
  String getLocalizedName(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case IconCategory.general:
        return l10n.iconCategoryGeneral;
      case IconCategory.programming:
        return l10n.iconCategoryProgramming;
      case IconCategory.mathematics:
        return l10n.iconCategoryMathematics;
      case IconCategory.science:
        return l10n.iconCategoryScience;
      case IconCategory.study:
        return l10n.iconCategoryStudy;
      case IconCategory.creativity:
        return l10n.iconCategoryCreativity;
      case IconCategory.collaboration:
        return l10n.iconCategoryCollaboration;
      case IconCategory.system:
        return l10n.iconCategorySystem;
    }
  }
}

