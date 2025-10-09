import '../../core/api/base/api_client.dart';
import '../../core/api/base/api_response.dart';
import '../../core/api/interceptors/auth_interceptor.dart';
import '../../core/api/interceptors/logging_interceptor.dart';
import '../../core/api/interceptors/retry_interceptor.dart';
import 'auth/auth_api_service.dart';
import 'auth/token_manager.dart';
import 'auth/session_manager.dart';
import 'chat/chat_api_service.dart';
import 'folder/folder_api_service.dart';
import 'search/search_api_service.dart';

/// مدير API الرئيسي
///
/// يوفر نقطة دخول موحدة لجميع خدمات API في التطبيق
/// ويدير إنشاء وتكوين جميع الخدمات
class ApiManager {
  /// Singleton instance
  static ApiManager? _instance;

  /// API Client
  late final ApiClient _apiClient;

  /// Token Manager
  late final TokenManager _tokenManager;

  /// Session Manager
  late final SessionManager _sessionManager;

  /// Auth API Service
  late final AuthApiService _authService;

  /// Chat API Service
  late final ChatApiService _chatService;

  /// Folder API Service
  late final FolderApiService _folderService;

  /// Search API Service
  late final SearchApiService _searchService;

  /// Private constructor
  ApiManager._internal() {
    _initialize();
  }

  /// الحصول على المثيل الوحيد
  factory ApiManager() {
    _instance ??= ApiManager._internal();
    return _instance!;
  }

  /// إعادة تهيئة الخدمات (للاختبار أو إعادة التعيين)
  static void reset() {
    _instance = null;
  }

  /// تهيئة جميع الخدمات
  void _initialize() {
    // إنشاء Token Manager
    _tokenManager = TokenManager();

    // إنشاء Session Manager
    _sessionManager = SessionManager(tokenManager: _tokenManager);

    // إنشاء Auth Interceptor
    final authInterceptor = AuthInterceptor(
      getAccessToken: () => _tokenManager.getAccessToken(),
      getRefreshToken: () => _tokenManager.getRefreshToken(),
      refreshAccessToken: (refreshToken) async {
        final response = await _authService.refreshToken(refreshToken);
        if (response.success && response.data != null) {
          return response.data!.accessToken;
        }
        return null;
      },
      saveTokens: (accessToken, refreshToken) async {
        await _tokenManager.updateAccessToken(accessToken);
      },
      onRefreshFailed: () async {
        await _sessionManager.endSession();
        await _tokenManager.clearTokens();
        // TODO: Navigate to login screen
      },
    );

    // إنشاء Logging Interceptor
    final loggingInterceptor = LoggingInterceptor();

    // إنشاء Retry Interceptor
    final retryInterceptor = RetryInterceptor();

    // إنشاء API Client مع جميع Interceptors
    _apiClient = ApiClient(
      authInterceptor: authInterceptor,
      loggingInterceptor: loggingInterceptor,
      retryInterceptor: retryInterceptor,
    );

    // إنشاء جميع الخدمات
    _authService = AuthApiService(
      apiClient: _apiClient,
      tokenManager: _tokenManager,
      sessionManager: _sessionManager,
    );

    _chatService = ChatApiService(apiClient: _apiClient);
    _folderService = FolderApiService(apiClient: _apiClient);
    _searchService = SearchApiService(apiClient: _apiClient);
  }

  // ==================== Getters للخدمات ====================

  /// الحصول على Auth Service
  AuthApiService get auth => _authService;

  /// الحصول على Chat Service
  ChatApiService get chat => _chatService;

  /// الحصول على Folder Service
  FolderApiService get folder => _folderService;

  /// الحصول على Search Service
  SearchApiService get search => _searchService;

  /// الحصول على Token Manager
  TokenManager get tokenManager => _tokenManager;

  /// الحصول على Session Manager
  SessionManager get sessionManager => _sessionManager;

  /// الحصول على API Client (للاستخدامات المتقدمة)
  ApiClient get apiClient => _apiClient;

  // ==================== طرق مساعدة ====================

  /// التحقق من تسجيل الدخول
  bool get isAuthenticated => _sessionManager.isAuthenticated;

  /// التحقق من صلاحية الجلسة
  Future<bool> isSessionValid() async {
    return await _sessionManager.isSessionValid();
  }

  /// الحصول على معرف المستخدم الحالي
  Future<String?> getCurrentUserId() async {
    return await _tokenManager.getUserId();
  }

  /// تسجيل الخروج وتنظيف جميع البيانات
  Future<ApiResponse<void>> logout() async {
    return await _authService.logout();
  }

  /// إعادة تحميل الجلسة من التخزين
  Future<void> reloadSession() async {
    await _sessionManager.reloadSession();
  }
}
