import 'dart:typed_data';

import 'package:devplanner/me/data/me_api_adapter.dart';
import 'package:devplanner/me/data/me_api_transport.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:devplanner/me/domain/models/user_session_item.dart';
import 'package:flutter_test/flutter_test.dart';

final class _RecordingTransport implements MeApiTransport {
  _RecordingTransport();

  MeApiResponse _response = const MeApiResponse(statusCode: 200);
  final List<MeApiRequest> requests = [];

  void setResponse(MeApiResponse response) {
    _response = response;
  }

  @override
  Future<MeApiResponse> send(MeApiRequest request) async {
    requests.add(request);
    return _response;
  }
}

void main() {
  group('MeApiAdapter', () {
    late _RecordingTransport transport;
    late MeApiAdapter adapter;

    setUp(() {
      transport = _RecordingTransport();
      adapter = MeApiAdapter(transport: transport);
    });

    test('getProfile pobiera i poprawnie mapuje profil użytkownika', () async {
      transport.setResponse(
        const MeApiResponse(
          statusCode: 200,
          body: {
            'userId': 'user-123',
            'login': 'jankowalski',
            'email': 'jan@example.com',
            'displayName': 'Jan Kowalski',
            'avatarFileId': 'avatar-abc',
            'roles': ['Admin', 'Developer'],
            'permissions': ['workspaces.read', 'projects.manage'],
          },
        ),
      );

      final profile = await adapter.getProfile();

      expect(transport.requests.length, 1);
      expect(transport.requests.first.method, MeApiMethod.get);
      expect(transport.requests.first.path, '/api/v1/me');

      expect(
        profile,
        const UserProfile(
          userId: 'user-123',
          login: 'jankowalski',
          email: 'jan@example.com',
          displayName: 'Jan Kowalski',
          avatarFileId: 'avatar-abc',
          roles: {'Admin', 'Developer'},
          permissions: {'workspaces.read', 'projects.manage'},
        ),
      );
    });

    test('updateProfile wysyła PATCH /api/v1/me z polami aktualizacji', () async {
      transport.setResponse(
        const MeApiResponse(
          statusCode: 200,
          body: {
            'userId': 'user-123',
            'login': 'jankowalski',
            'email': 'jan@example.com',
            'displayName': 'Jan Zaktualizowany',
            'avatarFileId': null,
            'roles': <String>[],
            'permissions': <String>[],
          },
        ),
      );

      final result = await adapter.updateProfile(displayName: 'Jan Zaktualizowany');

      expect(transport.requests.length, 1);
      final req = transport.requests.first;
      expect(req.method, MeApiMethod.patch);
      expect(req.path, '/api/v1/me');
      expect(req.body, {'displayName': 'Jan Zaktualizowany'});
      expect(result.displayName, 'Jan Zaktualizowany');
    });

    test('changePassword wysyła POST /api/v1/auth/change-password', () async {
      transport.setResponse(const MeApiResponse(statusCode: 204));

      await adapter.changePassword(
        currentPassword: 'OldPassword123!',
        newPassword: 'NewPassword123!',
      );

      expect(transport.requests.length, 1);
      final req = transport.requests.first;
      expect(req.method, MeApiMethod.post);
      expect(req.path, '/api/v1/auth/change-password');
      expect(req.body, {
        'currentPassword': 'OldPassword123!',
        'newPassword': 'NewPassword123!',
      });
    });

    test('getSessions pobiera listę aktywnych sesji i poprawnie ją mapuje', () async {
      transport.setResponse(
        const MeApiResponse(
          statusCode: 200,
          body: [
            {
              'id': 'session-1',
              'deviceName': 'MacBook Pro',
              'platform': 'macOS',
              'createdAtUtc': '2026-09-01T10:00:00.000Z',
              'lastSeenAtUtc': '2026-09-16T12:00:00.000Z',
              'isCurrent': true,
            },
            {
              'id': 'session-2',
              'deviceName': 'iPhone 15',
              'platform': 'iOS',
              'createdAtUtc': '2026-08-20T08:00:00.000Z',
              'lastSeenAtUtc': '2026-09-10T14:30:00.000Z',
              'isCurrent': false,
            },
          ],
        ),
      );

      final sessions = await adapter.getSessions();

      expect(transport.requests.length, 1);
      expect(transport.requests.first.method, MeApiMethod.get);
      expect(transport.requests.first.path, '/api/v1/me/sessions');

      expect(sessions.length, 2);
      expect(
        sessions[0],
        UserSessionItem(
          id: 'session-1',
          deviceName: 'MacBook Pro',
          platform: 'macOS',
          createdAtUtc: DateTime.utc(2026, 9, 1, 10),
          lastSeenAtUtc: DateTime.utc(2026, 9, 16, 12),
          isCurrent: true,
        ),
      );
      expect(
        sessions[1],
        UserSessionItem(
          id: 'session-2',
          deviceName: 'iPhone 15',
          platform: 'iOS',
          createdAtUtc: DateTime.utc(2026, 8, 20, 8),
          lastSeenAtUtc: DateTime.utc(2026, 9, 10, 14, 30),
          isCurrent: false,
        ),
      );
    });

    test('revokeSession wysyła DELETE /api/v1/me/sessions/{sessionId}', () async {
      transport.setResponse(const MeApiResponse(statusCode: 204));

      await adapter.revokeSession('session-to-revoke');

      expect(transport.requests.length, 1);
      expect(transport.requests.first.method, MeApiMethod.delete);
      expect(transport.requests.first.path, '/api/v1/me/sessions/session-to-revoke');
    });

    test('uploadAvatar i deleteAvatar wykonują odpowiednie żądania HTTP', () async {
      transport.setResponse(const MeApiResponse(statusCode: 204));

      final avatarBytes = Uint8List.fromList([1, 2, 3, 4]);
      await adapter.uploadAvatar(avatarBytes, 'avatar.jpg');

      expect(transport.requests.length, 1);
      expect(transport.requests.first.method, MeApiMethod.post);
      expect(transport.requests.first.path, '/api/v1/me/avatar');
      expect(transport.requests.first.rawBytes, avatarBytes);
      expect(transport.requests.first.filename, 'avatar.jpg');

      await adapter.deleteAvatar();
      expect(transport.requests.length, 2);
      expect(transport.requests.last.method, MeApiMethod.delete);
      expect(transport.requests.last.path, '/api/v1/me/avatar');
    });

    test('rzuca MeApiException ze szczegółami w przypadku błędu serwera', () async {
      transport.setResponse(
        const MeApiResponse(
          statusCode: 400,
          body: {
            'code': 'INVALID_PASSWORD',
            'message': 'Podane aktualne hasło jest niepoprawne.',
            'traceId': 'trace-xyz-123',
          },
        ),
      );

      expect(
        () => adapter.changePassword(
          currentPassword: 'WrongPassword!',
          newPassword: 'ValidNewPassword123!',
        ),
        throwsA(
          isA<MeApiException>()
              .having((e) => e.statusCode, 'statusCode', 400)
              .having((e) => e.code, 'code', 'INVALID_PASSWORD')
              .having((e) => e.message, 'message', 'Podane aktualne hasło jest niepoprawne.')
              .having((e) => e.traceId, 'traceId', 'trace-xyz-123'),
        ),
      );
    });
  });
}
