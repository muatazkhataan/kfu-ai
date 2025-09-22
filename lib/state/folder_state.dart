import '../features/folders/domain/models/folder.dart';

/// حالة المجلدات
///
/// يمثل هذا الكلاس حالة جميع المجلدات في التطبيق
class FolderState {
  /// قائمة جميع المجلدات
  final List<Folder> folders;

  /// المجلد المحدد حالياً
  final Folder? selectedFolder;

  /// هل يتم تحميل المجلدات
  final bool isLoadingFolders;

  /// هل يتم إنشاء مجلد جديد
  final bool isCreatingFolder;

  /// هل يتم تحديث مجلد
  final bool isUpdatingFolder;

  /// هل يتم حذف مجلد
  final bool isDeletingFolder;

  /// خطأ في المجلدات
  final String? error;

  /// خطأ في إنشاء المجلد
  final String? createError;

  /// خطأ في تحديث المجلد
  final String? updateError;

  /// خطأ في حذف المجلد
  final String? deleteError;

  /// هل تم تحميل المجلدات لأول مرة
  final bool hasLoadedInitial;

  const FolderState({
    this.folders = const [],
    this.selectedFolder,
    this.isLoadingFolders = false,
    this.isCreatingFolder = false,
    this.isUpdatingFolder = false,
    this.isDeletingFolder = false,
    this.error,
    this.createError,
    this.updateError,
    this.deleteError,
    this.hasLoadedInitial = false,
  });

  /// إنشاء نسخة من الحالة مع تعديلات
  FolderState copyWith({
    List<Folder>? folders,
    Folder? selectedFolder,
    bool? isLoadingFolders,
    bool? isCreatingFolder,
    bool? isUpdatingFolder,
    bool? isDeletingFolder,
    String? error,
    String? createError,
    String? updateError,
    String? deleteError,
    bool? hasLoadedInitial,
  }) {
    return FolderState(
      folders: folders ?? this.folders,
      selectedFolder: selectedFolder ?? this.selectedFolder,
      isLoadingFolders: isLoadingFolders ?? this.isLoadingFolders,
      isCreatingFolder: isCreatingFolder ?? this.isCreatingFolder,
      isUpdatingFolder: isUpdatingFolder ?? this.isUpdatingFolder,
      isDeletingFolder: isDeletingFolder ?? this.isDeletingFolder,
      error: error ?? this.error,
      createError: createError ?? this.createError,
      updateError: updateError ?? this.updateError,
      deleteError: deleteError ?? this.deleteError,
      hasLoadedInitial: hasLoadedInitial ?? this.hasLoadedInitial,
    );
  }

  /// الحالة الأولية
  static const FolderState initial = FolderState();

  /// التحقق من وجود مجلدات
  bool get hasFolders => folders.isNotEmpty;

  /// التحقق من وجود مجلد محدد
  bool get hasSelectedFolder => selectedFolder != null;

  /// التحقق من وجود خطأ
  bool get hasError =>
      error != null ||
      createError != null ||
      updateError != null ||
      deleteError != null;

  /// التحقق من كون المجلدات محملة
  bool get isLoaded => hasLoadedInitial && !isLoadingFolders;

  /// التحقق من كون المجلدات جاهزة للاستخدام
  bool get isReady => isLoaded && !hasError;

  /// التحقق من وجود عمليات جارية
  bool get hasOngoingOperations =>
      isCreatingFolder || isUpdatingFolder || isDeletingFolder;

  /// الحصول على عدد المجلدات
  int get folderCount => folders.length;

  /// الحصول على المجلدات الثابتة
  List<Folder> get fixedFolders =>
      folders.where((folder) => folder.isFixed).toList();

  /// الحصول على المجلدات المخصصة
  List<Folder> get customFolders =>
      folders.where((folder) => folder.isCustom).toList();

  /// الحصول على المجلدات النظامية
  List<Folder> get systemFolders =>
      folders.where((folder) => folder.isSystem).toList();

  /// الحصول على المجلدات المقيدة
  List<Folder> get pinnedFolders =>
      folders.where((folder) => folder.isPinned).toList();

  /// الحصول على المجلدات المرئية
  List<Folder> get visibleFolders =>
      folders.where((folder) => !folder.isHidden).toList();

  /// الحصول على المجلدات الفارغة
  List<Folder> get emptyFolders =>
      folders.where((folder) => folder.isEmpty).toList();

  /// الحصول على المجلدات غير الفارغة
  List<Folder> get nonEmptyFolders =>
      folders.where((folder) => !folder.isEmpty).toList();

  /// الحصول على المجلدات القابلة للتعديل
  List<Folder> get editableFolders =>
      folders.where((folder) => folder.isEditable).toList();

  /// الحصول على المجلدات القابلة للحذف
  List<Folder> get deletableFolders =>
      folders.where((folder) => folder.isDeletable).toList();

  /// الحصول على المجلد بالمعرف
  Folder? getFolderById(String id) {
    try {
      return folders.firstWhere((folder) => folder.id == id);
    } catch (e) {
      return null;
    }
  }

  /// الحصول على المجلدات بالاسم
  List<Folder> getFoldersByName(String name) {
    return folders
        .where(
          (folder) => folder.name.toLowerCase().contains(name.toLowerCase()),
        )
        .toList();
  }

  /// الحصول على المجلدات بالمعرف
  List<Folder> getFoldersByType(String type) {
    return folders.where((folder) => folder.type.value == type).toList();
  }

  /// الحصول على المجلدات مرتبة حسب الاسم
  List<Folder> get foldersSortedByName {
    final sortedFolders = List<Folder>.from(folders);
    sortedFolders.sort((a, b) => a.name.compareTo(b.name));
    return sortedFolders;
  }

  /// الحصول على المجلدات مرتبة حسب تاريخ الإنشاء
  List<Folder> get foldersSortedByDate {
    final sortedFolders = List<Folder>.from(folders);
    sortedFolders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedFolders;
  }

  /// الحصول على المجلدات مرتبة حسب آخر نشاط
  List<Folder> get foldersSortedByActivity {
    final sortedFolders = List<Folder>.from(folders);
    sortedFolders.sort((a, b) {
      final aActivity = a.lastActivityAt ?? a.updatedAt;
      final bActivity = b.lastActivityAt ?? b.updatedAt;
      return bActivity.compareTo(aActivity);
    });
    return sortedFolders;
  }

  /// الحصول على المجلدات مرتبة حسب عدد المحادثات
  List<Folder> get foldersSortedByChatCount {
    final sortedFolders = List<Folder>.from(folders);
    sortedFolders.sort((a, b) => b.chatCount.compareTo(a.chatCount));
    return sortedFolders;
  }

  /// الحصول على إجمالي عدد المحادثات في جميع المجلدات
  int get totalChatCount =>
      folders.fold(0, (sum, folder) => sum + folder.chatCount);

  /// الحصول على عدد المجلدات الفارغة
  int get emptyFolderCount => emptyFolders.length;

  /// الحصول على عدد المجلدات المخصصة
  int get customFolderCount => customFolders.length;

  /// الحصول على عدد المجلدات الثابتة
  int get fixedFolderCount => fixedFolders.length;

  /// الحصول على معاينة الحالة
  String get preview {
    if (hasFolders) {
      return '${folderCount} مجلد، ${totalChatCount} محادثة';
    } else if (isLoadingFolders) {
      return 'جاري تحميل المجلدات...';
    } else if (hasError) {
      return 'خطأ في تحميل المجلدات';
    } else {
      return 'لا توجد مجلدات';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderState &&
          runtimeType == other.runtimeType &&
          folders == other.folders &&
          selectedFolder == other.selectedFolder &&
          isLoadingFolders == other.isLoadingFolders &&
          isCreatingFolder == other.isCreatingFolder &&
          isUpdatingFolder == other.isUpdatingFolder &&
          isDeletingFolder == other.isDeletingFolder &&
          error == other.error &&
          createError == other.createError &&
          updateError == other.updateError &&
          deleteError == other.deleteError &&
          hasLoadedInitial == other.hasLoadedInitial;

  @override
  int get hashCode {
    return Object.hash(
      folders,
      selectedFolder,
      isLoadingFolders,
      isCreatingFolder,
      isUpdatingFolder,
      isDeletingFolder,
      error,
      createError,
      updateError,
      deleteError,
      hasLoadedInitial,
    );
  }

  @override
  String toString() {
    return 'FolderState(folderCount: $folderCount, selectedFolder: $selectedFolder, isLoading: $isLoadingFolders, hasError: $hasError)';
  }
}
