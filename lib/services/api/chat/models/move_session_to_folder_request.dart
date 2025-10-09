/// نموذج طلب نقل جلسة إلى مجلد
///
/// يحتوي على البيانات المطلوبة لنقل جلسة محادثة إلى مجلد معين
class MoveSessionToFolderRequest {
  /// معرف الجلسة
  final String sessionId;

  /// معرف المجلد
  final String folderId;

  const MoveSessionToFolderRequest({
    required this.sessionId,
    required this.folderId,
  });

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {'sessionId': sessionId, 'folderId': folderId};
  }

  /// التحقق من صحة البيانات
  bool get isValid => sessionId.isNotEmpty && folderId.isNotEmpty;

  /// نسخ مع تعديلات
  MoveSessionToFolderRequest copyWith({String? sessionId, String? folderId}) {
    return MoveSessionToFolderRequest(
      sessionId: sessionId ?? this.sessionId,
      folderId: folderId ?? this.folderId,
    );
  }

  @override
  String toString() {
    return 'MoveSessionToFolderRequest(sessionId: $sessionId, folderId: $folderId)';
  }
}
