/// أنواع المجلدات
///
/// يحدد هذا التعداد أنواع المجلدات المختلفة في التطبيق
enum FolderType {
  /// مجلد ثابت (لا يمكن حذفه أو تعديله)
  fixed('fixed'),

  /// مجلد مخصص (يمكن للمستخدم إنشاؤه وتعديله)
  custom('custom'),

  /// مجلد نظام (مجلدات خاصة بالنظام)
  system('system'),

  /// مجلد مؤقت (للعمليات المؤقتة)
  temporary('temporary');

  const FolderType(this.value);

  /// القيمة النصية للنوع
  final String value;

  /// التحويل من نص إلى نوع مجلد
  static FolderType fromString(String value) {
    return FolderType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => FolderType.custom,
    );
  }

  /// التحقق من كون المجلد ثابت
  bool get isFixed => this == FolderType.fixed;

  /// التحقق من كون المجلد مخصص
  bool get isCustom => this == FolderType.custom;

  /// التحقق من كون المجلد نظام
  bool get isSystem => this == FolderType.system;

  /// التحقق من كون المجلد مؤقت
  bool get isTemporary => this == FolderType.temporary;

  /// التحقق من إمكانية التعديل
  bool get isEditable => isCustom || isTemporary;

  /// التحقق من إمكانية الحذف
  bool get isDeletable => isCustom || isTemporary;

  /// التحقق من إمكانية تغيير الأيقونة
  bool get isIconChangeable => isCustom || isTemporary;

  /// التحقق من إمكانية إعادة التسمية
  bool get isRenamable => isCustom || isTemporary;
}
