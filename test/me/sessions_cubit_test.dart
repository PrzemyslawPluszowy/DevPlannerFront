import 'package:bloc_test/bloc_test.dart';
import 'package:devplanner/me/data/me_api_adapter.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:devplanner/me/domain/models/user_session_item.dart';
import 'package:devplanner/me/domain/ports/me_gateway.dart';
import 'package:devplanner/me/presentation/cubit/sessions_cubit.dart';
import 'package:devplanner/me/presentation/cubit/sessions_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Atrapa bramy MeGateway do testów jednostkowych sesji użytkownika.
class _FakeMeGateway implements MeGateway {
  List<UserSessionItem> sessions = [];
  Exception? errorToThrow;
  String? lastRevokedSessionId;

  @override
  Future<UserProfile> getProfile() async => throw UnimplementedError();

  @override
  Future<UserProfile> updateProfile({
    String? displayName,
    String? avatarFileId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async =>
      throw UnimplementedError();

  @override
  Future<List<UserSessionItem>> getSessions() async {
    if (errorToThrow != null) throw errorToThrow!;
    return sessions;
  }

  @override
  Future<void> revokeSession(String sessionId) async {
    if (errorToThrow != null) throw errorToThrow!;
    lastRevokedSessionId = sessionId;
    sessions = sessions.where((s) => s.id != sessionId).toList();
  }

  @override
  Future<void> uploadAvatar(List<int> bytes, String filename) async {}

  @override
  Future<void> deleteAvatar() async {}
}

void main() {
  group('SessionsCubit', () {
    late _FakeMeGateway gateway;

    final olderNonCurrentSession = UserSessionItem(
      id: 'session-old',
      deviceName: 'Chrome on Linux',
      platform: 'Linux',
      createdAtUtc: DateTime.utc(2026),
      lastSeenAtUtc: DateTime.utc(2026, 1, 10),
      isCurrent: false,
    );

    final newerNonCurrentSession = UserSessionItem(
      id: 'session-new',
      deviceName: 'Safari on macOS',
      platform: 'macOS',
      createdAtUtc: DateTime.utc(2026, 2),
      lastSeenAtUtc: DateTime.utc(2026, 2, 15),
      isCurrent: false,
    );

    final currentSession = UserSessionItem(
      id: 'session-current',
      deviceName: 'Edge on Windows',
      platform: 'Windows',
      createdAtUtc: DateTime.utc(2026, 1, 5),
      lastSeenAtUtc: DateTime.utc(2026, 1, 6),
      isCurrent: true,
    );

    setUp(() {
      gateway = _FakeMeGateway();
    });

    test('stan początkowy to SessionsInitial', () {
      final cubit = SessionsCubit(gateway: gateway);
      expect(cubit.state, equals(const SessionsInitial()));
    });

    blocTest<SessionsCubit, SessionsState>(
      'loadSessions sortuje bieżącą sesję na początku, a pozostałe wg daty malejąco',
      build: () {
        gateway.sessions = [
          olderNonCurrentSession,
          newerNonCurrentSession,
          currentSession,
        ];
        return SessionsCubit(gateway: gateway);
      },
      act: (cubit) => cubit.loadSessions(),
      expect: () => [
        const SessionsLoading(),
        SessionsLoaded(
          sessions: [
            currentSession,
            newerNonCurrentSession,
            olderNonCurrentSession,
          ],
        ),
      ],
    );

    blocTest<SessionsCubit, SessionsState>(
      'loadSessions emituje SessionsError w przypadku błędu API (MeApiException)',
      build: () {
        gateway.errorToThrow = const MeApiException(
          message: 'Błąd pobierania sesji.',
          code: 'SESSIONS_FETCH_ERROR',
          traceId: 'trace-sessions-123',
        );
        return SessionsCubit(gateway: gateway);
      },
      act: (cubit) => cubit.loadSessions(),
      expect: () => [
        const SessionsLoading(),
        const SessionsError(
          message: 'Błąd pobierania sesji.',
          code: 'SESSIONS_FETCH_ERROR',
          traceId: 'trace-sessions-123',
        ),
      ],
    );

    blocTest<SessionsCubit, SessionsState>(
      'loadSessions emituje SessionsError w przypadku nieoczekiwanego błędu',
      build: () {
        gateway.errorToThrow = Exception('Brak sieci');
        return SessionsCubit(gateway: gateway);
      },
      act: (cubit) => cubit.loadSessions(),
      expect: () => [
        const SessionsLoading(),
        isA<SessionsError>().having(
          (e) => e.message,
          'message',
          contains('Brak sieci'),
        ),
      ],
    );

    blocTest<SessionsCubit, SessionsState>(
      'revokeSession usuwa sesję z listy i ustawia komunikat sukcesu',
      build: () => SessionsCubit(gateway: gateway),
      seed: () => SessionsLoaded(
        sessions: [
          currentSession,
          newerNonCurrentSession,
        ],
      ),
      act: (cubit) => cubit.revokeSession('session-new'),
      expect: () => [
        SessionsLoaded(
          sessions: [
            currentSession,
            newerNonCurrentSession,
          ],
          revokingSessionId: 'session-new',
        ),
        SessionsLoaded(
          sessions: [
            currentSession,
          ],
          actionMessage: 'Sesja została pomyślnie zakończona.',
        ),
      ],
      verify: (_) {
        expect(gateway.lastRevokedSessionId, equals('session-new'));
      },
    );

    blocTest<SessionsCubit, SessionsState>(
      'revokeSession zachowuje listę sesji w SessionsError w przypadku błędu API',
      build: () {
        gateway.errorToThrow = const MeApiException(
          message: 'Nie można unieważnić sesji.',
          code: 'REVOKE_FAILED',
          traceId: 'trace-revoke-456',
        );
        return SessionsCubit(gateway: gateway);
      },
      seed: () => SessionsLoaded(
        sessions: [
          currentSession,
          newerNonCurrentSession,
        ],
      ),
      act: (cubit) => cubit.revokeSession('session-new'),
      expect: () => [
        SessionsLoaded(
          sessions: [
            currentSession,
            newerNonCurrentSession,
          ],
          revokingSessionId: 'session-new',
        ),
        SessionsError(
          message: 'Nie można unieważnić sesji.',
          code: 'REVOKE_FAILED',
          traceId: 'trace-revoke-456',
          lastSessions: [
            currentSession,
            newerNonCurrentSession,
          ],
        ),
      ],
    );

    blocTest<SessionsCubit, SessionsState>(
      'revokeSession nic nie robi gdy stan nie posiada sesji',
      build: () => SessionsCubit(gateway: gateway),
      act: (cubit) => cubit.revokeSession('any-id'),
      expect: () => <SessionsState>[],
    );
  });
}
