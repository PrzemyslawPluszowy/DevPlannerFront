import 'package:devplanner/workspaces/data/preferences/shared_preferences_tasks_project_view_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the stored view per project and keeps writes', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'devplanner.tasks-view.user-1.ws-1.proj-1': 'kanban',
    });
    final store = SharedPreferencesTasksProjectViewStore(
      currentUserId: () => 'user-1',
    );

    // Przed `load()` port nie zgaduje widoku: brak wpisu to brak preferencji.
    expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-1'), isNull);

    await store.load();

    expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-1'), 'kanban');
    expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-2'), isNull);

    await store.write(workspaceId: 'ws-1', projectId: 'proj-2', view: 'list');

    expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-2'), 'list');

    final reloaded = SharedPreferencesTasksProjectViewStore(
      currentUserId: () => 'user-1',
    );
    await reloaded.load();

    expect(reloaded.viewFor(workspaceId: 'ws-1', projectId: 'proj-2'), 'list');
    // Preferencja jednego projektu nie przecieka do innego.
    expect(reloaded.viewFor(workspaceId: 'ws-1', projectId: 'proj-3'), isNull);
  });

  test(
    'nie oddaje wyboru widoku innemu kontu na tym samym urządzeniu',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'devplanner.tasks-view.user-1.ws-1.proj-1': 'kanban',
      });
      var userId = 'user-1';
      final store = SharedPreferencesTasksProjectViewStore(
        currentUserId: () => userId,
      );

      await store.load();
      expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-1'), 'kanban');

      // To samo urządzenie, inny użytkownik: cache poprzedniego konta nie może
      // być źródłem widoku, dopóki właściciel sesji nie wczyta nowego zestawu.
      userId = 'user-2';
      expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-1'), isNull);

      await store.load();
      expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-1'), isNull);

      await store.write(workspaceId: 'ws-1', projectId: 'proj-1', view: 'list');
      expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-1'), 'list');
    },
  );

  test(
    'bez zalogowanego użytkownika nie zapisuje i nie czyta preferencji',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final store = SharedPreferencesTasksProjectViewStore(
        currentUserId: () => null,
      );

      await store.load();
      await store.write(
        workspaceId: 'ws-1',
        projectId: 'proj-1',
        view: 'kanban',
      );

      expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-1'), isNull);
    },
  );
}
