import '../../../../features/search/domain/models/search_filter.dart';

/// طلب البحث في المحادثات
class SearchChatsRequest {
  /// نص البحث
  final String query;

  /// معرف المجلد (اختياري)
  final String? folderId;

  /// تاريخ البداية (اختياري)
  final DateTime? startDate;

  /// تاريخ النهاية (اختياري)
  final DateTime? endDate;

  /// نوع المحادثات
  final SearchType type;

  /// طريقة الترتيب
  final SortBy sortBy;

  /// الحد الأدنى لعدد الرسائل
  final int? minMessageCount;

  /// الحد الأقصى لعدد الرسائل
  final int? maxMessageCount;

  /// رقم الصفحة
  final int page;

  /// حجم الصفحة
  final int pageSize;

  const SearchChatsRequest({
    required this.query,
    this.folderId,
    this.startDate,
    this.endDate,
    this.type = SearchType.all,
    this.sortBy = SortBy.relevance,
    this.minMessageCount,
    this.maxMessageCount,
    this.page = 1,
    this.pageSize = 20,
  });

  /// إنشاء من SearchFilter
  factory SearchChatsRequest.fromFilter({
    required String query,
    SearchFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) {
    return SearchChatsRequest(
      query: query,
      folderId: filter?.folderId,
      startDate: filter?.startDate,
      endDate: filter?.endDate,
      type: filter?.type ?? SearchType.all,
      sortBy: filter?.sortBy ?? SortBy.relevance,
      minMessageCount: filter?.minMessageCount,
      maxMessageCount: filter?.maxMessageCount,
      page: page,
      pageSize: pageSize,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'Query': query.trim(), // إزالة المسافات الزائدة
      'Type': type.value,
      'SortBy': sortBy.value,
      'Page': page,
      'PageSize': pageSize,
    };

    // إضافة الفلاتر الاختيارية
    if (folderId != null && folderId!.isNotEmpty) json['FolderId'] = folderId;
    if (startDate != null) json['StartDate'] = startDate!.toIso8601String();
    if (endDate != null) json['EndDate'] = endDate!.toIso8601String();
    if (minMessageCount != null) json['MinMessageCount'] = minMessageCount;
    if (maxMessageCount != null) json['MaxMessageCount'] = maxMessageCount;

    // تسجيل تفصيلي للطلب
    print('[SearchChatsRequest.toJson] 📤 Request JSON: $json');
    print('[SearchChatsRequest.toJson] 📝 Query: "${json['Query']}"');
    print('[SearchChatsRequest.toJson] 📝 Type: ${json['Type']}');
    print('[SearchChatsRequest.toJson] 📝 SortBy: ${json['SortBy']}');

    return json;
  }

  /// التحقق من صحة البيانات
  bool get isValid => query.isNotEmpty && query.trim().isNotEmpty;

  /// نسخ مع تعديلات
  SearchChatsRequest copyWith({
    String? query,
    String? folderId,
    DateTime? startDate,
    DateTime? endDate,
    SearchType? type,
    SortBy? sortBy,
    int? minMessageCount,
    int? maxMessageCount,
    int? page,
    int? pageSize,
    bool clearFolderId = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearMinMessageCount = false,
    bool clearMaxMessageCount = false,
  }) {
    return SearchChatsRequest(
      query: query ?? this.query,
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
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  String toString() {
    return 'SearchChatsRequest(query: $query, type: ${type.arabicName}, sortBy: ${sortBy.arabicName})';
  }
}
