/// أنواع طرق HTTP المدعومة
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE');

  const HttpMethod(this.value);
  final String value;
}

/// نموذج الطلب الموحد لـ API
///
/// يستخدم هذا الكلاس لتوحيد شكل الطلبات المرسلة لـ API
class ApiRequest {
  /// نقطة النهاية (endpoint)
  final String endpoint;

  /// طريقة HTTP
  final HttpMethod method;

  /// البيانات المرسلة في الطلب (body)
  final Map<String, dynamic>? body;

  /// رؤوس HTTP إضافية
  final Map<String, String>? headers;

  /// معاملات الاستعلام (query parameters)
  final Map<String, dynamic>? queryParameters;

  /// هل يتطلب الطلب مصادقة (Bearer Token)
  final bool requiresAuth;

  /// المهلة الزمنية للطلب (timeout)
  final Duration? timeout;

  /// هل يجب إعادة المحاولة عند الفشل
  final bool enableRetry;

  /// عدد محاولات إعادة الطلب
  final int maxRetries;

  /// هل يجب حفظ الطلب في الكاش
  final bool enableCache;

  /// مدة صلاحية الكاش
  final Duration? cacheDuration;

  const ApiRequest({
    required this.endpoint,
    required this.method,
    this.body,
    this.headers,
    this.queryParameters,
    this.requiresAuth = true,
    this.timeout,
    this.enableRetry = true,
    this.maxRetries = 3,
    this.enableCache = false,
    this.cacheDuration,
  });

  /// إنشاء طلب GET
  factory ApiRequest.get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
    bool enableCache = false,
    Duration? cacheDuration,
  }) {
    return ApiRequest(
      endpoint: endpoint,
      method: HttpMethod.get,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      enableCache: enableCache,
      cacheDuration: cacheDuration,
    );
  }

  /// إنشاء طلب POST
  factory ApiRequest.post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) {
    return ApiRequest(
      endpoint: endpoint,
      method: HttpMethod.post,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// إنشاء طلب PUT
  factory ApiRequest.put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) {
    return ApiRequest(
      endpoint: endpoint,
      method: HttpMethod.put,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// إنشاء طلب DELETE
  factory ApiRequest.delete({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) {
    return ApiRequest(
      endpoint: endpoint,
      method: HttpMethod.delete,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
    );
  }

  /// نسخ الطلب مع تعديلات
  ApiRequest copyWith({
    String? endpoint,
    HttpMethod? method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool? requiresAuth,
    Duration? timeout,
    bool? enableRetry,
    int? maxRetries,
    bool? enableCache,
    Duration? cacheDuration,
  }) {
    return ApiRequest(
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
      body: body ?? this.body,
      headers: headers ?? this.headers,
      queryParameters: queryParameters ?? this.queryParameters,
      requiresAuth: requiresAuth ?? this.requiresAuth,
      timeout: timeout ?? this.timeout,
      enableRetry: enableRetry ?? this.enableRetry,
      maxRetries: maxRetries ?? this.maxRetries,
      enableCache: enableCache ?? this.enableCache,
      cacheDuration: cacheDuration ?? this.cacheDuration,
    );
  }

  @override
  String toString() {
    return 'ApiRequest(${method.value} $endpoint, requiresAuth: $requiresAuth)';
  }
}
