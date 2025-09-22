import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/folder.dart';
import '../../domain/models/folder_icon.dart';
import '../../domain/models/folder_type.dart';
import '../../../../state/folder_state.dart';

/// مزود حالة المجلدات
///
/// يدير حالة جميع المجلدات في التطبيق مع العمليات المرتبطة بها
class FolderNotifier extends StateNotifier<FolderState> {
  FolderNotifier() : super(FolderState.initial);

  /// تحميل المجلدات
  Future<void> loadFolders() async {
    try {
      state = state.copyWith(isLoadingFolders: true, error: null);

      // TODO: تحميل المجلدات من قاعدة البيانات
      await Future.delayed(const Duration(milliseconds: 500));

      // إنشاء المجلدات الافتراضية
      final folders = Folder.createDefaultFolders();

      state = state.copyWith(
        folders: folders,
        isLoadingFolders: false,
        hasLoadedInitial: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingFolders: false,
        error: 'فشل في تحميل المجلدات: ${e.toString()}',
      );
    }
  }

  /// إنشاء مجلد جديد
  Future<void> createFolder({
    required String name,
    String? description,
    FolderIcon? icon,
    String? color,
  }) async {
    try {
      state = state.copyWith(isCreatingFolder: true, createError: null);

      // TODO: التحقق من صحة البيانات
      if (name.trim().isEmpty) {
        throw Exception('اسم المجلد مطلوب');
      }

      // التحقق من عدم تكرار الاسم
      final existingFolder = state.getFolderById(name.trim());
      if (existingFolder != null) {
        throw Exception('يوجد مجلد بهذا الاسم بالفعل');
      }

      // إنشاء المجلد الجديد
      final newFolder = Folder.create(
        name: name.trim(),
        description: description?.trim(),
        userId: 'user_123', // TODO: الحصول من مصدر المستخدم الحالي
        icon: icon ?? FolderIconManager.getIconById('folder_general')!,
        color: color,
      );

      // إضافة المجلد للحالة
      final updatedFolders = [...state.folders, newFolder];
      state = state.copyWith(folders: updatedFolders, isCreatingFolder: false);

      // TODO: حفظ المجلد في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        isCreatingFolder: false,
        createError: 'فشل في إنشاء المجلد: ${e.toString()}',
      );
    }
  }

  /// تحديث مجلد موجود
  Future<void> updateFolder(
    String folderId, {
    String? name,
    String? description,
    FolderIcon? icon,
    String? color,
  }) async {
    try {
      state = state.copyWith(isUpdatingFolder: true, updateError: null);

      final folder = state.getFolderById(folderId);
      if (folder == null) {
        throw Exception('المجلد غير موجود');
      }

      if (!folder.isEditable) {
        throw Exception('لا يمكن تعديل هذا المجلد');
      }

      // التحقق من عدم تكرار الاسم (إذا تم تغييره)
      if (name != null && name.trim() != folder.name) {
        final existingFolder = state.getFolderById(name.trim());
        if (existingFolder != null && existingFolder.id != folderId) {
          throw Exception('يوجد مجلد بهذا الاسم بالفعل');
        }
      }

      // تحديث المجلد
      final updatedFolder = folder.copyWith(
        name: name?.trim() ?? folder.name,
        description: description?.trim() ?? folder.description,
        icon: icon ?? folder.icon,
        color: color ?? folder.color,
        updatedAt: DateTime.now(),
      );

      // تحديث الحالة
      final updatedFolders = state.folders.map((f) {
        return f.id == folderId ? updatedFolder : f;
      }).toList();

      state = state.copyWith(folders: updatedFolders, isUpdatingFolder: false);

      // تحديث المجلد المحدد إذا كان هو نفسه
      if (state.selectedFolder?.id == folderId) {
        state = state.copyWith(selectedFolder: updatedFolder);
      }

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        isUpdatingFolder: false,
        updateError: 'فشل في تحديث المجلد: ${e.toString()}',
      );
    }
  }

  /// حذف مجلد
  Future<void> deleteFolder(String folderId) async {
    try {
      state = state.copyWith(isDeletingFolder: true, deleteError: null);

      final folder = state.getFolderById(folderId);
      if (folder == null) {
        throw Exception('المجلد غير موجود');
      }

      if (!folder.isDeletable) {
        throw Exception('لا يمكن حذف هذا المجلد');
      }

      // التحقق من وجود محادثات في المجلد
      if (folder.hasChats) {
        throw Exception('لا يمكن حذف مجلد يحتوي على محادثات');
      }

      // حذف المجلد من الحالة
      final updatedFolders = state.folders
          .where((f) => f.id != folderId)
          .toList();

      state = state.copyWith(folders: updatedFolders, isDeletingFolder: false);

      // إلغاء تحديد المجلد إذا كان محذوفاً
      if (state.selectedFolder?.id == folderId) {
        state = state.copyWith(selectedFolder: null);
      }

      // TODO: حذف المجلد من قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        isDeletingFolder: false,
        deleteError: 'فشل في حذف المجلد: ${e.toString()}',
      );
    }
  }

  /// تحديد مجلد
  void selectFolder(String folderId) {
    final folder = state.getFolderById(folderId);
    if (folder != null) {
      state = state.copyWith(selectedFolder: folder);
    }
  }

  /// إلغاء تحديد المجلد
  void deselectFolder() {
    state = state.copyWith(selectedFolder: null);
  }

  /// تحديث عدد المحادثات في مجلد
  Future<void> updateFolderChatCount(String folderId, int newCount) async {
    try {
      final updatedFolders = state.folders.map((folder) {
        if (folder.id == folderId) {
          return folder.copyWith(
            chatCount: newCount,
            updatedAt: DateTime.now(),
          );
        }
        return folder;
      }).toList();

      state = state.copyWith(folders: updatedFolders);

      // تحديث المجلد المحدد إذا كان هو نفسه
      if (state.selectedFolder?.id == folderId) {
        final updatedFolder = updatedFolders.firstWhere(
          (f) => f.id == folderId,
        );
        state = state.copyWith(selectedFolder: updatedFolder);
      }

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      // يمكن تجاهل هذا الخطأ أو تسجيله
      print('فشل في تحديث عدد المحادثات: ${e.toString()}');
    }
  }

  /// تحديث آخر نشاط في مجلد
  Future<void> updateFolderLastActivity(String folderId) async {
    try {
      final now = DateTime.now();
      final updatedFolders = state.folders.map((folder) {
        if (folder.id == folderId) {
          return folder.copyWith(lastActivityAt: now, updatedAt: now);
        }
        return folder;
      }).toList();

      state = state.copyWith(folders: updatedFolders);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      // يمكن تجاهل هذا الخطأ أو تسجيله
      print('فشل في تحديث آخر نشاط: ${e.toString()}');
    }
  }

  /// تبديل حالة التثبيت
  Future<void> toggleFolderPin(String folderId) async {
    try {
      final folder = state.getFolderById(folderId);
      if (folder == null) return;

      final updatedFolder = folder.copyWith(
        isPinned: !folder.isPinned,
        updatedAt: DateTime.now(),
      );

      final updatedFolders = state.folders.map((f) {
        return f.id == folderId ? updatedFolder : f;
      }).toList();

      state = state.copyWith(folders: updatedFolders);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        updateError: 'فشل في تبديل التثبيت: ${e.toString()}',
      );
    }
  }

  /// تبديل حالة الإخفاء
  Future<void> toggleFolderVisibility(String folderId) async {
    try {
      final folder = state.getFolderById(folderId);
      if (folder == null) return;

      final updatedFolder = folder.copyWith(
        isHidden: !folder.isHidden,
        updatedAt: DateTime.now(),
      );

      final updatedFolders = state.folders.map((f) {
        return f.id == folderId ? updatedFolder : f;
      }).toList();

      state = state.copyWith(folders: updatedFolders);

      // TODO: حفظ التحديث في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        updateError: 'فشل في تبديل الإخفاء: ${e.toString()}',
      );
    }
  }

  /// البحث في المجلدات
  List<Folder> searchFolders(String query) {
    if (query.trim().isEmpty) return state.folders;

    final lowercaseQuery = query.toLowerCase();
    return state.folders.where((folder) {
      return folder.name.toLowerCase().contains(lowercaseQuery) ||
          folder.description?.toLowerCase().contains(lowercaseQuery) == true;
    }).toList();
  }

  /// الحصول على المجلدات حسب النوع
  List<Folder> getFoldersByType(FolderType type) {
    return state.folders.where((folder) => folder.type == type).toList();
  }

  /// الحصول على المجلدات المقيدة
  List<Folder> getPinnedFolders() {
    return state.folders.where((folder) => folder.isPinned).toList();
  }

  /// الحصول على المجلدات المرئية
  List<Folder> getVisibleFolders() {
    return state.folders.where((folder) => !folder.isHidden).toList();
  }

  /// الحصول على المجلدات الفارغة
  List<Folder> getEmptyFolders() {
    return state.folders.where((folder) => folder.isEmpty).toList();
  }

  /// إعادة ترتيب المجلدات
  Future<void> reorderFolders(List<Folder> reorderedFolders) async {
    try {
      state = state.copyWith(folders: reorderedFolders);
      // TODO: حفظ الترتيب الجديد في قاعدة البيانات
    } catch (e) {
      state = state.copyWith(
        updateError: 'فشل في إعادة ترتيب المجلدات: ${e.toString()}',
      );
    }
  }

  /// إعادة تعيين الحالة
  void reset() {
    state = FolderState.initial;
  }

  /// مسح الأخطاء
  void clearErrors() {
    state = state.copyWith(
      error: null,
      createError: null,
      updateError: null,
      deleteError: null,
    );
  }

  /// إعادة تحميل المجلدات
  Future<void> refresh() async {
    await loadFolders();
  }
}

/// مزود حالة المجلدات
final folderProvider = StateNotifierProvider<FolderNotifier, FolderState>((
  ref,
) {
  return FolderNotifier();
});

/// مزود قائمة المجلدات
final foldersProvider = Provider<List<Folder>>((ref) {
  return ref.watch(folderProvider).folders;
});

/// مزود المجلد المحدد
final selectedFolderProvider = Provider<Folder?>((ref) {
  return ref.watch(folderProvider).selectedFolder;
});

/// مزود المجلدات المرئية
final visibleFoldersProvider = Provider<List<Folder>>((ref) {
  return ref.watch(folderProvider).visibleFolders;
});

/// مزود المجلدات المقيدة
final pinnedFoldersProvider = Provider<List<Folder>>((ref) {
  return ref.watch(folderProvider).pinnedFolders;
});

/// مزود المجلدات الثابتة
final fixedFoldersProvider = Provider<List<Folder>>((ref) {
  return ref.watch(folderProvider).fixedFolders;
});

/// مزود المجلدات المخصصة
final customFoldersProvider = Provider<List<Folder>>((ref) {
  return ref.watch(folderProvider).customFolders;
});

/// مزود المجلدات الفارغة
final emptyFoldersProvider = Provider<List<Folder>>((ref) {
  return ref.watch(folderProvider).emptyFolders;
});

/// مزود حالة التحميل
final foldersLoadingProvider = Provider<bool>((ref) {
  return ref.watch(folderProvider).isLoadingFolders;
});

/// مزود الأخطاء
final foldersErrorProvider = Provider<String?>((ref) {
  final folderState = ref.watch(folderProvider);
  return folderState.error ??
      folderState.createError ??
      folderState.updateError ??
      folderState.deleteError;
});

/// مزود العمليات الجارية
final foldersOperationsProvider = Provider<bool>((ref) {
  final folderState = ref.watch(folderProvider);
  return folderState.hasOngoingOperations;
});
