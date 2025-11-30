# دليل إنشاء نسخة Windows قابلة للتوزيع

## نظرة عامة
هذا الدليل يشرح كيفية إنشاء نسخة قابلة للتشغيل على جميع أجهزة Windows تتضمن جميع الملفات المطلوبة (الخطوط، الأيقونات، المكتبات).

## المتطلبات
- ✅ Flutter مثبت ومضبوط
- ✅ Visual Studio مع مكونات C++ Desktop Development
- ✅ تم بناء التطبيق بنجاح (`flutter build windows --release`)

## الطريقة السريعة

### استخدام السكريبت التلقائي
```powershell
.\create_windows_package.ps1
```

هذا السكريبت يقوم بـ:
1. بناء التطبيق (`flutter build windows --release`)
2. نسخ جميع الملفات المطلوبة
3. إنشاء مجلد package كامل
4. إنشاء ملف ZIP للتوزيع

### مع تحديد الإصدار
```powershell
.\create_windows_package.ps1 -Version "1.0.2"
```

## الملفات المضمنة في النسخة

### الملفات الأساسية
- `kfu_ai.exe` - التطبيق الرئيسي
- `*.dll` - جميع المكتبات المطلوبة (Flutter، plugins، إلخ)

### المجلدات
- `data/` - يحتوي على:
  - `flutter_assets/` - جميع الأصول (assets)
    - `fonts/` - الخطوط المخصصة (IBMPlexSansArabic، FontAwesome)
    - `images/` - الصور
    - `svg/` - ملفات SVG
    - `icons/` - الأيقونات
  - `icudtl.dat` - بيانات Unicode

- `native_assets/` - الأصول الأصلية (إن وجدت)

## التحقق من النسخة

### 1. التحقق من الخطوط
```powershell
# بعد إنشاء النسخة
$packageDir = "dist\kfu_ai_windows_1.0.1"
$fonts = Get-ChildItem "$packageDir\data\flutter_assets\fonts" -Recurse
Write-Host "Fonts found: $($fonts.Count)"
```

### 2. التحقق من الأيقونات
```powershell
$icons = Get-ChildItem "$packageDir\data\flutter_assets\icons" -Recurse
Write-Host "Icons found: $($icons.Count)"
```

### 3. التحقق من الملفات المطلوبة
```powershell
$requiredFiles = @("kfu_ai.exe", "flutter_windows.dll", "data\flutter_assets")
foreach ($file in $requiredFiles) {
    $path = Join-Path $packageDir $file
    if (Test-Path $path) {
        Write-Host "✓ $file" -ForegroundColor Green
    } else {
        Write-Host "✗ $file MISSING!" -ForegroundColor Red
    }
}
```

## التوزيع

### الطريقة 1: ملف ZIP (بسيط)
```powershell
# السكريبت ينشئ ZIP تلقائياً
# الملف: dist\kfu_ai_windows_1.0.1.zip
```

**المميزات:**
- ✅ بسيط وسريع
- ✅ لا يحتاج برامج إضافية
- ✅ يعمل على جميع أجهزة Windows

**العيوب:**
- ❌ لا يوجد installer
- ❌ لا يوجد shortcuts تلقائية

### الطريقة 2: إنشاء Installer (موصى به)

#### باستخدام Inno Setup (مجاني)
1. تحميل Inno Setup: https://jrsoftware.org/isdl.php
2. إنشاء ملف `.iss`:
```inno
[Setup]
AppName=مساعد كفو
AppVersion=1.0.1
DefaultDirName={pf}\KFU AI Assistant
DefaultGroupName=KFU AI Assistant
OutputDir=installer
OutputBaseFilename=kfu_ai_setup
Compression=lzma2
SolidCompression=yes

[Files]
Source: "dist\kfu_ai_windows_1.0.1\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\مساعد كفو"; Filename: "{app}\kfu_ai.exe"
Name: "{commondesktop}\مساعد كفو"; Filename: "{app}\kfu_ai.exe"

[Run]
Filename: "{app}\kfu_ai.exe"; Description: "تشغيل مساعد كفو"; Flags: nowait postinstall skipifsilent
```

3. تجميع installer من Inno Setup

#### باستخدام WiX Toolset (متقدم)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
  <Product Id="*" Name="KFU AI Assistant" Language="1033" Version="1.0.1" Manufacturer="KFU" UpgradeCode="YOUR-GUID-HERE">
    <Package InstallerVersion="200" Compressed="yes" InstallScope="perMachine" />
    <MajorUpgrade DowngradeErrorMessage="A newer version is already installed." />
    <MediaTemplate />
    
    <Feature Id="ProductFeature" Title="KFU AI Assistant" Level="1">
      <ComponentGroupRef Id="ProductComponents" />
    </Feature>
  </Product>
  
  <Fragment>
    <Directory Id="TARGETDIR" Name="SourceDir">
      <Directory Id="ProgramFilesFolder">
        <Directory Id="INSTALLFOLDER" Name="KFU AI Assistant" />
      </Directory>
    </Directory>
  </Fragment>
  
  <Fragment>
    <ComponentGroup Id="ProductComponents" Directory="INSTALLFOLDER">
      <Component Id="ApplicationFiles">
        <File Id="kfu_ai.exe" Source="dist\kfu_ai_windows_1.0.1\kfu_ai.exe" KeyPath="yes" />
        <!-- Add other files -->
      </Component>
    </ComponentGroup>
  </Fragment>
</Wix>
```

## الاختبار

### اختبار على جهاز مختلف
1. انسخ المجلد `dist\kfu_ai_windows_1.0.1` إلى جهاز Windows آخر
2. تأكد من عدم تثبيت Flutter على الجهاز
3. شغّل `kfu_ai.exe`
4. تحقق من:
   - ✅ التطبيق يعمل
   - ✅ الخطوط العربية تظهر بشكل صحيح
   - ✅ الأيقونات تظهر
   - ✅ جميع الميزات تعمل

### اختبار على Windows 10/11
```powershell
# على جهاز Windows 10
# نسخ المجلد واختبار
```

## حل المشاكل الشائعة

### المشكلة: الخطوط لا تظهر
**الحل:**
- تأكد من وجود مجلد `data\flutter_assets\fonts`
- تحقق من أن ملفات الخطوط موجودة (.ttf, .otf)

### المشكلة: الأيقونات لا تظهر
**الحل:**
- تأكد من وجود مجلد `data\flutter_assets\icons`
- تحقق من ملفات SVG والصور

### المشكلة: خطأ "DLL not found"
**الحل:**
- تأكد من نسخ جميع ملفات `.dll` من مجلد Release
- تأكد من وجود `flutter_windows.dll`

### المشكلة: التطبيق لا يعمل على Windows 7/8
**الحل:**
- Flutter Windows يتطلب Windows 10 أو أحدث
- تأكد من تثبيت Visual C++ Redistributable

## نصائح مهمة

1. **اختبار شامل**: اختبر النسخة على أجهزة مختلفة قبل التوزيع
2. **حجم الملف**: النسخة قد تكون كبيرة (50-100 MB) بسبب تضمين Flutter engine
3. **التوقيع الرقمي**: للتوزيع الرسمي، قم بتوقيع الملفات رقمياً
4. **التحديثات**: فكر في آلية تحديث تلقائي للمستقبل

## الملفات المرفقة

- `create_windows_package.ps1` - سكريبت إنشاء النسخة
- `CREATE_WINDOWS_PACKAGE_GUIDE.md` - هذا الدليل

## الخطوات التالية

1. ✅ إنشاء النسخة باستخدام السكريبت
2. ✅ اختبار النسخة على جهاز مختلف
3. ✅ إنشاء installer (اختياري)
4. ✅ توزيع النسخة

