# 📋 خطة تطوير المرحلة القادمة - تطبيق مساعد كفو

## 📊 الوضع الحالي

### ✅ تم إنجازه:
1. ✅ نظام API كامل مع OOP و SOLID principles
2. ✅ تسجيل الدخول مع خاصية "تذكرني"
3. ✅ شاشة المحادثة الرئيسية
4. ✅ القائمة الجانبية مع المحادثات الأخيرة
5. ✅ عرض HTML في الرسائل مع المصادر
6. ✅ دعم RTL/LTR
7. ✅ إرسال واستقبال الرسائل
8. ✅ فتح المحادثات القديمة

### 🚧 ملفات موجودة لكن غير مكتملة:
- `lib/features/settings/presentation/screens/settings_screen.dart`
- `lib/features/help/presentation/screens/help_screen.dart`
- `lib/features/feedback/presentation/screens/feedback_screen.dart`
- `lib/features/chat_history/presentation/screens/chat_history_screen.dart`

---

## 🎯 المرحلة القادمة: تطوير الميزات الأساسية

### **المرحلة 1: البحث وإدارة المحادثات** (الأولوية: عالية جداً 🔴)

#### 1.1 البحث في المحادثات
- [ ] إنشاء `ChatSearchScreen` كاملة
- [ ] ربط زر البحث في القائمة الجانبية
- [ ] تنفيذ البحث باستخدام API: `/api/Search/SearchChats`
- [ ] عرض نتائج البحث مع highlight للكلمات المفتاحية
- [ ] فلترة النتائج (حسب المجلد، التاريخ، النوع)
- [ ] حفظ تاريخ البحث الأخير

**📁 الملفات:**
```
lib/features/search/
  ├── data/
  │   └── search_repository.dart
  ├── domain/
  │   └── models/
  │       ├── search_result.dart
  │       └── search_filter.dart
  ├── presentation/
      ├── providers/
      │   └── search_provider.dart
      ├── screens/
      │   └── search_screen.dart
      └── widgets/
          ├── search_bar.dart
          ├── search_results_list.dart
          └── search_filter_sheet.dart
```

**⏱️ الوقت المتوقع:** 2-3 أيام

---

#### 1.2 إدارة المحادثات المتقدمة
- [ ] أرشفة المحادثة (`/api/Session/ArchiveSession`)
- [ ] استعادة المحادثة من الأرشيف (`/api/Session/RestoreSession`)
- [ ] حذف المحادثة (`/api/Session/DeleteSession`)
- [ ] نقل المحادثة إلى مجلد (`/api/Session/MoveSessionToFolder`)
- [ ] تعديل عنوان المحادثة (`/api/Session/UpdateSessionTitle`)
- [ ] قائمة خيارات المحادثة (long press)
- [ ] تأكيد الحذف (dialog)
- [ ] إشعارات النجاح/الفشل

**📁 الملفات:**
```
lib/features/chat/presentation/
  └── widgets/
      ├── chat_options_menu.dart
      ├── delete_confirmation_dialog.dart
      └── move_to_folder_sheet.dart
```

**⏱️ الوقت المتوقع:** 2 يوم

---

### **المرحلة 2: إدارة المجلدات** (الأولوية: عالية 🟠)

#### 2.1 عمليات المجلدات
- [ ] إنشاء مجلد جديد (`/api/Folder/CreateFolder`)
- [ ] تعديل اسم المجلد (`/api/Folder/UpdateFolderName`)
- [ ] حذف المجلد (`/api/Folder/DeleteFolder`)
- [ ] إعادة ترتيب المجلدات (`/api/Folder/OrderFolders`)
- [ ] اختيار أيقونة ولون للمجلد
- [ ] عرض عدد المحادثات في كل مجلد

**📁 الملفات:**
```
lib/features/folders/presentation/
  ├── screens/
  │   └── folder_management_screen.dart
  ├── widgets/
  │   ├── create_folder_dialog.dart
  │   ├── edit_folder_dialog.dart
  │   ├── folder_icon_picker.dart
  │   └── folder_color_picker.dart
  └── providers/
      └── folder_management_provider.dart
```

**⏱️ الوقت المتوقع:** 2-3 أيام

---

### **المرحلة 3: شاشة الإعدادات الكاملة** (الأولوية: متوسطة 🟡)

#### 3.1 الإعدادات العامة
- [ ] تغيير اللغة (العربية/الإنجليزية)
- [ ] تبديل الثيم (فاتح/داكن)
- [ ] حجم الخط
- [ ] الإشعارات (تفعيل/تعطيل)

#### 3.2 إعدادات الحساب
- [ ] عرض معلومات المستخدم
- [ ] تحديث الملف الشخصي (`/api/User/UpdateProfile`)
- [ ] تغيير كلمة المرور (`/api/Auth/ChangePassword`)
- [ ] تسجيل الخروج من جميع الأجهزة

#### 3.3 إعدادات المحادثة
- [ ] حفظ المحادثات تلقائياً
- [ ] عرض الطوابع الزمنية
- [ ] حجم الخط في المحادثات
- [ ] تفعيل/تعطيل الأصوات

**📁 الملفات:**
```
lib/features/settings/
  ├── data/
  │   └── settings_repository.dart
  ├── domain/
  │   └── models/
  │       └── user_settings.dart
  ├── presentation/
      ├── providers/
      │   └── settings_provider.dart
      ├── screens/
      │   ├── settings_screen.dart (تحديث)
      │   ├── profile_settings_screen.dart
      │   ├── appearance_settings_screen.dart
      │   └── chat_settings_screen.dart
      └── widgets/
          ├── settings_section.dart
          ├── settings_tile.dart
          └── change_password_dialog.dart
```

**⏱️ الوقت المتوقع:** 3-4 أيام

---

### **المرحلة 4: شاشة المساعدة والملاحظات** (الأولوية: متوسطة 🟡)

#### 4.1 شاشة المساعدة
- [ ] أقسام المساعدة (كيفية الاستخدام، الأسئلة الشائعة)
- [ ] شرح الميزات بالصور
- [ ] دروس تفاعلية (Tutorials)
- [ ] شروط الاستخدام وسياسة الخصوصية
- [ ] معلومات التطبيق (رقم الإصدار، الترخيص)

**📁 الملفات:**
```
lib/features/help/
  ├── data/
  │   └── help_data.dart (موجود - تحديث)
  ├── domain/
  │   └── models/
  │       ├── help_section.dart (موجود - تحديث)
  │       └── faq_item.dart
  ├── presentation/
      ├── screens/
      │   ├── help_screen.dart (تحديث)
      │   ├── tutorial_screen.dart
      │   └── terms_screen.dart
      └── widgets/
          ├── help_content.dart (موجود - تحديث)
          ├── faq_item_widget.dart
          └── tutorial_step_widget.dart
```

**⏱️ الوقت المتوقع:** 2-3 أيام

---

#### 4.2 شاشة الملاحظات
- [ ] نموذج إرسال ملاحظات
- [ ] اختيار نوع الملاحظة (اقتراح، مشكلة، شكوى)
- [ ] إرفاق صور (اختياري)
- [ ] تقييم التطبيق (نجوم)
- [ ] ربط مع API الملاحظات

**📁 الملفات:**
```
lib/features/feedback/
  ├── data/
  │   └── feedback_repository.dart
  ├── domain/
  │   └── models/
  │       ├── feedback_type.dart
  │       └── feedback_model.dart
  ├── presentation/
      ├── providers/
      │   └── feedback_provider.dart
      ├── screens/
      │   └── feedback_screen.dart (تحديث)
      └── widgets/
          ├── feedback_form.dart
          ├── rating_widget.dart
          └── image_picker_widget.dart
```

**⏱️ الوقت المتوقع:** 2 يوم

---

### **المرحلة 5: تحسينات UX/UI** (الأولوية: متوسطة 🟡)

#### 5.1 الرسوم المتحركة والتأثيرات
- [ ] انتقالات سلسة بين الشاشات
- [ ] Hero animations للصور والأيقونات
- [ ] Loading skeletons بدلاً من spinners
- [ ] Shimmer effect للتحميل
- [ ] Swipe gestures للمحادثات

#### 5.2 تحسينات الأداء
- [ ] Lazy loading للمحادثات القديمة
- [ ] Caching للصور والبيانات
- [ ] تحسين استهلاك الذاكرة
- [ ] تحسين وقت الاستجابة

#### 5.3 Accessibility
- [ ] Screen reader support
- [ ] حجم خط قابل للتعديل
- [ ] Contrast ratio مناسب
- [ ] Keyboard navigation

**⏱️ الوقت المتوقع:** 3-4 أيام

---

### **المرحلة 6: الميزات المتقدمة** (الأولوية: منخفضة 🟢)

#### 6.1 مرفقات الملفات
- [ ] إرفاق صور في المحادثة
- [ ] إرفاق ملفات (PDF, DOCX)
- [ ] معاينة الملفات
- [ ] تحميل وحفظ المرفقات

#### 6.2 التصدير والمشاركة
- [ ] تصدير المحادثة كـ PDF
- [ ] تصدير المحادثة كـ TXT
- [ ] مشاركة المحادثة
- [ ] نسخ الرسائل

#### 6.3 الإحصائيات
- [ ] عدد المحادثات الإجمالي
- [ ] عدد الرسائل
- [ ] الوقت المستخدم
- [ ] رسوم بيانية للنشاط

**⏱️ الوقت المتوقع:** 4-5 أيام

---

## 📅 الجدول الزمني المقترح

| المرحلة | الوقت المتوقع | الأولوية |
|---------|---------------|----------|
| 1. البحث وإدارة المحادثات | 4-5 أيام | 🔴 عالية جداً |
| 2. إدارة المجلدات | 2-3 أيام | 🟠 عالية |
| 3. شاشة الإعدادات | 3-4 أيام | 🟡 متوسطة |
| 4. المساعدة والملاحظات | 4-5 أيام | 🟡 متوسطة |
| 5. تحسينات UX/UI | 3-4 أيام | 🟡 متوسطة |
| 6. الميزات المتقدمة | 4-5 أيام | 🟢 منخفضة |

**⏱️ الوقت الإجمالي المتوقع:** 20-26 يوم عمل (~4-5 أسابيع)

---

## 🏗️ البنية المعمارية المقترحة

### 1. استمرار نهج Clean Architecture
```
lib/features/<feature>/
  ├── data/
  │   ├── repositories/
  │   └── data_sources/
  ├── domain/
  │   ├── models/
  │   ├── repositories/
  │   └── use_cases/
  └── presentation/
      ├── providers/
      ├── screens/
      └── widgets/
```

### 2. State Management
- استمرار استخدام **Riverpod** لإدارة الحالة
- إضافة **StateNotifier** للحالات المعقدة
- استخدام **FutureProvider** للعمليات الغير متزامنة

### 3. API Integration
- استخدام نفس `ApiManager` الموجود
- إضافة خدمات جديدة في `lib/services/api/`

---

## 🎨 معايير التصميم

### 1. الالتزام بـ Material Design 3
- استخدام `AppTheme` و `AppColorSchemes` الموجودة
- الالتزام بـ Swiss minimal design
- عدم الخروج عن color palette المحددة

### 2. التناسق
- استخدام نفس الـ widgets المشتركة
- الالتزام بـ `AppTokens` للمسافات والأحجام
- استخدام `AppIcons` للأيقونات

### 3. Responsive Design
- دعم أحجام شاشات مختلفة
- تصميم متجاوب للتابلت
- دعم landscape mode

---

## ✅ Checklist قبل بدء كل مرحلة

- [ ] مراجعة API endpoints المطلوبة
- [ ] تحديد الـ models والـ DTOs
- [ ] إنشاء الـ repository والـ providers
- [ ] تصميم الـ UI mockups
- [ ] كتابة الـ widgets الأساسية
- [ ] اختبار الـ API integration
- [ ] اختبار الـ UI على أجهزة مختلفة
- [ ] مراجعة الكود وتحسينه
- [ ] توثيق الميزة الجديدة

---

## 🚀 التوصيات

### 1. الأولوية للميزات الأساسية
- ابدأ بالبحث وإدارة المحادثات (المرحلة 1)
- ثم إدارة المجلدات (المرحلة 2)
- ثم الإعدادات (المرحلة 3)

### 2. التطوير التدريجي
- أكمل كل مرحلة قبل الانتقال للتالية
- اختبر كل ميزة فور تطويرها
- احتفظ بنسخة احتياطية قبل كل تحديث كبير

### 3. التوثيق
- وثّق كل API endpoint مستخدم
- أضف تعليقات واضحة في الكود
- احتفظ بملف CHANGELOG.md

---

## 📝 ملاحظات

1. **API Documentation**: تأكد من توفر documentation كامل لجميع الـ endpoints
2. **Error Handling**: احرص على معالجة جميع الأخطاء المحتملة
3. **User Feedback**: أضف رسائل واضحة للمستخدم في كل عملية
4. **Performance**: راقب الأداء خاصة في قوائم المحادثات الطويلة
5. **Security**: احرص على تأمين البيانات الحساسة (كلمات المرور، tokens)

---

## 🎯 الهدف النهائي

تطبيق **مساعد كفو** متكامل وعملي يوفر:
- ✅ تجربة مستخدم سلسة ومريحة
- ✅ أداء عالي وسريع
- ✅ تصميم أنيق واحترافي
- ✅ دعم كامل للغة العربية والإنجليزية
- ✅ جميع الميزات الأساسية للمحادثة والإدارة

---

**📌 ملاحظة:** هذه الخطة قابلة للتعديل حسب الأولويات والمتطلبات الجديدة.

**📅 تاريخ الإنشاء:** 2025-10-21
**✍️ الإصدار:** 1.0

