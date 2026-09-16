import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/router/app_route_paths.dart';

void main() {
  group('prywatne trasy użytkownika', () {
    test('mają kanoniczne ścieżki poza segmentem workspaceId', () {
      expect(AppRoutePaths.meTasks, '/me/tasks');
      expect(AppRoutePaths.meFiles, '/me/files');
    });

    test('przekierowuje stare linki i zachowuje query oraz fragment', () {
      expect(
        AppRoutePaths.redirectLegacyPrivatePath(
          Uri.parse('/workspaces/private/tasks?view=list#today'),
        ),
        '/me/tasks?view=list#today',
      );
      expect(
        AppRoutePaths.redirectLegacyPrivatePath(
          Uri.parse('/workspaces/private/files?view=favorites&folder=folder-1'),
        ),
        '/me/files?view=favorites&folder=folder-1',
      );
    });

    test('nie zmienia prawdziwych tras workspace’u', () {
      expect(
        AppRoutePaths.redirectLegacyPrivatePath(
          Uri.parse('/workspaces/11111111-1111-4111-8111-111111111111/files'),
        ),
        isNull,
      );
    });
  });
}
