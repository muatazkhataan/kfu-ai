# خطة تطوير نظام حفظ الإعدادات المحترف

## 📋 تحليل المشاكل الحالية

### المشاكل المكتشفة:

1. **تعارض في فتح Hive Box:**
   - `LocalStorageService.init()` يفتح `app_settings` كـ `Box<Map>` (السطر 28)
   - `LocalSettingsRepository.initialize()` يحاول فتح نفس الـ box كـ `Box<String>` (السطر 42)
   - **النتيجة:** `HiveError: The box "app_settings" is already open and of type Box<Map<dynamic, dynamic>>`

2. **عدم وجود Singleton pattern صحيح:**
   - `LocalSettingsRepository` لا يستخدم Singleton
   - كل مرة يتم استدعاء `initialize()` يحاول فتح Box مرة أخرى
   - لا يوجد تنسيق بين الخدمات المختلفة

3. **عدم وجود إدارة مركزية:**
   - لا يوجد مدير مركزي لـ Hive Boxes
   - كل خدمة تفتح Boxes بشكل منفصل
   - صعوبة في تتبع Boxes المفتوحة

4. **عدم وجود معالجة أخطاء قوية:**
   - معالجة أخطاء بسيطة
   - لا يوجد retry mechanism
   - لا يوجد fallback strategy

## 🎯 الحل المقترح - بنية OOP احترافية

### البنية المقترحة:

```
┌─────────────────────────────────────────┐
│     HiveBoxManager (Singleton)          │
│  - إدارة مركزية لجميع Hive Boxes      │
│  - فتح وإغلاق Boxes بشكل آمن           │
│  - تتبع Boxes المفتوحة                 │
└─────────────────────────────────────────┘
                    │
                    ├─────────────────┐
                    │                 │
        ┌───────────▼───────────┐  ┌───▼──────────────────┐
        │ SettingsStorageService│  │ LocalStorageService │
        │    (Singleton)        │  │   (Singleton)       │
        │     - حفظ/تحميل الإعدادات │  │    - تخزين عام │
        │ - Box منفصل          │  │ - Boxes أخرى        │
        └───────────────────────┘  └──────────────────────┘
                    │
        ┌───────────▼─────────────┐
        │ LocalSettingsRepository │
        │   - يستخدم              │
        │   SettingsStorageService│
        └─────────────────────────┘
```

## 📐 التصميم التفصيلي

### 1. HiveBoxManager (مدير Boxes المركزي)

**المسؤوليات:**
- إدارة دورة حياة Hive Boxes
- فتح Boxes بشكل آمن مع التحقق من النوع
- تتبع Boxes المفتوحة
- إغلاق Boxes عند الحاجة
- معالجة الأخطاء والاستثناءات

**الميزات:**
- Singleton pattern
- Type-safe box management
- Error handling مع retry
- Logging شامل

### 2. SettingsStorageService (خدمة تخزين الإعدادات)

**المسؤوليات:**
- حفظ/تحميل الإعدادات من Hive
- استخدام Box منفصل للإعدادات (`settings_storage`)
- Serialization/Deserialization
- Validation
- Caching

**الميزات:**
- Singleton pattern
- Box منفصل عن `app_settings`
- Type-safe operations
- Auto-save mechanism
- Backup/Restore

### 3. LocalSettingsRepository (محدث)

**المسؤوليات:**
- استخدام `SettingsStorageService` بدلاً من فتح Box مباشرة
- التركيز على منطق الأعمال
- Validation
- Error handling

## 🔧 التطبيق

### المرحلة 1: إنشاء HiveBoxManager

```dart
class HiveBoxManager {
  static final HiveBoxManager _instance = HiveBoxManager._internal();
  factory HiveBoxManager() => _instance;
  HiveBoxManager._internal();

  final Map<String, Box> _openBoxes = {};
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _initialized = true;
  }

  Future<Box<T>> openBox<T>(String name) async {
    // فتح Box بشكل آمن
  }

  Box<T>? getBox<T>(String name) {
    // الحصول على Box مفتوح
  }

  Future<void> closeBox(String name) async {
    // إغلاق Box
  }
}
```

### المرحلة 2: إنشاء SettingsStorageService

```dart
class SettingsStorageService {
  static final SettingsStorageService _instance = SettingsStorageService._internal();
  factory SettingsStorageService() => _instance;
  SettingsStorageService._internal();

  static const String _boxName = 'settings_storage';
  Box<String>? _box;

  Future<void> initialize() async {
    final manager = HiveBoxManager();
    await manager.initialize();
    _box = await manager.openBox<String>(_boxName);
  }

  Future<void> saveSettings(AppSettings settings) async {
    // حفظ الإعدادات
  }

  Future<AppSettings?> loadSettings() async {
    // تحميل الإعدادات
  }
}
```

### المرحلة 3: تحديث LocalSettingsRepository

```dart
class LocalSettingsRepository implements SettingsRepository {
  final SettingsStorageService _storage;

  LocalSettingsRepository() : _storage = SettingsStorageService();

  @override
  Future<AppSettings> loadSettings() async {
    await _storage.initialize();
    return await _storage.loadSettings() ?? const AppSettings();
  }

  @override
  Future<SettingsSaveResult> saveSettings(AppSettings settings) async {
    await _storage.initialize();
    await _storage.saveSettings(settings);
    return SettingsSaveSuccess(...);
  }
}
```

### المرحلة 4: تحديث LocalStorageService

```dart
class LocalStorageService {
  // إزالة فتح app_settings box
  // استخدام box منفصل للبحث والتخزين العام
  static const String _searchHistoryBoxName = 'search_history';
  static const String _authBoxName = 'auth_storage';
  // لا نفتح app_settings هنا
}
```

## ✅ المزايا

1. **فصل المسؤوليات:**
   - كل خدمة لها Box منفصل
   - لا يوجد تعارض في الأنواع

2. **Singleton Pattern:**
   - إدارة مركزية للـ Boxes
   - تقليل استهلاك الذاكرة

3. **Type Safety:**
   - التحقق من أنواع Boxes
   - منع الأخطاء في وقت التصريف

4. **Error Handling:**
   - معالجة شاملة للأخطاء
   - Retry mechanism
   - Fallback strategies

5. **Testability:**
   - سهولة الاختبار
   - Mocking بسيط
   - Dependency injection

## 📝 خطوات التنفيذ

1. ✅ تحليل المشاكل الحالية
2. ⏳ إنشاء HiveBoxManager
3. ⏳ إنشاء SettingsStorageService
4. ⏳ تحديث LocalSettingsRepository
5. ⏳ تحديث LocalStorageService
6. ⏳ اختبار النظام الجديد
7. ⏳ تحديث main.dart

## 🧪 الاختبار

- اختبار فتح Boxes متعددة
- اختبار التعارض في الأنواع
- اختبار Singleton pattern
- اختبار حفظ/تحميل الإعدادات
- اختبار معالجة الأخطاء

