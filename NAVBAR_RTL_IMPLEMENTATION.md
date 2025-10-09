# 🎨 تطبيق NavBar مع دعم RTL/LTR

## ✅ ما تم إنجازه

تم إعادة تصميم **AppBar** و**Drawer** في شاشة المحادثة لدعم RTL/LTR بشكل ديناميكي.

---

## 📐 الترتيب الجديد للـ AppBar

### في RTL (العربية):
```
┌─────────────────────────────────────────┐
│  ⚙️            محادثة جديدة         ☰  │
│ إعدادات          العنوان          قائمة │
└─────────────────────────────────────────┘
   اليسار          الوسط           اليمين
```

### في LTR (English):
```
┌─────────────────────────────────────────┐
│  ☰            New Chat            ⚙️    │
│ Menu           Title          Settings  │
└─────────────────────────────────────────┘
   Left          Center            Right
```

---

## 🔧 التغييرات التقنية

### 1. **تحديث `build()` في ChatScreen**

```dart
@override
Widget build(BuildContext context) {
  final theme = context.theme;           // ✅ استخدام extension
  final chatState = ref.watch(chatProvider);
  final isRTL = context.isRTL;           // ✅ استخدام extension

  return Scaffold(
    drawer: isRTL ? null : _buildNavigationDrawer(theme),
    endDrawer: isRTL ? _buildNavigationDrawer(theme) : null,
    appBar: _buildAppBar(theme, chatState, isRTL),
    body: ...,
  );
}
```

### 2. **إنشاء `_buildAppBar()` الجديد**

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
            // 1️⃣ أيقونة القائمة
            IconButton(
              icon: Icon(AppIcons.getIcon(AppIcon.menu)),
              onPressed: () => builderContext.openAdaptiveDrawer(),
            ),
            
            const SizedBox(width: 8),
            
            // 2️⃣ العنوان (يتمدد)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_getChatTitle(chatState)),
                  if (_getChatSubtitle(chatState).isNotEmpty)
                    Text(_getChatSubtitle(chatState)),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // 3️⃣ أيقونة الإعدادات
            IconButton(
              icon: Icon(AppIcons.getIcon(AppIcon.settings)),
              onPressed: () { /* TODO */ },
            ),
          ],
        );
      },
    ),
  );
}
```

### 3. **حذف `_buildChatHeader()` القديم**

تم حذف الدالة القديمة لأنها لم تعد تُستخدم.

---

## 🎯 Context Extensions الجديد

### الملف: `lib/core/extensions/context_extensions.dart`

#### أمثلة على الاستخدام:

```dart
// ❌ قبل:
final theme = Theme.of(context);
final isRTL = Directionality.of(context) == TextDirection.rtl;
final width = MediaQuery.of(context).size.width;

// ✅ بعد:
final theme = context.theme;
final isRTL = context.isRTL;
final width = context.screenWidth;
```

#### الـ Extensions المتوفرة:

##### Theme & Style
- `context.theme` - ThemeData
- `context.colorScheme` - ColorScheme
- `context.textTheme` - TextTheme

##### Direction & Locale
- `context.isRTL` - bool
- `context.isLTR` - bool
- `context.textDirection` - TextDirection
- `context.isArabic` - bool
- `context.isEnglish` - bool
- `context.currentLocale` - Locale

##### MediaQuery
- `context.screenSize` - Size
- `context.screenWidth` - double
- `context.screenHeight` - double
- `context.isSmallScreen` - bool (< 600)
- `context.isMediumScreen` - bool (600-900)
- `context.isLargeScreen` - bool (> 900)
- `context.isKeyboardOpen` - bool

##### Navigation
- `context.push(page)` - الانتقال لصفحة
- `context.pushReplacement(page)` - الاستبدال
- `context.pop()` - العودة
- `context.popUntilFirst()` - العودة للصفحة الأولى

##### Drawer
- `context.openAdaptiveDrawer()` - فتح Drawer حسب الاتجاه
- `context.closeDrawer()` - إغلاق Drawer

##### SnackBar
- `context.showSnackBar(message)` - عرض رسالة
- `context.showErrorSnackBar(message)` - عرض خطأ
- `context.showSuccessSnackBar(message)` - عرض نجاح

##### Focus
- `context.unfocus()` - إخفاء لوحة المفاتيح
- `context.nextFocus()` - الانتقال للحقل التالي

---

## 🗂️ كيفية عمل Drawer الاتجاهي

### الكود:

```dart
Scaffold(
  drawer: isRTL ? null : myDrawer,      // من اليسار في LTR
  endDrawer: isRTL ? myDrawer : null,   // من اليمين في RTL
  body: ...,
)
```

### السلوك:

| اللغة | الاتجاه | Property | يفتح من |
|------|---------|----------|---------|
| 🇸🇦 العربية | RTL | `endDrawer` | اليمين ← |
| 🇬🇧 English | LTR | `drawer` | ← اليسار |

### فتح Drawer:

```dart
// الطريقة اليدوية:
if (context.isRTL) {
  Scaffold.of(context).openEndDrawer();
} else {
  Scaffold.of(context).openDrawer();
}

// ✅ الطريقة السهلة (باستخدام extension):
context.openAdaptiveDrawer();
```

---

## 📱 مثال كامل: Adaptive Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/extensions/context_extensions.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final isRTL = context.isRTL;

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
              // 1. القائمة
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => ctx.openAdaptiveDrawer(),
              ),
              
              // 2. العنوان
              Expanded(child: Text('My Screen')),
              
              // 3. الإعدادات
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: _onSettings,
              ),
            ],
          ),
        ),
      ),
      
      // المحتوى
      body: Padding(
        padding: EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('محتوى الشاشة'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(ThemeData theme) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('القائمة')),
          ListTile(title: Text('خيار 1')),
          ListTile(title: Text('خيار 2')),
        ],
      ),
    );
  }

  void _onSettings() {
    // TODO: فتح الإعدادات
  }
}
```

---

## 🎨 Widgets Directional مخصصة (اختيارية)

### إنشاء Widgets قابلة لإعادة الاستخدام

#### AdaptiveAppBar:

```dart
// lib/core/widgets/adaptive_app_bar.dart

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSettingsTap;
  final List<Widget>? actions;

  const AdaptiveAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onMenuTap,
    this.onSettingsTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    return AppBar(
      automaticallyImplyLeading: false,
      title: Builder(
        builder: (ctx) => Row(
          children: [
            // قائمة
            if (onMenuTap != null)
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  if (onMenuTap != null) {
                    onMenuTap!();
                  } else {
                    ctx.openAdaptiveDrawer();
                  }
                },
              ),
            
            const SizedBox(width: 8),
            
            // عنوان
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, maxLines: 1),
                  if (subtitle != null)
                    Text(subtitle!, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // إعدادات أو actions
            if (onSettingsTap != null)
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: onSettingsTap,
              ),
            
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// الاستخدام:
AdaptiveAppBar(
  title: 'محادثة جديدة',
  subtitle: '5 رسائل',
  onMenuTap: () => context.openAdaptiveDrawer(),
  onSettingsTap: _goToSettings,
)
```

---

## 🔄 تبديل اللغة

### في الإعدادات:

```dart
// تبديل اللغة
ref.read(localeProvider.notifier).toggleLanguage();

// تحديد لغة معينة
ref.read(localeProvider.notifier).setLocale(
  const Locale('ar', ''),  // العربية
);
```

### السلوك التلقائي:

1. ✅ MaterialApp تستمع لـ `localeProvider`
2. ✅ عند تغيير اللغة، يُعاد بناء التطبيق
3. ✅ `Directionality` يتغير تلقائياً
4. ✅ `Drawer` ينتقل للجهة الصحيحة
5. ✅ `AppBar` يُعيد ترتيب العناصر

---

## 📊 الملفات المُعدّلة

### 1. ✅ `lib/features/chat/presentation/screens/chat_screen.dart`
- تحديث `build()` لدعم RTL/LTR
- إضافة `_buildAppBar()` جديد
- دعم `drawer` و `endDrawer` ديناميكياً
- حذف `_buildChatHeader()` القديم

### 2. ✅ `lib/core/extensions/context_extensions.dart` (جديد)
- Extensions شاملة للـ BuildContext
- سهولة الوصول للمعلومات الشائعة
- دوال مساعدة للـ navigation و snackbar

### 3. 📄 `RTL_LTR_SUPPORT_GUIDE.md` (دليل شامل)
- أنماط OOP احترافية
- أمثلة تطبيقية
- أفضل الممارسات

---

## 🎯 النتيجة

### في التطبيق الآن:

✅ **AppBar**:
- الترتيب: [القائمة - العنوان - الإعدادات]
- يتكيف مع الاتجاه تلقائياً
- أزرار واضحة ومنظمة

✅ **Drawer**:
- يفتح من اليمين في العربية (RTL)
- يفتح من اليسار في الإنجليزية (LTR)
- زر القائمة يعمل بشكل صحيح

✅ **Extensions**:
- كود أنظف وأقصر
- سهولة في الصيانة
- قابلية إعادة الاستخدام

---

## 📱 الاستخدام

### فتح القائمة:
1. **انقر على أيقونة ☰** في أقصى اليمين (RTL) أو أقصى اليسار (LTR)
2. **القائمة تفتح من الجهة الصحيحة** تلقائياً

### فتح الإعدادات:
1. **انقر على أيقونة ⚙️** في أقصى اليسار (RTL) أو أقصى اليمين (LTR)
2. **TODO**: سيتم إضافة شاشة الإعدادات لاحقاً

---

## 🚀 التحسينات المستقبلية

### يمكن إضافة:

1. **AdaptiveDrawer class** - لتسهيل استخدام Drawer
2. **DirectionalRow/Column** - Widgets مخصصة
3. **DirectionService** - خدمة شاملة
4. **تبديل اللغة من الإعدادات** - UI لتبديل اللغة

راجع `RTL_LTR_SUPPORT_GUIDE.md` للتفاصيل الكاملة!

---

تم بنجاح! 🎉

