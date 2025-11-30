# حل مشكلة خطأ البناء MSB8066

## المشكلة
```
error MSB8066: Custom build for 'flutter_assemble.rule' exited with code 1.
Target unpack_windows failed: PathNotFoundException: Cannot open file, path = 'C:\flutter\bin\cache\artifacts\engine\windows-x64\icudtl.dat'
```

## السبب
ملفات Flutter engine لـ Windows غير موجودة في cache.

## الحل

### الطريقة 1: استخدام flutter precache (موصى به) ✅
```powershell
# استخدام mirror Google الرسمي
$env:FLUTTER_STORAGE_BASE_URL="https://storage.googleapis.com"
$env:PUB_HOSTED_URL="https://pub.dev"
flutter precache --windows --force

# ثم البناء
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
flutter build windows --release
```

### الطريقة 2: استخدام السكريبت
```powershell
.\fix_build_error.ps1
```

## الخطوات الكاملة

1. **تنظيف المشروع:**
```powershell
flutter clean
```

2. **تحميل ملفات Windows engine:**
```powershell
$env:FLUTTER_STORAGE_BASE_URL="https://storage.googleapis.com"
$env:PUB_HOSTED_URL="https://pub.dev"
flutter precache --windows --force
```

3. **البناء:**
```powershell
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
flutter build windows --release
```

4. **إنشاء النسخة القابلة للتوزيع:**
```powershell
.\package_windows.ps1
```

## ملاحظات

- ✅ استخدام mirror Google الرسمي (`storage.googleapis.com`) لتحميل ملفات engine
- ✅ استخدام mirror الصيني (`storage.flutter-io.cn`) للبناء العادي
- ✅ `--force` في precache يفرض إعادة تحميل الملفات

## الملفات المتوفرة

- `fix_build_error.ps1` - سكريبت شامل لحل المشكلة
- `FIX_BUILD_ERROR_GUIDE.md` - هذا الدليل




