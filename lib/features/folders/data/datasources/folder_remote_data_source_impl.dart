import '../../../../core/api/base/api_response.dart';
import '../../../../services/api/folder/folder_api_service.dart';
import '../../../../services/api/folder/models/folder_dto.dart';
import '../../../../services/api/folder/models/create_folder_request.dart';
import '../../../../services/api/folder/models/update_folder_request.dart';
import '../../../../services/api/folder/models/update_folder_order_request.dart';
import '../../../../services/api/chat/models/session_dto.dart';
import 'folder_remote_data_source.dart';

/// تنفيذ مصدر البيانات البعيدة للمجلدات
///
/// يستخدم FolderApiService للوصول إلى API
class FolderRemoteDataSourceImpl implements FolderRemoteDataSource {
  final FolderApiService _apiService;

  FolderRemoteDataSourceImpl({required FolderApiService apiService})
      : _apiService = apiService;

  @override
  Future<ApiResponse<List<FolderDto>>> getAllFolders() async {
    return await _apiService.getAllFolders();
  }

  @override
  Future<ApiResponse<List<FolderDto>>> getAvailableFolders() async {
    return await _apiService.getAvailableFolders();
  }

  @override
  Future<ApiResponse<List<SessionDto>>> getFolderChats(String folderId) async {
    return await _apiService.getFolderChats(folderId);
  }

  @override
  Future<ApiResponse<FolderDto>> createFolder(
    CreateFolderRequest request,
  ) async {
    return await _apiService.createFolder(request);
  }

  @override
  Future<ApiResponse<void>> updateFolderName(
    UpdateFolderRequest request,
  ) async {
    return await _apiService.updateFolderName(request);
  }

  @override
  Future<ApiResponse<void>> updateFolderIcon(
    String folderId,
    String icon, {
    String? color,
  }) async {
    return await _apiService.updateFolderIcon(folderId, icon, color: color);
  }

  @override
  Future<ApiResponse<void>> deleteFolder(String folderId) async {
    return await _apiService.deleteFolder(folderId);
  }

  @override
  Future<ApiResponse<void>> updateFolderOrder(
    UpdateFolderOrderRequest request,
  ) async {
    return await _apiService.updateFolderOrder(request.folderIds);
  }
}

