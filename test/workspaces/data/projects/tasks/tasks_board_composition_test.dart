import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('composes the standalone Board graph from an authenticated desktop transport', () {
    final transport = DevPlannerHttpTransport(
      baseUrl: 'https://localhost:5173',
      isWeb: false,
      tokenProvider: () async => 'test-token',
    );

    final composition = TasksBoardComposition.fromTransport(transport);

    expect(composition, isNotNull);
    expect(composition!.realtimeFactory.baseUrl, 'https://localhost:5173');
  });

  test('does not compose realtime for a browser BFF transport', () {
    final transport = DevPlannerHttpTransport(
      baseUrl: 'https://localhost:5173',
      isWeb: true,
    );

    expect(TasksBoardComposition.fromTransport(transport), isNull);
  });
}
