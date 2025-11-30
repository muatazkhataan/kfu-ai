import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/api/api_manager.dart';
import '../../../../services/api/auth/models/login_request.dart';
import '../../../../services/api/auth/models/login_response.dart';
import '../../../../services/credential_manager_service.dart';

/// حالة المصادقة
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? userId;
  final String? error;
  final LoginResponse? loginResponse;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userId,
    this.error,
    this.loginResponse,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? userId,
    String? error,
    LoginResponse? loginResponse,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      error: error,
      loginResponse: loginResponse ?? this.loginResponse,
    );
  }
}

/// مزود حالة المصادقة
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiManager _apiManager;

  AuthNotifier(this._apiManager) : super(const AuthState()) {
    // سيتم التحقق من الجلسة في SplashScreen
  }

  /// تسجيل الدخول
  Future<bool> login(
    String studentNumber,
    String password, {
    bool rememberMe = false,
  }) async {
    // ignore: avoid_print
    print('\n╔═══════════════════════════════════════════════');
    // ignore: avoid_print
    print('║ 🔐 AuthProvider: بدء تسجيل الدخول');
    // ignore: avoid_print
    print('╠═══════════════════════════════════════════════');
    // ignore: avoid_print
    print('║ 📝 الرقم الجامعي: $studentNumber');
    // ignore: avoid_print
    print('║ 📝 طول كلمة المرور: ${password.length}');
    // ignore: avoid_print
    print('╚═══════════════════════════════════════════════\n');

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequest(
        studentNumber: studentNumber,
        password: password,
      );

      // ignore: avoid_print
      print('📤 إرسال طلب تسجيل الدخول...\n');
      // ignore: avoid_print
      print('📝 تذكرني: $rememberMe');

      final response = await _apiManager.auth.login(
        request,
        rememberMe: rememberMe,
      );

      // ignore: avoid_print
      print('\n╔═══════════════════════════════════════════════');
      // ignore: avoid_print
      print('║ 📨 استلام استجابة من AuthApiService');
      // ignore: avoid_print
      print('╠═══════════════════════════════════════════════');
      // ignore: avoid_print
      print('║ ✓ Success: ${response.success}');
      // ignore: avoid_print
      print('║ 📊 Status Code: ${response.statusCode}');
      // ignore: avoid_print
      print('║ 💬 Message: ${response.message}');
      // ignore: avoid_print
      print('║ ❌ Error: ${response.error}');
      // ignore: avoid_print
      print('║ 🔢 Error Code: ${response.errorCode}');
      // ignore: avoid_print
      print('║ 📦 Has Data: ${response.data != null}');

      if (response.success && response.data != null) {
        // ignore: avoid_print
        print('║ 👤 User ID: ${response.data!.userId}');
        // ignore: avoid_print
        print('║ 🎫 Token Type: ${response.data!.tokenType}');
        // ignore: avoid_print
        print('║ 📋 Profile: ${response.data!.profile}');
        // ignore: avoid_print
        print('╚═══════════════════════════════════════════════\n');

        // ignore: avoid_print
        print('✅ تحديث State بحالة Authenticated...\n');

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userId: response.data!.userId,
          loginResponse: response.data,
          error: null,
        );

        // حفظ بيانات الدخول في نظام التشغيل (Credential Manager)
        if (rememberMe) {
          try {
            final credentialService = CredentialManagerService();
            await credentialService.saveCredentials(
              studentNumber: studentNumber,
              password: password,
              userId: response.data!.userId,
            );
            // ignore: avoid_print
            print('[AuthProvider] ✅ تم حفظ بيانات الدخول في Credential Manager');
          } catch (e) {
            // ignore: avoid_print
            print('[AuthProvider] ⚠️ خطأ في حفظ بيانات الدخول في Credential Manager: $e');
            // لا نوقف عملية تسجيل الدخول إذا فشل حفظ البيانات
          }
        }

        return true;
      } else {
        // ignore: avoid_print
        print('╚═══════════════════════════════════════════════\n');
        // ignore: avoid_print
        print('❌ فشل تسجيل الدخول - تفاصيل الخطأ:');
        // ignore: avoid_print
        print('   - Error: ${response.error}');
        // ignore: avoid_print
        print('   - Error Code: ${response.errorCode}');
        // ignore: avoid_print
        print('   - Status Code: ${response.statusCode}');
        // ignore: avoid_print
        print('   - Message: ${response.message}\n');

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          error: response.error ?? 'فشل تسجيل الدخول',
        );
        return false;
      }
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('\n💥 استثناء في AuthProvider.login()');
      // ignore: avoid_print
      print('❌ الخطأ: $e');
      // ignore: avoid_print
      print('📚 Stack Trace:\n$stackTrace\n');

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: 'حدث خطأ: ${e.toString()}',
      );
      return false;
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      // ignore: avoid_print
      print('[AuthProvider] 🚪 تسجيل الخروج...');

      // تسجيل الخروج من API
      await _apiManager.logout();

      // حذف بيانات الدخول من Credential Manager (اختياري - يمكن الاحتفاظ بها)
      // إذا أردت حذفها عند تسجيل الخروج، قم بإلغاء التعليق من السطور التالية:
      // try {
      //   final credentialService = CredentialManagerService();
      //   await credentialService.deleteCredentials();
      //   // ignore: avoid_print
      //   print('[AuthProvider] ✅ تم حذف بيانات الدخول من Credential Manager');
      // } catch (e) {
      //   // ignore: avoid_print
      //   print('[AuthProvider] ⚠️ خطأ في حذف بيانات الدخول: $e');
      // }

      // ignore: avoid_print
      print('[AuthProvider] ✅ تم تسجيل الخروج وحذف الجلسة المحفوظة');

      // إعادة تعيين الحالة (سيقوم ApiManager.logout بحذف tokens والجلسة)
      state = const AuthState();
    } catch (e) {
      // ignore: avoid_print
      print('[AuthProvider] ❌ خطأ في تسجيل الخروج: $e');

      state = state.copyWith(
        isLoading: false,
        error: 'فشل تسجيل الخروج: ${e.toString()}',
      );
    }
  }

  /// التحقق من صلاحية الجلسة
  Future<bool> checkSession() async {
    final isValid = await _apiManager.isSessionValid();
    if (!isValid && state.isAuthenticated) {
      // الجلسة منتهية
      state = const AuthState();
    }
    return isValid;
  }

  /// التحقق من وجود جلسة محفوظة (للتسجيل التلقائي)
  Future<bool> checkSavedSession() async {
    try {
      // ignore: avoid_print
      print('[AuthProvider] 🔍 التحقق من جلسة محفوظة...');

      // محاولة إعادة تحميل الجلسة من TokenManager
      await _apiManager.reloadSession();

      // التحقق من إمكانية التسجيل التلقائي (تذكرني + جلسة صالحة)
      final shouldAutoLogin = await _apiManager.shouldAutoLogin();

      if (shouldAutoLogin) {
        // الحصول على userId من TokenManager
        final userId = await _apiManager.getCurrentUserId();

        // ignore: avoid_print
        print('[AuthProvider] ✅ جلسة صالحة مع تذكرني - User ID: $userId');

        // تحديث الحالة
        state = state.copyWith(
          isAuthenticated: true,
          userId: userId,
          isLoading: false,
        );

        return true;
      } else {
        // ignore: avoid_print
        print('[AuthProvider] ❌ الجلسة منتهية أو المستخدم لم يختر "تذكرني"');
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('[AuthProvider] ❌ خطأ في التحقق من الجلسة: $e');
      return false;
    }
  }
}

/// Provider للـ ApiManager
final apiManagerProvider = Provider<ApiManager>((ref) {
  return ApiManager();
});

/// Provider لحالة المصادقة
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiManager = ref.watch(apiManagerProvider);
  return AuthNotifier(apiManager);
});

/// Provider للتحقق من تسجيل الدخول
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Provider لمعرف المستخدم
final userIdProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).userId;
});
