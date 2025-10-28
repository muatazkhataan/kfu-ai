import 'package:flutter/material.dart';

/// Color schemes for Light and Dark themes
/// Based on Material 3 design system with KFU institutional colors
class AppColorSchemes {
  AppColorSchemes._();

  // KFU Institutional Colors
  static const Color kfuPrimary = Color(0xFF1B8354); // Saudi green (primary)
  static const Color kfuPrimaryDark = Color(
    0xFFFFFFFF,
  ); // Lighter green for dark theme
  static const Color kfuSecondary = Color(
    0xFFF9FAFB,
  ); // Bootstrap secondary gray

  // Light Theme Colors
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: kfuPrimary,
    onPrimary: Colors.white,
    secondary: kfuSecondary,
    onSecondary: Colors.white,
    tertiary: Color(0xFF33C27D), // Green accent (tertiary)
    onTertiary: Colors.white,
    error: Color(0xFFdc3545), // Bootstrap danger
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF1f2328), // Dark text on light surface
    surfaceContainerHighest: Color(0xFFf8f9fa), // Light gray background
    onSurfaceVariant: Color(0xFF6c757d), // Secondary text
    outline: Color(0xFFdee2e6), // Borders
    outlineVariant: Color(0xFFe9ecef), // Light borders
    shadow: Colors.black12,
    scrim: Colors.black26,
    inverseSurface: Color(0xFF2a2f36),
    onInverseSurface: Color(0xFFe6e8ea),
    inversePrimary: kfuPrimaryDark,
  );

  // Dark Theme Colors
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: kfuPrimaryDark,
    onPrimary: Color(0xFF1f2328),
    secondary: Color(0xFFa0a6ad), // Lighter gray for dark theme
    onSecondary: Color(0xFF1f2328),
    tertiary: Color(0xFF48D08C), // Green accent for dark theme
    onTertiary: Color(0xFF1f2328),
    error: Color(0xFFf56565), // Lighter red for dark theme
    onError: Color(0xFF1f2328),
    surface: Color(0xFF104631), // Dark surface with KFU green
    onSurface: Color(0xFFe6e8ea), // Light text on dark surface
    surfaceContainerHighest: Color(0xFF171a21), // Darker gray background
    onSurfaceVariant: Color(0xFFa0a6ad), // Secondary text for dark
    outline: Color(0xFF2a2f36), // Dark borders
    outlineVariant: Color(0xFF3a3f46), // Lighter dark borders
    shadow: Colors.black54,
    scrim: Colors.black87,
    inverseSurface: Color(0xFFe6e8ea),
    onInverseSurface: Color(0xFF1f2328),
    inversePrimary: kfuPrimary,
  );

  // Semantic colors for specific use cases
  static const Color success = Color(0xFF28a745); // Bootstrap success
  static const Color warning = Color(0xFFffc107); // Bootstrap warning
  static const Color info = Color(0xFF17a2b8); // Bootstrap info
  static const Color danger = Color(0xFFdc3545); // Bootstrap danger

  // Chat specific colors
  static const Color userMessageBackground = kfuPrimary;
  static const Color assistantMessageBackground = Color(0xFFf8f9fa);
  static const Color assistantMessageBackgroundDark = Color(0xFF171a21);

  // Status colors
  static const Color online = Color(0xFF28a745);
  static const Color offline = Color(0xFF6c757d);
  static const Color typing = Color(0xFFffc107);

  // Folder colors for organization
  static const List<Color> folderColors = [
    Color(0xFF007bff), // Blue
    Color(0xFF28a745), // Green
    Color(0xFFffc107), // Yellow
    Color(0xFFdc3545), // Red
    Color(0xFF6f42c1), // Purple
    Color(0xFFfd7e14), // Orange
    Color(0xFF20c997), // Teal
    Color(0xFFe83e8c), // Pink
  ];
}
