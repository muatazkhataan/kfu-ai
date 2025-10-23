import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/features/search/presentation/screens/search_screen.dart';

/// اختبار بسيط لشاشة البحث
void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: SearchScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
