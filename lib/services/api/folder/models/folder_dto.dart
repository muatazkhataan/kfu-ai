/// Data Transfer Object للمجلد
class FolderDto {
  final String folderId;
  final String name;
  final String? icon;
  final int chatCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const FolderDto({
    required this.folderId,
    required this.name,
    this.icon,
    this.chatCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory FolderDto.fromJson(Map<String, dynamic> json) {
    // استخراج البيانات من المستوى الرئيسي أولاً
    final color = json['Color'] ?? json['color'];
    final isFixed = json['IsFixed'] ?? json['isFixed'] ?? false;
    final iconClass = json['IconClass'] ?? json['iconClass'];
    final icon = json['Icon'] ?? json['icon'];

    // بناء metadata من البيانات المتاحة
    final metadata = <String, dynamic>{};
    if (iconClass != null) {
      metadata['iconClass'] = iconClass;
    }
    if (color != null) {
      metadata['color'] = color;
    }
    metadata['isFixed'] = isFixed;

    // دمج مع metadata الموجود إن وجد
    final existingMetadata = json['Metadata'] ?? json['metadata'];
    if (existingMetadata is Map) {
      metadata.addAll(Map<String, dynamic>.from(existingMetadata));
    }

    return FolderDto(
      // API يستخدم "Id" وليس "FolderId"
      folderId: json['Id'] ?? json['FolderId'] ?? json['folderId'] ?? '',
      name: json['Name'] ?? json['name'] ?? '',
      icon: icon,
      chatCount: json['ChatCount'] ?? json['chatCount'] ?? 0,
      createdAt: json['CreatedAt'] != null
          ? DateTime.parse(json['CreatedAt'])
          : json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['UpdatedAt'] != null
          ? DateTime.parse(json['UpdatedAt'])
          : json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      metadata: metadata.isEmpty ? null : metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FolderId': folderId,
      'Name': name,
      'Icon': icon,
      'ChatCount': chatCount,
      'CreatedAt': createdAt.toIso8601String(),
      'UpdatedAt': updatedAt.toIso8601String(),
      'Metadata': metadata,
    };
  }

  bool get isValid => folderId.isNotEmpty && name.isNotEmpty;
}
