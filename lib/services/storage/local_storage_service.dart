import 'package:hive_flutter/hive_flutter.dart';

/// خدمة التخزين المحلي باستخدام Hive
class LocalStorageService {
  static const String _searchHistoryBoxName = 'search_history';
  static const String _settingsBoxName = 'app_settings';
  static const String _authBoxName = 'auth_storage';

  /// Singleton instance
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  /// تهيئة Hive
  static Future<void> init() async {
    print('[LocalStorageService] 🔧 بدء تهيئة Hive...');
    await Hive.initFlutter();
    print('[LocalStorageService] ✅ تم تهيئة Hive بنجاح');

    // فتح الـ boxes المطلوبة
    print('[LocalStorageService] 📦 فتح search history box...');
    await Hive.openBox<Map>(_searchHistoryBoxName);
    print('[LocalStorageService] ✅ تم فتح search history box');

    print('[LocalStorageService] 📦 فتح settings box...');
    await Hive.openBox<Map>(_settingsBoxName);
    print('[LocalStorageService] ✅ تم فتح settings box');

    print('[LocalStorageService] 📦 فتح auth box...');
    await Hive.openBox<dynamic>(_authBoxName);
    print('[LocalStorageService] ✅ تم فتح auth box');

    print('[LocalStorageService] 🎉 تم تهيئة LocalStorageService بالكامل');
  }

  /// فتح box للتخزين
  Future<Box<T>> _openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
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

  /// حفظ قيمة نصية
  Future<void> setString(String key, String value) async {
    final box = await _openBox<dynamic>(_settingsBoxName);
    await box.put(key, value);
  }

  /// الحصول على قيمة نصية
  Future<String?> getString(String key) async {
    final box = await _openBox<dynamic>(_settingsBoxName);
    return box.get(key) as String?;
  }

  /// حفظ قيمة منطقية
  Future<void> setBool(String key, bool value) async {
    final box = await _openBox<dynamic>(_settingsBoxName);
    await box.put(key, value);
  }

  /// الحصول على قيمة منطقية
  Future<bool?> getBool(String key) async {
    final box = await _openBox<dynamic>(_settingsBoxName);
    return box.get(key) as bool?;
  }

  /// حفظ قيمة عددية
  Future<void> setInt(String key, int value) async {
    final box = await _openBox<dynamic>(_settingsBoxName);
    await box.put(key, value);
  }

  /// الحصول على قيمة عددية
  Future<int?> getInt(String key) async {
    final box = await _openBox<dynamic>(_settingsBoxName);
    return box.get(key) as int?;
  }

  /// حذف قيمة
  Future<void> remove(String key) async {
    final box = await _openBox<dynamic>(_settingsBoxName);
    await box.delete(key);
  }

  /// مسح جميع البيانات
  Future<void> clear() async {
    final box = await _openBox<dynamic>(_settingsBoxName);
    await box.clear();
  }

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
