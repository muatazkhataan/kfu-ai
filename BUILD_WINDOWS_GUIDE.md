# دليل بناء تطبيق Windows

## المشكلة
Flutter يحاول استخدام Visual Studio 16 2019 بينما النظام يحتوي على Visual Studio 2026 (18).

## الحل السريع

### الطريقة 1: استخدام السكريبت (موصى به)
```powershell
.\build_windows_simple.ps1
```

### الطريقة 2: تحديث Flutter
```powershell
flutter upgrade
flutter clean
flutter build windows --release
```

### الطريقة 3: تثبيت Visual Studio 2022 بجانب Visual Studio 2026
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

## ملاحظات
- Visual Studio 2026 متوافق مع مولد Visual Studio 17 2022 في CMake
- Flutter قد يتجاهل متغيرات البيئة CMAKE_GENERATOR
- الحل الأفضل هو تحديث Flutter إلى إصدار أحدث يدعم Visual Studio 2026

