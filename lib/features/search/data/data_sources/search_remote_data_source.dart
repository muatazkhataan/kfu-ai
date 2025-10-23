import '../../../../core/api/base/api_response.dart';
import '../../../../services/api/api_manager.dart';
import '../../../../services/api/search/models/search_chats_request.dart';
import '../../../../services/api/chat/models/session_dto.dart';
import '../../domain/models/search_filter.dart';

/// مصدر البيانات عن بعد للبحث
class SearchRemoteDataSource {
  final ApiManager _apiManager;

  SearchRemoteDataSource({ApiManager? apiManager})
    : _apiManager = apiManager ?? ApiManager();

  /// البحث في المحادثات من خلال API
  ///
  /// [query] نص البحث
  /// [filter] فلتر البحث (اختياري)
  /// [page] رقم الصفحة
  /// [pageSize] حجم الصفحة
  ///
  /// Returns استجابة تحتوي على قائمة بجلسات المحادثة
  Future<ApiResponse<List<SessionDto>>> searchChats(
    String query, {
    SearchFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) async {
    print(
      '[SearchRemoteDataSource] 🔍 بدء البحث في RemoteDataSource: "$query"',
    );

    try {
      // إنشاء request للبحث مع الفلاتر
      print('[SearchRemoteDataSource] 🔧 إنشاء SearchChatsRequest...');
      final request = SearchChatsRequest.fromFilter(
        query: query,
        filter: filter,
        page: page,
        pageSize: pageSize,
      );

      // التحقق من صحة البيانات
      if (!request.isValid) {
        print('[SearchRemoteDataSource] ❌ طلب البحث غير صحيح');
        return ApiResponse.error(
          error: 'يرجى إدخال نص البحث',
          errorCode: 'INVALID_QUERY',
          statusCode: 400,
        );
      }

      print('[SearchRemoteDataSource] 📡 استدعاء API Manager...');
      // استدعاء API
      final response = await _apiManager.search.searchChats(request);
      print(
        '[SearchRemoteDataSource] 📊 استجابة API: success=${response.success}',
      );

      return response;
    } catch (e) {
      print('[SearchRemoteDataSource] ❌ خطأ في RemoteDataSource: $e');
      return ApiResponse.error(
        error: 'فشل البحث: ${e.toString()}',
        errorCode: 'SEARCH_FAILED',
        statusCode: 500,
      );
    }
  }

  /// الحصول على اقتراحات البحث
  ///
  /// حالياً يعتمد على البيانات المحلية
  /// يمكن تطويره لاحقاً للاتصال بـ API
  Future<List<String>> getSearchSuggestions(String query) async {
    // TODO: تطوير endpoint للاقتراحات في API
    // حالياً نرجع قائمة فارغة
    return [];
  }
}
