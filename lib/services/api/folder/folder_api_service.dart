import '../../../core/api/base/api_client.dart';
import '../../../core/api/base/api_response.dart';
import '../../../core/api/config/api_endpoints.dart';
import 'models/folder_dto.dart';
import 'models/create_folder_request.dart';
import 'models/update_folder_request.dart';
import 'models/delete_folder_request.dart';
import 'models/update_folder_order_request.dart';
import '../chat/models/session_dto.dart';

/// خدمة API للمجلدات
///
/// تدير جميع العمليات المتعلقة بالمجلدات
class FolderApiService {
  /// API Client
  final ApiClient _apiClient;

  /// Constructor
  FolderApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// الحصول على جميع المجلدات
  Future<ApiResponse<List<FolderDto>>> getAllFolders() async {
    try {
      final response = await _apiClient.get<List<FolderDto>>(
        endpoint: ApiEndpoints.getAllFolders,
        fromJson: (json) {
          if (json is List) {
            return json.map((item) => FolderDto.fromJson(item)).toList();
          }
          return [];
        },
      );
      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل الحصول على المجلدات: ${e.toString()}',
        errorCode: 'GET_FOLDERS_FAILED',
        statusCode: 500,
      );
    }
  }

  /// الحصول على المجلدات المتاحة
  Future<ApiResponse<List<FolderDto>>> getAvailableFolders() async {
    try {
      final response = await _apiClient.get<List<FolderDto>>(
        endpoint: ApiEndpoints.getAvailableFolders,
        fromJson: (json) {
          if (json is List) {
            return json.map((item) => FolderDto.fromJson(item)).toList();
          }
          return [];
        },
      );
      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل الحصول على المجلدات المتاحة: ${e.toString()}',
        errorCode: 'GET_AVAILABLE_FOLDERS_FAILED',
        statusCode: 500,
      );
    }
  }

  /// الحصول على محادثات المجلد
  Future<ApiResponse<List<SessionDto>>> getFolderChats(String folderId) async {
    try {
      if (folderId.isEmpty) {
        return ApiResponse.error(
          error: 'معرف المجلد غير صالح',
          errorCode: 'INVALID_FOLDER_ID',
          statusCode: 400,
        );
      }

      final response = await _apiClient.get<List<SessionDto>>(
        endpoint: ApiEndpoints.getFolderChats,
        queryParameters: {'folderId': folderId},
        fromJson: (json) {
          if (json is List) {
            return json.map((item) => SessionDto.fromJson(item)).toList();
          }
          return [];
        },
      );
      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل الحصول على محادثات المجلد: ${e.toString()}',
        errorCode: 'GET_FOLDER_CHATS_FAILED',
        statusCode: 500,
      );
    }
  }

  /// إنشاء مجلد جديد
  Future<ApiResponse<FolderDto>> createFolder(
    CreateFolderRequest request,
  ) async {
    try {
      if (!request.isValid) {
        return ApiResponse.error(
          error: 'يرجى إدخال اسم المجلد',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      final response = await _apiClient.post<FolderDto>(
        endpoint: ApiEndpoints.createFolder,
        body: request.toJson(),
        fromJson: (json) => FolderDto.fromJson(json),
      );
      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل إنشاء المجلد: ${e.toString()}',
        errorCode: 'CREATE_FOLDER_FAILED',
        statusCode: 500,
      );
    }
  }

  /// تحديث اسم المجلد
  Future<ApiResponse<void>> updateFolderName(
    UpdateFolderRequest request,
  ) async {
    try {
      if (!request.isValid) {
        return ApiResponse.error(
          error: 'معرف المجلد أو الاسم غير صالح',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.updateFolderName,
        body: request.toJson(),
      );
      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل تحديث اسم المجلد: ${e.toString()}',
        errorCode: 'UPDATE_FOLDER_NAME_FAILED',
        statusCode: 500,
      );
    }
  }

  /// تحديث أيقونة المجلد
  Future<ApiResponse<void>> updateFolderIcon(
    String folderId,
    String icon,
  ) async {
    try {
      if (folderId.isEmpty || icon.isEmpty) {
        return ApiResponse.error(
          error: 'معرف المجلد أو الأيقونة غير صالح',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.updateFolderIcon,
        body: {'folderId': folderId, 'Icon': icon},
      );
      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل تحديث أيقونة المجلد: ${e.toString()}',
        errorCode: 'UPDATE_FOLDER_ICON_FAILED',
        statusCode: 500,
      );
    }
  }

  /// حذف مجلد
  Future<ApiResponse<void>> deleteFolder(String folderId) async {
    try {
      if (folderId.isEmpty) {
        return ApiResponse.error(
          error: 'معرف المجلد غير صالح',
          errorCode: 'INVALID_FOLDER_ID',
          statusCode: 400,
        );
      }

      final request = DeleteFolderRequest(folderId: folderId);
      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.deleteFolder,
        body: request.toJson(),
      );
      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل حذف المجلد: ${e.toString()}',
        errorCode: 'DELETE_FOLDER_FAILED',
        statusCode: 500,
      );
    }
  }

  /// تحديث ترتيب المجلدات
  Future<ApiResponse<void>> updateFolderOrder(List<String> folderIds) async {
    try {
      if (folderIds.isEmpty) {
        return ApiResponse.error(
          error: 'قائمة المجلدات فارغة',
          errorCode: 'EMPTY_FOLDER_LIST',
          statusCode: 400,
        );
      }

      final request = UpdateFolderOrderRequest(folderIds: folderIds);
      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.updateFolderOrder,
        body: request.toJson(),
      );
      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل تحديث ترتيب المجلدات: ${e.toString()}',
        errorCode: 'UPDATE_FOLDER_ORDER_FAILED',
        statusCode: 500,
      );
    }
  }
}
