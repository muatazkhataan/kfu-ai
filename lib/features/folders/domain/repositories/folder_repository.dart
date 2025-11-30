import '../models/folder.dart';

/// مستودع المجلدات
///
/// واجهة لجميع عمليات المجلدات (API + Cache)
abstract class FolderRepository {
  /// الحصول على جميع المجلدات
  Future<List<Folder>> getAllFolders();

  /// الحصول على المجلدات المتاحة
  Future<List<Folder>> getAvailableFolders();

  /// الحصول على محادثات مجلد معين
  /// TODO: استبدال Session بنموذج المحادثة من domain
  Future<List<dynamic>> getFolderChats(String folderId);

  /// إنشاء مجلد جديد
  Future<Folder> createFolder({
    required String name,
    required String icon,
    String? description,
    String? color,
  });

  /// تحديث اسم المجلد
  Future<void> updateFolderName(String folderId, String newName);

  /// تحديث أيقونة المجلد
  Future<void> updateFolderIcon(
    String folderId,
    String icon, {
    String? color,
  });

  /// حذف مجلد
  Future<void> deleteFolder(String folderId);

  /// تحديث ترتيب المجلدات
  Future<void> updateFolderOrder(List<String> folderIds);
}

