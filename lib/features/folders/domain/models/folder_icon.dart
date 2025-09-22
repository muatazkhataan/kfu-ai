import 'package:flutter/material.dart';
import '../../../../core/theme/icons.dart';

/// إدارة أيقونات المجلدات
///
/// يوفر هذا الكلاس إدارة شاملة لأيقونات المجلدات مع تصنيفها حسب الفئة
class FolderIcon {
  /// معرف الأيقونة
  final String id;

  /// اسم الأيقونة
  final String name;

  /// رمز FontAwesome
  final AppIcon icon;

  /// فئة الأيقونة
  final IconCategory category;

  /// لون الأيقونة (اختياري)
  final String? color;

  /// وصف الأيقونة
  final String? description;

  /// هل الأيقونة متاحة للاستخدام
  final bool isAvailable;

  /// أولوية الأيقونة (للترتيب)
  final int priority;

  const FolderIcon({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    this.color,
    this.description,
    this.isAvailable = true,
    this.priority = 0,
  });

  /// إنشاء نسخة من الأيقونة مع تعديلات
  FolderIcon copyWith({
    String? id,
    String? name,
    AppIcon? icon,
    IconCategory? category,
    String? color,
    String? description,
    bool? isAvailable,
    int? priority,
  }) {
    return FolderIcon(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      color: color ?? this.color,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      priority: priority ?? this.priority,
    );
  }

  /// التحويل إلى خريطة للتخزين
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon.name,
      'category': category.name,
      'color': color,
      'description': description,
      'isAvailable': isAvailable,
      'priority': priority,
    };
  }

  /// إنشاء من خريطة
  factory FolderIcon.fromMap(Map<String, dynamic> map) {
    return FolderIcon(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: AppIcon.values.firstWhere(
        (icon) => icon.name == map['icon'],
        orElse: () => AppIcon.folder,
      ),
      category: IconCategory.values.firstWhere(
        (category) => category.name == map['category'],
        orElse: () => IconCategory.general,
      ),
      color: map['color'],
      description: map['description'],
      isAvailable: map['isAvailable'] ?? true,
      priority: map['priority'] ?? 0,
    );
  }

  /// التحقق من توفر الأيقونة
  bool get isIconAvailable => isAvailable;

  /// الحصول على رمز FontAwesome
  IconData get iconData => AppIcons.getIcon(icon);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderIcon && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FolderIcon(id: $id, name: $name, category: $category)';
  }
}

/// فئات الأيقونات
enum IconCategory {
  /// عام
  general('general'),

  /// البرمجة
  programming('programming'),

  /// الرياضيات
  mathematics('mathematics'),

  /// العلوم
  science('science'),

  /// الدراسة
  study('study'),

  /// الإبداع
  creativity('creativity'),

  /// العمل الجماعي
  collaboration('collaboration'),

  /// النظام
  system('system');

  const IconCategory(this.value);

  /// القيمة النصية للفئة
  final String value;

  /// التحويل من نص إلى فئة أيقونة
  static IconCategory fromString(String value) {
    return IconCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => IconCategory.general,
    );
  }

  /// الحصول على اسم الفئة بالعربية
  String get arabicName {
    switch (this) {
      case IconCategory.general:
        return 'عام';
      case IconCategory.programming:
        return 'البرمجة';
      case IconCategory.mathematics:
        return 'الرياضيات';
      case IconCategory.science:
        return 'العلوم';
      case IconCategory.study:
        return 'الدراسة';
      case IconCategory.creativity:
        return 'الإبداع';
      case IconCategory.collaboration:
        return 'العمل الجماعي';
      case IconCategory.system:
        return 'النظام';
    }
  }

  /// الحصول على أيقونة الفئة
  AppIcon get categoryIcon {
    switch (this) {
      case IconCategory.general:
        return AppIcon.folder;
      case IconCategory.programming:
        return AppIcon.code;
      case IconCategory.mathematics:
        return AppIcon.brain;
      case IconCategory.science:
        return AppIcon.lightbulb;
      case IconCategory.study:
        return AppIcon.book;
      case IconCategory.creativity:
        return AppIcon.palette;
      case IconCategory.collaboration:
        return AppIcon.user;
      case IconCategory.system:
        return AppIcon.settings;
    }
  }
}

/// مدير أيقونات المجلدات
class FolderIconManager {
  FolderIconManager._();

  /// قائمة جميع الأيقونات المتاحة
  static final List<FolderIcon> _allIcons = [
    // أيقونات عامة
    FolderIcon(
      id: 'folder_general',
      name: 'مجلد عادي',
      icon: AppIcon.folder,
      category: IconCategory.general,
      description: 'مجلد عادي للتنظيم',
      priority: 1,
    ),
    FolderIcon(
      id: 'folder_star',
      name: 'مجلد مهم',
      icon: AppIcon.info,
      category: IconCategory.general,
      description: 'مجلد للملفات المهمة',
      priority: 2,
    ),
    FolderIcon(
      id: 'folder_heart',
      name: 'مجلد مفضل',
      icon: AppIcon.info,
      category: IconCategory.general,
      description: 'مجلد للملفات المفضلة',
      priority: 3,
    ),

    // أيقونات البرمجة
    FolderIcon(
      id: 'folder_code',
      name: 'البرمجة',
      icon: AppIcon.code,
      category: IconCategory.programming,
      description: 'مجلد مشاريع البرمجة',
      priority: 1,
    ),
    FolderIcon(
      id: 'folder_database',
      name: 'قواعد البيانات',
      icon: AppIcon.database,
      category: IconCategory.programming,
      description: 'مجلد قواعد البيانات',
      priority: 2,
    ),
    FolderIcon(
      id: 'folder_sitemap',
      name: 'هياكل البيانات',
      icon: AppIcon.sitemap,
      category: IconCategory.programming,
      description: 'مجلد هياكل البيانات',
      priority: 3,
    ),
    FolderIcon(
      id: 'folder_brain',
      name: 'الخوارزميات',
      icon: AppIcon.brain,
      category: IconCategory.programming,
      description: 'مجلد الخوارزميات',
      priority: 4,
    ),

    // أيقونات الدراسة
    FolderIcon(
      id: 'folder_book',
      name: 'الدراسة',
      icon: AppIcon.book,
      category: IconCategory.study,
      description: 'مجلد المواد الدراسية',
      priority: 1,
    ),
    FolderIcon(
      id: 'folder_graduation_cap',
      name: 'الشؤون الأكاديمية',
      icon: AppIcon.graduationCap,
      category: IconCategory.study,
      description: 'مجلد الشؤون الأكاديمية',
      priority: 2,
    ),
    FolderIcon(
      id: 'folder_archive',
      name: 'الأرشيف',
      icon: AppIcon.archive,
      category: IconCategory.study,
      description: 'مجلد الأرشيف',
      priority: 3,
    ),
    FolderIcon(
      id: 'folder_inbox',
      name: 'جميع المحادثات',
      icon: AppIcon.inbox,
      category: IconCategory.study,
      description: 'جميع المحادثات',
      priority: 4,
    ),

    // أيقونات الإبداع
    FolderIcon(
      id: 'folder_palette',
      name: 'الإبداع',
      icon: AppIcon.palette,
      category: IconCategory.creativity,
      description: 'مجلد المشاريع الإبداعية',
      priority: 1,
    ),
    FolderIcon(
      id: 'folder_lightbulb',
      name: 'الأفكار',
      icon: AppIcon.lightbulb,
      category: IconCategory.creativity,
      description: 'مجلد الأفكار والمشاريع',
      priority: 2,
    ),
  ];

  /// الحصول على جميع الأيقونات
  static List<FolderIcon> getAllIcons() => List.unmodifiable(_allIcons);

  /// الحصول على الأيقونات حسب الفئة
  static List<FolderIcon> getIconsByCategory(IconCategory category) {
    return _allIcons.where((icon) => icon.category == category).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// الحصول على أيقونة بالمعرف
  static FolderIcon? getIconById(String id) {
    try {
      return _allIcons.firstWhere((icon) => icon.id == id);
    } catch (e) {
      return null;
    }
  }

  /// الحصول على الأيقونات المتاحة فقط
  static List<FolderIcon> getAvailableIcons() {
    return _allIcons.where((icon) => icon.isAvailable).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// البحث في الأيقونات
  static List<FolderIcon> searchIcons(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _allIcons
        .where(
          (icon) =>
              icon.name.toLowerCase().contains(lowercaseQuery) ||
              icon.description?.toLowerCase().contains(lowercaseQuery) == true,
        )
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// الحصول على الأيقونات الافتراضية للمجلدات الثابتة
  static Map<String, FolderIcon> getDefaultFolderIcons() {
    return {
      'academic': getIconById('folder_graduation_cap')!,
      'archived': getIconById('folder_archive')!,
      'all': getIconById('folder_inbox')!,
      'programming': getIconById('folder_code')!,
      'datastructures': getIconById('folder_sitemap')!,
      'algorithms': getIconById('folder_brain')!,
      'databases': getIconById('folder_database')!,
    };
  }
}
