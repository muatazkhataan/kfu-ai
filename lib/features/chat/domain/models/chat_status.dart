/// حالة المحادثة
///
/// يحدد هذا التعداد الحالات المختلفة للمحادثة
enum ChatStatus {
  /// محادثة نشطة
  active('active'),

  /// محادثة مؤرشفة
  archived('archived'),

  /// محادثة محذوفة
  deleted('deleted'),

  /// محادثة مسودة
  draft('draft'),

  /// محادثة مجمدة
  frozen('frozen');

  const ChatStatus(this.value);

  /// القيمة النصية للحالة
  final String value;

  /// التحويل من نص إلى حالة محادثة
  static ChatStatus fromString(String value) {
    return ChatStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ChatStatus.active,
    );
  }

  /// التحقق من كون المحادثة نشطة
  bool get isActive => this == ChatStatus.active;

  /// التحقق من كون المحادثة مؤرشفة
  bool get isArchived => this == ChatStatus.archived;

  /// التحقق من كون المحادثة محذوفة
  bool get isDeleted => this == ChatStatus.deleted;

  /// التحقق من كون المحادثة مسودة
  bool get isDraft => this == ChatStatus.draft;

  /// التحقق من كون المحادثة مجمدة
  bool get isFrozen => this == ChatStatus.frozen;

  /// التحقق من إمكانية التفاعل مع المحادثة
  bool get isInteractive => isActive || isDraft;
}
