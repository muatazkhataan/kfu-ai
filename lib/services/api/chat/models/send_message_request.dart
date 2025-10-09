/// نموذج طلب إرسال رسالة
///
/// يحتوي على البيانات المطلوبة لإرسال رسالة في المحادثة
class SendMessageRequest {
  /// معرف الجلسة
  final String sessionId;

  /// محتوى الرسالة
  final String content;

  const SendMessageRequest({required this.sessionId, required this.content});

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {'SessionId': sessionId, 'Content': content};
  }

  /// التحقق من صحة البيانات
  bool get isValid =>
      sessionId.isNotEmpty && content.isNotEmpty && content.trim().isNotEmpty;

  /// نسخ مع تعديلات
  SendMessageRequest copyWith({String? sessionId, String? content}) {
    return SendMessageRequest(
      sessionId: sessionId ?? this.sessionId,
      content: content ?? this.content,
    );
  }

  @override
  String toString() {
    return 'SendMessageRequest(sessionId: $sessionId, contentLength: ${content.length})';
  }
}
