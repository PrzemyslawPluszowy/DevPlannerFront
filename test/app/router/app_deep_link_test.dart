import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/router/app_deep_link.dart';

void main() {
  const workspaceId = '11111111-1111-4111-8111-111111111111';
  const projectId = '22222222-2222-4222-8222-222222222222';
  const taskId = '33333333-3333-4333-8333-333333333333';

  test('normalizuje backendowy link zadania i zachowuje query oraz fragment', () {
    final value = AppDeepLink.normalize(
      '/workspaces/$workspaceId/projects/$projectId/tasks/$taskId?tab=activity#comments',
    );

    expect(
      value,
      '/workspaces/$workspaceId/projects/$projectId/tasks/$taskId?tab=activity#comments',
    );
  });

  test('obsługuje zasoby dashboardu i storage', () {
    expect(AppDeepLink.parse('/storage/files/$taskId'), isNotNull);
    expect(
      AppDeepLink.parse('/workspaces/$workspaceId/okr/key-results/$taskId'),
      isNotNull,
    );
    expect(
      AppDeepLink.parse('/workspaces/$workspaceId/okr/objectives/$taskId'),
      isNotNull,
    );
  });

  test('dopuszcza zasoby pokazane w gałęzi projektu menu', () {
    expect(
      AppDeepLink.parse(
        '/workspaces/$workspaceId/projects/$projectId/automations',
      ),
      isNotNull,
    );
    expect(
      AppDeepLink.parse(
        '/workspaces/$workspaceId/projects/$projectId/corkboard',
      ),
      isNotNull,
    );
    expect(
      AppDeepLink.parse(
        '/workspaces/$workspaceId/projects/$projectId/wiki/pages/$taskId',
      ),
      isNotNull,
    );
    expect(
      AppDeepLink.parse(
        '/workspaces/$workspaceId/projects/$projectId/automations/$taskId',
      ),
      isNotNull,
    );
  });

  test('obsługuje globalny cel powiadomień i rozmowę czatu', () {
    expect(AppDeepLink.normalize('/notifications'), '/notifications');
    expect(
      AppDeepLink.normalize('/chat/conversations/$taskId/messages/$projectId'),
      '/chat/conversations/$taskId/messages/$projectId',
    );
  });

  test('odrzuca zewnętrzne i nieznane linki', () {
    expect(AppDeepLink.parse('https://evil.example/workspaces'), isNull);
    expect(AppDeepLink.parse('//evil.example/workspaces'), isNull);
    expect(AppDeepLink.parse('/'), isNull);
    expect(AppDeepLink.parse('/workspaces/$workspaceId/unknown'), isNull);
    expect(AppDeepLink.parse('/workspaces/invitations'), isNull);
    expect(AppDeepLink.parse('/framework'), isNull);
    expect(AppDeepLink.parse('/workspaces/../settings'), isNull);
  });

  test('dopuszcza prywatny kontekst bez workspace’u', () {
    expect(AppDeepLink.normalize('/me/tasks'), '/me/tasks');
    expect(AppDeepLink.normalize('/me/files'), '/me/files');
    expect(AppDeepLink.parse('/workspaces/private/tasks'), isNull);
    expect(AppDeepLink.parse('/workspaces/private/files'), isNull);
    expect(AppDeepLink.parse('/me/projects'), isNull);
  });

  test('wymaga UUID dla identyfikatorów zasobów', () {
    expect(AppDeepLink.parse('/workspaces/not-a-guid'), isNull);
    expect(AppDeepLink.parse('/storage/files/not-a-guid'), isNull);
  });
}
