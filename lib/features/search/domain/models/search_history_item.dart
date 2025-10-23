/// عنصر في تاريخ البحث
class SearchHistoryItem {
  /// نص البحث
  final String query;

  /// وقت إجراء البحث
  final DateTime timestamp;

  /// عدد النتائج
  final int resultCount;

  /// معرف فريد للعنصر
  final String id;

  /// معرف المجلد المستخدم في الفلتر (اختياري)
  final String? folderId;

  /// اسم المجلد المستخدم في الفلتر (اختياري)
  final String? folderName;

  const SearchHistoryItem({
    required this.query,
    required this.timestamp,
    required this.resultCount,
    required this.id,
    this.folderId,
    this.folderName,
  });

  /// إنشاء عنصر تاريخ جديد
  factory SearchHistoryItem.create({
    required String query,
    required int resultCount,
    String? folderId,
    String? folderName,
  }) {
    return SearchHistoryItem(
      id: _generateId(),
      query: query,
      timestamp: DateTime.now(),
      resultCount: resultCount,
      folderId: folderId,
      folderName: folderName,
    );
  }

  /// إنشاء نسخة من العنصر مع تعديلات
  SearchHistoryItem copyWith({
    String? query,
    DateTime? timestamp,
    int? resultCount,
    String? id,
    String? folderId,
    String? folderName,
  }) {
    return SearchHistoryItem(
      query: query ?? this.query,
      timestamp: timestamp ?? this.timestamp,
      resultCount: resultCount ?? this.resultCount,
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
    );
  }

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'timestamp': timestamp.toIso8601String(),
      'resultCount': resultCount,
      'folderId': folderId,
      'folderName': folderName,
    };
  }

  /// الإنشاء من JSON
  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['id'] ?? _generateId(),
      query: json['query'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      resultCount: json['resultCount'] ?? 0,
      folderId: json['folderId'],
      folderName: json['folderName'],
    );
  }

  /// توليد معرف فريد
  static String _generateId() {
    return 'search_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000).toString().padLeft(3, '0')}';
  }

  /// الحصول على وقت البحث بصيغة مقروءة
  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} يوم';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} أسبوع';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// الحصول على عدد النتائج بصيغة مقروءة
  String get formattedResultCount {
    if (resultCount == 0) return 'لا توجد نتائج';
    if (resultCount == 1) return 'نتيجة واحدة';
    if (resultCount == 2) return 'نتيجتان';
    if (resultCount <= 10) return '$resultCount نتائج';
    return '$resultCount نتيجة';
  }

  /// الحصول على نص وصفي كامل
  String get description {
    if (folderName != null) {
      return '$query • $folderName • $formattedResultCount';
    }
    return '$query • $formattedResultCount';
  }

  /// التحقق من وجود فلتر مجلد
  bool get hasFolder => folderId != null && folderName != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SearchHistoryItem(query: $query, resultCount: $resultCount, timestamp: $formattedTimestamp)';
  }
}
