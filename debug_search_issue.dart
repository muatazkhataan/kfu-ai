import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/services/storage/local_storage_service.dart';
import 'lib/features/search/presentation/screens/search_screen.dart';

/// اختبار تشخيصي لمشكلة البحث
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة LocalStorageService
  await LocalStorageService.init();

  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: SearchScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
