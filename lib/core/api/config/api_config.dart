/// إعدادات API الأساسية
///
/// يحتوي على جميع الإعدادات المركزية للـ API
class ApiConfig {
  /// Base URL للـ API
  static const String baseUrl = 'https://kfuai-api.kfu.edu.sa';

  /// إصدار API
  static const String apiVersion = 'v1';

  /// المهلة الزمنية الافتراضية للاتصال (بالثواني)
  static const int connectTimeout = 30;

  /// المهلة الزمنية الافتراضية للاستقبال (بالثواني)
  static const int receiveTimeout = 30;

  /// المهلة الزمنية الافتراضية للإرسال (بالثواني)
  static const int sendTimeout = 30;

  /// عدد محاولات إعادة الطلب الافتراضي
  static const int maxRetries = 3;

  /// مدة صلاحية الكاش الافتراضية (بالدقائق)
  static const int cacheDurationMinutes = 5;

  /// هل يجب طباعة سجلات الطلبات في وضع Debug
  static const bool enableLogging = true;

  /// مفتاح التطبيق (إن وجد)
  static const String? apiKey = null;

  /// حجم الصفحة الافتراضي للبيانات المقسمة
  static const int defaultPageSize = 20;

  /// الحد الأقصى لحجم الملف المرفوع (بالميجابايت)
  static const int maxFileUploadSizeMB = 10;

  /// الحد الأقصى لعدد الملفات المرفقة
  static const int maxAttachmentCount = 5;

  /// الحصول على URL الكامل لنقطة النهاية
  static String getFullUrl(String endpoint) {
    // إزالة الشرطة المائلة من البداية إن وجدت
    final cleanEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;

    return '$baseUrl/$cleanEndpoint';
  }

  /// الحصول على مدة المهلة الزمنية
  static Duration get connectTimeoutDuration =>
      Duration(seconds: connectTimeout);

  static Duration get receiveTimeoutDuration =>
      Duration(seconds: receiveTimeout);

  static Duration get sendTimeoutDuration => Duration(seconds: sendTimeout);

  /// الحصول على مدة صلاحية الكاش
  static Duration get cacheDuration => Duration(minutes: cacheDurationMinutes);

  /// الحصول على الحد الأقصى لحجم الملف بالبايت
  static int get maxFileUploadSizeBytes => maxFileUploadSizeMB * 1024 * 1024;
}
