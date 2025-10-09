# خطة تطوير خدمة API لتطبيق مساعد كفو - منهجية OOP

## 📋 نظرة عامة

هذا المستند يحتوي على خطة شاملة لتطوير وتنفيذ خدمة API كاملة لتطبيق مساعد كفو باستخدام منهجية البرمجة الشيئية (OOP) والتكامل مع API الخاص بجامعة الملك فيصل.

**API Base URL:** `https://kfuai-api.kfu.edu.sa`

---

## 🎯 الأهداف الرئيسية

1. بناء بنية API محترفة باستخدام مبادئ OOP
2. تطبيق مبادئ SOLID في جميع أجزاء الكود
3. تنفيذ Clean Architecture (Data - Domain - Presentation)
4. إنشاء نظام مصادقة آمن مع Token Management
5. تطوير خدمات API لكل feature في التطبيق
6. ضمان تجربة مستخدم سلسة من Login إلى Chat
7. دعم Error Handling وRetry Logic
8. تطبيق Caching Strategy للأداء الأمثل

---

## 🏗️ البنية المعمارية (Architecture)

### 1. Core Layer (الطبقة الأساسية)

```
lib/core/api/
├── base/                    # الفئات الأساسية المشتركة
│   ├── api_client.dart     # HTTP Client الأساسي
│   ├── api_response.dart   # نموذج الاستجابة الموحد
│   ├── api_endpoint.dart   # تعريف نقاط النهاية
│   └── api_request.dart    # نموذج الطلب الموحد
├── config/                  # إعدادات API
│   ├── api_config.dart     # الإعدادات الأساسية
│   ├── api_endpoints.dart  # جميع endpoints
│   └── api_headers.dart    # Headers الثابتة
├── exceptions/              # معالجة الأخطاء
│   ├── api_exception.dart  # استثناءات API
│   ├── network_exception.dart
│   └── auth_exception.dart
├── interceptors/            # Interceptors للطلبات
│   ├── auth_interceptor.dart
│   ├── logging_interceptor.dart
│   └── retry_interceptor.dart
└── utils/                   # أدوات مساعدة
    ├── api_utils.dart
    └── response_parser.dart
```

### 2. Services Layer (طبقة الخدمات)

```
lib/services/api/
├── auth/                    # خدمات المصادقة
│   ├── auth_api_service.dart
│   ├── token_manager.dart
│   └── session_manager.dart
├── chat/                    # خدمات المحادثات
│   ├── chat_api_service.dart
│   └── message_api_service.dart
├── folder/                  # خدمات المجلدات
│   └── folder_api_service.dart
├── search/                  # خدمات البحث
│   └── search_api_service.dart
└── storage/                 # التخزين المحلي
    ├── cache_manager.dart
    └── offline_sync_manager.dart
```

### 3. Data Layer (طبقة البيانات)

```
lib/features/{feature}/data/
├── datasources/
│   ├── {feature}_remote_datasource.dart  # مصدر البيانات البعيد
│   └── {feature}_local_datasource.dart   # مصدر البيانات المحلي
├── models/
│   └── {feature}_dto.dart                # Data Transfer Objects
└── repositories/
    └── {feature}_repository_impl.dart    # تنفيذ Repository
```

---

## 📦 نماذج البيانات (Data Models)

### 1. Core Models

#### ApiResponse<T>
```dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? metadata;
}
```

#### ApiRequest
```dart
class ApiRequest {
  final String endpoint;
  final HttpMethod method;
  final Map<String, dynamic>? body;
  final Map<String, String>? headers;
  final Map<String, dynamic>? queryParameters;
  final bool requiresAuth;
}
```

### 2. Authentication Models

#### LoginRequest
```dart
class LoginRequest {
  final String studentNumber;  // الرقم الجامعي
  final String password;        // كلمة المرور
}
```

#### LoginResponse
```dart
class LoginResponse {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;
  final UserProfile? profile;
}
```

#### RefreshTokenRequest
```dart
class RefreshTokenRequest {
  final String userId;
  final String refreshToken;
}
```

### 3. Chat Models

#### SendMessageRequest
```dart
class SendMessageRequest {
  final String sessionId;
  final String content;
}
```

#### CreateSessionRequest
```dart
class CreateSessionRequest {
  final String title;
}
```

#### SessionResponse
```dart
class SessionResponse {
  final String sessionId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MessageDto>? messages;
}
```

### 4. Folder Models

#### CreateFolderRequest
```dart
class CreateFolderRequest {
  final String name;
  final String icon;
}
```

#### UpdateFolderRequest
```dart
class UpdateFolderRequest {
  final String folderId;
  final String? name;
  final String? icon;
}
```

#### FolderResponse
```dart
class FolderResponse {
  final String folderId;
  final String name;
  final String icon;
  final int chatCount;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### 5. Search Models

#### SearchChatsRequest
```dart
class SearchChatsRequest {
  final String query;
}
```

#### SearchChatsResponse
```dart
class SearchChatsResponse {
  final List<ChatSearchResult> results;
  final int totalCount;
}
```

---

## 🔌 API Endpoints (نقاط النهاية)

### 1. Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/Users/login` | تسجيل الدخول |
| POST | `/api/Users/refresh_token` | تجديد Token |
| POST | `/api/Users/logout` | تسجيل الخروج |

### 2. Chat Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/Chat/SendMessage` | إرسال رسالة |
| POST | `/api/Chat/CreateSession` | إنشاء جلسة محادثة |
| GET | `/api/Chat/GetSession?sessionId={id}` | الحصول على جلسة |
| POST | `/api/Chat/UpdateSessionTitle` | تحديث عنوان الجلسة |
| POST | `/api/Chat/ArchiveSession` | أرشفة جلسة |
| POST | `/api/Chat/DeleteSession` | حذف جلسة |
| POST | `/api/Chat/RestoreSession` | استعادة جلسة |
| POST | `/api/Chat/MoveSessionToFolder` | نقل جلسة لمجلد |
| GET | `/api/Chat/GetUserSessions` | الحصول على جميع الجلسات |

### 3. Folder Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/Folder/GetAllFolder` | الحصول على جميع المجلدات |
| GET | `/api/Folder/GetAvailableFolders` | المجلدات المتاحة |
| GET | `/api/Folder/GetFolderChats?folderId={id}` | محادثات المجلد |
| POST | `/api/Folder/CreateFolder` | إنشاء مجلد |
| POST | `/api/Folder/UpdateFolderName` | تحديث اسم المجلد |
| POST | `/api/Folder/UpdateFolderIcon` | تحديث أيقونة المجلد |
| POST | `/api/Folder/DeleteFolder` | حذف مجلد |
| POST | `/api/Folder/UpdateFolderOrder` | تحديث ترتيب المجلدات |

### 4. Search Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/Search/SearchChats` | البحث في المحادثات |
| GET | `/api/Search/GetRecentChats` | المحادثات الأخيرة |

---

## 🎨 تطبيق مبادئ OOP وSOLID

### 1. Single Responsibility Principle (SRP)
- كل Service مسؤول عن نطاق واحد فقط
- فصل Auth Logic عن Business Logic
- فصل Network Logic عن Data Persistence

### 2. Open/Closed Principle (OCP)
- استخدام Abstract Classes للتوسع
- Interfaces للـ Repositories
- Strategy Pattern للـ Retry Logic

### 3. Liskov Substitution Principle (LSP)
- جميع Repositories قابلة للاستبدال
- ApiClient يمكن استبداله بـ Mock للاختبار

### 4. Interface Segregation Principle (ISP)
- واجهات صغيرة ومحددة لكل خدمة
- عدم إجبار Classes على تنفيذ methods غير ضرورية

### 5. Dependency Inversion Principle (DIP)
- الاعتماد على Abstractions وليس Implementations
- استخدام Dependency Injection (GetIt/Riverpod)

---

## 🔐 إدارة المصادقة والأمان

### 1. Token Management
```dart
class TokenManager {
  // تخزين آمن للـ Tokens
  Future<void> saveTokens(String accessToken, String refreshToken);
  
  // استرجاع Access Token
  Future<String?> getAccessToken();
  
  // استرجاع Refresh Token
  Future<String?> getRefreshToken();
  
  // حذف Tokens (Logout)
  Future<void> clearTokens();
  
  // التحقق من صلاحية Token
  bool isTokenExpired(String token);
}
```

### 2. Auth Interceptor
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // إضافة Bearer Token للطلبات
    final token = await tokenManager.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // معالجة 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // محاولة تجديد Token
      await refreshTokenAndRetry(err, handler);
    }
  }
}
```

### 3. Session Manager
```dart
class SessionManager {
  // إدارة الجلسة الحالية
  Future<void> createSession(LoginResponse loginResponse);
  
  // التحقق من الجلسة
  Future<bool> isSessionValid();
  
  // إنهاء الجلسة
  Future<void> endSession();
}
```

---

## 📱 تدفق العمل (Workflow)

### 1. Login Flow
```
1. User enters StudentNumber → LoginScreen
2. User enters Password → LoginScreen
3. Call authService.login(studentNumber, password)
4. Receive LoginResponse with tokens
5. TokenManager saves tokens securely
6. SessionManager creates session
7. Navigate to ChatScreen
8. Load user data and sessions
```

### 2. Chat Flow
```
1. ChatScreen loads with existing/new session
2. User types message → ChatInputField
3. Call chatService.sendMessage(sessionId, content)
4. Display user message immediately (optimistic UI)
5. Receive AI response from API
6. Display AI response in MessageBubble
7. Update local database with messages
8. Update session metadata
```

### 3. Session Management Flow
```
1. User opens app
2. Check if tokens exist
3. If exist → Validate token
4. If valid → Load ChatScreen
5. If invalid → Try refresh token
6. If refresh fails → Navigate to LoginScreen
```

---

## 🛠️ تنفيذ الخطة (Implementation Steps)

### المرحلة 1: Core API Infrastructure ✅
1. إنشاء ApiClient base class
2. تطوير ApiResponse وApiRequest models
3. إنشاء Exception hierarchy
4. تطوير Interceptors (Auth, Logging, Retry)
5. إعداد API Configuration

### المرحلة 2: Authentication Service ✅
1. تطوير AuthApiService
2. إنشاء TokenManager
3. إنشاء SessionManager
4. تطوير Login/Logout/RefreshToken methods
5. تطبيق Secure Storage للـ Tokens

### المرحلة 3: Chat Service ✅
1. تطوير ChatApiService
2. إنشاء DTOs للـ Chat
3. تنفيذ جميع Chat endpoints
4. دمج مع ChatProvider
5. تحديث ChatScreen للعمل مع API

### المرحلة 4: Folder Service ✅
1. تطوير FolderApiService
2. إنشاء DTOs للـ Folder
3. تنفيذ جميع Folder endpoints
4. دمج مع FolderProvider
5. تحديث FolderSidebar للعمل مع API

### المرحلة 5: Search Service ✅
1. تطوير SearchApiService
2. إنشاء DTOs للـ Search
3. تنفيذ Search endpoints
4. دمج مع ChatHistoryProvider
5. تحديث ChatHistoryScreen للعمل مع API

### المرحلة 6: Integration & Testing ✅
1. دمج جميع الخدمات
2. اختبار تدفق Login → Chat
3. اختبار Error Handling
4. اختبار Offline Mode
5. اختبار Token Refresh
6. Performance Testing

### المرحلة 7: UI Updates ✅
1. تحديث LoginScreen لاستخدام API
2. تحديث ChatScreen لاستخدام API
3. تحديث ChatHistoryScreen
4. تحديث FolderSidebar
5. إضافة Loading States
6. إضافة Error Messages

### المرحلة 8: Polish & Optimization 🎨
1. تحسين Caching Strategy
2. تحسين Error Messages
3. إضافة Retry Logic المتقدم
4. تحسين Performance
5. إضافة Analytics (اختياري)

---

## 🧪 الاختبار (Testing Strategy)

### 1. Unit Tests
- اختبار جميع API Services
- اختبار Models وDTO conversions
- اختبار TokenManager
- اختبار Exception Handling

### 2. Integration Tests
- اختبار تدفق Login
- اختبار تدفق Chat
- اختبار Token Refresh
- اختبار Offline Sync

### 3. Widget Tests
- اختبار LoginScreen
- اختبار ChatScreen
- اختبار Loading States
- اختبار Error States

---

## 📊 إدارة الحالات (State Management)

### استخدام Riverpod

```dart
// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// Chat State Provider
final chatStateProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.read(chatServiceProvider));
});

// Folder State Provider
final folderStateProvider = StateNotifierProvider<FolderNotifier, FolderState>((ref) {
  return FolderNotifier(ref.read(folderServiceProvider));
});
```

---

## 🔄 معالجة الأخطاء (Error Handling)

### Exception Hierarchy

```dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;
  
  AppException(this.message, {this.code, this.details});
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

class AuthException extends AppException {
  AuthException(String message) : super(message, code: 'AUTH_ERROR');
}

class ApiException extends AppException {
  final int? statusCode;
  
  ApiException(String message, {this.statusCode, String? code})
      : super(message, code: code ?? 'API_ERROR');
}
```

---

## 💾 استراتيجية التخزين (Caching Strategy)

### 1. Memory Cache
- Tokens في الذاكرة للوصول السريع
- Sessions الحالية
- User Profile

### 2. Disk Cache
- Messages التاريخية
- Folders والتصنيفات
- Search Results

### 3. Sync Strategy
- Sync on app start
- Periodic background sync
- Manual refresh
- Optimistic updates

---

## 🎯 معايير النجاح (Success Criteria)

✅ تسجيل الدخول يعمل بشكل كامل
✅ إرسال الرسائل والحصول على ردود من AI
✅ إنشاء وإدارة الجلسات
✅ إنشاء وإدارة المجلدات
✅ البحث في المحادثات
✅ Token refresh تلقائي
✅ Error handling واضح وفعال
✅ Offline mode للقراءة
✅ Performance مقبول (< 2s للطلبات)
✅ Security محكم للـ Tokens

---

## 📚 المراجع والموارد

- [KFU AI API Documentation](https://kfuai-api.kfu.edu.sa/swagger/index.html)
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [Dio Package](https://pub.dev/packages/dio)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Riverpod Documentation](https://riverpod.dev)

---

## 📝 ملاحظات إضافية

1. **الأمان**: استخدام Flutter Secure Storage لتخزين Tokens
2. **الأداء**: تنفيذ Caching للحد من الطلبات
3. **التجربة**: Optimistic UI Updates لسرعة الاستجابة
4. **الخطأ**: رسائل خطأ واضحة بالعربية
5. **الاتصال**: Retry logic للطلبات الفاشلة
6. **الاختبار**: Mock API للتطوير والاختبار

---

**تاريخ الإنشاء:** 08 أكتوبر 2025
**الإصدار:** 1.0
**الحالة:** قيد التنفيذ 🚀

