import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_runtime_coordinator.dart';

/// Filtry tablicy Kanban: wykonawca, priorytet i kamień milowy.
///
/// Backend liczy liczniki kolumn i WIP tą samą predykatą, którą filtruje karty,
/// dlatego każda zmiana filtra odświeża tablicę zamiast filtrować załadowane
/// karty po stronie klienta. Filtr jest stanem widoku, a nie preferencją
/// użytkownika, więc nie trafia do `PATCH /kanban/preferences`.
final class TasksBoardFilterCommands {
  TasksBoardFilterCommands({
    required this._context,
    required this._runtime,
  });

  final TasksBoardCommandContext _context;
  final TasksBoardRuntimeCoordinator _runtime;

  Future<void> setAssignee(String? assigneeUserId) => _apply(
    (filter) => filter.copyWith(
      assigneeUserId: assigneeUserId,
      clearAssignee: assigneeUserId == null,
    ),
  );

  Future<void> setPriority(TaskPriority? priority) => _apply(
    (filter) =>
        filter.copyWith(priority: priority, clearPriority: priority == null),
  );

  Future<void> setMilestone(String? milestoneId) => _apply(
    (filter) => filter.copyWith(
      milestoneId: milestoneId,
      clearMilestone: milestoneId == null,
    ),
  );

  /// Ustawia filtr statusu kart: systemowy albo własny, nigdy oba naraz.
  ///
  /// W widoku osób osoba opisuje kolumnę, więc status jest tam filtrem kart —
  /// „pokaż tylko to, co jest w toku” nie myli się z osią kolumn. Oba pola
  /// kontraktu opisują jeden wymiar, więc zmieniamy je **jedną** operacją: dwa
  /// osobne wywołania zostawiały na moment oba filtry aktywne (pusta tablica),
  /// a czyszczenie szło dwiema niezależnymi ścieżkami, czyli w wyścigu.
  Future<void> setStatusColumn({
    ProjectTaskStatus? status,
    String? customStatusId,
  }) => _apply(
    (filter) => status == null && customStatusId == null
        ? filter.copyWith(clearStatus: true, clearCustomStatus: true)
        : filter.copyWith(status: status, customStatusId: customStatusId),
  );

  Future<void> clearFilters() => _apply((_) => KanbanBoardFilter.none);

  Future<void> _apply(
    KanbanBoardFilter Function(KanbanBoardFilter) change,
  ) async {
    if (_context.isBoardClosed) return;
    final updated = change(_runtime.filter);
    if (updated == _runtime.filter) return;
    await _runtime.setFilter(updated);
  }
}
