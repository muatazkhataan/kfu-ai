import 'chat_status.dart';
import 'message.dart';

/// نموذج المحادثة
///
/// يمثل هذا الكلاس محادثة كاملة مع جميع المعلومات المرتبطة بها
class Chat {
  /// معرف فريد للمحادثة
  final String id;

  /// عنوان المحادثة
  final String title;

  /// وصف المحادثة (اختياري)
  final String? description;

  /// معرف المستخدم المالك
  final String userId;

  /// معرف المجلد المرتبط
  final String? folderId;

  /// حالة المحادثة
  final ChatStatus status;

  /// تاريخ إنشاء المحادثة
  final DateTime createdAt;

  /// تاريخ آخر تعديل
  final DateTime updatedAt;

  /// تاريخ آخر نشاط
  final DateTime? lastActivityAt;

  /// عدد الرسائل في المحادثة
  final int messageCount;

  /// معرف آخر رسالة
  final String? lastMessageId;

  /// محتوى آخر رسالة (للمعاينة)
  final String? lastMessagePreview;

  /// نوع آخر رسالة
  final String? lastMessageType;

  /// تاريخ آخر رسالة
  final DateTime? lastMessageAt;

  /// معرف المرسل الأخير
  final String? lastSenderId;

  /// اسم المرسل الأخير
  final String? lastSenderName;

  /// هل المحادثة محفوظة في المفضلة
  final bool isFavorite;

  /// هل المحادثة مقيدة
  final bool isPinned;

  /// هل المحادثة مقيدة
  final bool isMuted;

  /// هل المحادثة مقيدة
  final bool isArchived;

  /// معرف المحادثة المرجعية (إذا كانت نسخة)
  final String? originalChatId;

  /// بيانات إضافية (JSON)
  final Map<String, dynamic>? metadata;

  /// قائمة الرسائل (مؤقتة، لا تُحفظ)
  final List<Message>? messages;

  const Chat({
    required this.id,
    required this.title,
    this.description,
    required this.userId,
    this.folderId,
    this.status = ChatStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.lastActivityAt,
    this.messageCount = 0,
    this.lastMessageId,
    this.lastMessagePreview,
    this.lastMessageType,
    this.lastMessageAt,
    this.lastSenderId,
    this.lastSenderName,
    this.isFavorite = false,
    this.isPinned = false,
    this.isMuted = false,
    this.isArchived = false,
    this.originalChatId,
    this.metadata,
    this.messages,
  });

  /// إنشاء نسخة من المحادثة مع تعديلات
  Chat copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    String? folderId,
    ChatStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActivityAt,
    int? messageCount,
    String? lastMessageId,
    String? lastMessagePreview,
    String? lastMessageType,
    DateTime? lastMessageAt,
    String? lastSenderId,
    String? lastSenderName,
    bool? isFavorite,
    bool? isPinned,
    bool? isMuted,
    bool? isArchived,
    String? originalChatId,
    Map<String, dynamic>? metadata,
    List<Message>? messages,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      folderId: folderId ?? this.folderId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      messageCount: messageCount ?? this.messageCount,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      lastSenderName: lastSenderName ?? this.lastSenderName,
      isFavorite: isFavorite ?? this.isFavorite,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
      isArchived: isArchived ?? this.isArchived,
      originalChatId: originalChatId ?? this.originalChatId,
      metadata: metadata ?? this.metadata,
      messages: messages ?? this.messages,
    );
  }

  /// التحويل إلى خريطة للتخزين
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'folderId': folderId,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastActivityAt': lastActivityAt?.toIso8601String(),
      'messageCount': messageCount,
      'lastMessageId': lastMessageId,
      'lastMessagePreview': lastMessagePreview,
      'lastMessageType': lastMessageType,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'lastSenderId': lastSenderId,
      'lastSenderName': lastSenderName,
      'isFavorite': isFavorite,
      'isPinned': isPinned,
      'isMuted': isMuted,
      'isArchived': isArchived,
      'originalChatId': originalChatId,
      'metadata': metadata,
    };
  }

  /// إنشاء من خريطة
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      userId: map['userId'] ?? '',
      folderId: map['folderId'],
      status: ChatStatus.fromString(map['status'] ?? ''),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      lastActivityAt: map['lastActivityAt'] != null
          ? DateTime.parse(map['lastActivityAt'])
          : null,
      messageCount: map['messageCount'] ?? 0,
      lastMessageId: map['lastMessageId'],
      lastMessagePreview: map['lastMessagePreview'],
      lastMessageType: map['lastMessageType'],
      lastMessageAt: map['lastMessageAt'] != null
          ? DateTime.parse(map['lastMessageAt'])
          : null,
      lastSenderId: map['lastSenderId'],
      lastSenderName: map['lastSenderName'],
      isFavorite: map['isFavorite'] ?? false,
      isPinned: map['isPinned'] ?? false,
      isMuted: map['isMuted'] ?? false,
      isArchived: map['isArchived'] ?? false,
      originalChatId: map['originalChatId'],
      metadata: map['metadata'],
    );
  }

  /// إنشاء محادثة جديدة
  factory Chat.create({
    required String title,
    String? description,
    required String userId,
    String? folderId,
  }) {
    final now = DateTime.now();
    return Chat(
      id: _generateId(),
      title: title,
      description: description,
      userId: userId,
      folderId: folderId,
      createdAt: now,
      updatedAt: now,
      lastActivityAt: now,
    );
  }

  /// إنشاء محادثة ترحيبية
  factory Chat.createWelcome({required String userId, String? folderId}) {
    final now = DateTime.now();
    return Chat(
      id: _generateId(),
      title: 'محادثة جديدة',
      description: 'مرحباً بك في مساعد كفو! كيف يمكنني مساعدتك اليوم؟',
      userId: userId,
      folderId: folderId,
      createdAt: now,
      updatedAt: now,
      lastActivityAt: now,
    );
  }

  /// توليد معرف فريد
  static String _generateId() {
    return 'chat_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000).toString().padLeft(3, '0')}';
  }

  /// التحقق من كون المحادثة نشطة
  bool get isActive => status.isActive;

  /// التحقق من كون المحادثة مؤرشفة
  bool get isArchivedStatus => status.isArchived;

  /// التحقق من كون المحادثة محذوفة
  bool get isDeleted => status.isDeleted;

  /// التحقق من كون المحادثة مسودة
  bool get isDraft => status.isDraft;

  /// التحقق من كون المحادثة مجمدة
  bool get isFrozen => status.isFrozen;

  /// التحقق من وجود رسائل
  bool get hasMessages => messageCount > 0;

  /// التحقق من وجود آخر رسالة
  bool get hasLastMessage =>
      lastMessageId != null && lastMessagePreview != null;

  /// التحقق من كون المحادثة في مجلد
  bool get hasFolder => folderId != null && folderId!.isNotEmpty;

  /// التحقق من كون المحادثة مقيدة
  bool get isPinnedChat => isPinned;

  /// التحقق من كون المحادثة صامتة
  bool get isMutedChat => isMuted;

  /// التحقق من كون المحادثة مفضلة
  bool get isFavoriteChat => isFavorite;

  /// التحقق من كون المحادثة نسخة
  bool get isCopy => originalChatId != null;

  /// الحصول على معاينة المحادثة
  String get preview {
    if (hasLastMessage) {
      return lastMessagePreview!;
    } else if (description != null && description!.isNotEmpty) {
      return description!;
    } else {
      return 'محادثة جديدة';
    }
  }

  /// الحصول على وقت آخر نشاط بصيغة مقروءة
  String get formattedLastActivity {
    if (lastActivityAt == null) return 'لم يتم النشاط';

    final now = DateTime.now();
    final difference = now.difference(lastActivityAt!);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} يوم';
    } else {
      return '${lastActivityAt!.day}/${lastActivityAt!.month}/${lastActivityAt!.year}';
    }
  }

  /// الحصول على عدد الرسائل بصيغة مقروءة
  String get formattedMessageCount {
    if (messageCount == 0) return 'لا توجد رسائل';
    if (messageCount == 1) return 'رسالة واحدة';
    if (messageCount == 2) return 'رسالتان';
    if (messageCount <= 10) return '$messageCount رسائل';
    return '$messageCount رسالة';
  }

  /// التحقق من صحة المحادثة
  bool get isValid => id.isNotEmpty && title.isNotEmpty && userId.isNotEmpty;

  /// الحصول على لون الحالة
  String get statusColor {
    switch (status) {
      case ChatStatus.active:
        return 'green';
      case ChatStatus.archived:
        return 'orange';
      case ChatStatus.deleted:
        return 'red';
      case ChatStatus.draft:
        return 'blue';
      case ChatStatus.frozen:
        return 'grey';
    }
  }

  /// الحصول على أيقونة الحالة
  String get statusIcon {
    switch (status) {
      case ChatStatus.active:
        return 'circle';
      case ChatStatus.archived:
        return 'archive';
      case ChatStatus.deleted:
        return 'trash';
      case ChatStatus.draft:
        return 'edit';
      case ChatStatus.frozen:
        return 'snowflake';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chat && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Chat(id: $id, title: $title, status: $status, messageCount: $messageCount)';
  }
}
