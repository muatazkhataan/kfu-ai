/// نموذج استجابة تسجيل الدخول
///
/// يحتوي على معلومات المستخدم والـ Tokens
class LoginResponse {
  /// معرف المستخدم
  final String userId;

  /// Access Token
  final String accessToken;

  /// Refresh Token
  final String refreshToken;

  /// مدة صلاحية Token (بالثواني)
  final int expiresIn;

  /// نوع Token (عادة "Bearer")
  final String tokenType;

  /// معلومات المستخدم الإضافية
  final Map<String, dynamic>? profile;

  const LoginResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.tokenType = 'Bearer',
    this.profile,
  });

  /// من JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // استخراج معلومات المستخدم
    final profile = <String, dynamic>{
      'userId': json['UserId'] ?? json['userId'],
      'fullName': json['FullName'] ?? json['fullName'],
    };

    return LoginResponse(
      userId: json['UserId'] ?? json['userId'] ?? '',
      accessToken: json['AccessToken'] ?? json['accessToken'] ?? '',
      refreshToken: json['RefreshToken'] ?? json['refreshToken'] ?? '',
      expiresIn: json['ExpiresIn'] ?? json['expiresIn'] ?? 3600,
      tokenType: json['TokenType'] ?? json['tokenType'] ?? 'Bearer',
      profile: json['FullName'] != null
          ? profile
          : (json['Profile'] ?? json['profile']),
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
      'Profile': profile,
    };
  }

  /// التحقق من صحة الاستجابة
  bool get isValid =>
      userId.isNotEmpty && accessToken.isNotEmpty && refreshToken.isNotEmpty;

  /// نسخ مع تعديلات
  LoginResponse copyWith({
    String? userId,
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
    String? tokenType,
    Map<String, dynamic>? profile,
  }) {
    return LoginResponse(
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
      tokenType: tokenType ?? this.tokenType,
      profile: profile ?? this.profile,
    );
  }

  @override
  String toString() {
    return 'LoginResponse(userId: $userId, tokenType: $tokenType, expiresIn: $expiresIn)';
  }
}
