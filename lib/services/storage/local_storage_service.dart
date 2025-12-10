import 'package:hive_flutter/hive_flutter.dart';
import 'hive_box_manager.dart';

/// خدمة التخزين المحلي باستخدام Hive
class LocalStorageService {
  static const String _searchHistoryBoxName = 'search_history';
  static const String _authBoxName = 'auth_storage';
  // تم إزالة app_settings لتجنب التعارض مع SettingsStorageService

  /// Singleton instance
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  /// مدير Boxes
  final HiveBoxManager _boxManager = HiveBoxManager();

  /// تهيئة Hive
  static Future<void> init() async {
    print('[LocalStorageService] 🔧 بدء تهيئة Hive...');
    
    // استخدام HiveBoxManager للتهيئة
    final boxManager = HiveBoxManager();
    await boxManager.initialize();
    
    print('[LocalStorageService] ✅ تم تهيئة Hive بنجاح');

    // فتح الـ boxes المطلوبة باستخدام HiveBoxManager
    final instance = LocalStorageService();
    
    print('[LocalStorageService] 📦 فتح search history box...');
    await instance._boxManager.openBox<Map>(_searchHistoryBoxName);
    print('[LocalStorageService] ✅ تم فتح search history box');

    // تم إزالة فتح app_settings box لتجنب التعارض
    // الإعدادات تُحفظ الآن في settings_storage box منفصل

    print('[LocalStorageService] 📦 فتح auth box...');
    await instance._boxManager.openBox<dynamic>(_authBoxName);
    print('[LocalStorageService] ✅ تم فتح auth box');

    print('[LocalStorageService] 🎉 تم تهيئة LocalStorageService بالكامل');
  }

  /// فتح box للتخزين
  Future<Box<T>> _openBox<T>(String boxName) async {
    return await _boxManager.openBox<T>(boxName);
  }

  // ==================== تاريخ البحث ====================

  /// حفظ تاريخ البحث
  Future<void> saveSearchHistory(String key, Map<String, dynamic> data) async {
    final box = await _openBox<Map>(_searchHistoryBoxName);
    await box.put(key, data);
  }

  /// الحصول على تاريخ البحث
  Future<List<Map<String, dynamic>>> getSearchHistory({int limit = 10}) async {
    final box = await _openBox<Map>(_searchHistoryBoxName);
    final items = box.values.toList();

    // ترتيب حسب التاريخ (الأحدث أولاً)
    items.sort((a, b) {
      final aTime = a['timestamp'] as String?;
      final bTime = b['timestamp'] as String?;
      if (aTime == null || bTime == null) return 0;
      return bTime.compareTo(aTime);
    });

    // تطبيق الحد الأقصى
    final limitedItems = items.take(limit).toList();

    return limitedItems.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  /// حذف عنصر من تاريخ البحث
  Future<void> deleteSearchHistoryItem(String key) async {
    final box = await _openBox<Map>(_searchHistoryBoxName);
    await box.delete(key);
  }

  /// مسح تاريخ البحث بالكامل
  Future<void> clearSearchHistory() async {
    final box = await _openBox<Map>(_searchHistoryBoxName);
    await box.clear();
  }

  // ==================== الإعدادات العامة ====================
  // تم إزالة هذه الطرق لأن الإعدادات تُحفظ الآن في SettingsStorageService
  // إذا كنت تحتاج لتخزين بيانات عامة أخرى، استخدم Box منفصل

  // ==================== تخزين التوثيق (سطح المكتب) ====================

  /// حفظ قيمة نصية في auth storage (لمنصات سطح المكتب)
  Future<void> setAuthString(String key, String value) async {
    final box = await _openBox<dynamic>(_authBoxName);
    await box.put(key, value);
  }

  /// قراءة قيمة نصية من auth storage
  Future<String?> getAuthString(String key) async {
    final box = await _openBox<dynamic>(_authBoxName);
    final value = box.get(key);
    return value is String ? value : value?.toString();
  }

  /// حذف مفتاح من auth storage
  Future<void> removeAuthKey(String key) async {
    final box = await _openBox<dynamic>(_authBoxName);
    await box.delete(key);
  }

  /// مسح جميع بيانات auth storage
  Future<void> clearAuth() async {
    final box = await _openBox<dynamic>(_authBoxName);
    await box.clear();
  }
}
