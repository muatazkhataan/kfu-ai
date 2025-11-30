import '../repositories/folder_repository.dart';

/// Use Case لتحديث اسم المجلد
class UpdateFolderNameUseCase {
  final FolderRepository _repository;

  UpdateFolderNameUseCase(this._repository);

  /// تنفيذ Use Case
  Future<void> call(String folderId, String newName) async {
    if (folderId.isEmpty) {
      throw Exception('معرف المجلد مطلوب');
    }

    if (newName.trim().isEmpty) {
      throw Exception('اسم المجلد مطلوب');
    }

    if (newName.trim().length < 2) {
      throw Exception('اسم المجلد يجب أن يكون على الأقل حرفين');
    }

    if (newName.trim().length > 50) {
      throw Exception('اسم المجلد يجب ألا يتجاوز 50 حرفاً');
    }

    return await _repository.updateFolderName(folderId, newName.trim());
  }
}

