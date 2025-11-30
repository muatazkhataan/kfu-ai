import '../repositories/folder_repository.dart';

/// Use Case لتحديث ترتيب المجلدات
class UpdateFolderOrderUseCase {
  final FolderRepository _repository;

  UpdateFolderOrderUseCase(this._repository);

  /// تنفيذ Use Case
  Future<void> call(List<String> folderIds) async {
    if (folderIds.isEmpty) {
      throw Exception('قائمة المجلدات فارغة');
    }

    // التحقق من عدم وجود تكرار
    final uniqueIds = folderIds.toSet();
    if (uniqueIds.length != folderIds.length) {
      throw Exception('يوجد تكرار في معرفات المجلدات');
    }

    return await _repository.updateFolderOrder(folderIds);
  }
}

