/// رؤوس HTTP الثابتة والديناميكية للـ API
///
/// يحتوي على جميع Headers المستخدمة في الطلبات
class ApiHeaders {
  ApiHeaders._(); // Private constructor

  // ==================== Content Types ====================

  /// JSON Content-Type
  static const String contentTypeJson = 'application/json';

  /// Form Data Content-Type
  static const String contentTypeForm = 'application/x-www-form-urlencoded';

  /// Multipart Form Data Content-Type
  static const String contentTypeMultipart = 'multipart/form-data';

  // ==================== Header Keys ====================

  /// مفتاح Content-Type
  static const String contentType = 'Content-Type';

  /// مفتاح Accept
  static const String accept = 'Accept';

  /// مفتاح Authorization
  static const String authorization = 'Authorization';

  /// مفتاح User-Agent
  static const String userAgent = 'User-Agent';

  /// مفتاح Accept-Language
  static const String acceptLanguage = 'Accept-Language';

  /// مفتاح X-App-Version
  static const String appVersion = 'X-App-Version';

  /// مفتاح X-Device-Id
  static const String deviceId = 'X-Device-Id';

  /// مفتاح X-Platform
  static const String platform = 'X-Platform';

  // ==================== Common Headers ====================

  /// Headers الأساسية لجميع الطلبات
  static Map<String, String> get defaultHeaders => {
    contentType: contentTypeJson,
    accept: '*/*',
    userAgent: 'KFU-AI-App/1.0',
  };

  /// Headers للطلبات التي تتطلب JSON
  static Map<String, String> get jsonHeaders => {
    contentType: contentTypeJson,
    accept: contentTypeJson,
  };

  /// Headers للطلبات التي تتطلب Form Data
  static Map<String, String> get formHeaders => {contentType: contentTypeForm};

  /// Headers للطلبات التي تتطلب Multipart
  static Map<String, String> get multipartHeaders => {
    contentType: contentTypeMultipart,
  };

  // ==================== Helper Methods ====================

  /// بناء header المصادقة
  static String buildAuthHeader(String token) {
    return 'Bearer $token';
  }

  /// بناء headers مع Token
  static Map<String, String> withAuth(
    String token, {
    Map<String, String>? additionalHeaders,
  }) {
    return {
      ...defaultHeaders,
      authorization: buildAuthHeader(token),
      if (additionalHeaders != null) ...additionalHeaders,
    };
  }

  /// بناء headers مع اللغة
  static Map<String, String> withLanguage(
    String languageCode, {
    Map<String, String>? additionalHeaders,
  }) {
    return {
      ...defaultHeaders,
      acceptLanguage: languageCode,
      if (additionalHeaders != null) ...additionalHeaders,
    };
  }

  /// بناء headers مع معلومات الجهاز
  static Map<String, String> withDeviceInfo({
    required String version,
    required String deviceId,
    required String platform,
    Map<String, String>? additionalHeaders,
  }) {
    return {
      ...defaultHeaders,
      appVersion: version,
      ApiHeaders.deviceId: deviceId,
      ApiHeaders.platform: platform,
      if (additionalHeaders != null) ...additionalHeaders,
    };
  }

  /// بناء headers كاملة
  static Map<String, String> buildFullHeaders({
    String? token,
    String? languageCode,
    String? version,
    String? deviceId,
    String? platform,
    Map<String, String>? additionalHeaders,
  }) {
    return {
      ...defaultHeaders,
      if (token != null) authorization: buildAuthHeader(token),
      if (languageCode != null) acceptLanguage: languageCode,
      if (version != null) appVersion: version,
      if (deviceId != null) ApiHeaders.deviceId: deviceId,
      if (platform != null) ApiHeaders.platform: platform,
      if (additionalHeaders != null) ...additionalHeaders,
    };
  }
}
