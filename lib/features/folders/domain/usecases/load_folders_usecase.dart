import '../models/folder.dart';
import '../repositories/folder_repository.dart';

/// Use Case لتحميل المجلدات
class LoadFoldersUseCase {
  final FolderRepository _repository;

  LoadFoldersUseCase(this._repository);

  /// تنفيذ Use Case
  Future<List<Folder>> call() async {
    return await _repository.getAllFolders();
  }
}

