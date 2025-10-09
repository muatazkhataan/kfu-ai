import 'package:flutter/material.dart';

/// Extensions للـ BuildContext لسهولة الوصول للمعلومات الشائعة
extension ContextExtensions on BuildContext {
  // ==================== Theme ====================

  /// الحصول على Theme الحالي
  ThemeData get theme => Theme.of(this);

  /// الحصول على ColorScheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// الحصول على TextTheme
  TextTheme get textTheme => theme.textTheme;

  // ==================== Direction & Locale ====================

  /// الحصول على اتجاه النص
  TextDirection get textDirection => Directionality.of(this);

  /// هل الاتجاه من اليمين لليسار
  bool get isRTL => textDirection == TextDirection.rtl;

  /// هل الاتجاه من اليسار لليمين
  bool get isLTR => textDirection == TextDirection.ltr;

  /// الحصول على اللغة الحالية
  Locale get currentLocale => Localizations.localeOf(this);

  /// هل اللغة عربية
  bool get isArabic => currentLocale.languageCode == 'ar';

  /// هل اللغة إنجليزية
  bool get isEnglish => currentLocale.languageCode == 'en';

  // ==================== MediaQuery ====================

  /// الحصول على حجم الشاشة
  Size get screenSize => MediaQuery.of(this).size;

  /// عرض الشاشة
  double get screenWidth => screenSize.width;

  /// ارتفاع الشاشة
  double get screenHeight => screenSize.height;

  /// نسبة العرض إلى الارتفاع
  double get aspectRatio => screenWidth / screenHeight;

  /// هل الشاشة صغيرة (أقل من 600)
  bool get isSmallScreen => screenWidth < 600;

  /// هل الشاشة متوسطة (600-900)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 900;

  /// هل الشاشة كبيرة (أكبر من 900)
  bool get isLargeScreen => screenWidth >= 900;

  /// الحصول على padding
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// الحصول على viewInsets (لوحة المفاتيح)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// هل لوحة المفاتيح مفتوحة
  bool get isKeyboardOpen => viewInsets.bottom > 0;

  // ==================== Navigation ====================

  /// الانتقال إلى صفحة جديدة
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// الاستبدال بصفحة جديدة
  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(
      this,
    ).pushReplacement<T, void>(MaterialPageRoute(builder: (_) => page));
  }

  /// العودة
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// العودة إلى الصفحة الأولى
  void popUntilFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  // ==================== Drawer ====================

  /// فتح Drawer حسب الاتجاه
  /// ملاحظة: Flutter يعكس drawer/endDrawer تلقائياً في RTL!
  void openAdaptiveDrawer() {
    // في RTL: drawer يفتح من اليمين (بسبب العكس التلقائي)
    // في LTR: drawer يفتح من اليسار
    Scaffold.of(this).openDrawer();
  }

  /// إغلاق Drawer
  void closeDrawer() {
    if (Scaffold.of(this).isDrawerOpen) {
      Navigator.of(this).pop();
    }
    if (Scaffold.of(this).isEndDrawerOpen) {
      Navigator.of(this).pop();
    }
  }

  // ==================== SnackBar & Dialogs ====================

  /// عرض SnackBar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  /// عرض SnackBar خطأ
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// عرض SnackBar نجاح
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ==================== Focus ====================

  /// إزالة Focus من TextField
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// نقل Focus للعنصر التالي
  void nextFocus() {
    FocusScope.of(this).nextFocus();
  }
}
