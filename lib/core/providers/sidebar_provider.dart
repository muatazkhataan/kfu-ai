import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider لإدارة حالة فتح/إغلاق القائمة الجانبية في الشاشات العريضة
final sidebarProvider = StateNotifierProvider<SidebarNotifier, bool>((ref) {
  return SidebarNotifier();
});

/// Notifier لإدارة حالة القائمة الجانبية
class SidebarNotifier extends StateNotifier<bool> {
  // القيمة الافتراضية: true للشاشات العريضة على أنظمة سطح المكتب (ويندوز، ماك، لينكس)
  SidebarNotifier()
    : super(Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// فتح القائمة الجانبية
  void open() {
    state = true;
  }

  /// إغلاق القائمة الجانبية
  void close() {
    state = false;
  }

  /// تبديل حالة القائمة الجانبية
  void toggle() {
    state = !state;
  }
}
