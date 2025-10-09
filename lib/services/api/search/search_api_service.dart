import '../../../core/api/base/api_client.dart';
import '../../../core/api/base/api_response.dart';
import '../../../core/api/config/api_endpoints.dart';
import 'models/search_chats_request.dart';
import '../chat/models/session_dto.dart';

/// خدمة API للبحث
class SearchApiService {
  final ApiClient _apiClient;

  SearchApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// البحث في المحادثات
  Future<ApiResponse<List<SessionDto>>> searchChats(
    SearchChatsRequest request,
  ) async {
    try {
      if (!request.isValid) {
        return ApiResponse.error(
          error: 'يرجى إدخال نص البحث',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      final response = await _apiClient.post<List<SessionDto>>(
        endpoint: ApiEndpoints.searchChats,
        body: request.toJson(),
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
        error: 'فشل البحث: ${e.toString()}',
        errorCode: 'SEARCH_FAILED',
        statusCode: 500,
      );
    }
  }

  /// الحصول على المحادثات الأخيرة
  Future<ApiResponse<List<SessionDto>>> getRecentChats() async {
    try {
      final response = await _apiClient.get<List<SessionDto>>(
        endpoint: ApiEndpoints.getRecentChats,
        fromJson: (json) {
          // API يعيد object مع Results array
          if (json is Map<String, dynamic> && json['Results'] != null) {
            final results = json['Results'] as List;
            return results.map((item) => SessionDto.fromJson(item)).toList();
          }
          // fallback: array مباشر
          if (json is List) {
            return json.map((item) => SessionDto.fromJson(item)).toList();
          }
          return [];
        },
      );
      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل الحصول على المحادثات الأخيرة: ${e.toString()}',
        errorCode: 'GET_RECENT_CHATS_FAILED',
        statusCode: 500,
      );
    }
  }
}
