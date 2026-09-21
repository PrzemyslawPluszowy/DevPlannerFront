import 'package:devplanner/workspaces/domain/models/tasks_board_assignee_columns_preference.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';

/// Osobiste preferencje widoku tablicy Kanban.
///
/// Zakres klucza to użytkownik, workspace i projekt, więc wybór „Osoba” albo
/// ukrycie kolumny w jednym projekcie nie zmienia widoku pozostałych projektów
/// ani innych kont na tym samym urządzeniu. Brak wpisu oznacza brak preferencji,
/// czyli grupowanie po statusie i wszystkie kolumny osób widoczne.
abstract interface class TasksBoardViewPreferenceStore {
  /// Zwraca zapisane grupowanie albo `null`, gdy użytkownik go nie wybrał.
  ///
  /// Odczyt jest best-effort: niedostępna persistence oznacza brak preferencji,
  /// a nie błąd widoku.
  Future<TasksBoardGrouping?> readGrouping({
    required String workspaceId,
    required String projectId,
  });

  /// Zapisuje wybór grupowania.
  Future<void> writeGrouping({
    required String workspaceId,
    required String projectId,
    required TasksBoardGrouping grouping,
  });

  /// Zwraca zapisaną widoczność kolumn osób; brak wpisu oznacza stan domyślny.
  Future<TasksBoardAssigneeColumnsPreference> readAssigneeColumns({
    required String workspaceId,
    required String projectId,
  });

  /// Zapisuje widoczność kolumn osób.
  Future<void> writeAssigneeColumns({
    required String workspaceId,
    required String projectId,
    required TasksBoardAssigneeColumnsPreference preference,
  });
}
