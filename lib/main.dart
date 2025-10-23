import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'services/storage/local_storage_service.dart';

void main() async {
  print('[Main] 🚀 بدء تشغيل التطبيق');
  WidgetsFlutterBinding.ensureInitialized();
  print('[Main] ✅ تم تهيئة WidgetsFlutterBinding');

  // تهيئة LocalStorageService للبحث
  print('[Main] 🔧 بدء تهيئة LocalStorageService...');
  try {
    await LocalStorageService.init();
    print('[Main] ✅ تم تهيئة LocalStorageService بنجاح');
  } catch (e) {
    print('[Main] ❌ خطأ في تهيئة LocalStorageService: $e');
  }

  print('[Main] 🎯 بدء تشغيل KfuAiApp');
  runApp(const ProviderScope(child: KfuAiApp()));
}
