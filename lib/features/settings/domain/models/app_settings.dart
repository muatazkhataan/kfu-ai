import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// نموذج بيانات الإعدادات الرئيسية للتطبيق
class AppSettings {
  // ===== الإعدادات العامة =====
  final String defaultLanguage;
  final String timezone;
  final bool betaMode;
  final bool autoUpdate;

  // ===== إعدادات المظهر =====
  final ThemeMode themeMode;
  final FontSizeLevel fontSize;
  final SidebarBehavior sidebarBehavior;
  final bool animationsEnabled;
  final bool hapticFeedback;
  final double interfaceScale;

  // ===== إعدادات المحادثة =====
  final ResponseStyle responseStyle;
  final int maxMessages;
  final bool autoResponse;
  final bool showSuggestions;
  final bool autoCorrect;
  final bool soundEffects;

  // ===== إعدادات الخصوصية =====
  final bool analytics;
  final bool saveChatHistory;
  final bool allowSharing;
  final DataRetention dataRetention;

  // ===== إعدادات الإشعارات =====
  final bool enableNotifications;
  final bool updateNotifications;
  final bool featureNotifications;
  final bool notificationSound;
  final NotificationPriority priority;

  // ===== إعدادات الذكاء الاصطناعي =====
  final AIModel aiModel;
  final int creativityLevel;
  final int contextLength;
  final bool adaptiveLearning;
  final bool experimentalAI;
  final ResponseLanguage responseLanguage;

  // ===== إعدادات البيانات =====
  final bool autoBackup;
  final BackupFrequency backupFrequency;
  final bool cloudSync;
  final DataCompression dataCompression;

  // ===== معلومات التطبيق =====
  final String version;
  final DateTime? lastUpdated;
  final DateTime? lastBackup;

  const AppSettings({
    this.defaultLanguage = 'ar',
    this.timezone = 'Asia/Riyadh',
    this.betaMode = false,
    this.autoUpdate = true,
    this.themeMode = ThemeMode.system,
    this.fontSize = FontSizeLevel.medium,
    this.sidebarBehavior = SidebarBehavior.always,
    this.animationsEnabled = true,
    this.hapticFeedback = true,
    this.interfaceScale = 1.0,
    this.responseStyle = ResponseStyle.balanced,
    this.maxMessages = 100,
    this.autoResponse = true,
    this.showSuggestions = true,
    this.autoCorrect = true,
    this.soundEffects = true,
    this.analytics = true,
    this.saveChatHistory = true,
    this.allowSharing = false,
    this.dataRetention = DataRetention.sixMonths,
    this.enableNotifications = true,
    this.updateNotifications = true,
    this.featureNotifications = false,
    this.notificationSound = false,
    this.priority = NotificationPriority.normal,
    this.aiModel = AIModel.gpt35,
    this.creativityLevel = 70,
    this.contextLength = 10,
    this.adaptiveLearning = true,
    this.experimentalAI = false,
    this.responseLanguage = ResponseLanguage.auto,
    this.autoBackup = true,
    this.backupFrequency = BackupFrequency.daily,
    this.cloudSync = false,
    this.dataCompression = DataCompression.medium,
    this.version = '1.0.0',
    this.lastUpdated,
    this.lastBackup,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      defaultLanguage: json['defaultLanguage'] as String? ?? 'ar',
      timezone: json['timezone'] as String? ?? 'Asia/Riyadh',
      betaMode: json['betaMode'] as bool? ?? false,
      autoUpdate: json['autoUpdate'] as bool? ?? true,
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      fontSize: FontSizeLevel.values.firstWhere(
        (size) => size.name == json['fontSize'],
        orElse: () => FontSizeLevel.medium,
      ),
      sidebarBehavior: SidebarBehavior.values.firstWhere(
        (behavior) => behavior.name == json['sidebarBehavior'],
        orElse: () => SidebarBehavior.always,
      ),
      animationsEnabled: json['animationsEnabled'] as bool? ?? true,
      hapticFeedback: json['hapticFeedback'] as bool? ?? true,
      interfaceScale: (json['interfaceScale'] as num?)?.toDouble() ?? 1.0,
      responseStyle: ResponseStyle.values.firstWhere(
        (style) => style.name == json['responseStyle'],
        orElse: () => ResponseStyle.balanced,
      ),
      maxMessages: json['maxMessages'] as int? ?? 100,
      autoResponse: json['autoResponse'] as bool? ?? true,
      showSuggestions: json['showSuggestions'] as bool? ?? true,
      autoCorrect: json['autoCorrect'] as bool? ?? true,
      soundEffects: json['soundEffects'] as bool? ?? true,
      analytics: json['analytics'] as bool? ?? true,
      saveChatHistory: json['saveChatHistory'] as bool? ?? true,
      allowSharing: json['allowSharing'] as bool? ?? false,
      dataRetention: DataRetention.values.firstWhere(
        (retention) => retention.name == json['dataRetention'],
        orElse: () => DataRetention.sixMonths,
      ),
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      updateNotifications: json['updateNotifications'] as bool? ?? true,
      featureNotifications: json['featureNotifications'] as bool? ?? false,
      notificationSound: json['notificationSound'] as bool? ?? false,
      priority: NotificationPriority.values.firstWhere(
        (priority) => priority.name == json['priority'],
        orElse: () => NotificationPriority.normal,
      ),
      aiModel: AIModel.values.firstWhere(
        (model) => model.name == json['aiModel'],
        orElse: () => AIModel.gpt35,
      ),
      creativityLevel: json['creativityLevel'] as int? ?? 70,
      contextLength: json['contextLength'] as int? ?? 10,
      adaptiveLearning: json['adaptiveLearning'] as bool? ?? true,
      experimentalAI: json['experimentalAI'] as bool? ?? false,
      responseLanguage: ResponseLanguage.values.firstWhere(
        (lang) => lang.name == json['responseLanguage'],
        orElse: () => ResponseLanguage.auto,
      ),
      autoBackup: json['autoBackup'] as bool? ?? true,
      backupFrequency: BackupFrequency.values.firstWhere(
        (freq) => freq.name == json['backupFrequency'],
        orElse: () => BackupFrequency.daily,
      ),
      cloudSync: json['cloudSync'] as bool? ?? false,
      dataCompression: DataCompression.values.firstWhere(
        (comp) => comp.name == json['dataCompression'],
        orElse: () => DataCompression.medium,
      ),
      version: json['version'] as String? ?? '1.0.0',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String)
          : null,
      lastBackup: json['lastBackup'] != null
          ? DateTime.tryParse(json['lastBackup'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultLanguage': defaultLanguage,
      'timezone': timezone,
      'betaMode': betaMode,
      'autoUpdate': autoUpdate,
      'themeMode': themeMode.name,
      'fontSize': fontSize.name,
      'sidebarBehavior': sidebarBehavior.name,
      'animationsEnabled': animationsEnabled,
      'hapticFeedback': hapticFeedback,
      'interfaceScale': interfaceScale,
      'responseStyle': responseStyle.name,
      'maxMessages': maxMessages,
      'autoResponse': autoResponse,
      'showSuggestions': showSuggestions,
      'autoCorrect': autoCorrect,
      'soundEffects': soundEffects,
      'analytics': analytics,
      'saveChatHistory': saveChatHistory,
      'allowSharing': allowSharing,
      'dataRetention': dataRetention.name,
      'enableNotifications': enableNotifications,
      'updateNotifications': updateNotifications,
      'featureNotifications': featureNotifications,
      'notificationSound': notificationSound,
      'priority': priority.name,
      'aiModel': aiModel.name,
      'creativityLevel': creativityLevel,
      'contextLength': contextLength,
      'adaptiveLearning': adaptiveLearning,
      'experimentalAI': experimentalAI,
      'responseLanguage': responseLanguage.name,
      'autoBackup': autoBackup,
      'backupFrequency': backupFrequency.name,
      'cloudSync': cloudSync,
      'dataCompression': dataCompression.name,
      'version': version,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'lastBackup': lastBackup?.toIso8601String(),
    };
  }

  AppSettings copyWith({
    String? defaultLanguage,
    String? timezone,
    bool? betaMode,
    bool? autoUpdate,
    ThemeMode? themeMode,
    FontSizeLevel? fontSize,
    SidebarBehavior? sidebarBehavior,
    bool? animationsEnabled,
    bool? hapticFeedback,
    double? interfaceScale,
    ResponseStyle? responseStyle,
    int? maxMessages,
    bool? autoResponse,
    bool? showSuggestions,
    bool? autoCorrect,
    bool? soundEffects,
    bool? analytics,
    bool? saveChatHistory,
    bool? allowSharing,
    DataRetention? dataRetention,
    bool? enableNotifications,
    bool? updateNotifications,
    bool? featureNotifications,
    bool? notificationSound,
    NotificationPriority? priority,
    AIModel? aiModel,
    int? creativityLevel,
    int? contextLength,
    bool? adaptiveLearning,
    bool? experimentalAI,
    ResponseLanguage? responseLanguage,
    bool? autoBackup,
    BackupFrequency? backupFrequency,
    bool? cloudSync,
    DataCompression? dataCompression,
    String? version,
    DateTime? lastUpdated,
    DateTime? lastBackup,
  }) {
    return AppSettings(
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      timezone: timezone ?? this.timezone,
      betaMode: betaMode ?? this.betaMode,
      autoUpdate: autoUpdate ?? this.autoUpdate,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      sidebarBehavior: sidebarBehavior ?? this.sidebarBehavior,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      interfaceScale: interfaceScale ?? this.interfaceScale,
      responseStyle: responseStyle ?? this.responseStyle,
      maxMessages: maxMessages ?? this.maxMessages,
      autoResponse: autoResponse ?? this.autoResponse,
      showSuggestions: showSuggestions ?? this.showSuggestions,
      autoCorrect: autoCorrect ?? this.autoCorrect,
      soundEffects: soundEffects ?? this.soundEffects,
      analytics: analytics ?? this.analytics,
      saveChatHistory: saveChatHistory ?? this.saveChatHistory,
      allowSharing: allowSharing ?? this.allowSharing,
      dataRetention: dataRetention ?? this.dataRetention,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      updateNotifications: updateNotifications ?? this.updateNotifications,
      featureNotifications: featureNotifications ?? this.featureNotifications,
      notificationSound: notificationSound ?? this.notificationSound,
      priority: priority ?? this.priority,
      aiModel: aiModel ?? this.aiModel,
      creativityLevel: creativityLevel ?? this.creativityLevel,
      contextLength: contextLength ?? this.contextLength,
      adaptiveLearning: adaptiveLearning ?? this.adaptiveLearning,
      experimentalAI: experimentalAI ?? this.experimentalAI,
      responseLanguage: responseLanguage ?? this.responseLanguage,
      autoBackup: autoBackup ?? this.autoBackup,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      cloudSync: cloudSync ?? this.cloudSync,
      dataCompression: dataCompression ?? this.dataCompression,
      version: version ?? this.version,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastBackup: lastBackup ?? this.lastBackup,
    );
  }

  /// الإعدادات الافتراضية
  static const AppSettings defaults = AppSettings();

  /// تحقق من صلاحية الإعدادات
  bool get isValid {
    return maxMessages > 0 &&
        creativityLevel >= 0 &&
        creativityLevel <= 100 &&
        contextLength > 0 &&
        interfaceScale >= 0.5 &&
        interfaceScale <= 2.0;
  }

  /// حساب الحجم التقريبي للبيانات بالميجابايت
  double get approximateDataSize {
    // حساب تقديري بناءً على الإعدادات
    return (maxMessages * 0.5) + (contextLength * 0.1);
  }
}

/// مستويات حجم الخط
enum FontSizeLevel {
  @JsonValue('small')
  small,
  @JsonValue('medium')
  medium,
  @JsonValue('large')
  large,
  @JsonValue('extraLarge')
  extraLarge;

  String get label {
    switch (this) {
      case FontSizeLevel.small:
        return 'صغير';
      case FontSizeLevel.medium:
        return 'متوسط';
      case FontSizeLevel.large:
        return 'كبير';
      case FontSizeLevel.extraLarge:
        return 'كبير جداً';
    }
  }

  double get scaleFactor {
    switch (this) {
      case FontSizeLevel.small:
        return 0.9;
      case FontSizeLevel.medium:
        return 1.0;
      case FontSizeLevel.large:
        return 1.1;
      case FontSizeLevel.extraLarge:
        return 1.2;
    }
  }
}

/// سلوك الشريط الجانبي
enum SidebarBehavior {
  @JsonValue('always')
  always,
  @JsonValue('hover')
  hover,
  @JsonValue('manual')
  manual;

  String get label {
    switch (this) {
      case SidebarBehavior.always:
        return 'دائماً';
      case SidebarBehavior.hover:
        return 'عند التمرير';
      case SidebarBehavior.manual:
        return 'يدوياً';
    }
  }
}

/// أنماط الاستجابة
enum ResponseStyle {
  @JsonValue('detailed')
  detailed,
  @JsonValue('concise')
  concise,
  @JsonValue('balanced')
  balanced;

  String get label {
    switch (this) {
      case ResponseStyle.detailed:
        return 'مفصل وموسع';
      case ResponseStyle.concise:
        return 'مختصر ومباشر';
      case ResponseStyle.balanced:
        return 'متوازن';
    }
  }
}

/// مدة الاحتفاظ بالبيانات
enum DataRetention {
  @JsonValue('oneMonth')
  oneMonth,
  @JsonValue('threeMonths')
  threeMonths,
  @JsonValue('sixMonths')
  sixMonths,
  @JsonValue('oneYear')
  oneYear,
  @JsonValue('forever')
  forever;

  String get label {
    switch (this) {
      case DataRetention.oneMonth:
        return 'شهر واحد';
      case DataRetention.threeMonths:
        return 'ثلاثة أشهر';
      case DataRetention.sixMonths:
        return 'ستة أشهر';
      case DataRetention.oneYear:
        return 'سنة واحدة';
      case DataRetention.forever:
        return 'دائماً';
    }
  }
}

/// أولوية الإشعارات
enum NotificationPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high;

  String get label {
    switch (this) {
      case NotificationPriority.low:
        return 'منخفضة';
      case NotificationPriority.normal:
        return 'عادية';
      case NotificationPriority.high:
        return 'عالية';
    }
  }
}

/// نماذج الذكاء الاصطناعي
enum AIModel {
  @JsonValue('gpt-4')
  gpt4,
  @JsonValue('gpt-3.5')
  gpt35,
  @JsonValue('claude')
  claude;

  String get label {
    switch (this) {
      case AIModel.gpt4:
        return 'GPT-4 (الأكثر دقة)';
      case AIModel.gpt35:
        return 'GPT-3.5 (متوازن)';
      case AIModel.claude:
        return 'Claude (مفصل)';
    }
  }
}

/// لغة الاستجابة
enum ResponseLanguage {
  @JsonValue('auto')
  auto,
  @JsonValue('ar')
  arabic,
  @JsonValue('en')
  english;

  String get label {
    switch (this) {
      case ResponseLanguage.auto:
        return 'تلقائي';
      case ResponseLanguage.arabic:
        return 'العربية';
      case ResponseLanguage.english:
        return 'English';
    }
  }
}

/// تكرار النسخ الاحتياطي
enum BackupFrequency {
  @JsonValue('never')
  never,
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly;

  String get label {
    switch (this) {
      case BackupFrequency.never:
        return 'أبداً';
      case BackupFrequency.daily:
        return 'يومياً';
      case BackupFrequency.weekly:
        return 'أسبوعياً';
      case BackupFrequency.monthly:
        return 'شهرياً';
    }
  }
}

/// مستوى ضغط البيانات
enum DataCompression {
  @JsonValue('none')
  none,
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high;

  String get label {
    switch (this) {
      case DataCompression.none:
        return 'بدون ضغط';
      case DataCompression.low:
        return 'ضغط منخفض';
      case DataCompression.medium:
        return 'ضغط متوسط';
      case DataCompression.high:
        return 'ضغط عالي';
    }
  }
}
