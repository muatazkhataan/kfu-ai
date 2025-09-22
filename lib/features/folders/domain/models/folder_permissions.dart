/// صلاحيات المجلدات
///
/// يحدد هذا الكلاس الصلاحيات المختلفة للمجلدات
class FolderPermissions {
  /// هل يمكن قراءة المحتويات
  final bool canRead;

  /// هل يمكن إنشاء محادثات جديدة
  final bool canCreate;

  /// هل يمكن تعديل المحادثات الموجودة
  final bool canEdit;

  /// هل يمكن حذف المحادثات
  final bool canDelete;

  /// هل يمكن نقل المحادثات
  final bool canMove;

  /// هل يمكن نسخ المحادثات
  final bool canCopy;

  /// هل يمكن مشاركة المحادثات
  final bool canShare;

  /// هل يمكن تصدير المحادثات
  final bool canExport;

  /// هل يمكن إدارة المجلد نفسه
  final bool canManage;

  const FolderPermissions({
    this.canRead = true,
    this.canCreate = true,
    this.canEdit = true,
    this.canDelete = true,
    this.canMove = true,
    this.canCopy = true,
    this.canShare = true,
    this.canExport = true,
    this.canManage = false,
  });

  /// إنشاء نسخة من الصلاحيات مع تعديلات
  FolderPermissions copyWith({
    bool? canRead,
    bool? canCreate,
    bool? canEdit,
    bool? canDelete,
    bool? canMove,
    bool? canCopy,
    bool? canShare,
    bool? canExport,
    bool? canManage,
  }) {
    return FolderPermissions(
      canRead: canRead ?? this.canRead,
      canCreate: canCreate ?? this.canCreate,
      canEdit: canEdit ?? this.canEdit,
      canDelete: canDelete ?? this.canDelete,
      canMove: canMove ?? this.canMove,
      canCopy: canCopy ?? this.canCopy,
      canShare: canShare ?? this.canShare,
      canExport: canExport ?? this.canExport,
      canManage: canManage ?? this.canManage,
    );
  }

  /// التحويل إلى خريطة للتخزين
  Map<String, dynamic> toMap() {
    return {
      'canRead': canRead,
      'canCreate': canCreate,
      'canEdit': canEdit,
      'canDelete': canDelete,
      'canMove': canMove,
      'canCopy': canCopy,
      'canShare': canShare,
      'canExport': canExport,
      'canManage': canManage,
    };
  }

  /// إنشاء من خريطة
  factory FolderPermissions.fromMap(Map<String, dynamic> map) {
    return FolderPermissions(
      canRead: map['canRead'] ?? true,
      canCreate: map['canCreate'] ?? true,
      canEdit: map['canEdit'] ?? true,
      canDelete: map['canDelete'] ?? true,
      canMove: map['canMove'] ?? true,
      canCopy: map['canCopy'] ?? true,
      canShare: map['canShare'] ?? true,
      canExport: map['canExport'] ?? true,
      canManage: map['canManage'] ?? false,
    );
  }

  /// صلاحيات القراءة فقط
  static const FolderPermissions readOnly = FolderPermissions(
    canRead: true,
    canCreate: false,
    canEdit: false,
    canDelete: false,
    canMove: false,
    canCopy: true,
    canShare: false,
    canExport: false,
    canManage: false,
  );

  /// صلاحيات كاملة
  static const FolderPermissions full = FolderPermissions(
    canRead: true,
    canCreate: true,
    canEdit: true,
    canDelete: true,
    canMove: true,
    canCopy: true,
    canShare: true,
    canExport: true,
    canManage: true,
  );

  /// صلاحيات محدودة
  static const FolderPermissions limited = FolderPermissions(
    canRead: true,
    canCreate: true,
    canEdit: false,
    canDelete: false,
    canMove: false,
    canCopy: true,
    canShare: false,
    canExport: false,
    canManage: false,
  );

  /// صلاحيات النظام (ثابتة)
  static const FolderPermissions system = FolderPermissions(
    canRead: true,
    canCreate: false,
    canEdit: false,
    canDelete: false,
    canMove: false,
    canCopy: false,
    canShare: false,
    canExport: false,
    canManage: false,
  );

  /// التحقق من وجود أي صلاحيات
  bool get hasAnyPermissions =>
      canRead ||
      canCreate ||
      canEdit ||
      canDelete ||
      canMove ||
      canCopy ||
      canShare ||
      canExport ||
      canManage;

  /// التحقق من وجود صلاحيات التعديل
  bool get hasEditPermissions => canEdit || canDelete || canMove;

  /// التحقق من وجود صلاحيات الإدارة
  bool get hasManagementPermissions => canManage;

  /// التحقق من وجود صلاحيات المشاركة
  bool get hasSharingPermissions => canShare || canExport || canCopy;

  /// دمج صلاحيات مع صلاحيات أخرى
  FolderPermissions merge(FolderPermissions other) {
    return FolderPermissions(
      canRead: canRead && other.canRead,
      canCreate: canCreate && other.canCreate,
      canEdit: canEdit && other.canEdit,
      canDelete: canDelete && other.canDelete,
      canMove: canMove && other.canMove,
      canCopy: canCopy && other.canCopy,
      canShare: canShare && other.canShare,
      canExport: canExport && other.canExport,
      canManage: canManage && other.canManage,
    );
  }

  /// إضافة صلاحيات إلى صلاحيات أخرى
  FolderPermissions add(FolderPermissions other) {
    return FolderPermissions(
      canRead: canRead || other.canRead,
      canCreate: canCreate || other.canCreate,
      canEdit: canEdit || other.canEdit,
      canDelete: canDelete || other.canDelete,
      canMove: canMove || other.canMove,
      canCopy: canCopy || other.canCopy,
      canShare: canShare || other.canShare,
      canExport: canExport || other.canExport,
      canManage: canManage || other.canManage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderPermissions &&
          runtimeType == other.runtimeType &&
          canRead == other.canRead &&
          canCreate == other.canCreate &&
          canEdit == other.canEdit &&
          canDelete == other.canDelete &&
          canMove == other.canMove &&
          canCopy == other.canCopy &&
          canShare == other.canShare &&
          canExport == other.canExport &&
          canManage == other.canManage;

  @override
  int get hashCode {
    return Object.hash(
      canRead,
      canCreate,
      canEdit,
      canDelete,
      canMove,
      canCopy,
      canShare,
      canExport,
      canManage,
    );
  }

  @override
  String toString() {
    return 'FolderPermissions(canRead: $canRead, canCreate: $canCreate, canEdit: $canEdit, canDelete: $canDelete, canMove: $canMove, canCopy: $canCopy, canShare: $canShare, canExport: $canExport, canManage: $canManage)';
  }
}
