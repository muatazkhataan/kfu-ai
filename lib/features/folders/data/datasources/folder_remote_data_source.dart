import '../../../../core/api/base/api_response.dart';
import '../../../../services/api/folder/models/folder_dto.dart';
import '../../../../services/api/folder/models/create_folder_request.dart';
import '../../../../services/api/folder/models/update_folder_request.dart';
import '../../../../services/api/folder/models/update_folder_order_request.dart';
import '../../../../services/api/chat/models/session_dto.dart';

/// مصدر البيانات البعيدة للمجلدات
///
/// واجهة لجميع عمليات API المتعلقة بالمجلدات
abstract class FolderRemoteDataSource {
  /// الحصول على جميع المجلدات
  Future<ApiResponse<List<FolderDto>>> getAllFolders();

  /// الحصول على المجلدات المتاحة
  Future<ApiResponse<List<FolderDto>>> getAvailableFolders();

  /// الحصول على محادثات مجلد معين
  Future<ApiResponse<List<SessionDto>>> getFolderChats(String folderId);

  /// إنشاء مجلد جديد
  Future<ApiResponse<FolderDto>> createFolder(CreateFolderRequest request);

  /// تحديث اسم المجلد
  Future<ApiResponse<void>> updateFolderName(UpdateFolderRequest request);

  /// تحديث أيقونة المجلد
  Future<ApiResponse<void>> updateFolderIcon(
    String folderId,
    String icon, {
    String? color,
  });

  /// حذف مجلد
  Future<ApiResponse<void>> deleteFolder(String folderId);

  /// تحديث ترتيب المجلدات
  Future<ApiResponse<void>> updateFolderOrder(
    UpdateFolderOrderRequest request,
  );
}

