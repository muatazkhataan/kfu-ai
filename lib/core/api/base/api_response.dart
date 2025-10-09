/// نموذج الاستجابة الموحد من API
///
/// يستخدم هذا الكلاس لتوحيد شكل الاستجابات من API
/// مع دعم Generic Type للبيانات
class ApiResponse<T> {
  /// حالة النجاح
  final bool success;

  /// البيانات المرجعة
  final T? data;

  /// رسالة النجاح أو المعلومات
  final String? message;

  /// رسالة الخطأ
  final String? error;

  /// كود الخطأ
  final String? errorCode;

  /// كود حالة HTTP
  final int? statusCode;

  /// بيانات إضافية (metadata)
  final Map<String, dynamic>? metadata;

  /// وقت الاستجابة
  final DateTime timestamp;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.errorCode,
    this.statusCode,
    this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// إنشاء استجابة ناجحة
  factory ApiResponse.success({
    required T data,
    String? message,
    int? statusCode,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode ?? 200,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// إنشاء استجابة خطأ
  factory ApiResponse.error({
    required String error,
    String? errorCode,
    int? statusCode,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      success: false,
      error: error,
      errorCode: errorCode,
      statusCode: statusCode ?? 500,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// إنشاء من JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    // ignore: avoid_print
    print('[ApiResponse.fromJson] 📥 بدء تحليل الاستجابة');
    // ignore: avoid_print
    print('[ApiResponse.fromJson] 📦 JSON Keys: ${json.keys.toList()}');

    // استخراج قيم الخطأ
    final error = json['Error'] ?? json['error'];
    final errorCode = json['ErrorCode'] ?? json['errorCode'];

    // تحديد النجاح:
    // 1. إذا كان هناك حقل Success صريح، استخدمه
    // 2. وإلا، اعتبر الطلب ناجحاً إذا لم يكن هناك خطأ
    final hasExplicitSuccess =
        json.containsKey('Success') || json.containsKey('success');
    final explicitSuccess = json['Success'] ?? json['success'];
    final success = hasExplicitSuccess
        ? (explicitSuccess == true || explicitSuccess == 'true')
        : (error == null || error.toString().isEmpty);

    // ignore: avoid_print
    print('[ApiResponse.fromJson] ✅ Success determined: $success');
    // ignore: avoid_print
    print(
      '[ApiResponse.fromJson]    - hasExplicitSuccess: $hasExplicitSuccess',
    );
    // ignore: avoid_print
    print('[ApiResponse.fromJson]    - error: $error');

    // تحديد البيانات
    // إذا كان هناك حقل Data، استخدمه، وإلا استخدم json نفسه
    final dataJson = json.containsKey('Data') || json.containsKey('data')
        ? (json['Data'] ?? json['data'])
        : json;

    // ignore: avoid_print
    print('[ApiResponse.fromJson] 📊 DataJson type: ${dataJson.runtimeType}');
    // ignore: avoid_print
    print('[ApiResponse.fromJson] 🔄 fromJsonT provided: ${fromJsonT != null}');

    T? parsedData;
    try {
      if (fromJsonT != null && dataJson != null) {
        // ignore: avoid_print
        print('[ApiResponse.fromJson] ⏳ تحليل البيانات باستخدام fromJsonT...');
        parsedData = fromJsonT(dataJson);
        // ignore: avoid_print
        print('[ApiResponse.fromJson] ✅ تم تحليل البيانات بنجاح');
      } else {
        parsedData = dataJson as T?;
      }
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[ApiResponse.fromJson] ❌ خطأ في تحليل البيانات!');
      // ignore: avoid_print
      print('[ApiResponse.fromJson] Error: $e');
      // ignore: avoid_print
      print('[ApiResponse.fromJson] Stack: $stackTrace');
      parsedData = null;
    }

    return ApiResponse<T>(
      success: success,
      data: parsedData,
      message: json['Message'] ?? json['message'],
      error: error,
      errorCode: errorCode,
      statusCode: json['StatusCode'] ?? json['statusCode'],
      metadata: json['Metadata'] ?? json['metadata'],
      timestamp: DateTime.now(),
    );
  }

  /// التحويل إلى JSON
  Map<String, dynamic> toJson([dynamic Function(T)? toJsonT]) {
    return {
      'Success': success,
      'Data': toJsonT != null && data != null ? toJsonT(data as T) : data,
      'Message': message,
      'Error': error,
      'ErrorCode': errorCode,
      'StatusCode': statusCode,
      'Metadata': metadata,
      'Timestamp': timestamp.toIso8601String(),
    };
  }

  /// التحقق من وجود بيانات
  bool get hasData => data != null;

  /// التحقق من وجود خطأ
  bool get hasError => error != null || !success;

  /// الحصول على رسالة الخطأ أو الرسالة العامة
  String? get displayMessage => error ?? message;

  /// نسخ الاستجابة مع تعديلات
  ApiResponse<T> copyWith({
    bool? success,
    T? data,
    String? message,
    String? error,
    String? errorCode,
    int? statusCode,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  }) {
    return ApiResponse<T>(
      success: success ?? this.success,
      data: data ?? this.data,
      message: message ?? this.message,
      error: error ?? this.error,
      errorCode: errorCode ?? this.errorCode,
      statusCode: statusCode ?? this.statusCode,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, statusCode: $statusCode, hasData: $hasData, error: $error)';
  }
}
