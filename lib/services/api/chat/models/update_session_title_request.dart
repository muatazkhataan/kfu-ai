/// نموذج طلب تحديث عنوان الجلسة
///
/// يحتوي على البيانات المطلوبة لتحديث عنوان جلسة المحادثة
class UpdateSessionTitleRequest {
  /// معرف الجلسة
  final String sessionId;

  /// العنوان الجديد
  final String title;

  const UpdateSessionTitleRequest({
    required this.sessionId,
    required this.title,
  });

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {'sessionId': sessionId, 'title': title};
  }

  /// التحقق من صحة البيانات
  bool get isValid =>
      sessionId.isNotEmpty && title.isNotEmpty && title.trim().isNotEmpty;

  /// نسخ مع تعديلات
  UpdateSessionTitleRequest copyWith({String? sessionId, String? title}) {
    return UpdateSessionTitleRequest(
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
    );
  }

  @override
  String toString() {
    return 'UpdateSessionTitleRequest(sessionId: $sessionId, title: $title)';
  }
}
