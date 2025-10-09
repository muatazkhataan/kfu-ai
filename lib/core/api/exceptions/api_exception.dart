/// استثناء أساسي لجميع استثناءات التطبيق
///
/// يوفر هذا الكلاس هيكل موحد للاستثناءات في التطبيق
abstract class AppException implements Exception {
  /// رسالة الخطأ
  final String message;

  /// كود الخطأ
  final String? code;

  /// تفاصيل إضافية عن الخطأ
  final dynamic details;

  /// وقت حدوث الخطأ
  final DateTime timestamp;

  AppException(this.message, {this.code, this.details, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return '$runtimeType: $message (code: $code)';
  }
}

/// استثناء API عام
///
/// يستخدم للأخطاء المتعلقة بطلبات API
class ApiException extends AppException {
  /// كود حالة HTTP
  final int? statusCode;

  /// بيانات الاستجابة
  final Map<String, dynamic>? responseData;

  ApiException(
    super.message, {
    this.statusCode,
    this.responseData,
    super.code,
    super.details,
  });

  /// هل الخطأ من جانب العميل (4xx)
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// هل الخطأ من جانب الخادم (5xx)
  bool get isServerError =>
      statusCode != null && statusCode! >= 500 && statusCode! < 600;

  @override
  String toString() {
    return 'ApiException: $message (statusCode: $statusCode, code: $code)';
  }
}

/// استثناء الشبكة
///
/// يستخدم للأخطاء المتعلقة بالاتصال بالشبكة
class NetworkException extends AppException {
  /// نوع خطأ الشبكة
  final NetworkErrorType type;

  NetworkException(
    super.message, {
    this.type = NetworkErrorType.unknown,
    super.code,
    super.details,
  });

  /// إنشاء استثناء عدم توفر الإنترنت
  factory NetworkException.noInternet() {
    return NetworkException(
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال والمحاولة مرة أخرى.',
      type: NetworkErrorType.noInternet,
      code: 'NO_INTERNET',
    );
  }

  /// إنشاء استثناء انتهاء المهلة
  factory NetworkException.timeout() {
    return NetworkException(
      'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.',
      type: NetworkErrorType.timeout,
      code: 'TIMEOUT',
    );
  }

  /// إنشاء استثناء فشل الاتصال
  factory NetworkException.connectionFailed() {
    return NetworkException(
      'فشل الاتصال بالخادم. يرجى المحاولة مرة أخرى لاحقاً.',
      type: NetworkErrorType.connectionFailed,
      code: 'CONNECTION_FAILED',
    );
  }

  @override
  String toString() {
    return 'NetworkException: $message (type: ${type.name})';
  }
}

/// أنواع أخطاء الشبكة
enum NetworkErrorType {
  noInternet,
  timeout,
  connectionFailed,
  sslError,
  unknown,
}

/// استثناء المصادقة
///
/// يستخدم للأخطاء المتعلقة بالمصادقة والتفويض
class AuthException extends AppException {
  /// نوع خطأ المصادقة
  final AuthErrorType type;

  AuthException(
    super.message, {
    this.type = AuthErrorType.unknown,
    super.code,
    super.details,
  });

  /// إنشاء استثناء عدم التفويض (401)
  factory AuthException.unauthorized() {
    return AuthException(
      'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.',
      type: AuthErrorType.unauthorized,
      code: 'UNAUTHORIZED',
    );
  }

  /// إنشاء استثناء ممنوع (403)
  factory AuthException.forbidden() {
    return AuthException(
      'ليس لديك صلاحية للوصول إلى هذا المورد.',
      type: AuthErrorType.forbidden,
      code: 'FORBIDDEN',
    );
  }

  /// إنشاء استثناء بيانات اعتماد غير صالحة
  factory AuthException.invalidCredentials() {
    return AuthException(
      'الرقم الجامعي أو كلمة المرور غير صحيحة.',
      type: AuthErrorType.invalidCredentials,
      code: 'INVALID_CREDENTIALS',
    );
  }

  /// إنشاء استثناء انتهاء صلاحية Token
  factory AuthException.tokenExpired() {
    return AuthException(
      'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.',
      type: AuthErrorType.tokenExpired,
      code: 'TOKEN_EXPIRED',
    );
  }

  /// إنشاء استثناء Token غير صالح
  factory AuthException.invalidToken() {
    return AuthException(
      'جلسة غير صالحة. يرجى تسجيل الدخول مرة أخرى.',
      type: AuthErrorType.invalidToken,
      code: 'INVALID_TOKEN',
    );
  }

  @override
  String toString() {
    return 'AuthException: $message (type: ${type.name})';
  }
}

/// أنواع أخطاء المصادقة
enum AuthErrorType {
  unauthorized,
  forbidden,
  invalidCredentials,
  tokenExpired,
  invalidToken,
  unknown,
}

/// استثناء التحقق من الصحة
///
/// يستخدم للأخطاء المتعلقة بالتحقق من صحة البيانات
class ValidationException extends AppException {
  /// الحقول التي فشل التحقق منها
  final Map<String, String>? fieldErrors;

  ValidationException(
    super.message, {
    this.fieldErrors,
    super.code,
    super.details,
  });

  /// إنشاء استثناء حقل مطلوب
  factory ValidationException.requiredField(String fieldName) {
    return ValidationException(
      'الحقل "$fieldName" مطلوب.',
      code: 'REQUIRED_FIELD',
      fieldErrors: {fieldName: 'هذا الحقل مطلوب'},
    );
  }

  /// إنشاء استثناء تنسيق غير صحيح
  factory ValidationException.invalidFormat(String fieldName, String format) {
    return ValidationException(
      'تنسيق الحقل "$fieldName" غير صحيح. التنسيق المطلوب: $format',
      code: 'INVALID_FORMAT',
      fieldErrors: {fieldName: 'التنسيق غير صحيح'},
    );
  }

  @override
  String toString() {
    return 'ValidationException: $message (fieldErrors: ${fieldErrors?.length ?? 0})';
  }
}

/// استثناء غير موجود (404)
///
/// يستخدم عندما لا يتم العثور على المورد المطلوب
class NotFoundException extends AppException {
  /// نوع المورد غير الموجود
  final String? resourceType;

  /// معرف المورد غير الموجود
  final String? resourceId;

  NotFoundException(
    super.message, {
    this.resourceType,
    this.resourceId,
    super.code,
  });

  /// إنشاء استثناء موحد
  factory NotFoundException.resource(String resourceType, String resourceId) {
    return NotFoundException(
      'لم يتم العثور على $resourceType بالمعرف $resourceId',
      resourceType: resourceType,
      resourceId: resourceId,
      code: 'NOT_FOUND',
    );
  }

  @override
  String toString() {
    return 'NotFoundException: $message (resourceType: $resourceType, resourceId: $resourceId)';
  }
}

/// استثناء تعارض (409)
///
/// يستخدم عند حدوث تعارض في البيانات
class ConflictException extends AppException {
  ConflictException(super.message, {super.code, super.details});

  @override
  String toString() {
    return 'ConflictException: $message';
  }
}

/// استثناء خطأ الخادم (500+)
///
/// يستخدم للأخطاء من جانب الخادم
class ServerException extends AppException {
  /// كود حالة HTTP
  final int? statusCode;

  ServerException(super.message, {this.statusCode, super.code, super.details});

  @override
  String toString() {
    return 'ServerException: $message (statusCode: $statusCode)';
  }
}

/// استثناء الكاش
///
/// يستخدم للأخطاء المتعلقة بالكاش
class CacheException extends AppException {
  CacheException(super.message, {super.code, super.details});

  @override
  String toString() {
    return 'CacheException: $message';
  }
}

/// استثناء التخزين المحلي
///
/// يستخدم للأخطاء المتعلقة بالتخزين المحلي
class StorageException extends AppException {
  StorageException(super.message, {super.code, super.details});

  @override
  String toString() {
    return 'StorageException: $message';
  }
}
