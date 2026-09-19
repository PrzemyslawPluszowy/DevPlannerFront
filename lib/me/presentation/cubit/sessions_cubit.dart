import 'package:devplanner/me/data/me_api_adapter.dart';
import 'package:devplanner/me/domain/models/user_session_item.dart';
import 'package:devplanner/me/domain/ports/me_gateway.dart';
import 'package:devplanner/me/presentation/cubit/sessions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit do przeglądania oraz unieważniania aktywnych sesji urządzeń.
class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit({required this.gateway}) : super(const SessionsInitial());

  final MeGateway gateway;

  /// Pobiera listę aktywnych sesji i układa bieżącą sesję na szczycie.
  Future<void> loadSessions() async {
    emit(const SessionsLoading());
    try {
      final sessions = await gateway.getSessions();
      final sorted = _sortSessions(sessions);
      emit(SessionsLoaded(sessions: sorted));
    } on MeApiException catch (e) {
      emit(
        SessionsError(
          message: e.message,
          code: e.code,
          traceId: e.traceId,
        ),
      );
    } catch (e) {
      emit(SessionsError(message: 'Nie udało się pobrać listy sesji: $e'));
    }
  }

  /// Unieważnia wskazaną sesję urządzenia.
  Future<void> revokeSession(String sessionId) async {
    final currentSessions = _currentSessions;
    if (currentSessions == null) return;

    emit(
      SessionsLoaded(
        sessions: currentSessions,
        revokingSessionId: sessionId,
      ),
    );

    try {
      await gateway.revokeSession(sessionId);
      final updated = currentSessions
          .where((session) => session.id != sessionId)
          .toList();
      emit(
        SessionsLoaded(
          sessions: updated,
          actionMessage: 'Sesja została pomyślnie zakończona.',
        ),
      );
    } on MeApiException catch (e) {
      emit(
        SessionsError(
          message: e.message,
          code: e.code,
          traceId: e.traceId,
          lastSessions: currentSessions,
        ),
      );
    } catch (e) {
      emit(
        SessionsError(
          message: 'Nie udało się zakończyć sesji: $e',
          lastSessions: currentSessions,
        ),
      );
    }
  }

  List<UserSessionItem>? get _currentSessions => switch (state) {
    SessionsLoaded(:final sessions) => sessions,
    SessionsError(:final lastSessions) => lastSessions,
    _ => null,
  };

  List<UserSessionItem> _sortSessions(List<UserSessionItem> sessions) {
    final list = List<UserSessionItem>.from(sessions);
    list.sort((a, b) {
      if (a.isCurrent && !b.isCurrent) return -1;
      if (!a.isCurrent && b.isCurrent) return 1;
      return b.lastSeenAtUtc.compareTo(a.lastSeenAtUtc);
    });
    return list;
  }
}
