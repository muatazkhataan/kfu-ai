# 🔐 ميزة "تذكرني" - التسجيل التلقائي

## 📋 الملخص

تم إضافة خاصية **"تذكرني"** (Remember Me) التي تسمح للمستخدم بالبقاء مسجل دخول حتى بعد إغلاق التطبيق.

---

## ✨ كيف تعمل

### 1️⃣ **عند فتح التطبيق** (SplashScreen)

```
SplashScreen يعرض لمدة 2 ثانية
          ↓
التحقق من وجود جلسة محفوظة
          ↓
    ┌─────────────┐
    │ هل توجد؟   │
    └─────────────┘
         ↙     ↘
      نعم      لا
       ↓        ↓
  ChatScreen  LoginScreen
```

#### التدفق التفصيلي:

```dart
// 1. التحقق من AuthState الحالي
final authState = ref.read(authProvider);

// 2. محاولة تحميل الجلسة من Secure Storage
final sessionValid = await authProvider.checkSavedSession();

// 3أ. إذا كانت الجلسة صالحة
if (sessionValid) {
  // تحميل المحادثات
  await chatSessionsProvider.loadRecentChats();
  
  // الانتقال إلى ChatScreen
  Navigator.pushReplacement(ChatScreen());
}

// 3ب. إذا لم تكن الجلسة صالحة
else {
  // الانتقال إلى LoginScreen
  Navigator.pushReplacement(LoginScreen());
}
```

---

### 2️⃣ **عند تسجيل الدخول**

```dart
// 1. المستخدم يدخل بياناته
final success = await authProvider.login(studentNumber, password);

// 2. إذا نجح
if (success) {
  // AuthApiService يحفظ تلقائياً:
  // - AccessToken
  // - RefreshToken  
  // - UserId
  // - ExpiresIn
  // في FlutterSecureStorage
  
  // 3. الانتقال إلى ChatScreen
  Navigator.pushReplacement(ChatScreen());
}
```

---

### 3️⃣ **عند تسجيل الخروج**

```dart
// 1. المستخدم ينقر على "تسجيل الخروج"
await authProvider.logout();

// 2. AuthApiService يحذف:
// ✅ إرسال طلب logout للخادم
// ✅ حذف جميع Tokens من Secure Storage
// ✅ إنهاء الجلسة في SessionManager
// ✅ إعادة تعيين AuthState

// 3. الانتقال إلى LoginScreen
Navigator.pushReplacement(LoginScreen());
```

---

## 🔧 الملفات المُعدّلة

### 1. **`lib/app/app.dart`** - SplashScreen

#### التغييرات:
- ✅ تحويل `SplashScreen` من `StatefulWidget` إلى `ConsumerStatefulWidget`
- ✅ تحديث `_navigateToNextScreen()` للتحقق من الجلسة المحفوظة

#### الكود الجديد:
```dart
class SplashScreen extends ConsumerStatefulWidget { ... }

void _navigateToNextScreen() {
  Future.delayed(const Duration(seconds: 2), () async {
    try {
      // التحقق من جلسة محفوظة
      final sessionValid = await ref
          .read(authProvider.notifier)
          .checkSavedSession();

      if (sessionValid && mounted) {
        // تحميل المحادثات
        await ref.read(chatSessionsProvider.notifier).loadRecentChats();
        
        // الانتقال إلى ChatScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        );
      } else {
        // الانتقال إلى LoginScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      // في حالة الخطأ، الانتقال إلى LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  });
}
```

---

### 2. **`lib/features/auth/presentation/providers/auth_provider.dart`**

#### التغييرات:
- ✅ حذف `_checkSession()` من constructor
- ✅ إضافة دالة `checkSavedSession()` جديدة
- ✅ تحديث `logout()` مع logs

#### الدالة الجديدة:
```dart
/// التحقق من وجود جلسة محفوظة (للتسجيل التلقائي)
Future<bool> checkSavedSession() async {
  try {
    // إعادة تحميل الجلسة من TokenManager
    await _apiManager.reloadSession();

    // التحقق من صلاحية الجلسة
    final isValid = await _apiManager.isSessionValid();

    if (isValid) {
      final userId = await _apiManager.getCurrentUserId();
      
      // تحديث الحالة
      state = state.copyWith(
        isAuthenticated: true,
        userId: userId,
        isLoading: false,
      );

      return true;
    }
    
    return false;
  } catch (e) {
    return false;
  }
}
```

---

## 🔄 كيف يتم الحفظ؟

### التخزين الآمن (FlutterSecureStorage)

عند تسجيل الدخول الناجح، يُحفظ في Secure Storage:

```dart
// في AuthApiService.login
await _tokenManager.saveTokens(
  accessToken: loginResponse.accessToken,
  refreshToken: loginResponse.refreshToken,
  userId: loginResponse.userId,
  expiresIn: loginResponse.expiresIn,
);
```

**ما يُحفظ**:
- ✅ `access_token` - للوصول إلى API
- ✅ `refresh_token` - لتجديد الـ token
- ✅ `user_id` - معرف المستخدم
- ✅ `token_expiry` - وقت انتهاء الصلاحية

---

## 🧪 السيناريوهات

### السيناريو 1: أول مرة
```
1. المستخدم يفتح التطبيق
2. لا توجد جلسة محفوظة
3. ✅ الانتقال إلى LoginScreen
```

### السيناريو 2: تسجيل دخول جديد
```
1. المستخدم يسجل الدخول
2. ✅ حفظ Tokens في Secure Storage
3. ✅ الانتقال إلى ChatScreen
```

### السيناريو 3: إعادة فتح التطبيق
```
1. المستخدم يفتح التطبيق
2. ✅ وجود جلسة محفوظة صالحة
3. ✅ الانتقال مباشرة إلى ChatScreen
```

### السيناريو 4: الجلسة منتهية
```
1. المستخدم يفتح التطبيق
2. وجود tokens لكنها منتهية
3. ❌ الجلسة غير صالحة
4. ✅ الانتقال إلى LoginScreen
```

### السيناريو 5: تسجيل خروج
```
1. المستخدم ينقر "تسجيل الخروج"
2. ✅ حذف جميع Tokens
3. ✅ إنهاء الجلسة
4. ✅ الانتقال إلى LoginScreen
5. عند إعادة فتح التطبيق → LoginScreen
```

---

## 🔐 الأمان

### FlutterSecureStorage
- ✅ **مشفر** على جميع المنصات
- ✅ **Android**: KeyStore
- ✅ **iOS**: Keychain
- ✅ **Windows**: CredentialManager
- ✅ لا يمكن الوصول إليه من تطبيقات أخرى

### انتهاء الصلاحية
- ✅ الـ Token له وقت انتهاء (expiresIn)
- ✅ AuthInterceptor يجدد الـ Token تلقائياً
- ✅ إذا فشل التجديد، يُطلب تسجيل دخول جديد

---

## 📊 السجلات (Logs)

### عند فتح التطبيق:
```
🚀 SplashScreen: التحقق من تسجيل الدخول
📊 Is Authenticated: false
🔍 البحث عن جلسة محفوظة...
[AuthProvider] 🔍 التحقق من جلسة محفوظة...
[AuthProvider] ✅ جلسة صالحة - User ID: xxx
✅ تم العثور على جلسة صالحة - الانتقال إلى ChatScreen
```

### عند تسجيل الخروج:
```
[AuthProvider] 🚪 تسجيل الخروج...
[AuthProvider] ✅ تم تسجيل الخروج وحذف الجلسة المحفوظة
```

---

## ✅ الميزات

1. ✅ **تسجيل تلقائي** - لا حاجة لإدخال البيانات كل مرة
2. ✅ **آمن** - Tokens مشفرة في Secure Storage
3. ✅ **تجديد تلقائي** - AuthInterceptor يجدد Token عند انتهاء الصلاحية
4. ✅ **سهل الاستخدام** - كل شيء تلقائي
5. ✅ **تسجيل خروج كامل** - يحذف كل البيانات المحفوظة

---

## 🎯 النتيجة

- ✅ المستخدم يسجل الدخول **مرة واحدة**
- ✅ التطبيق يتذكره في المرات القادمة
- ✅ إلا إذا سجّل الخروج أو انتهت الجلسة

---

تم بنجاح! 🎉

