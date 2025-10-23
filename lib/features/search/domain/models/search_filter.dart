/// نوع البحث
enum SearchType {
  /// جميع المحادثات
  all,

  /// المحادثات النشطة فقط
  active,

  /// المحادثات المؤرشفة فقط
  archived,

  /// المحادثات المحذوفة
  deleted;

  /// الحصول على القيمة النصية
  String get value {
    switch (this) {
      case SearchType.all:
        return 'all';
      case SearchType.active:
        return 'active';
      case SearchType.archived:
        return 'archived';
      case SearchType.deleted:
        return 'deleted';
    }
  }

  /// الحصول على الاسم بالعربية
  String get arabicName {
    switch (this) {
      case SearchType.all:
        return 'الكل';
      case SearchType.active:
        return 'النشطة';
      case SearchType.archived:
        return 'المؤرشفة';
      case SearchType.deleted:
        return 'المحذوفة';
    }
  }

  /// الإنشاء من نص
  static SearchType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return SearchType.active;
      case 'archived':
        return SearchType.archived;
      case 'deleted':
        return SearchType.deleted;
      default:
        return SearchType.all;
    }
  }
}

/// طريقة الترتيب
enum SortBy {
  /// الأحدث أولاً
  dateDesc,

  /// الأقدم أولاً
  dateAsc,

  /// حسب الأهمية/التطابق
  relevance,

  /// حسب العنوان أبجدياً
  titleAsc,

  /// حسب العنوان عكسياً
  titleDesc;

  /// الحصول على القيمة النصية
  String get value {
    switch (this) {
      case SortBy.dateDesc:
        return 'date_desc';
      case SortBy.dateAsc:
        return 'date_asc';
      case SortBy.relevance:
        return 'relevance';
      case SortBy.titleAsc:
        return 'title_asc';
      case SortBy.titleDesc:
        return 'title_desc';
    }
  }

  /// الحصول على الاسم بالعربية
  String get arabicName {
    switch (this) {
      case SortBy.dateDesc:
        return 'الأحدث أولاً';
      case SortBy.dateAsc:
        return 'الأقدم أولاً';
      case SortBy.relevance:
        return 'الأكثر تطابقاً';
      case SortBy.titleAsc:
        return 'أبجدياً (أ-ي)';
      case SortBy.titleDesc:
        return 'أبجدياً (ي-أ)';
    }
  }

  /// الإنشاء من نص
  static SortBy fromString(String value) {
    switch (value.toLowerCase()) {
      case 'date_asc':
        return SortBy.dateAsc;
      case 'relevance':
        return SortBy.relevance;
      case 'title_asc':
        return SortBy.titleAsc;
      case 'title_desc':
        return SortBy.titleDesc;
      default:
        return SortBy.dateDesc;
    }
  }
}

/// فلتر البحث
class SearchFilter {
  /// معرف المجلد للفلترة (null = كل المجلدات)
  final String? folderId;

  /// تاريخ البداية للفلترة
  final DateTime? startDate;

  /// تاريخ النهاية للفلترة
  final DateTime? endDate;

  /// نوع المحادثات
  final SearchType type;

  /// طريقة الترتيب
  final SortBy sortBy;

  /// الحد الأدنى لعدد الرسائل
  final int? minMessageCount;

  /// الحد الأقصى لعدد الرسائل
  final int? maxMessageCount;

  const SearchFilter({
    this.folderId,
    this.startDate,
    this.endDate,
    this.type = SearchType.all,
    this.sortBy = SortBy.relevance,
    this.minMessageCount,
    this.maxMessageCount,
  });

  /// إنشاء فلتر افتراضي
  factory SearchFilter.defaultFilter() {
    return const SearchFilter(type: SearchType.all, sortBy: SortBy.relevance);
  }

  /// إنشاء نسخة من الفلتر مع تعديلات
  SearchFilter copyWith({
    String? folderId,
    DateTime? startDate,
    DateTime? endDate,
    SearchType? type,
    SortBy? sortBy,
    int? minMessageCount,
    int? maxMessageCount,
    bool clearFolderId = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearMinMessageCount = false,
    bool clearMaxMessageCount = false,
  }) {
    return SearchFilter(
      folderId: clearFolderId ? null : (folderId ?? this.folderId),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      type: type ?? this.type,
      sortBy: sortBy ?? this.sortBy,
      minMessageCount: clearMinMessageCount
          ? null
          : (minMessageCount ?? this.minMessageCount),
      maxMessageCount: clearMaxMessageCount
          ? null
          : (maxMessageCount ?? this.maxMessageCount),
    );
  }

  /// التحويل إلى Map للإرسال للـ API
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'Type': type.value, 'SortBy': sortBy.value};

    if (folderId != null) map['FolderId'] = folderId;
    if (startDate != null) map['StartDate'] = startDate!.toIso8601String();
    if (endDate != null) map['EndDate'] = endDate!.toIso8601String();
    if (minMessageCount != null) map['MinMessageCount'] = minMessageCount;
    if (maxMessageCount != null) map['MaxMessageCount'] = maxMessageCount;

    return map;
  }

  /// الإنشاء من Map
  factory SearchFilter.fromMap(Map<String, dynamic> map) {
    return SearchFilter(
      folderId: map['FolderId'] ?? map['folderId'],
      startDate: map['StartDate'] != null
          ? DateTime.parse(map['StartDate'])
          : (map['startDate'] != null
                ? DateTime.parse(map['startDate'])
                : null),
      endDate: map['EndDate'] != null
          ? DateTime.parse(map['EndDate'])
          : (map['endDate'] != null ? DateTime.parse(map['endDate']) : null),
      type: SearchType.fromString(map['Type'] ?? map['type'] ?? 'all'),
      sortBy: SortBy.fromString(map['SortBy'] ?? map['sortBy'] ?? 'relevance'),
      minMessageCount: map['MinMessageCount'] ?? map['minMessageCount'],
      maxMessageCount: map['MaxMessageCount'] ?? map['maxMessageCount'],
    );
  }

  /// التحقق من وجود فلاتر نشطة
  bool get hasActiveFilters {
    return folderId != null ||
        startDate != null ||
        endDate != null ||
        type != SearchType.all ||
        minMessageCount != null ||
        maxMessageCount != null;
  }

  /// التحقق من وجود فلتر تاريخ
  bool get hasDateFilter => startDate != null || endDate != null;

  /// التحقق من وجود فلتر مجلد
  bool get hasFolderFilter => folderId != null;

  /// التحقق من وجود فلتر عدد الرسائل
  bool get hasMessageCountFilter =>
      minMessageCount != null || maxMessageCount != null;

  /// عدد الفلاتر النشطة
  int get activeFilterCount {
    int count = 0;
    if (folderId != null) count++;
    if (startDate != null || endDate != null) count++;
    if (type != SearchType.all) count++;
    if (minMessageCount != null || maxMessageCount != null) count++;
    return count;
  }

  /// الحصول على وصف الفلاتر النشطة
  String get activeFiltersDescription {
    if (!hasActiveFilters) return 'لا توجد فلاتر';

    final List<String> descriptions = [];

    if (hasFolderFilter) {
      descriptions.add('مجلد محدد');
    }

    if (hasDateFilter) {
      descriptions.add('فترة زمنية');
    }

    if (type != SearchType.all) {
      descriptions.add(type.arabicName);
    }

    if (hasMessageCountFilter) {
      descriptions.add('عدد رسائل محدد');
    }

    return descriptions.join(' • ');
  }

  /// إعادة تعيين جميع الفلاتر
  SearchFilter reset() {
    return SearchFilter.defaultFilter();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchFilter &&
          runtimeType == other.runtimeType &&
          folderId == other.folderId &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          type == other.type &&
          sortBy == other.sortBy &&
          minMessageCount == other.minMessageCount &&
          maxMessageCount == other.maxMessageCount;

  @override
  int get hashCode =>
      folderId.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      type.hashCode ^
      sortBy.hashCode ^
      minMessageCount.hashCode ^
      maxMessageCount.hashCode;

  @override
  String toString() {
    return 'SearchFilter(type: ${type.arabicName}, sortBy: ${sortBy.arabicName}, '
        'hasActiveFilters: $hasActiveFilters)';
  }
}
