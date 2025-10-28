# 📘 كيفية استخدام API في التطبيق

<div dir="rtl">

## 🎯 الطرق المختلفة للاستخدام

هناك طريقتان لاستخدام API في التطبيق:

1. **مباشرة** - استخدام `ApiManager` مباشرة
2. **مع Providers** - استخدام Riverpod Providers (موصى به)

---

## 🔹 الطريقة 1: الاستخدام المباشر

### تسجيل الدخول

```dart
import 'package:kfu_ai/services/api/api_manager.dart';
import 'package:kfu_ai/services/api/auth/models/login_request.dart';

// في أي دالة async
final apiManager = ApiManager();

final request = LoginRequest(
  studentNumber: '123456',
  password: 'password123',
);

final response = await apiManager.auth.login(request);

if (response.success && response.data != null) {
  print('تم تسجيل الدخول!');
  print('User ID: ${response.data!.userId}');
  print('Access Token: ${response.data!.accessToken}');
} else {
  print('خطأ: ${response.error}');
}
```

### تحميل المحادثات الأخيرة

```dart
final response = await ApiManager().search.getRecentChats();

if (response.success && response.data != null) {
  for (var session in response.data!) {
    print('${session.title}: ${session.messageCount ?? 0} رسالة');
  }
}
```

### إرسال رسالة

```dart
import 'package:kfu_ai/services/api/chat/models/send_message_request.dart';

final request = SendMessageRequest(
  sessionId: 'session_123',
  content: 'مرحباً، كيف يمكنني حل هذه المسألة؟',
);

final response = await ApiManager().chat.sendMessage(request);

if (response.success && response.data != null) {
  print('تم إرسال الرسالة!');
  print('الرد: ${response.data!.content}');
}
```

---

## 🔹 الطريقة 2: مع Providers (موصى به ⭐)

### في Widget

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfu_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:kfu_ai/features/chat/presentation/providers/chat_sessions_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. مراقبة الحالة
    final authState = ref.watch(authProvider);
    final sessionsState = ref.watch(chatSessionsProvider);
    
    // 2. التحقق من الحالة
    if (authState.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (authState.error != null) {
      return Text('خطأ: ${authState.error}');
    }
    
    // 3. عرض البيانات
    return Column(
      children: [
        if (authState.isAuthenticated)
          Text('مرحباً! ${authState.userId}'),
        
        ...sessionsState.recentSessions.map((session) =>
          ListTile(title: Text(session.title)),
        ),
      ],
    );
  }
}
```

### تسجيل الدخول

```dart
class LoginButton extends ConsumerWidget {
  final String studentNumber;
  final String password;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return ElevatedButton(
      onPressed: authState.isLoading ? null : () async {
        final success = await ref.read(authProvider.notifier).login(
          studentNumber,
          password,
        );
        
        if (success) {
          // نجح تسجيل الدخول - الانتقال للمحادثة
          Navigator.push(...);
        } else {
          // فشل - عرض رسالة
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authState.error ?? 'خطأ')),
          );
        }
      },
      child: authState.isLoading
          ? CircularProgressIndicator()
          : Text('دخول'),
    );
  }
}
```

### تحميل المحادثات

```dart
class RecentChatsList extends ConsumerStatefulWidget {
  @override
  ConsumerState createState() => _RecentChatsListState();
}

class _RecentChatsListState extends ConsumerState<RecentChatsList> {
  @override
  void initState() {
    super.initState();
    // تحميل عند بدء التشغيل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatSessionsProvider.notifier).loadRecentChats();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final sessionsState = ref.watch(chatSessionsProvider);
    
    if (sessionsState.isLoading) {
      return CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: sessionsState.recentSessions.length,
      itemBuilder: (context, index) {
        final session = sessionsState.recentSessions[index];
        return ListTile(
          title: Text(session.title),
          subtitle: Text('${session.messageCount ?? 0} رسالة'),
          onTap: () {
            // فتح المحادثة
          },
        );
      },
    );
  }
}
```

### تحديث المحادثات

```dart
// زر تحديث
IconButton(
  onPressed: () {
    ref.read(chatSessionsProvider.notifier).loadRecentChats();
  },
  icon: Icon(Icons.refresh),
)
```

### تسجيل الخروج

```dart
ElevatedButton(
  onPressed: () async {
    await ref.read(authProvider.notifier).logout();
    Navigator.pushReplacement(...); // للـ LoginScreen
  },
  child: Text('تسجيل الخروج'),
)
```

---

## 🎨 Providers المتاحة

### Auth Providers

```dart
// حالة المصادقة الكاملة
final authState = ref.watch(authProvider);

// التحقق من تسجيل الدخول فقط
final isAuth = ref.watch(isAuthenticatedProvider);

// معرف المستخدم فقط
final userId = ref.watch(userIdProvider);

// العمليات
ref.read(authProvider.notifier).login(username, password);
ref.read(authProvider.notifier).logout();
ref.read(authProvider.notifier).checkSession();
```

### Chat Sessions Providers

```dart
// حالة الجلسات الكاملة
final sessionsState = ref.watch(chatSessionsProvider);

// جميع الجلسات فقط
final allSessions = ref.watch(allSessionsProvider);

// المحادثات الأخيرة فقط
final recentSessions = ref.watch(recentSessionsProvider);

// العمليات
ref.read(chatSessionsProvider.notifier).loadUserSessions();
ref.read(chatSessionsProvider.notifier).loadRecentChats();
ref.read(chatSessionsProvider.notifier).refreshAll();
```

---

## 🔍 معالجة الأخطاء

### نمط موحد

```dart
final response = await apiManager.auth.login(request);

if (response.success) {
  // نجح ✅
  final data = response.data!;
  // استخدم البيانات
} else {
  // فشل ❌
  print('الخطأ: ${response.error}');
  print('كود الخطأ: ${response.errorCode}');
  print('كود الحالة: ${response.statusCode}');
  
  // معالجة حسب نوع الخطأ
  switch (response.errorCode) {
    case 'UNAUTHORIZED':
      // إعادة توجيه لتسجيل الدخول
      break;
    case 'NO_INTERNET':
      // عرض رسالة لا يوجد إنترنت
      break;
    case 'TIMEOUT':
      // إعادة المحاولة
      break;
    default:
      // عرض رسالة عامة
      break;
  }
}
```

### مع Providers

```dart
final authState = ref.watch(authProvider);

if (authState.isLoading) {
  return CircularProgressIndicator();
}

if (authState.error != null) {
  return Column(
    children: [
      Text('خطأ: ${authState.error}'),
      ElevatedButton(
        onPressed: () {
          // إعادة المحاولة
        },
        child: Text('إعادة المحاولة'),
      ),
    ],
  );
}

if (authState.isAuthenticated) {
  return ChatScreen();
}

return LoginScreen();
```

---

## 📱 أمثلة واقعية

### مثال 1: شاشة Login كاملة

```dart
class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  Future<void> _handleLogin() async {
    final success = await ref.read(authProvider.notifier).login(
      _usernameController.text,
      _passwordController.text,
    );
    
    if (success) {
      // تحميل البيانات
      ref.read(chatSessionsProvider.notifier).refreshAll();
      
      // الانتقال
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChatScreen()),
      );
    } else {
      // عرض الخطأ
      final error = ref.read(authProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'فشل تسجيل الدخول')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _usernameController),
          TextField(controller: _passwordController),
          ElevatedButton(
            onPressed: authState.isLoading ? null : _handleLogin,
            child: authState.isLoading
                ? CircularProgressIndicator()
                : Text('دخول'),
          ),
        ],
      ),
    );
  }
}
```

### مثال 2: عرض المحادثات الأخيرة

```dart
class RecentChatsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsState = ref.watch(chatSessionsProvider);
    
    // Loading
    if (sessionsState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    // Error
    if (sessionsState.error != null) {
      return Column(
        children: [
          Text('خطأ: ${sessionsState.error}'),
          ElevatedButton(
            onPressed: () {
              ref.read(chatSessionsProvider.notifier).loadRecentChats();
            },
            child: Text('إعادة المحاولة'),
          ),
        ],
      );
    }
    
    // Empty
    if (sessionsState.recentSessions.isEmpty) {
      return Center(child: Text('لا توجد محادثات'));
    }
    
    // Data
    return ListView.builder(
      itemCount: sessionsState.recentSessions.length,
      itemBuilder: (context, index) {
        final session = sessionsState.recentSessions[index];
        return ListTile(
          title: Text(session.title),
          subtitle: Text('${session.messageCount ?? 0} رسالة'),
          trailing: Text(formatDate(session.updatedAt)),
          onTap: () {
            // فتح المحادثة
          },
        );
      },
    );
  }
}
```

### مثال 3: زر تحديث

```dart
class RefreshButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(chatSessionsProvider).isLoading;
    
    return IconButton(
      onPressed: isLoading ? null : () {
        ref.read(chatSessionsProvider.notifier).loadRecentChats();
      },
      icon: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(Icons.refresh),
    );
  }
}
```

---

## 🛠️ نصائح للمطورين

### ✅ افعل

```dart
// ✅ استخدم ApiManager كـ Singleton
final api = ApiManager();

// ✅ تحقق من الاستجابة
if (response.success) { ... }

// ✅ استخدم Providers للـ State
ref.watch(authProvider);

// ✅ معالجة الأخطاء
if (response.error != null) { ... }
```

### ❌ لا تفعل

```dart
// ❌ لا تخزن Tokens يدوياً
String token = response.data.accessToken;

// ❌ لا تتجاهل الأخطاء
await api.auth.login(request);  // بدون تحقق

// ❌ لا تنشئ instances متعددة من ApiManager
final api1 = ApiManager();
final api2 = ApiManager();  // نفس الـ instance

// ❌ لا تستخدم print في production
print('User logged in');  // استخدم Logger
```

---

## 🎯 أمثلة متقدمة

### مثال 1: Login مع Remember Me

```dart
Future<void> loginWithRememberMe(
  String username,
  String password,
  bool rememberMe,
) async {
  final success = await ref.read(authProvider.notifier).login(
    username,
    password,
  );
  
  if (success && rememberMe) {
    // حفظ معلومات إضافية
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_username', username);
  }
}
```

### مثال 2: Auto Refresh للمحادثات

```dart
class AutoRefreshChats extends ConsumerStatefulWidget {
  @override
  ConsumerState createState() => _AutoRefreshChatsState();
}

class _AutoRefreshChatsState extends ConsumerState<AutoRefreshChats> {
  Timer? _refreshTimer;
  
  @override
  void initState() {
    super.initState();
    
    // تحديث كل 30 ثانية
    _refreshTimer = Timer.periodic(
      Duration(seconds: 30),
      (_) {
        if (ref.read(isAuthenticatedProvider)) {
          ref.read(chatSessionsProvider.notifier).loadRecentChats();
        }
      },
    );
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

### مثال 3: Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    await ref.read(chatSessionsProvider.notifier).loadRecentChats();
  },
  child: ListView(...),
)
```

---

## 🔍 التحقق من الحالة

### تسجيل الدخول

```dart
// طريقة 1: مع Provider
if (ref.watch(isAuthenticatedProvider)) {
  print('مسجل الدخول');
}

// طريقة 2: مباشرة
if (ApiManager().isAuthenticated) {
  print('مسجل الدخول');
}

// طريقة 3: التحقق من الجلسة
final isValid = await ApiManager().isSessionValid();
if (isValid) {
  print('الجلسة صالحة');
}
```

### معرف المستخدم

```dart
// مع Provider
final userId = ref.watch(userIdProvider);

// مباشرة
final userId = await ApiManager().getCurrentUserId();
```

---

## 📦 Widgets الجاهزة

### RecentChatsWidget

```dart
import 'package:kfu_ai/features/chat/presentation/widgets/recent_chats_widget.dart';

RecentChatsWidget(
  selectedSessionId: currentSessionId,
  onSessionSelected: (sessionId) {
    print('Selected: $sessionId');
    // فتح المحادثة
  },
  showRefreshButton: true,  // عرض زر التحديث
)
```

**الميزات:**
- ✅ تحميل تلقائي
- ✅ Loading State
- ✅ Error State
- ✅ Empty State
- ✅ زر تحديث اختياري

---

## 🎓 الخلاصة

### للاستخدام السريع
استخدم **Providers** (موصى به):
```dart
ref.read(authProvider.notifier).login(...);
ref.read(chatSessionsProvider.notifier).loadRecentChats();
```

### للتحكم الكامل
استخدم **ApiManager** مباشرة:
```dart
final api = ApiManager();
await api.auth.login(...);
await api.search.getRecentChats();
```

### للـ UI Components
استخدم **Widgets الجاهزة**:
```dart
RecentChatsWidget(...)
```

---

**اختر الطريقة المناسبة لك وابدأ!** 🚀

</div>

