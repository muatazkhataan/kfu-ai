# إعدادات Windows لتطبيق مساعد كفو

## حجم النافذة وموضعها

تم تكوين التطبيق ليعمل على Windows بالخصائص التالية:

### أبعاد النافذة
- **العرض**: 800 بيكسل
- **الارتفاع**: 600 بيكسل
- **الموضع**: وسط الشاشة تلقائياً

### إعدادات إضافية
- **عنوان النافذة**: "مساعد كفو - KFU AI Assistant"
- **قابلية تغيير الحجم**: مُفعلة
- **الحد الأدنى للأبعاد**: 800×600
- **الحد الأقصى للأبعاد**: 1200×900

## صناديق الإدخال

تم تحسين صناديق إدخال البيانات في شاشة تسجيل الدخول:

### خصائص صناديق الإدخال
- **العرض الأقصى**: 400 بيكسل
- **التكيف التلقائي**: للشاشات الأصغر من 400 بيكسل
- **التصميم**: Floating Input Field مع تأثيرات بصرية

### فورم تسجيل الدخول المُحسن
- **العرض الأقصى للفورم كاملاً**: 400 بيكسل ✅
- **التوسيط**: الفورم في وسط الشاشة ✅
- **التكيف التلقائي**: للشاشات الأصغر من 400 بيكسل ✅

### حقول الإدخال المُحسنة
1. **حقل الرقم الأكاديمي**
   - أيقونة المستخدم
   - تسمية عائمة
   - تأثيرات التركيز
   - **العرض**: يتكيف مع عرض الفورم

2. **حقل رمز المرور**
   - أيقونة القفل
   - إخفاء النص
   - تسمية عائمة
   - **العرض**: يتكيف مع عرض الفورم

### أزرار تسجيل الدخول المُحسنة
1. **زر "التالي"**
   - **العرض الأقصى**: 200 بيكسل في الشاشات الكبيرة (>600px)
   - تصميم متجاوب للشاشات الصغيرة
   - نص قابل للطي مع `TextOverflow.ellipsis`

2. **زر "السابق"**
   - **العرض الأقصى**: 200 بيكسل في الشاشات الكبيرة (>600px)
   - تصميم متجاوب للشاشات الصغيرة
   - نص قابل للطي مع `TextOverflow.ellipsis`

3. **زر "دخول"**
   - **العرض الأقصى**: 200 بيكسل في الشاشات الكبيرة (>600px)
   - تصميم متجاوب للشاشات الصغيرة
   - نص قابل للطي مع `TextOverflow.ellipsis`

## كيفية البناء والتشغيل

### بناء تطبيق Windows
```bash
flutter build windows --debug
```

### تشغيل التطبيق
```bash
# من مجلد build/windows/x64/runner/Debug/
kfu_ai.exe
```

### بناء الإصدار النهائي
```bash
flutter build windows --release
```

## ملفات التكوين

### الملفات المُعدلة
1. `windows/runner/main.cpp` - إعدادات النافذة الرئيسية
2. `windows/runner/window_config.h` - تكوين النافذة
3. `lib/core/widgets/floating_input_field.dart` - صناديق الإدخال

### إعدادات النافذة
```cpp
// في window_config.h
constexpr int WINDOW_WIDTH = 800;
constexpr int WINDOW_HEIGHT = 600;
constexpr bool CENTER_ON_SCREEN = true;
```

### إعدادات فورم تسجيل الدخول
```dart
// في app.dart
child: Center(
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width > 400 ? 400 : double.infinity,
    ),
    child: Column(
      // ... محتوى الفورم
    ),
  ),
),
```

### إعدادات صناديق الإدخال
```dart
// في floating_input_field.dart
Container(
  width: double.infinity, // يتكيف مع عرض الفورم
  // ... باقي الإعدادات
),
```

### إعدادات أزرار تسجيل الدخول
```dart
// في login_navigation_buttons.dart
// إزالة قيود العرض - الأزرار تتكيف مع عرض الفورم
Expanded(child: ElevatedButton(...))
```

### إعدادات أزرار الاقتراحات
```dart
// في chat_screen.dart
gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4, // 4 أزرار في الصف
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: isLargeScreen ? 1.2 : 1.3,
),
```

### إعدادات زر تسجيل الدخول في شاشة البداية
```dart
// في app.dart
ElevatedButton(
  // إزالة SizedBox wrapper - الزر يتكيف تلقائياً مع محتواه
  onPressed: () { ... },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    // ... باقي الإعدادات
  ),
  child: Text(context.l10n.authLogin),
),

// في floating_input_field.dart (زر التالي)
ConstrainedBox(
  constraints: BoxConstraints(
    maxWidth: MediaQuery.of(context).size.width > 600 ? 200 : double.infinity,
  ),
  child: ElevatedButton(...),
),
```

### أزرار الاقتراحات في شاشة المحادثة
- **الشاشات الصغيرة (<600px)**: قائمة عمودية ✅
- **الشاشات المتوسطة والكبيرة (≥600px)**: شبكة 4×1 (4 أزرار في الصف) ✅
- **العرض الأقصى**: 1000px للشاشات الكبيرة، 800px للمتوسطة ✅
- **التوسيط**: الأزرار متوسطة في الشاشة ✅
- **حجم الإيموجي**: 45×45px مع خط 22px ✅

### زر تسجيل الدخول في شاشة البداية
- **العرض**: تلقائي يتكيف مع محتوى النص ✅
- **الحشو**: 32px أفقي، 16px عمودي ✅
- **التصميم**: متسق مع باقي الأزرار ✅

## ملاحظات مهمة

1. **اللغة**: النافذة تدعم النصوص العربية
2. **الخطوط**: يجب تثبيت خطوط العربية على النظام
3. **الأداء**: تم تحسين الأداء للنوافذ الصغيرة
4. **التوافق**: يعمل على Windows 10/11
5. **التصميم المتجاوب**: يتكيف مع أحجام الشاشات المختلفة

## استكشاف الأخطاء

### مشاكل شائعة
1. **النافذة لا تظهر في الوسط**: تأكد من دقة الشاشة
2. **النصوص العربية لا تظهر**: تأكد من تثبيت خطوط العربية
3. **صناديق الإدخال كبيرة جداً**: تأكد من أن العرض أكبر من 400 بيكسل

### حلول
- إعادة بناء التطبيق: `flutter clean && flutter build windows`
- التحقق من دقة الشاشة
- تثبيت خطوط العربية من Microsoft

## مشكلة CMake و Visual Studio

### المشكلة
عند محاولة بناء التطبيق، قد تواجه الخطأ التالي:
```
CMake Error: Error: generator : Visual Studio 16 2019
Does not match the generator used previously: Visual Studio 17 2022
```

أو:
```
CMake Error: Generator Visual Studio 16 2019 could not find any instance of Visual Studio.
```

### الأسباب
1. **تعارض في مولدات CMake**: تم استخدام مولد مختلف في بناء سابق
2. **Visual Studio غير مثبت**: Flutter لـ Windows يتطلب Visual Studio مع مكونات C++ Desktop Development
3. **إصدار Visual Studio غير متطابق**: النظام يحتوي على Visual Studio 2022 بينما CMake يحاول استخدام 2019

### الحلول

#### الحل 1: تنظيف ملفات CMake القديمة
```powershell
# تنظيف المشروع بالكامل
flutter clean

# حذف ملفات CMake المتبقية يدوياً (إن وجدت)
Get-ChildItem -Path "windows" -Recurse -Include "CMakeCache.txt","CMakeFiles" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
```

#### الحل 2: تثبيت Visual Studio 2022 (مطلوب)
Flutter لـ Windows **يتطلب** Visual Studio مع مكونات تطوير C++:

1. **تحميل Visual Studio 2022 Community** (مجاني):
   - من الموقع الرسمي: https://visualstudio.microsoft.com/downloads/

2. **تثبيت المكونات المطلوبة**:
   - ✅ **Desktop development with C++** (تطوير سطح المكتب باستخدام C++)
   - ✅ **Windows 10/11 SDK** (أحدث إصدار)
   - ✅ **CMake tools for Windows**

3. **إعادة تشغيل الجهاز** بعد التثبيت

4. **التحقق من التثبيت**:
   ```powershell
   # التحقق من وجود Visual Studio
   Get-ChildItem "C:\Program Files\Microsoft Visual Studio" -ErrorAction SilentlyContinue
   
   # التحقق من CMake
   cmake --version
   ```

5. **إعادة بناء المشروع**:
   ```powershell
   flutter clean
   flutter build windows --release
   ```

#### الحل 3: استخدام متغيرات البيئة (تجريبي)
```powershell
# تحديد مولد CMake (قد لا يعمل مع Flutter)
$env:CMAKE_GENERATOR="Visual Studio 17 2022"
$env:CMAKE_GENERATOR_PLATFORM="x64"
flutter build windows --release
```

**ملاحظة**: Flutter قد يتجاهل متغيرات البيئة هذه، لذا الحل الأفضل هو تثبيت Visual Studio 2022.

### متطلبات النظام
- ✅ Windows 10/11 (64-bit)
- ✅ Visual Studio 2022 Community أو أحدث
- ✅ مكونات C++ Desktop Development
- ✅ Windows SDK (أحدث إصدار)
- ✅ CMake 3.14 أو أحدث

### التحقق من الإعداد
```powershell
# التحقق من Flutter
flutter doctor -v

# التحقق من CMake
cmake --version

# التحقق من Visual Studio
where.exe devenv
```

إذا كان `flutter doctor` يظهر تحذيرات بخصوص Visual Studio، قم بتثبيت المكونات المطلوبة من Visual Studio Installer.