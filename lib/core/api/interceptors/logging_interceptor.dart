import 'package:dio/dio.dart';
import 'dart:developer' as developer;

import '../config/api_config.dart';

/// Logging Interceptor
///
/// يسجل معلومات الطلبات والاستجابات في وضع Debug
class LoggingInterceptor extends Interceptor {
  /// هل يجب طباعة الطلبات
  final bool logRequests;

  /// هل يجب طباعة الاستجابات
  final bool logResponses;

  /// هل يجب طباعة الأخطاء
  final bool logErrors;

  LoggingInterceptor({
    this.logRequests = true,
    this.logResponses = true,
    this.logErrors = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (ApiConfig.enableLogging && logRequests) {
      _logRequest(options);
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (ApiConfig.enableLogging && logResponses) {
      _logResponse(response);
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (ApiConfig.enableLogging && logErrors) {
      _logError(err);
    }
    return handler.next(err);
  }

  /// تسجيل معلومات الطلب
  void _logRequest(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.writeln('╔═══════════════════════════════════════════════');
    buffer.writeln('║ ➡️ REQUEST: ${options.method} ${options.uri}');
    buffer.writeln('╠═══════════════════════════════════════════════');

    // Headers
    if (options.headers.isNotEmpty) {
      buffer.writeln('║ 📋 Headers:');
      options.headers.forEach((key, value) {
        // إخفاء Authorization Token في السجلات
        if (key.toLowerCase() == 'authorization') {
          buffer.writeln('║   $key: Bearer ***');
        } else {
          buffer.writeln('║   $key: $value');
        }
      });
      buffer.writeln('╠───────────────────────────────────────────────');
    }

    // Query Parameters
    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('║ 🔍 Query Parameters:');
      options.queryParameters.forEach((key, value) {
        buffer.writeln('║   $key: $value');
      });
      buffer.writeln('╠───────────────────────────────────────────────');
    }

    // Body
    if (options.data != null) {
      buffer.writeln('║ 📦 Body:');
      buffer.writeln('║   ${_formatData(options.data)}');
      buffer.writeln('╠───────────────────────────────────────────────');
    }

    buffer.writeln('╚═══════════════════════════════════════════════');

    developer.log(buffer.toString(), name: 'API Request', time: DateTime.now());
  }

  /// تسجيل معلومات الاستجابة
  void _logResponse(Response response) {
    final buffer = StringBuffer();
    buffer.writeln('╔═══════════════════════════════════════════════');
    buffer.writeln(
      '║ ⬅️ RESPONSE: ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    buffer.writeln(
      '║ 📊 Status Code: ${response.statusCode} ${response.statusMessage}',
    );
    buffer.writeln('╠═══════════════════════════════════════════════');

    // Headers
    if (response.headers.map.isNotEmpty) {
      buffer.writeln('║ 📋 Headers:');
      response.headers.map.forEach((key, value) {
        buffer.writeln('║   $key: ${value.join(", ")}');
      });
      buffer.writeln('╠───────────────────────────────────────────────');
    }

    // Data
    if (response.data != null) {
      buffer.writeln('║ 📦 Data:');
      buffer.writeln('║   ${_formatData(response.data)}');
      buffer.writeln('╠───────────────────────────────────────────────');
    }

    buffer.writeln('╚═══════════════════════════════════════════════');

    developer.log(
      buffer.toString(),
      name: 'API Response',
      time: DateTime.now(),
    );
  }

  /// تسجيل معلومات الخطأ
  void _logError(DioException error) {
    final buffer = StringBuffer();
    buffer.writeln('╔═══════════════════════════════════════════════');
    buffer.writeln(
      '║ ❌ ERROR: ${error.requestOptions.method} ${error.requestOptions.uri}',
    );
    buffer.writeln('║ 🔴 Type: ${error.type}');
    buffer.writeln('║ 💬 Message: ${error.message}');
    buffer.writeln('╠═══════════════════════════════════════════════');

    // Response Error
    if (error.response != null) {
      buffer.writeln('║ 📊 Status Code: ${error.response!.statusCode}');
      buffer.writeln('║ 📦 Response Data:');
      buffer.writeln('║   ${_formatData(error.response!.data)}');
    }

    buffer.writeln('╚═══════════════════════════════════════════════');

    developer.log(
      buffer.toString(),
      name: 'API Error',
      time: DateTime.now(),
      error: error,
      stackTrace: error.stackTrace,
    );
  }

  /// تنسيق البيانات للعرض
  String _formatData(dynamic data) {
    try {
      if (data == null) return 'null';
      if (data is String) return data;
      if (data is Map || data is List) {
        return data.toString();
      }
      return data.toString();
    } catch (e) {
      return 'Error formatting data: $e';
    }
  }
}
