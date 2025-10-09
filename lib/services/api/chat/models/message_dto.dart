/// Data Transfer Object للرسالة
///
/// يستخدم لنقل بيانات الرسالة من وإلى API
class MessageDto {
  /// معرف الرسالة
  final String messageId;

  /// محتوى الرسالة
  final String content;

  /// نوع الرسالة (user, assistant, system)
  final String type;

  /// هل الرسالة من المستخدم
  final bool isFromUser;

  /// معرف المرسل
  final String? senderId;

  /// اسم المرسل
  final String? senderName;

  /// تاريخ الإنشاء
  final DateTime createdAt;

  /// معرف الجلسة
  final String? sessionId;

  /// مزود AI (مثل "AI Assistant")
  final String? aiProvider;

  /// وقت الاستجابة
  final int? responseTime;

  /// بيانات إضافية
  final Map<String, dynamic>? metadata;

  const MessageDto({
    required this.messageId,
    required this.content,
    required this.type,
    required this.isFromUser,
    this.senderId,
    this.senderName,
    required this.createdAt,
    this.sessionId,
    this.aiProvider,
    this.responseTime,
    this.metadata,
  });

  /// من JSON
  factory MessageDto.fromJson(Map<String, dynamic> json) {
    // API يرسل IsFromUser لتحديد نوع الرسالة
    final isFromUser = json['IsFromUser'] ?? json['isFromUser'] ?? true;

    // تحديد النوع بناءً على IsFromUser
    final type = isFromUser ? 'user' : 'assistant';

    // تحليل التاريخ
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return DateTime.now();
        }
      }
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      return DateTime.now();
    }

    return MessageDto(
      // API يرسل "Id" وليس "MessageId"
      messageId:
          json['Id'] ??
          json['MessageId'] ??
          json['messageId'] ??
          json['id'] ??
          '',
      content: json['Content'] ?? json['content'] ?? '',
      type: type,
      isFromUser: isFromUser,
      senderId: json['SenderId'] ?? json['senderId'],
      senderName: json['SenderName'] ?? json['senderName'],
      createdAt: parseDate(
        json['Timestamp'] ??
            json['CreatedAt'] ??
            json['createdAt'] ??
            json['timestamp'],
      ),
      sessionId: json['SessionId'] ?? json['sessionId'],
      aiProvider: json['AIProvider'] ?? json['aiProvider'],
      responseTime: json['ResponseTime'] ?? json['responseTime'],
      metadata: json['Metadata'] ?? json['metadata'],
    );
  }

  /// إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'MessageId': messageId,
      'Content': content,
      'Type': type,
      'SenderId': senderId,
      'SenderName': senderName,
      'CreatedAt': createdAt.toIso8601String(),
      'SessionId': sessionId,
      'Metadata': metadata,
    };
  }

  /// التحقق من كون الرسالة من المستخدم
  bool get isUserMessage => isFromUser || type.toLowerCase() == 'user';

  /// التحقق من كون الرسالة من المساعد
  bool get isAssistantMessage =>
      !isFromUser || type.toLowerCase() == 'assistant';

  /// التحقق من كون الرسالة من النظام
  bool get isSystemMessage => type.toLowerCase() == 'system';

  /// التحقق من صحة البيانات
  bool get isValid =>
      messageId.isNotEmpty && content.isNotEmpty && type.isNotEmpty;

  /// نسخ مع تعديلات
  MessageDto copyWith({
    String? messageId,
    String? content,
    String? type,
    bool? isFromUser,
    String? senderId,
    String? senderName,
    DateTime? createdAt,
    String? sessionId,
    String? aiProvider,
    int? responseTime,
    Map<String, dynamic>? metadata,
  }) {
    return MessageDto(
      messageId: messageId ?? this.messageId,
      content: content ?? this.content,
      type: type ?? this.type,
      isFromUser: isFromUser ?? this.isFromUser,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      createdAt: createdAt ?? this.createdAt,
      sessionId: sessionId ?? this.sessionId,
      aiProvider: aiProvider ?? this.aiProvider,
      responseTime: responseTime ?? this.responseTime,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'MessageDto(messageId: $messageId, type: $type, contentLength: ${content.length})';
  }
}
