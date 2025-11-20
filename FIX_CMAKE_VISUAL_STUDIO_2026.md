# حل مشكلة CMake و Visual Studio 2026

## المشكلة
عند محاولة بناء تطبيق Flutter لنظام Windows، قد تواجه الخطأ التالي:
```
CMake Error: Generator Visual Studio 16 2019 could not find any instance of Visual Studio.
```

## السبب
- لديك Visual Studio 2026 (الإصدار 18) مثبتاً
- CMake 4.1.0 لا يدعم Visual Studio 2026 بعد
- Flutter يحاول استخدام Visual Studio 16 2019 بشكل افتراضي

## الحلول

### الحل 1: تحديث CMake (موصى به)
1. قم بتحميل CMake 3.29 أو أحدث من: https://cmake.org/download/
2. قم بتثبيت CMake
3. تأكد من أن CMake في PATH
4. أعد بناء المشروع:
```powershell
flutter clean
flutter build windows --release
```

### الحل 2: تثبيت Visual Studio 2022 بجانب Visual Studio 2026
1. قم بتحميل Visual Studio 2022 Community من: https://visualstudio.microsoft.com/downloads/
2. قم بتثبيت المكونات التالية:
   - Desktop development with C++
   - Windows 10/11 SDK
   - CMake tools for Windows
3. أعد بناء المشروع:
```powershell
flutter clean
flutter build windows --release
```

### الحل 3: استخدام سكريبت الإصلاح
قم بتشغيل السكريبت المرفق:
```powershell
.\fix_cmake_visual_studio.ps1
```

## ملاحظات
- Visual Studio 2026 متوافق مع مولدات Visual Studio 2022 في CMake، لكن CMake 4.1.0 لا يدعم Visual Studio 2026 بشكل كامل
- الحل الأفضل هو تحديث CMake إلى إصدار 3.29 أو أحدث

