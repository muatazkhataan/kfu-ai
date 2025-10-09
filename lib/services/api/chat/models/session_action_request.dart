/// نموذج طلب إجراء على جلسة
///
/// يستخدم للعمليات البسيطة على الجلسة مثل الأرشفة والحذف والاستعادة
class SessionActionRequest {
  /// معرف الجلسة
  final String sessionId;

  const SessionActionRequest({required this.sessionId});

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {'sessionId': sessionId};
  }

  /// التحقق من صحة البيانات
  bool get isValid => sessionId.isNotEmpty;

  /// نسخ مع تعديلات
  SessionActionRequest copyWith({String? sessionId}) {
    return SessionActionRequest(sessionId: sessionId ?? this.sessionId);
  }

  @override
  String toString() {
    return 'SessionActionRequest(sessionId: $sessionId)';
  }
}
