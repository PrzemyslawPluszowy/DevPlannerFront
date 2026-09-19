import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'kanban_subtasks_status_mutation.dart';

/// Lokalny Cubit zarządzający pobieraniem, paginacją i tworzeniem podzadań pojedynczej karty Kanban.
///
/// Zgodnie z punktem 4 i sekcją 5 specyfikacji Kanban UI:
/// - Izoluje stan sieciowy i paginację od widoku karty; DTO pozostają w stanie
///   Cubita i nie są przechowywane w widoku.
/// - Pobiera pierwszą partię (5 podzadań) dopiero po rozwinięciu.
/// - Obsługuje stronicowanie "Pokaż kolejne 5" wewnątrz karty, zapamiętując kursor.
/// - Bezpiecznie obsługuje błędy (błąd nowej strony nie kasuje załadowanych dzieci, błąd create nie zamyka formularza).
class KanbanSubtasksCubit extends Cubit<KanbanSubtasksState> {
  KanbanSubtasksCubit({
    required this.tasksRepository,
    required this.workspaceId,
    required this.projectId,
    required this.parentTaskId,
    required int initialSubtaskTotal,
    required int initialSubtaskCompleted,
  }) : _parentTotal = initialSubtaskTotal,
       _parentCompleted = initialSubtaskCompleted,
       super(
         KanbanSubtasksInitial(
           subtaskTotal: initialSubtaskTotal,
           subtaskCompleted: initialSubtaskCompleted,
         ),
       );

  final TasksRepository tasksRepository;
  final String workspaceId;
  final String projectId;
  final String parentTaskId;
  int _parentTotal;
  int _parentCompleted;

  static const int _pageSize = 5;

  /// Ładowanie początkowej partii podzadań po rozwinięciu sekcji.
  Future<void> loadInitial() async {
    if (state is KanbanSubtasksLoading) return;
    if (state is KanbanSubtasksReady && state.subtasks.isNotEmpty) return;

    emit(
      KanbanSubtasksLoading(
        subtaskTotal: state.subtaskTotal,
        subtaskCompleted: state.subtaskCompleted,
      ),
    );

    try {
      final result = await tasksRepository.listProjectTasks(
        workspaceId: workspaceId,
        projectId: projectId,
        query: ProjectTasksQuery(
          parentTaskId: parentTaskId,
          limit: _pageSize,
        ),
      );

      if (isClosed) return;

      result.fold(
        (error) => emit(
          KanbanSubtasksError(
            message: error.message,
            subtaskTotal: state.subtaskTotal,
            subtaskCompleted: state.subtaskCompleted,
          ),
        ),
        (page) {
          final items = page.items;
          final hasMore =
              (page.nextCursor != null && page.nextCursor!.isNotEmpty) ||
              (items.length < state.subtaskTotal);
          emit(
            KanbanSubtasksReady(
              subtasks: items,
              subtaskTotal: state.subtaskTotal,
              subtaskCompleted: state.subtaskCompleted,
              nextCursor: page.nextCursor,
              hasMore: hasMore && items.length < state.subtaskTotal,
            ),
          );
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        KanbanSubtasksError(
          message: e.toString(),
          subtaskTotal: state.subtaskTotal,
          subtaskCompleted: state.subtaskCompleted,
        ),
      );
    }
  }

  /// Wymusza odczyt dzieci po zdarzeniu realtime lub konflikcie wersji.
  /// W przeciwieństwie do [loadInitial] nie zatrzymuje się na istniejącym
  /// lokalnym snapshotcie.
  Future<void> refresh({String? mutationError, int mutationSerial = 0}) async {
    if (isClosed || state is KanbanSubtasksLoading) return;
    final previous = state;
    final requestedLimit = previous.subtasks.length > _pageSize
        ? previous.subtasks.length
        : _pageSize;
    emit(
      KanbanSubtasksLoading(
        subtaskTotal: _parentTotal,
        subtaskCompleted: _parentCompleted,
      ),
    );
    try {
      final result = await tasksRepository.listProjectTasks(
        workspaceId: workspaceId,
        projectId: projectId,
        query: ProjectTasksQuery(
          parentTaskId: parentTaskId,
          limit: requestedLimit,
        ),
      );
      if (isClosed) return;
      result.fold(
        (error) => emit(
          KanbanSubtasksError(
            message: error.message,
            subtaskTotal: _parentTotal,
            subtaskCompleted: _parentCompleted,
          ),
        ),
        (page) => emit(
          KanbanSubtasksReady(
            subtasks: page.items,
            subtaskTotal: _parentTotal,
            subtaskCompleted: _parentCompleted,
            nextCursor: page.nextCursor,
            hasMore:
                (page.nextCursor != null && page.nextCursor!.isNotEmpty) ||
                page.items.length < _parentTotal,
            mutationError: mutationError,
            mutationSerial: mutationSerial,
          ),
        ),
      );
    } catch (error) {
      if (!isClosed) {
        emit(
          KanbanSubtasksError(
            message: error.toString(),
            subtaskTotal: _parentTotal,
            subtaskCompleted: _parentCompleted,
          ),
        );
      }
    }
  }

  /// Synchronizuje liczniki przekazane w nowszym snapshotcie rodzica.
  void syncParentCounters({
    required int subtaskTotal,
    required int subtaskCompleted,
  }) {
    if (isClosed ||
        (_parentTotal == subtaskTotal &&
            _parentCompleted == subtaskCompleted)) {
      return;
    }
    _parentTotal = subtaskTotal;
    _parentCompleted = subtaskCompleted;
    final current = state;
    if (current is KanbanSubtasksReady) {
      emit(
        current.copyWith(
          subtaskTotal: subtaskTotal,
          subtaskCompleted: subtaskCompleted,
        ),
      );
    }
  }

  /// Paginacja — pobranie kolejnej partii podzadań wewnątrz tej samej karty.
  Future<void> loadMore() async {
    final current = state;
    if (current is! KanbanSubtasksReady ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    try {
      final result = await tasksRepository.listProjectTasks(
        workspaceId: workspaceId,
        projectId: projectId,
        query: ProjectTasksQuery(
          parentTaskId: parentTaskId,
          cursor: current.nextCursor,
          limit: _pageSize,
        ),
      );

      if (isClosed) return;

      result.fold(
        (error) => emit(
          current.copyWith(
            isLoadingMore: false,
            loadMoreError: error.message,
          ),
        ),
        (page) {
          final existingIds = current.subtasks.map((t) => t.id).toSet();
          final newUniqueItems = page.items
              .where((t) => !existingIds.contains(t.id))
              .toList();
          final updatedItems = [...current.subtasks, ...newUniqueItems];
          final hasMore =
              (page.nextCursor != null && page.nextCursor!.isNotEmpty) ||
              (updatedItems.length < current.subtaskTotal);

          emit(
            current.copyWith(
              subtasks: updatedItems,
              nextCursor: page.nextCursor,
              hasMore: hasMore && updatedItems.length < current.subtaskTotal,
              isLoadingMore: false,
              clearLoadMoreError: true,
            ),
          );
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        current.copyWith(
          isLoadingMore: false,
          loadMoreError: e.toString(),
        ),
      );
    }
  }

  /// Utworzenie nowego podzadania inline wewnątrz karty.
  Future<bool> createSubtask(String rawTitle) async {
    final title = rawTitle.trim();
    if (title.isEmpty) return false;

    final current = state;
    if (current is! KanbanSubtasksReady || current.isSubmittingSubtask) {
      return false;
    }

    emit(current.copyWith(isSubmittingSubtask: true, clearCreateError: true));

    try {
      final result = await tasksRepository.quickCreateTask(
        workspaceId: workspaceId,
        projectId: projectId,
        payload: QuickCreateProjectTaskPayload(
          title: title,
          parentTaskId: parentTaskId,
        ),
      );

      if (isClosed) return false;

      final success = result.fold(
        (error) {
          emit(
            current.copyWith(
              isSubmittingSubtask: false,
              createError: error.message,
            ),
          );
          return false;
        },
        (mutation) {
          final created = mutation.data;
          final item = ProjectTaskListItemResponse(
            id: created.id,
            number: created.number,
            key: created.key,
            parentTaskId: created.parentTaskId,
            title: created.title,
            status: created.status,
            priority: created.priority,
            startAtUtc: created.startAtUtc,
            dueAtUtc: created.dueAtUtc,
            assignees: created.assignees,
            checklistCompletedCount: created.checklistItems
                .where((c) => c.isCompleted)
                .length,
            checklistTotalCount: created.checklistItems.length,
            updatedAtUtc: created.updatedAtUtc,
            version: created.version,
            customStatusId: created.customStatusId,
            taskType: created.taskType,
            size: created.size,
            complexity: created.complexity,
            risk: created.risk,
            businessValue: created.businessValue,
            estimatedMinutes: created.estimatedMinutes,
            actualMinutes: created.actualMinutes,
            recurrence: created.recurrence,
          );

          emit(
            current.copyWith(
              subtasks: [...current.subtasks, item],
              subtaskTotal: current.subtaskTotal + 1,
              isSubmittingSubtask: false,
              clearCreateError: true,
            ),
          );
          return true;
        },
      );
      return success;
    } catch (e) {
      if (isClosed) return false;
      emit(
        current.copyWith(
          isSubmittingSubtask: false,
          createError: e.toString(),
        ),
      );
      return false;
    }
  }

  /// Czyszczenie błędu dodawania bez utraty stanu.
  void clearCreateError() {
    final current = state;
    if (current is KanbanSubtasksReady && current.createError != null) {
      emit(current.copyWith(clearCreateError: true));
    }
  }

  /// Wąski port emisji dla wydzielonych mutacji podzadań.
  ///
  /// Chroni cykl życia Cubita w jednym miejscu i nie udostępnia chronionego
  /// `emit` poza samą klasą.
  void _emitMutationState(KanbanSubtasksState nextState) {
    if (!isClosed) emit(nextState);
  }
}
