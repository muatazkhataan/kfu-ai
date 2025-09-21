import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

/// Theme mode notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  /// Check if current theme is light
  bool get isLight => state == ThemeMode.light;

  /// Check if current theme is dark
  bool get isDark => state == ThemeMode.dark;

  /// Check if current theme is system
  bool get isSystem => state == ThemeMode.system;
}

/// Locale notifier
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar', ''));

  /// Set locale
  void setLocale(Locale locale) {
    state = locale;
  }

  /// Toggle between Arabic and English
  void toggleLanguage() {
    state = state.languageCode == 'ar'
        ? const Locale('en', '')
        : const Locale('ar', '');
  }

  /// Check if current locale is Arabic
  bool get isArabic => state.languageCode == 'ar';

  /// Check if current locale is English
  bool get isEnglish => state.languageCode == 'en';
}
