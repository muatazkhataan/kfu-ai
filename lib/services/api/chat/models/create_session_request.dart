/// نموذج طلب إنشاء جلسة محادثة
///
/// يحتوي على البيانات المطلوبة لإنشاء جلسة محادثة جديدة
class CreateSessionRequest {
  /// عنوان الجلسة
  final String title;

  const CreateSessionRequest({required this.title});

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {'title': title};
  }

  /// التحقق من صحة البيانات
  bool get isValid => title.isNotEmpty && title.trim().isNotEmpty;

  /// نسخ مع تعديلات
  CreateSessionRequest copyWith({String? title}) {
    return CreateSessionRequest(title: title ?? this.title);
  }

  @override
  String toString() {
    return 'CreateSessionRequest(title: $title)';
  }
}
