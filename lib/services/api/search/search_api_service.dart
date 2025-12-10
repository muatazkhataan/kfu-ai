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
      print('[SearchApiService] 🔍 بدء البحث...');
      print('[SearchApiService] 📝 Query: "${request.query}"');
      print('[SearchApiService] ✅ isValid: ${request.isValid}');
      
      if (!request.isValid) {
        print('[SearchApiService] ❌ طلب البحث غير صحيح');
        return ApiResponse.error(
          error: 'يرجى إدخال نص البحث',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      final requestBody = request.toJson();
      print('[SearchApiService] 📤 إرسال الطلب إلى: ${ApiEndpoints.searchChats}');
      print('[SearchApiService] 📦 Request Body: $requestBody');

      final response = await _apiClient.post<List<SessionDto>>(
        endpoint: ApiEndpoints.searchChats,
        body: requestBody,
        fromJson: (json) {
          print('[SearchApiService] 📥 استلام الاستجابة...');
          print('[SearchApiService] 📋 Response Type: ${json.runtimeType}');
          
          if (json is List) {
            print('[SearchApiService] ✅ Response is List with ${json.length} items');
            return json.map((item) => SessionDto.fromJson(item)).toList();
          }
          
          // قد يكون API يعيد object مع Results array
          if (json is Map<String, dynamic> && json['Results'] != null) {
            final results = json['Results'] as List;
            print('[SearchApiService] ✅ Response is Map with Results array (${results.length} items)');
            return results.map((item) => SessionDto.fromJson(item)).toList();
          }
          
          print('[SearchApiService] ⚠️ Response format not recognized, returning empty list');
          return [];
        },
      );
      
      print('[SearchApiService] 📊 Response Success: ${response.success}');
      if (!response.success) {
        print('[SearchApiService] ❌ Error: ${response.error}');
      }
      
      return response;
    } catch (e, stackTrace) {
      print('[SearchApiService] 💥 Exception: $e');
      print('[SearchApiService] 📚 Stack: $stackTrace');
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
