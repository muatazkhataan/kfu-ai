import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/folder.dart';
import 'folder_local_data_source.dart';

/// تنفيذ مصدر البيانات المحلية للمجلدات
///
/// يستخدم Hive للتخزين المحلي
class FolderLocalDataSourceImpl implements FolderLocalDataSource {
  static const String _boxName = 'folders_cache';
  static const String _foldersKey = 'folders_list';
  static const String _lastUpdateKey = 'last_update';

  Box<String>? _box;

  /// تهيئة الـ Box
  Future<void> _ensureBox() async {
    if (_box == null || !Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<String>(_boxName);
    } else {
      _box = Hive.box<String>(_boxName);
    }
  }

  @override
  Future<List<Folder>> getCachedFolders() async {
    try {
      await _ensureBox();
      final foldersJson = _box!.get(_foldersKey);
      if (foldersJson == null) {
        return [];
      }

      final List<dynamic> foldersList = json.decode(foldersJson);
      return foldersList
          .map((json) => Folder.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // في حالة الخطأ، إرجاع قائمة فارغة
      return [];
    }
  }

  @override
  Future<void> cacheFolders(List<Folder> folders) async {
    try {
      await _ensureBox();
      final foldersJson = json.encode(
        folders.map((folder) => folder.toMap()).toList(),
      );
      await _box!.put(_foldersKey, foldersJson);
      await _box!.put(_lastUpdateKey, DateTime.now().toIso8601String());
    } catch (e) {
      // يمكن إضافة logging هنا
      rethrow;
    }
  }

  @override
  Future<void> cacheFolder(Folder folder) async {
    try {
      final folders = await getCachedFolders();
      final index = folders.indexWhere((f) => f.id == folder.id);
      if (index >= 0) {
        folders[index] = folder;
      } else {
        folders.add(folder);
      }
      await cacheFolders(folders);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCachedFolder(String folderId) async {
    try {
      final folders = await getCachedFolders();
      folders.removeWhere((folder) => folder.id == folderId);
      await cacheFolders(folders);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _ensureBox();
      await _box!.clear();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> hasCachedData() async {
    try {
      await _ensureBox();
      return _box!.containsKey(_foldersKey);
    } catch (e) {
      return false;
    }
  }

  /// الحصول على تاريخ آخر تحديث
  Future<DateTime?> getLastUpdate() async {
    try {
      await _ensureBox();
      final lastUpdateStr = _box!.get(_lastUpdateKey);
      if (lastUpdateStr == null) return null;
      return DateTime.parse(lastUpdateStr);
    } catch (e) {
      return null;
    }
  }
}

