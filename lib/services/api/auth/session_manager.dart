import 'models/login_response.dart';
import 'token_manager.dart';

/// مدير الجلسة
///
/// يدير حالة الجلسة الحالية للمستخدم
class SessionManager {
  /// Token Manager
  final TokenManager _tokenManager;

  /// حالة الجلسة الحالية
  SessionState _currentState = SessionState.unauthenticated;

  /// معلومات المستخدم الحالي
  Map<String, dynamic>? _userProfile;

  /// Constructor
  SessionManager({TokenManager? tokenManager})
    : _tokenManager = tokenManager ?? TokenManager();

  /// الحصول على حالة الجلسة
  SessionState get currentState => _currentState;

  /// الحصول على معلومات المستخدم
  Map<String, dynamic>? get userProfile => _userProfile;

  /// التحقق من تسجيل الدخول
  bool get isAuthenticated => _currentState == SessionState.authenticated;

  /// إنشاء جلسة جديدة
  Future<void> createSession(LoginResponse loginResponse) async {
    try {
      // حفظ Tokens
      await _tokenManager.saveTokens(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
        userId: loginResponse.userId,
        expiresIn: loginResponse.expiresIn,
      );

      // حفظ معلومات المستخدم
      _userProfile = loginResponse.profile;

      // تحديث حالة الجلسة
      _currentState = SessionState.authenticated;
    } catch (e) {
      _currentState = SessionState.error;
      throw SessionException('فشل إنشاء الجلسة: ${e.toString()}');
    }
  }

  /// التحقق من صلاحية الجلسة
  Future<bool> isSessionValid() async {
    try {
      // التحقق من وجود Tokens
      final hasTokens = await _tokenManager.hasTokens();
      if (!hasTokens) {
        _currentState = SessionState.unauthenticated;
        return false;
      }

      // التحقق من صلاحية Token
      final isValid = await _tokenManager.isTokenValid();
      if (!isValid) {
        _currentState = SessionState.expired;
        return false;
      }

      _currentState = SessionState.authenticated;
      return true;
    } catch (e) {
      _currentState = SessionState.error;
      return false;
    }
  }

  /// إنهاء الجلسة (Logout)
  Future<void> endSession() async {
    try {
      // حذف Tokens
      await _tokenManager.clearTokens();

      // مسح معلومات المستخدم
      _userProfile = null;

      // تحديث حالة الجلسة
      _currentState = SessionState.unauthenticated;
    } catch (e) {
      _currentState = SessionState.error;
      throw SessionException('فشل إنهاء الجلسة: ${e.toString()}');
    }
  }

  /// تحديث معلومات المستخدم
  Future<void> updateUserProfile(Map<String, dynamic> profile) async {
    _userProfile = profile;
  }

  /// الحصول على معرف المستخدم
  Future<String?> getUserId() async {
    return await _tokenManager.getUserId();
  }

  /// التحقق من انتهاء صلاحية الجلسة
  Future<bool> isSessionExpired() async {
    return await _tokenManager.isTokenExpired();
  }

  /// تحديث Access Token
  Future<void> refreshSession(String newAccessToken, {int? expiresIn}) async {
    await _tokenManager.updateAccessToken(newAccessToken, expiresIn: expiresIn);
    _currentState = SessionState.authenticated;
  }

  /// إعادة تحميل الجلسة من التخزين
  Future<void> reloadSession() async {
    final tokenInfo = await _tokenManager.getTokenInfo();
    if (tokenInfo != null && tokenInfo.isValid) {
      _currentState = SessionState.authenticated;
    } else {
      _currentState = SessionState.unauthenticated;
    }
  }
}

/// حالات الجلسة
enum SessionState {
  /// غير مصادق (لم يسجل الدخول)
  unauthenticated,

  /// مصادق (مسجل الدخول)
  authenticated,

  /// منتهية الصلاحية
  expired,

  /// خطأ
  error,
}

/// استثناء الجلسة
class SessionException implements Exception {
  final String message;

  SessionException(this.message);

  @override
  String toString() => 'SessionException: $message';
}
