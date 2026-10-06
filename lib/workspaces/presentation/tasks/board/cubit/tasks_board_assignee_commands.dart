import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';

import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_assignee_columns_preference.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_board_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_assignee_move_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_assignee_read_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';

/// Odpowiada za grupowanie tablicy po osobach: osobistą preferencję trybu,
/// odczyt grup, niezależną paginację każdej kolumny oraz zmianę głównego
/// wykonawcy karty.
///
/// Zmiana osoby jest osobnym use case'em od przesuwania karty: karta zmienia
/// kolumnę osoby, ale jej status, pozycja i workflow pozostają bez zmian.
final class TasksBoardAssigneeCommands {
  TasksBoardAssigneeCommands({
    required this._context,
    required this._repository,
    required this._viewPreferenceStore,
    required this._scopeRevision,
    this._realtimeRefreshDebounce = const Duration(milliseconds: 180),
  }) {
    _moves = TasksBoardAssigneeMoveCommands(
      context: _context,
      repository: _repository,
      scopeRevision: _scopeRevision,
      reloadAfterSettingsConflict: loadBoard,
    );
  }

  late final TasksBoardAssigneeMoveCommands _moves;

  /// Klucz grupy „Nieprzypisane”; Backend używa dla niej `null`, a mapa błędów
  /// doładowania potrzebuje stabilnego klucza.
  static const String unassignedGroupKey = 'unassigned';

  final TasksBoardCommandContext _context;
  final KanbanRepository _repository;
  final TasksBoardViewPreferenceStore _viewPreferenceStore;
  final Duration _realtimeRefreshDebounce;
  final int Function() _scopeRevision;

  Timer? _realtimeRefreshTimer;

  /// Najnowsza widoczność kolumn czekająca na zapis oraz znacznik trwającego
  /// zapisu — razem tworzą kolejkę „latest wins” bez równoległych zapisów.
  TasksBoardAssigneeColumnsPreference? _pendingColumnsWrite;
  bool _isWritingColumns = false;

  /// Rewizja odczytu tablicy osób.
  ///
  /// Rośnie przy każdym starcie odczytu, więc odpowiedź, która wróci po nowszym
  /// żądaniu (np. po szybkiej zmianie filtra priorytetu), nie nadpisze świeższych
  /// grup. Ten sam mechanizm co `_boardQueryRevision` dla kolumn statusów.
  int _boardRevision = 0;

  /// Klucz grupy używany przez stan widoku i mapę błędów doładowania.
  static String keyOf(AssigneeKanbanGroupResponse group) =>
      group.assigneeUserId ?? unassignedGroupKey;

  /// Wczytuje zapisaną preferencję po wejściu na tablicę.
  ///
  /// Dopóki widok osób nie jest aktywny, nie wykonujemy żadnego żądania: brak
  /// preferencji oznacza grupowanie po statusie.
  Future<void> restore() async {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    final saved = await _viewPreferenceStore.readGrouping(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
    );
    final columns = await _viewPreferenceStore.readAssigneeColumns(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
    );
    if (_context.isBoardClosed) return;
    final published = _context.currentState;
    if (published is! TasksBoardReady) return;
    _context.publish(
      published.copyWith(
        hiddenAssigneeUserIds: columns.hiddenAssigneeUserIds,
        hideEmptyAssigneeColumns: columns.hideEmpty,
      ),
    );
    if (saved == null || saved == published.grouping) return;
    final afterColumns = _context.currentState;
    if (afterColumns is! TasksBoardReady) return;
    _context.publish(afterColumns.copyWith(grouping: saved));
    if (saved == TasksBoardGrouping.assignee) await loadBoard();
  }

  /// Przełącza grupowanie i zapisuje osobistą preferencję.
  ///
  /// Kolejność jest istotna: najpierw pokazujemy wybór, a zapis lokalny leci
  /// w tle. Persistence jest wygodą, a nie warunkiem przełączenia widoku —
  /// wolny albo niedostępny storage (np. brak pluginu) nie może zostawić
  /// użytkownika z klikniętym, ale nieaktywnym przełącznikiem.
  Future<void> setGrouping(TasksBoardGrouping grouping) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady || current.grouping == grouping) return;
    _context.publish(
      current.copyWith(grouping: grouping, clearError: true),
    );
    unawaited(
      _viewPreferenceStore.writeGrouping(
        workspaceId: _context.workspaceId,
        projectId: _context.projectId,
        grouping: grouping,
      ),
    );
    if (grouping == TasksBoardGrouping.assignee) await loadBoard();
  }

  /// Pokazuje albo ukrywa kolumnę osoby.
  ///
  /// Widoczność kolumn jest osobistą preferencją lokalną, więc zapis jest
  /// best-effort: brak adaptera nie może blokować samego ukrycia kolumny.
  Future<void> setAssigneeColumnVisible({
    required String groupKey,
    required bool visible,
  }) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady || _context.isBoardClosed) return;
    final hidden = {...current.hiddenAssigneeUserIds};
    visible ? hidden.remove(groupKey) : hidden.add(groupKey);
    _context.publish(
      current.copyWith(hiddenAssigneeUserIds: hidden, clearError: true),
    );
    unawaited(_persistAssigneeColumns(_context.currentState));
  }

  /// Włącza albo wyłącza ukrywanie kolumn osób bez zadań.
  Future<void> setHideEmptyAssigneeColumns(bool hideEmpty) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady || _context.isBoardClosed) return;
    if (current.hideEmptyAssigneeColumns == hideEmpty) return;
    _context.publish(
      current.copyWith(hideEmptyAssigneeColumns: hideEmpty, clearError: true),
    );
    unawaited(_persistAssigneeColumns(_context.currentState));
  }

  /// Przywraca widoczność wszystkich kolumn osób.
  Future<void> showAllAssigneeColumns() async {
    final current = _context.currentState;
    if (current is! TasksBoardReady || _context.isBoardClosed) return;
    if (current.hiddenAssigneeUserIds.isEmpty &&
        !current.hideEmptyAssigneeColumns) {
      return;
    }
    _context.publish(
      current.copyWith(
        hiddenAssigneeUserIds: const <String>{},
        hideEmptyAssigneeColumns: false,
        clearError: true,
      ),
    );
    unawaited(_persistAssigneeColumns(_context.currentState));
  }

  /// Zapisuje widoczność kolumn, serializując zapisy i wygrywając najnowszym.
  ///
  /// Kolejne kliknięcia checkboxów startują osobne zapisy, a storage nie musi
  /// kończyć ich w kolejności wywołania — gdyby starszy zapis dobiegł ostatni,
  /// nadpisałby świeższy wybór. Dlatego zapisy idą jeden po drugim, a w międzyczasie
  /// w kolejce trzymamy wyłącznie **najnowszy** stan: po zakończeniu zapisu
  /// nadchodzi on na miejsce poprzedniego.
  Future<void> _persistAssigneeColumns(TasksBoardState state) async {
    if (state is! TasksBoardReady) return;
    _pendingColumnsWrite = TasksBoardAssigneeColumnsPreference(
      hiddenAssigneeUserIds: state.hiddenAssigneeUserIds,
      hideEmpty: state.hideEmptyAssigneeColumns,
    );
    if (_isWritingColumns) return;
    _isWritingColumns = true;
    try {
      while (_pendingColumnsWrite != null && !_context.isBoardClosed) {
        final next = _pendingColumnsWrite!;
        _pendingColumnsWrite = null;
        await _viewPreferenceStore.writeAssigneeColumns(
          workspaceId: _context.workspaceId,
          projectId: _context.projectId,
          preference: next,
        );
      }
    } finally {
      _isWritingColumns = false;
    }
  }

  /// Odczytuje tablicę osób dla bieżących filtrów tablicy.
  ///
  /// Nieudany odczyt wraca do poprzedniego, działającego widoku i zostawia
  /// trwały banner: pusta tablica osób nie może udawać, że projekt nie ma zadań.
  Future<void> loadBoard() => _loadBoard(retryStale: true);

  Future<void> _loadBoard({required bool retryStale}) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady || _context.isBoardClosed) return;
    final revision = ++_boardRevision;
    final scope = _scopeRevision();
    final filter = current.filter;
    final snapshot = TasksBoardAssigneeReadSnapshot(current);
    _context.publish(current.copyWith(isAssigneeBoardLoading: true));
    try {
      final result = await _repository.getAssigneeBoard(
        workspaceId: _context.workspaceId,
        projectId: _context.projectId,
        filter: filter,
      );
      if (_context.isBoardClosed || revision != _boardRevision) return;
      final published = _context.currentState;
      if (published is! TasksBoardReady) return;
      // Po zmianie zakresu odpowiedź opisuje inny zbiór kart.
      if (_scopeRevision() != scope ||
          published.filter != filter ||
          published.grouping != current.grouping ||
          published.userPreference?.quickFilter !=
              current.userPreference?.quickFilter) {
        return;
      }
      if (result.isRight() && snapshot.changed(published)) {
        // GET opisuje wcześniejsze dane/grupy. Nigdy nie scalać starej
        // membership z nową; co najwyżej jeden świeży odczyt bez replay zapisu.
        _context.publish(
          published.copyWith(
            isAssigneeBoardLoading: false,
            error: const TasksViewError(
              code: TasksViewErrorCodes.boardReloadFailed,
            ),
          ),
        );
        if (retryStale) await _loadBoard(retryStale: false);
        return;
      }
      result.fold(
        (error) => _context.publish(
          published.copyWith(
            grouping: TasksBoardGrouping.status,
            isAssigneeBoardLoading: false,
            error: tasksViewErrorFrom(error),
          ),
        ),
        (board) => _context.publish(
          published.copyWith(
            assigneeBoard: board,
            isAssigneeBoardLoading: false,
            assigneeGroupLoadErrors: const <String, String>{},
            clearError: true,
          ),
        ),
      );
    } catch (_) {
      final latest = _context.currentState;
      if (!_context.isBoardClosed &&
          revision == _boardRevision &&
          _scopeRevision() == scope &&
          latest is TasksBoardReady) {
        _context.publish(
          latest.copyWith(
            error: tasksViewErrorFrom(
              const ApiError(
                type: ApiErrorType.unknown,
                message: TasksViewErrorCodes.boardReloadFailed,
              ),
            ),
          ),
        );
      }
    } finally {
      final latest = _context.currentState;
      if (!_context.isBoardClosed &&
          revision == _boardRevision &&
          latest is TasksBoardReady &&
          latest.isAssigneeBoardLoading) {
        _context.publish(latest.copyWith(isAssigneeBoardLoading: false));
      }
    }
  }

  /// Odświeża grupy po zmianie filtrów tablicy.
  Future<void> reloadAfterFilterChange() async {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    if (current.grouping != TasksBoardGrouping.assignee) return;
    await loadBoard();
  }

  /// Doładowuje kolejną stronę jednej grupy; inne kolumny pozostają nietknięte.
  Future<void> loadMore(AssigneeKanbanGroupResponse group) async {
    final current = _context.currentState;
    if (current is! TasksBoardReady || _context.isBoardClosed) return;
    final board = current.assigneeBoard;
    final cursor = group.nextCursor;
    if (board == null || cursor == null) return;
    final key = keyOf(group);
    if (current.loadingAssigneeGroupKeys.contains(key)) return;
    // Kolejna strona należy do bieżącego filtra: jeśli w trakcie odpowiedzi
    // tablica zostanie odczytana ponownie dla innego filtra, ta strona jest już
    // nieaktualna i nie wolno jej dopiąć do nowych grup.
    final revision = _boardRevision;

    _context.publish(
      current.copyWith(
        loadingAssigneeGroupKeys: {...current.loadingAssigneeGroupKeys, key},
        assigneeGroupLoadErrors: {...current.assigneeGroupLoadErrors}
          ..remove(key),
      ),
    );
    final result = await _repository.getAssigneeGroup(
      workspaceId: _context.workspaceId,
      projectId: _context.projectId,
      assigneeUserId: group.assigneeUserId,
      query: current.filter.toColumnQuery(cursor: cursor),
    );
    if (_context.isBoardClosed || revision != _boardRevision) return;
    final published = _context.currentState;
    if (published is! TasksBoardReady) return;
    final publishedBoard = published.assigneeBoard;
    final loading = {...published.loadingAssigneeGroupKeys}..remove(key);
    if (publishedBoard == null) {
      _context.publish(published.copyWith(loadingAssigneeGroupKeys: loading));
      return;
    }

    result.fold(
      (error) => _context.publish(
        published.copyWith(
          loadingAssigneeGroupKeys: loading,
          assigneeGroupLoadErrors: {
            ...published.assigneeGroupLoadErrors,
            key: error.message,
          },
        ),
      ),
      (page) => _context.publish(
        published.copyWith(
          assigneeBoard: publishedBoard.copyWith(
            groups: publishedBoard.groups
                .map((item) {
                  if (keyOf(item) != key) return item;
                  final known = item.tasks.map((task) => task.id).toSet();
                  return item.copyWith(
                    tasks: [
                      ...item.tasks,
                      ...page.items.where(
                        (task) => !known.contains(task.id),
                      ),
                    ],
                    nextCursor: page.nextCursor,
                  );
                })
                .toList(growable: false),
          ),
          loadingAssigneeGroupKeys: loading,
          assigneeGroupLoadErrors: {...published.assigneeGroupLoadErrors}
            ..remove(key),
        ),
      ),
    );
  }

  /// Przenosi kartę do kolumny osoby, zmieniając wyłącznie głównego wykonawcę.
  ///
  /// [targetUserId] równy `null` oznacza grupę „Nieprzypisane” i usuwa
  /// wszystkich wykonawców zadania; prezentacja wymaga na to jawnego
  /// potwierdzenia, bo reguła D2 nie może usuwać współwykonawców przez pomyłkę.
  Future<bool> moveToAssignee({
    required KanbanTaskCardResponse task,
    required String? targetUserId,
  }) => _moves.move(task: task, targetUserId: targetUserId);

  /// Odświeża grupy po zmianie z innej sesji.
  ///
  /// Event realtime zmiany wykonawcy niesie wersję zadania, ale nie pełną listę
  /// grup, więc zamiast zgadywać kolumnę docelową odczytujemy grupy ponownie.
  void refreshAfterRealtime() {
    final current = _context.currentState;
    if (current is! TasksBoardReady) return;
    if (current.grouping != TasksBoardGrouping.assignee) return;
    _realtimeRefreshTimer?.cancel();
    _realtimeRefreshTimer = Timer(
      _realtimeRefreshDebounce,
      () => unawaited(loadBoard()),
    );
  }

  /// Czyści grupy i anuluje oczekujące odświeżenie (np. przed ponownym odczytem).
  void reset() {
    _realtimeRefreshTimer?.cancel();
    _realtimeRefreshTimer = null;
  }
}
