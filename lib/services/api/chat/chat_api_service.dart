import '../../../core/api/base/api_client.dart';
import '../../../core/api/base/api_response.dart';
import '../../../core/api/config/api_endpoints.dart';
import 'models/send_message_request.dart';
import 'models/create_session_request.dart';
import 'models/update_session_title_request.dart';
import 'models/session_action_request.dart';
import 'models/move_session_to_folder_request.dart';
import 'models/session_dto.dart';
import 'models/message_dto.dart';

/// خدمة API للمحادثات
///
/// تدير جميع العمليات المتعلقة بالمحادثات والجلسات
class ChatApiService {
  /// API Client
  final ApiClient _apiClient;

  /// Constructor
  ChatApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// إرسال رسالة
  ///
  /// [request] - بيانات الرسالة
  /// Returns [ApiResponse<MessageDto>]
  Future<ApiResponse<MessageDto>> sendMessage(
    SendMessageRequest request,
  ) async {
    try {
      // التحقق من صحة البيانات
      if (!request.isValid) {
        return ApiResponse.error(
          error: 'يرجى إدخال محتوى الرسالة',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      // إرسال الطلب
      final response = await _apiClient.post<MessageDto>(
        endpoint: ApiEndpoints.sendMessage,
        body: request.toJson(),
        fromJson: (json) => MessageDto.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل إرسال الرسالة: ${e.toString()}',
        errorCode: 'SEND_MESSAGE_FAILED',
        statusCode: 500,
      );
    }
  }

  /// إنشاء جلسة محادثة جديدة
  ///
  /// [request] - بيانات الجلسة
  /// Returns [ApiResponse<SessionDto>]
  Future<ApiResponse<SessionDto>> createSession(
    CreateSessionRequest request,
  ) async {
    try {
      // التحقق من صحة البيانات
      if (!request.isValid) {
        return ApiResponse.error(
          error: 'يرجى إدخال عنوان الجلسة',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      // إرسال الطلب
      final response = await _apiClient.post<SessionDto>(
        endpoint: ApiEndpoints.createSession,
        body: request.toJson(),
        fromJson: (json) => SessionDto.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل إنشاء الجلسة: ${e.toString()}',
        errorCode: 'CREATE_SESSION_FAILED',
        statusCode: 500,
      );
    }
  }

  /// الحصول على جلسة محادثة
  ///
  /// [sessionId] - معرف الجلسة
  /// Returns [ApiResponse<SessionDto>]
  Future<ApiResponse<SessionDto>> getSession(String sessionId) async {
    try {
      // التحقق من صحة المعرف
      if (sessionId.isEmpty) {
        return ApiResponse.error(
          error: 'معرف الجلسة غير صالح',
          errorCode: 'INVALID_SESSION_ID',
          statusCode: 400,
        );
      }

      // إرسال الطلب
      final response = await _apiClient.get<SessionDto>(
        endpoint: ApiEndpoints.getSession,
        queryParameters: {'sessionId': sessionId},
        fromJson: (json) => SessionDto.fromJson(json),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل الحصول على الجلسة: ${e.toString()}',
        errorCode: 'GET_SESSION_FAILED',
        statusCode: 500,
      );
    }
  }

  /// تحديث عنوان الجلسة
  ///
  /// [request] - بيانات التحديث
  /// Returns [ApiResponse<void>]
  Future<ApiResponse<void>> updateSessionTitle(
    UpdateSessionTitleRequest request,
  ) async {
    try {
      // التحقق من صحة البيانات
      if (!request.isValid) {
        return ApiResponse.error(
          error: 'يرجى إدخال عنوان الجلسة الجديد',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      // إرسال الطلب
      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.updateSessionTitle,
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل تحديث عنوان الجلسة: ${e.toString()}',
        errorCode: 'UPDATE_TITLE_FAILED',
        statusCode: 500,
      );
    }
  }

  /// أرشفة جلسة
  ///
  /// [sessionId] - معرف الجلسة
  /// Returns [ApiResponse<void>]
  Future<ApiResponse<void>> archiveSession(String sessionId) async {
    try {
      // التحقق من صحة المعرف
      if (sessionId.isEmpty) {
        return ApiResponse.error(
          error: 'معرف الجلسة غير صالح',
          errorCode: 'INVALID_SESSION_ID',
          statusCode: 400,
        );
      }

      // إنشاء الطلب
      final request = SessionActionRequest(sessionId: sessionId);

      // إرسال الطلب
      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.archiveSession,
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل أرشفة الجلسة: ${e.toString()}',
        errorCode: 'ARCHIVE_SESSION_FAILED',
        statusCode: 500,
      );
    }
  }

  /// حذف جلسة
  ///
  /// [sessionId] - معرف الجلسة
  /// Returns [ApiResponse<void>]
  Future<ApiResponse<void>> deleteSession(String sessionId) async {
    try {
      // التحقق من صحة المعرف
      if (sessionId.isEmpty) {
        return ApiResponse.error(
          error: 'معرف الجلسة غير صالح',
          errorCode: 'INVALID_SESSION_ID',
          statusCode: 400,
        );
      }

      // إنشاء الطلب
      final request = SessionActionRequest(sessionId: sessionId);

      // إرسال الطلب
      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.deleteSession,
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل حذف الجلسة: ${e.toString()}',
        errorCode: 'DELETE_SESSION_FAILED',
        statusCode: 500,
      );
    }
  }

  /// استعادة جلسة مؤرشفة
  ///
  /// [sessionId] - معرف الجلسة
  /// Returns [ApiResponse<void>]
  Future<ApiResponse<void>> restoreSession(String sessionId) async {
    try {
      // التحقق من صحة المعرف
      if (sessionId.isEmpty) {
        return ApiResponse.error(
          error: 'معرف الجلسة غير صالح',
          errorCode: 'INVALID_SESSION_ID',
          statusCode: 400,
        );
      }

      // إنشاء الطلب
      final request = SessionActionRequest(sessionId: sessionId);

      // إرسال الطلب
      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.restoreSession,
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل استعادة الجلسة: ${e.toString()}',
        errorCode: 'RESTORE_SESSION_FAILED',
        statusCode: 500,
      );
    }
  }

  /// نقل جلسة إلى مجلد
  ///
  /// [request] - بيانات النقل
  /// Returns [ApiResponse<void>]
  Future<ApiResponse<void>> moveSessionToFolder(
    MoveSessionToFolderRequest request,
  ) async {
    try {
      // التحقق من صحة البيانات
      if (!request.isValid) {
        return ApiResponse.error(
          error: 'معرف الجلسة أو المجلد غير صالح',
          errorCode: 'INVALID_INPUT',
          statusCode: 400,
        );
      }

      // إرسال الطلب
      final response = await _apiClient.post<void>(
        endpoint: ApiEndpoints.moveSessionToFolder,
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        error: 'فشل نقل الجلسة: ${e.toString()}',
        errorCode: 'MOVE_SESSION_FAILED',
        statusCode: 500,
      );
    }
  }

  /// الحصول على جميع جلسات المستخدم
  ///
  /// Returns [ApiResponse<List<SessionDto>>]
  Future<ApiResponse<List<SessionDto>>> getUserSessions() async {
    try {
      // إرسال الطلب
      final response = await _apiClient.get<List<SessionDto>>(
        endpoint: ApiEndpoints.getUserSessions,
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
        error: 'فشل الحصول على الجلسات: ${e.toString()}',
        errorCode: 'GET_SESSIONS_FAILED',
        statusCode: 500,
      );
    }
  }
}
