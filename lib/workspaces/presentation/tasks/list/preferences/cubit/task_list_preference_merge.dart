import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart';

/// Scala lokalny draft użytkownika ze świeżym stanem serwera po konflikcie wersji.
///
/// Trzy strony scalenia to:
/// * `fresh` — co Backend ma teraz (także zmiany z innej sesji),
/// * `lastSaved` — co Backend potwierdził przy ostatnim udanym zapisie,
/// * `draft` — co użytkownik ma na ekranie.
///
/// Pole, którego użytkownik nie ruszył od ostatniego zapisu, przyjmuje wartość
/// z serwera, więc równoległa zmiana z innej sesji nie zostaje nadpisana.
/// Pole zmienione lokalnie wygrywa, bo jest intencją użytkownika — i to ona
/// zostaje zapisana ponownie, a nie odświeżony stan serwera. Szerokości kolumn
/// scala się osobno dla każdej kolumny, żeby zmiana jednej nie kasowała zmiany
/// innej.
TaskListPreferencesReady mergeTaskListPreferences({
  required TaskListPreferencesReady fresh,
  required TaskListPreferencesReady lastSaved,
  required TaskListPreferencesReady draft,
}) => fresh.copyWith(
  effectiveVisibleColumns:
      draft.effectiveVisibleColumns != lastSaved.effectiveVisibleColumns
      ? draft.effectiveVisibleColumns
      : fresh.effectiveVisibleColumns,
  columnWidths: _mergeColumnWidths(
    fresh: fresh.columnWidths,
    lastSaved: lastSaved.columnWidths,
    draft: draft.columnWidths,
  ),
  sortField: draft.sortField != lastSaved.sortField
      ? draft.sortField
      : fresh.sortField,
  sortDirection: draft.sortDirection != lastSaved.sortDirection
      ? draft.sortDirection
      : fresh.sortDirection,
  groupBy: draft.groupBy != lastSaved.groupBy ? draft.groupBy : fresh.groupBy,
  activeSavedViewId: draft.activeSavedViewId != lastSaved.activeSavedViewId
      ? draft.activeSavedViewId
      : fresh.activeSavedViewId,
  clearActiveSavedViewId:
      draft.activeSavedViewId == null &&
      lastSaved.activeSavedViewId != null,
);

/// Nakłada na świeże szerokości tylko te kolumny, które użytkownik zmienił.
Map<String, double> _mergeColumnWidths({
  required Map<String, double> fresh,
  required Map<String, double> lastSaved,
  required Map<String, double> draft,
}) {
  final merged = Map<String, double>.from(fresh);
  for (final entry in draft.entries) {
    if (lastSaved[entry.key] != entry.value) {
      merged[entry.key] = entry.value;
    }
  }
  return merged;
}
