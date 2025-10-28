# ✨ ميزة عرض رسائل HTML مع المصادر

## 📋 الملخص

تم إضافة نظام كامل لعرض رسائل المساعد التي تأتي بصيغة **HTML** مع استخراج وعرض **المصادر** بأيقونات FontAwesome جميلة.

---

## 🎯 المشكلة الأصلية

رسائل المساعد تأتي من الخادم بصيغة HTML:

```html
<p>مقرر مقدمة في الإرشاد السياحي يتناول تعريف الإرشاد السياحي...</p>
<p>بشكل عام، يهدف المقرر إلى تأهيل الطلاب...</p>
<div class='sources mt-4'>
  <p class='text-primary'><strong>المصادر</strong></p>
  <button type='button' class='btn btn-sm btn-light' data-toggle='popover' 
          title='مقدمة فى الارشاد السياحي-CH01-U03.pptx شريحة رقم : 2'>
    <i class='fa-duotone fa-light fa-file-ppt text-danger me-2'></i>
  </button>
  <button type='button' class='btn btn-sm btn-light' 
          title='مقدمة فى الارشاد السياحي-CH12-U02.pptx شريحة رقم : 1'>
    <i class='fa-duotone fa-light fa-file-ppt text-danger me-2'></i>
  </button>
</div>
```

---

## ✅ الحل المطبق

### 1. **إضافة حزم HTML** ✅

```yaml
dependencies:
  flutter_html: ^3.0.0  # لعرض HTML في Flutter
  html: ^0.15.6         # لمعالجة وتحليل HTML
```

### 2. **إنشاء `HtmlUtils`** ✅

**الملف**: `lib/core/utils/html_utils.dart`

#### الدوال المتوفرة:

##### `extractSources()` - استخراج المصادر
```dart
List<SourceInfo> sources = HtmlUtils.extractSources(htmlContent);
// يستخرج معلومات المصادر من <div class="sources">
```

**ما تستخرجه**:
- عنوان المصدر من `title` attribute
- نوع الملف من class الأيقونة:
  - `fa-file-ppt` → PowerPoint
  - `fa-file-pdf` → PDF
  - `fa-file-word` → Word
  - `fa-file-excel` → Excel

##### `cleanHtml()` - تنظيف HTML
```dart
String cleanHtml = HtmlUtils.cleanHtml(htmlContent);
// يحذف <div class="sources"> مع الحفاظ على باقي HTML
```

##### `htmlToPlainText()` - تحويل إلى نص عادي
```dart
String plainText = HtmlUtils.htmlToPlainText(htmlContent);
// يحول HTML إلى نص عادي بالكامل
```

##### `htmlToFormattedText()` - تحويل مع التنسيق
```dart
String formattedText = HtmlUtils.htmlToFormattedText(htmlContent);
// يحول HTML إلى نص مع حفظ الفقرات والأسطر
```

##### `containsHtml()` - التحقق من HTML
```dart
bool hasHtml = HtmlUtils.containsHtml(content);
// يتحقق من وجود HTML tags في النص
```

---

### 3. **تحديث `MessageBubble`** ✅

**الملف**: `lib/features/chat/presentation/widgets/message_bubble.dart`

#### ميزات جديدة:

##### أ. دالة `_buildMessageText()`
تعرض المحتوى بناءً على نوعه:

```dart
// رسائل المساعد بـ HTML
if (isAssistant && hasHtml) {
  return Column(
    children: [
      Html(data: cleanedHtml),  // المحتوى
      _buildSources(sources),    // المصادر
    ],
  );
}

// رسائل المستخدم بنص عادي
return Text(content);
```

##### ب. دالة `_buildSources()`
تعرض قسم المصادر بتصميم جميل:

```dart
Container(
  decoration: BoxDecoration(...),
  child: Column(
    children: [
      Row([
        Icon(FontAwesomeIcons.bookOpen),
        Text('المصادر'),
      ]),
      Wrap([
        _buildSourceChip(source1),
        _buildSourceChip(source2),
        ...
      ]),
    ],
  ),
)
```

##### ج. دالة `_buildSourceChip()`
تعرض chip لكل مصدر مع أيقونته:

**الأيقونات حسب نوع الملف**:
- 🟧 PPT → `FontAwesomeIcons.filePowerpoint` (برتقالي)
- 🔴 PDF → `FontAwesomeIcons.filePdf` (أحمر)
- 🔵 Word → `FontAwesomeIcons.fileWord` (أزرق)
- 🟢 Excel → `FontAwesomeIcons.fileExcel` (أخضر)
- ⚫ أخرى → `FontAwesomeIcons.file` (لون التطبيق)

---

## 🎨 كيف يبدو في التطبيق

### رسالة المساعد:

```
┌────────────────────────────────────┐
│ 👤 مساعد كفو                      │
├────────────────────────────────────┤
│                                    │
│ مقرر مقدمة في الإرشاد السياحي    │
│ يتناول تعريف الإرشاد السياحي...   │
│                                    │
│ بشكل عام، يهدف المقرر إلى...      │
│                                    │
│ ┌──────────────────────────────┐   │
│ │ 📖 المصادر                   │   │
│ │                              │   │
│ │ [📄 ملف 1] [📄 ملف 2]       │   │
│ └──────────────────────────────┘   │
│                                    │
│ منذ 5 دقائق                       │
└────────────────────────────────────┘
```

### رسالة المستخدم:

```
                    ┌───────────────────┐
                    │ عم يتحدث المقرر؟ │
                    │                   │
                    │ منذ 5 دقائق      │
                    └───────────────────┘
```

---

## 📦 الملفات المعدلة

1. ✅ `lib/core/utils/html_utils.dart` - **جديد**
2. ✅ `lib/features/chat/presentation/widgets/message_bubble.dart` - **محدث**
3. ✅ `pubspec.yaml` - إضافة `flutter_html` و `html`

---

## 🔄 كيف يعمل

### تدفق البيانات:

```
API Response (HTML)
       ↓
MessageDto.content
       ↓
ChatNotifier (Message)
       ↓
MessageBubble
       ↓
_buildMessageText()
       ├─→ استخراج المصادر (extractSources)
       ├─→ تنظيف HTML (cleanHtml)
       ├─→ عرض HTML (Html widget)
       └─→ عرض المصادر (_buildSources)
```

---

## 🎯 الميزات الإضافية

### 1. معالجة ذكية للمحتوى
- ✅ يتعرف تلقائياً على HTML
- ✅ يعرض HTML للمساعد فقط
- ✅ يحول HTML إلى نص للمستخدم

### 2. استخراج مرن للمصادر
- ✅ يدعم أنواع ملفات متعددة
- ✅ يستخرج العنوان من `title` attribute
- ✅ يحدد النوع من class الأيقونة

### 3. تصميم احترافي
- ✅ أيقونات ملونة حسب نوع الملف
- ✅ chips جميلة للمصادر
- ✅ مساحة منفصلة للمصادر

---

## 🧪 اختبار

### بيانات اختبار حقيقية:

من `test_chat_session.dart`:
```dart
final sessionId = 'd5dfcc59-f2e2-47cc-ac92-ffe9baa96a28';
final session = await api.getSession(sessionId);
// سيعرض رسالتين:
// 1. سؤال المستخدم (نص عادي)
// 2. رد المساعد (HTML + مصادر)
```

---

## ✨ النتيجة النهائية

✅ رسائل المساعد تُعرض بتنسيق HTML جميل
✅ المصادر تُعرض بأيقونات FontAwesome ملونة
✅ تجربة مستخدم احترافية وسلسة
✅ معالجة ذكية لأنواع المحتوى المختلفة

---

## 🚀 الخطوات التالية (اختيارية)

1. إضافة إمكانية النقر على المصادر
2. إضافة معاينة للمصدر عند النقر
3. دعم المزيد من أنواع الملفات
4. إضافة رسوم متحركة للمصادر

---

تم بنجاح! 🎉

