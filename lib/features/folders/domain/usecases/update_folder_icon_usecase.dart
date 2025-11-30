import '../repositories/folder_repository.dart';

/// Use Case لتحديث أيقونة المجلد
class UpdateFolderIconUseCase {
  final FolderRepository _repository;

  UpdateFolderIconUseCase(this._repository);

  /// تنفيذ Use Case
  Future<void> call({
    required String folderId,
    required String icon,
    String? color,
  }) async {
    if (folderId.isEmpty) {
      throw Exception('معرف المجلد مطلوب');
    }

    if (icon.isEmpty) {
      throw Exception('الأيقونة مطلوبة');
    }

    return await _repository.updateFolderIcon(folderId, icon, color: color);
  }
}

