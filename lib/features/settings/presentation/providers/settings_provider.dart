import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/models/settings_category.dart';
import '../../../../state/app_state.dart';

/// مزود الإعدادات الرئيسي
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return LocalSettingsRepository();
});

/// مزود حالة الإعدادات
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository, ref);
});

/// مزود حالة تحديث الإعدادات
final settingsUpdateStateProvider =
    StateNotifierProvider<SettingsUpdateNotifier, SettingsUpdateState>((ref) {
      return SettingsUpdateNotifier();
    });

/// مزود معلومات الاستخدام
final settingsUsageInfoProvider = FutureProvider<SettingsUsageInfo>((
  ref,
) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return await repository.getUsageInfo();
});

/// إدارة حالة الإعدادات
class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repository;
  final Ref _ref;
  Timer? _autoSaveTimer;

  SettingsNotifier(this._repository, this._ref) : super(const AppSettings()) {
    _loadSettings();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  /// تحميل الإعدادات من التخزين المحلي
  Future<void> _loadSettings() async {
    try {
      final settings = await _repository.loadSettings();
      state = settings;

      // تطبيق إعدادات المظهر فوراً
      _applyThemeSettings();

      debugPrint('[SettingsNotifier] ✅ تم تحميل الإعدادات');
    } catch (e) {
      debugPrint('[SettingsNotifier] ❌ خطأ في تحميل الإعدادات: $e');
      // في حالة الخطأ، تطبيق الإعدادات الافتراضية
      _applyThemeSettings();
    }
  }

  /// حفظ الإعدادات
  Future<SettingsSaveResult> saveSettings() async {
    try {
      final result = await _repository.saveSettings(state);

      if (result is SettingsSaveSuccess) {
        // تحديث حالة التحديث
        _ref.read(settingsUpdateStateProvider.notifier).markSaved();

        // تطبيق الإعدادات الجديدة
        _applyThemeSettings();

        debugPrint('[SettingsNotifier] ✅ تم حفظ الإعدادات بنجاح');
      }

      return result;
    } catch (e) {
      debugPrint('[SettingsNotifier] ❌ خطأ في حفظ الإعدادات: $e');
      return SettingsSaveFailure(
        error: 'فشل في حفظ الإعدادات',
        details: e.toString(),
      );
    }
  }

  /// تحديث إعداد واحد مع الحفظ التلقائي
  Future<void> updateSetting<T>(String key, T value) async {
    AppSettings newSettings;

    switch (key) {
      // ===== إعدادات المظهر =====
      case 'themeMode':
        if (value is ThemeMode) {
          newSettings = state.copyWith(themeMode: value);
          // تطبيق الثيم فوراً
          _ref.read(themeModeProvider.notifier).setThemeMode(value);
        } else {
          return;
        }
        break;
      case 'fontSize':
        if (value is FontSizeLevel) {
          newSettings = state.copyWith(fontSize: value);
        } else {
          return;
        }
        break;
      case 'animationsEnabled':
        if (value is bool) {
          newSettings = state.copyWith(animationsEnabled: value);
        } else {
          return;
        }
        break;
      case 'hapticFeedback':
        if (value is bool) {
          newSettings = state.copyWith(hapticFeedback: value);
        } else {
          return;
        }
        break;
      case 'interfaceScale':
        if (value is double) {
          newSettings = state.copyWith(interfaceScale: value);
        } else {
          return;
        }
        break;
      case 'sidebarBehavior':
        if (value is SidebarBehavior) {
          newSettings = state.copyWith(sidebarBehavior: value);
        } else {
          return;
        }
        break;

      // ===== إعدادات عامة =====
      case 'defaultLanguage':
        if (value is String) {
          newSettings = state.copyWith(defaultLanguage: value);
          // تحديث اللغة في النظام
          _updateLocale(value);
        } else {
          return;
        }
        break;
      case 'timezone':
        if (value is String) {
          newSettings = state.copyWith(timezone: value);
        } else {
          return;
        }
        break;
      case 'betaMode':
        if (value is bool) {
          newSettings = state.copyWith(betaMode: value);
        } else {
          return;
        }
        break;
      case 'autoUpdate':
        if (value is bool) {
          newSettings = state.copyWith(autoUpdate: value);
        } else {
          return;
        }
        break;

      // ===== إعدادات المحادثة =====
      case 'responseStyle':
        if (value is ResponseStyle) {
          newSettings = state.copyWith(responseStyle: value);
        } else {
          return;
        }
        break;
      case 'maxMessages':
        if (value is int) {
          newSettings = state.copyWith(maxMessages: value);
        } else {
          return;
        }
        break;
      case 'autoResponse':
        if (value is bool) {
          newSettings = state.copyWith(autoResponse: value);
        } else {
          return;
        }
        break;
      case 'showSuggestions':
        if (value is bool) {
          newSettings = state.copyWith(showSuggestions: value);
        } else {
          return;
        }
        break;
      case 'autoCorrect':
        if (value is bool) {
          newSettings = state.copyWith(autoCorrect: value);
        } else {
          return;
        }
        break;
      case 'soundEffects':
        if (value is bool) {
          newSettings = state.copyWith(soundEffects: value);
        } else {
          return;
        }
        break;

      // ===== إعدادات الخصوصية =====
      case 'analytics':
        if (value is bool) {
          newSettings = state.copyWith(analytics: value);
        } else {
          return;
        }
        break;
      case 'saveChatHistory':
        if (value is bool) {
          newSettings = state.copyWith(saveChatHistory: value);
        } else {
          return;
        }
        break;
      case 'allowSharing':
        if (value is bool) {
          newSettings = state.copyWith(allowSharing: value);
        } else {
          return;
        }
        break;
      case 'dataRetention':
        if (value is DataRetention) {
          newSettings = state.copyWith(dataRetention: value);
        } else {
          return;
        }
        break;

      // ===== إعدادات الإشعارات =====
      case 'enableNotifications':
        if (value is bool) {
          newSettings = state.copyWith(enableNotifications: value);
        } else {
          return;
        }
        break;
      case 'updateNotifications':
        if (value is bool) {
          newSettings = state.copyWith(updateNotifications: value);
        } else {
          return;
        }
        break;
      case 'featureNotifications':
        if (value is bool) {
          newSettings = state.copyWith(featureNotifications: value);
        } else {
          return;
        }
        break;
      case 'notificationSound':
        if (value is bool) {
          newSettings = state.copyWith(notificationSound: value);
        } else {
          return;
        }
        break;
      case 'priority':
        if (value is NotificationPriority) {
          newSettings = state.copyWith(priority: value);
        } else {
          return;
        }
        break;

      // ===== إعدادات الذكاء الاصطناعي =====
      case 'aiModel':
        if (value is AIModel) {
          newSettings = state.copyWith(aiModel: value);
        } else {
          return;
        }
        break;
      case 'creativityLevel':
        if (value is int) {
          newSettings = state.copyWith(creativityLevel: value);
        } else {
          return;
        }
        break;
      case 'contextLength':
        if (value is int) {
          newSettings = state.copyWith(contextLength: value);
        } else {
          return;
        }
        break;
      case 'adaptiveLearning':
        if (value is bool) {
          newSettings = state.copyWith(adaptiveLearning: value);
        } else {
          return;
        }
        break;
      case 'experimentalAI':
        if (value is bool) {
          newSettings = state.copyWith(experimentalAI: value);
        } else {
          return;
        }
        break;
      case 'responseLanguage':
        if (value is ResponseLanguage) {
          newSettings = state.copyWith(responseLanguage: value);
        } else {
          return;
        }
        break;

      // ===== إعدادات البيانات =====
      case 'autoBackup':
        if (value is bool) {
          newSettings = state.copyWith(autoBackup: value);
        } else {
          return;
        }
        break;
      case 'backupFrequency':
        if (value is BackupFrequency) {
          newSettings = state.copyWith(backupFrequency: value);
        } else {
          return;
        }
        break;
      case 'cloudSync':
        if (value is bool) {
          newSettings = state.copyWith(cloudSync: value);
        } else {
          return;
        }
        break;
      case 'dataCompression':
        if (value is DataCompression) {
          newSettings = state.copyWith(dataCompression: value);
        } else {
          return;
        }
        break;

      default:
        debugPrint('[SettingsNotifier] ⚠️ إعداد غير معروف: $key');
        return;
    }

    // تحديث الحالة
    state = newSettings;

    // تحديد التغييرات المعلقة
    _ref
        .read(settingsUpdateStateProvider.notifier)
        .addPendingChange(key, value);

    // تأخير الحفظ التلقائي
    _scheduleAutoSave();

    debugPrint('[SettingsNotifier] 🔄 تم تحديث الإعداد: $key = $value');
  }

  /// جدولة الحفظ التلقائي
  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), () {
      saveSettings();
    });
  }

  /// تطبيق إعدادات المظهر واللغة على النظام
  void _applyThemeSettings() {
    // تحديث وضع المظهر
    _ref.read(themeModeProvider.notifier).setThemeMode(state.themeMode);

    // تحديث اللغة إذا كانت مختلفة عن اللغة الحالية
    final currentLocale = _ref.read(localeProvider);
    if (currentLocale.languageCode != state.defaultLanguage) {
      _updateLocale(state.defaultLanguage);
    }

    debugPrint('[SettingsNotifier] 🎨 تم تطبيق إعدادات المظهر واللغة');
  }

  /// تحديث لغة التطبيق
  void _updateLocale(String languageCode) {
    final locale = Locale(languageCode);
    _ref.read(localeProvider.notifier).setLocale(locale);

    debugPrint('[SettingsNotifier] 🌐 تم تحديث اللغة إلى: $languageCode');
  }

  /// إعادة تعيين الإعدادات
  Future<SettingsSaveResult> resetToDefaults() async {
    try {
      final result = await _repository.resetSettings();

      if (result is SettingsSaveSuccess) {
        state = const AppSettings();
        _applyThemeSettings();

        debugPrint('[SettingsNotifier] 🔄 تم إعادة تعيين الإعدادات');
      }

      return result;
    } catch (e) {
      debugPrint('[SettingsNotifier] ❌ خطأ في إعادة التعيين: $e');
      return SettingsSaveFailure(
        error: 'فشل في إعادة تعيين الإعدادات',
        details: e.toString(),
      );
    }
  }

  /// تصدير الإعدادات
  Future<String> exportSettings() async {
    return await _repository.exportSettings();
  }

  /// استيراد الإعدادات
  Future<SettingsSaveResult> importSettings(String settingsJson) async {
    try {
      final result = await _repository.importSettings(settingsJson);

      if (result is SettingsSaveSuccess) {
        // إعادة تحميل الإعدادات
        await _loadSettings();
      }

      return result;
    } catch (e) {
      debugPrint('[SettingsNotifier] ❌ خطأ في الاستيراد: $e');
      return SettingsSaveFailure(
        error: 'فشل في استيراد الإعدادات',
        details: e.toString(),
      );
    }
  }
}

/// إدارة حالة تحديث الإعدادات
class SettingsUpdateNotifier extends StateNotifier<SettingsUpdateState> {
  SettingsUpdateNotifier() : super(const SettingsUpdateState());

  /// إضافة تغيير معلق
  void addPendingChange(String key, dynamic value) {
    final newPendingChanges = Map<String, dynamic>.from(state.pendingChanges);
    newPendingChanges[key] = value;

    state = state.copyWith(
      hasUnsavedChanges: true,
      pendingChanges: newPendingChanges,
    );
  }

  /// وضع علامة على الحفظ
  void markSaved() {
    state = state.copyWith(
      hasUnsavedChanges: false,
      lastSaved: DateTime.now().toIso8601String(),
      pendingChanges: {},
    );
  }

  /// وضع علامة خطأ
  void setError(String error) {
    state = state.copyWith(error: error);
  }

  /// مسح الخطأ
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// بدء عملية التحديث
  void startUpdating() {
    state = state.copyWith(isUpdating: true);
  }

  /// إنهاء عملية التحديث
  void stopUpdating() {
    state = state.copyWith(isUpdating: false);
  }
}
