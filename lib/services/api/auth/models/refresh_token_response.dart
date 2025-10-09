/// نموذج استجابة تجديد Token
///
/// يحتوي على الـ Tokens الجديدة
class RefreshTokenResponse {
  /// معرف المستخدم
  final String? userId;

  /// Access Token الجديد
  final String? accessToken;

  /// Refresh Token الجديد (اختياري)
  final String? refreshToken;

  /// مدة صلاحية Token (بالثواني)
  final int? expiresIn;

  /// نوع Token
  final String? tokenType;

  /// كود الخطأ (في حالة الفشل)
  final String? errorCode;

  /// رسالة الخطأ (في حالة الفشل)
  final String? error;

  const RefreshTokenResponse({
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
    this.errorCode,
    this.error,
  });

  /// من JSON
  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      userId: json['UserId'] ?? json['userId'],
      accessToken: json['AccessToken'] ?? json['accessToken'],
      refreshToken: json['RefreshToken'] ?? json['refreshToken'],
      expiresIn: json['ExpiresIn'] ?? json['expiresIn'],
      tokenType: json['TokenType'] ?? json['tokenType'],
      errorCode: json['ErrorCode'] ?? json['errorCode'],
      error: json['Error'] ?? json['error'],
    );
  }

  /// إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'AccessToken': accessToken,
      'RefreshToken': refreshToken,
      'ExpiresIn': expiresIn,
      'TokenType': tokenType,
      'ErrorCode': errorCode,
      'Error': error,
    };
  }

  /// التحقق من نجاح التجديد
  bool get isSuccess =>
      accessToken != null && accessToken!.isNotEmpty && userId != null;

  /// التحقق من وجود خطأ
  bool get hasError => error != null || errorCode != null || !isSuccess;

  /// نسخ مع تعديلات
  RefreshTokenResponse copyWith({
    String? userId,
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
    String? tokenType,
    String? errorCode,
    String? error,
  }) {
    return RefreshTokenResponse(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
      tokenType: tokenType ?? this.tokenType,
      errorCode: errorCode ?? this.errorCode,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'RefreshTokenResponse(userId: $userId, isSuccess: $isSuccess, error: $error)';
  }
}
