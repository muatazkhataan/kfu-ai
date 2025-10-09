import 'package:dio/dio.dart';

/// Auth Interceptor
///
/// يضيف Bearer Token للطلبات التي تتطلب مصادقة
/// ويعالج أخطاء 401 (Unauthorized) بتجديد Token تلقائياً
class AuthInterceptor extends Interceptor {
  /// دالة للحصول على Access Token
  final Future<String?> Function() getAccessToken;

  /// دالة للحصول على Refresh Token
  final Future<String?> Function() getRefreshToken;

  /// دالة لتجديد Token
  final Future<String?> Function(String refreshToken) refreshAccessToken;

  /// دالة لحفظ Tokens الجديدة
  final Future<void> Function(String accessToken, String? refreshToken)?
  saveTokens;

  /// دالة للتعامل مع فشل التجديد (Logout)
  final Future<void> Function()? onRefreshFailed;

  AuthInterceptor({
    required this.getAccessToken,
    required this.getRefreshToken,
    required this.refreshAccessToken,
    this.saveTokens,
    this.onRefreshFailed,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // إضافة Bearer Token للطلبات
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // معالجة 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // محاولة تجديد Token
      final success = await _refreshTokenAndRetry(err, handler);
      if (success) {
        return; // تم التجديد والإعادة بنجاح
      }
    }

    return handler.next(err);
  }

  /// تجديد Token وإعادة محاولة الطلب
  Future<bool> _refreshTokenAndRetry(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      // الحصول على Refresh Token
      final refreshToken = await getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        // لا يوجد Refresh Token - فشل
        await onRefreshFailed?.call();
        return false;
      }

      // محاولة تجديد Access Token
      final newAccessToken = await refreshAccessToken(refreshToken);
      if (newAccessToken == null || newAccessToken.isEmpty) {
        // فشل التجديد
        await onRefreshFailed?.call();
        return false;
      }

      // حفظ Token الجديد
      await saveTokens?.call(newAccessToken, refreshToken);

      // إعادة محاولة الطلب الأصلي مع Token الجديد
      final options = error.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccessToken';

      // تنفيذ الطلب مرة أخرى
      final dio = Dio();
      final response = await dio.request(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: Options(method: options.method, headers: options.headers),
      );

      // إرجاع الاستجابة الجديدة
      return handler.resolve(response) as bool;
    } catch (e) {
      // فشل التجديد
      await onRefreshFailed?.call();
      return false;
    }
  }
}
