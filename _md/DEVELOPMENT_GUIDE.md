# 📚 دليل التطوير - تطبيق مساعد كفو

## 📖 نظرة عامة

هذا الدليل يوفر خارطة طريق شاملة لتطوير التطبيق في مراحله القادمة.

---

## 📂 ملفات الخطة

### 1. **NEXT_PHASE_PLAN.md** 📋
**الغرض:** خطة عامة شاملة لجميع مراحل التطوير القادمة

**المحتوى:**
- الوضع الحالي للتطبيق
- 6 مراحل تطوير مفصلة
- الجدول الزمني المتوقع (4-5 أسابيع)
- البنية المعمارية المقترحة
- معايير التصميم
- التوصيات والملاحظات

**متى تستخدمه:**
- عند التخطيط للعمل الأسبوعي
- عند تحديد الأولويات
- عند تقدير الوقت الإجمالي
- عند مراجعة التقدم العام

---

### 2. **PHASE_1_SEARCH_CHAT_MANAGEMENT.md** 🔍
**الغرض:** خطة تفصيلية خطوة بخطوة للمرحلة الأولى (البحث وإدارة المحادثات)

**المحتوى:**
- 10 خطوات تنفيذية مفصلة
- أمثلة كود لكل component
- Checklist شامل
- سيناريوهات اختبار
- تقدير الوقت لكل خطوة

**متى تستخدمه:**
- عند البدء بتطوير المرحلة 1
- عند الحاجة لأمثلة كود
- عند اختبار الميزات
- كمرجع أثناء التطوير

---

### 3. **DEVELOPMENT_GUIDE.md** 📚 (هذا الملف)
**الغرض:** دليل شامل لاستخدام ملفات الخطة والتطوير

---

## 🚀 كيفية البدء

### الخطوة 1: فهم الوضع الحالي

1. **اقرأ قسم "الوضع الحالي"** في `NEXT_PHASE_PLAN.md`
2. **راجع الملفات الموجودة** في `lib/features/`
3. **تحقق من API endpoints** المتوفرة
4. **اختبر الميزات الحالية** في التطبيق

### الخطوة 2: اختيار المرحلة

1. **راجع الجدول الزمني** في `NEXT_PHASE_PLAN.md`
2. **حدد المرحلة** حسب الأولوية (موصى بالبدء بالمرحلة 1)
3. **افتح ملف الخطة التفصيلية** للمرحلة (مثل `PHASE_1_SEARCH_CHAT_MANAGEMENT.md`)

### الخطوة 3: التحضير

1. **أنشئ branch جديد في Git:**
   ```bash
   git checkout -b feature/phase-1-search-chat-management
   ```

2. **راجع الـ API endpoints المطلوبة:**
   - `/api/Search/SearchChats`
   - `/api/Session/ArchiveSession`
   - `/api/Session/RestoreSession`
   - `/api/Session/DeleteSession`
   - `/api/Session/UpdateSessionTitle`
   - `/api/Session/MoveSessionToFolder`

3. **تأكد من توفر المتطلبات:**
   - Flutter SDK محدث
   - جميع الـ dependencies محدثة (`flutter pub get`)
   - Access tokens صالحة
   - بيئة اختبار جاهزة

### الخطوة 4: التنفيذ

اتبع الخطوات التفصيلية في ملف المرحلة:

#### مثال: المرحلة 1

```
✅ الخطوة 1: إنشاء Models
   ⏱️ 1-2 ساعة
   📁 lib/features/search/domain/models/
   
✅ الخطوة 2: إنشاء Repository
   ⏱️ 2-3 ساعات
   📁 lib/features/search/data/
   
✅ الخطوة 3: إنشاء Providers
   ⏱️ 2-3 ساعات
   📁 lib/features/search/presentation/providers/
   
... وهكذا
```

### الخطوة 5: الاختبار

1. **اختبر كل ميزة فور تطويرها**
2. **استخدم Checklist الاختبار** في ملف المرحلة
3. **اختبر على أجهزة مختلفة:**
   - Android
   - iOS (إن أمكن)
   - أحجام شاشات مختلفة

### الخطوة 6: المراجعة والتوثيق

1. **راجع الكود:**
   - هل يتبع معايير التصميم المحددة؟
   - هل يلتزم بـ Clean Architecture؟
   - هل التعليقات واضحة؟

2. **وثق التغييرات:**
   - أضف entry في CHANGELOG.md
   - حدّث README.md إذا لزم الأمر
   - أضف تعليقات للكود المعقد

3. **Commit & Push:**
   ```bash
   git add .
   git commit -m "feat: implement phase 1 - search and chat management"
   git push origin feature/phase-1-search-chat-management
   ```

---

## 📋 Workflow الموصى به

### يومياً:

1. **صباحاً:**
   - راجع الـ Checklist
   - حدد المهام لليوم (2-3 خطوات)
   - ابدأ بالخطوة الأسهل

2. **أثناء العمل:**
   - اعمل على خطوة واحدة في المرة
   - اختبر فور الانتهاء
   - Commit للتغييرات الصغيرة

3. **مساءً:**
   - راجع ما تم إنجازه
   - حدّث الـ Checklist
   - خطط ليوم غد

### أسبوعياً:

1. **بداية الأسبوع:**
   - راجع الخطة العامة
   - حدد هدف الأسبوع
   - قدّر الوقت المطلوب

2. **نهاية الأسبوع:**
   - راجع التقدم
   - اختبر شامل للميزات الجديدة
   - وثّق أي تحديات أو ملاحظات

---

## 🎯 أفضل الممارسات

### 1. الكود

```dart
✅ DO:
- استخدم أسماء واضحة ومعبرة
- اتبع Clean Architecture
- أضف تعليقات للكود المعقد
- استخدم const constructors حيث أمكن
- استخدم final للمتغيرات التي لا تتغير

❌ DON'T:
- لا تكرر الكود (DRY principle)
- لا تستخدم magic numbers
- لا تخرج عن معايير التصميم المحددة
- لا تهمل error handling
```

### 2. Git Commits

```bash
✅ Good commit messages:
feat: add search screen with filters
fix: resolve chat deletion error
refactor: improve search provider performance
docs: update development guide

❌ Bad commit messages:
update
fix bug
changes
wip
```

### 3. Testing

```dart
✅ اختبر:
- Happy path (السيناريو الطبيعي)
- Edge cases (الحالات الحدية)
- Error handling (معالجة الأخطاء)
- Performance (الأداء)
- Different screen sizes (أحجام الشاشات)
- RTL/LTR layouts

❌ لا تفترض:
- أن API سيعمل دائماً
- أن المستخدم سيدخل بيانات صحيحة
- أن الشبكة متوفرة دائماً
- أن الجهاز سريع
```

### 4. UI/UX

```dart
✅ DO:
- استخدم AppTheme و AppColorSchemes
- اتبع Material Design 3
- وفر feedback واضح للمستخدم
- استخدم Loading states
- وفر رسائل خطأ واضحة

❌ DON'T:
- لا تغير الألوان بشكل عشوائي
- لا تستخدم أحجام خطوط غير قياسية
- لا تهمل RTL support
- لا تنسى accessibility
```

---

## 🔧 الأدوات المساعدة

### 1. VS Code Extensions (موصى بها)

- Flutter
- Dart
- Dart Data Class Generator
- Flutter Riverpod Snippets
- Error Lens
- GitLens

### 2. الأوامر المفيدة

```bash
# تنظيف المشروع
flutter clean
flutter pub get

# تشغيل التطبيق
flutter run --debug

# تحليل الكود
flutter analyze

# فحص formatting
dart format --set-exit-if-changed .

# إنشاء build
flutter build apk --release
flutter build ios --release
```

### 3. Snippets مفيدة

#### Riverpod Provider
```dart
@riverpod
class MyFeature extends _$MyFeature {
  @override
  MyState build() {
    return MyState();
  }
}
```

#### ConsumerWidget
```dart
class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return Container();
  }
}
```

---

## 📊 تتبع التقدم

### استخدم الـ Checklists

في كل ملف مرحلة، هناك checklist شامل. استخدمه لتتبع التقدم:

```markdown
- [x] إنشاء Models
- [x] إنشاء Repository
- [ ] إنشاء Providers (جاري العمل...)
- [ ] إنشاء Widgets
- [ ] إنشاء Screens
```

### احتفظ بملف PROGRESS.md

```markdown
# تقدم التطوير

## الأسبوع 1 (21-27 أكتوبر)
- [x] المرحلة 1 - الخطوة 1: Models ✅
- [x] المرحلة 1 - الخطوة 2: Repository ✅
- [x] المرحلة 1 - الخطوة 3: Providers ✅
- [ ] المرحلة 1 - الخطوة 4: Widgets (جاري...)

### الملاحظات:
- واجهت مشكلة في highlight text، تم حلها باستخدام RichText
- API البحث أبطأ من المتوقع، أضفت loading state أفضل

### الوقت الفعلي:
- Models: 1.5 ساعة
- Repository: 2.5 ساعة
- Providers: 3 ساعات
```

---

## ❓ استكشاف الأخطاء

### مشكلة: API لا يستجيب

```dart
// تحقق من:
1. Access token صالح؟
2. الـ endpoint صحيح؟
3. الـ parameters صحيحة؟
4. الشبكة متوفرة؟

// أضف logging:
print('[DEBUG] API Request: $endpoint');
print('[DEBUG] Parameters: $params');
print('[DEBUG] Response: $response');
```

### مشكلة: Widget لا يعيد البناء

```dart
// تحقق من:
1. هل تستخدم ConsumerWidget أو Consumer؟
2. هل تستخدم ref.watch وليس ref.read في build؟
3. هل الـ provider يصدر state جديد؟

// أضف debugging:
print('[DEBUG] State changed: $state');
```

### مشكلة: Layout overflow

```dart
// الحلول الشائعة:
1. استخدم Expanded أو Flexible
2. استخدم SingleChildScrollView
3. قلل padding/margin
4. استخدم LayoutBuilder للشاشات الصغيرة
```

---

## 📞 الدعم والمساعدة

### قبل طلب المساعدة:

1. راجع ملفات الخطة مرة أخرى
2. ابحث عن أمثلة مشابهة في الكود الحالي
3. اقرأ الـ error message بعناية
4. جرب الحلول الشائعة

### عند طلب المساعدة:

```markdown
**المشكلة:** وصف واضح للمشكلة
**الخطوات:** ما الذي قمت به؟
**الكود:** الكود المرتبط بالمشكلة
**الخطأ:** رسالة الخطأ الكاملة
**ما جربت:** الحلول التي جربتها
```

---

## 🎉 بعد إكمال كل مرحلة

1. **احتفل بالإنجاز!** 🎊
2. **خذ استراحة قصيرة**
3. **راجع ما تعلمته**
4. **حدث الخطة العامة**
5. **خطط للمرحلة القادمة**

---

## 📚 مراجع مفيدة

### Flutter & Dart
- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io)

### State Management
- [Riverpod Documentation](https://riverpod.dev)
- [Riverpod Examples](https://github.com/rrousselGit/riverpod/tree/master/examples)

### Architecture
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture Example](https://github.com/ResoCoder/flutter-tdd-clean-architecture-course)

---

## 🔄 تحديث هذا الدليل

هذا الدليل حي ويتطور مع المشروع. لا تتردد في:
- إضافة نصائح جديدة تعلمتها
- تحديث الأمثلة
- إضافة حلول للمشاكل الشائعة
- تحسين التوضيحات

---

**📅 آخر تحديث:** 2025-10-21  
**✍️ الإصدار:** 1.0  
**🎯 الحالة:** نشط

---

## 🚀 ابدأ الآن!

1. ✅ افتح `NEXT_PHASE_PLAN.md` واقرأه
2. ✅ افتح `PHASE_1_SEARCH_CHAT_MANAGEMENT.md`
3. ✅ أنشئ branch جديد
4. ✅ ابدأ بالخطوة 1!

**حظاً موفقاً في التطوير! 💪**

