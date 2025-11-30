# حل مشكلة الملف المقفل في Flutter Windows

## المشكلة
```
Error: Flutter failed to write to a file at
"c:\flutter\bin\cache\artifacts\engine\windows-x64\icudtl.dat". 
The file is being used by another program.
```

## الأسباب المحتملة
1. **عمليات Flutter/Dart تعمل في الخلفية**
2. **برنامج مكافحة الفيروسات يحجب الملف**
3. **التطبيق يعمل بالفعل**
4. **ملفات Flutter مفتوحة في برنامج آخر**

## الحلول

### الحل 1: استخدام السكريبت (موصى به) ⭐
```powershell
.\fix_file_locked.ps1
```

هذا السكريبت يقوم بـ:
- إغلاق جميع عمليات Flutter/Dart
- انتظار تحرير الملفات
- محاولة حذف الملف المقفل
- إعادة بناء المشروع

### الحل 2: إغلاق العمليات يدوياً
```powershell
# إغلاق جميع عمليات Flutter/Dart
Get-Process | Where-Object {
    $_.Path -like "*flutter*" -or 
    $_.Path -like "*dart*" -or 
    $_.ProcessName -like "*kfu_ai*"
} | Stop-Process -Force

# حذف الملف المقفل
Remove-Item "C:\flutter\bin\cache\artifacts\engine\windows-x64\icudtl.dat" -Force

# إعادة البناء
flutter build windows --release
```

### الحل 3: تشغيل PowerShell كمسؤول
1. انقر بزر الماوس الأيمن على PowerShell
2. اختر "Run as Administrator"
3. نفذ الأوامر:
```powershell
cd D:\kfu_ai
.\fix_file_locked.ps1
```

### الحل 4: تعطيل مكافحة الفيروسات مؤقتاً
1. افتح إعدادات مكافحة الفيروسات
2. أضف مجلد Flutter إلى الاستثناءات:
   - `C:\flutter\bin\cache\`
   - أو عطل مكافحة الفيروسات مؤقتاً

### الحل 5: إعادة تشغيل الجهاز
إذا استمرت المشكلة، أعد تشغيل الجهاز ثم حاول مرة أخرى.

## التحقق من العمليات النشطة
```powershell
# عرض جميع عمليات Flutter/Dart
Get-Process | Where-Object {
    $_.Path -like "*flutter*" -or 
    $_.Path -like "*dart*"
} | Select-Object ProcessName, Id, Path | Format-Table
```

## ملاحظات مهمة
- تأكد من إغلاق جميع نوافذ Flutter/Dart قبل البناء
- إذا كان التطبيق يعمل، أغلقه أولاً
- قد تحتاج إلى تشغيل PowerShell كمسؤول

## الملفات المتوفرة
- `fix_file_locked.ps1` - سكريبت شامل لحل المشكلة

