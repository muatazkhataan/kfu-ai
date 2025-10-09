import 'message_dto.dart';

/// Data Transfer Object لجلسة المحادثة
///
/// يستخدم لنقل بيانات الجلسة من وإلى API
class SessionDto {
  /// معرف الجلسة
  final String sessionId;

  /// عنوان الجلسة
  final String title;

  /// تاريخ الإنشاء
  final DateTime createdAt;

  /// تاريخ آخر تحديث
  final DateTime updatedAt;

  /// معرف المجلد (اختياري)
  final String? folderId;

  /// هل الجلسة مؤرشفة
  final bool isArchived;

  /// قائمة الرسائل (اختيارية)
  final List<MessageDto>? messages;

  /// عدد الرسائل
  final int? messageCount;

  /// بيانات إضافية
  final Map<String, dynamic>? metadata;

  const SessionDto({
    required this.sessionId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.folderId,
    this.isArchived = false,
    this.messages,
    this.messageCount,
    this.metadata,
  });

  /// من JSON
  factory SessionDto.fromJson(Map<String, dynamic> json) {
    // معالجة التواريخ - يدعم ISO String و Timestamp
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) return DateTime.parse(value);
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      return DateTime.now();
    }

    return SessionDto(
      // API يستخدم "Id" وليس "SessionId"
      sessionId:
          json['Id'] ??
          json['SessionId'] ??
          json['sessionId'] ??
          json['id'] ??
          '',
      title: json['Title'] ?? json['title'] ?? '',
      createdAt: parseDate(json['CreatedAt'] ?? json['createdAt']),
      updatedAt: parseDate(json['UpdatedAt'] ?? json['updatedAt']),
      folderId: json['FolderId'] ?? json['folderId'],
      isArchived: json['IsArchived'] ?? json['isArchived'] ?? false,
      messages: json['Messages'] != null || json['messages'] != null
          ? ((json['Messages'] ?? json['messages']) as List<dynamic>)
                .map((m) => MessageDto.fromJson(m as Map<String, dynamic>))
                .toList()
          : null,
      messageCount: json['MessageCount'] ?? json['messageCount'],
      metadata:
          json['Metadata'] ??
          json['metadata'] ??
          {'firstMessage': json['FirstMessage'] ?? json['firstMessage']},
    );
  }

  /// إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'SessionId': sessionId,
      'Title': title,
      'CreatedAt': createdAt.toIso8601String(),
      'UpdatedAt': updatedAt.toIso8601String(),
      'FolderId': folderId,
      'IsArchived': isArchived,
      'Messages': messages?.map((m) => m.toJson()).toList(),
      'MessageCount': messageCount,
      'Metadata': metadata,
    };
  }

  /// التحقق من صحة البيانات
  bool get isValid => sessionId.isNotEmpty && title.isNotEmpty;

  /// نسخ مع تعديلات
  SessionDto copyWith({
    String? sessionId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? folderId,
    bool? isArchived,
    List<MessageDto>? messages,
    int? messageCount,
    Map<String, dynamic>? metadata,
  }) {
    return SessionDto(
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      folderId: folderId ?? this.folderId,
      isArchived: isArchived ?? this.isArchived,
      messages: messages ?? this.messages,
      messageCount: messageCount ?? this.messageCount,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'SessionDto(sessionId: $sessionId, title: $title, messageCount: ${messages?.length ?? messageCount ?? 0})';
  }
}
