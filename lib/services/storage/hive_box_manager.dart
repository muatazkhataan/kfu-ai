import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// مدير مركزي لإدارة Hive Boxes
/// يستخدم Singleton pattern لإدارة Boxes بشكل آمن
class HiveBoxManager {
  /// Singleton instance
  static final HiveBoxManager _instance = HiveBoxManager._internal();
  
  factory HiveBoxManager() => _instance;
  
  HiveBoxManager._internal();

  /// Boxes المفتوحة حالياً
  final Map<String, Box> _openBoxes = {};
  
  /// حالة التهيئة
  bool _initialized = false;
  
  /// Lock للعمليات غير المتزامنة
  final Map<String, Future<Box>> _openingBoxes = {};

  /// تهيئة Hive
  Future<void> initialize() async {
    if (_initialized) {
      debugPrint('[HiveBoxManager] ✅ Hive مُهيأ بالفعل');
      return;
    }

    try {
      debugPrint('[HiveBoxManager] 🔧 بدء تهيئة Hive...');
      await Hive.initFlutter();
      _initialized = true;
      debugPrint('[HiveBoxManager] ✅ تم تهيئة Hive بنجاح');
    } catch (e) {
      debugPrint('[HiveBoxManager] ❌ خطأ في تهيئة Hive: $e');
      rethrow;
    }
  }

  /// فتح Box بشكل آمن
  /// يتحقق من النوع ويمنع التعارض
  Future<Box<T>> openBox<T>(String name) async {
    // التأكد من التهيئة
    if (!_initialized) {
      await initialize();
    }

    // التحقق من وجود Box مفتوح بالفعل
    if (_openBoxes.containsKey(name)) {
      final existingBox = _openBoxes[name];
      
      // التحقق من النوع
      if (existingBox is Box<T>) {
        debugPrint('[HiveBoxManager] ✅ Box "$name" مفتوح بالفعل');
        return existingBox;
      } else {
        throw HiveBoxTypeError(
          'Box "$name" مفتوح بالفعل بنوع مختلف: '
          '${existingBox.runtimeType} بدلاً من Box<$T>',
        );
      }
    }

    // التحقق من وجود عملية فتح جارية
    if (_openingBoxes.containsKey(name)) {
      debugPrint('[HiveBoxManager] ⏳ انتظار فتح Box "$name"...');
      final box = await _openingBoxes[name] as Future<Box<T>>;
      return box;
    }

    // فتح Box جديد
    try {
      debugPrint('[HiveBoxManager] 📦 فتح Box "$name" من نوع Box<$T>...');
      
      final openFuture = Hive.openBox<T>(name).then((box) {
        _openBoxes[name] = box;
        _openingBoxes.remove(name);
        debugPrint('[HiveBoxManager] ✅ تم فتح Box "$name" بنجاح');
        return box;
      });

      _openingBoxes[name] = openFuture;
      return await openFuture;
    } catch (e) {
      _openingBoxes.remove(name);
      debugPrint('[HiveBoxManager] ❌ خطأ في فتح Box "$name": $e');
      rethrow;
    }
  }

  /// الحصول على Box مفتوح
  Box<T>? getBox<T>(String name) {
    final box = _openBoxes[name];
    if (box is Box<T>) {
      return box;
    } else if (box != null) {
      throw HiveBoxTypeError(
        'Box "$name" موجود بنوع مختلف: '
        '${box.runtimeType} بدلاً من Box<$T>',
      );
    }
    return null;
  }

  /// التحقق من وجود Box مفتوح
  bool isBoxOpen(String name) {
    return _openBoxes.containsKey(name) && Hive.isBoxOpen(name);
  }

  /// إغلاق Box
  Future<void> closeBox(String name) async {
    if (!_openBoxes.containsKey(name)) {
      debugPrint('[HiveBoxManager] ⚠️ Box "$name" غير مفتوح');
      return;
    }

    try {
      debugPrint('[HiveBoxManager] 🔒 إغلاق Box "$name"...');
      final box = _openBoxes[name];
      await box?.close();
      _openBoxes.remove(name);
      debugPrint('[HiveBoxManager] ✅ تم إغلاق Box "$name"');
    } catch (e) {
      debugPrint('[HiveBoxManager] ❌ خطأ في إغلاق Box "$name": $e');
      // إزالة من القائمة حتى لو فشل الإغلاق
      _openBoxes.remove(name);
    }
  }

  /// إغلاق جميع Boxes
  Future<void> closeAllBoxes() async {
    debugPrint('[HiveBoxManager] 🔒 إغلاق جميع Boxes...');
    final boxNames = _openBoxes.keys.toList();
    
    for (final name in boxNames) {
      await closeBox(name);
    }
    
    debugPrint('[HiveBoxManager] ✅ تم إغلاق جميع Boxes');
  }

  /// الحصول على قائمة Boxes المفتوحة
  List<String> getOpenBoxes() {
    return _openBoxes.keys.toList();
  }

  /// إعادة تعيين المدير (للاستخدام في الاختبارات)
  @visibleForTesting
  Future<void> reset() async {
    await closeAllBoxes();
    _initialized = false;
    _openingBoxes.clear();
  }
}

/// خطأ في نوع Box
class HiveBoxTypeError extends Error {
  final String message;
  
  HiveBoxTypeError(this.message);
  
  @override
  String toString() => 'HiveBoxTypeError: $message';
}

