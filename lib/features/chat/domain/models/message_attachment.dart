/// مرفقات الرسائل
///
/// يمثل هذا الكلاس المرفقات المختلفة التي يمكن إضافتها للرسائل
class MessageAttachment {
  /// معرف فريد للمرفق
  final String id;

  /// اسم الملف
  final String fileName;

  /// نوع الملف (صورة، صوت، مستند، إلخ)
  final AttachmentType type;

  /// مسار الملف المحلي
  final String? localPath;

  /// رابط الملف الخارجي
  final String? externalUrl;

  /// حجم الملف بالبايت
  final int? fileSize;

  /// تاريخ إنشاء المرفق
  final DateTime createdAt;

  /// تاريخ آخر تعديل
  final DateTime? updatedAt;

  /// وصف المرفق (اختياري)
  final String? description;

  /// معرف الرسالة المرتبطة
  final String messageId;

  const MessageAttachment({
    required this.id,
    required this.fileName,
    required this.type,
    this.localPath,
    this.externalUrl,
    this.fileSize,
    required this.createdAt,
    this.updatedAt,
    this.description,
    required this.messageId,
  });

  /// إنشاء نسخة من المرفق مع تعديلات
  MessageAttachment copyWith({
    String? id,
    String? fileName,
    AttachmentType? type,
    String? localPath,
    String? externalUrl,
    int? fileSize,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    String? messageId,
  }) {
    return MessageAttachment(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      type: type ?? this.type,
      localPath: localPath ?? this.localPath,
      externalUrl: externalUrl ?? this.externalUrl,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      messageId: messageId ?? this.messageId,
    );
  }

  /// التحويل إلى خريطة للتخزين
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileName': fileName,
      'type': type.value,
      'localPath': localPath,
      'externalUrl': externalUrl,
      'fileSize': fileSize,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'description': description,
      'messageId': messageId,
    };
  }

  /// إنشاء من خريطة
  factory MessageAttachment.fromMap(Map<String, dynamic> map) {
    return MessageAttachment(
      id: map['id'] ?? '',
      fileName: map['fileName'] ?? '',
      type: AttachmentType.fromString(map['type'] ?? ''),
      localPath: map['localPath'],
      externalUrl: map['externalUrl'],
      fileSize: map['fileSize'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
      description: map['description'],
      messageId: map['messageId'] ?? '',
    );
  }

  /// التحقق من وجود المرفق محلياً
  bool get hasLocalFile => localPath != null && localPath!.isNotEmpty;

  /// التحقق من وجود المرفق خارجياً
  bool get hasExternalFile => externalUrl != null && externalUrl!.isNotEmpty;

  /// التحقق من صحة المرفق
  bool get isValid => hasLocalFile || hasExternalFile;

  /// الحصول على حجم الملف بصيغة مقروءة
  String get formattedFileSize {
    if (fileSize == null) return 'غير محدد';

    const units = ['B', 'KB', 'MB', 'GB'];
    int unitIndex = 0;
    double size = fileSize!.toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAttachment &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MessageAttachment(id: $id, fileName: $fileName, type: $type)';
  }
}

/// أنواع المرفقات
enum AttachmentType {
  /// صورة
  image('image'),

  /// صوت
  audio('audio'),

  /// فيديو
  video('video'),

  /// مستند
  document('document'),

  /// ملف مضغوط
  archive('archive'),

  /// ملف آخر
  other('other');

  const AttachmentType(this.value);

  /// القيمة النصية للنوع
  final String value;

  /// التحويل من نص إلى نوع مرفق
  static AttachmentType fromString(String value) {
    return AttachmentType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AttachmentType.other,
    );
  }

  /// التحقق من كون المرفق صورة
  bool get isImage => this == AttachmentType.image;

  /// التحقق من كون المرفق صوت
  bool get isAudio => this == AttachmentType.audio;

  /// التحقق من كون المرفق فيديو
  bool get isVideo => this == AttachmentType.video;

  /// التحقق من كون المرفق مستند
  bool get isDocument => this == AttachmentType.document;

  /// الحصول على امتدادات الملفات المقبولة
  List<String> get acceptedExtensions {
    switch (this) {
      case AttachmentType.image:
        return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];
      case AttachmentType.audio:
        return ['mp3', 'wav', 'ogg', 'm4a', 'aac'];
      case AttachmentType.video:
        return ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'];
      case AttachmentType.document:
        return ['pdf', 'doc', 'docx', 'txt', 'rtf', 'odt'];
      case AttachmentType.archive:
        return ['zip', 'rar', '7z', 'tar', 'gz'];
      case AttachmentType.other:
        return [];
    }
  }
}
