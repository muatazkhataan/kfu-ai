/// نموذج طلب تجديد Token
///
/// يحتوي على البيانات المطلوبة لتجديد Token
class RefreshTokenRequest {
  /// معرف المستخدم
  final String userId;

  /// Refresh Token
  final String refreshToken;

  const RefreshTokenRequest({required this.userId, required this.refreshToken});

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {'UserId': userId, 'RefreshToken': refreshToken};
  }

  /// التحقق من صحة البيانات
  bool get isValid => userId.isNotEmpty && refreshToken.isNotEmpty;

  /// نسخ مع تعديلات
  RefreshTokenRequest copyWith({String? userId, String? refreshToken}) {
    return RefreshTokenRequest(
      userId: userId ?? this.userId,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  String toString() {
    return 'RefreshTokenRequest(userId: $userId, refreshToken: ***)';
  }
}
