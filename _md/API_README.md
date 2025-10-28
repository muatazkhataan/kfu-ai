# 📱 خدمة API - تطبيق مساعد كفو

<div dir="rtl">

## 📋 جدول المحتويات

1. [نظرة عامة](#نظرة-عامة)
2. [التثبيت والإعداد](#التثبيت-والإعداد)
3. [البنية المعمارية](#البنية-المعمارية)
4. [الاستخدام السريع](#الاستخدام-السريع)
5. [التوثيق التفصيلي](#التوثيق-التفصيلي)
6. [أمثلة الكود](#أمثلة-الكود)
7. [معالجة الأخطاء](#معالجة-الأخطاء)
8. [الأمان](#الأمان)
9. [الأسئلة الشائعة](#الأسئلة-الشائعة)

---

## 🎯 نظرة عامة

تم تطوير خدمة API شاملة لتطبيق مساعد كفو باستخدام:
- **منهجية OOP**: برمجة شيئية كاملة
- **مبادئ SOLID**: تطبيق شامل
- **Clean Architecture**: فصل واضح بين الطبقات
- **Type Safety**: استخدام Generic Types
- **Security First**: تخزين آمن للـ Tokens

### ✨ المميزات الرئيسية

✅ **تسجيل دخول آمن** مع Token Management  
✅ **تجديد تلقائي** للـ Access Token  
✅ **إدارة المحادثات** الكاملة  
✅ **إدارة المجلدات** والتنظيم  
✅ **بحث متقدم** في المحادثات  
✅ **معالجة أخطاء** ذكية  
✅ **إعادة محاولة** تلقائية  
✅ **تسجيل** شامل للطلبات  

---

## 🚀 التثبيت والإعداد

### 1. المتطلبات

```yaml
# pubspec.yaml
dependencies:
  dio: ^5.9.0
  flutter_secure_storage: ^9.2.4
  flutter_riverpod: ^2.4.9
```

### 2. التثبيت

```bash
flutter pub add dio flutter_secure_storage
```

### 3. الإعداد الأولي

لا حاجة لإعداد إضافي! البنية جاهزة للاستخدام فوراً:

```dart
import 'package:kfu_ai/services/api/api_manager.dart';

final apiManager = ApiManager();
```

---

## 🏗️ البنية المعمارية

### الطبقات الرئيسية

```
┌─────────────────────────────────────┐
│         API Manager                 │  ← نقطة الدخول الوحيدة
│        (Singleton)                  │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────┐  ┌──────────┐       │
│  │   Auth   │  │   Chat   │       │
│  │ Service  │  │ Service  │       │
│  └──────────┘  └──────────┘       │
│                                     │
│  ┌──────────┐  ┌──────────┐       │
│  │  Folder  │  │  Search  │       │
│  │ Service  │  │ Service  │       │
│  └──────────┘  └──────────┘       │
│                                     │
├─────────────────────────────────────┤
│          API Client                 │  ← HTTP Client
│           (Dio)                     │
├─────────────────────────────────────┤
│                                     │
│  ┌────────────────────────────┐   │
│  │     Interceptors           │   │
│  │  • Auth Interceptor        │   │
│  │  • Logging Interceptor     │   │
│  │  • Retry Interceptor       │   │
│  └────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│        Core Components              │
│  • ApiResponse<T>                   │
│  • ApiRequest                       │
│  • Exceptions Hierarchy             │
│  • Config & Endpoints               │
└─────────────────────────────────────┘
```

### المكونات الأساسية

#### 1. **ApiManager** - المدير الرئيسي
- Singleton Pattern
- نقطة دخول موحدة لجميع الخدمات
- إدارة دورة حياة الخدمات

#### 2. **Services** - طبقة الخدمات
- **AuthService**: المصادقة والجلسات
- **ChatService**: إدارة المحادثات
- **FolderService**: إدارة المجلدات
- **SearchService**: البحث

#### 3. **ApiClient** - عميل HTTP
- بناء على Dio
- دعم Interceptors
- معالجة Responses موحدة

#### 4. **Interceptors** - المعترضات
- **Auth**: إضافة Token + تجديد تلقائي
- **Logging**: تسجيل الطلبات
- **Retry**: إعادة المحاولة

---

## ⚡ الاستخدام السريع

### مثال بسيط: تسجيل الدخول وإرسال رسالة

```dart
import 'package:kfu_ai/services/api/api_manager.dart';
import 'package:kfu_ai/services/api/auth/models/login_request.dart';
import 'package:kfu_ai/services/api/chat/models/send_message_request.dart';

void main() async {
  final api = ApiManager();
  
  // 1. تسجيل الدخول
  final loginResponse = await api.auth.login(
    LoginRequest(
      studentNumber: '123456',
      password: 'password',
    ),
  );
  
  if (loginResponse.success) {
    print('✅ تم تسجيل الدخول!');
    
    // 2. إرسال رسالة
    final messageResponse = await api.chat.sendMessage(
      SendMessageRequest(
        sessionId: 'session_123',
        content: 'مرحباً!',
      ),
    );
    
    if (messageResponse.success) {
      print('✅ تم إرسال الرسالة: ${messageResponse.data!.content}');
    }
  }
}
```

---

## 📚 التوثيق التفصيلي

### 🔐 Auth Service

#### تسجيل الدخول

```dart
final response = await ApiManager().auth.login(
  LoginRequest(
    studentNumber: 'رقمك الجامعي',
    password: 'كلمة المرور',
  ),
);

if (response.success && response.data != null) {
  final userId = response.data!.userId;
  final accessToken = response.data!.accessToken;
  // يتم حفظ Tokens تلقائياً
}
```

#### التحقق من الجلسة

```dart
// التحقق من تسجيل الدخول
if (ApiManager().isAuthenticated) {
  print('المستخدم مسجل الدخول');
}

// التحقق من صلاحية الجلسة
final isValid = await ApiManager().isSessionValid();
if (!isValid) {
  // إعادة توجيه لشاشة تسجيل الدخول
}
```

#### تسجيل الخروج

```dart
await ApiManager().logout();
// يتم مسح Tokens والجلسة تلقائياً
```

---

### 💬 Chat Service

#### إنشاء جلسة جديدة

```dart
final response = await ApiManager().chat.createSession(
  CreateSessionRequest(title: 'عنوان الجلسة'),
);

if (response.success) {
  final sessionId = response.data!.sessionId;
}
```

#### إرسال رسالة

```dart
final response = await ApiManager().chat.sendMessage(
  SendMessageRequest(
    sessionId: 'session_id',
    content: 'محتوى الرسالة',
  ),
);
```

#### الحصول على جميع الجلسات

```dart
final response = await ApiManager().chat.getUserSessions();

if (response.success) {
  for (var session in response.data!) {
    print('${session.title}: ${session.messageCount} رسالة');
  }
}
```

#### أرشفة/حذف/استعادة

```dart
// أرشفة
await ApiManager().chat.archiveSession(sessionId);

// حذف
await ApiManager().chat.deleteSession(sessionId);

// استعادة
await ApiManager().chat.restoreSession(sessionId);
```

---

### 📁 Folder Service

#### الحصول على جميع المجلدات

```dart
final response = await ApiManager().folder.getAllFolders();

if (response.success) {
  for (var folder in response.data!) {
    print('${folder.name}: ${folder.chatCount} محادثة');
  }
}
```

#### إنشاء مجلد

```dart
final response = await ApiManager().folder.createFolder(
  CreateFolderRequest(
    name: 'اسم المجلد',
    icon: 'اسم الأيقونة',
  ),
);
```

#### تحديث/حذف مجلد

```dart
// تحديث الاسم
await ApiManager().folder.updateFolderName(
  UpdateFolderRequest(
    folderId: 'folder_id',
    name: 'الاسم الجديد',
  ),
);

// حذف
await ApiManager().folder.deleteFolder('folder_id');
```

---

### 🔍 Search Service

#### البحث في المحادثات

```dart
final response = await ApiManager().search.searchChats(
  SearchChatsRequest(query: 'كلمة البحث'),
);

if (response.success) {
  print('عدد النتائج: ${response.data!.length}');
}
```

#### المحادثات الأخيرة

```dart
final response = await ApiManager().search.getRecentChats();
```

---

## 🛡️ معالجة الأخطاء

### نموذج الاستجابة

كل استجابة من API تتبع نفس النمط:

```dart
class ApiResponse<T> {
  final bool success;          // هل نجح الطلب؟
  final T? data;               // البيانات المرجعة
  final String? message;       // رسالة النجاح
  final String? error;         // رسالة الخطأ
  final String? errorCode;     // كود الخطأ
  final int? statusCode;       // كود حالة HTTP
}
```

### معالجة الأخطاء

```dart
final response = await ApiManager().auth.login(request);

if (response.success) {
  // نجح الطلب
  final data = response.data!;
  // استخدم البيانات
} else {
  // فشل الطلب
  print('الخطأ: ${response.error}');
  print('كود الخطأ: ${response.errorCode}');
  print('كود الحالة: ${response.statusCode}');
  
  // معالجة حسب كود الخطأ
  switch (response.errorCode) {
    case 'UNAUTHORIZED':
      // إعادة توجيه لتسجيل الدخول
      break;
    case 'NETWORK_ERROR':
      // عرض رسالة لا يوجد إنترنت
      break;
    default:
      // عرض رسالة خطأ عامة
      break;
  }
}
```

### أنواع الأخطاء

```dart
// أخطاء المصادقة
'UNAUTHORIZED'         // انتهت صلاحية الجلسة
'INVALID_CREDENTIALS'  // بيانات اعتماد خاطئة
'TOKEN_EXPIRED'        // انتهت صلاحية Token

// أخطاء الشبكة
'NO_INTERNET'          // لا يوجد اتصال
'TIMEOUT'              // انتهت مهلة الاتصال
'CONNECTION_FAILED'    // فشل الاتصال

// أخطاء البيانات
'INVALID_INPUT'        // بيانات إدخال غير صالحة
'NOT_FOUND'            // المورد غير موجود
'CONFLICT'             // تعارض في البيانات

// أخطاء الخادم
'SERVER_ERROR'         // خطأ في الخادم
```

---

## 🔒 الأمان

### 1. Token Management

- **تخزين آمن**: استخدام Flutter Secure Storage
- **Encrypted**: تشفير على Android و iOS
- **Auto Refresh**: تجديد تلقائي للـ Token
- **No Logs**: لا يتم تسجيل Tokens

### 2. Best Practices

```dart
// ✅ جيد - استخدام ApiManager
final api = ApiManager();

// ❌ سيء - لا تخزن Tokens يدوياً
// String token = response.data.accessToken;

// ✅ جيد - التحقق من الجلسة
if (await api.isSessionValid()) {
  // المتابعة
}

// ❌ سيء - افتراض أن المستخدم مسجل
// api.chat.sendMessage(...);
```

---

## ❓ الأسئلة الشائعة

### س: كيف أتحقق من تسجيل الدخول؟

```dart
if (ApiManager().isAuthenticated) {
  // المستخدم مسجل الدخول
}
```

### س: ماذا يحدث عند انتهاء صلاحية Token؟

يتم تجديد Token تلقائياً! `AuthInterceptor` يتعامل مع ذلك بشكل شفاف.

### س: كيف أتعامل مع أخطاء الشبكة؟

```dart
final response = await api.chat.sendMessage(request);

if (!response.success) {
  if (response.errorCode == 'NO_INTERNET') {
    // عرض رسالة لا يوجد إنترنت
  }
}
```

### س: هل يمكنني إعادة استخدام ApiManager؟

نعم! هو Singleton - استخدم `ApiManager()` في أي مكان.

### س: كيف أختبر API؟

راجع ملف `example/api_usage_example.dart` للأمثلة الكاملة.

---

## 📖 مراجع إضافية

- **الخطة الكاملة**: `API_IMPLEMENTATION_PLAN.md`
- **ملخص التنفيذ**: `API_IMPLEMENTATION_SUMMARY.md`
- **أمثلة الكود**: `example/api_usage_example.dart`

---

## 🎉 جاهز للاستخدام!

البنية كاملة وجاهزة. ابدأ الآن:

```dart
void main() async {
  final api = ApiManager();
  
  // ابدأ البرمجة! 🚀
}
```

---

**تاريخ الإنشاء**: 08 أكتوبر 2025  
**الإصدار**: 1.0  
**الحالة**: مكتمل ✅

</div>

