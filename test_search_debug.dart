import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/services/storage/local_storage_service.dart';
import 'lib/features/search/presentation/screens/search_screen.dart';

/// اختبار تشخيصي لشاشة البحث مع رسائل التتبع
void main() async {
  print('[Test] 🚀 بدء اختبار SearchScreen');

  WidgetsFlutterBinding.ensureInitialized();
  print('[Test] ✅ تم تهيئة WidgetsFlutterBinding');

  // تهيئة LocalStorageService
  print('[Test] 🔧 بدء تهيئة LocalStorageService...');
  try {
    await LocalStorageService.init();
    print('[Test] ✅ تم تهيئة LocalStorageService بنجاح');
  } catch (e) {
    print('[Test] ❌ خطأ في تهيئة LocalStorageService: $e');
  }

  print('[Test] 🎯 بدء تشغيل SearchScreen');
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: SearchScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
