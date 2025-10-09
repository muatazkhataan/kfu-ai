import '../../../core/api/base/api_client.dart';
import '../../../core/api/base/api_response.dart';
import '../../../core/api/config/api_endpoints.dart';
import 'models/login_request.dart';
import 'models/login_response.dart';
import 'models/refresh_token_request.dart';
import 'models/refresh_token_response.dart';
import 'token_manager.dart';
import 'session_manager.dart';

/// خدمة API للمصادقة
///
/// تدير جميع العمليات المتعلقة بالمصادقة
class AuthApiService {
  /// API Client
  final ApiClient _apiClient;

  /// Token Manager
  final TokenManager _tokenManager;

  /// Session Manager
  final SessionManager _sessionManager;

  /// Constructor
  AuthApiService({
    required ApiClient apiClient,
    TokenManager? tokenManager,
    SessionManager? sessionManager,
  }) : _apiClient = apiClient,
       _tokenManager = tokenManager ?? TokenManager(),
       _sessionManager = sessionManager ?? SessionManager();

  /// تسجيل الدخول
  ///
  /// [request] - بيانات تسجيل الدخول
  /// Returns [ApiResponse<LoginResponse>]
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    _logDebug('🔐 بدء عملية تسجيل الدخول');
    _logDebug('📝 الرقم الجامعي: ${request.studentNumber}');
    _logDebug('📝 طول كلمة المرور: ${request.password.length} حرف');

    try {
      // التحقق من صحة البيانات
      if (!request.isValid) {
        _logError('❌ بيانات غير صالحة');
        _logError('   - الرقم الجامعي فارغ: ${request.studentNumber.isEmpty}');
        _logError('   - كلمة المرور فارغة: ${request.password.isEmpty}');
        _logError('   - طول الرقم < 6: ${request.studentNumber.length < 6}');

        return ApiResponse.error(
          error: 'يرجى إدخال الرقم الجامعي وكلمة المرور',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      _logDebug('✅ البيانات صالحة - إرسال الطلب للخادم...');
      _logDebug('🌐 Endpoint: ${ApiEndpoints.login}');
      _logDebug('📦 Body: ${request.toJson()}');

      // إرسال طلب تسجيل الدخول
      _logDebug('⏳ بدء استدعاء _apiClient.post...');

      late final ApiResponse<LoginResponse> response;
      try {
        response = await _apiClient.post<LoginResponse>(
          endpoint: ApiEndpoints.login,
          body: request.toJson(),
          fromJson: (json) {
            _logDebug('📥 استلام استجابة من الخادم - fromJson() تم استدعاؤه');
            _logDebug('📋 JSON Response Type: ${json.runtimeType}');
            _logDebug('📋 JSON Response: $json');
            return LoginResponse.fromJson(json);
          },
        );

        _logDebug('✅ _apiClient.post اكتمل');
      } catch (e, st) {
        _logError('💥 خطأ في _apiClient.post');
        _logError('❌ نوع الخطأ: ${e.runtimeType}');
        _logError('❌ الخطأ: ${e.toString()}');
        _logError('📚 Stack Trace: $st');
        rethrow;
      }

      _logDebug('📊 نتيجة الطلب: ${response.success ? "نجاح ✅" : "فشل ❌"}');
      _logDebug('📊 Status Code: ${response.statusCode}');

      // إذا نجح تسجيل الدخول، حفظ Tokens وإنشاء جلسة
      if (response.success && response.data != null) {
        final loginResponse = response.data!;

        _logDebug('✅ تسجيل الدخول نجح!');
        _logDebug('👤 User ID: ${loginResponse.userId}');
        _logDebug(
          '🎫 Access Token (أول 30 حرف): ${loginResponse.accessToken.substring(0, 30)}...',
        );
        _logDebug(
          '🔄 Refresh Token (أول 20 حرف): ${loginResponse.refreshToken.substring(0, 20)}...',
        );
        _logDebug('⏱️ Expires In: ${loginResponse.expiresIn} ثانية');

        // حفظ Tokens
        _logDebug('💾 حفظ Tokens في Secure Storage...');
        await _tokenManager.saveTokens(
          accessToken: loginResponse.accessToken,
          refreshToken: loginResponse.refreshToken,
          userId: loginResponse.userId,
          expiresIn: loginResponse.expiresIn,
        );
        _logDebug('✅ تم حفظ Tokens بنجاح');

        // إنشاء جلسة
        _logDebug('🔓 إنشاء جلسة...');
        await _sessionManager.createSession(loginResponse);
        _logDebug('✅ تم إنشاء الجلسة بنجاح');
      } else {
        _logError('❌ فشل تسجيل الدخول');
        _logError('📊 Success: ${response.success}');
        _logError('📊 Status Code: ${response.statusCode}');
        _logError('💬 Error: ${response.error}');
        _logError('🔢 Error Code: ${response.errorCode}');
        _logError('📦 Response Data: ${response.data}');
      }

      return response;
    } catch (e, stackTrace) {
      _logError('💥 استثناء أثناء تسجيل الدخول');
      _logError('❌ الخطأ: ${e.toString()}');
      _logError('📚 Stack Trace: $stackTrace');

      return ApiResponse.error(
        error: 'فشل تسجيل الدخول: ${e.toString()}',
        errorCode: 'LOGIN_FAILED',
        statusCode: 500,
      );
    }
  }

  /// تسجيل رسالة debug
  void _logDebug(String message) {
    // ignore: avoid_print
    print('[AuthService] $message');
  }

  /// تسجيل رسالة خطأ
  void _logError(String message) {
    // ignore: avoid_print
    print('[AuthService ERROR] $message');
  }

  /// تجديد Token
  ///
  /// [refreshToken] - Refresh Token
  /// Returns [ApiResponse<RefreshTokenResponse>]
  Future<ApiResponse<RefreshTokenResponse>> refreshToken(
    String refreshToken,
  ) async {
    try {
      // الحصول على معرف المستخدم
      final userId = await _tokenManager.getUserId();
      if (userId == null || userId.isEmpty) {
        return ApiResponse.error(
          error: 'لم يتم العثور على معرف المستخدم',
          errorCode: 'USER_ID_NOT_FOUND',
          statusCode: 401,
        );
      }

      // إنشاء طلب تجديد Token
      final request = RefreshTokenRequest(
        userId: userId,
        refreshToken: refreshToken,
      );

      // إرسال طلب تجديد Token
      final response = await _apiClient.post<RefreshTokenResponse>(
        endpoint: ApiEndpoints.refreshToken,
        body: request.toJson(),
        fromJson: (json) => RefreshTokenResponse.fromJson(json),
      );

      // إذا نجح التجديد، تحديث Token
      if (response.success && response.data != null) {
        final refreshResponse = response.data!;

        if (refreshResponse.isSuccess) {
          // تحديث Access Token
          await _tokenManager.updateAccessToken(
            refreshResponse.accessToken!,
            expiresIn: refreshResponse.expiresIn,
          );

          // تحديث جلسة
          await _sessionManager.refreshSession(
            refreshResponse.accessToken!,
            expiresIn: refreshResponse.expiresIn,
          );
        }
      }

      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل تجديد الجلسة: ${e.toString()}',
        errorCode: 'REFRESH_FAILED',
        statusCode: 500,
      );
    }
  }

  /// تسجيل الخروج
  ///
  /// Returns [ApiResponse<void>]
  Future<ApiResponse<void>> logout() async {
    try {
      // إرسال طلب تسجيل الخروج للخادم
      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.logout,
        body: {},
      );

      // بغض النظر عن نتيجة الطلب، نقوم بمسح الجلسة المحلية
      await _sessionManager.endSession();
      await _tokenManager.clearTokens();

      return response.success
          ? ApiResponse.success(data: null, message: 'تم تسجيل الخروج بنجاح')
          : response;
    } catch (e) {
      // حتى لو فشل الطلب، نقوم بمسح الجلسة المحلية
      await _sessionManager.endSession();
      await _tokenManager.clearTokens();

      return ApiResponse.success(data: null, message: 'تم تسجيل الخروج محلياً');
    }
  }

  /// التحقق من صلاحية الجلسة الحالية
  ///
  /// Returns [bool] true إذا كانت الجلسة صالحة
  Future<bool> isSessionValid() async {
    return await _sessionManager.isSessionValid();
  }

  /// الحصول على Access Token الحالي
  ///
  /// Returns [String?] Access Token أو null
  Future<String?> getCurrentAccessToken() async {
    return await _tokenManager.getAccessToken();
  }

  /// الحصول على معرف المستخدم الحالي
  ///
  /// Returns [String?] User ID أو null
  Future<String?> getCurrentUserId() async {
    return await _tokenManager.getUserId();
  }

  /// التحقق من تسجيل الدخول
  ///
  /// Returns [bool] true إذا كان المستخدم مسجل الدخول
  bool get isAuthenticated => _sessionManager.isAuthenticated;

  /// الحصول على Session Manager
  SessionManager get sessionManager => _sessionManager;

  /// الحصول على Token Manager
  TokenManager get tokenManager => _tokenManager;
}
