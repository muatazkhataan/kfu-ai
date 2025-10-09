/// جميع نقاط النهاية (Endpoints) لـ API
///
/// يحتوي على جميع الروابط المستخدمة في التطبيق بشكل منظم
class ApiEndpoints {
  ApiEndpoints._(); // Private constructor لمنع الإنشاء

  // ==================== Authentication Endpoints ====================

  /// تسجيل الدخول
  static const String login = '/api/Users/login';

  /// تجديد Token
  static const String refreshToken = '/api/Users/refresh_token';

  /// تسجيل الخروج
  static const String logout = '/api/Users/logout';

  // ==================== Chat Endpoints ====================

  /// إرسال رسالة
  static const String sendMessage = '/api/Chat/SendMessage';

  /// إنشاء جلسة محادثة جديدة
  static const String createSession = '/api/Chat/CreateSession';

  /// الحصول على جلسة محادثة
  static const String getSession = '/api/Chat/GetSession';

  /// تحديث عنوان الجلسة
  static const String updateSessionTitle = '/api/Chat/UpdateSessionTitle';

  /// أرشفة جلسة
  static const String archiveSession = '/api/Chat/ArchiveSession';

  /// حذف جلسة
  static const String deleteSession = '/api/Chat/DeleteSession';

  /// استعادة جلسة مؤرشفة
  static const String restoreSession = '/api/Chat/RestoreSession';

  /// نقل جلسة إلى مجلد
  static const String moveSessionToFolder = '/api/Chat/MoveSessionToFolder';

  /// الحصول على جميع جلسات المستخدم
  static const String getUserSessions = '/api/Chat/GetUserSessions';

  // ==================== Folder Endpoints ====================

  /// الحصول على جميع المجلدات
  static const String getAllFolders = '/api/Folder/GetAllFolder';

  /// الحصول على المجلدات المتاحة
  static const String getAvailableFolders = '/api/Folder/GetAvailableFolders';

  /// الحصول على محادثات مجلد معين
  static const String getFolderChats = '/api/Folder/GetFolderChats';

  /// تحديث ترتيب المجلدات
  static const String updateFolderOrder = '/api/Folder/UpdateFolderOrder';

  /// إنشاء مجلد جديد
  static const String createFolder = '/api/Folder/CreateFolder';

  /// تحديث اسم المجلد
  static const String updateFolderName = '/api/Folder/UpdateFolderName';

  /// تحديث أيقونة المجلد
  static const String updateFolderIcon = '/api/Folder/UpdateFolderIcon';

  /// حذف مجلد
  static const String deleteFolder = '/api/Folder/DeleteFolder';

  // ==================== Search Endpoints ====================

  /// البحث في المحادثات
  static const String searchChats = '/api/Search/SearchChats';

  /// الحصول على المحادثات الأخيرة
  static const String getRecentChats = '/api/Search/GetRecentChats';

  // ==================== Helper Methods ====================

  /// بناء URL مع معاملات الاستعلام
  static String buildUrl(String endpoint, Map<String, dynamic>? queryParams) {
    if (queryParams == null || queryParams.isEmpty) {
      return endpoint;
    }

    final queryString = queryParams.entries
        .where((entry) => entry.value != null)
        .map(
          (entry) =>
              '${entry.key}=${Uri.encodeComponent(entry.value.toString())}',
        )
        .join('&');

    return queryString.isEmpty ? endpoint : '$endpoint?$queryString';
  }

  /// الحصول على URL الجلسة مع معاملات
  static String getSessionUrl(String sessionId) {
    return buildUrl(getSession, {'sessionId': sessionId});
  }

  /// الحصول على URL محادثات المجلد مع معاملات
  static String getFolderChatsUrl(String folderId) {
    return buildUrl(getFolderChats, {'folderId': folderId});
  }
}
