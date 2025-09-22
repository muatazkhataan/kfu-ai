import 'message_type.dart';
import 'message_attachment.dart';

/// نموذج الرسالة
///
/// يمثل هذا الكلاس رسالة في المحادثة مع جميع المعلومات المرتبطة بها
class Message {
  /// معرف فريد للرسالة
  final String id;

  /// محتوى الرسالة النصي
  final String content;

  /// نوع الرسالة
  final MessageType type;

  /// معرف المحادثة المرتبطة
  final String chatId;

  /// معرف المستخدم المرسل (إذا كانت من المستخدم)
  final String? senderId;

  /// اسم المرسل (للعرض)
  final String? senderName;

  /// صورة شخصية المرسل
  final String? senderAvatar;

  /// تاريخ إنشاء الرسالة
  final DateTime createdAt;

  /// تاريخ آخر تعديل
  final DateTime? updatedAt;

  /// مرفقات الرسالة
  final List<MessageAttachment> attachments;

  /// حالة الرسالة (مرسلة، مقروءة، فاشلة، إلخ)
  final MessageState state;

  /// معرف الرسالة المرجعية (للرد على رسالة)
  final String? replyToId;

  /// معرف الرسالة المحررة (إذا كانت تعديلاً)
  final String? editOfId;

  /// تاريخ آخر قراءة
  final DateTime? readAt;

  /// هل الرسالة محذوفة
  final bool isDeleted;

  /// تاريخ الحذف
  final DateTime? deletedAt;

  /// سبب الحذف
  final String? deletionReason;

  /// بيانات إضافية (JSON)
  final Map<String, dynamic>? metadata;

  const Message({
    required this.id,
    required this.content,
    required this.type,
    required this.chatId,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.createdAt,
    this.updatedAt,
    this.attachments = const [],
    this.state = MessageState.sent,
    this.replyToId,
    this.editOfId,
    this.readAt,
    this.isDeleted = false,
    this.deletedAt,
    this.deletionReason,
    this.metadata,
  });

  /// إنشاء نسخة من الرسالة مع تعديلات
  Message copyWith({
    String? id,
    String? content,
    MessageType? type,
    String? chatId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MessageAttachment>? attachments,
    MessageState? state,
    String? replyToId,
    String? editOfId,
    DateTime? readAt,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletionReason,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachments: attachments ?? this.attachments,
      state: state ?? this.state,
      replyToId: replyToId ?? this.replyToId,
      editOfId: editOfId ?? this.editOfId,
      readAt: readAt ?? this.readAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      deletionReason: deletionReason ?? this.deletionReason,
      metadata: metadata ?? this.metadata,
    );
  }

  /// التحويل إلى خريطة للتخزين
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'type': type.value,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'attachments': attachments
          .map((attachment) => attachment.toMap())
          .toList(),
      'state': state.value,
      'replyToId': replyToId,
      'editOfId': editOfId,
      'readAt': readAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletionReason': deletionReason,
      'metadata': metadata,
    };
  }

  /// إنشاء من خريطة
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      type: MessageType.fromString(map['type'] ?? ''),
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'],
      senderName: map['senderName'],
      senderAvatar: map['senderAvatar'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
      attachments:
          (map['attachments'] as List<dynamic>?)
              ?.map((attachment) => MessageAttachment.fromMap(attachment))
              .toList() ??
          [],
      state: MessageState.fromString(map['state'] ?? ''),
      replyToId: map['replyToId'],
      editOfId: map['editOfId'],
      readAt: map['readAt'] != null ? DateTime.parse(map['readAt']) : null,
      isDeleted: map['isDeleted'] ?? false,
      deletedAt: map['deletedAt'] != null
          ? DateTime.parse(map['deletedAt'])
          : null,
      deletionReason: map['deletionReason'],
      metadata: map['metadata'],
    );
  }

  /// التحقق من كون الرسالة من المستخدم
  bool get isUserMessage => type.isUser;

  /// التحقق من كون الرسالة من المساعد
  bool get isAssistantMessage => type.isAssistant;

  /// التحقق من كون الرسالة من النظام
  bool get isSystemMessage => type.isSystem;

  /// التحقق من كون الرسالة ترحيبية
  bool get isWelcomeMessage => type.isWelcome;

  /// التحقق من كون الرسالة اقتراح
  bool get isSuggestionMessage => type.isSuggestion;

  /// التحقق من وجود مرفقات
  bool get hasAttachments => attachments.isNotEmpty;

  /// التحقق من كون الرسالة محذوفة
  bool get isDeletedMessage => isDeleted;

  /// التحقق من كون الرسالة مقروءة
  bool get isRead => readAt != null;

  /// التحقق من كون الرسالة رداً على رسالة أخرى
  bool get isReply => replyToId != null;

  /// التحقق من كون الرسالة تعديلاً لرسالة أخرى
  bool get isEdit => editOfId != null;

  /// الحصول على عدد المرفقات
  int get attachmentCount => attachments.length;

  /// الحصول على المرفقات المصورة فقط
  List<MessageAttachment> get imageAttachments =>
      attachments.where((attachment) => attachment.type.isImage).toList();

  /// الحصول على المرفقات الصوتية فقط
  List<MessageAttachment> get audioAttachments =>
      attachments.where((attachment) => attachment.type.isAudio).toList();

  /// الحصول على المرفقات المستندية فقط
  List<MessageAttachment> get documentAttachments =>
      attachments.where((attachment) => attachment.type.isDocument).toList();

  /// التحقق من صحة الرسالة
  bool get isValid => content.isNotEmpty && id.isNotEmpty && chatId.isNotEmpty;

  /// الحصول على معاينة الرسالة (بدون تنسيق)
  String get preview {
    final cleanContent = content
        .replaceAll(RegExp(r'<[^>]*>'), '') // إزالة HTML tags
        .replaceAll(RegExp(r'\n+'), ' ') // استبدال الأسطر المتعددة بمسافة
        .trim();

    return cleanContent.length > 100
        ? '${cleanContent.substring(0, 100)}...'
        : cleanContent;
  }

  /// الحصول على وقت الرسالة بصيغة مقروءة
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} يوم';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Message(id: $id, type: $type, content: ${content.length > 50 ? '${content.substring(0, 50)}...' : content})';
  }
}

/// حالة الرسالة
enum MessageState {
  /// جاري الإرسال
  sending('sending'),

  /// تم الإرسال
  sent('sent'),

  /// تم التسليم
  delivered('delivered'),

  /// تم القراءة
  read('read'),

  /// فشل الإرسال
  failed('failed'),

  /// محذوفة
  deleted('deleted');

  const MessageState(this.value);

  /// القيمة النصية للحالة
  final String value;

  /// التحويل من نص إلى حالة رسالة
  static MessageState fromString(String value) {
    return MessageState.values.firstWhere(
      (state) => state.value == value,
      orElse: () => MessageState.sent,
    );
  }

  /// التحقق من كون الرسالة جارية الإرسال
  bool get isSending => this == MessageState.sending;

  /// التحقق من كون الرسالة مرسلة
  bool get isSent => this == MessageState.sent;

  /// التحقق من كون الرسالة مسلمة
  bool get isDelivered => this == MessageState.delivered;

  /// التحقق من كون الرسالة مقروءة
  bool get isRead => this == MessageState.read;

  /// التحقق من فشل الرسالة
  bool get isFailed => this == MessageState.failed;

  /// التحقق من كون الرسالة محذوفة
  bool get isDeleted => this == MessageState.deleted;
}
