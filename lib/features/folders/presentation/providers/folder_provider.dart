import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/folder.dart';
import '../../domain/models/folder_icon.dart';
import '../../domain/models/folder_type.dart';
import '../../domain/usecases/load_folders_usecase.dart';
import '../../domain/usecases/create_folder_usecase.dart';
import '../../domain/usecases/update_folder_icon_usecase.dart';
import '../../domain/usecases/update_folder_name_usecase.dart';
import '../../domain/usecases/delete_folder_usecase.dart';
import '../../domain/usecases/update_folder_order_usecase.dart';
import '../../data/providers/folder_repository_provider.dart';
import '../../../../state/folder_state.dart';
import '../../../../core/theme/icons.dart';

/// مزود حالة المجلدات
///
/// يدير حالة جميع المجلدات في التطبيق مع العمليات المرتبطة بها
class FolderNotifier extends StateNotifier<FolderState> {
  final LoadFoldersUseCase _loadFoldersUseCase;
  final CreateFolderUseCase _createFolderUseCase;
  final UpdateFolderIconUseCase _updateFolderIconUseCase;
  final UpdateFolderNameUseCase _updateFolderNameUseCase;
  final DeleteFolderUseCase _deleteFolderUseCase;
  final UpdateFolderOrderUseCase _updateFolderOrderUseCase;

  FolderNotifier({
    required LoadFoldersUseCase loadFoldersUseCase,
    required CreateFolderUseCase createFolderUseCase,
    required UpdateFolderIconUseCase updateFolderIconUseCase,
    required UpdateFolderNameUseCase updateFolderNameUseCase,
    required DeleteFolderUseCase deleteFolderUseCase,
    required UpdateFolderOrderUseCase updateFolderOrderUseCase,
  }) : _loadFoldersUseCase = loadFoldersUseCase,
       _createFolderUseCase = createFolderUseCase,
       _updateFolderIconUseCase = updateFolderIconUseCase,
       _updateFolderNameUseCase = updateFolderNameUseCase,
       _deleteFolderUseCase = deleteFolderUseCase,
       _updateFolderOrderUseCase = updateFolderOrderUseCase,
       super(FolderState.initial);

  /// تحميل المجلدات
  Future<void> loadFolders() async {
    try {
      state = state.copyWith(isLoadingFolders: true, error: null);

      final folders = await _loadFoldersUseCase();

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

      // التحقق من عدم تكرار الاسم محلياً
      final existingFolder = state.folders
          .where((f) => f.name.toLowerCase() == name.trim().toLowerCase())
          .firstOrNull;
      if (existingFolder != null) {
        throw Exception('يوجد مجلد بهذا الاسم بالفعل');
      }

      // تحويل FolderIcon إلى FontAwesome string
      final selectedIcon =
          icon ?? FolderIconManager.getIconById('folder_general')!;
      final iconString = AppIcons.toFontAwesomeClass(
        selectedIcon.icon,
        style: 'fas',
      );

      // استخدام Use Case لإنشاء المجلد
      final newFolder = await _createFolderUseCase(
        name: name,
        icon: iconString,
        description: description,
        color: color,
      );

      // إضافة المجلد للحالة
      final updatedFolders = [...state.folders, newFolder];
      state = state.copyWith(folders: updatedFolders, isCreatingFolder: false);
    } catch (e) {
      state = state.copyWith(
        isCreatingFolder: false,
        createError: 'فشل في إنشاء المجلد: ${e.toString()}',
      );
    }
  }

  /// تحديث أيقونة المجلد
  Future<void> updateFolderIcon(
    String folderId,
    String iconId, {
    String? color,
  }) async {
    try {
      state = state.copyWith(isUpdatingFolder: true, updateError: null);

      final folder = state.getFolderById(folderId);
      if (folder == null) {
        throw Exception('المجلد غير موجود');
      }

      if (!folder.isIconChangeable) {
        throw Exception('لا يمكن تغيير أيقونة هذا المجلد');
      }

      // الحصول على FolderIcon وتحويله إلى FontAwesome string
      final selectedFolderIcon =
          FolderIconManager.getIconById(iconId) ??
          FolderIconManager.getIconById('folder_general')!;
      final iconString = AppIcons.toFontAwesomeClass(
        selectedFolderIcon.icon,
        style: 'fas',
      );

      // استخدام Use Case لتحديث الأيقونة (سيقوم برمي Exception إذا فشل)
      await _updateFolderIconUseCase(
        folderId: folderId,
        icon: iconString,
        color: color,
      );

      // إعادة تحميل المجلدات من API للحصول على البيانات المحدثة
      final reloadedFolders = await _loadFoldersUseCase();

      // تحديث الحالة بالبيانات المحدثة من API
      state = state.copyWith(folders: reloadedFolders, isUpdatingFolder: false);

      // تحديث المجلد المحدد إذا كان هو نفسه
      final updatedFolder = reloadedFolders.firstWhere(
        (f) => f.id == folderId,
        orElse: () => folder.copyWith(
          icon: selectedFolderIcon,
          color: color ?? folder.color,
          updatedAt: DateTime.now(),
        ),
      );

      if (state.selectedFolder?.id == folderId) {
        state = state.copyWith(selectedFolder: updatedFolder);
      }
    } catch (e) {
      state = state.copyWith(
        isUpdatingFolder: false,
        updateError: 'فشل في تحديث أيقونة المجلد: ${e.toString()}',
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

      // تحديث الاسم في API إذا تغير
      if (name != null && name.trim() != folder.name) {
        await _updateFolderNameUseCase(folderId, name.trim());
      }

      // تحديث الأيقونة في API إذا تغيرت
      if (icon != null && icon.id != folder.icon.id) {
        final iconString = AppIcons.toFontAwesomeClass(icon.icon, style: 'fas');
        await _updateFolderIconUseCase(
          folderId: folderId,
          icon: iconString,
          color: color,
        );
      }

      // إعادة تحميل المجلدات من API للحصول على البيانات المحدثة
      final reloadedFolders = await _loadFoldersUseCase();

      // تحديث الحالة بالبيانات المحدثة من API
      state = state.copyWith(folders: reloadedFolders, isUpdatingFolder: false);

      // تحديث المجلد المحدد إذا كان هو نفسه
      final finalUpdatedFolder = reloadedFolders.firstWhere(
        (f) => f.id == folderId,
        orElse: () => updatedFolder,
      );

      if (state.selectedFolder?.id == folderId) {
        state = state.copyWith(selectedFolder: finalUpdatedFolder);
      }
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

      // استخدام Use Case لحذف المجلد
      await _deleteFolderUseCase(folderId);

      // حذف المجلد من الحالة
      final updatedFolders = state.folders
          .where((f) => f.id != folderId)
          .toList();

      state = state.copyWith(folders: updatedFolders, isDeletingFolder: false);

      // إلغاء تحديد المجلد إذا كان محذوفاً
      if (state.selectedFolder?.id == folderId) {
        state = state.copyWith(selectedFolder: null);
      }
    } catch (e) {
      state = state.copyWith(
        isDeletingFolder: false,
        deleteError: 'فشل في حذف المجلد: ${e.toString()}',
      );
    }
  }

  /// تحديث اسم المجلد
  Future<void> updateFolderName(String folderId, String newName) async {
    try {
      state = state.copyWith(isUpdatingFolder: true, updateError: null);

      final folder = state.getFolderById(folderId);
      if (folder == null) {
        throw Exception('المجلد غير موجود');
      }

      if (!folder.isEditable) {
        throw Exception('لا يمكن تعديل هذا المجلد');
      }

      // استخدام Use Case لتحديث الاسم
      await _updateFolderNameUseCase(folderId, newName.trim());

      // تحديث الحالة
      final updatedFolder = folder.copyWith(
        name: newName.trim(),
        updatedAt: DateTime.now(),
      );

      final updatedFolders = state.folders.map((f) {
        return f.id == folderId ? updatedFolder : f;
      }).toList();

      state = state.copyWith(folders: updatedFolders, isUpdatingFolder: false);

      // تحديث المجلد المحدد إذا كان هو نفسه
      if (state.selectedFolder?.id == folderId) {
        state = state.copyWith(selectedFolder: updatedFolder);
      }
    } catch (e) {
      state = state.copyWith(
        isUpdatingFolder: false,
        updateError: 'فشل في تحديث اسم المجلد: ${e.toString()}',
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
    final previousFolders = List<Folder>.from(state.folders);
    try {
      state = state.copyWith(
        folders: reorderedFolders,
        isUpdatingFolder: true,
        updateError: null,
      );

      // استخراج معرفات المجلدات بالترتيب الجديد
      final folderIds = reorderedFolders.map((f) => f.id).toList();

      // استخدام Use Case لتحديث الترتيب
      await _updateFolderOrderUseCase(folderIds);
      state = state.copyWith(isUpdatingFolder: false);
    } catch (e) {
      state = state.copyWith(
        folders: previousFolders,
        isUpdatingFolder: false,
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

/// Providers للـ Use Cases
final loadFoldersUseCaseProvider = Provider<LoadFoldersUseCase>((ref) {
  return LoadFoldersUseCase(ref.watch(folderRepositoryProvider));
});

final createFolderUseCaseProvider = Provider<CreateFolderUseCase>((ref) {
  return CreateFolderUseCase(ref.watch(folderRepositoryProvider));
});

final updateFolderIconUseCaseProvider = Provider<UpdateFolderIconUseCase>((
  ref,
) {
  return UpdateFolderIconUseCase(ref.watch(folderRepositoryProvider));
});

final updateFolderNameUseCaseProvider = Provider<UpdateFolderNameUseCase>((
  ref,
) {
  return UpdateFolderNameUseCase(ref.watch(folderRepositoryProvider));
});

final deleteFolderUseCaseProvider = Provider<DeleteFolderUseCase>((ref) {
  return DeleteFolderUseCase(ref.watch(folderRepositoryProvider));
});

final updateFolderOrderUseCaseProvider = Provider<UpdateFolderOrderUseCase>((
  ref,
) {
  return UpdateFolderOrderUseCase(ref.watch(folderRepositoryProvider));
});

/// مزود حالة المجلدات
final folderProvider = StateNotifierProvider<FolderNotifier, FolderState>((
  ref,
) {
  return FolderNotifier(
    loadFoldersUseCase: ref.watch(loadFoldersUseCaseProvider),
    createFolderUseCase: ref.watch(createFolderUseCaseProvider),
    updateFolderIconUseCase: ref.watch(updateFolderIconUseCaseProvider),
    updateFolderNameUseCase: ref.watch(updateFolderNameUseCaseProvider),
    deleteFolderUseCase: ref.watch(deleteFolderUseCaseProvider),
    updateFolderOrderUseCase: ref.watch(updateFolderOrderUseCaseProvider),
  );
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
