# 🔄 دليل تحديث DTOs بناءً على الاستجابة الفعلية

<div dir="rtl">

## 🎯 الهدف

هذا الدليل يشرح كيفية تحديث Data Transfer Objects (DTOs) بعد معرفة شكل الاستجابة الفعلي من API.

---

## 🧪 الخطوة 1: اختبار API

### استخدم السكريبت المجهز

```bash
# 1. افتح الملف
# test_api_with_real_data.dart

# 2. ضع بياناتك الحقيقية
const studentNumber = '123456';  # رقمك الجامعي
const password = 'your_password';  # كلمة مرورك

# 3. شغّل الاختبار
dart test_api_with_real_data.dart

# 4. راقب النتائج
```

---

## 📋 الخطوة 2: تحليل الاستجابة

### سيناريو 1: استجابة Login

#### إذا كانت:
```json
{
  "UserId": "12345",
  "AccessToken": "eyJhbGc...",
  "RefreshToken": "refresh123...",
  "ExpiresIn": 3600,
  "TokenType": "Bearer"
}
```

**الحالة:** ✅ DTOs الحالية ستعمل بشكل مثالي!

---

#### إذا كانت:
```json
{
  "Success": true,
  "Data": {
    "userId": "12345",
    "token": "eyJhbGc...",
    "refreshToken": "refresh123...",
    "expiresIn": 3600
  }
}
```

**التحديث المطلوب:**

```dart
// lib/services/api/auth/models/login_response.dart

factory LoginResponse.fromJson(Map<String, dynamic> json) {
  // دعم كلا الشكلين
  final data = json['Data'] ?? json;
  
  return LoginResponse(
    userId: data['userId'] ?? data['UserId'] ?? '',
    accessToken: data['token'] ?? data['AccessToken'] ?? data['accessToken'] ?? '',
    refreshToken: data['refreshToken'] ?? data['RefreshToken'] ?? '',
    expiresIn: data['expiresIn'] ?? data['ExpiresIn'] ?? 3600,
    tokenType: data['tokenType'] ?? data['TokenType'] ?? 'Bearer',
  );
}
```

---

### سيناريو 2: استجابة GetUserSessions

#### إذا كانت:
```json
[
  {
    "SessionId": "sess_123",
    "Title": "محادثة 1",
    "CreatedAt": "2025-10-08T10:00:00Z",
    "UpdatedAt": "2025-10-08T11:00:00Z",
    "MessageCount": 5
  }
]
```

**الحالة:** ✅ DTOs الحالية ستعمل!

---

#### إذا كانت:
```json
{
  "Success": true,
  "Data": {
    "Sessions": [...]
  }
}
```

**التحديث المطلوب:**

```dart
// في ChatApiService.getUserSessions()

final response = await _apiClient.get<List<SessionDto>>(
  endpoint: ApiEndpoints.getUserSessions,
  fromJson: (json) {
    // دعم wrapper
    if (json is Map && json['Data'] != null) {
      final data = json['Data'];
      if (data is Map && data['Sessions'] != null) {
        return (data['Sessions'] as List)
            .map((item) => SessionDto.fromJson(item))
            .toList();
      }
    }
    
    // دعم array مباشر
    if (json is List) {
      return json.map((item) => SessionDto.fromJson(item)).toList();
    }
    
    return [];
  },
);
```

---

## 🔧 الخطوة 3: تحديث DTOs

### قائمة DTOs التي قد تحتاج تحديث

| DTO | الملف | الاحتمال |
|-----|-------|----------|
| `LoginResponse` | `lib/services/api/auth/models/login_response.dart` | متوسط |
| `SessionDto` | `lib/services/api/chat/models/session_dto.dart` | متوسط |
| `MessageDto` | `lib/services/api/chat/models/message_dto.dart` | متوسط |
| `FolderDto` | `lib/services/api/folder/models/folder_dto.dart` | متوسط |
| `RefreshTokenResponse` | `lib/services/api/auth/models/refresh_token_response.dart` | منخفض |

---

## 📝 نموذج التحديث

### قبل:
```dart
factory SessionDto.fromJson(Map<String, dynamic> json) {
  return SessionDto(
    sessionId: json['SessionId'] ?? '',
    title: json['Title'] ?? '',
  );
}
```

### بعد (مع دعم formats متعددة):
```dart
factory SessionDto.fromJson(Map<String, dynamic> json) {
  return SessionDto(
    // دعم PascalCase و camelCase
    sessionId: json['SessionId'] ?? json['sessionId'] ?? json['id'] ?? '',
    title: json['Title'] ?? json['title'] ?? json['name'] ?? '',
    
    // دعم تواريخ مختلفة
    createdAt: _parseDate(json['CreatedAt'] ?? json['createdAt'] ?? json['created_at']),
  );
}

static DateTime _parseDate(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is String) return DateTime.parse(value);
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.now();
}
```

---

## ✅ الخطوة 4: الاختبار

### بعد التحديث:

```bash
# 1. شغّل التطبيق
flutter run

# 2. سجل الدخول ببيانات حقيقية

# 3. راقب Console Logs
# ستجد logs من LoggingInterceptor تعرض:
# - الطلبات
# - الاستجابات
# - الأخطاء

# 4. تأكد من:
# ✅ تسجيل الدخول يعمل
# ✅ المحادثات تُحمّل
# ✅ لا توجد أخطاء parsing
```

---

## 🐛 معالجة المشاكل

### مشكلة: "FormatException: Unexpected character"

**السبب:** JSON parsing فشل

**الحل:**
```dart
// أضف try-catch في fromJson
factory SessionDto.fromJson(Map<String, dynamic> json) {
  try {
    return SessionDto(...);
  } catch (e) {
    print('❌ خطأ في parsing SessionDto: $e');
    print('JSON: $json');
    rethrow;
  }
}
```

---

### مشكلة: "Null check operator used on a null value"

**السبب:** حقل مطلوب غير موجود في الاستجابة

**الحل:**
```dart
// استخدم قيم افتراضية
sessionId: json['SessionId'] ?? json['sessionId'] ?? 'unknown',
title: json['Title'] ?? json['title'] ?? 'بدون عنوان',
```

---

### مشكلة: "type 'int' is not a subtype of type 'String'"

**السبب:** نوع البيانات مختلف عن المتوقع

**الحل:**
```dart
// حوّل النوع
messageCount: (json['MessageCount'] ?? json['messageCount'] ?? 0).toString(),

// أو
messageCount: int.tryParse(json['MessageCount']?.toString() ?? '0') ?? 0,
```

---

## 📊 سيناريوهات محتملة

### السيناريو A: API يستخدم PascalCase فقط
```json
{
  "SessionId": "...",
  "Title": "...",
  "CreatedAt": "..."
}
```

**الحالة:** ✅ **DTOs الحالية تدعم هذا!**

---

### السيناريو B: API يستخدم camelCase فقط
```json
{
  "sessionId": "...",
  "title": "...",
  "createdAt": "..."
}
```

**الحالة:** ✅ **DTOs الحالية تدعم هذا أيضاً!**

---

### السيناريو C: API يستخدم Success wrapper
```json
{
  "Success": true,
  "Data": {...}
}
```

**الحالة:** ✅ **ApiResponse.fromJson يتعامل مع هذا!**

---

### السيناريو D: API يستخدم snake_case
```json
{
  "session_id": "...",
  "created_at": "..."
}
```

**التحديث المطلوب:** إضافة دعم snake_case في DTOs

```dart
sessionId: json['SessionId'] ?? 
           json['sessionId'] ?? 
           json['session_id'] ?? '',  // إضافة
```

---

## 🎯 الخلاصة

### ما فعلناه:
✅ بنينا **نماذج مرنة** تدعم formats متعددة  
✅ أضفنا **fallbacks** لجميع الحقول  
✅ وفرنا **قيم افتراضية** عند الفشل  
✅ أنشأنا **سكريبت اختبار** سهل الاستخدام  

### الخطوة التالية:
1. ✅ شغّل `test_api_with_real_data.dart` ببيانات حقيقية
2. ✅ راقب شكل الاستجابات
3. ✅ حدّث DTOs **فقط إذا لزم الأمر**
4. ✅ اختبر التطبيق

### النصيحة الذهبية:
**على الأرجح DTOs الحالية ستعمل بدون تعديل!**  
**لكن الاختبار سيؤكد ذلك 100%**

---

**جاهز للاختبار!** 🧪

</div>

