import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/models/settings_category.dart';
import '../../../../services/storage/settings_storage_service.dart';
import '../../../../services/storage/hive_box_manager.dart';

/// مستودع البيانات للإعدادات
abstract class SettingsRepository {
  /// تحميل الإعدادات المحفوظة
  Future<AppSettings> loadSettings();

  /// حفظ الإعدادات
  Future<SettingsSaveResult> saveSettings(AppSettings settings);

  /// إعادة تعيين الإعدادات للقيم الافتراضية
  Future<SettingsSaveResult> resetSettings();

  /// تصدير الإعدادات
  Future<String> exportSettings();

  /// استيراد الإعدادات
  Future<SettingsSaveResult> importSettings(String settingsJson);

  /// الحصول على معلومات الاستخدام
  Future<SettingsUsageInfo> getUsageInfo();

  /// تنظيف البيانات القديمة
  Future<void> cleanupOldData();
}

/// تطبيق محلي لمستودع الإعدادات باستخدام Hive
class LocalSettingsRepository implements SettingsRepository {
  static const String _usageInfoBoxName = 'usage_info';

  /// خدمة تخزين الإعدادات
  final SettingsStorageService _storageService = SettingsStorageService();
  
  /// مدير Boxes
  final HiveBoxManager _boxManager = HiveBoxManager();
  
  /// Box لمعلومات الاستخدام
  Box<String>? _usageInfoBox;
  
  /// حالة التهيئة
  bool _initialized = false;

  /// تهيئة المستودع
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      // تهيئة خدمة التخزين
      await _storageService.initialize();
      
      // فتح Box لمعلومات الاستخدام
      _usageInfoBox = await _boxManager.openBox<String>(_usageInfoBoxName);
      
      _initialized = true;
      debugPrint('[LocalSettingsRepository] ✅ تم تهيئة المستودع بنجاح');
    } catch (e) {
      debugPrint('[LocalSettingsRepository] ❌ خطأ في تهيئة المستودع: $e');
      rethrow;
    }
  }

  @override
  Future<AppSettings> loadSettings() async {
    try {
      await initialize();

      final settings = await _storageService.loadSettings();
      
      if (settings == null) {
        debugPrint(
          '[SettingsRepository] 📥 لا توجد إعدادات محفوظة، استخدام الافتراضية',
        );
        return const AppSettings();
      }

      debugPrint('[SettingsRepository] ✅ تم تحميل الإعدادات بنجاح');
      return settings;
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في تحميل الإعدادات: $e');
      return const AppSettings();
    }
  }

  @override
  Future<SettingsSaveResult> saveSettings(AppSettings settings) async {
    try {
      await initialize();

      if (!settings.isValid) {
        return const SettingsSaveFailure(
          error: 'الإعدادات غير صالحة',
          details: 'تحقق من صحة القيم المدخلة',
        );
      }

      // حفظ الإعدادات باستخدام خدمة التخزين
      await _storageService.saveSettings(settings);

      debugPrint('[SettingsRepository] ✅ تم حفظ الإعدادات بنجاح');
      return SettingsSaveSuccess(
        message: 'تم حفظ الإعدادات بنجاح',
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في حفظ الإعدادات: $e');
      return SettingsSaveFailure(
        error: 'فشل في حفظ الإعدادات',
        details: e.toString(),
      );
    }
  }

  @override
  Future<SettingsSaveResult> resetSettings() async {
    try {
      await initialize();

      // حذف الإعدادات المحفوظة
      await _storageService.deleteSettings();

      debugPrint('[SettingsRepository] 🔄 تم إعادة تعيين الإعدادات');
      return SettingsSaveSuccess(
        message: 'تم إعادة تعيين الإعدادات بنجاح',
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في إعادة التعيين: $e');
      return SettingsSaveFailure(
        error: 'فشل في إعادة تعيين الإعدادات',
        details: e.toString(),
      );
    }
  }

  @override
  Future<String> exportSettings() async {
    try {
      final settings = await loadSettings();
      final exportData = {
        'version': '1.0.0',
        'exportDate': DateTime.now().toIso8601String(),
        'settings': settings.toJson(),
      };

      return json.encode(exportData);
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في التصدير: $e');
      rethrow;
    }
  }

  @override
  Future<SettingsSaveResult> importSettings(String settingsJson) async {
    try {
      final importData = json.decode(settingsJson) as Map<String, dynamic>;

      if (!importData.containsKey('settings')) {
        return const SettingsSaveFailure(
          error: 'ملف الإعدادات غير صالح',
          details: 'لا يحتوي على بيانات الإعدادات',
        );
      }

      final settingsData = importData['settings'] as Map<String, dynamic>;
      final settings = AppSettings.fromJson(settingsData);

      return await saveSettings(settings);
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في الاستيراد: $e');
      return SettingsSaveFailure(
        error: 'فشل في استيراد الإعدادات',
        details: e.toString(),
      );
    }
  }

  @override
  Future<SettingsUsageInfo> getUsageInfo() async {
    try {
      await initialize();

      final usageJson = _usageInfoBox!.get('usage_info');
      if (usageJson == null) {
        // حساب حجم التخزين من خدمة الإعدادات
        final storageSize = await _storageService.getStorageSize();
        return SettingsUsageInfo(
          storageUsedMB: storageSize,
        );
      }

      final usageMap = json.decode(usageJson) as Map<String, dynamic>;
      
      // إضافة حجم تخزين الإعدادات
      final settingsSize = await _storageService.getStorageSize();
      final totalStorage = (usageMap['storageUsedMB'] as num?)?.toDouble() ?? 0;
      
      return SettingsUsageInfo(
        storageUsedMB: totalStorage + settingsSize,
        storageLimitMB: (usageMap['storageLimitMB'] as num?)?.toDouble() ?? 100,
        totalChats: usageMap['totalChats'] as int? ?? 0,
        totalMessages: usageMap['totalMessages'] as int? ?? 0,
        lastBackup: usageMap['lastBackup'] != null
            ? DateTime.tryParse(usageMap['lastBackup'] as String)
            : null,
        lastSync: usageMap['lastSync'] != null
            ? DateTime.tryParse(usageMap['lastSync'] as String)
            : null,
      );
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في تحميل معلومات الاستخدام: $e');
      return const SettingsUsageInfo();
    }
  }

  /// تحديث معلومات الاستخدام
  Future<void> updateUsageInfo(SettingsUsageInfo usageInfo) async {
    try {
      await initialize();

      final usageJson = json.encode({
        'storageUsedMB': usageInfo.storageUsedMB,
        'storageLimitMB': usageInfo.storageLimitMB,
        'totalChats': usageInfo.totalChats,
        'totalMessages': usageInfo.totalMessages,
        'lastBackup': usageInfo.lastBackup?.toIso8601String(),
        'lastSync': usageInfo.lastSync?.toIso8601String(),
      });

      await _usageInfoBox!.put('usage_info', usageJson);
      debugPrint('[SettingsRepository] ✅ تم تحديث معلومات الاستخدام');
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في تحديث معلومات الاستخدام: $e');
    }
  }

  @override
  Future<void> cleanupOldData() async {
    try {
      await initialize();

      // تنظيف البيانات القديمة من Box معلومات الاستخدام
      final keys = _usageInfoBox!.keys.toList();
      final now = DateTime.now();

      for (final key in keys) {
        if (key.toString().startsWith('temp_') ||
            key.toString().startsWith('cache_')) {
          final value = _usageInfoBox!.get(key);
          if (value != null) {
            try {
              final data = json.decode(value) as Map<String, dynamic>;
              final timestamp = DateTime.tryParse(
                data['timestamp'] as String? ?? '',
              );

              if (timestamp != null && now.difference(timestamp).inDays > 30) {
                await _usageInfoBox!.delete(key);
                debugPrint(
                  '[SettingsRepository] 🗑️ تم حذف البيانات القديمة: $key',
                );
              }
            } catch (e) {
              // تجاهل الأخطاء في البيانات التالفة
              await _usageInfoBox!.delete(key);
            }
          }
        }
      }
      
      debugPrint('[SettingsRepository] ✅ تم تنظيف البيانات القديمة');
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في تنظيف البيانات: $e');
    }
  }

  /// الحصول على حجم البيانات المحفوظة
  Future<double> getStorageSize() async {
    try {
      await initialize();

      // حجم تخزين الإعدادات
      final settingsSize = await _storageService.getStorageSize();
      
      // حجم Box معلومات الاستخدام
      int usageSize = 0;
      final usageKeys = _usageInfoBox!.keys.toList();
      for (final key in usageKeys) {
        final value = _usageInfoBox!.get(key);
        if (value != null) {
          usageSize += value.toString().length;
        }
      }
      
      final totalSize = settingsSize + (usageSize / (1024 * 1024));
      return totalSize;
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في حساب حجم التخزين: $e');
      return 0.0;
    }
  }
}
