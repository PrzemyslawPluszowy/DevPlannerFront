import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('composes Board and bearer realtime from an authenticated desktop transport', () {
    final transport = DevPlannerHttpTransport(
      baseUrl: 'https://localhost:5173',
      isWeb: false,
      tokenProvider: () async => 'test-token',
    );

    final composition = TasksBoardComposition.fromTransport(transport);

    expect(composition, isNotNull);
    expect(composition!.realtimeFactory.baseUrl, 'https://localhost:5173');
    expect(
      composition.realtimeFactory.credentials,
      isA<WorkspaceRealtimeBearerCredentials>(),
    );
  });

  test('composes Board and cookie/CSRF realtime for browser BFF transport', () {
    final transport = DevPlannerHttpTransport(
      baseUrl: 'https://localhost:5173',
      isWeb: true,
    );

    final composition = TasksBoardComposition.fromTransport(transport);

    expect(composition, isNotNull);
    expect(
      composition!.realtimeFactory.credentials,
      isA<WorkspaceRealtimeCookieCredentials>(),
    );
  });

  test('does not compose Board without a session credential source', () {
    final transport = DevPlannerHttpTransport(
      baseUrl: 'https://localhost:5173',
      isWeb: false,
    );

    expect(TasksBoardComposition.fromTransport(transport), isNull);
  });
}
