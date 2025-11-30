import '../repositories/folder_repository.dart';

/// Use Case لحذف مجلد
class DeleteFolderUseCase {
  final FolderRepository _repository;

  DeleteFolderUseCase(this._repository);

  /// تنفيذ Use Case
  Future<void> call(String folderId) async {
    if (folderId.isEmpty) {
      throw Exception('معرف المجلد مطلوب');
    }

    return await _repository.deleteFolder(folderId);
  }
}

