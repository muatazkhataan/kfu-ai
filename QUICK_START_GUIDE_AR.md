# 🚀 دليل البدء السريع - تطبيق مساعد كفو

<div dir="rtl">

## ⚡ ابدأ في 3 خطوات فقط!

### 1️⃣ شغّل التطبيق

```bash
cd d:\kfu_ai
flutter run
```

### 2️⃣ سجّل الدخول

```
1. انتظر SplashScreen (15 ثانية) أو اضغط على الشاشة
2. أدخل الرقم الجامعي
3. اضغط "التالي"
4. أدخل كلمة المرور
5. اضغط "دخول"
```

### 3️⃣ استمتع! 🎉

```
✅ ستُحمّل المحادثات الأخيرة تلقائياً
✅ افتح القائمة الجانبية (الأيقونة في الزاوية)
✅ شاهد محادثاتك الأخيرة
✅ حدّث القائمة بزر التحديث
```

---

## 💡 ما يعمل الآن

| الميزة | الحالة |
|--------|--------|
| تسجيل الدخول | ✅ يعمل |
| حفظ Tokens | ✅ آمن |
| المحادثات الأخيرة | ✅ من API |
| تحديث القائمة | ✅ بزر واحد |
| تسجيل الخروج | ✅ كامل |
| معالجة الأخطاء | ✅ ذكية |

---

## 🔧 نصائح سريعة

### ✅ إذا ظهر خطأ "Unauthorized"
- تأكد من صحة الرقم الجامعي وكلمة المرور
- جرّب مرة أخرى

### ✅ إذا ظهر خطأ "No Internet"
- تحقق من اتصالك بالإنترنت
- سيحاول التطبيق إعادة الاتصال تلقائياً

### ✅ إذا لم تظهر المحادثات
- اضغط زر التحديث (⟳)
- تأكد من وجود محادثات في حسابك

---

## 📖 للتفاصيل الكاملة

راجع الوثائق الشاملة:
- `API_README.md` - دليل الاستخدام
- `INTEGRATION_GUIDE.md` - دليل التكامل
- `COMPLETION_SUMMARY.md` - ملخص الإنجاز

---

## 🎯 بدء الكود

### استخدام API مباشرة

```dart
import 'package:kfu_ai/services/api/api_manager.dart';

final api = ApiManager();

// تسجيل الدخول
await api.auth.login(request);

// المحادثات
await api.search.getRecentChats();
```

### مع Riverpod

```dart
import 'package:kfu_ai/features/auth/presentation/providers/auth_provider.dart';

// في widget
Consumer(builder: (context, ref, child) {
  // تسجيل الدخول
  await ref.read(authProvider.notifier).login(
    studentNumber,
    password,
  );
  
  // تحميل المحادثات
  ref.read(chatSessionsProvider.notifier).loadRecentChats();
});
```

---

**جاهز! ابدأ الآن!** 🚀

</div>

