import 'package:flutter/material.dart';

/// فئة إعدادات مع معلوماتها الأساسية
class SettingsCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<SettingsItem> items;
  final int order;
  final bool isEnabled;
  final Color? accentColor;

  const SettingsCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
    this.order = 0,
    this.isEnabled = true,
    this.accentColor,
  });
}

/// عنصر إعدادات فردي
class SettingsItem {
  final String id;
  final String title;
  final String description;
  final SettingsItemType type;
  final IconData icon;
  final dynamic value;
  final dynamic defaultValue;
  final Map<String, dynamic>? options;
  final bool isEnabled;
  final String? group;
  final VoidCallback? onTap;
  final Function(dynamic)? onChanged;

  const SettingsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    this.value,
    this.defaultValue,
    this.options,
    this.isEnabled = true,
    this.group,
    this.onTap,
    this.onChanged,
  });
}

/// أنواع عناصر الإعدادات
enum SettingsItemType {
  /// مفتاح تشغيل/إيقاف
  toggle,

  /// قائمة اختيار
  dropdown,

  /// منزلق رقمي
  slider,

  /// حقل نص
  textField,

  /// زر إجراء
  button,

  /// اختيار متعدد
  multiSelect,

  /// اختيار لون
  colorPicker,

  /// محدد الوقت
  timePicker,

  /// محدد التاريخ
  datePicker,

  /// معلومات فقط (للقراءة)
  info,

  /// اختيار ملف
  filePicker,

  /// رابط خارجي
  link,
}

/// مجموعة إعدادات لتنظيم العناصر
class SettingsGroup {
  final String id;
  final String title;
  final String? description;
  final List<SettingsItem> items;
  final int order;
  final bool isCollapsible;
  final bool isExpanded;

  const SettingsGroup({
    required this.id,
    required this.title,
    this.description,
    required this.items,
    this.order = 0,
    this.isCollapsible = true,
    this.isExpanded = true,
  });
}

/// حالة تحديث الإعدادات
class SettingsUpdateState {
  final bool isUpdating;
  final bool hasUnsavedChanges;
  final String? lastSaved;
  final String? error;
  final Map<String, dynamic> pendingChanges;

  const SettingsUpdateState({
    this.isUpdating = false,
    this.hasUnsavedChanges = false,
    this.lastSaved,
    this.error,
    this.pendingChanges = const {},
  });

  SettingsUpdateState copyWith({
    bool? isUpdating,
    bool? hasUnsavedChanges,
    String? lastSaved,
    String? error,
    Map<String, dynamic>? pendingChanges,
  }) {
    return SettingsUpdateState(
      isUpdating: isUpdating ?? this.isUpdating,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      lastSaved: lastSaved ?? this.lastSaved,
      error: error ?? this.error,
      pendingChanges: pendingChanges ?? this.pendingChanges,
    );
  }
}

/// نتيجة عملية حفظ الإعدادات
abstract class SettingsSaveResult {
  const SettingsSaveResult();
}

class SettingsSaveSuccess extends SettingsSaveResult {
  final String message;
  final DateTime? timestamp;

  const SettingsSaveSuccess({required this.message, this.timestamp});
}

class SettingsSaveFailure extends SettingsSaveResult {
  final String error;
  final String? details;

  const SettingsSaveFailure({required this.error, this.details});
}

/// معلومات الاستخدام والإحصائيات
class SettingsUsageInfo {
  final double storageUsedMB;
  final double storageLimitMB;
  final int totalChats;
  final int totalMessages;
  final DateTime? lastBackup;
  final DateTime? lastSync;

  const SettingsUsageInfo({
    this.storageUsedMB = 0,
    this.storageLimitMB = 100,
    this.totalChats = 0,
    this.totalMessages = 0,
    this.lastBackup,
    this.lastSync,
  });

  /// نسبة الاستخدام من إجمالي المساحة
  double get storagePercentage {
    if (storageLimitMB <= 0) return 0;
    return (storageUsedMB / storageLimitMB).clamp(0.0, 1.0);
  }

  /// هل المساحة قريبة من الامتلاء (أكثر من 80%)
  bool get isStorageNearFull => storagePercentage > 0.8;

  /// هل المساحة ممتلئة (أكثر من 95%)
  bool get isStorageFull => storagePercentage > 0.95;

  /// النص المعروض للمساحة
  String get storageText {
    return '${storageUsedMB.toStringAsFixed(1)} MB من ${storageLimitMB.toStringAsFixed(0)} MB';
  }
}
