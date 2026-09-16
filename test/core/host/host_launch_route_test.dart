import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/core/host/host_launch_route.dart';

void main() {
  const workspaceId = '11111111-1111-4111-8111-111111111111';
  const projectId = '22222222-2222-4222-8222-222222222222';

  group('resolveWebLaunchLocation', () {
    test('usuwa prefiks hosta i zachowuje query', () {
      expect(
        resolveWebLaunchLocation(
          path: '/ready-next/inventory/stock',
          query: 'tab=expired&sort=asc',
        ),
        '/inventory/stock?tab=expired&sort=asc',
      );
    });

    test('zachowuje dynamiczny deep link zasobu', () {
      expect(
        resolveWebLaunchLocation(
          path: '/ready-next/workspaces/$workspaceId/projects/$projectId/tasks',
          query: 'view=mine',
        ),
        '/workspaces/$workspaceId/projects/$projectId/tasks?view=mine',
      );
    });

    test('obsługuje starszy routing hash wraz z query i fragmentem', () {
      expect(
        resolveWebLaunchLocation(
          path: '/ready-next/',
          fragment: '/inventory/stock?tab=expired#filters',
        ),
        '/inventory/stock?tab=expired#filters',
      );
    });

    test('nie przepuszcza ścieżki podobnej do znanej trasy', () {
      expect(
        resolveWebLaunchLocation(path: '/ready-next/not-orders'),
        AppRoutePaths.dashboard,
      );
    });
  });
}
