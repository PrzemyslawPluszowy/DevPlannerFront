/// Czyste operacje na zaznaczeniu listy zadań.
///
/// Zakres (grupa, gałąź podzadań albo cała załadowana lista) jest zawsze
/// przekazywany jawnie. Dzięki temu kontrolka select-all nie może przypadkiem
/// rozszerzyć operacji na rekordy z innej sekcji.
abstract final class TaskListSelection {
  /// Przełącza pojedynczy rekord albo ciągły zakres w kolejności widocznej listy.
  ///
  /// Rekord spoza aktualnie załadowanego zakresu nie zmienia selekcji. Dzięki
  /// temu opóźniony event interfejsu nie może zaznaczyć elementu po zmianie
  /// filtrów lub stron.
  static Set<String> toggle({
    required Set<String> selectedIds,
    required List<String> orderedScopeIds,
    required String taskId,
    required String? anchorTaskId,
    required bool range,
  }) {
    if (!orderedScopeIds.contains(taskId)) {
      return Set.unmodifiable({...selectedIds});
    }

    final result = {...selectedIds};
    if (range && anchorTaskId != null) {
      final anchorIndex = orderedScopeIds.indexOf(anchorTaskId);
      final taskIndex = orderedScopeIds.indexOf(taskId);
      if (anchorIndex >= 0) {
        final from = anchorIndex < taskIndex ? anchorIndex : taskIndex;
        final to = anchorIndex < taskIndex ? taskIndex : anchorIndex;
        result.addAll(orderedScopeIds.sublist(from, to + 1));
        return Set.unmodifiable(result);
      }
    }
    if (!result.add(taskId)) {
      result.remove(taskId);
    }
    return Set.unmodifiable(result);
  }

  static bool containsAll(Set<String> selectedIds, Iterable<String> scopeIds) {
    final scope = scopeIds.toSet();
    return scope.isNotEmpty && selectedIds.containsAll(scope);
  }

  static Set<String> setScope({
    required Set<String> selectedIds,
    required Iterable<String> scopeIds,
    required bool selected,
  }) {
    final result = {...selectedIds};
    if (selected) {
      result.addAll(scopeIds);
    } else {
      result.removeAll(scopeIds);
    }
    return Set.unmodifiable(result);
  }
}
