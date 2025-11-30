import '../../domain/models/folder.dart';
import '../../domain/models/folder_icon.dart';
import '../../domain/repositories/folder_repository.dart';
import '../datasources/folder_remote_data_source.dart';
import '../datasources/folder_local_data_source.dart';
import '../mappers/folder_dto_mapper.dart';
import '../../../../services/api/folder/models/create_folder_request.dart';
import '../../../../services/api/folder/models/update_folder_request.dart';
import '../../../../services/api/folder/models/update_folder_order_request.dart';
import '../../../../core/theme/icons.dart';

/// تنفيذ مستودع المجلدات
///
/// يجمع بين Remote و Local Data Sources
/// يستخدم Cache-first strategy
class FolderRepositoryImpl implements FolderRepository {
  final FolderRemoteDataSource _remoteDataSource;
  final FolderLocalDataSource _localDataSource;

  FolderRepositoryImpl({
    required FolderRemoteDataSource remoteDataSource,
    required FolderLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<Folder>> getAllFolders() async {
    try {
      // محاولة الحصول من Cache أولاً
      final cachedFolders = await _localDataSource.getCachedFolders();
      if (cachedFolders.isNotEmpty) {
        // تحديث من API في الخلفية
        _refreshFoldersFromRemote();
        return cachedFolders;
      }

      // إذا لم توجد بيانات محلية، جلب من API
      return await _refreshFoldersFromRemote();
    } catch (e) {
      // في حالة الخطأ، محاولة إرجاع البيانات المحلية
      final cachedFolders = await _localDataSource.getCachedFolders();
      if (cachedFolders.isNotEmpty) {
        return cachedFolders;
      }
      rethrow;
    }
  }

  /// تحديث المجلدات من API
  Future<List<Folder>> _refreshFoldersFromRemote() async {
    final response = await _remoteDataSource.getAllFolders();
    if (response.success && response.data != null) {
      final folders = FolderDtoMapper.toDomainList(response.data!);
      // حفظ في Cache
      await _localDataSource.cacheFolders(folders);
      return folders;
    } else {
      throw Exception(response.error ?? 'فشل تحميل المجلدات');
    }
  }

  @override
  Future<List<Folder>> getAvailableFolders() async {
    try {
      final response = await _remoteDataSource.getAvailableFolders();
      if (response.success && response.data != null) {
        return FolderDtoMapper.toDomainList(response.data!);
      } else {
        throw Exception(response.error ?? 'فشل تحميل المجلدات المتاحة');
      }
    } catch (e) {
      // في حالة الخطأ، إرجاع البيانات المحلية
      final cachedFolders = await _localDataSource.getCachedFolders();
      return cachedFolders.where((f) => !f.isHidden).toList();
    }
  }

  @override
  Future<List<dynamic>> getFolderChats(String folderId) async {
    try {
      final response = await _remoteDataSource.getFolderChats(folderId);
      if (response.success && response.data != null) {
        // TODO: تحويل SessionDto إلى Session domain model
        return response.data!;
      } else {
        throw Exception(response.error ?? 'فشل تحميل محادثات المجلد');
      }
    } catch (e) {
      throw Exception('فشل تحميل محادثات المجلد: ${e.toString()}');
    }
  }

  @override
  Future<Folder> createFolder({
    required String name,
    required String icon,
    String? description,
    String? color,
  }) async {
    try {
      final request = CreateFolderRequest(name: name, icon: icon, color: color);
      final response = await _remoteDataSource.createFolder(request);
      if (response.success && response.data != null) {
        final folder = FolderDtoMapper.toDomain(response.data!);
        // حفظ في Cache
        await _localDataSource.cacheFolder(folder);
        return folder;
      } else {
        throw Exception(response.error ?? 'فشل إنشاء المجلد');
      }
    } catch (e) {
      throw Exception('فشل إنشاء المجلد: ${e.toString()}');
    }
  }

  @override
  Future<void> updateFolderName(String folderId, String newName) async {
    try {
      final request = UpdateFolderRequest(folderId: folderId, name: newName);
      final response = await _remoteDataSource.updateFolderName(request);
      if (response.success) {
        // تحديث Cache
        final cachedFolders = await _localDataSource.getCachedFolders();
        final folderIndex =
            cachedFolders.indexWhere((f) => f.id == folderId);
        if (folderIndex >= 0) {
          final updatedFolder =
              cachedFolders[folderIndex].copyWith(name: newName);
          cachedFolders[folderIndex] = updatedFolder;
          await _localDataSource.cacheFolders(cachedFolders);
        }
      } else {
        throw Exception(response.error ?? 'فشل تحديث اسم المجلد');
      }
    } catch (e) {
      throw Exception('فشل تحديث اسم المجلد: ${e.toString()}');
    }
  }

  @override
  Future<void> updateFolderIcon(
    String folderId,
    String icon, {
    String? color,
  }) async {
    try {
      final response =
          await _remoteDataSource.updateFolderIcon(folderId, icon, color: color);
      if (response.success) {
        // تحديث Cache
        final cachedFolders = await _localDataSource.getCachedFolders();
        final folderIndex =
            cachedFolders.indexWhere((f) => f.id == folderId);
        if (folderIndex >= 0) {
          // تحويل FontAwesome string إلى FolderIcon
          final appIcon = AppIcons.fromFontAwesomeClass(icon);
          final folderIcon = appIcon != null
              ? (FolderIconManager.getIconByAppIcon(appIcon) ??
                  FolderIconManager.getIconById('folder_general')!)
              : FolderIconManager.getIconById('folder_general')!;
          
          final updatedFolder =
              cachedFolders[folderIndex].copyWith(
                icon: folderIcon,
                color: color ?? cachedFolders[folderIndex].color,
              );
          cachedFolders[folderIndex] = updatedFolder;
          await _localDataSource.cacheFolders(cachedFolders);
        }
      } else {
        throw Exception(response.error ?? 'فشل تحديث أيقونة المجلد');
      }
    } catch (e) {
      throw Exception('فشل تحديث أيقونة المجلد: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFolder(String folderId) async {
    try {
      final response = await _remoteDataSource.deleteFolder(folderId);
      if (response.success) {
        // حذف من Cache
        await _localDataSource.deleteCachedFolder(folderId);
      } else {
        throw Exception(response.error ?? 'فشل حذف المجلد');
      }
    } catch (e) {
      throw Exception('فشل حذف المجلد: ${e.toString()}');
    }
  }

  @override
  Future<void> updateFolderOrder(List<String> folderIds) async {
    try {
      final request = UpdateFolderOrderRequest(folderIds: folderIds);
      final response = await _remoteDataSource.updateFolderOrder(request);
      if (response.success) {
        // تحديث Cache بالترتيب الجديد
        final cachedFolders = await _localDataSource.getCachedFolders();
        final orderedFolders = folderIds
            .map((id) => cachedFolders.firstWhere((f) => f.id == id))
            .toList();
        // إضافة أي مجلدات غير موجودة في القائمة
        for (final folder in cachedFolders) {
          if (!folderIds.contains(folder.id)) {
            orderedFolders.add(folder);
          }
        }
        await _localDataSource.cacheFolders(orderedFolders);
      } else {
        throw Exception(response.error ?? 'فشل تحديث ترتيب المجلدات');
      }
    } catch (e) {
      throw Exception('فشل تحديث ترتيب المجلدات: ${e.toString()}');
    }
  }
}

