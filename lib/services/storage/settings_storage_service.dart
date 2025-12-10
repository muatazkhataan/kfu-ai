import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/settings/domain/models/app_settings.dart';
import 'hive_box_manager.dart';

/// خدمة تخزين الإعدادات باستخدام Hive
/// تستخدم Box منفصل للإعدادات لتجنب التعارض
class SettingsStorageService {
  /// Singleton instance
  static final SettingsStorageService _instance = SettingsStorageService._internal();
  
  factory SettingsStorageService() => _instance;
  
  SettingsStorageService._internal();

  /// اسم Box للإعدادات (منفصل عن app_settings)
  static const String _boxName = 'settings_storage';
  
  /// Box للإعدادات
  Box<String>? _box;
  
  /// حالة التهيئة
  bool _initialized = false;
  
  /// HiveBoxManager
  final HiveBoxManager _boxManager = HiveBoxManager();

  /// تهيئة الخدمة
  Future<void> initialize() async {
    if (_initialized && _box != null) {
      debugPrint('[SettingsStorageService] ✅ الخدمة مُهيأة بالفعل');
      return;
    }

    try {
      debugPrint('[SettingsStorageService] 🔧 بدء تهيئة خدمة تخزين الإعدادات...');
      
      // تهيئة HiveBoxManager
      await _boxManager.initialize();
      
      // فتح Box للإعدادات
      _box = await _boxManager.openBox<String>(_boxName);
      
      _initialized = true;
      debugPrint('[SettingsStorageService] ✅ تم تهيئة خدمة تخزين الإعدادات بنجاح');
    } catch (e) {
      debugPrint('[SettingsStorageService] ❌ خطأ في تهيئة الخدمة: $e');
      rethrow;
    }
  }

  /// حفظ الإعدادات
  Future<void> saveSettings(AppSettings settings) async {
    await initialize();

    if (!settings.isValid) {
      throw ArgumentError('الإعدادات غير صالحة');
    }

    try {
      debugPrint('[SettingsStorageService] 💾 حفظ الإعدادات...');
      
      final settingsJson = json.encode(settings.toJson());
      await _box!.put('settings', settingsJson);
      
      // حفظ تاريخ آخر تحديث
      await _box!.put(
        'last_updated',
        DateTime.now().toIso8601String(),
      );
      
      // حفظ إصدار الإعدادات
      await _box!.put('version', settings.version);
      
      debugPrint('[SettingsStorageService] ✅ تم حفظ الإعدادات بنجاح');
    } catch (e) {
      debugPrint('[SettingsStorageService] ❌ خطأ في حفظ الإعدادات: $e');
      rethrow;
    }
  }

  /// تحميل الإعدادات
  Future<AppSettings?> loadSettings() async {
    await initialize();

    try {
      debugPrint('[SettingsStorageService] 📥 تحميل الإعدادات...');
      
      final settingsJson = _box!.get('settings');
      
      if (settingsJson == null) {
        debugPrint('[SettingsStorageService] 📥 لا توجد إعدادات محفوظة');
        return null;
      }

      final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
      final settings = AppSettings.fromJson(settingsMap);
      
      debugPrint('[SettingsStorageService] ✅ تم تحميل الإعدادات بنجاح');
      return settings;
    } catch (e) {
      debugPrint('[SettingsStorageService] ❌ خطأ في تحميل الإعدادات: $e');
      return null;
    }
  }

  /// حذف الإعدادات
  Future<void> deleteSettings() async {
    await initialize();

    try {
      debugPrint('[SettingsStorageService] 🗑️ حذف الإعدادات...');
      
      await _box!.delete('settings');
      await _box!.delete('last_updated');
      await _box!.delete('version');
      
      debugPrint('[SettingsStorageService] ✅ تم حذف الإعدادات');
    } catch (e) {
      debugPrint('[SettingsStorageService] ❌ خطأ في حذف الإعدادات: $e');
      rethrow;
    }
  }

  /// الحصول على تاريخ آخر تحديث
  Future<DateTime?> getLastUpdated() async {
    await initialize();

    try {
      final lastUpdatedStr = _box!.get('last_updated');
      if (lastUpdatedStr == null) return null;
      
      return DateTime.tryParse(lastUpdatedStr);
    } catch (e) {
      debugPrint('[SettingsStorageService] ❌ خطأ في قراءة تاريخ التحديث: $e');
      return null;
    }
  }

  /// الحصول على إصدار الإعدادات
  Future<String?> getVersion() async {
    await initialize();

    try {
      return _box!.get('version');
    } catch (e) {
      debugPrint('[SettingsStorageService] ❌ خطأ في قراءة الإصدار: $e');
      return null;
    }
  }

  /// التحقق من وجود إعدادات محفوظة
  Future<bool> hasSettings() async {
    await initialize();
    return _box!.containsKey('settings');
  }

  /// الحصول على حجم البيانات المحفوظة (بالميجابايت)
  Future<double> getStorageSize() async {
    await initialize();

    try {
      int totalSize = 0;
      
      for (final key in _box!.keys) {
        final value = _box!.get(key);
        if (value != null) {
          totalSize += value.toString().length;
        }
      }
      
      // تحويل من bytes إلى MB
      return totalSize / (1024 * 1024);
    } catch (e) {
      debugPrint('[SettingsStorageService] ❌ خطأ في حساب حجم التخزين: $e');
      return 0.0;
    }
  }
}

