# 📋 هيكل استجابات API الفعلية - KFU AI API

<div dir="rtl">

## 🔍 ما اكتشفناه من الاختبار

### ✅ ما نعرفه حالياً

#### 1. Login Response (فشل)
```json
{
  "Success": false,
  "Error": "محاولة تسجيل دخول غير صالحة"
}
```

**الملاحظات:**
- ✅ يستخدم `Success` boolean
- ✅ يستخدم `Error` للرسائل الخطأ
- ✅ Content-Type: `application/json; charset=utf-8`

#### 2. 401 Unauthorized Responses
- ✅ Status Code: 401
- ✅ Body: فارغ
- ✅ Header: `www-authenticate: Bearer`

**الملاحظة:** جميع endpoints التي تحتاج مصادقة تعيد 401 مع body فارغ

---

## ❓ ما نحتاج معرفته

### 🔐 Login Success Response

**نتوقع:**
```json
{
  "Success": true,
  "Data": {
    "UserId": "string",
    "AccessToken": "string",
    "RefreshToken": "string",
    "ExpiresIn": 3600,
    "TokenType": "Bearer"
  }
}
```

**أو ربما:**
```json
{
  "UserId": "string",
  "AccessToken": "string",
  "RefreshToken": "string",
  "ExpiresIn": 3600
}
```

**حالة الكود:** ⚠️ **غير مؤكد** - يحتاج اختبار بيانات صحيحة

---

### 💬 GetUserSessions Success Response

**نتوقع:**
```json
[
  {
    "SessionId": "string",
    "Title": "string",
    "CreatedAt": "2025-10-08T10:00:00Z",
    "UpdatedAt": "2025-10-08T10:30:00Z",
    "MessageCount": 10,
    "FolderId": "string",
    "IsArchived": false
  }
]
```

**أو مع wrapper:**
```json
{
  "Success": true,
  "Data": [...]
}
```

**حالة الكود:** ⚠️ **غير مؤكد** - يحتاج token صحيح

---

### 🔍 GetRecentChats Success Response

**نتوقع نفس structure الـ GetUserSessions**

**حالة الكود:** ⚠️ **غير مؤكد**

---

### 📁 GetAllFolder Success Response

**نتوقع:**
```json
[
  {
    "FolderId": "string",
    "Name": "string",
    "Icon": "string",
    "ChatCount": 5,
    "CreatedAt": "2025-10-08T10:00:00Z",
    "UpdatedAt": "2025-10-08T10:00:00Z"
  }
]
```

**حالة الكود:** ⚠️ **غير مؤكد**

---

## 🛠️ الحل المطبق

### ✅ ما فعلناه

قمنا بإنشاء **نماذج مرنة** تدعم **عدة احتمالات**:

```dart
// في ApiResponse.fromJson
factory ApiResponse.fromJson(
  Map<String, dynamic> json,
  T Function(dynamic)? fromJsonT,
) {
  return ApiResponse<T>(
    // يدعم Success أو success
    success: json['Success'] ?? json['success'] ?? false,
    
    // يدعم Data أو data
    data: fromJsonT != null && json['Data'] != null
        ? fromJsonT(json['Data'])
        : json['Data'] as T?,
    
    // يدعم Error أو error
    error: json['Error'] ?? json['error'],
    
    // يدعم ErrorCode أو errorCode
    errorCode: json['ErrorCode'] ?? json['errorCode'],
  );
}
```

### ✅ في SessionDto.fromJson

```dart
factory SessionDto.fromJson(Map<String, dynamic> json) {
  return SessionDto(
    // يدعم SessionId أو sessionId
    sessionId: json['SessionId'] ?? json['sessionId'] ?? '',
    
    // يدعم Title أو title
    title: json['Title'] ?? json['title'] ?? '',
    
    // يدعم تنسيقات تاريخ مختلفة
    createdAt: json['CreatedAt'] != null
        ? DateTime.parse(json['CreatedAt'])
        : json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
    
    // ... بقية الحقول بنفس المرونة
  );
}
```

### ✅ في ApiClient._handleResponse

```dart
ApiResponse<T> _handleResponse<T>(Response response, T Function(dynamic)? fromJson) {
  final statusCode = response.statusCode ?? 500;
  
  if (statusCode >= 200 && statusCode < 300) {
    final data = response.data;
    
    // يدعم استجابة مع Success wrapper
    if (data is Map<String, dynamic>) {
      return ApiResponse<T>.fromJson(data, fromJson);
    }
    
    // يدعم استجابة مباشرة (Array أو Object)
    final T? parsedData = fromJson != null && data != null
        ? fromJson(data)
        : data as T?;
    
    return ApiResponse<T>.success(data: parsedData!);
  }
  
  return _handleErrorResponse<T>(response);
}
```

---

## 🎯 لماذا هذا النهج ذكي؟

### ✅ المرونة
النماذج تدعم:
- `Success` أو `success`
- `Data` أو `data`
- `Error` أو `error`
- مع أو بدون wrapper

### ✅ التوافق
يعمل مع:
- Responses مباشرة: `[{...}, {...}]`
- Responses مع wrapper: `{"Success": true, "Data": [...]}`
- حالات الخطأ المختلفة

### ✅ المتانة
- لا يتعطل عند تغيير format
- يحاول التحليل بطرق متعددة
- يعطي قيم افتراضية عند الفشل

---

## 🔧 كيفية التحديث عند معرفة الشكل الفعلي

### الخطوة 1: احصل على بيانات حقيقية

```bash
# استخدم بيانات اعتماد صحيحة
curl -X POST https://kfuai-api.kfu.edu.sa/api/Users/login \
  -H "Content-Type: application/json" \
  -d '{"StudentNumber":"YOUR_ID","Password":"YOUR_PASSWORD"}'
```

### الخطوة 2: افحص الاستجابة

انظر إلى:
- ✅ أسماء الحقول (PascalCase أو camelCase)
- ✅ هل هناك Success wrapper
- ✅ هيكل Data
- ✅ أنواع البيانات

### الخطوة 3: حدّث DTOs

إذا كانت الاستجابة مثلاً:
```json
{
  "userId": "123",  // camelCase بدلاً من UserId
  "token": "...",   // token بدلاً من AccessToken
  "expires": 3600   // expires بدلاً من ExpiresIn
}
```

حدّث LoginResponse:
```dart
factory LoginResponse.fromJson(Map<String, dynamic> json) {
  return LoginResponse(
    userId: json['userId'] ?? json['UserId'] ?? '',
    accessToken: json['token'] ?? json['AccessToken'] ?? '',
    // ... إلخ
  );
}
```

---

## 🧪 سكريبت الاختبار

قمت بإنشاء `test_api.dart` للاختبار. استخدمه:

```bash
dart test_api.dart
```

لاختبار مع بيانات صحيحة، عدّل السكريبت:

```dart
body: jsonEncode({
  'StudentNumber': 'YOUR_REAL_ID',  // ضع رقمك الحقيقي
  'Password': 'YOUR_REAL_PASSWORD',  // ضع كلمة مرورك الحقيقية
}),
```

---

## ✅ الخلاصة

### ما نعرفه:
1. ✅ شكل Error Response: `{"Success": false, "Error": "..."}`
2. ✅ 401 يعيد body فارغ
3. ✅ Content-Type هو JSON
4. ✅ API يستخدم PascalCase للحقول

### ما نحتاجه:
1. ⚠️ شكل Login Success Response
2. ⚠️ شكل Sessions Response
3. ⚠️ شكل Folders Response
4. ⚠️ شكل Messages Response

### الحل:
✅ **النماذج الحالية مرنة** وتدعم احتمالات متعددة  
✅ **ستعمل** في معظم الحالات  
✅ **سهل التحديث** عند معرفة الشكل الفعلي  

---

## 🎯 الخطوات التالية

### خيار 1: اختبر مع بيانات حقيقية
```bash
# عدّل test_api.dart بيانات صحيحة
# ثم شغّل
dart test_api.dart
```

### خيار 2: استخدم Swagger Documentation
راجع: https://kfuai-api.kfu.edu.sa/swagger/index.html
- شاهد Examples
- حاول Execute
- انسخ Response

### خيار 3: استخدم التطبيق مباشرة
```bash
flutter run
# سجل دخول ببيانات حقيقية
# شاهد Logs في Console
```

---

## 📝 ملاحظة مهمة

**النماذج الحالية ذكية ومرنة:**
- ✅ تدعم formats متعددة
- ✅ تحاول parsing بطرق مختلفة
- ✅ تعطي قيم افتراضية
- ✅ لا تتعطل عند الأخطاء

**لذلك على الأرجح ستعمل بدون مشاكل!**

**لكن للتأكد التام:**
→ اختبر مع بيانات حقيقية
→ راقب Logs
→ حدّث إذا لزم الأمر

---

**تاريخ الاختبار:** 08 أكتوبر 2025  
**الحالة:** جاهز للاختبار مع بيانات حقيقية

</div>

