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
    return FolderDto(
      // API يستخدم "Id" وليس "FolderId"
      folderId: json['Id'] ?? json['FolderId'] ?? json['folderId'] ?? '',
      name: json['Name'] ?? json['name'] ?? '',
      icon: json['Icon'] ?? json['icon'],
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
      metadata:
          json['Metadata'] ??
          json['metadata'] ??
          {
            'iconClass': json['IconClass'] ?? json['iconClass'],
            'color': json['Color'] ?? json['color'],
            'isFixed': json['IsFixed'] ?? json['isFixed'],
          },
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
