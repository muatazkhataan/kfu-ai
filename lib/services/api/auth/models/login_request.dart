/// نموذج طلب تسجيل الدخول
///
/// يحتوي على البيانات المطلوبة لتسجيل الدخول
class LoginRequest {
  /// الرقم الجامعي
  final String studentNumber;

  /// كلمة المرور
  final String password;

  const LoginRequest({required this.studentNumber, required this.password});

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {'StudentNumber': studentNumber, 'Password': password};
  }

  /// التحقق من صحة البيانات
  bool get isValid =>
      studentNumber.isNotEmpty &&
      password.isNotEmpty &&
      studentNumber.length >= 6;

  /// نسخ مع تعديلات
  LoginRequest copyWith({String? studentNumber, String? password}) {
    return LoginRequest(
      studentNumber: studentNumber ?? this.studentNumber,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'LoginRequest(studentNumber: $studentNumber, password: ***)';
  }
}
