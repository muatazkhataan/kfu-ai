import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kfu_ai/generated/l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ui' as ui;

/// Localization configuration for the KFU AI Assistant app
class AppLocalization {
  AppLocalization._();

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('ar', ''), // Arabic
    Locale('en', ''), // English
  ];

  /// Default locale
  static const Locale defaultLocale = Locale('ar', '');

  /// Localizations delegates
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Get current locale from context
  static Locale getCurrentLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }

  /// Check if current locale is Arabic
  static bool isArabic(BuildContext context) {
    return getCurrentLocale(context).languageCode == 'ar';
  }

  /// Check if current locale is English
  static bool isEnglish(BuildContext context) {
    return getCurrentLocale(context).languageCode == 'en';
  }

  /// Get text direction based on locale
  static ui.TextDirection getTextDirection(BuildContext context) {
    return isArabic(context) ? ui.TextDirection.rtl : ui.TextDirection.ltr;
  }

  /// Get app localizations from context
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  /// Get localized string with fallback
  static String getLocalizedString(
    BuildContext context,
    String Function(AppLocalizations) getter, {
    String fallback = '',
  }) {
    try {
      return getter(of(context));
    } catch (e) {
      return fallback;
    }
  }

  /// Format number based on locale
  static String formatNumber(BuildContext context, int number) {
    final locale = getCurrentLocale(context);
    return intl.NumberFormat.compact(locale: locale.toString()).format(number);
  }

  /// Format date based on locale
  static String formatDate(BuildContext context, DateTime date) {
    final locale = getCurrentLocale(context);
    return intl.DateFormat.yMMMd(locale.toString()).format(date);
  }

  /// Format time based on locale
  static String formatTime(BuildContext context, DateTime time) {
    final locale = getCurrentLocale(context);
    return intl.DateFormat.jm(locale.toString()).format(time);
  }

  /// Format date and time based on locale
  static String formatDateTime(BuildContext context, DateTime dateTime) {
    final locale = getCurrentLocale(context);
    return intl.DateFormat.yMMMd(locale.toString()).add_jm().format(dateTime);
  }
}

/// Extension on BuildContext for easy access to localization
extension LocalizationExtension on BuildContext {
  /// Get app localizations
  AppLocalizations get l10n => AppLocalization.of(this);

  /// Check if current locale is Arabic
  bool get isArabic => AppLocalization.isArabic(this);

  /// Check if current locale is English
  bool get isEnglish => AppLocalization.isEnglish(this);

  /// Get text direction
  ui.TextDirection get textDirection => AppLocalization.getTextDirection(this);

  /// Format number
  String formatNumber(int number) => AppLocalization.formatNumber(this, number);

  /// Format date
  String formatDate(DateTime date) => AppLocalization.formatDate(this, date);

  /// Format time
  String formatTime(DateTime time) => AppLocalization.formatTime(this, time);

  /// Format date and time
  String formatDateTime(DateTime dateTime) =>
      AppLocalization.formatDateTime(this, dateTime);
}
