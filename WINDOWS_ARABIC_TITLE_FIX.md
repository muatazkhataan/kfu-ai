# إصلاح مشكلة عرض العنوان العربي في نافذة Windows

## المشكلة
عند بناء تطبيق Flutter لنظام Windows، قد يظهر عنوان النافذة بالحروف اللاتينية بدلاً من الأحرف العربية حتى لو كان العنوان محدداً بالعربية في الكود.

## السبب
المشكلة تحدث بسبب أن مترجم C++ في Visual Studio قد لا يقرأ ملفات المصدر بترميز UTF-8 بشكل افتراضي، مما يؤدي إلى تحويل الأحرف العربية إلى حروف لاتينية أو رموز غير صحيحة.

## الحل
تم إضافة إعداد `/utf-8` إلى خيارات المترجم في ملف `windows/CMakeLists.txt` لضمان قراءة جميع ملفات المصدر بترميز UTF-8.

### التغييرات التي تمت:
1. إضافة `/utf-8` flag إلى دالة `APPLY_STANDARD_SETTINGS` في `windows/CMakeLists.txt`
2. هذا يضمن أن المترجم يقرأ جميع ملفات `.cpp` و `.h` بترميز UTF-8

### الملفات المتأثرة:
- `windows/CMakeLists.txt` - تم إضافة `/utf-8` flag
- `windows/runner/window_config.h` - يحتوي على العنوان العربي: `L"مساعد كفو - KFU AI Assistant"`

## خطوات التحقق من الحل:

1. **تأكد من ترميز الملفات:**
   - تأكد أن ملف `window_config.h` محفوظ بترميز **UTF-8**
   - في Visual Studio Code: افتح الملف → انقر على "UTF-8" في شريط الحالة → اختر "Save with Encoding" → اختر "UTF-8"

2. **أعد بناء المشروع:**
   ```powershell
   flutter clean
   flutter build windows
   ```

3. **اختبر التطبيق:**
   - شغّل ملف `.exe` المبنى
   - تحقق من أن عنوان النافذة يظهر بالعربية: "مساعد كفو - KFU AI Assistant"

## ملاحظات إضافية:

- إذا استمرت المشكلة بعد تطبيق الحل:
  1. تأكد من أن ملف `window_config.h` محفوظ بترميز UTF-8 (بدون BOM)
  2. احذف مجلد `build` وأعد البناء من جديد
  3. تأكد من استخدام Visual Studio 2019 أو أحدث مع دعم C++17

- ملف `Runner.rc` يحتوي بالفعل على `#pragma code_page(65001)` (UTF-8) وهو صحيح

## المراجع:
- [MSVC `/utf-8` compiler option](https://docs.microsoft.com/en-us/cpp/build/reference/utf-8-set-source-and-executable-character-sets-to-utf-8)
- [Flutter Windows Desktop Support](https://docs.flutter.dev/development/platform-integration/desktop)

