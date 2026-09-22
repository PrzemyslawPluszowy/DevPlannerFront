import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkspaceRealtimeCredentials', () {
    test('desktop rozwiązuje access token bez nagłówków negotiate', () async {
      final credentials = WorkspaceRealtimeCredentials.bearer(
        () async => 'token-1',
      );

      final handshake = await credentials.resolve();

      expect(handshake.usesBearer, isTrue);
      expect(handshake.headers, isEmpty);
      expect(await handshake.accessTokenProvider!(), 'token-1');
    });

    test('desktop odmawia startu bez aktywnego tokenu', () async {
      final credentials = WorkspaceRealtimeCredentials.bearer(() async => '  ');

      await expectLater(credentials.resolve(), throwsA(isA<StateError>()));
    });

    test('web przekazuje cookie BFF i nagłówek CSRF', () async {
      final credentials = WorkspaceRealtimeCredentials.bffCookie(
        () async => 'csrf-123',
      );

      final handshake = await credentials.resolve();

      expect(handshake.usesBearer, isFalse);
      expect(handshake.accessTokenProvider, isNull);
      expect(
        handshake.headers,
        <String, String>{workspaceRealtimeCsrfHeaderName: 'csrf-123'},
      );
    });

    test('web odmawia startu bez tokenu CSRF aktywnej sesji', () async {
      final credentials = WorkspaceRealtimeCredentials.bffCookie(
        () async => null,
      );

      await expectLater(credentials.resolve(), throwsA(isA<StateError>()));
    });

    test('transport webowy BFF daje poświadczenia cookie, nie token', () {
      final transport = DevPlannerHttpTransport(
        isWeb: true,
        baseUrl: 'http://127.0.0.1:1/',
      );

      final credentials = WorkspaceRealtimeCredentials.fromTransport(transport);

      expect(credentials, isA<WorkspaceRealtimeCookieCredentials>());
    });

    test('transport desktopowy z tokenem daje poświadczenia bearer', () {
      final transport = DevPlannerHttpTransport(
        isWeb: false,
        baseUrl: 'http://127.0.0.1:1/',
        tokenProvider: () async => 'token-1',
      );

      final credentials = WorkspaceRealtimeCredentials.fromTransport(transport);

      expect(credentials, isA<WorkspaceRealtimeBearerCredentials>());
    });

    test('transport bez źródła poświadczeń nie tworzy klienta realtime', () {
      final transport = DevPlannerHttpTransport(
        isWeb: false,
        baseUrl: 'http://127.0.0.1:1/',
      );

      expect(WorkspaceRealtimeCredentials.fromTransport(transport), isNull);
    });
  });
}
