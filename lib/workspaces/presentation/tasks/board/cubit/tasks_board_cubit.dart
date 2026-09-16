import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/kanban/models/kanban_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:ready_next/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:ready_next/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:ready_next/workspaces/domain/repositories/kanban_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:ready_next/workspaces/domain/repositories/task_template_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:ready_next/workspaces/presentation/tasks/recurrence/task_recurrence_summary.dart';

/// Właściciel snapshotu Kanbana, paginacji kolumn i lifecycle realtime.
final class TasksBoardCubit extends Cubit<TasksBoardState> {
  TasksBoardCubit(
    this._repository,
    this._realtime,
    this._tasksRepository, {
    this.workflowRepository,
    this.collaborationRepository,
    this.taskTemplateRepository,
    this.memberProfilesRepository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TasksBoardInitial());

  final KanbanRepository _repository;
  final TaskProjectRealtime _realtime;
  final TasksRepository _tasksRepository;
  final TaskWorkflowRepository? workflowRepository;
  final TaskCollaborationRepository? collaborationRepository;
  final TaskTemplateRepository? taskTemplateRepository;
  final ProjectMemberProfilesRepository? memberProfilesRepository;
  final String workspaceId;
  final String projectId;
  StreamSubscription<TaskProjectRealtimeUpdate>? _updates;
  StreamSubscription<WorkspaceSignalRConnectionState>? _connections;
  StreamSubscription<WorkspaceScopedRealtimeError>? _realtimeErrors;
  Timer? _resyncDebounce;
  Set<String>? _allowedWorkflowTransitions;
  final Set<String> _seenRealtimeEventIds = <String>{};
  final List<String> _realtimeEventOrder = <String>[];
  final Map<String, int> _lastTaskVersions = <String, int>{};
  int _boardQueryRevision = 0;

  Future<void> load({bool force = false}) async {
    final queryRevision = ++_boardQueryRevision;
    if (isClosed || (!force && state is TasksBoardLoading)) return;
    if (state is! TasksBoardReady) emit(const TasksBoardLoading());
    final result = await _repository.getBoard(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed || queryRevision != _boardQueryRevision) return;
    result.fold(
      (error) => emit(
        TasksBoardFailure(
          message: error.message,
          kind: switch (error.type) {
            ApiErrorType.forbidden ||
            ApiErrorType.unauthorized => TasksBoardFailureKind.forbidden,
            ApiErrorType.notFound => TasksBoardFailureKind.notFound,
            ApiErrorType.connectionTimeout ||
            ApiErrorType.sendTimeout ||
            ApiErrorType.receiveTimeout ||
            ApiErrorType.connection => TasksBoardFailureKind.offline,
            _ => TasksBoardFailureKind.other,
          },
          backendCode: error.backendCode?.toString(),
        ),
      ),
      (board) {
        final previous = state;
        emit(
          TasksBoardReady(
            board: board,
            connectionState: previous is TasksBoardReady
                ? previous.connectionState
                : WorkspaceSignalRConnectionState.disconnected,
            presence: previous is TasksBoardReady
                ? previous.presence
                : const <TaskProjectPresenceUser>[],
            memberProfilesByCoreUserId: previous is TasksBoardReady
                ? previous.memberProfilesByCoreUserId
                : const {},
            userPreference: previous is TasksBoardReady
                ? previous.userPreference
                : null,
            // Resync Kanbana nie jest nowym eventem realtime. Zachowanie obu
            // wartości zapobiega temu, by widok listy po debounce potraktował
            // świeży snapshot jako nieznaną zmianę i odczytał całą tabelę.
            realtimeRevision: previous is TasksBoardReady
                ? previous.realtimeRevision
                : 0,
            latestRealtimeMutation: previous is TasksBoardReady
                ? previous.latestRealtimeMutation
                : null,
          ),
        );
      },
    );
  }

  Future<void> start() async {
    await load();
    if (isClosed || state is TasksBoardFailure) return;
    await _updates?.cancel();
    await _connections?.cancel();
    await _realtimeErrors?.cancel();
    _updates = _realtime.updates.listen(_onRealtimeUpdate);
    _connections = _realtime.connectionStates.listen(_onConnectionState);
    _realtimeErrors = _realtime.errors.listen((_) => _scheduleResync());
    await _realtime.start(workspaceId: workspaceId, projectId: projectId);
    unawaited(_loadUserPreference());
    unawaited(refreshWorkflow());
    unawaited(_loadMemberProfiles());
  }

  /// Ładuje dane widoczne w presence poza krytyczną ścieżką snapshotu tablicy.
  ///
  /// Błąd katalogu nie blokuje pracy Kanbana: UI pokaże wtedy deterministyczne
  /// inicjały, nigdy surowy identyfikator użytkownika.
  Future<void> _loadMemberProfiles() async {
    final repository = memberProfilesRepository;
    if (repository == null) return;
    final result = await repository.listProfiles(
      workspaceId: workspaceId,
      projectId: projectId,
      forceRefresh: true,
    );
    final current = state;
    if (isClosed || current is! TasksBoardReady) return;
    result.fold(
      (_) {},
      (profiles) {
        final latest = state;
        if (isClosed || latest is! TasksBoardReady) return;
        emit(
          latest.copyWith(
            memberProfilesByCoreUserId: {
              for (final profile in profiles) profile.coreUserId: profile,
            },
          ),
        );
      },
    );
  }

  /// Odświeża lokalną macierz przejść po zmianie ustawień projektu.
  Future<void> refreshWorkflow() async {
    final repository = workflowRepository;
    if (repository == null) return;
    final result = await repository.getWorkflow(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    result.fold(
      (_) {},
      (workflow) => _allowedWorkflowTransitions = {
        for (final transition in workflow.transitions)
          _transitionKey(transition.fromStatus, transition.toStatus),
      },
    );
  }

  Future<void> _loadUserPreference() async {
    final result = await _repository.getUserPreference(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    final current = state;
    if (isClosed || current is! TasksBoardReady) return;
    result.fold(
      (_) {},
      (preference) => emit(current.copyWith(userPreference: preference)),
    );
  }

  /// Zmienia wyłącznie osobiste przypięcie karty, bez odczytywania boarda.
  Future<bool> togglePinned(KanbanTaskCardResponse task) async {
    final current = state;
    final collaboration = collaborationRepository;
    if (current is! TasksBoardReady || collaboration == null) return false;
    final pinned = !task.isPinned;
    final result = await collaboration.updatePinned(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: task.id,
      isPinned: pinned,
    );
    if (isClosed || state is! TasksBoardReady) return false;
    final latest = state as TasksBoardReady;
    return result.fold(
      (error) {
        emit(
          latest.copyWith(
            mutationError: error.message,
            mutationSerial: latest.mutationSerial + 1,
          ),
        );
        return false;
      },
      (_) {
        final currentCard =
            latest.board.columns
                .expand((column) => column.tasks)
                .where((card) => card.id == task.id)
                .firstOrNull ??
            task;
        emit(_replaceCard(latest, currentCard.copyWith(isPinned: pinned)));
        return true;
      },
    );
  }

  /// Obserwuje albo przestaje obserwować pojedynczą kartę z jej wersją.
  Future<bool> toggleWatching(KanbanTaskCardResponse task) async {
    final current = state;
    final collaboration = collaborationRepository;
    if (current is! TasksBoardReady || collaboration == null) return false;
    final result = task.isWatchedByMe
        ? await collaboration.unfollow(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: task.id,
            expectedVersion: task.version,
          )
        : await collaboration.follow(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: task.id,
            expectedVersion: task.version,
          );
    if (isClosed || state is! TasksBoardReady) return false;
    final latest = state as TasksBoardReady;
    return result.fold(
      (error) {
        emit(
          latest.copyWith(
            mutationError: error.message,
            mutationSerial: latest.mutationSerial + 1,
          ),
        );
        return false;
      },
      (mutation) {
        final currentCard =
            latest.board.columns
                .expand((column) => column.tasks)
                .where((card) => card.id == task.id)
                .firstOrNull ??
            task;
        final watching = !currentCard.isWatchedByMe;
        emit(
          _replaceCard(
            latest,
            currentCard.copyWith(
              isWatchedByMe: watching,
              watcherCount: watching
                  ? currentCard.watcherCount + 1
                  : (currentCard.watcherCount - 1).clamp(
                      0,
                      currentCard.watcherCount,
                    ),
              version: mutation.taskVersion,
            ),
          ),
        );
        return true;
      },
    );
  }

  /// Zapisuje priorytet z jednolitym stanem mutacji Kanbana.
  Future<bool> updateTaskPriority(String taskId, TaskPriority priority) =>
      _updateCardListItem(
        taskId,
        (card) => UpdateTaskListItemPayload(
          priority: priority,
          expectedVersion: card.version,
        ),
      );

  /// Zapisuje termin z jednolitym stanem mutacji Kanbana.
  Future<bool> updateTaskDueDate(String taskId, DateTime? dueAtUtc) =>
      _updateCardListItem(
        taskId,
        (card) => UpdateTaskListItemPayload(
          dueAtUtc: dueAtUtc,
          clearDueAtUtc: dueAtUtc == null,
          expectedVersion: card.version,
        ),
      );

  /// Zastępuje wykonawców przez wspólny mechanizm mutacji karty.
  Future<bool> replaceTaskAssignees(
    String taskId,
    List<String> coreUserIds,
  ) async {
    final current = state;
    final collaboration = collaborationRepository;
    if (current is! TasksBoardReady ||
        collaboration == null ||
        current.pendingTaskIds.contains(taskId)) {
      return false;
    }
    final card = current.board.columns
        .expand((column) => column.tasks)
        .where((item) => item.id == taskId)
        .firstOrNull;
    if (card == null) return false;
    emit(current.copyWith(pendingTaskIds: {...current.pendingTaskIds, taskId}));
    final result = await collaboration.replaceAssignees(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      coreUserIds: coreUserIds,
      expectedVersion: card.version,
    );
    if (isClosed || state is! TasksBoardReady) return false;
    final ready = state as TasksBoardReady;
    return result.fold(
      (error) {
        emit(
          ready.copyWith(
            pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            mutationError: error.message,
            mutationSerial: ready.mutationSerial + 1,
          ),
        );
        return false;
      },
      (mutation) {
        final latest = ready.board.columns
            .expand((column) => column.tasks)
            .where((item) => item.id == taskId)
            .firstOrNull;
        if (latest != null) {
          if (mutation.data.version < latest.version) {
            emit(
              ready.copyWith(
                pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
              ),
            );
            return true;
          }
          final primary =
              mutation.data.assignees
                  .where((item) => item.isPrimary)
                  .firstOrNull ??
              mutation.data.assignees.firstOrNull;
          emit(
            _replaceCard(
              ready,
              latest.copyWith(
                primaryAssigneeCoreUserId: primary?.coreUserId,
                version: mutation.data.version,
              ),
            ).copyWith(
              pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            ),
          );
        } else {
          emit(
            ready.copyWith(
              pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            ),
          );
        }
        return true;
      },
    );
  }

  Future<bool> _updateCardListItem(
    String taskId,
    UpdateTaskListItemPayload Function(KanbanTaskCardResponse card) payload,
  ) async {
    final current = state;
    if (current is! TasksBoardReady ||
        current.pendingTaskIds.contains(taskId)) {
      return false;
    }
    final card = current.board.columns
        .expand((column) => column.tasks)
        .where((item) => item.id == taskId)
        .firstOrNull;
    if (card == null) return false;
    emit(current.copyWith(pendingTaskIds: {...current.pendingTaskIds, taskId}));
    final result = await _tasksRepository.updateListItem(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: payload(card),
    );
    if (isClosed || state is! TasksBoardReady) return false;
    final ready = state as TasksBoardReady;
    return result.fold(
      (error) {
        emit(
          ready.copyWith(
            pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            mutationError: error.message,
            mutationSerial: ready.mutationSerial + 1,
          ),
        );
        return false;
      },
      (mutation) {
        final saved = mutation.data;
        final latest = ready.board.columns
            .expand((column) => column.tasks)
            .where((item) => item.id == taskId)
            .firstOrNull;
        if (latest != null) {
          if (saved.version < latest.version) {
            emit(
              ready.copyWith(
                pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
              ),
            );
            return true;
          }
          emit(
            _replaceCard(
              ready,
              latest.copyWith(
                priority: saved.priority,
                dueAtUtc: saved.dueAtUtc,
                version: saved.version,
              ),
            ).copyWith(
              pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            ),
          );
        } else {
          emit(
            ready.copyWith(
              pendingTaskIds: {...ready.pendingTaskIds}..remove(taskId),
            ),
          );
        }
        return true;
      },
    );
  }

  TasksBoardReady _replaceCard(
    TasksBoardReady current,
    KanbanTaskCardResponse replacement,
  ) => current.copyWith(
    board: current.board.copyWith(
      columns: [
        for (final column in current.board.columns)
          column.copyWith(
            tasks: [
              for (final task in column.tasks)
                if (task.id == replacement.id) replacement else task,
            ],
          ),
      ],
    ),
    clearMutationError: true,
    mutationSerial: current.mutationSerial + 1,
  );

  /// Stosuje wynik wspólnego edytora cykliczności tylko do karty, której
  /// dotyczył zapis — bez odczytu całego boarda.
  void applyRecurrenceMutation(
    KanbanTaskCardResponse task,
    TaskMutationResponse<TaskRecurrenceResponse> mutation,
  ) {
    final current = state;
    if (current is! TasksBoardReady || isClosed) return;
    final value = mutation.data;
    final latestTask =
        current.board.columns
            .expand((column) => column.tasks)
            .where((card) => card.id == task.id)
            .firstOrNull ??
        task;
    emit(
      _replaceCard(
        current,
        latestTask.copyWith(
          version: mutation.taskVersion,
          recurrence: value.toSummary(taskId: latestTask.id),
        ),
      ),
    );
  }

  /// Zapisuje osobiste zwinięcie kolumny bez dotykania ustawień projektu.
  Future<void> toggleColumnCollapsed(KanbanColumnResponse column) async {
    final current = state;
    if (current is! TasksBoardReady || current.savingUserPreference) return;
    final preference = current.userPreference;
    if (preference == null) return;

    final customStatusId = column.customStatusId;
    final collapsedStatuses = {...preference.collapsedColumns};
    final collapsedCustomStatuses = {...preference.collapsedCustomStatusIds};
    final wasCollapsed = customStatusId == null
        ? collapsedStatuses.contains(column.status)
        : collapsedCustomStatuses.contains(customStatusId);
    if (customStatusId == null) {
      wasCollapsed
          ? collapsedStatuses.remove(column.status)
          : collapsedStatuses.add(column.status);
    } else {
      wasCollapsed
          ? collapsedCustomStatuses.remove(customStatusId)
          : collapsedCustomStatuses.add(customStatusId);
    }
    final optimistic = preference.copyWith(
      collapsedColumns: collapsedStatuses.toList(growable: false),
      collapsedCustomStatusIds: collapsedCustomStatuses.toList(growable: false),
    );
    emit(
      current.copyWith(
        userPreference: optimistic,
        savingUserPreference: true,
        clearMutationError: true,
      ),
    );
    final result = await _repository.updateUserPreference(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: UpdateUserKanbanPreferencePayload(
        collapsedColumns: optimistic.collapsedColumns,
        collapsedCustomStatusIds: optimistic.collapsedCustomStatusIds,
        quickFilter: preference.quickFilter,
        expectedVersion: preference.version,
      ),
    );
    final ready = state;
    if (isClosed || ready is! TasksBoardReady) return;
    result.fold(
      (error) => emit(
        ready.copyWith(
          userPreference: preference,
          savingUserPreference: false,
          mutationError: error.message,
          mutationSerial: ready.mutationSerial + 1,
        ),
      ),
      (saved) => emit(
        ready.copyWith(userPreference: saved, savingUserPreference: false),
      ),
    );
  }

  /// Zmienia osobisty szybki filtr, zapisuje go wersjonowanym PUT i pobiera
  /// nowy snapshot, aby liczniki oraz wszystkie strony kolumn pozostały spójne.
  Future<void> setQuickFilter(KanbanQuickFilter quickFilter) async {
    final current = state;
    if (current is! TasksBoardReady || current.savingUserPreference) return;
    final preference = current.userPreference;
    if (preference == null || preference.quickFilter == quickFilter) return;

    final optimistic = preference.copyWith(quickFilter: quickFilter);
    emit(
      current.copyWith(
        userPreference: optimistic,
        savingUserPreference: true,
        clearMutationError: true,
      ),
    );
    final result = await _repository.updateUserPreference(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: UpdateUserKanbanPreferencePayload(
        collapsedColumns: preference.collapsedColumns,
        collapsedCustomStatusIds: preference.collapsedCustomStatusIds,
        quickFilter: quickFilter,
        expectedVersion: preference.version,
      ),
    );
    final ready = state;
    if (isClosed || ready is! TasksBoardReady) return;
    await result.fold(
      (error) async => emit(
        ready.copyWith(
          userPreference: preference,
          savingUserPreference: false,
          mutationError: error.message,
          mutationSerial: ready.mutationSerial + 1,
        ),
      ),
      (saved) async {
        emit(
          ready.copyWith(userPreference: saved, savingUserPreference: false),
        );
        await load(force: true);
      },
    );
  }

  Future<void> loadMore(KanbanColumnResponse column) async {
    final current = state;
    final cursor = column.nextCursor;
    final key = _columnKey(column);
    if (current is! TasksBoardReady ||
        cursor == null ||
        current.loadingColumnKeys.contains(key)) {
      return;
    }
    final queryRevision = _boardQueryRevision;
    emit(
      current.copyWith(
        loadingColumnKeys: {...current.loadingColumnKeys, key},
        columnLoadErrors: {...current.columnLoadErrors}..remove(key),
      ),
    );
    final customStatusId = column.customStatusId;
    final result = customStatusId != null
        ? await _repository.getCustomColumn(
            workspaceId: workspaceId,
            projectId: projectId,
            customStatusId: customStatusId,
            query: KanbanColumnQuery(cursor: cursor),
          )
        : await _repository.getSystemColumn(
            workspaceId: workspaceId,
            projectId: projectId,
            status: column.status,
            query: KanbanColumnQuery(cursor: cursor),
          );
    if (isClosed ||
        queryRevision != _boardQueryRevision ||
        state is! TasksBoardReady) {
      return;
    }
    result.fold(
      (error) => _finishColumnLoading(key, error: error.message),
      (page) {
        final ready = state as TasksBoardReady;
        final columns = ready.board.columns
            .map((candidate) {
              if (_columnKey(candidate) != key) return candidate;
              final known = candidate.tasks.map((task) => task.id).toSet();
              return candidate.copyWith(
                tasks: [
                  ...candidate.tasks,
                  ...page.items.where((task) => known.add(task.id)),
                ],
                nextCursor: page.nextCursor,
              );
            })
            .toList(growable: false);
        emit(
          ready.copyWith(
            board: ready.board.copyWith(columns: columns),
            loadingColumnKeys: {...ready.loadingColumnKeys}..remove(key),
          ),
        );
      },
    );
  }

  /// Tworzy zadanie od razu w wybranej kolumnie (systemowej lub własnej) z opcjonalną formatką i odświeża snapshot tablicy.
  Future<bool> createQuickTask({
    required KanbanColumnResponse column,
    required String title,
    String? taskTemplateId,
    bool useDefaultTemplate = true,
  }) async {
    final normalizedTitle = title.trim();
    final current = state;
    if (current is! TasksBoardReady || normalizedTitle.isEmpty) {
      return false;
    }
    final result = await _tasksRepository.quickCreateTask(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: QuickCreateProjectTaskPayload(
        title: normalizedTitle,
        targetStatus: column.customStatusId == null ? column.status : null,
        customStatusId: column.customStatusId,
        taskTemplateId: taskTemplateId,
        useDefaultTemplate: useDefaultTemplate,
      ),
    );
    if (isClosed) return false;
    var created = false;
    await result.fold(
      (error) async {
        final ready = state;
        if (ready is TasksBoardReady) {
          emit(
            ready.copyWith(
              mutationError: error.message,
              mutationSerial: ready.mutationSerial + 1,
            ),
          );
        }
      },
      (_) async {
        created = true;
        await load(force: true);
      },
    );
    return created;
  }

  /// Tworzy zadanie przez kontrakt szablonu, a potem odświeża snapshot Kanbana.
  Future<bool> applyTaskTemplate({
    required String templateId,
    required String title,
  }) async {
    final repository = taskTemplateRepository;
    final current = state;
    if (current is! TasksBoardReady || repository == null) return false;

    final result = await repository.apply(
      workspaceId: workspaceId,
      templateId: templateId,
      payload: ApplyTaskTemplatePayload(
        projectId: projectId,
        titleOverride: title.trim(),
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        final ready = state;
        if (ready is TasksBoardReady) {
          emit(
            ready.copyWith(
              mutationError: error.message,
              mutationSerial: ready.mutationSerial + 1,
            ),
          );
        }
        return false;
      },
      (_) async {
        await load(force: true);
        return true;
      },
    );
  }

  /// Zmienia zaznaczenie karty bez przechowywania stanu w pojedynczym widżecie.
  void toggleTaskSelection(KanbanTaskCardResponse task) {
    final current = state;
    if (current is! TasksBoardReady || current.isBulkSaving) return;
    final selected = {...current.selectedTaskIds};
    selected.contains(task.id)
        ? selected.remove(task.id)
        : selected.add(task.id);
    emit(current.copyWith(selectedTaskIds: selected));
  }

  /// Czyści bieżący zestaw kart wybranych do operacji zbiorczej.
  void clearTaskSelection() {
    final current = state;
    if (current is! TasksBoardReady || current.selectedTaskIds.isEmpty) return;
    emit(current.copyWith(selectedTaskIds: const <String>{}));
  }

  /// Zaznacza wszystkie aktualnie wczytane karty tablicy.
  ///
  /// Nie pobiera kolejnych stron kolumn: skrót klawiaturowy operuje wyłącznie
  /// na widocznym zbiorze, więc nie może przypadkowo zmienić ukrytych zadań.
  void selectAllLoadedTasks() {
    final current = state;
    if (current is! TasksBoardReady || current.isBulkSaving) return;
    final taskIds = {
      for (final column in current.board.columns)
        for (final task in column.tasks) task.id,
    };
    if (taskIds.isEmpty ||
        taskIds.length == current.selectedTaskIds.length &&
            taskIds.containsAll(current.selectedTaskIds)) {
      return;
    }
    emit(current.copyWith(selectedTaskIds: taskIds));
  }

  /// Atomowo przenosi wszystkie zaznaczone karty na wersjach snapshotu.
  Future<void> bulkMoveTasks(KanbanColumnResponse targetColumn) async {
    final current = state;
    if (current is! TasksBoardReady ||
        current.isBulkSaving ||
        current.selectedTaskIds.isEmpty) {
      return;
    }
    final cards = _selectedCards(current);
    if (cards.isEmpty) return;
    emit(current.copyWith(isBulkSaving: true, clearMutationError: true));
    final result = await _repository.bulkMove(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: BulkMoveKanbanTasksPayload(
        targetStatus: targetColumn.status,
        customStatusId: targetColumn.customStatusId,
        tasks: [
          for (final card in cards)
            BulkMoveKanbanTaskItemPayload(
              taskId: card.id,
              expectedVersion: card.version,
            ),
        ],
      ),
    );
    if (isClosed) return;
    await result.fold(
      (error) async {
        final ready = state;
        if (ready is TasksBoardReady) {
          emit(
            ready.copyWith(
              isBulkSaving: false,
              mutationError: error.message,
              mutationSerial: ready.mutationSerial + 1,
            ),
          );
        }
      },
      (_) async => load(force: true),
    );
  }

  /// Atomowo nadaje jeden priorytet wszystkim zaznaczonym kartom.
  Future<void> bulkUpdatePriority(TaskPriority priority) =>
      _bulkUpdate(priority: priority);

  /// Atomowo ustawia termin wszystkim zaznaczonym kartom.
  Future<void> bulkUpdateDueDate(DateTime dueAtUtc) =>
      _bulkUpdate(dueAtUtc: dueAtUtc.toUtc());

  Future<void> _bulkUpdate({TaskPriority? priority, DateTime? dueAtUtc}) async {
    final current = state;
    if (current is! TasksBoardReady ||
        current.isBulkSaving ||
        current.selectedTaskIds.isEmpty) {
      return;
    }
    final cards = _selectedCards(current);
    if (cards.isEmpty) return;
    emit(current.copyWith(isBulkSaving: true, clearMutationError: true));
    final result = await _repository.bulkUpdate(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: BulkUpdateKanbanTasksPayload(
        priority: priority,
        dueAtUtc: dueAtUtc,
        tasks: [
          for (final card in cards)
            BulkUpdateKanbanTaskItemPayload(
              taskId: card.id,
              expectedVersion: card.version,
            ),
        ],
      ),
    );
    if (isClosed) return;
    await result.fold(
      (error) async {
        final ready = state;
        if (ready is TasksBoardReady) {
          emit(
            ready.copyWith(
              isBulkSaving: false,
              mutationError: error.message,
              mutationSerial: ready.mutationSerial + 1,
            ),
          );
        }
      },
      (_) async => load(force: true),
    );
  }

  List<KanbanTaskCardResponse> _selectedCards(TasksBoardReady current) => [
    for (final column in current.board.columns)
      for (final task in column.tasks)
        if (current.selectedTaskIds.contains(task.id)) task,
  ];

  /// Przenosi kartę z optymistyczną aktualizacją i rollbackiem przy błędzie.
  Future<void> moveTask({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
    required int targetIndex,
  }) async {
    final current = state;
    if (current is! TasksBoardReady) return;
    final latestTask = current.board.columns
        .expand((column) => column.tasks)
        .where((item) => item.id == task.id)
        .firstOrNull;
    if (latestTask == null) {
      emit(
        current.copyWith(
          mutationError: 'Zadanie nie jest już dostępne na aktualnej tablicy.',
          mutationSerial: current.mutationSerial + 1,
        ),
      );
      return;
    }
    task = latestTask;
    if (!canMoveTaskTo(task: task, targetColumn: targetColumn)) {
      debugPrint(
        '[Kanban] Drop zablokowany przez workflow: '
        '${task.status.name} → ${targetColumn.status.name}',
      );
      emit(
        current.copyWith(
          mutationError: 'To przejście statusu nie jest dozwolone w workflow.',
          mutationSerial: current.mutationSerial + 1,
        ),
      );
      return;
    }
    final sourceColumn = current.board.columns
        .where((column) => column.tasks.any((item) => item.id == task.id))
        .firstOrNull;
    if (sourceColumn == null) {
      debugPrint('[Kanban] Nie znaleziono karty źródłowej dla dropu.');
      return;
    }

    final isSameColumn = _columnKey(sourceColumn) == _columnKey(targetColumn);
    final sourceIndex = sourceColumn.tasks.indexWhere(
      (item) => item.id == task.id,
    );
    final adjustedTargetIndex =
        isSameColumn && sourceIndex >= 0 && sourceIndex < targetIndex
        ? targetIndex - 1
        : targetIndex;
    final targetCards = targetColumn.tasks
        .where((item) => item.id != task.id)
        .toList(growable: true);
    final safeIndex = adjustedTargetIndex.clamp(0, targetCards.length);
    final previousTaskId = safeIndex == 0
        ? null
        : targetCards[safeIndex - 1].id;
    final nextTaskId = safeIndex == targetCards.length
        ? null
        : targetCards[safeIndex].id;
    targetCards.insert(
      safeIndex,
      task.copyWith(
        status: targetColumn.status,
        customStatusId: targetColumn.customStatusId,
      ),
    );

    final sourceKey = _columnKey(sourceColumn);
    final targetKey = _columnKey(targetColumn);
    final optimisticColumns = current.board.columns
        .map((column) {
          final key = _columnKey(column);
          if (key == targetKey) {
            return column.copyWith(
              tasks: targetCards,
              totalTaskCount: isSameColumn
                  ? column.totalTaskCount
                  : column.totalTaskCount + 1,
            );
          }
          if (key == sourceKey) {
            return column.copyWith(
              tasks: column.tasks.where((item) => item.id != task.id).toList(),
              totalTaskCount: (column.totalTaskCount - 1).clamp(0, 1 << 31),
            );
          }
          return column;
        })
        .toList(growable: false);
    emit(
      current.copyWith(
        board: current.board.copyWith(columns: optimisticColumns),
        pendingTaskIds: {...current.pendingTaskIds, task.id},
        clearMutationError: true,
      ),
    );

    final result = await _repository.moveTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: task.id,
      payload: MoveKanbanTaskPayload(
        targetStatus: targetColumn.status,
        previousTaskId: previousTaskId,
        nextTaskId: nextTaskId,
        expectedVersion: task.version,
        customStatusId: targetColumn.customStatusId,
      ),
    );
    if (isClosed) return;
    result.fold(
      (error) {
        debugPrint(
          '[Kanban] Backend odrzucił przeniesienie: '
          '${error.backendCode ?? error.type.name} — ${error.message}',
        );
        final ready = state;
        if (ready is TasksBoardReady) {
          final revertedColumns = ready.board.columns
              .map((column) {
                final key = _columnKey(column);
                if (key == targetKey) {
                  return column.copyWith(
                    tasks: column.tasks
                        .where((item) => item.id != task.id)
                        .toList(growable: false),
                    totalTaskCount: isSameColumn
                        ? column.totalTaskCount
                        : (column.totalTaskCount - 1).clamp(0, 1 << 31),
                  );
                }
                if (key == sourceKey) {
                  final restoredCards = column.tasks
                      .where((item) => item.id != task.id)
                      .toList(growable: true);
                  final insertIdx = sourceIndex.clamp(0, restoredCards.length);
                  restoredCards.insert(insertIdx, task);
                  return column.copyWith(
                    tasks: restoredCards,
                    totalTaskCount: isSameColumn
                        ? column.totalTaskCount
                        : column.totalTaskCount + 1,
                  );
                }
                return column;
              })
              .toList(growable: false);

          emit(
            ready.copyWith(
              board: ready.board.copyWith(columns: revertedColumns),
              pendingTaskIds: {...ready.pendingTaskIds}..remove(task.id),
              mutationError: error.message,
              mutationSerial: ready.mutationSerial + 1,
            ),
          );
        }
      },
      (response) {
        debugPrint('[Kanban] Backend potwierdził przeniesienie karty.');
        final ready = state;
        if (ready is! TasksBoardReady) return;
        final currentCard = ready.board.columns
            .expand((column) => column.tasks)
            .where((item) => item.id == response.task.id)
            .firstOrNull;
        if (currentCard != null &&
            currentCard.version > response.task.version) {
          emit(
            ready.copyWith(
              pendingTaskIds: {...ready.pendingTaskIds}..remove(task.id),
            ),
          );
          return;
        }
        final columns = ready.board.columns
            .map((column) {
              if (_columnKey(column) != targetKey) return column;
              return column.copyWith(
                tasks: column.tasks
                    .map(
                      (item) =>
                          item.id == response.task.id ? response.task : item,
                    )
                    .toList(growable: false),
                totalTaskCount: response.targetColumnTaskCount,
                wipLimit: response.targetColumnWipLimit,
                isWipLimitExceeded: response.isWipLimitExceeded,
              );
            })
            .toList(growable: false);
        emit(
          ready.copyWith(
            board: ready.board.copyWith(columns: columns),
            pendingTaskIds: {...ready.pendingTaskIds}..remove(task.id),
          ),
        );
      },
    );
  }

  void _finishColumnLoading(String key, {String? error}) {
    final ready = state;
    if (ready is TasksBoardReady) {
      final errors = {...ready.columnLoadErrors};
      if (error != null) errors[key] = error;
      emit(
        ready.copyWith(
          loadingColumnKeys: {...ready.loadingColumnKeys}..remove(key),
          columnLoadErrors: errors,
        ),
      );
    }
  }

  void _onConnectionState(WorkspaceSignalRConnectionState connectionState) {
    final current = state;
    if (!isClosed && current is TasksBoardReady) {
      emit(current.copyWith(connectionState: connectionState));
    }
  }

  void _onRealtimeUpdate(TaskProjectRealtimeUpdate update) {
    final current = state;
    if (isClosed || current is! TasksBoardReady) return;
    switch (update) {
      case TaskProjectPresence(:final users):
        emit(current.copyWith(presence: List.unmodifiable(users)));
      case TaskRealtimeMutation(
        :final type,
        :final eventId,
        :final taskId,
        :final version,
      ):
        if (!_acceptRealtimeMutation(
          eventId: eventId,
          taskId: taskId,
          version: version,
        )) {
          return;
        }
        if (type == TaskRealtimeMutationType.updated) {
          _patchLoadedCard(update);
        } else {
          emit(
            current.copyWith(
              realtimeRevision: current.realtimeRevision + 1,
              latestRealtimeMutation: update,
            ),
          );
          _scheduleResync();
        }
    }
  }

  /// Eliminuje powtórzone replaye i opóźnione zdarzenia dla tej samej karty.
  bool _acceptRealtimeMutation({
    required String eventId,
    required String taskId,
    required int version,
  }) {
    if (_seenRealtimeEventIds.contains(eventId)) return false;
    final lastVersion = _lastTaskVersions[taskId];
    if (lastVersion != null && version <= lastVersion) return false;
    _seenRealtimeEventIds.add(eventId);
    _realtimeEventOrder.add(eventId);
    if (_realtimeEventOrder.length > 500) {
      _seenRealtimeEventIds.remove(_realtimeEventOrder.removeAt(0));
    }
    _lastTaskVersions[taskId] = version;
    return true;
  }

  void _patchLoadedCard(TaskRealtimeMutation mutation) {
    final current = state;
    if (current is! TasksBoardReady) return;
    var changed = false;
    final columns = current.board.columns
        .map((column) {
          final cards = column.tasks
              .map((card) {
                if (card.id != mutation.taskId ||
                    card.version >= mutation.version) {
                  return card;
                }
                changed = true;
                return card.copyWith(
                  title: mutation.title ?? card.title,
                  priority: mutation.priority ?? card.priority,
                  dueAtUtc: mutation.hasDueAtUtc
                      ? mutation.dueAtUtc
                      : card.dueAtUtc,
                  position: mutation.position ?? card.position,
                  version: mutation.version,
                );
              })
              .toList(growable: false);
          return column.copyWith(tasks: cards);
        })
        .toList(growable: false);
    emit(
      current.copyWith(
        board: changed ? current.board.copyWith(columns: columns) : null,
        realtimeRevision: current.realtimeRevision + 1,
        latestRealtimeMutation: mutation,
      ),
    );
  }

  void _scheduleResync() {
    _resyncDebounce?.cancel();
    _resyncDebounce = Timer(
      const Duration(milliseconds: 180),
      () => unawaited(load(force: true)),
    );
  }

  static String _columnKey(KanbanColumnResponse column) =>
      column.customStatusId ?? column.status.name;

  bool _isWorkflowTransitionAllowed(
    KanbanTaskCardResponse task,
    KanbanColumnResponse targetColumn,
  ) {
    final transitions = _allowedWorkflowTransitions;
    if (transitions == null ||
        task.customStatusId != null ||
        targetColumn.customStatusId != null ||
        task.status == targetColumn.status) {
      return true;
    }
    return transitions.contains(
      _transitionKey(task.status, targetColumn.status),
    );
  }

  /// Określa, czy interfejs może przyjąć kartę w danej kolumnie.
  ///
  /// Backend pozostaje ostatecznym źródłem autoryzacji; metoda pozwala jedynie
  /// nie podświetlać stref, które lokalna macierz workflow już odrzuca.
  bool canMoveTaskTo({
    required KanbanTaskCardResponse task,
    required KanbanColumnResponse targetColumn,
  }) {
    final current = state;
    if (current is TasksBoardReady &&
        current.pendingTaskIds.contains(task.id)) {
      return false;
    }
    return _isWorkflowTransitionAllowed(task, targetColumn);
  }

  static String _transitionKey(
    ProjectTaskStatus from,
    ProjectTaskStatus to,
  ) => '${from.name}:${to.name}';

  @override
  Future<void> close() async {
    _resyncDebounce?.cancel();
    await _updates?.cancel();
    await _connections?.cancel();
    await _realtimeErrors?.cancel();
    await _realtime.dispose();
    return super.close();
  }
}
