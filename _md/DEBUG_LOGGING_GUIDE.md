# 🔍 دليل Debug Logging - تتبع تسجيل الدخول

<div dir="rtl">

## ✅ تم إضافة Logging شامل!

أضفت دوال logging مفصلة في 3 مستويات لتتبع كل خطوة من عملية تسجيل الدخول.

---

## 📊 مستويات Logging

### المستوى 1: LoginScreen (UI Layer) 🖥️

**الملف:** `lib/app/app.dart`

**ما يُسجّل:**
```
╔═══════════════════════════════════════════════
║ 🔐 LoginScreen: بدء عملية تسجيل الدخول
╠═══════════════════════════════════════════════
║ 📝 الرقم الجامعي: 2284896111
║ 📝 طول كلمة المرور: 11 حرف
║ 📝 كلمة المرور: Kfu***
║ ✅ البيانات مكتملة - بدء المصادقة...
╚═══════════════════════════════════════════════

🔄 استدعاء AuthProvider.login()...
```

---

### المستوى 2: AuthProvider (State Layer) 📦

**الملف:** `lib/features/auth/presentation/providers/auth_provider.dart`

**ما يُسجّل:**
```
╔═══════════════════════════════════════════════
║ 🔐 AuthProvider: بدء تسجيل الدخول
╠═══════════════════════════════════════════════
║ 📝 الرقم الجامعي: 2284896111
║ 📝 طول كلمة المرور: 11
╚═══════════════════════════════════════════════

📤 إرسال طلب تسجيل الدخول...

╔═══════════════════════════════════════════════
║ 📨 استلام استجابة من AuthApiService
╠═══════════════════════════════════════════════
║ ✓ Success: true/false
║ 📊 Status Code: 200/400/401/500
║ 💬 Message: ...
║ ❌ Error: ...
║ 🔢 Error Code: ...
║ 📦 Has Data: true/false
║ 👤 User ID: ...
║ 🎫 Token Type: Bearer
║ 📋 Profile: {...}
╚═══════════════════════════════════════════════
```

---

### المستوى 3: AuthApiService (Service Layer) 🔧

**الملف:** `lib/services/api/auth/auth_api_service.dart`

**ما يُسجّل:**
```
[AuthService] 🔐 بدء عملية تسجيل الدخول
[AuthService] 📝 الرقم الجامعي: 2284896111
[AuthService] 📝 طول كلمة المرور: 11 حرف
[AuthService] ✅ البيانات صالحة - إرسال الطلب للخادم...
[AuthService] 🌐 Endpoint: /api/Users/login
[AuthService] 📦 Body: {StudentNumber: ..., Password: ...}
[AuthService] 📥 استلام استجابة من الخادم
[AuthService] 📋 JSON Response: {...}
[AuthService] 📊 نتيجة الطلب: نجاح ✅ / فشل ❌
[AuthService] 📊 Status Code: 200
[AuthService] ✅ تسجيل الدخول نجح!
[AuthService] 👤 User ID: a2012bc4-7c1c-4915-99c7-55a6c0fe8df4
[AuthService] 🎫 Access Token (أول 30 حرف): eyJhbGciOiJIUzI1NiIsInR5cCI6...
[AuthService] 🔄 Refresh Token (أول 20 حرف): o3513ojN6zONfnxQuEK5...
[AuthService] ⏱️ Expires In: 3600 ثانية
[AuthService] 💾 حفظ Tokens في Secure Storage...
[AuthService] ✅ تم حفظ Tokens بنجاح
[AuthService] 🔓 إنشاء جلسة...
[AuthService] ✅ تم إنشاء الجلسة بنجاح
```

---

### المستوى 4: LoggingInterceptor (HTTP Layer) 🌐

**الملف:** `lib/core/api/interceptors/logging_interceptor.dart`

**ما يُسجّل:**
```
╔═══════════════════════════════════════════════
║ ➡️ REQUEST: POST https://kfuai-api.kfu.edu.sa/api/Users/login
╠═══════════════════════════════════════════════
║ 📋 Headers:
║   Content-Type: application/json
║   Accept: */*
║   Authorization: Bearer ***
╠───────────────────────────────────────────────
║ 📦 Body:
║   {StudentNumber: 2284896111, Password: ***}
╠───────────────────────────────────────────────
╚═══════════════════════════════════════════════

╔═══════════════════════════════════════════════
║ ⬅️ RESPONSE: POST /api/Users/login
║ 📊 Status Code: 200 OK
╠═══════════════════════════════════════════════
║ 📦 Data:
║   {AccessToken: ..., RefreshToken: ..., UserId: ...}
╚═══════════════════════════════════════════════
```

---

## 🔍 كيفية قراءة Logs

### في حالة النجاح ✅

ستشاهد:
```
🔐 LoginScreen: بدء عملية تسجيل الدخول
   ↓
🔐 AuthProvider: بدء تسجيل الدخول
   ↓
[AuthService] 🔐 بدء عملية تسجيل الدخول
   ↓
➡️ REQUEST: POST /api/Users/login
   ↓
⬅️ RESPONSE: 200 OK
   ↓
[AuthService] ✅ تسجيل الدخول نجح!
   ↓
✅ AuthProvider: تحديث State
   ↓
📊 LoginScreen: نجاح ✅
   ↓
📥 تحميل المحادثات الأخيرة...
   ↓
🔄 الانتقال إلى ChatScreen...
```

---

### في حالة الفشل ❌

#### سيناريو 1: بيانات خاطئة

```
🔐 LoginScreen: بدء عملية تسجيل الدخول
   ↓
➡️ REQUEST: POST /api/Users/login
   ↓
⬅️ RESPONSE: 400 Bad Request
   ↓
[AuthService ERROR] ❌ فشل تسجيل الدخول
[AuthService ERROR] 📊 Status Code: 400
[AuthService ERROR] 💬 Error: محاولة تسجيل دخول غير صالحة
   ↓
❌ AuthProvider: فشل تسجيل الدخول
   ↓
📊 LoginScreen: فشل ❌
💬 رسالة الخطأ: محاولة تسجيل دخول غير صالحة
```

#### سيناريو 2: لا يوجد إنترنت

```
🔐 LoginScreen: بدء عملية تسجيل الدخول
   ↓
➡️ REQUEST: POST /api/Users/login
   ↓
❌ ERROR: Connection Error
   ↓
[AuthService ERROR] 💥 استثناء أثناء تسجيل الدخول
[AuthService ERROR] ❌ الخطأ: DioException: Connection failed
   ↓
❌ AuthProvider: حدث خطأ
   ↓
💬 رسالة الخطأ: لا يوجد اتصال بالإنترنت
```

#### سيناريو 3: مشكلة في parsing

```
🔐 LoginScreen: بدء عملية تسجيل الدخول
   ↓
⬅️ RESPONSE: 200 OK
   ↓
[AuthService] 📥 استلام استجابة من الخادم
[AuthService] 📋 JSON Response: {...}
   ↓
💥 FormatException: Unexpected format
   ↓
[AuthService ERROR] 💥 استثناء أثناء تسجيل الدخول
[AuthService ERROR] ❌ الخطأ: FormatException...
[AuthService ERROR] 📚 Stack Trace: ...
```

---

## 🛠️ استخدام Logs للتشخيص

### الخطوة 1: شغّل التطبيق

```bash
flutter run
```

### الخطوة 2: راقب Console

ابحث عن:
```
🔐 LoginScreen: بدء عملية تسجيل الدخول
```

### الخطوة 3: تتبع التدفق

تابع الرموز:
- 🔐 - بدء
- ➡️ - طلب HTTP
- ⬅️ - استجابة HTTP
- ✅ - نجاح
- ❌ - فشل
- 💥 - استثناء

### الخطوة 4: حدد المشكلة

| الرمز | المعنى | الإجراء |
|------|--------|---------|
| `❌ بيانات غير صالحة` | Input فارغ أو قصير | تحقق من الإدخال |
| `⬅️ 400` | بيانات خاطئة | تحقق من Username/Password |
| `⬅️ 401` | Unauthorized | تحقق من الصلاحيات |
| `⬅️ 500` | Server Error | انتظر أو راسل الدعم |
| `Connection Error` | لا إنترنت | تحقق من الاتصال |
| `FormatException` | مشكلة parsing | راجع DTOs |

---

## 📝 مثال من Console الفعلي

### عند النجاح:

```
╔═══════════════════════════════════════════════
║ 🔐 LoginScreen: بدء عملية تسجيل الدخول
╠═══════════════════════════════════════════════
║ 📝 الرقم الجامعي: 2284896111
║ 📝 طول كلمة المرور: 11 حرف
║ 📝 كلمة المرور: Kfu***
║ ✅ البيانات مكتملة - بدء المصادقة...
╚═══════════════════════════════════════════════

🔄 استدعاء AuthProvider.login()...

╔═══════════════════════════════════════════════
║ 🔐 AuthProvider: بدء تسجيل الدخول
╠═══════════════════════════════════════════════
║ 📝 الرقم الجامعي: 2284896111
║ 📝 طول كلمة المرور: 11
╚═══════════════════════════════════════════════

📤 إرسال طلب تسجيل الدخول...

[AuthService] 🔐 بدء عملية تسجيل الدخول
[AuthService] 📝 الرقم الجامعي: 2284896111
[AuthService] 📝 طول كلمة المرور: 11 حرف
[AuthService] ✅ البيانات صالحة - إرسال الطلب للخادم...
[AuthService] 🌐 Endpoint: /api/Users/login
[AuthService] 📦 Body: {StudentNumber: 2284896111, Password: Kfu@ai@2025}

╔═══════════════════════════════════════════════
║ ➡️ REQUEST: POST https://kfuai-api.kfu.edu.sa/api/Users/login
╠═══════════════════════════════════════════════
║ 📋 Headers:
║   Content-Type: application/json
║   Accept: */*
╠───────────────────────────────────────────────
║ 📦 Body:
║   {StudentNumber: 2284896111, Password: ***}
╚═══════════════════════════════════════════════

╔═══════════════════════════════════════════════
║ ⬅️ RESPONSE: POST /api/Users/login
║ 📊 Status Code: 200 OK
╠═══════════════════════════════════════════════
║ 📦 Data:
║   {AccessToken: eyJ..., UserId: a2012bc4-...}
╚═══════════════════════════════════════════════

[AuthService] 📥 استلام استجابة من الخادم
[AuthService] 📋 JSON Response: {AccessToken: ..., UserId: ...}
[AuthService] 📊 نتيجة الطلب: نجاح ✅
[AuthService] 📊 Status Code: 200
[AuthService] ✅ تسجيل الدخول نجح!
[AuthService] 👤 User ID: a2012bc4-7c1c-4915-99c7-55a6c0fe8df4
[AuthService] 🎫 Access Token (أول 30 حرف): eyJhbGciOiJIUzI1NiIsInR5cCI6...
[AuthService] 💾 حفظ Tokens في Secure Storage...
[AuthService] ✅ تم حفظ Tokens بنجاح
[AuthService] 🔓 إنشاء جلسة...
[AuthService] ✅ تم إنشاء الجلسة بنجاح

╔═══════════════════════════════════════════════
║ 📨 استلام استجابة من AuthApiService
╠═══════════════════════════════════════════════
║ ✓ Success: true
║ 📊 Status Code: 200
║ 👤 User ID: a2012bc4-7c1c-4915-99c7-55a6c0fe8df4
╚═══════════════════════════════════════════════

✅ تحديث State بحالة Authenticated...

╔═══════════════════════════════════════════════
║ 📊 نتيجة تسجيل الدخول: نجاح ✅
╠═══════════════════════════════════════════════
║ ✅ تم تسجيل الدخول بنجاح!
║ 👤 User ID: a2012bc4-7c1c-4915-99c7-55a6c0fe8df4
╚═══════════════════════════════════════════════

📥 تحميل المحادثات الأخيرة...
🔄 الانتقال إلى ChatScreen...
```

---

### عند الفشل:

```
╔═══════════════════════════════════════════════
║ 🔐 LoginScreen: بدء عملية تسجيل الدخول
╠═══════════════════════════════════════════════
║ 📝 الرقم الجامعي: wronguser
║ 📝 طول كلمة المرور: 8 حرف
╚═══════════════════════════════════════════════

[AuthService] 🔐 بدء عملية تسجيل الدخول
[AuthService] 📝 الرقم الجامعي: wronguser
[AuthService] 📝 طول كلمة المرور: 8 حرف
[AuthService] ✅ البيانات صالحة - إرسال الطلب للخادم...

╔═══════════════════════════════════════════════
║ ➡️ REQUEST: POST /api/Users/login
╚═══════════════════════════════════════════════

╔═══════════════════════════════════════════════
║ ⬅️ RESPONSE: POST /api/Users/login
║ 📊 Status Code: 400 Bad Request
╠═══════════════════════════════════════════════
║ 📦 Data:
║   {Success: false, Error: محاولة تسجيل دخول غير صالحة}
╚═══════════════════════════════════════════════

[AuthService ERROR] ❌ فشل تسجيل الدخول
[AuthService ERROR] 📊 Success: false
[AuthService ERROR] 📊 Status Code: 400
[AuthService ERROR] 💬 Error: محاولة تسجيل دخول غير صالحة
[AuthService ERROR] 🔢 Error Code: INVALID_CREDENTIALS

❌ فشل تسجيل الدخول - تفاصيل الخطأ:
   - Error: محاولة تسجيل دخول غير صالحة
   - Error Code: INVALID_CREDENTIALS
   - Status Code: 400

╔═══════════════════════════════════════════════
║ 📊 نتيجة تسجيل الدخول: فشل ❌
╠═══════════════════════════════════════════════
║ ❌ فشل تسجيل الدخول!
║ 💬 رسالة الخطأ: محاولة تسجيل دخول غير صالحة
╚═══════════════════════════════════════════════
```

---

## 🎯 تشخيص المشاكل الشائعة

### مشكلة 1: "محاولة تسجيل دخول غير صالحة"

**السبب:**
- رقم جامعي خاطئ
- كلمة مرور خاطئة
- الحساب غير موجود

**راقب في Logs:**
```
[AuthService] 📝 الرقم الجامعي: [تحقق من الرقم]
[AuthService] 📝 طول كلمة المرور: [تحقق من الطول]
⬅️ RESPONSE: 400 Bad Request
Error: محاولة تسجيل دخول غير صالحة
```

**الحل:**
- تأكد من الرقم الجامعي صحيح
- تأكد من كلمة المرور صحيحة
- استخدم أيقونة العين 👁️ للتحقق

---

### مشكلة 2: "Connection Error"

**السبب:**
- لا يوجد اتصال بالإنترنت
- الخادم غير متاح
- Firewall يمنع الاتصال

**راقب في Logs:**
```
➡️ REQUEST: POST /api/Users/login
❌ ERROR: DioException: Connection failed
💥 استثناء أثناء تسجيل الدخول
```

**الحل:**
- تحقق من الإنترنت
- جرب VPN إذا محظور
- انتظر وأعد المحاولة

---

### مشكلة 3: "FormatException"

**السبب:**
- استجابة API بشكل غير متوقع
- مشكلة في DTOs

**راقب في Logs:**
```
⬅️ RESPONSE: 200 OK
📋 JSON Response: {...}
💥 FormatException: Invalid format
```

**الحل:**
- انسخ JSON Response من Logs
- قارن مع DTOs
- حدّث DTOs إذا لزم

---

## 🔧 تفعيل/تعطيل Logging

### لتعطيل Logging في Production:

في `lib/core/api/config/api_config.dart`:
```dart
static const bool enableLogging = false;  // غيّر لـ false
```

### للتحكم في مستوى Logging:

في `lib/core/api/interceptors/logging_interceptor.dart`:
```dart
LoggingInterceptor(
  logRequests: true,   // Requests
  logResponses: true,  // Responses
  logErrors: true,     // Errors
)
```

---

## 🚀 جرب الآن

```bash
flutter run
```

**في Console، راقب:**
```
🔐 بدء تسجيل الدخول
↓
[كل خطوة مسجلة بالتفصيل]
↓
✅ نجاح أو ❌ فشل مع السبب
```

---

## 📞 إذا واجهت مشكلة

### 1. انسخ Logs الكاملة من Console

### 2. ابحث عن:
- ❌ ERROR
- 💥 استثناء
- ⬅️ RESPONSE مع Status Code

### 3. راجع:
- الرقم الجامعي في Logs
- Status Code
- رسالة الخطأ

### 4. قارن مع السيناريوهات أعلاه

---

**الآن Console سيخبرك بالضبط ما المشكلة!** 🔍

</div>

