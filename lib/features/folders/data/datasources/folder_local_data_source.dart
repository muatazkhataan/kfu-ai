import '../../domain/models/folder.dart';

/// مصدر البيانات المحلية للمجلدات
///
/// واجهة للتخزين المحلي (Cache) باستخدام Hive
abstract class FolderLocalDataSource {
  /// الحصول على المجلدات المخزنة محلياً
  Future<List<Folder>> getCachedFolders();

  /// حفظ قائمة المجلدات محلياً
  Future<void> cacheFolders(List<Folder> folders);

  /// حفظ مجلد واحد محلياً
  Future<void> cacheFolder(Folder folder);

  /// حذف مجلد من التخزين المحلي
  Future<void> deleteCachedFolder(String folderId);

  /// مسح جميع المجلدات المخزنة
  Future<void> clearCache();

  /// التحقق من وجود بيانات مخزنة
  Future<bool> hasCachedData();
}

