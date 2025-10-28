import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/models/settings_category.dart';

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
  static const String _settingsBoxName = 'app_settings';
  static const String _usageInfoBoxName = 'usage_info';

  Box<String>? _settingsBox;
  Box<String>? _usageInfoBox;

  /// تهيئة المستودع
  Future<void> initialize() async {
    if (!Hive.isBoxOpen(_settingsBoxName)) {
      _settingsBox = await Hive.openBox<String>(_settingsBoxName);
    } else {
      _settingsBox = Hive.box<String>(_settingsBoxName);
    }

    if (!Hive.isBoxOpen(_usageInfoBoxName)) {
      _usageInfoBox = await Hive.openBox<String>(_usageInfoBoxName);
    } else {
      _usageInfoBox = Hive.box<String>(_usageInfoBoxName);
    }
  }

  @override
  Future<AppSettings> loadSettings() async {
    try {
      await initialize();

      final settingsJson = _settingsBox!.get('settings');
      if (settingsJson == null) {
        debugPrint(
          '[SettingsRepository] 📥 لا توجد إعدادات محفوظة، استخدام الافتراضية',
        );
        return const AppSettings();
      }

      final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
      final settings = AppSettings.fromJson(settingsMap);

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

      final settingsJson = json.encode(settings.toJson());
      await _settingsBox!.put('settings', settingsJson);

      // تحديث تاريخ آخر حفظ
      await _settingsBox!.put(
        'last_settings_save',
        DateTime.now().toIso8601String(),
      );

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
      await _settingsBox!.delete('settings');
      await _settingsBox!.delete('last_settings_save');

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
        return const SettingsUsageInfo();
      }

      final usageMap = json.decode(usageJson) as Map<String, dynamic>;
      return SettingsUsageInfo(
        storageUsedMB: (usageMap['storageUsedMB'] as num?)?.toDouble() ?? 0,
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

      // تنظيف البيانات القديمة (أكثر من 30 يوم)
      await initialize();
      final keys = _settingsBox!.keys.toList();
      final now = DateTime.now();

      for (final key in keys) {
        if (key.toString().startsWith('temp_') ||
            key.toString().startsWith('cache_')) {
          final value = _settingsBox!.get(key);
          if (value != null) {
            try {
              final data = json.decode(value) as Map<String, dynamic>;
              final timestamp = DateTime.tryParse(
                data['timestamp'] as String? ?? '',
              );

              if (timestamp != null && now.difference(timestamp).inDays > 30) {
                await _settingsBox!.delete(key);
                debugPrint(
                  '[SettingsRepository] 🗑️ تم حذف البيانات القديمة: $key',
                );
              }
            } catch (e) {
              // تجاهل الأخطاء في البيانات التالفة
              await _settingsBox!.delete(key);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في تنظيف البيانات: $e');
    }
  }

  /// الحصول على حجم البيانات المحفوظة
  Future<double> getStorageSize() async {
    try {
      await initialize();

      final keys = _settingsBox!.keys.toList();
      int totalSize = 0;

      for (final key in keys) {
        final value = _settingsBox!.get(key);
        if (value != null) {
          totalSize += value.toString().length;
        }
      }

      // إضافة حجم صندوق معلومات الاستخدام
      final usageKeys = _usageInfoBox!.keys.toList();
      for (final key in usageKeys) {
        final value = _usageInfoBox!.get(key);
        if (value != null) {
          totalSize += value.toString().length;
        }
      }

      // تحويل من bytes إلى MB
      return totalSize / (1024 * 1024);
    } catch (e) {
      debugPrint('[SettingsRepository] ❌ خطأ في حساب حجم التخزين: $e');
      return 0.0;
    }
  }
}
