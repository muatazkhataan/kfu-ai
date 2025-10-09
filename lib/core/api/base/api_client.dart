import 'package:dio/dio.dart';

import 'api_request.dart';
import 'api_response.dart';
import '../config/api_config.dart';
import '../config/api_headers.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import '../interceptors/retry_interceptor.dart';

/// عميل API الأساسي
///
/// يوفر واجهة موحدة للتواصل مع API باستخدام Dio
/// ويدعم Interceptors للمصادقة والتسجيل وإعادة المحاولة
class ApiClient {
  /// مثيل Dio
  late final Dio _dio;

  /// Auth Interceptor
  final AuthInterceptor? _authInterceptor;

  /// Logging Interceptor
  final LoggingInterceptor? _loggingInterceptor;

  /// Retry Interceptor
  final RetryInterceptor? _retryInterceptor;

  /// Constructor
  ApiClient({
    AuthInterceptor? authInterceptor,
    LoggingInterceptor? loggingInterceptor,
    RetryInterceptor? retryInterceptor,
    BaseOptions? options,
  }) : _authInterceptor = authInterceptor,
       _loggingInterceptor = loggingInterceptor,
       _retryInterceptor = retryInterceptor {
    _dio = Dio(
      options ??
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: ApiConfig.connectTimeoutDuration,
            receiveTimeout: ApiConfig.receiveTimeoutDuration,
            sendTimeout: ApiConfig.sendTimeoutDuration,
            headers: ApiHeaders.defaultHeaders,
            validateStatus: (status) => status != null && status < 500,
          ),
    );

    // إضافة Interceptors
    if (_authInterceptor != null) {
      _dio.interceptors.add(_authInterceptor);
    }
    if (_loggingInterceptor != null) {
      _dio.interceptors.add(_loggingInterceptor);
    }
    if (_retryInterceptor != null) {
      _dio.interceptors.add(_retryInterceptor);
    }
  }

  /// تنفيذ طلب API عام
  ///
  /// [request] - معلومات الطلب
  /// [fromJson] - دالة لتحويل JSON إلى النوع المطلوب
  Future<ApiResponse<T>> execute<T>({
    required ApiRequest request,
    T Function(dynamic)? fromJson,
  }) async {
    // ignore: avoid_print
    print('[ApiClient.execute] 🚀 بدء تنفيذ الطلب');
    // ignore: avoid_print
    print('[ApiClient.execute] 📍 Endpoint: ${request.endpoint}');
    // ignore: avoid_print
    print('[ApiClient.execute] 🔧 Method: ${request.method.value}');

    try {
      // بناء الخيارات
      final options = Options(
        method: request.method.value,
        headers: request.headers,
      );

      // بناء URL مع معاملات الاستعلام
      final uri = _buildUri(request.endpoint, request.queryParameters);

      // ignore: avoid_print
      print('[ApiClient.execute] 🌍 Full URI: $uri');
      // ignore: avoid_print
      print('[ApiClient.execute] 📦 Request Body: ${request.body}');
      // ignore: avoid_print
      print('[ApiClient.execute] ⏳ جاري إرسال الطلب عبر Dio...');

      // تنفيذ الطلب
      final response = await _dio.request<dynamic>(
        uri,
        data: request.body,
        options: options,
      );

      // ignore: avoid_print
      print('[ApiClient.execute] ✅ استلام رد من Dio');
      // ignore: avoid_print
      print('[ApiClient.execute] 📊 Status Code: ${response.statusCode}');
      // ignore: avoid_print
      print(
        '[ApiClient.execute] 📋 Response Data Type: ${response.data.runtimeType}',
      );
      // ignore: avoid_print
      print('[ApiClient.execute] 📋 Response Data: ${response.data}');

      // معالجة الاستجابة
      // ignore: avoid_print
      print('[ApiClient.execute] 🔄 بدء معالجة الاستجابة...');
      final result = _handleResponse<T>(response, fromJson);

      // ignore: avoid_print
      print('[ApiClient.execute] ✅ معالجة الاستجابة اكتملت');
      // ignore: avoid_print
      print('[ApiClient.execute] 📊 Result Success: ${result.success}');

      return result;
    } on DioException catch (e) {
      // ignore: avoid_print
      print('[ApiClient.execute] ⚠️ DioException حدث');
      // ignore: avoid_print
      print('[ApiClient.execute] ❌ Type: ${e.type}');
      // ignore: avoid_print
      print('[ApiClient.execute] ❌ Message: ${e.message}');
      // ignore: avoid_print
      print('[ApiClient.execute] ❌ Response: ${e.response}');

      return _handleDioError<T>(e);
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[ApiClient.execute] 💥 خطأ عام حدث');
      // ignore: avoid_print
      print('[ApiClient.execute] ❌ Error Type: ${e.runtimeType}');
      // ignore: avoid_print
      print('[ApiClient.execute] ❌ Error: $e');
      // ignore: avoid_print
      print('[ApiClient.execute] 📚 Stack: $stackTrace');

      return _handleGenericError<T>(e, stackTrace);
    }
  }

  /// طلب GET
  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return execute<T>(
      request: ApiRequest.get(
        endpoint: endpoint,
        queryParameters: queryParameters,
        headers: headers,
      ),
      fromJson: fromJson,
    );
  }

  /// طلب POST
  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    // ignore: avoid_print
    print('[ApiClient.post] 🚀 بدء طلب POST');
    // ignore: avoid_print
    print('[ApiClient.post] 🌐 Endpoint: $endpoint');
    // ignore: avoid_print
    print('[ApiClient.post] 📦 Body: $body');
    // ignore: avoid_print
    print('[ApiClient.post] 🔧 Headers: $headers');

    try {
      final result = await execute<T>(
        request: ApiRequest.post(
          endpoint: endpoint,
          body: body,
          queryParameters: queryParameters,
          headers: headers,
        ),
        fromJson: fromJson,
      );

      // ignore: avoid_print
      print('[ApiClient.post] ✅ execute() اكتمل');
      // ignore: avoid_print
      print('[ApiClient.post] 📊 Success: ${result.success}');
      // ignore: avoid_print
      print('[ApiClient.post] 📊 Status Code: ${result.statusCode}');

      return result;
    } catch (e, st) {
      // ignore: avoid_print
      print('[ApiClient.post] 💥 خطأ في execute()');
      // ignore: avoid_print
      print('[ApiClient.post] ❌ الخطأ: $e');
      // ignore: avoid_print
      print('[ApiClient.post] 📚 Stack: $st');
      rethrow;
    }
  }

  /// طلب PUT
  Future<ApiResponse<T>> put<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return execute<T>(
      request: ApiRequest.put(
        endpoint: endpoint,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
      ),
      fromJson: fromJson,
    );
  }

  /// طلب DELETE
  Future<ApiResponse<T>> delete<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return execute<T>(
      request: ApiRequest.delete(
        endpoint: endpoint,
        queryParameters: queryParameters,
        headers: headers,
      ),
      fromJson: fromJson,
    );
  }

  /// بناء URI مع معاملات الاستعلام
  String _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    if (queryParameters == null || queryParameters.isEmpty) {
      return endpoint;
    }

    final uri = Uri.parse(endpoint);
    final mergedQueryParams = {...uri.queryParameters, ...queryParameters};

    return Uri(
      path: uri.path,
      queryParameters: mergedQueryParams.isEmpty ? null : mergedQueryParams,
    ).toString();
  }

  /// معالجة الاستجابة الناجحة
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    final statusCode = response.statusCode ?? 500;

    // التحقق من نجاح الطلب
    if (statusCode >= 200 && statusCode < 300) {
      // محاولة تحليل الاستجابة
      try {
        final data = response.data;

        // إذا كانت الاستجابة تحتوي على Success field
        if (data is Map<String, dynamic>) {
          // استخدام ApiResponse.fromJson للتحليل
          return ApiResponse<T>.fromJson(data, fromJson);
        }

        // إذا لم تكن Map، نعتبرها data مباشرة
        final T? parsedData = fromJson != null && data != null
            ? fromJson(data)
            : data as T?;

        return ApiResponse<T>.success(
          data: parsedData!,
          statusCode: statusCode,
        );
      } catch (e) {
        return ApiResponse<T>.error(
          error: 'فشل في تحليل الاستجابة: ${e.toString()}',
          statusCode: statusCode,
          errorCode: 'PARSE_ERROR',
        );
      }
    }

    // معالجة حالات الخطأ
    return _handleErrorResponse<T>(response);
  }

  /// معالجة استجابة الخطأ
  ApiResponse<T> _handleErrorResponse<T>(Response response) {
    final statusCode = response.statusCode ?? 500;
    final data = response.data;

    String errorMessage = 'حدث خطأ غير متوقع';
    String? errorCode;

    // محاولة استخراج رسالة الخطأ من الاستجابة
    if (data is Map<String, dynamic>) {
      errorMessage =
          data['Error'] ??
          data['error'] ??
          data['Message'] ??
          data['message'] ??
          errorMessage;
      errorCode = data['ErrorCode'] ?? data['errorCode'];
    } else if (data is String) {
      errorMessage = data;
    }

    // رسائل خطأ محددة حسب كود الحالة
    if (statusCode == 401) {
      errorMessage = 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.';
      errorCode = 'UNAUTHORIZED';
    } else if (statusCode == 403) {
      errorMessage = 'ليس لديك صلاحية للوصول إلى هذا المورد.';
      errorCode = 'FORBIDDEN';
    } else if (statusCode == 404) {
      errorMessage = 'المورد المطلوب غير موجود.';
      errorCode = 'NOT_FOUND';
    } else if (statusCode == 409) {
      errorMessage = 'حدث تعارض في البيانات.';
      errorCode = 'CONFLICT';
    } else if (statusCode >= 500) {
      errorMessage = 'حدث خطأ في الخادم. يرجى المحاولة مرة أخرى لاحقاً.';
      errorCode = 'SERVER_ERROR';
    }

    return ApiResponse<T>.error(
      error: errorMessage,
      errorCode: errorCode,
      statusCode: statusCode,
    );
  }

  /// معالجة أخطاء Dio
  ApiResponse<T> _handleDioError<T>(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiResponse<T>.error(
        error: 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.',
        errorCode: 'TIMEOUT',
        statusCode: 408,
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return ApiResponse<T>.error(
        error: 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال.',
        errorCode: 'NO_INTERNET',
        statusCode: 0,
      );
    }

    if (error.response != null) {
      return _handleErrorResponse<T>(error.response!);
    }

    return ApiResponse<T>.error(
      error: 'حدث خطأ غير متوقع: ${error.message}',
      errorCode: 'UNKNOWN_ERROR',
      statusCode: 500,
    );
  }

  /// معالجة الأخطاء العامة
  ApiResponse<T> _handleGenericError<T>(Object error, StackTrace stackTrace) {
    return ApiResponse<T>.error(
      error: 'حدث خطأ غير متوقع: ${error.toString()}',
      errorCode: 'EXCEPTION',
      statusCode: 500,
    );
  }

  /// إلغاء جميع الطلبات
  void cancelRequests({String? tag}) {
    _dio.close(force: true);
  }

  /// الحصول على مثيل Dio (للاستخدامات المتقدمة)
  Dio get dio => _dio;
}
