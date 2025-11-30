# حل مشكلة CMake و Visual Studio 2026

## المشكلة
عند محاولة بناء تطبيق Flutter لنظام Windows، يظهر الخطأ التالي:
```
CMake Error: Generator Visual Studio 16 2019 could not find any instance of Visual Studio.
```

## السبب
- لديك **Visual Studio 2026** (الإصدار 18) مثبتاً
- **Flutter 3.32.4** يحاول استخدام **Visual Studio 16 2019** بشكل افتراضي
- Flutter يتجاهل متغيرات البيئة `CMAKE_GENERATOR`

## الحلول

### الحل 1: تحديث Flutter (موصى به) ⭐
```powershell
# إذا كان Flutter لديه تغييرات محلية، استخدم --force
flutter upgrade --force

# ثم أعد بناء المشروع
flutter clean
flutter build windows --release
```

**ملاحظة**: الإصدارات الأحدث من Flutter تدعم Visual Studio 2026 بشكل أفضل.

### الحل 2: تثبيت Visual Studio 2022 بجانب Visual Studio 2026
1. قم بتحميل **Visual Studio 2022 Community** (مجاني):
   - https://visualstudio.microsoft.com/downloads/
   
2. قم بتثبيت المكونات التالية:
   - ✅ **Desktop development with C++**
   - ✅ **Windows 10/11 SDK** (أحدث إصدار)
   - ✅ **CMake tools for Windows**

3. أعد بناء المشروع:
```powershell
flutter clean
flutter build windows --release
```

### الحل 3: استخدام سكريبت البناء (تجريبي)
```powershell
.\build_windows_final.ps1
```

**ملاحظة**: هذا السكريبت قد لا يحل المشكلة لأن Flutter يتجاهل متغيرات البيئة.

## الملفات المتوفرة

1. **build_windows_final.ps1** - سكريبت شامل للبناء
2. **build_windows_simple.ps1** - سكريبت بسيط
3. **fix_cmake_visual_studio.ps1** - سكريبت الإصلاح الأصلي

## التحقق من الإعداد

```powershell
# التحقق من Flutter
flutter doctor -v

# التحقق من CMake
cmake --version

# التحقق من Visual Studio
Get-ChildItem "C:\Program Files\Microsoft Visual Studio" -ErrorAction SilentlyContinue
```

## ملاحظات مهمة

- **Visual Studio 2026** متوافق مع مولد **Visual Studio 17 2022** في CMake
- **Flutter 3.32.4** قد لا يدعم Visual Studio 2026 بشكل كامل
- الحل الأفضل هو **تحديث Flutter** أو **تثبيت Visual Studio 2022**

## إذا استمرت المشكلة

1. تأكد من تثبيت **مكونات C++ Desktop Development** في Visual Studio
2. أعد تشغيل الجهاز بعد تثبيت Visual Studio
3. تحقق من أن **CMake** في PATH
4. جرب تحديث **CMake** إلى إصدار أحدث (3.29+)

