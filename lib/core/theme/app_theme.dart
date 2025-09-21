import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_schemes.dart';
import 'typography.dart';
import 'tokens.dart';

/// Main theme configuration for the KFU AI Assistant app
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.lightColorScheme,
      textTheme: _buildTextTheme(AppColorSchemes.lightColorScheme),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorSchemes.lightColorScheme.surface,
        foregroundColor: AppColorSchemes.lightColorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColorSchemes.lightColorScheme.onSurface,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Card theme
      cardTheme: const CardThemeData(margin: EdgeInsets.all(AppTokens.spaceS)),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorSchemes.lightColorScheme.primary,
          foregroundColor: AppColorSchemes.lightColorScheme.onPrimary,
          elevation: AppTokens.elevationS,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spaceL,
            vertical: AppTokens.spaceM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusM),
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorSchemes.lightColorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spaceM,
            vertical: AppTokens.spaceS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusM),
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorSchemes.lightColorScheme.primary,
          side: BorderSide(
            color: AppColorSchemes.lightColorScheme.outline,
            width: 1.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spaceL,
            vertical: AppTokens.spaceM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusM),
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorSchemes.lightColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
          borderSide: BorderSide(
            color: AppColorSchemes.lightColorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
          borderSide: BorderSide(
            color: AppColorSchemes.lightColorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
          borderSide: BorderSide(
            color: AppColorSchemes.lightColorScheme.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
          borderSide: BorderSide(color: AppColorSchemes.lightColorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spaceM,
          vertical: AppTokens.spaceM,
        ),
        hintStyle: AppTypography.searchPlaceholder.copyWith(
          color: AppColorSchemes.lightColorScheme.onSurfaceVariant,
        ),
      ),

      // List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spaceM,
          vertical: AppTokens.spaceS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
        ),
        titleTextStyle: AppTypography.bodyLarge.copyWith(
          color: AppColorSchemes.lightColorScheme.onSurface,
        ),
        subtitleTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColorSchemes.lightColorScheme.onSurfaceVariant,
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColorSchemes.lightColorScheme.outlineVariant,
        thickness: 1.0,
        space: AppTokens.spaceM,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: AppColorSchemes.lightColorScheme.onSurface,
        size: AppTokens.iconSizeM,
      ),

      // Primary icon theme
      primaryIconTheme: IconThemeData(
        color: AppColorSchemes.lightColorScheme.onPrimary,
        size: AppTokens.iconSizeM,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorSchemes.lightColorScheme.surface,
        selectedItemColor: AppColorSchemes.lightColorScheme.primary,
        unselectedItemColor: AppColorSchemes.lightColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: AppTokens.elevationM,
      ),

      // Drawer theme
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColorSchemes.lightColorScheme.surface,
        elevation: AppTokens.elevationL,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppTokens.radiusL),
            bottomRight: Radius.circular(AppTokens.radiusL),
          ),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorSchemes.lightColorScheme.primary,
        foregroundColor: AppColorSchemes.lightColorScheme.onPrimary,
        elevation: AppTokens.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusL),
        ),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColorSchemes.darkColorScheme,
      textTheme: _buildTextTheme(AppColorSchemes.darkColorScheme),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorSchemes.darkColorScheme.surface,
        foregroundColor: AppColorSchemes.darkColorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColorSchemes.darkColorScheme.onSurface,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Card theme
      cardTheme: const CardThemeData(margin: EdgeInsets.all(AppTokens.spaceS)),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorSchemes.darkColorScheme.primary,
          foregroundColor: AppColorSchemes.darkColorScheme.onPrimary,
          elevation: AppTokens.elevationS,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spaceL,
            vertical: AppTokens.spaceM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusM),
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorSchemes.darkColorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spaceM,
            vertical: AppTokens.spaceS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusM),
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorSchemes.darkColorScheme.primary,
          side: BorderSide(
            color: AppColorSchemes.darkColorScheme.outline,
            width: 1.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spaceL,
            vertical: AppTokens.spaceM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusM),
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorSchemes.darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
          borderSide: BorderSide(
            color: AppColorSchemes.darkColorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
          borderSide: BorderSide(
            color: AppColorSchemes.darkColorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
          borderSide: BorderSide(
            color: AppColorSchemes.darkColorScheme.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
          borderSide: BorderSide(color: AppColorSchemes.darkColorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spaceM,
          vertical: AppTokens.spaceM,
        ),
        hintStyle: AppTypography.searchPlaceholder.copyWith(
          color: AppColorSchemes.darkColorScheme.onSurfaceVariant,
        ),
      ),

      // List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spaceM,
          vertical: AppTokens.spaceS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusM),
        ),
        titleTextStyle: AppTypography.bodyLarge.copyWith(
          color: AppColorSchemes.darkColorScheme.onSurface,
        ),
        subtitleTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColorSchemes.darkColorScheme.onSurfaceVariant,
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColorSchemes.darkColorScheme.outlineVariant,
        thickness: 1.0,
        space: AppTokens.spaceM,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: AppColorSchemes.darkColorScheme.onSurface,
        size: AppTokens.iconSizeM,
      ),

      // Primary icon theme
      primaryIconTheme: IconThemeData(
        color: AppColorSchemes.darkColorScheme.onPrimary,
        size: AppTokens.iconSizeM,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorSchemes.darkColorScheme.surface,
        selectedItemColor: AppColorSchemes.darkColorScheme.primary,
        unselectedItemColor: AppColorSchemes.darkColorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: AppTokens.elevationM,
      ),

      // Drawer theme
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColorSchemes.darkColorScheme.surface,
        elevation: AppTokens.elevationL,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppTokens.radiusL),
            bottomRight: Radius.circular(AppTokens.radiusL),
          ),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorSchemes.darkColorScheme.primary,
        foregroundColor: AppColorSchemes.darkColorScheme.onPrimary,
        elevation: AppTokens.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusL),
        ),
      ),
    );
  }

  /// Build text theme with proper colors
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      displayMedium: AppTypography.displayMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      displaySmall: AppTypography.displaySmall.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: colorScheme.onSurface,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: colorScheme.onSurface),
      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      bodySmall: AppTypography.bodySmall.copyWith(color: colorScheme.onSurface),
      labelLarge: AppTypography.labelLarge.copyWith(
        color: colorScheme.onSurface,
      ),
      labelMedium: AppTypography.labelMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      labelSmall: AppTypography.labelSmall.copyWith(
        color: colorScheme.onSurface,
      ),
    );
  }
}
