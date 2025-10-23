/// نموذج نتيجة البحث
///
/// يمثل نتيجة واحدة من عملية البحث في المحادثات
class SearchResult {
  /// معرف المحادثة
  final String sessionId;

  /// عنوان المحادثة
  final String title;

  /// مقتطف من المحادثة يحتوي على الكلمة المفتاحية
  final String snippet;

  /// اسم المجلد (اختياري)
  final String? folderName;

  /// معرف المجلد (اختياري)
  final String? folderId;

  /// تاريخ إنشاء المحادثة
  final DateTime createdAt;

  /// تاريخ آخر تحديث
  final DateTime updatedAt;

  /// عدد الرسائل في المحادثة
  final int messageCount;

  /// الكلمات المميزة (للتمييز في واجهة المستخدم)
  final List<String> highlightedWords;

  /// هل المحادثة مؤرشفة
  final bool isArchived;

  /// درجة التطابق (0-100)
  final double relevanceScore;

  const SearchResult({
    required this.sessionId,
    required this.title,
    required this.snippet,
    this.folderName,
    this.folderId,
    required this.createdAt,
    required this.updatedAt,
    this.messageCount = 0,
    this.highlightedWords = const [],
    this.isArchived = false,
    this.relevanceScore = 0.0,
  });

  /// إنشاء نسخة من النتيجة مع تعديلات
  SearchResult copyWith({
    String? sessionId,
    String? title,
    String? snippet,
    String? folderName,
    String? folderId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? messageCount,
    List<String>? highlightedWords,
    bool? isArchived,
    double? relevanceScore,
  }) {
    return SearchResult(
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      folderName: folderName ?? this.folderName,
      folderId: folderId ?? this.folderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageCount: messageCount ?? this.messageCount,
      highlightedWords: highlightedWords ?? this.highlightedWords,
      isArchived: isArchived ?? this.isArchived,
      relevanceScore: relevanceScore ?? this.relevanceScore,
    );
  }

  /// التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'title': title,
      'snippet': snippet,
      'folderName': folderName,
      'folderId': folderId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messageCount': messageCount,
      'highlightedWords': highlightedWords,
      'isArchived': isArchived,
      'relevanceScore': relevanceScore,
    };
  }

  /// الإنشاء من JSON
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      sessionId: json['sessionId'] ?? json['SessionId'] ?? '',
      title: json['title'] ?? json['Title'] ?? '',
      snippet: json['snippet'] ?? json['Snippet'] ?? '',
      folderName: json['folderName'] ?? json['FolderName'],
      folderId: json['folderId'] ?? json['FolderId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['CreatedAt'] != null
                ? DateTime.parse(json['CreatedAt'])
                : DateTime.now()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (json['UpdatedAt'] != null
                ? DateTime.parse(json['UpdatedAt'])
                : DateTime.now()),
      messageCount: json['messageCount'] ?? json['MessageCount'] ?? 0,
      highlightedWords: json['highlightedWords'] != null
          ? List<String>.from(json['highlightedWords'])
          : (json['HighlightedWords'] != null
                ? List<String>.from(json['HighlightedWords'])
                : []),
      isArchived: json['isArchived'] ?? json['IsArchived'] ?? false,
      relevanceScore: (json['relevanceScore'] ?? json['RelevanceScore'] ?? 0.0)
          .toDouble(),
    );
  }

  /// الحصول على وصف مختصر للنتيجة
  String get description {
    if (snippet.isNotEmpty) return snippet;
    if (folderName != null) return 'في مجلد: $folderName';
    return 'محادثة بدون وصف';
  }

  /// الحصول على عدد الرسائل بصيغة مقروءة
  String get formattedMessageCount {
    if (messageCount == 0) return 'لا توجد رسائل';
    if (messageCount == 1) return 'رسالة واحدة';
    if (messageCount == 2) return 'رسالتان';
    if (messageCount <= 10) return '$messageCount رسائل';
    return '$messageCount رسالة';
  }

  /// الحصول على تاريخ بصيغة مقروءة
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

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
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId;

  @override
  int get hashCode => sessionId.hashCode;

  @override
  String toString() {
    return 'SearchResult(sessionId: $sessionId, title: $title, messageCount: $messageCount)';
  }
}
