import '../repositories/folder_repository.dart';

/// Use Case للحصول على محادثات المجلد
class GetFolderChatsUseCase {
  final FolderRepository _repository;

  GetFolderChatsUseCase(this._repository);

  /// تنفيذ Use Case
  Future<List<dynamic>> call(String folderId) async {
    if (folderId.isEmpty) {
      throw Exception('معرف المجلد مطلوب');
    }

    return await _repository.getFolderChats(folderId);
  }
}

