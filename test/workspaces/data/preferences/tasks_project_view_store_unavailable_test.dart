import 'package:devplanner/workspaces/data/preferences/shared_preferences_tasks_project_view_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ten plik celowo nie rejestruje mocka `shared_preferences`.
///
/// Platforma bez implementacji persistence zgłasza `FlutterError`, czyli
/// `Error`, a nie `Exception` — port musi to zamienić na pusty stan i wpis
/// w logu, żeby brak storage'u nie wywracał modułu Zadania. Trzymanie tego
/// przypadku w osobnym pliku chroni go przed mockiem z sąsiedniego testu,
/// który rejestruje się na cały proces.
void main() {
  test(
    'treats missing persistence as an empty preference, not a failure',
    () async {
      final store = SharedPreferencesTasksProjectViewStore(
        currentUserId: () => 'user-1',
      );

      await store.load();

      expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-1'), isNull);

      // Zapis nadal działa w pamięci sesji, więc wybór widoku obowiązuje
      // do końca uruchomienia klienta.
      await store.write(
        workspaceId: 'ws-1',
        projectId: 'proj-1',
        view: 'kanban',
      );

      expect(store.viewFor(workspaceId: 'ws-1', projectId: 'proj-1'), 'kanban');
    },
  );
}
