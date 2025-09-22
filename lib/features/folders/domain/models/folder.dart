import 'package:flutter/material.dart';
import 'folder_type.dart';
import 'folder_icon.dart';
import 'folder_permissions.dart';

/// نموذج المجلد
///
/// يمثل هذا الكلاس مجلد في التطبيق مع جميع المعلومات المرتبطة به
class Folder {
  /// معرف فريد للمجلد
  final String id;

  /// اسم المجلد
  final String name;

  /// وصف المجلد (اختياري)
  final String? description;

  /// معرف المستخدم المالك
  final String userId;

  /// نوع المجلد
  final FolderType type;

  /// أيقونة المجلد
  final FolderIcon icon;

  /// صلاحيات المجلد
  final FolderPermissions permissions;

  /// تاريخ إنشاء المجلد
  final DateTime createdAt;

  /// تاريخ آخر تعديل
  final DateTime updatedAt;

  /// عدد المحادثات في المجلد
  final int chatCount;

  /// معرف آخر محادثة
  final String? lastChatId;

  /// عنوان آخر محادثة (للمعاينة)
  final String? lastChatTitle;

  /// تاريخ آخر نشاط
  final DateTime? lastActivityAt;

  /// هل المجلد مقيد
  final bool isPinned;

  /// هل المجلد مخفي
  final bool isHidden;

  /// لون المجلد (اختياري)
  final String? color;

  /// بيانات إضافية (JSON)
  final Map<String, dynamic>? metadata;

  const Folder({
    required this.id,
    required this.name,
    this.description,
    required this.userId,
    this.type = FolderType.custom,
    required this.icon,
    this.permissions = const FolderPermissions(),
    required this.createdAt,
    required this.updatedAt,
    this.chatCount = 0,
    this.lastChatId,
    this.lastChatTitle,
    this.lastActivityAt,
    this.isPinned = false,
    this.isHidden = false,
    this.color,
    this.metadata,
  });

  /// إنشاء نسخة من المجلد مع تعديلات
  Folder copyWith({
    String? id,
    String? name,
    String? description,
    String? userId,
    FolderType? type,
    FolderIcon? icon,
    FolderPermissions? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? chatCount,
    String? lastChatId,
    String? lastChatTitle,
    DateTime? lastActivityAt,
    bool? isPinned,
    bool? isHidden,
    String? color,
    Map<String, dynamic>? metadata,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chatCount: chatCount ?? this.chatCount,
      lastChatId: lastChatId ?? this.lastChatId,
      lastChatTitle: lastChatTitle ?? this.lastChatTitle,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      isPinned: isPinned ?? this.isPinned,
      isHidden: isHidden ?? this.isHidden,
      color: color ?? this.color,
      metadata: metadata ?? this.metadata,
    );
  }

  /// التحويل إلى خريطة للتخزين
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'type': type.value,
      'icon': icon.toMap(),
      'permissions': permissions.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'chatCount': chatCount,
      'lastChatId': lastChatId,
      'lastChatTitle': lastChatTitle,
      'lastActivityAt': lastActivityAt?.toIso8601String(),
      'isPinned': isPinned,
      'isHidden': isHidden,
      'color': color,
      'metadata': metadata,
    };
  }

  /// إنشاء من خريطة
  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      userId: map['userId'] ?? '',
      type: FolderType.fromString(map['type'] ?? ''),
      icon: FolderIcon.fromMap(map['icon'] ?? {}),
      permissions: FolderPermissions.fromMap(map['permissions'] ?? {}),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      chatCount: map['chatCount'] ?? 0,
      lastChatId: map['lastChatId'],
      lastChatTitle: map['lastChatTitle'],
      lastActivityAt: map['lastActivityAt'] != null
          ? DateTime.parse(map['lastActivityAt'])
          : null,
      isPinned: map['isPinned'] ?? false,
      isHidden: map['isHidden'] ?? false,
      color: map['color'],
      metadata: map['metadata'],
    );
  }

  /// إنشاء مجلد جديد
  factory Folder.create({
    required String name,
    String? description,
    required String userId,
    FolderType type = FolderType.custom,
    FolderIcon? icon,
    String? color,
  }) {
    final now = DateTime.now();
    return Folder(
      id: _generateId(),
      name: name,
      description: description,
      userId: userId,
      type: type,
      icon: icon ?? FolderIconManager.getIconById('folder_general')!,
      createdAt: now,
      updatedAt: now,
      color: color,
    );
  }

  /// إنشاء مجلد ثابت
  factory Folder.createFixed({
    required String name,
    required String id,
    required FolderIcon icon,
    String? description,
    String? color,
  }) {
    final now = DateTime.now();
    return Folder(
      id: id,
      name: name,
      description: description,
      userId: 'system',
      type: FolderType.fixed,
      icon: icon,
      permissions: FolderPermissions.system,
      createdAt: now,
      updatedAt: now,
      color: color,
    );
  }

  /// توليد معرف فريد
  static String _generateId() {
    return 'folder_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000).toString().padLeft(3, '0')}';
  }

  /// إنشاء المجلدات الثابتة الافتراضية
  static List<Folder> createDefaultFolders() {
    final now = DateTime.now();
    final defaultIcons = FolderIconManager.getDefaultFolderIcons();

    return [
      // مجلد الشؤون الأكاديمية
      Folder(
        id: 'academic',
        name: 'الشؤون الأكاديمية',
        description: 'مجلد الشؤون الأكاديمية والاستفسارات الدراسية',
        userId: 'system',
        type: FolderType.fixed,
        icon: defaultIcons['academic']!,
        permissions: FolderPermissions.system,
        createdAt: now,
        updatedAt: now,
        color: '#4CAF50',
      ),

      // مجلد الأرشيف
      Folder(
        id: 'archived',
        name: 'الأرشيف',
        description: 'المحادثات المؤرشفة',
        userId: 'system',
        type: FolderType.fixed,
        icon: defaultIcons['archived']!,
        permissions: FolderPermissions.readOnly,
        createdAt: now,
        updatedAt: now,
        color: '#FF9800',
      ),

      // مجلد جميع المحادثات
      Folder(
        id: 'all',
        name: 'جميع المحادثات',
        description: 'جميع المحادثات في التطبيق',
        userId: 'system',
        type: FolderType.system,
        icon: defaultIcons['all']!,
        permissions: FolderPermissions.full,
        createdAt: now,
        updatedAt: now,
        color: '#2196F3',
      ),

      // مجلد البرمجة
      Folder(
        id: 'programming',
        name: 'البرمجة',
        description: 'مجلد مشاريع ومحادثات البرمجة',
        userId: 'system',
        type: FolderType.custom,
        icon: defaultIcons['programming']!,
        permissions: FolderPermissions.full,
        createdAt: now,
        updatedAt: now,
        color: '#9C27B0',
      ),

      // مجلد هياكل البيانات
      Folder(
        id: 'datastructures',
        name: 'هياكل البيانات',
        description: 'مجلد هياكل البيانات والخوارزميات',
        userId: 'system',
        type: FolderType.custom,
        icon: defaultIcons['datastructures']!,
        permissions: FolderPermissions.full,
        createdAt: now,
        updatedAt: now,
        color: '#E91E63',
      ),

      // مجلد الخوارزميات
      Folder(
        id: 'algorithms',
        name: 'الخوارزميات',
        description: 'مجلد الخوارزميات وحل المشاكل',
        userId: 'system',
        type: FolderType.custom,
        icon: defaultIcons['algorithms']!,
        permissions: FolderPermissions.full,
        createdAt: now,
        updatedAt: now,
        color: '#00BCD4',
      ),

      // مجلد قواعد البيانات
      Folder(
        id: 'databases',
        name: 'قواعد البيانات',
        description: 'مجلد قواعد البيانات وإدارة البيانات',
        userId: 'system',
        type: FolderType.custom,
        icon: defaultIcons['databases']!,
        permissions: FolderPermissions.full,
        createdAt: now,
        updatedAt: now,
        color: '#795548',
      ),
    ];
  }

  /// التحقق من كون المجلد ثابت
  bool get isFixed => type.isFixed;

  /// التحقق من كون المجلد مخصص
  bool get isCustom => type.isCustom;

  /// التحقق من كون المجلد نظام
  bool get isSystem => type.isSystem;

  /// التحقق من كون المجلد مؤقت
  bool get isTemporary => type.isTemporary;

  /// التحقق من إمكانية التعديل
  bool get isEditable => type.isEditable && permissions.canManage;

  /// التحقق من إمكانية الحذف
  bool get isDeletable => type.isDeletable && permissions.canManage;

  /// التحقق من إمكانية تغيير الأيقونة
  bool get isIconChangeable => type.isIconChangeable && permissions.canManage;

  /// التحقق من إمكانية إعادة التسمية
  bool get isRenamable => type.isRenamable && permissions.canManage;

  /// التحقق من وجود محادثات
  bool get hasChats => chatCount > 0;

  /// التحقق من وجود آخر محادثة
  bool get hasLastChat => lastChatId != null && lastChatTitle != null;

  /// التحقق من كون المجلد مقيد
  bool get isPinnedFolder => isPinned;

  /// التحقق من كون المجلد مخفي
  bool get isHiddenFolder => isHidden;

  /// التحقق من كون المجلد فارغ
  bool get isEmpty => chatCount == 0;

  /// الحصول على معاينة المجلد
  String get preview {
    if (hasLastChat) {
      return lastChatTitle!;
    } else if (description != null && description!.isNotEmpty) {
      return description!;
    } else {
      return 'مجلد فارغ';
    }
  }

  /// الحصول على عدد المحادثات بصيغة مقروءة
  String get formattedChatCount {
    if (chatCount == 0) return 'لا توجد محادثات';
    if (chatCount == 1) return 'محادثة واحدة';
    if (chatCount == 2) return 'محادثتان';
    if (chatCount <= 10) return '$chatCount محادثات';
    return '$chatCount محادثة';
  }

  /// الحصول على وقت آخر نشاط بصيغة مقروءة
  String get formattedLastActivity {
    if (lastActivityAt == null) return 'لا يوجد نشاط';

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

  /// التحقق من صحة المجلد
  bool get isValid => id.isNotEmpty && name.isNotEmpty && userId.isNotEmpty;

  /// الحصول على لون المجلد
  String get folderColor => color ?? '#2196F3';

  /// الحصول على أيقونة المجلد
  IconData get folderIcon => icon.iconData;

  /// الحصول على اسم فئة الأيقونة
  String get iconCategoryName => icon.category.arabicName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Folder && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Folder(id: $id, name: $name, type: $type, chatCount: $chatCount)';
  }
}
