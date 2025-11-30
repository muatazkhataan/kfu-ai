import '../models/folder.dart';
import '../repositories/folder_repository.dart';

/// Use Case لإنشاء مجلد جديد
class CreateFolderUseCase {
  final FolderRepository _repository;

  CreateFolderUseCase(this._repository);

  /// تنفيذ Use Case
  Future<Folder> call({
    required String name,
    required String icon,
    String? description,
    String? color,
  }) async {
    // التحقق من صحة البيانات
    if (name.trim().isEmpty) {
      throw Exception('اسم المجلد مطلوب');
    }

    if (name.trim().length < 2) {
      throw Exception('اسم المجلد يجب أن يكون على الأقل حرفين');
    }

    if (name.trim().length > 50) {
      throw Exception('اسم المجلد يجب ألا يتجاوز 50 حرفاً');
    }

    return await _repository.createFolder(
      name: name.trim(),
      icon: icon,
      description: description?.trim(),
      color: color,
    );
  }
}

