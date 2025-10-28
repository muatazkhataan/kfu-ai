# 🌍 دليل دعم RTL/LTR بطريقة OOP احترافية

## 📋 الملخص

دليل شامل لدعم الاتجاهين (من اليمين لليسار / من اليسار لليمين) في تطبيق Flutter باستخدام منهجية OOP احترافية.

---

## 🎯 ما تم تطبيقه حالياً

### 1. **إعدادات اللغة والاتجاه**

#### الملفات الأساسية:
- ✅ `lib/core/localization/l10n.dart` - إدارة اللغات
- ✅ `lib/state/app_state.dart` - LocaleProvider
- ✅ `l10n.yaml` - إعدادات التوطين
- ✅ `lib/l10n/app_ar.arb` & `lib/l10n/app_en.arb` - ملفات الترجمة

#### الإعدادات:
```dart
// في lib/app/app.dart
MaterialApp(
  locale: locale,                    // اللغة الحالية
  localizationsDelegates: [          // محولات الترجمة
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('ar', ''),  // العربية (RTL)
    Locale('en', ''),  // الإنجليزية (LTR)
  ],
)
```

---

## 🏗️ البنية الاحترافية (OOP)

### النمط الأول: Direction Helper Service

#### 1. إنشاء `DirectionService`

```dart
// lib/core/services/direction_service.dart

import 'package:flutter/material.dart';

/// خدمة إدارة الاتجاه (RTL/LTR)
/// 
/// توفر طرق موحدة للتعامل مع الاتجاهات في التطبيق
class DirectionService {
  DirectionService._();

  /// الحصول على اتجاه النص من Context
  static TextDirection getTextDirection(BuildContext context) {
    return Directionality.of(context);
  }

  /// التحقق من RTL
  static bool isRTL(BuildContext context) {
    return getTextDirection(context) == TextDirection.rtl;
  }

  /// التحقق من LTR
  static bool isLTR(BuildContext context) {
    return getTextDirection(context) == TextDirection.ltr;
  }

  /// الحصول على Alignment بناءً على الاتجاه
  static Alignment getStartAlignment(BuildContext context) {
    return isRTL(context) ? Alignment.centerRight : Alignment.centerLeft;
  }

  static Alignment getEndAlignment(BuildContext context) {
    return isRTL(context) ? Alignment.centerLeft : Alignment.centerRight;
  }

  /// الحصول على CrossAxisAlignment بناءً على الاتجاه
  static CrossAxisAlignment getStartCrossAlignment(BuildContext context) {
    return isRTL(context) 
        ? CrossAxisAlignment.end 
        : CrossAxisAlignment.start;
  }

  static CrossAxisAlignment getEndCrossAlignment(BuildContext context) {
    return isRTL(context) 
        ? CrossAxisAlignment.start 
        : CrossAxisAlignment.end;
  }

  /// الحصول على EdgeInsets بناءً على الاتجاه
  static EdgeInsets getDirectionalPadding({
    required BuildContext context,
    double? start,
    double? end,
    double? top,
    double? bottom,
  }) {
    final isRtl = isRTL(context);
    return EdgeInsets.only(
      left: isRtl ? (end ?? 0) : (start ?? 0),
      right: isRtl ? (start ?? 0) : (end ?? 0),
      top: top ?? 0,
      bottom: bottom ?? 0,
    );
  }

  /// الحصول على MainAxisAlignment بناءً على الاتجاه
  static MainAxisAlignment getStartMainAlignment(BuildContext context) {
    return isRTL(context) 
        ? MainAxisAlignment.end 
        : MainAxisAlignment.start;
  }

  static MainAxisAlignment getEndMainAlignment(BuildContext context) {
    return isRTL(context) 
        ? MainAxisAlignment.start 
        : MainAxisAlignment.end;
  }
}
```

---

### النمط الثاني: Directional Widgets

#### 2. إنشاء Widgets قابلة لإعادة الاستخدام

```dart
// lib/core/widgets/directional_row.dart

import 'package:flutter/material.dart';
import '../services/direction_service.dart';

/// Row يدعم RTL/LTR تلقائياً
class DirectionalRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const DirectionalRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = DirectionService.isRTL(context);
    
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: children,
    );
  }
}
```

```dart
// lib/core/widgets/directional_padding.dart

import 'package:flutter/material.dart';
import '../services/direction_service.dart';

/// Padding يدعم RTL/LTR
class DirectionalPadding extends StatelessWidget {
  final Widget child;
  final double? start;
  final double? end;
  final double? top;
  final double? bottom;

  const DirectionalPadding({
    super.key,
    required this.child,
    this.start,
    this.end,
    this.top,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: DirectionService.getDirectionalPadding(
        context: context,
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      ),
      child: child,
    );
  }
}
```

---

### النمط الثالث: Adaptive Drawer

#### 3. Drawer تلقائي للاتجاه

```dart
// lib/core/widgets/adaptive_drawer.dart

import 'package:flutter/material.dart';
import '../services/direction_service.dart';

/// Drawer يفتح من اليمين في RTL ومن اليسار في LTR
class AdaptiveDrawer {
  AdaptiveDrawer._();

  /// إضافة Drawer للـ Scaffold حسب الاتجاه
  static Map<String, Widget?> getDrawerProperties({
    required BuildContext context,
    required Widget drawer,
  }) {
    final isRTL = DirectionService.isRTL(context);
    
    return {
      'drawer': isRTL ? null : drawer,
      'endDrawer': isRTL ? drawer : null,
    };
  }

  /// فتح Drawer حسب الاتجاه
  static void open(BuildContext context) {
    final isRTL = DirectionService.isRTL(context);
    
    if (isRTL) {
      Scaffold.of(context).openEndDrawer();
    } else {
      Scaffold.of(context).openDrawer();
    }
  }

  /// إغلاق Drawer حسب الاتجاه
  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
```

---

## 📱 التطبيق العملي في ChatScreen

### قبل (ثابت على RTL):
```dart
Scaffold(
  endDrawer: _buildNavigationDrawer(theme),  // ❌ فقط من اليمين
  appBar: AppBar(...),
)
```

### بعد (يدعم RTL & LTR):
```dart
Scaffold(
  drawer: isRTL ? null : _buildNavigationDrawer(theme),     // ✅ من اليسار في LTR
  endDrawer: isRTL ? _buildNavigationDrawer(theme) : null,  // ✅ من اليمين في RTL
  appBar: _buildAppBar(theme, chatState, isRTL),
)
```

### AppBar الجديد:

```dart
PreferredSizeWidget _buildAppBar(
  ThemeData theme,
  dynamic chatState,
  bool isRTL,
) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Builder(
      builder: (builderContext) {
        return Row(
          children: [
            // [من اليمين في RTL]
            // 1️⃣ أيقونة القائمة
            IconButton(
              icon: Icon(AppIcons.getIcon(AppIcon.menu)),
              onPressed: () {
                if (isRTL) {
                  Scaffold.of(builderContext).openEndDrawer();
                } else {
                  Scaffold.of(builderContext).openDrawer();
                }
              },
            ),
            
            // 2️⃣ العنوان (يتمدد)
            Expanded(child: Column(...)),
            
            // 3️⃣ أيقونة الإعدادات
            // [من اليسار في RTL]
            IconButton(
              icon: Icon(AppIcons.getIcon(AppIcon.settings)),
              onPressed: () { /* ... */ },
            ),
          ],
        );
      },
    ),
  );
}
```

**الترتيب في RTL (العربية)**:
```
┌─────────────────────────────────────┐
│ [⚙️ إعدادات] [العنوان] [☰ القائمة] │
└─────────────────────────────────────┘
   اليسار          الوسط        اليمين
```

**الترتيب في LTR (الإنجليزية)**:
```
┌─────────────────────────────────────┐
│ [☰ Menu] [Title] [⚙️ Settings] │
└─────────────────────────────────────┘
   Left      Center      Right
```

---

## 🔧 أمثلة للاستخدام

### مثال 1: Row مع محاذاة تلقائية

```dart
// بدلاً من:
Row(
  children: [
    Icon(...),
    Text(...),
  ],
)

// استخدم:
DirectionalRow(
  mainAxisAlignment: MainAxisAlignment.start, // يتكيف تلقائياً
  children: [
    Icon(...),
    Text(...),
  ],
)
```

### مثال 2: Padding اتجاهي

```dart
// بدلاً من:
Padding(
  padding: EdgeInsets.only(left: 16), // ❌ ثابت
  child: Text(...),
)

// استخدم:
DirectionalPadding(
  start: 16,  // ✅ يمين في RTL، يسار في LTR
  child: Text(...),
)
```

### مثال 3: فتح Drawer

```dart
// بدلاً من:
Scaffold.of(context).openEndDrawer(); // ❌ فقط من اليمين

// استخدم:
AdaptiveDrawer.open(context);  // ✅ يتكيف تلقائياً
```

---

## 📚 الهيكلية الكاملة المقترحة

```
lib/
  core/
    services/
      direction_service.dart      # خدمة الاتجاه الأساسية
      localization_service.dart   # خدمة اللغات
    
    widgets/
      directional_row.dart        # Row تلقائي
      directional_column.dart     # Column تلقائي  
      directional_padding.dart    # Padding تلقائي
      adaptive_drawer.dart        # Drawer تكيفي
      adaptive_app_bar.dart       # AppBar تكيفي
    
    extensions/
      context_extensions.dart     # extensions للـ Context
      
    localization/
      l10n.dart                   # إعدادات اللغات
```

---

## 🔌 Extensions مفيدة

```dart
// lib/core/extensions/context_extensions.dart

extension DirectionExtensions on BuildContext {
  /// هل الاتجاه من اليمين لليسار
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
  
  /// هل الاتجاه من اليسار لليمين
  bool get isLTR => !isRTL;
  
  /// الحصول على اتجاه النص
  TextDirection get textDirection => Directionality.of(this);
  
  /// الحصول على اللغة الحالية
  Locale get currentLocale => Localizations.localeOf(this);
  
  /// هل اللغة عربية
  bool get isArabic => currentLocale.languageCode == 'ar';
  
  /// هل اللغة إنجليزية
  bool get isEnglish => currentLocale.languageCode == 'en';
}

// الاستخدام:
if (context.isRTL) {
  // كود خاص بـ RTL
}
```

---

## 🎨 أفضل الممارسات

### 1. استخدم `Directionality` widget
```dart
Directionality(
  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
  child: YourWidget(),
)
```

### 2. استخدم `Alignment` الاتجاهية
```dart
// ❌ لا تستخدم:
Alignment.centerLeft
Alignment.centerRight

// ✅ استخدم:
AlignmentDirectional.centerStart  // بداية النص
AlignmentDirectional.centerEnd    // نهاية النص
```

### 3. استخدم `EdgeInsetsDirectional`
```dart
// ❌ لا تستخدم:
EdgeInsets.only(left: 16, right: 8)

// ✅ استخدم:
EdgeInsetsDirectional.only(start: 16, end: 8)
```

### 4. استخدم `Positioned.directional`
```dart
// ❌ لا تستخدم:
Positioned(left: 0, child: ...)

// ✅ استخدم:
Positioned.directional(
  textDirection: Directionality.of(context),
  start: 0,
  child: ...,
)
```

---

## 📐 ترتيب العناصر في AppBar

### التصميم المُطبق:

```dart
AppBar(
  automaticallyImplyLeading: false,
  title: Row(
    children: [
      // 1. أيقونة القائمة
      IconButton(
        icon: Icon(menuIcon),
        onPressed: () {
          if (isRTL) {
            Scaffold.of(context).openEndDrawer();
          } else {
            Scaffold.of(context).openDrawer();
          }
        },
      ),
      
      // 2. العنوان (يتمدد)
      Expanded(child: titleWidget),
      
      // 3. أيقونة الإعدادات
      IconButton(
        icon: Icon(settingsIcon),
        onPressed: onSettingsTap,
      ),
    ],
  ),
)
```

### النتيجة:

**RTL (العربية):**
```
┌──────────────────────────────────────┐
│  ⚙️         محادثة جديدة         ☰  │
│ Settings      Title         Menu     │
└──────────────────────────────────────┘
```

**LTR (English):**
```
┌──────────────────────────────────────┐
│  ☰         New Chat         ⚙️       │
│ Menu        Title         Settings   │
└──────────────────────────────────────┘
```

---

## 🗂️ Drawer الاتجاهي

### التطبيق الحالي:

```dart
final isRTL = Directionality.of(context) == TextDirection.rtl;

Scaffold(
  drawer: isRTL ? null : myDrawer,      // من اليسار في LTR
  endDrawer: isRTL ? myDrawer : null,   // من اليمين في RTL
  body: ...,
)
```

### فتح Drawer:

```dart
IconButton(
  onPressed: () {
    if (isRTL) {
      Scaffold.of(context).openEndDrawer();
    } else {
      Scaffold.of(context).openDrawer();
    }
  },
  child: Icon(menuIcon),
)
```

---

## 🎯 قواعد عامة

### ✅ افعل:

1. **استخدم Directional widgets** من Material Design:
   - `AlignmentDirectional`
   - `EdgeInsetsDirectional`
   - `Positioned.directional`

2. **تحقق من الاتجاه ديناميكياً**:
   ```dart
   final isRTL = Directionality.of(context) == TextDirection.rtl;
   ```

3. **استخدم `start` و `end`** بدلاً من `left` و `right`

4. **اجعل Row تلقائي**:
   ```dart
   Row(
     textDirection: Directionality.of(context),
     children: ...,
   )
   ```

### ❌ لا تفعل:

1. **لا تستخدم left/right مباشرة**:
   ```dart
   // ❌
   padding: EdgeInsets.only(left: 16)
   
   // ✅
   padding: EdgeInsetsDirectional.only(start: 16)
   ```

2. **لا تثبت الاتجاه**:
   ```dart
   // ❌
   textDirection: TextDirection.rtl
   
   // ✅
   textDirection: Directionality.of(context)
   ```

3. **لا تستخدم Alignment عادي**:
   ```dart
   // ❌
   alignment: Alignment.centerLeft
   
   // ✅
   alignment: AlignmentDirectional.centerStart
   ```

---

## 🧪 الاختبار

### تبديل اللغة:

```dart
// في Settings أو أي مكان
ref.read(localeProvider.notifier).toggleLanguage();
```

### السلوك المتوقع:

| اللغة | الاتجاه | القائمة | AppBar |
|------|---------|---------|--------|
| 🇸🇦 العربية | RTL | من اليمين | [⚙️ - العنوان - ☰] |
| 🇬🇧 English | LTR | من اليسار | [☰ - Title - ⚙️] |

---

## 🎨 مثال كامل لـ Screen

```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isRTL = context.isRTL;  // من extension
    
    return Scaffold(
      // Drawer تلقائي
      drawer: isRTL ? null : _buildDrawer(theme),
      endDrawer: isRTL ? _buildDrawer(theme) : null,
      
      // AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Builder(
          builder: (ctx) => Row(
            children: [
              // قائمة
              IconButton(
                icon: Icon(menuIcon),
                onPressed: () => AdaptiveDrawer.open(ctx),
              ),
              
              // عنوان
              Expanded(child: Text('Title')),
              
              // إعدادات
              IconButton(
                icon: Icon(settingsIcon),
                onPressed: onSettings,
              ),
            ],
          ),
        ),
      ),
      
      // محتوى
      body: DirectionalPadding(
        start: 16,
        end: 16,
        child: Column(...),
      ),
    );
  }
}
```

---

## 🚀 الملفات المُحدّثة في التطبيق

### 1. `lib/features/chat/presentation/screens/chat_screen.dart`

✅ **التغييرات:**
- إضافة دعم `isRTL`
- `drawer` و `endDrawer` ديناميكيان
- `_buildAppBar()` جديد بترتيب: [menu - title - settings]
- فتح Drawer حسب الاتجاه

---

## 📊 خارطة التحسينات المستقبلية

### Phase 1: الأساسيات (✅ مُنجز)
- [x] إعداد localization
- [x] دعم drawer اتجاهي
- [x] AppBar تكيفي

### Phase 2: خدمات مساعدة
- [ ] إنشاء `DirectionService`
- [ ] إنشاء `AdaptiveDrawer` class
- [ ] إضافة `context` extensions

### Phase 3: widgets مخصصة
- [ ] `DirectionalRow`
- [ ] `DirectionalPadding`
- [ ] `AdaptiveAppBar`

### Phase 4: تحسينات
- [ ] animations اتجاهية
- [ ] transitions اتجاهية
- [ ] gestures (swipe) اتجاهية

---

## ✨ الخلاصة

✅ **AppBar الآن**: [القائمة - العنوان - الإعدادات]  
✅ **Drawer**: يفتح من اليمين في RTL ومن اليسار في LTR  
✅ **نمط احترافي**: يدعم تبديل اللغة ديناميكياً  
✅ **قابل للتوسع**: بنية OOP سهلة الصيانة  

---

📄 **ملاحظة**: راجع `lib/core/localization/l10n.dart` للمزيد عن إدارة اللغات.

تم بنجاح! 🎉

