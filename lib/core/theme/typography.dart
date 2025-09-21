import 'package:flutter/material.dart';
import 'tokens.dart';

/// Typography system for the KFU AI Assistant app
/// Using IBM Plex Sans Arabic for Arabic text
class AppTypography {
  AppTypography._();

  // Text styles for Arabic content
  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeXXXL,
    fontWeight: FontWeight.w700, // Bold
    height: AppTokens.lineHeightTight,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeXXL,
    fontWeight: FontWeight.w600, // SemiBold
    height: AppTokens.lineHeightTight,
    letterSpacing: -0.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeXL,
    fontWeight: FontWeight.w600, // SemiBold
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeXL,
    fontWeight: FontWeight.w600, // SemiBold
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeL,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeM,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeL,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeM,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeS,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeM,
    fontWeight: FontWeight.w400, // Regular
    height: AppTokens.lineHeightRelaxed,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeS,
    fontWeight: FontWeight.w400, // Regular
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeXS,
    fontWeight: FontWeight.w400, // Regular
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeS,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeXS,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeXS,
    fontWeight: FontWeight.w400, // Regular
    height: AppTokens.lineHeightNormal,
  );

  // Custom text styles for specific use cases
  static const TextStyle chatMessage = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeM,
    fontWeight: FontWeight.w400, // Regular
    height: AppTokens.lineHeightRelaxed,
  );

  static const TextStyle chatTimestamp = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeXS,
    fontWeight: FontWeight.w300, // Light
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle sidebarItem = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeS,
    fontWeight: FontWeight.w400, // Regular
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeM,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle inputText = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeM,
    fontWeight: FontWeight.w400, // Regular
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle searchPlaceholder = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeS,
    fontWeight: FontWeight.w300, // Light
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle folderName = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeS,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle chatTitle = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeM,
    fontWeight: FontWeight.w500, // Medium
    height: AppTokens.lineHeightNormal,
  );

  static const TextStyle chatPreview = TextStyle(
    fontFamily: AppTokens.fontFamilyArabic,
    fontSize: AppTokens.fontSizeS,
    fontWeight: FontWeight.w300, // Light
    height: AppTokens.lineHeightNormal,
  );
}
