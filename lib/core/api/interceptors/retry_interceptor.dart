import 'package:dio/dio.dart';

import '../config/api_config.dart';

/// Retry Interceptor
///
/// يعيد محاولة الطلبات الفاشلة تلقائياً
class RetryInterceptor extends Interceptor {
  /// عدد محاولات إعادة الطلب
  final int maxRetries;

  /// المدة الزمنية بين المحاولات (بالثواني)
  final Duration retryDelay;

  /// الأخطاء التي يجب إعادة المحاولة عندها
  final List<DioExceptionType> retryableExceptions;

  /// أكواد الحالة التي يجب إعادة المحاولة عندها
  final List<int> retryableStatusCodes;

  RetryInterceptor({
    int? maxRetries,
    Duration? retryDelay,
    List<DioExceptionType>? retryableExceptions,
    List<int>? retryableStatusCodes,
  }) : maxRetries = maxRetries ?? ApiConfig.maxRetries,
       retryDelay = retryDelay ?? const Duration(seconds: 1),
       retryableExceptions =
           retryableExceptions ??
           [
             DioExceptionType.connectionTimeout,
             DioExceptionType.sendTimeout,
             DioExceptionType.receiveTimeout,
             DioExceptionType.connectionError,
           ],
       retryableStatusCodes =
           retryableStatusCodes ?? [408, 429, 500, 502, 503, 504];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // التحقق من إمكانية إعادة المحاولة
    if (_shouldRetry(err)) {
      // الحصول على عدد المحاولات السابقة
      final retriesLeft = _getRetriesLeft(err.requestOptions);

      if (retriesLeft > 0) {
        // تحديث عدد المحاولات المتبقية
        err.requestOptions.extra['retries'] = maxRetries - retriesLeft + 1;

        // الانتظار قبل إعادة المحاولة (Exponential Backoff)
        await Future.delayed(_calculateDelay(maxRetries - retriesLeft + 1));

        try {
          // إعادة محاولة الطلب
          final dio = Dio();
          final response = await dio.request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
              responseType: err.requestOptions.responseType,
              contentType: err.requestOptions.contentType,
              validateStatus: err.requestOptions.validateStatus,
              receiveDataWhenStatusError:
                  err.requestOptions.receiveDataWhenStatusError,
            ),
          );

          return handler.resolve(response);
        } catch (e) {
          // فشلت المحاولة، المتابعة للمحاولة التالية أو الفشل
          if (e is DioException) {
            return onError(e, handler);
          }
        }
      }
    }

    // لا يمكن إعادة المحاولة أو نفدت المحاولات
    return handler.next(err);
  }

  /// التحقق من إمكانية إعادة المحاولة
  bool _shouldRetry(DioException error) {
    // التحقق من نوع الخطأ
    if (retryableExceptions.contains(error.type)) {
      return true;
    }

    // التحقق من كود الحالة
    if (error.response?.statusCode != null &&
        retryableStatusCodes.contains(error.response!.statusCode)) {
      return true;
    }

    return false;
  }

  /// الحصول على عدد المحاولات المتبقية
  int _getRetriesLeft(RequestOptions options) {
    final retriesSoFar = options.extra['retries'] as int? ?? 0;
    return maxRetries - retriesSoFar;
  }

  /// حساب المدة الزمنية قبل إعادة المحاولة (Exponential Backoff)
  Duration _calculateDelay(int retryCount) {
    // Exponential backoff: delay = retryDelay * 2^(retryCount-1)
    final delayMilliseconds =
        retryDelay.inMilliseconds * (1 << (retryCount - 1));
    return Duration(milliseconds: delayMilliseconds);
  }
}
