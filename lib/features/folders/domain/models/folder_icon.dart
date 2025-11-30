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
    // ========== أيقونات عامة ==========
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
      name: 'نجمة',
      icon: AppIcon.star,
      category: IconCategory.general,
      description: 'مجلد مهم',
      priority: 2,
    ),
    FolderIcon(
      id: 'folder_heart',
      name: 'قلب',
      icon: AppIcon.heart,
      category: IconCategory.general,
      description: 'مجلد مفضل',
      priority: 3,
    ),
    FolderIcon(
      id: 'folder_home',
      name: 'الرئيسية',
      icon: AppIcon.home,
      category: IconCategory.general,
      description: 'المجلد الرئيسي',
      priority: 4,
    ),
    FolderIcon(
      id: 'folder_thumbtack',
      name: 'مثبت',
      icon: AppIcon.thumbtack,
      category: IconCategory.general,
      description: 'مجلد مثبت',
      priority: 5,
    ),
    FolderIcon(
      id: 'folder_folder_plus',
      name: 'إضافة مجلد',
      icon: AppIcon.folderPlus,
      category: IconCategory.general,
      description: 'إضافة مجلد جديد',
      priority: 6,
    ),
    FolderIcon(
      id: 'folder_folder_open',
      name: 'مجلد مفتوح',
      icon: AppIcon.folderOpen,
      category: IconCategory.general,
      description: 'مجلد مفتوح',
      priority: 7,
    ),

    // معرفات قديمة للتوافق مع getDefaultFolderIcons
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

    // ========== البرمجة والتقنية ==========
    FolderIcon(
      id: 'icon_code',
      name: 'كود',
      icon: AppIcon.code,
      category: IconCategory.programming,
      description: 'البرمجة',
      priority: 5,
    ),
    FolderIcon(
      id: 'icon_laptop_code',
      name: 'لابتوب كود',
      icon: AppIcon.laptopCode,
      category: IconCategory.programming,
      description: 'برمجة لابتوب',
      priority: 2,
    ),
    FolderIcon(
      id: 'icon_terminal',
      name: 'طرفية',
      icon: AppIcon.terminal,
      category: IconCategory.programming,
      description: 'سطر الأوامر',
      priority: 3,
    ),
    FolderIcon(
      id: 'icon_bug',
      name: 'خطأ برمجي',
      icon: AppIcon.bug,
      category: IconCategory.programming,
      description: 'تصحيح الأخطاء',
      priority: 4,
    ),
    FolderIcon(
      id: 'icon_cogs',
      name: 'إعدادات',
      icon: AppIcon.cogs,
      category: IconCategory.programming,
      description: 'إعدادات النظام',
      priority: 5,
    ),
    FolderIcon(
      id: 'icon_microchip',
      name: 'معالج',
      icon: AppIcon.microchip,
      category: IconCategory.programming,
      description: 'المعالجات',
      priority: 6,
    ),
    FolderIcon(
      id: 'icon_server',
      name: 'خادم',
      icon: AppIcon.server,
      category: IconCategory.programming,
      description: 'الخوادم',
      priority: 7,
    ),
    FolderIcon(
      id: 'icon_network_wired',
      name: 'شبكة',
      icon: AppIcon.networkWired,
      category: IconCategory.programming,
      description: 'الشبكات',
      priority: 8,
    ),
    FolderIcon(
      id: 'icon_shield_alt',
      name: 'حماية',
      icon: AppIcon.shieldAlt,
      category: IconCategory.programming,
      description: 'الأمان',
      priority: 9,
    ),
    FolderIcon(
      id: 'icon_key',
      name: 'مفتاح',
      icon: AppIcon.key,
      category: IconCategory.programming,
      description: 'المفاتيح',
      priority: 10,
    ),
    FolderIcon(
      id: 'icon_database',
      name: 'قاعدة بيانات',
      icon: AppIcon.database,
      category: IconCategory.programming,
      description: 'قواعد البيانات',
      priority: 15,
    ),
    FolderIcon(
      id: 'icon_table',
      name: 'جدول',
      icon: AppIcon.table,
      category: IconCategory.programming,
      description: 'الجداول',
      priority: 12,
    ),
    FolderIcon(
      id: 'icon_chart_bar',
      name: 'رسم بياني',
      icon: AppIcon.chartBar,
      category: IconCategory.programming,
      description: 'الرسوم البيانية',
      priority: 13,
    ),
    FolderIcon(
      id: 'icon_mobile_alt',
      name: 'جوال',
      icon: AppIcon.mobileAlt,
      category: IconCategory.programming,
      description: 'تطبيقات الجوال',
      priority: 14,
    ),
    FolderIcon(
      id: 'icon_globe',
      name: 'عالمي',
      icon: AppIcon.globe,
      category: IconCategory.programming,
      description: 'الويب',
      priority: 15,
    ),
    FolderIcon(
      id: 'icon_cloud',
      name: 'سحابة',
      icon: AppIcon.cloud,
      category: IconCategory.programming,
      description: 'الحوسبة السحابية',
      priority: 16,
    ),
    FolderIcon(
      id: 'icon_robot',
      name: 'روبوت',
      icon: AppIcon.robot,
      category: IconCategory.programming,
      description: 'الذكاء الاصطناعي',
      priority: 17,
    ),
    FolderIcon(
      id: 'icon_brain',
      name: 'دماغ',
      icon: AppIcon.brain,
      category: IconCategory.programming,
      description: 'الخوارزميات',
      priority: 22,
    ),
    FolderIcon(
      id: 'icon_sitemap',
      name: 'خريطة موقع',
      icon: AppIcon.sitemap,
      category: IconCategory.programming,
      description: 'هياكل البيانات',
      priority: 23,
    ),
    FolderIcon(
      id: 'icon_project_diagram',
      name: 'مخطط مشروع',
      icon: AppIcon.projectDiagram,
      category: IconCategory.programming,
      description: 'مخططات المشاريع',
      priority: 20,
    ),
    FolderIcon(
      id: 'icon_file_code',
      name: 'ملف كود',
      icon: AppIcon.fileCode,
      category: IconCategory.programming,
      description: 'ملفات الكود',
      priority: 21,
    ),
    FolderIcon(
      id: 'icon_code_branch',
      name: 'فرع كود',
      icon: AppIcon.codeBranch,
      category: IconCategory.programming,
      description: 'فروع الكود',
      priority: 22,
    ),
    FolderIcon(
      id: 'icon_code_merge',
      name: 'دمج كود',
      icon: AppIcon.codeMerge,
      category: IconCategory.programming,
      description: 'دمج الكود',
      priority: 23,
    ),
    FolderIcon(
      id: 'icon_code_compare',
      name: 'مقارنة كود',
      icon: AppIcon.codeCompare,
      category: IconCategory.programming,
      description: 'مقارنة الكود',
      priority: 24,
    ),

    // ========== الرياضيات والإحصائيات ==========
    FolderIcon(
      id: 'icon_calculator',
      name: 'آلة حاسبة',
      icon: AppIcon.calculator,
      category: IconCategory.mathematics,
      description: 'الحسابات',
      priority: 1,
    ),
    FolderIcon(
      id: 'icon_square_root_alt',
      name: 'جذر تربيعي',
      icon: AppIcon.squareRootAlt,
      category: IconCategory.mathematics,
      description: 'الجذور',
      priority: 2,
    ),
    FolderIcon(
      id: 'icon_infinity',
      name: 'لانهاية',
      icon: AppIcon.infinity,
      category: IconCategory.mathematics,
      description: 'اللانهاية',
      priority: 3,
    ),
    FolderIcon(
      id: 'icon_percentage',
      name: 'نسبة مئوية',
      icon: AppIcon.percentage,
      category: IconCategory.mathematics,
      description: 'النسب المئوية',
      priority: 4,
    ),
    FolderIcon(
      id: 'icon_chart_line',
      name: 'رسم خطي',
      icon: AppIcon.chartLine,
      category: IconCategory.mathematics,
      description: 'الرسوم الخطية',
      priority: 5,
    ),
    FolderIcon(
      id: 'icon_chart_pie',
      name: 'رسم دائري',
      icon: AppIcon.chartPie,
      category: IconCategory.mathematics,
      description: 'الرسوم الدائرية',
      priority: 6,
    ),
    FolderIcon(
      id: 'icon_chart_area',
      name: 'رسم مساحي',
      icon: AppIcon.chartArea,
      category: IconCategory.mathematics,
      description: 'الرسوم المساحية',
      priority: 7,
    ),
    FolderIcon(
      id: 'icon_sort_numeric_up',
      name: 'ترتيب تصاعدي',
      icon: AppIcon.sortNumericUp,
      category: IconCategory.mathematics,
      description: 'ترتيب الأرقام',
      priority: 8,
    ),
    FolderIcon(
      id: 'icon_sort_numeric_down',
      name: 'ترتيب تنازلي',
      icon: AppIcon.sortNumericDown,
      category: IconCategory.mathematics,
      description: 'ترتيب الأرقام',
      priority: 9,
    ),
    FolderIcon(
      id: 'icon_equals',
      name: 'يساوي',
      icon: AppIcon.equals,
      category: IconCategory.mathematics,
      description: 'المعادلات',
      priority: 10,
    ),
    FolderIcon(
      id: 'icon_plus',
      name: 'زائد',
      icon: AppIcon.plus,
      category: IconCategory.mathematics,
      description: 'الجمع',
      priority: 11,
    ),
    FolderIcon(
      id: 'icon_minus',
      name: 'ناقص',
      icon: AppIcon.minus,
      category: IconCategory.mathematics,
      description: 'الطرح',
      priority: 12,
    ),
    FolderIcon(
      id: 'icon_times',
      name: 'ضرب',
      icon: AppIcon.times,
      category: IconCategory.mathematics,
      description: 'الضرب',
      priority: 13,
    ),
    FolderIcon(
      id: 'icon_divide',
      name: 'قسمة',
      icon: AppIcon.divide,
      category: IconCategory.mathematics,
      description: 'القسمة',
      priority: 14,
    ),
    FolderIcon(
      id: 'icon_superscript',
      name: 'أس علوي',
      icon: AppIcon.superscript,
      category: IconCategory.mathematics,
      description: 'الأسس',
      priority: 15,
    ),
    FolderIcon(
      id: 'icon_subscript',
      name: 'أس سفلي',
      icon: AppIcon.subscript,
      category: IconCategory.mathematics,
      description: 'الأسس',
      priority: 16,
    ),
    FolderIcon(
      id: 'icon_sigma',
      name: 'سيجما',
      icon: AppIcon.sigma,
      category: IconCategory.mathematics,
      description: 'سيجما',
      priority: 17,
    ),
    FolderIcon(
      id: 'icon_pi',
      name: 'باي',
      icon: AppIcon.pi,
      category: IconCategory.mathematics,
      description: 'باي',
      priority: 18,
    ),
    FolderIcon(
      id: 'icon_function',
      name: 'دالة',
      icon: AppIcon.function,
      category: IconCategory.mathematics,
      description: 'الدوال',
      priority: 19,
    ),
    FolderIcon(
      id: 'icon_integral',
      name: 'تكامل',
      icon: AppIcon.integral,
      category: IconCategory.mathematics,
      description: 'التكامل',
      priority: 20,
    ),
    FolderIcon(
      id: 'icon_triangle',
      name: 'مثلث',
      icon: AppIcon.triangle,
      category: IconCategory.mathematics,
      description: 'المثلثات',
      priority: 21,
    ),
    FolderIcon(
      id: 'icon_omega',
      name: 'أوميغا',
      icon: AppIcon.omega,
      category: IconCategory.mathematics,
      description: 'أوميغا',
      priority: 22,
    ),
    FolderIcon(
      id: 'icon_theta',
      name: 'ثيتا',
      icon: AppIcon.theta,
      category: IconCategory.mathematics,
      description: 'ثيتا',
      priority: 23,
    ),

    // ========== العلوم والكيمياء ==========
    FolderIcon(
      id: 'icon_atom',
      name: 'ذرة',
      icon: AppIcon.atom,
      category: IconCategory.science,
      description: 'الفيزياء',
      priority: 1,
    ),
    FolderIcon(
      id: 'icon_flask',
      name: 'قارورة',
      icon: AppIcon.flask,
      category: IconCategory.science,
      description: 'الكيمياء',
      priority: 2,
    ),
    FolderIcon(
      id: 'icon_microscope',
      name: 'مجهر',
      icon: AppIcon.microscope,
      category: IconCategory.science,
      description: 'المجهر',
      priority: 3,
    ),
    FolderIcon(
      id: 'icon_dna',
      name: 'DNA',
      icon: AppIcon.dna,
      category: IconCategory.science,
      description: 'البيولوجيا',
      priority: 4,
    ),
    FolderIcon(
      id: 'icon_leaf',
      name: 'ورقة',
      icon: AppIcon.leaf,
      category: IconCategory.science,
      description: 'البيئة',
      priority: 5,
    ),
    FolderIcon(
      id: 'icon_seedling',
      name: 'نبتة',
      icon: AppIcon.seedling,
      category: IconCategory.science,
      description: 'النباتات',
      priority: 6,
    ),
    FolderIcon(
      id: 'icon_droplet',
      name: 'قطرة',
      icon: AppIcon.droplet,
      category: IconCategory.science,
      description: 'الماء',
      priority: 7,
    ),
    FolderIcon(
      id: 'icon_fire',
      name: 'نار',
      icon: AppIcon.fire,
      category: IconCategory.science,
      description: 'النار',
      priority: 8,
    ),
    FolderIcon(
      id: 'icon_bolt',
      name: 'برق',
      icon: AppIcon.bolt,
      category: IconCategory.science,
      description: 'الكهرباء',
      priority: 9,
    ),
    FolderIcon(
      id: 'icon_magnet',
      name: 'مغناطيس',
      icon: AppIcon.magnet,
      category: IconCategory.science,
      description: 'المغناطيسية',
      priority: 10,
    ),
    FolderIcon(
      id: 'icon_satellite',
      name: 'قمر صناعي',
      icon: AppIcon.satellite,
      category: IconCategory.science,
      description: 'الأقمار الصناعية',
      priority: 11,
    ),
    FolderIcon(
      id: 'icon_rocket',
      name: 'صاروخ',
      icon: AppIcon.rocket,
      category: IconCategory.science,
      description: 'الفضاء',
      priority: 12,
    ),
    FolderIcon(
      id: 'icon_sun',
      name: 'شمس',
      icon: AppIcon.sun,
      category: IconCategory.science,
      description: 'الشمس',
      priority: 13,
    ),
    FolderIcon(
      id: 'icon_moon',
      name: 'قمر',
      icon: AppIcon.moon,
      category: IconCategory.science,
      description: 'القمر',
      priority: 14,
    ),
    FolderIcon(
      id: 'icon_star',
      name: 'نجمة',
      icon: AppIcon.star,
      category: IconCategory.science,
      description: 'النجوم',
      priority: 15,
    ),
    FolderIcon(
      id: 'icon_telescope',
      name: 'تلسكوب',
      icon: AppIcon.telescope,
      category: IconCategory.science,
      description: 'الفلك',
      priority: 16,
    ),
    FolderIcon(
      id: 'icon_vial',
      name: 'أنبوب اختبار',
      icon: AppIcon.vial,
      category: IconCategory.science,
      description: 'الاختبارات',
      priority: 17,
    ),
    FolderIcon(
      id: 'icon_pills',
      name: 'أقراص',
      icon: AppIcon.pills,
      category: IconCategory.science,
      description: 'الأدوية',
      priority: 18,
    ),
    FolderIcon(
      id: 'icon_stethoscope',
      name: 'سماعة طبية',
      icon: AppIcon.stethoscope,
      category: IconCategory.science,
      description: 'الطب',
      priority: 19,
    ),
    FolderIcon(
      id: 'icon_heartbeat',
      name: 'نبض',
      icon: AppIcon.heartbeat,
      category: IconCategory.science,
      description: 'القلب',
      priority: 20,
    ),
    FolderIcon(
      id: 'icon_eye',
      name: 'عين',
      icon: AppIcon.eye,
      category: IconCategory.science,
      description: 'العين',
      priority: 21,
    ),
    FolderIcon(
      id: 'icon_ear',
      name: 'أذن',
      icon: AppIcon.ear,
      category: IconCategory.science,
      description: 'الأذن',
      priority: 22,
    ),
    FolderIcon(
      id: 'icon_nose',
      name: 'أنف',
      icon: AppIcon.nose,
      category: IconCategory.science,
      description: 'الأنف',
      priority: 23,
    ),
    FolderIcon(
      id: 'icon_tooth',
      name: 'سن',
      icon: AppIcon.tooth,
      category: IconCategory.science,
      description: 'الأسنان',
      priority: 24,
    ),
    FolderIcon(
      id: 'icon_bone',
      name: 'عظم',
      icon: AppIcon.bone,
      category: IconCategory.science,
      description: 'العظام',
      priority: 25,
    ),
    FolderIcon(
      id: 'icon_lungs',
      name: 'رئتان',
      icon: AppIcon.lungs,
      category: IconCategory.science,
      description: 'الرئتان',
      priority: 26,
    ),
    FolderIcon(
      id: 'icon_liver',
      name: 'كبد',
      icon: AppIcon.liver,
      category: IconCategory.science,
      description: 'الكبد',
      priority: 27,
    ),
    FolderIcon(
      id: 'icon_kidney',
      name: 'كلية',
      icon: AppIcon.kidney,
      category: IconCategory.science,
      description: 'الكلى',
      priority: 28,
    ),
    FolderIcon(
      id: 'icon_stomach',
      name: 'معدة',
      icon: AppIcon.stomach,
      category: IconCategory.science,
      description: 'المعدة',
      priority: 29,
    ),
    FolderIcon(
      id: 'icon_intestines',
      name: 'أمعاء',
      icon: AppIcon.intestines,
      category: IconCategory.science,
      description: 'الأمعاء',
      priority: 30,
    ),

    // ========== الدراسة والأكاديمية ==========
    FolderIcon(
      id: 'icon_graduation_cap',
      name: 'قبعة تخرج',
      icon: AppIcon.graduationCap,
      category: IconCategory.study,
      description: 'التخرج',
      priority: 5,
    ),
    FolderIcon(
      id: 'icon_book',
      name: 'كتاب',
      icon: AppIcon.book,
      category: IconCategory.study,
      description: 'الكتب',
      priority: 2,
    ),
    FolderIcon(
      id: 'icon_book_open',
      name: 'كتاب مفتوح',
      icon: AppIcon.bookOpen,
      category: IconCategory.study,
      description: 'القراءة',
      priority: 3,
    ),
    FolderIcon(
      id: 'icon_pen',
      name: 'قلم',
      icon: AppIcon.pen,
      category: IconCategory.study,
      description: 'الكتابة',
      priority: 4,
    ),
    FolderIcon(
      id: 'icon_pencil_alt',
      name: 'قلم رصاص',
      icon: AppIcon.pencilAlt,
      category: IconCategory.study,
      description: 'الرسم',
      priority: 5,
    ),
    FolderIcon(
      id: 'icon_highlighter',
      name: 'قلم تمييز',
      icon: AppIcon.highlighter,
      category: IconCategory.study,
      description: 'التمييز',
      priority: 6,
    ),
    FolderIcon(
      id: 'icon_sticky_note',
      name: 'ملاحظة',
      icon: AppIcon.stickyNote,
      category: IconCategory.study,
      description: 'الملاحظات',
      priority: 7,
    ),
    FolderIcon(
      id: 'icon_clipboard',
      name: 'لوح',
      icon: AppIcon.clipboard,
      category: IconCategory.study,
      description: 'اللوحات',
      priority: 8,
    ),
    FolderIcon(
      id: 'icon_file_alt',
      name: 'ملف',
      icon: AppIcon.fileAlt,
      category: IconCategory.study,
      description: 'الملفات',
      priority: 9,
    ),
    FolderIcon(
      id: 'icon_archive',
      name: 'أرشيف',
      icon: AppIcon.archive,
      category: IconCategory.study,
      description: 'الأرشيف',
      priority: 14,
    ),
    FolderIcon(
      id: 'icon_calendar_alt',
      name: 'تقويم',
      icon: AppIcon.calendarAlt,
      category: IconCategory.study,
      description: 'المواعيد',
      priority: 11,
    ),
    FolderIcon(
      id: 'icon_clock',
      name: 'ساعة',
      icon: AppIcon.clock,
      category: IconCategory.study,
      description: 'الوقت',
      priority: 12,
    ),
    FolderIcon(
      id: 'icon_stopwatch',
      name: 'ساعة توقيت',
      icon: AppIcon.stopwatch,
      category: IconCategory.study,
      description: 'الوقت',
      priority: 13,
    ),
    FolderIcon(
      id: 'icon_hourglass_half',
      name: 'ساعة رملية',
      icon: AppIcon.hourglassHalf,
      category: IconCategory.study,
      description: 'الوقت',
      priority: 14,
    ),
    FolderIcon(
      id: 'icon_bell',
      name: 'جرس',
      icon: AppIcon.bell,
      category: IconCategory.study,
      description: 'التنبيهات',
      priority: 15,
    ),
    FolderIcon(
      id: 'icon_flag',
      name: 'علم',
      icon: AppIcon.flag,
      category: IconCategory.study,
      description: 'الأعلام',
      priority: 16,
    ),
    FolderIcon(
      id: 'icon_trophy',
      name: 'كأس',
      icon: AppIcon.trophy,
      category: IconCategory.study,
      description: 'الجوائز',
      priority: 17,
    ),
    FolderIcon(
      id: 'icon_medal',
      name: 'ميدالية',
      icon: AppIcon.medal,
      category: IconCategory.study,
      description: 'الميداليات',
      priority: 18,
    ),
    FolderIcon(
      id: 'icon_certificate',
      name: 'شهادة',
      icon: AppIcon.certificate,
      category: IconCategory.study,
      description: 'الشهادات',
      priority: 19,
    ),
    FolderIcon(
      id: 'icon_award',
      name: 'جائزة',
      icon: AppIcon.award,
      category: IconCategory.study,
      description: 'الجوائز',
      priority: 20,
    ),
    FolderIcon(
      id: 'icon_user_graduate',
      name: 'طالب',
      icon: AppIcon.userGraduate,
      category: IconCategory.study,
      description: 'الطلاب',
      priority: 21,
    ),
    FolderIcon(
      id: 'icon_chalkboard_teacher',
      name: 'معلم',
      icon: AppIcon.chalkboardTeacher,
      category: IconCategory.study,
      description: 'المعلمون',
      priority: 22,
    ),
    FolderIcon(
      id: 'icon_chalkboard',
      name: 'سبورة',
      icon: AppIcon.chalkboard,
      category: IconCategory.study,
      description: 'السبورات',
      priority: 23,
    ),
    FolderIcon(
      id: 'icon_search',
      name: 'بحث',
      icon: AppIcon.search,
      category: IconCategory.study,
      description: 'البحث',
      priority: 24,
    ),
    FolderIcon(
      id: 'icon_question_circle',
      name: 'سؤال',
      icon: AppIcon.questionCircle,
      category: IconCategory.study,
      description: 'الأسئلة',
      priority: 25,
    ),
    FolderIcon(
      id: 'icon_lightbulb',
      name: 'فكرة',
      icon: AppIcon.lightbulb,
      category: IconCategory.study,
      description: 'الأفكار',
      priority: 26,
    ),
    FolderIcon(
      id: 'icon_inbox',
      name: 'صندوق وارد',
      icon: AppIcon.inbox,
      category: IconCategory.study,
      description: 'الوارد',
      priority: 31,
    ),

    // ========== الإبداع والتصميم ==========
    FolderIcon(
      id: 'icon_palette',
      name: 'لوحة ألوان',
      icon: AppIcon.palette,
      category: IconCategory.creativity,
      description: 'الألوان',
      priority: 1,
    ),
    FolderIcon(
      id: 'icon_paint_brush',
      name: 'فرشاة',
      icon: AppIcon.paintBrush,
      category: IconCategory.creativity,
      description: 'الرسم',
      priority: 2,
    ),
    FolderIcon(
      id: 'icon_magic',
      name: 'سحر',
      icon: AppIcon.magic,
      category: IconCategory.creativity,
      description: 'السحر',
      priority: 3,
    ),
    FolderIcon(
      id: 'icon_sparkles',
      name: 'شرارات',
      icon: AppIcon.sparkles,
      category: IconCategory.creativity,
      description: 'الشرارات',
      priority: 4,
    ),
    FolderIcon(
      id: 'icon_eye_dropper',
      name: 'قطارة',
      icon: AppIcon.eyeDropper,
      category: IconCategory.creativity,
      description: 'اختيار اللون',
      priority: 5,
    ),
    FolderIcon(
      id: 'icon_camera',
      name: 'كاميرا',
      icon: AppIcon.camera,
      category: IconCategory.creativity,
      description: 'التصوير',
      priority: 6,
    ),
    FolderIcon(
      id: 'icon_video',
      name: 'فيديو',
      icon: AppIcon.video,
      category: IconCategory.creativity,
      description: 'الفيديو',
      priority: 7,
    ),
    FolderIcon(
      id: 'icon_music',
      name: 'موسيقى',
      icon: AppIcon.music,
      category: IconCategory.creativity,
      description: 'الموسيقى',
      priority: 8,
    ),
    FolderIcon(
      id: 'icon_headphones',
      name: 'سماعات',
      icon: AppIcon.headphones,
      category: IconCategory.creativity,
      description: 'الصوت',
      priority: 9,
    ),
    FolderIcon(
      id: 'icon_gamepad',
      name: 'جهاز ألعاب',
      icon: AppIcon.gamepad,
      category: IconCategory.creativity,
      description: 'الألعاب',
      priority: 10,
    ),
    FolderIcon(
      id: 'icon_dice',
      name: 'نرد',
      icon: AppIcon.dice,
      category: IconCategory.creativity,
      description: 'الألعاب',
      priority: 11,
    ),
    FolderIcon(
      id: 'icon_puzzle_piece',
      name: 'قطعة أحجية',
      icon: AppIcon.puzzlePiece,
      category: IconCategory.creativity,
      description: 'الأحاجي',
      priority: 12,
    ),
    FolderIcon(
      id: 'icon_cube',
      name: 'مكعب',
      icon: AppIcon.cube,
      category: IconCategory.creativity,
      description: 'الأشكال',
      priority: 13,
    ),
    FolderIcon(
      id: 'icon_gem',
      name: 'جوهرة',
      icon: AppIcon.gem,
      category: IconCategory.creativity,
      description: 'الجواهر',
      priority: 14,
    ),
    FolderIcon(
      id: 'icon_crown',
      name: 'تاج',
      icon: AppIcon.crown,
      category: IconCategory.creativity,
      description: 'التاج',
      priority: 15,
    ),
    FolderIcon(
      id: 'icon_ribbon',
      name: 'شريط',
      icon: AppIcon.ribbon,
      category: IconCategory.creativity,
      description: 'الأشرطة',
      priority: 16,
    ),

    // ========== العمل الجماعي والتواصل ==========
    FolderIcon(
      id: 'icon_users',
      name: 'مستخدمون',
      icon: AppIcon.users,
      category: IconCategory.collaboration,
      description: 'المستخدمون',
      priority: 1,
    ),
    FolderIcon(
      id: 'icon_user_friends',
      name: 'أصدقاء',
      icon: AppIcon.userFriends,
      category: IconCategory.collaboration,
      description: 'الأصدقاء',
      priority: 2,
    ),
    FolderIcon(
      id: 'icon_handshake',
      name: 'مصافحة',
      icon: AppIcon.handshake,
      category: IconCategory.collaboration,
      description: 'التعاون',
      priority: 3,
    ),
    FolderIcon(
      id: 'icon_comments',
      name: 'تعليقات',
      icon: AppIcon.comments,
      category: IconCategory.collaboration,
      description: 'التعليقات',
      priority: 4,
    ),
    FolderIcon(
      id: 'icon_comment_dots',
      name: 'تعليق',
      icon: AppIcon.commentDots,
      category: IconCategory.collaboration,
      description: 'التعليق',
      priority: 5,
    ),
    FolderIcon(
      id: 'icon_envelope',
      name: 'ظرف',
      icon: AppIcon.envelope,
      category: IconCategory.collaboration,
      description: 'البريد',
      priority: 6,
    ),
    FolderIcon(
      id: 'icon_phone',
      name: 'هاتف',
      icon: AppIcon.phone,
      category: IconCategory.collaboration,
      description: 'المكالمات',
      priority: 7,
    ),
    FolderIcon(
      id: 'icon_video_camera',
      name: 'كاميرا فيديو',
      icon: AppIcon.videoCamera,
      category: IconCategory.collaboration,
      description: 'المكالمات المرئية',
      priority: 8,
    ),
    FolderIcon(
      id: 'icon_share_alt',
      name: 'مشاركة',
      icon: AppIcon.shareAlt,
      category: IconCategory.collaboration,
      description: 'المشاركة',
      priority: 9,
    ),
    FolderIcon(
      id: 'icon_link',
      name: 'رابط',
      icon: AppIcon.link,
      category: IconCategory.collaboration,
      description: 'الروابط',
      priority: 10,
    ),
    FolderIcon(
      id: 'icon_sync',
      name: 'مزامنة',
      icon: AppIcon.sync,
      category: IconCategory.collaboration,
      description: 'المزامنة',
      priority: 11,
    ),
    FolderIcon(
      id: 'icon_download',
      name: 'تحميل',
      icon: AppIcon.download,
      category: IconCategory.collaboration,
      description: 'التحميل',
      priority: 12,
    ),
    FolderIcon(
      id: 'icon_upload',
      name: 'رفع',
      icon: AppIcon.upload,
      category: IconCategory.collaboration,
      description: 'الرفع',
      priority: 13,
    ),
    FolderIcon(
      id: 'icon_print',
      name: 'طباعة',
      icon: AppIcon.print,
      category: IconCategory.collaboration,
      description: 'الطباعة',
      priority: 14,
    ),
    FolderIcon(
      id: 'icon_copy',
      name: 'نسخ',
      icon: AppIcon.copy,
      category: IconCategory.collaboration,
      description: 'النسخ',
      priority: 15,
    ),
    FolderIcon(
      id: 'icon_paper_plane',
      name: 'طائرة ورقية',
      icon: AppIcon.paperPlane,
      category: IconCategory.collaboration,
      description: 'الإرسال',
      priority: 16,
    ),
    FolderIcon(
      id: 'icon_send',
      name: 'إرسال',
      icon: AppIcon.send,
      category: IconCategory.collaboration,
      description: 'الإرسال',
      priority: 17,
    ),
    FolderIcon(
      id: 'icon_bell_slash',
      name: 'إيقاف التنبيهات',
      icon: AppIcon.bellSlash,
      category: IconCategory.collaboration,
      description: 'إيقاف التنبيهات',
      priority: 18,
    ),
    FolderIcon(
      id: 'icon_chat',
      name: 'محادثة',
      icon: AppIcon.chat,
      category: IconCategory.collaboration,
      description: 'المحادثات',
      priority: 19,
    ),
    FolderIcon(
      id: 'icon_message',
      name: 'رسالة',
      icon: AppIcon.message,
      category: IconCategory.collaboration,
      description: 'الرسائل',
      priority: 20,
    ),
    FolderIcon(
      id: 'icon_reply',
      name: 'رد',
      icon: AppIcon.reply,
      category: IconCategory.collaboration,
      description: 'الردود',
      priority: 21,
    ),
    FolderIcon(
      id: 'icon_share',
      name: 'مشاركة',
      icon: AppIcon.share,
      category: IconCategory.collaboration,
      description: 'المشاركة',
      priority: 22,
    ),
    FolderIcon(
      id: 'icon_attach',
      name: 'مرفق',
      icon: AppIcon.attach,
      category: IconCategory.collaboration,
      description: 'المرفقات',
      priority: 23,
    ),
    FolderIcon(
      id: 'icon_image',
      name: 'صورة',
      icon: AppIcon.image,
      category: IconCategory.collaboration,
      description: 'الصور',
      priority: 24,
    ),
    FolderIcon(
      id: 'icon_file',
      name: 'ملف',
      icon: AppIcon.file,
      category: IconCategory.collaboration,
      description: 'الملفات',
      priority: 25,
    ),
    FolderIcon(
      id: 'icon_paperclip',
      name: 'مشبك ورق',
      icon: AppIcon.paperclip,
      category: IconCategory.collaboration,
      description: 'المشابك',
      priority: 26,
    ),

    // ========== النظام والإعدادات ==========
    FolderIcon(
      id: 'icon_settings',
      name: 'إعدادات',
      icon: AppIcon.settings,
      category: IconCategory.system,
      description: 'الإعدادات',
      priority: 1,
    ),
    FolderIcon(
      id: 'icon_cog',
      name: 'ترس',
      icon: AppIcon.cog,
      category: IconCategory.system,
      description: 'الإعدادات',
      priority: 2,
    ),
    FolderIcon(
      id: 'icon_shield',
      name: 'درع',
      icon: AppIcon.shield,
      category: IconCategory.system,
      description: 'الأمان',
      priority: 3,
    ),
    FolderIcon(
      id: 'icon_info',
      name: 'معلومات',
      icon: AppIcon.info,
      category: IconCategory.system,
      description: 'المعلومات',
      priority: 4,
    ),
    FolderIcon(
      id: 'icon_help',
      name: 'مساعدة',
      icon: AppIcon.help,
      category: IconCategory.system,
      description: 'المساعدة',
      priority: 5,
    ),
    FolderIcon(
      id: 'icon_question',
      name: 'سؤال',
      icon: AppIcon.question,
      category: IconCategory.system,
      description: 'الأسئلة',
      priority: 6,
    ),
    FolderIcon(
      id: 'icon_check',
      name: 'صح',
      icon: AppIcon.check,
      category: IconCategory.system,
      description: 'التأكيد',
      priority: 7,
    ),
    FolderIcon(
      id: 'icon_warning',
      name: 'تحذير',
      icon: AppIcon.warning,
      category: IconCategory.system,
      description: 'التحذيرات',
      priority: 8,
    ),
    FolderIcon(
      id: 'icon_error',
      name: 'خطأ',
      icon: AppIcon.error,
      category: IconCategory.system,
      description: 'الأخطاء',
      priority: 9,
    ),
    FolderIcon(
      id: 'icon_info_circle',
      name: 'معلومات',
      icon: AppIcon.infoCircle,
      category: IconCategory.system,
      description: 'المعلومات',
      priority: 10,
    ),
    FolderIcon(
      id: 'icon_exclamation',
      name: 'تعجب',
      icon: AppIcon.exclamation,
      category: IconCategory.system,
      description: 'التنبيهات',
      priority: 11,
    ),
    FolderIcon(
      id: 'icon_exclamation_triangle',
      name: 'مثلث تحذير',
      icon: AppIcon.exclamationTriangle,
      category: IconCategory.system,
      description: 'التحذيرات',
      priority: 12,
    ),
    FolderIcon(
      id: 'icon_user',
      name: 'مستخدم',
      icon: AppIcon.user,
      category: IconCategory.system,
      description: 'المستخدم',
      priority: 13,
    ),
    FolderIcon(
      id: 'icon_lock',
      name: 'قفل',
      icon: AppIcon.lock,
      category: IconCategory.system,
      description: 'الأمان',
      priority: 14,
    ),
    FolderIcon(
      id: 'icon_sign_in',
      name: 'تسجيل دخول',
      icon: AppIcon.signIn,
      category: IconCategory.system,
      description: 'تسجيل الدخول',
      priority: 15,
    ),
    FolderIcon(
      id: 'icon_sign_out',
      name: 'تسجيل خروج',
      icon: AppIcon.signOut,
      category: IconCategory.system,
      description: 'تسجيل الخروج',
      priority: 16,
    ),
    FolderIcon(
      id: 'icon_edit',
      name: 'تعديل',
      icon: AppIcon.edit,
      category: IconCategory.system,
      description: 'التعديل',
      priority: 17,
    ),
    FolderIcon(
      id: 'icon_delete',
      name: 'حذف',
      icon: AppIcon.delete,
      category: IconCategory.system,
      description: 'الحذف',
      priority: 18,
    ),
    FolderIcon(
      id: 'icon_trash',
      name: 'سلة',
      icon: AppIcon.trash,
      category: IconCategory.system,
      description: 'سلة المهملات',
      priority: 19,
    ),
    FolderIcon(
      id: 'icon_save',
      name: 'حفظ',
      icon: AppIcon.save,
      category: IconCategory.system,
      description: 'الحفظ',
      priority: 20,
    ),
    FolderIcon(
      id: 'icon_history',
      name: 'تاريخ',
      icon: AppIcon.history,
      category: IconCategory.system,
      description: 'السجل',
      priority: 21,
    ),
    FolderIcon(
      id: 'icon_lock_keyhole',
      name: 'قفل',
      icon: AppIcon.lockKeyhole,
      category: IconCategory.system,
      description: 'الأمان',
      priority: 22,
    ),
    FolderIcon(
      id: 'icon_unlock',
      name: 'فتح',
      icon: AppIcon.unlock,
      category: IconCategory.system,
      description: 'فتح القفل',
      priority: 23,
    ),
    FolderIcon(
      id: 'icon_microphone',
      name: 'ميكروفون',
      icon: AppIcon.microphone,
      category: IconCategory.system,
      description: 'الصوت',
      priority: 24,
    ),
    FolderIcon(
      id: 'icon_file_code_icon',
      name: 'ملف كود',
      icon: AppIcon.fileCodeIcon,
      category: IconCategory.system,
      description: 'ملفات الكود',
      priority: 25,
    ),
    FolderIcon(
      id: 'icon_list',
      name: 'قائمة',
      icon: AppIcon.list,
      category: IconCategory.system,
      description: 'القوائم',
      priority: 26,
    ),
    FolderIcon(
      id: 'icon_grid',
      name: 'شبكة',
      icon: AppIcon.grid,
      category: IconCategory.system,
      description: 'الشبكات',
      priority: 27,
    ),
    FolderIcon(
      id: 'icon_th_large',
      name: 'شبكة كبيرة',
      icon: AppIcon.thLarge,
      category: IconCategory.system,
      description: 'الشبكات الكبيرة',
      priority: 28,
    ),
    FolderIcon(
      id: 'icon_bars',
      name: 'أشرطة',
      icon: AppIcon.bars,
      category: IconCategory.system,
      description: 'القوائم',
      priority: 29,
    ),
    FolderIcon(
      id: 'icon_menu',
      name: 'قائمة',
      icon: AppIcon.menu,
      category: IconCategory.system,
      description: 'القائمة',
      priority: 30,
    ),
    FolderIcon(
      id: 'icon_filter',
      name: 'تصفية',
      icon: AppIcon.filter,
      category: IconCategory.system,
      description: 'التصفية',
      priority: 31,
    ),
    FolderIcon(
      id: 'icon_sort',
      name: 'ترتيب',
      icon: AppIcon.sort,
      category: IconCategory.system,
      description: 'الترتيب',
      priority: 32,
    ),
    FolderIcon(
      id: 'icon_refresh',
      name: 'تحديث',
      icon: AppIcon.refresh,
      category: IconCategory.system,
      description: 'التحديث',
      priority: 33,
    ),
    FolderIcon(
      id: 'icon_back',
      name: 'رجوع',
      icon: AppIcon.back,
      category: IconCategory.system,
      description: 'الرجوع',
      priority: 34,
    ),
    FolderIcon(
      id: 'icon_next',
      name: 'التالي',
      icon: AppIcon.next,
      category: IconCategory.system,
      description: 'التالي',
      priority: 35,
    ),
    FolderIcon(
      id: 'icon_previous',
      name: 'السابق',
      icon: AppIcon.previous,
      category: IconCategory.system,
      description: 'السابق',
      priority: 36,
    ),
    FolderIcon(
      id: 'icon_close',
      name: 'إغلاق',
      icon: AppIcon.close,
      category: IconCategory.system,
      description: 'الإغلاق',
      priority: 37,
    ),
    FolderIcon(
      id: 'icon_ellipsis',
      name: 'نقاط',
      icon: AppIcon.ellipsis,
      category: IconCategory.system,
      description: 'المزيد',
      priority: 38,
    ),
    FolderIcon(
      id: 'icon_ellipsis_h',
      name: 'نقاط أفقية',
      icon: AppIcon.ellipsisH,
      category: IconCategory.system,
      description: 'المزيد',
      priority: 39,
    ),
    FolderIcon(
      id: 'icon_ellipsis_v',
      name: 'نقاط عمودية',
      icon: AppIcon.ellipsisV,
      category: IconCategory.system,
      description: 'المزيد',
      priority: 40,
    ),
    FolderIcon(
      id: 'icon_chevron_up',
      name: 'سهم علوي',
      icon: AppIcon.chevronUp,
      category: IconCategory.system,
      description: 'أعلى',
      priority: 41,
    ),
    FolderIcon(
      id: 'icon_chevron_down',
      name: 'سهم سفلي',
      icon: AppIcon.chevronDown,
      category: IconCategory.system,
      description: 'أسفل',
      priority: 42,
    ),
    FolderIcon(
      id: 'icon_chevron_left',
      name: 'سهم يسار',
      icon: AppIcon.chevronLeft,
      category: IconCategory.system,
      description: 'يسار',
      priority: 43,
    ),
    FolderIcon(
      id: 'icon_chevron_right',
      name: 'سهم يمين',
      icon: AppIcon.chevronRight,
      category: IconCategory.system,
      description: 'يمين',
      priority: 44,
    ),
    FolderIcon(
      id: 'icon_angle_up',
      name: 'زاوية علوية',
      icon: AppIcon.angleUp,
      category: IconCategory.system,
      description: 'أعلى',
      priority: 45,
    ),
    FolderIcon(
      id: 'icon_angle_down',
      name: 'زاوية سفلية',
      icon: AppIcon.angleDown,
      category: IconCategory.system,
      description: 'أسفل',
      priority: 46,
    ),
    FolderIcon(
      id: 'icon_angle_left',
      name: 'زاوية يسارية',
      icon: AppIcon.angleLeft,
      category: IconCategory.system,
      description: 'يسار',
      priority: 47,
    ),
    FolderIcon(
      id: 'icon_angle_right',
      name: 'زاوية يمينية',
      icon: AppIcon.angleRight,
      category: IconCategory.system,
      description: 'يمين',
      priority: 48,
    ),
    FolderIcon(
      id: 'icon_angles_up',
      name: 'زوايا علوية',
      icon: AppIcon.anglesUp,
      category: IconCategory.system,
      description: 'أعلى',
      priority: 49,
    ),
    FolderIcon(
      id: 'icon_angles_down',
      name: 'زوايا سفلية',
      icon: AppIcon.anglesDown,
      category: IconCategory.system,
      description: 'أسفل',
      priority: 50,
    ),
    FolderIcon(
      id: 'icon_up_right_and_down_left_from_center',
      name: 'توسيع',
      icon: AppIcon.upRightAndDownLeftFromCenter,
      category: IconCategory.system,
      description: 'التوسيع',
      priority: 51,
    ),
    FolderIcon(
      id: 'icon_down_left_and_up_right_to_center',
      name: 'طي',
      icon: AppIcon.downLeftAndUpRightToCenter,
      category: IconCategory.system,
      description: 'الطي',
      priority: 52,
    ),
    FolderIcon(
      id: 'icon_play',
      name: 'تشغيل',
      icon: AppIcon.play,
      category: IconCategory.system,
      description: 'التشغيل',
      priority: 53,
    ),
    FolderIcon(
      id: 'icon_pause',
      name: 'إيقاف',
      icon: AppIcon.pause,
      category: IconCategory.system,
      description: 'الإيقاف',
      priority: 54,
    ),
    FolderIcon(
      id: 'icon_stop',
      name: 'إيقاف',
      icon: AppIcon.stop,
      category: IconCategory.system,
      description: 'الإيقاف',
      priority: 55,
    ),
    FolderIcon(
      id: 'icon_film',
      name: 'فيلم',
      icon: AppIcon.film,
      category: IconCategory.system,
      description: 'الأفلام',
      priority: 56,
    ),
    FolderIcon(
      id: 'icon_file_text',
      name: 'ملف نصي',
      icon: AppIcon.fileText,
      category: IconCategory.system,
      description: 'الملفات النصية',
      priority: 57,
    ),
    FolderIcon(
      id: 'icon_file_lines',
      name: 'ملف',
      icon: AppIcon.fileLines,
      category: IconCategory.system,
      description: 'الملفات',
      priority: 58,
    ),
    FolderIcon(
      id: 'icon_arrow_left',
      name: 'سهم يسار',
      icon: AppIcon.arrowLeft,
      category: IconCategory.system,
      description: 'يسار',
      priority: 59,
    ),
    FolderIcon(
      id: 'icon_arrow_right',
      name: 'سهم يمين',
      icon: AppIcon.arrowRight,
      category: IconCategory.system,
      description: 'يمين',
      priority: 60,
    ),
    FolderIcon(
      id: 'icon_arrow_up',
      name: 'سهم أعلى',
      icon: AppIcon.arrowUp,
      category: IconCategory.system,
      description: 'أعلى',
      priority: 61,
    ),
    FolderIcon(
      id: 'icon_arrow_down',
      name: 'سهم أسفل',
      icon: AppIcon.arrowDown,
      category: IconCategory.system,
      description: 'أسفل',
      priority: 62,
    ),
    FolderIcon(
      id: 'icon_arrow_turn_up_left',
      name: 'سهم منعطف',
      icon: AppIcon.arrowTurnUpLeft,
      category: IconCategory.system,
      description: 'منعطف',
      priority: 63,
    ),
    FolderIcon(
      id: 'icon_arrow_turn_up_right',
      name: 'سهم منعطف',
      icon: AppIcon.arrowTurnUpRight,
      category: IconCategory.system,
      description: 'منعطف',
      priority: 64,
    ),
    FolderIcon(
      id: 'icon_arrow_turn_down_left',
      name: 'سهم منعطف',
      icon: AppIcon.arrowTurnDownLeft,
      category: IconCategory.system,
      description: 'منعطف',
      priority: 65,
    ),
    FolderIcon(
      id: 'icon_arrow_turn_down_right',
      name: 'سهم منعطف',
      icon: AppIcon.arrowTurnDownRight,
      category: IconCategory.system,
      description: 'منعطف',
      priority: 66,
    ),
    FolderIcon(
      id: 'icon_xmark',
      name: 'إغلاق',
      icon: AppIcon.xmark,
      category: IconCategory.system,
      description: 'الإغلاق',
      priority: 67,
    ),
    FolderIcon(
      id: 'icon_check_circle',
      name: 'صح دائري',
      icon: AppIcon.checkCircle,
      category: IconCategory.system,
      description: 'التأكيد',
      priority: 68,
    ),
    FolderIcon(
      id: 'icon_times_circle',
      name: 'خطأ دائري',
      icon: AppIcon.timesCircle,
      category: IconCategory.system,
      description: 'الخطأ',
      priority: 69,
    ),
    FolderIcon(
      id: 'icon_info_circle_icon',
      name: 'معلومات دائري',
      icon: AppIcon.infoCircleIcon,
      category: IconCategory.system,
      description: 'المعلومات',
      priority: 70,
    ),
    FolderIcon(
      id: 'icon_exclamation_circle',
      name: 'تعجب دائري',
      icon: AppIcon.exclamationCircle,
      category: IconCategory.system,
      description: 'التنبيه',
      priority: 71,
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

  /// الحصول على أيقونة باستخدام AppIcon
  static FolderIcon? getIconByAppIcon(AppIcon appIcon) {
    try {
      return _allIcons.firstWhere((icon) => icon.icon == appIcon);
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
