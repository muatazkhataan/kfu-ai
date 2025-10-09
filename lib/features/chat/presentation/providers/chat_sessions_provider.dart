import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/api/api_manager.dart';
import '../../../../services/api/chat/models/session_dto.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// حالة قائمة الجلسات
class ChatSessionsState {
  final bool isLoading;
  final List<SessionDto> sessions;
  final List<SessionDto> recentSessions;
  final String? error;

  const ChatSessionsState({
    this.isLoading = false,
    this.sessions = const [],
    this.recentSessions = const [],
    this.error,
  });

  ChatSessionsState copyWith({
    bool? isLoading,
    List<SessionDto>? sessions,
    List<SessionDto>? recentSessions,
    String? error,
  }) {
    return ChatSessionsState(
      isLoading: isLoading ?? this.isLoading,
      sessions: sessions ?? this.sessions,
      recentSessions: recentSessions ?? this.recentSessions,
      error: error,
    );
  }
}

/// مزود حالة الجلسات
class ChatSessionsNotifier extends StateNotifier<ChatSessionsState> {
  final ApiManager _apiManager;

  ChatSessionsNotifier(this._apiManager) : super(const ChatSessionsState());

  /// تحميل جميع جلسات المستخدم
  Future<void> loadUserSessions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiManager.chat.getUserSessions();

      if (response.success && response.data != null) {
        state = state.copyWith(
          isLoading: false,
          sessions: response.data!,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.error ?? 'فشل تحميل الجلسات',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ: ${e.toString()}',
      );
    }
  }

  /// تحميل المحادثات الأخيرة
  Future<void> loadRecentChats() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiManager.search.getRecentChats();

      if (response.success && response.data != null) {
        state = state.copyWith(
          isLoading: false,
          recentSessions: response.data!,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.error ?? 'فشل تحميل المحادثات الأخيرة',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ: ${e.toString()}',
      );
    }
  }

  /// تحديث كلا القائمتين
  Future<void> refreshAll() async {
    await Future.wait([loadUserSessions(), loadRecentChats()]);
  }

  /// إضافة جلسة جديدة للقائمة
  void addSession(SessionDto session) {
    state = state.copyWith(sessions: [session, ...state.sessions]);
  }

  /// تحديث جلسة في القائمة
  void updateSession(SessionDto updatedSession) {
    final updatedSessions = state.sessions.map((session) {
      return session.sessionId == updatedSession.sessionId
          ? updatedSession
          : session;
    }).toList();

    state = state.copyWith(sessions: updatedSessions);
  }

  /// حذف جلسة من القائمة
  void removeSession(String sessionId) {
    state = state.copyWith(
      sessions: state.sessions.where((s) => s.sessionId != sessionId).toList(),
      recentSessions: state.recentSessions
          .where((s) => s.sessionId != sessionId)
          .toList(),
    );
  }
}

/// Provider لحالة الجلسات
final chatSessionsProvider =
    StateNotifierProvider<ChatSessionsNotifier, ChatSessionsState>((ref) {
      final apiManager = ref.watch(apiManagerProvider);
      return ChatSessionsNotifier(apiManager);
    });

/// Provider لجميع الجلسات
final allSessionsProvider = Provider<List<SessionDto>>((ref) {
  return ref.watch(chatSessionsProvider).sessions;
});

/// Provider للمحادثات الأخيرة
final recentSessionsProvider = Provider<List<SessionDto>>((ref) {
  return ref.watch(chatSessionsProvider).recentSessions;
});
