import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:ready_next/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/task_list_query.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/task_list_selection.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/task_list_snapshot.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/task_list_tree_snapshot.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/task_list_grouping.dart';
import 'package:ready_next/workspaces/presentation/tasks/recurrence/task_recurrence_summary.dart';

export 'project_tasks_list_state.dart';

/// Cursorowa lista zadań projektu z filtrami obsługiwanymi przez backend.
final class ProjectTasksListCubit extends Cubit<ProjectTasksListState> {
  ProjectTasksListCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    this.metadataRepository,
    this.collaborationRepository,
    this.recurrenceRepository,
    this.savedViewId,
    TaskSavedViewGroupBy? groupBy,
  }) : _groupBy = groupBy ?? TaskSavedViewGroupBy.status,
       super(const ProjectTasksListLoading());

  final TasksRepository repository;
  final TaskMetadataRepository? metadataRepository;
  final TaskCollaborationRepository? collaborationRepository;
  final TaskRecurrenceRepository? recurrenceRepository;
  final String workspaceId;
  final String projectId;
  final String? savedViewId;
  TaskSavedViewGroupBy _groupBy;

  /// Aktualny sposób grupowania listy zadań.
  TaskSavedViewGroupBy get groupBy => _groupBy;

  /// Aktualizuje sposób grupowania listy zadań i przeładowuje dane.
  Future<void> updateGroupBy(TaskSavedViewGroupBy newGroupBy) async {
    if (_groupBy == newGroupBy && state is ProjectTasksListReady) return;
    _groupBy = newGroupBy;
    await load();
  }

  int _requestSerial = 0;
  int _localMutationDepth = 0;
  DateTime? _realtimeSuppressedUntil;
  Timer? _deferredRealtimeTimer;
  bool _realtimeRefreshPending = false;
  final List<TaskRealtimeMutation> _pendingRealtimeMutations = [];
  final Map<String, Future<bool>> _inFlightListItemUpdates = {};
  final Set<String> _loadingGroupKeys = {};

  bool get _shouldIgnoreRealtime {
    if (_localMutationDepth > 0) return true;
    final until = _realtimeSuppressedUntil;
    return until != null && until.isAfter(DateTime.now());
  }

  void _beginLocalMutation() => _localMutationDepth++;

  void _endLocalMutation() {
    _localMutationDepth = (_localMutationDepth - 1).clamp(0, 1 << 20);
    if (_realtimeRefreshPending) _scheduleDeferredRealtimeRefresh();
  }

  void _suppressRealtimeForLocalMutation() {
    // Odpowiedź mutacji zawiera już świeży snapshot wiersza. Nie zakładamy
    // sztucznego, dwusekundowego okna ciszy — było ono przyczyną widocznego
    // pełnego przeładowania listy po edycji pojedynczej komórki.
    _realtimeSuppressedUntil = null;
    if (_realtimeRefreshPending) _scheduleDeferredRealtimeRefresh();
  }

  void _scheduleDeferredRealtimeRefresh() {
    _deferredRealtimeTimer?.cancel();
    final delay = _localMutationDepth > 0
        ? const Duration(milliseconds: 80)
        : Duration.zero;
    _deferredRealtimeTimer = Timer(
      delay.isNegative ? Duration.zero : delay,
      () async {
        if (isClosed) return;
        _realtimeRefreshPending = false;
        final mutations = List<TaskRealtimeMutation>.from(
          _pendingRealtimeMutations,
        );
        _pendingRealtimeMutations.clear();
        for (final mutation in mutations) {
          if (isClosed) return;
          await applyRealtimeMutation(mutation);
        }
      },
    );
  }

  Future<void> load({
    ProjectTaskStatus? status,
    TaskPriority? priority,
    String? assigneeCoreUserId,
    TaskInvolvementFilter? myInvolvement,
    bool? unassignedOnly,
    bool? pinnedOnly,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearAssigneeCoreUserId = false,
    bool clearMyInvolvement = false,
  }) async {
    final current = state;
    final selectedStatus = clearStatus
        ? null
        : status ?? (current is ProjectTasksListReady ? current.status : null);
    final selectedPriority = clearPriority
        ? null
        : priority ??
              (current is ProjectTasksListReady ? current.priority : null);
    final selectedAssigneeCoreUserId = clearAssigneeCoreUserId
        ? null
        : assigneeCoreUserId ??
              (current is ProjectTasksListReady
                  ? current.assigneeCoreUserId
                  : null);
    final selectedMyInvolvement = clearMyInvolvement
        ? null
        : myInvolvement ??
              (current is ProjectTasksListReady ? current.myInvolvement : null);
    final selectedUnassignedOnly =
        unassignedOnly ??
        (current is ProjectTasksListReady && current.unassignedOnly);
    final selectedPinnedOnly =
        pinnedOnly ?? (current is ProjectTasksListReady && current.pinnedOnly);
    final serial = ++_requestSerial;
    if (current is ProjectTasksListReady) {
      emit(
        current.copyWith(
          isRefreshing: true,
          clearFilterError: true,
        ),
      );
    } else {
      emit(const ProjectTasksListLoading());
    }
    final result = await repository.listProjectTaskGroups(
      workspaceId: workspaceId,
      projectId: projectId,
      query: TaskListQuery(
        status: selectedStatus,
        priority: selectedPriority,
        assigneeCoreUserId: selectedAssigneeCoreUserId,
        myInvolvement: selectedMyInvolvement,
        unassignedOnly: selectedUnassignedOnly,
        pinnedOnly: selectedPinnedOnly,
        savedViewId: savedViewId,
      ).groups(groupBy: groupBy),
    );
    if (isClosed || serial != _requestSerial) return;
    result.fold(
      (error) {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          emit(
            latest.copyWith(
              isRefreshing: false,
              filterError: error.message,
            ),
          );
          return;
        }
        emit(ProjectTasksListFailure(error.message));
      },
      (page) => emit(
        ProjectTasksListReady(
          tasks: [for (final group in page.groups) ...group.items],
          status: selectedStatus,
          priority: selectedPriority,
          assigneeCoreUserId: selectedAssigneeCoreUserId,
          myInvolvement: selectedMyInvolvement,
          unassignedOnly: selectedUnassignedOnly,
          pinnedOnly: selectedPinnedOnly,
          nextCursor: null,
          groups: page.groups,
          totalCount: page.totalCount,
        ),
      ),
    );
  }

  /// Zachowany wyłącznie jako jawne odświeżenie użytkownika/fallback startowy.
  /// Eventy realtime nie mogą go wywoływać, bo zmiana jednej komórki nie może
  /// zerwać scrolla ani spowodować migotania całej tabeli.
  Future<void> refreshFromRealtime() async {
    if (_shouldIgnoreRealtime) {
      _realtimeRefreshPending = true;
      _scheduleDeferredRealtimeRefresh();
      return;
    }
    final current = state;
    if (current is ProjectTasksListReady) {
      // Kanał SignalR przekazuje konkretne mutacje do applyRealtimeMutation.
      // Brak mutacji nie jest uprawnieniem do pełnego GET, bo taki GET niszczy
      // viewport przy normalnej pracy. Jawny refresh użytkownika pozostaje
      // obsługiwany przez load().
      return;
    }
    await load();
  }

  /// Aktualizuje pojedynczy załadowany wiersz z wiadomości SignalR. Pełny
  /// odczyt pozostaje wyłącznie fallbackiem dla mutacji bez lokalnego odpowiednika.
  Future<void> applyRealtimeMutation(TaskRealtimeMutation mutation) async {
    final current = state;
    // Echo własnego PATCH ma wersję, którą lista już dostała w odpowiedzi.
    // Nie wolno odkładać go na 2 s, bo kończyło się to GET /tasks/groups.
    if (current is ProjectTasksListReady &&
        _isRealtimeMutationAlreadyApplied(current, mutation)) {
      return;
    }
    if (_shouldIgnoreRealtime) {
      _realtimeRefreshPending = true;
      _pendingRealtimeMutations.add(mutation);
      _scheduleDeferredRealtimeRefresh();
      return;
    }
    if (current is! ProjectTasksListReady) {
      await load();
      return;
    }
    switch (mutation.type) {
      case TaskRealtimeMutationType.updated:
        final task = current.tasks
            .where((item) => item.id == mutation.taskId)
            .firstOrNull;
        if (task == null || mutation.version <= task.version) return;
        emit(
          _replaceTask(
            current,
            task.copyWith(
              title: mutation.title ?? task.title,
              status: mutation.status ?? task.status,
              priority: mutation.priority ?? task.priority,
              dueAtUtc: mutation.hasDueAtUtc
                  ? mutation.dueAtUtc
                  : task.dueAtUtc,
              version: mutation.version,
              updatedAtUtc: mutation.occurredAtUtc,
            ),
          ),
        );
      case TaskRealtimeMutationType.statusChanged:
      case TaskRealtimeMutationType.kanbanMoved:
      case TaskRealtimeMutationType.kanbanBulkMoved:
      case TaskRealtimeMutationType.kanbanColumnRebalanced:
        if (groupBy == TaskSavedViewGroupBy.status && mutation.status != null) {
          if (_moveLoadedTaskForRealtimeStatus(current, mutation)) {
            return;
          }
        }
        final task = current.tasks
            .where((item) => item.id == mutation.taskId)
            .firstOrNull;
        if (task == null ||
            mutation.status == null ||
            mutation.version <= task.version) {
          return;
        }
        emit(
          _replaceTask(
            current,
            task.copyWith(
              status: mutation.status!,
              version: mutation.version,
              updatedAtUtc: mutation.occurredAtUtc,
            ),
          ),
        );
      case TaskRealtimeMutationType.created:
      case TaskRealtimeMutationType.restored:
        await _appendRealtimeRootTask(mutation);
        return;
      case TaskRealtimeMutationType.archived:
        final task = TaskListSnapshot.findLoadedTask(current, mutation.taskId);
        if (task == null || mutation.version <= task.version) return;
        emit(TaskListSnapshot.removeTask(current, task.id));
        return;
      case TaskRealtimeMutationType.recurrenceChanged:
        return;
    }
  }

  bool _isRealtimeMutationAlreadyApplied(
    ProjectTasksListReady current,
    TaskRealtimeMutation mutation,
  ) {
    final task = TaskListSnapshot.findLoadedTask(current, mutation.taskId);
    return task != null && task.version >= mutation.version;
  }

  /// Nowe albo przywrócone zadanie wymaga pełnej projekcji, aby lokalny reducer
  /// mógł poprawnie sprawdzić filtry i grupę. Pobieramy wyłącznie ten rekord;
  /// nigdy całe `/tasks/groups` ani atrapy pozbawione wykonawców/checklisty.
  Future<void> _appendRealtimeRootTask(TaskRealtimeMutation mutation) async {
    final result = await repository.getTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: mutation.taskId,
    );
    if (isClosed) return;
    result.fold((_) {}, (details) {
      final current = state;
      if (current is! ProjectTasksListReady ||
          TaskListSnapshot.findLoadedTask(current, mutation.taskId) != null ||
          details.task.archivedAtUtc != null ||
          details.task.version < mutation.version) {
        return;
      }
      emit(
        details.task.parentTaskId == null
            ? TaskListSnapshot.appendCreatedRootTask(
                current,
                details.task,
                groupBy: groupBy,
                hasSavedView: savedViewId != null,
              )
            : TaskListSnapshot.appendCreatedSubtaskIfLoaded(
                current,
                details.task,
                hasSavedView: savedViewId != null,
              ),
      );
    });
  }

  bool _moveLoadedTaskForRealtimeStatus(
    ProjectTasksListReady current,
    TaskRealtimeMutation mutation,
  ) {
    final sourceIndex = current.groups.indexWhere(
      (group) => group.items.any((task) => task.id == mutation.taskId),
    );
    final targetKey =
        'status:${mutation.status!.name[0].toUpperCase()}${mutation.status!.name.substring(1)}';
    final targetIndex = current.groups.indexWhere(
      (group) => group.key == targetKey,
    );
    if (sourceIndex < 0 || targetIndex < 0) return false;
    final source = current.groups[sourceIndex];
    final task = source.items.firstWhere((item) => item.id == mutation.taskId);
    if (mutation.version <= task.version) return true;
    final replacement = task.copyWith(
      title: mutation.title ?? task.title,
      priority: mutation.priority ?? task.priority,
      dueAtUtc: mutation.hasDueAtUtc ? mutation.dueAtUtc : task.dueAtUtc,
      status: mutation.status!,
      version: mutation.version,
      updatedAtUtc: mutation.occurredAtUtc,
    );
    if (_inFlightListItemUpdates.containsKey(mutation.taskId)) {
      emit(_replaceTask(current, replacement));
      return true;
    }
    final groups = [...current.groups];
    if (sourceIndex == targetIndex) {
      groups[sourceIndex] = source.copyWith(
        items: [
          for (final item in source.items)
            if (item.id == task.id) replacement else item,
        ],
      );
    } else {
      final target = current.groups[targetIndex];
      groups[sourceIndex] = source.copyWith(
        items: source.items.where((item) => item.id != task.id).toList(),
        totalCount: (source.totalCount - 1).clamp(0, source.totalCount),
      );
      groups[targetIndex] = target.copyWith(
        items: [...target.items, replacement],
        totalCount: target.totalCount + 1,
      );
    }
    emit(
      current.copyWith(
        groups: groups,
        tasks: [for (final group in groups) ...group.items],
      ),
    );
    return true;
  }

  @override
  Future<void> close() {
    _deferredRealtimeTimer?.cancel();
    _pendingRealtimeMutations.clear();
    return super.close();
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ProjectTasksListReady || !current.canLoadMore) return;
    final cursor = current.nextCursor;
    if (cursor == null) return;
    final serial = _requestSerial;
    emit(current.copyWith(isLoadingMore: true, clearMoreError: true));
    final result = await repository.listProjectTasks(
      workspaceId: workspaceId,
      projectId: projectId,
      query: TaskListQuery.fromReady(
        current,
        savedViewId: savedViewId,
      ).listPage(cursor: cursor),
    );
    if (isClosed || serial != _requestSerial) return;
    final latest = state;
    if (latest is! ProjectTasksListReady) return;
    result.fold(
      (error) => emit(
        latest.copyWith(isLoadingMore: false, moreError: error.message),
      ),
      (page) {
        final knownIds = latest.tasks.map((task) => task.id).toSet();
        emit(
          latest.copyWith(
            tasks: [
              ...latest.tasks,
              ...page.items.where((task) => knownIds.add(task.id)),
            ],
            nextCursor: page.nextCursor,
            clearCursor: page.nextCursor == null,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Doładowuje wyłącznie jedną grupę według jej niezależnego kursora.
  Future<void> loadMoreGroup(String groupKey) async {
    final current = state;
    if (current is! ProjectTasksListReady || !_loadingGroupKeys.add(groupKey)) {
      return;
    }
    final group = current.groups
        .where((item) => item.key == groupKey)
        .firstOrNull;
    if (group?.nextCursor == null) {
      _loadingGroupKeys.remove(groupKey);
      return;
    }
    try {
      final result = await repository.listProjectTaskGroups(
        workspaceId: workspaceId,
        projectId: projectId,
        query:
            TaskListQuery.fromReady(
              current,
              savedViewId: savedViewId,
            ).groups(
              groupBy: groupBy,
              groupKey: groupKey,
              cursor: group!.nextCursor,
            ),
      );
      if (isClosed || state is! ProjectTasksListReady) return;
      result.fold(
        (_) {},
        (page) {
          final latest = state as ProjectTasksListReady;
          final latestGroup = latest.groups
              .where((item) => item.key == groupKey)
              .firstOrNull;
          if (latestGroup == null) return;
          final incoming = page.groups.single;
          final knownIds = latestGroup.items.map((item) => item.id).toSet();
          final merged = latestGroup.copyWith(
            items: [
              ...latestGroup.items,
              ...incoming.items.where((item) => knownIds.add(item.id)),
            ],
            nextCursor: incoming.nextCursor,
          );
          emit(
            latest.copyWith(
              groups: [
                for (final item in latest.groups)
                  if (item.key == groupKey) merged else item,
              ],
              tasks: [
                for (final item in latest.groups)
                  if (item.key == groupKey) ...merged.items else ...item.items,
              ],
            ),
          );
        },
      );
    } finally {
      _loadingGroupKeys.remove(groupKey);
    }
  }

  /// Rozwija lub zwija bezpośrednie podzadania bez pobierania całej listy.
  Future<void> toggleSubtasks(ProjectTaskListItemResponse parent) async {
    final current = state;
    if (current is! ProjectTasksListReady || parent.parentTaskId != null) {
      return;
    }
    final parentId = parent.id;
    final expansion = TaskListTreeSnapshot.toggleExpansion(
      current,
      parentId: parentId,
    );
    if (!expansion.shouldLoad) {
      emit(expansion.state);
      return;
    }
    await _loadSubtasks(
      current,
      parentId,
      expandedTaskIds: expansion.expandedTaskIdsForLoad!,
    );
  }

  /// Tworzy jednopoziomowe podzadanie z listy i odświeża wyłącznie gałąź rodzica.
  Future<bool> createSubtask({
    required ProjectTaskListItemResponse parent,
    required String title,
  }) async {
    final current = state;
    final normalized = title.trim();
    if (current is! ProjectTasksListReady ||
        parent.parentTaskId != null ||
        normalized.isEmpty) {
      return false;
    }
    final result = await repository.quickCreateTask(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: QuickCreateProjectTaskPayload(
        title: normalized,
        parentTaskId: parent.id,
        targetStatus: ProjectTaskStatus.todo,
      ),
    );
    if (isClosed) return false;
    return await result.fold(
      (error) async {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          emit(
            latest.copyWith(
              subtaskErrorsByParentId: {
                ...latest.subtaskErrorsByParentId,
                parent.id: error.message,
              },
            ),
          );
        }
        return false;
      },
      (_) async {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          await _loadSubtasks(
            latest,
            parent.id,
            expandedTaskIds: {...latest.expandedTaskIds, parent.id},
            force: true,
          );
        }
        return true;
      },
    );
  }

  /// Doładowuje kolejną stronę bezpośrednich dzieci, zachowując cache gałęzi.
  Future<void> loadMoreSubtasks(ProjectTaskListItemResponse parent) async {
    final current = state;
    final parentId = parent.id;
    if (current is! ProjectTasksListReady ||
        !current.expandedTaskIds.contains(parentId) ||
        current.loadingSubtaskParentIds.contains(parentId)) {
      return;
    }
    final cursor = current.nextSubtaskCursorByParentId[parentId];
    if (cursor == null) return;
    await _loadSubtasks(
      current,
      parentId,
      expandedTaskIds: current.expandedTaskIds,
      cursor: cursor,
    );
  }

  /// Tworzy zadanie główne bez przeładowywania bieżącej listy.
  ///
  /// Backend zwraca pełną projekcję nowego zadania, którą składamy do lekkiego
  /// rekordu tabeli i dopisujemy tylko do jego załadowanej grupy. Dzięki temu
  /// wpisanie zadania nie resetuje scrolla, rozwiniętych podzadań ani filtrów.
  Future<bool> createRootTask({
    required String title,
    required ProjectTaskStatus status,
    TaskPriority priority = TaskPriority.normal,
    String? customStatusId,
  }) async {
    final current = state;
    final normalized = title.trim();
    if (current is! ProjectTasksListReady || normalized.isEmpty) return false;
    final result = await repository.quickCreateTask(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: QuickCreateProjectTaskPayload(
        title: normalized,
        targetStatus: customStatusId == null ? status : null,
        customStatusId: customStatusId,
      ),
    );
    if (isClosed) return false;
    return await result.fold(
      (_) => false,
      (mutation) async {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          emit(
            TaskListSnapshot.appendCreatedRootTask(
              latest,
              mutation.data,
              groupBy: groupBy,
              hasSavedView: savedViewId != null,
            ),
          );
        }
        return true;
      },
    );
  }

  /// Aktualizuje tytuł zadania optymistycznie i wysyła zmianę do backendu.
  Future<bool> updateTitle(
    ProjectTaskListItemResponse task,
    String newTitle,
  ) async {
    final trimmed = newTitle.trim();
    if (trimmed.isEmpty || trimmed == task.title) return false;
    return updateListItem(
      task: task,
      payload: UpdateTaskListItemPayload(
        title: trimmed,
        expectedVersion: task.version,
      ),
    );
  }

  /// Aktualizuje stan licznika checklisty dla zadania w lokalnym widoku listy.
  void updateChecklistCounts({
    required String taskId,
    required int completedCount,
    required int totalCount,
    int? newVersion,
  }) {
    final current = state;
    if (current is! ProjectTasksListReady) return;
    final task = TaskListSnapshot.findLoadedTask(current, taskId);
    if (task == null) return;
    final updated = task.copyWith(
      checklistCompletedCount: completedCount,
      checklistTotalCount: totalCount,
      version: newVersion ?? task.version,
    );
    emit(TaskListSnapshot.replaceTask(current, updated, groupBy: groupBy));
  }

  /// Zapisuje pojedynczą komórkę listy optymistycznie i przywraca ją po błędzie.
  Future<bool> updateListItem({
    required ProjectTaskListItemResponse task,
    required UpdateTaskListItemPayload payload,
  }) async {
    final inFlight = _inFlightListItemUpdates[task.id];
    if (inFlight != null) {
      // Szybka druga zmiana nie może wysłać starego expectedVersion.
      final previousSucceeded = await inFlight;
      if (!previousSucceeded || isClosed) return false;
      final current = state;
      final latest = current is ProjectTasksListReady
          ? TaskListSnapshot.findLoadedTask(current, task.id)
          : null;
      if (latest == null) return false;
      return updateListItem(
        task: latest,
        payload: payload.copyWith(expectedVersion: latest.version),
      );
    }
    late final Future<bool> future;
    future = _updateListItemNow(task: task, payload: payload).whenComplete(() {
      if (identical(_inFlightListItemUpdates[task.id], future)) {
        final removed = _inFlightListItemUpdates.remove(task.id);
        // [removed] jest właśnie kończącą się future; nie czekamy na nią
        // ponownie wewnątrz jej własnego whenComplete.
        assert(removed != null, 'Zakończona mutacja musi istnieć w kolejce.');
      }
    });
    _inFlightListItemUpdates[task.id] = future;
    return future;
  }

  Future<bool> _updateListItemNow({
    required ProjectTaskListItemResponse task,
    required UpdateTaskListItemPayload payload,
  }) async {
    final current = state;
    if (current is! ProjectTasksListReady ||
        task.version != payload.expectedVersion) {
      return false;
    }
    final optimistic = task.copyWith(
      title: payload.title ?? task.title,
      status: payload.status ?? task.status,
      priority: payload.priority ?? task.priority,
      startAtUtc: payload.clearStartAtUtc
          ? null
          : payload.startAtUtc ?? task.startAtUtc,
      dueAtUtc: payload.clearDueAtUtc
          ? null
          : payload.dueAtUtc ?? task.dueAtUtc,
      taskType: payload.taskType ?? task.taskType,
      size: payload.clearSize ? null : payload.size ?? task.size,
      complexity: payload.clearComplexity
          ? null
          : payload.complexity ?? task.complexity,
      risk: payload.clearRisk ? null : payload.risk ?? task.risk,
      businessValue: payload.clearBusinessValue
          ? null
          : payload.businessValue ?? task.businessValue,
      estimatedMinutes: payload.clearEstimatedMinutes
          ? null
          : payload.estimatedMinutes ?? task.estimatedMinutes,
    );
    emit(_replaceTask(current, optimistic));
    _beginLocalMutation();
    try {
      final result = await repository.updateListItem(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: task.id,
        payload: payload,
      );
      if (isClosed) return false;
      final latest = state;
      if (latest is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          final taskAfterFailure = error.type == ApiErrorType.conflict
              ? optimistic
              : task;
          emit(
            _replaceTask(
              latest,
              taskAfterFailure,
              errorForTaskId: task.id,
              error: error.type == ApiErrorType.conflict
                  ? 'Zadanie zmienił inny użytkownik. Odśwież je świadomie, aby porównać zmiany.'
                  : error.message,
            ),
          );
          return false;
        },
        (mutation) {
          // PATCH /list-item nie zmienia osobistego przypięcia ani relacji
          // obserwowania. Zachowujemy bieżący snapshot tych pól, aby nawet
          // starsza/niepełna odpowiedź backendu po zmianie statusu nie
          // zgasiła ikonek wiersza przed następnym odczytem listy.
          final currentTask =
              TaskListSnapshot.findLoadedTask(latest, task.id) ?? optimistic;
          final confirmed = mutation.data.copyWith(
            isPinned: currentTask.isPinned,
            watcherCount: currentTask.watcherCount,
            isWatchedByMe: currentTask.isWatchedByMe,
          );
          emit(_replaceTask(latest, confirmed));
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }

  /// Przenosi element względem sąsiadów, optymistycznie aktualizując wyłącznie
  /// załadowane grupy. Backend pozostaje źródłem prawdy dla pozycji i relacji.
  Future<bool> moveTask({
    required ProjectTaskListItemResponse task,
    required String targetGroupKey,
    String? previousTaskId,
    String? nextTaskId,
    String? parentTaskId,
  }) async {
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    final target = current.groups.where((group) => group.key == targetGroupKey);
    if (target.isEmpty) return false;
    final targetGroup = target.first;
    final isUnassignedCustomStatus =
        parentTaskId == null &&
        taskListIsUnassignedCustomStatusGroup(targetGroupKey);
    final customStatusId = parentTaskId == null
        ? taskListCustomStatusIdForGroup(targetGroupKey)
        : null;
    final status = parentTaskId == null && customStatusId == null
        ? (isUnassignedCustomStatus
              ? task.status
              : taskListStatusForGroup(targetGroupKey))
        : null;
    final optimistic = task.copyWith(
      parentTaskId: parentTaskId,
      status: status ?? task.status,
      customStatusId: customStatusId ?? task.customStatusId,
      customStatusName: customStatusId == null
          ? task.customStatusName
          : targetGroup.displayName,
      customStatusColor: customStatusId == null
          ? task.customStatusColor
          : targetGroup.color,
    );
    final snapshot = current;
    final removedGroups = [
      for (final group in current.groups)
        group.copyWith(
          items: group.items.where((item) => item.id != task.id).toList(),
        ),
    ];
    final subtasks = {
      for (final entry in current.subtasksByParentId.entries)
        entry.key: entry.value.where((item) => item.id != task.id).toList(),
    };
    if (parentTaskId == null) {
      final targetIndex = removedGroups.indexWhere(
        (group) => group.key == targetGroupKey,
      );
      final targetItems = [...removedGroups[targetIndex].items];
      final before = nextTaskId == null
          ? targetItems.length
          : targetItems.indexWhere((item) => item.id == nextTaskId);
      targetItems.insert(before < 0 ? targetItems.length : before, optimistic);
      removedGroups[targetIndex] = removedGroups[targetIndex].copyWith(
        items: targetItems,
      );
    } else {
      final targetItems = <ProjectTaskListItemResponse>[
        ...(subtasks[parentTaskId] ?? const <ProjectTaskListItemResponse>[]),
      ];
      final before = nextTaskId == null
          ? targetItems.length
          : targetItems.indexWhere((item) => item.id == nextTaskId);
      targetItems.insert(before < 0 ? targetItems.length : before, optimistic);
      subtasks[parentTaskId] = targetItems;
    }
    emit(
      current.copyWith(
        groups: removedGroups,
        tasks: [for (final group in removedGroups) ...group.items],
        subtasksByParentId: subtasks,
      ),
    );
    _suppressRealtimeForLocalMutation();
    final result = await repository.moveTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: task.id,
      payload: MoveProjectTaskPayload(
        expectedVersion: task.version,
        parentTaskId: parentTaskId,
        previousTaskId: previousTaskId,
        nextTaskId: nextTaskId,
        status: status,
        customStatusId: customStatusId,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(
          snapshot.copyWith(
            taskErrorsByTaskId: {
              ...snapshot.taskErrorsByTaskId,
              task.id: error.message,
            },
          ),
        );
        return false;
      },
      (moved) {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          emit(
            _replaceTask(
              latest,
              optimistic.copyWith(
                version: moved.version,
                updatedAtUtc: moved.updatedAtUtc,
                parentTaskId: moved.parentTaskId,
                status: moved.status,
                customStatusId: moved.customStatusId,
              ),
            ),
          );
        }
        return true;
      },
    );
  }

  /// Wstrzymuje albo wznawia serię bez przeładowania listy.
  Future<bool> toggleRecurrence(ProjectTaskListItemResponse task) async {
    final current = state;
    final repository = recurrenceRepository;
    final recurrence = task.recurrence;
    if (current is! ProjectTasksListReady ||
        repository == null ||
        recurrence == null) {
      return false;
    }
    final optimistic = task.copyWith(
      recurrence: recurrence.copyWith(isActive: !recurrence.isActive),
    );
    emit(_replaceTask(current, optimistic));
    _suppressRealtimeForLocalMutation();
    final result = recurrence.isActive
        ? await repository.pause(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: task.id,
            expectedVersion: recurrence.version,
          )
        : await repository.resume(
            workspaceId: workspaceId,
            projectId: projectId,
            taskId: task.id,
            expectedVersion: recurrence.version,
          );
    if (isClosed) return false;
    final latest = state;
    if (latest is! ProjectTasksListReady) return false;
    return result.fold(
      (error) {
        emit(
          _replaceTask(
            latest,
            task,
            errorForTaskId: task.id,
            error: error.message,
          ),
        );
        return false;
      },
      (mutation) {
        final value = mutation.data;
        emit(
          _replaceTask(
            latest,
            task.copyWith(
              version: mutation.taskVersion,
              updatedAtUtc: mutation.taskUpdatedAtUtc,
              recurrence: value.toSummary(taskId: task.id),
            ),
          ),
        );
        return true;
      },
    );
  }

  /// Przyjmuje potwierdzoną pełną regułę z zakotwiczonego edytora i podmienia
  /// wyłącznie ten wiersz; edytor nie powoduje ponownego pobrania grup.
  void applyRecurrenceMutation(
    ProjectTaskListItemResponse task,
    TaskMutationResponse<TaskRecurrenceResponse> mutation,
  ) {
    final current = state;
    if (current is! ProjectTasksListReady || isClosed) return;
    final value = mutation.data;
    final latestTask =
        TaskListSnapshot.findLoadedTask(current, task.id) ?? task;
    emit(
      _replaceTask(
        current,
        latestTask.copyWith(
          version: mutation.taskVersion,
          updatedAtUtc: mutation.taskUpdatedAtUtc,
          recurrence: value.toSummary(taskId: latestTask.id),
        ),
      ),
    );
    _suppressRealtimeForLocalMutation();
  }

  /// Zapisuje wszystkie wartości własne zadania, utrzymując wersję i rollback
  /// pojedynczego wiersza w tej samej ścieżce co pozostałe komórki listy.
  Future<bool> updateCustomField({
    required ProjectTaskListItemResponse task,
    required String fieldId,
    required Object? value,
  }) async {
    final current = state;
    final metadata = metadataRepository;
    if (current is! ProjectTasksListReady || metadata == null) return false;
    final values = <String, Object>{
      for (final item in task.customFields)
        if (item.value != null && item.fieldId != fieldId)
          item.fieldId: item.value!,
      if (value != null && (value is! String || value.trim().isNotEmpty))
        fieldId: value,
    };
    final optimistic = task.copyWith(
      customFields: [
        for (final item in task.customFields)
          if (item.fieldId == fieldId)
            if (value != null) item.copyWith(value: value) else null
          else
            item,
        if (value != null &&
            !task.customFields.any((item) => item.fieldId == fieldId))
          TaskCustomFieldValueResponse(
            fieldId: fieldId,
            value: value,
            updatedAtUtc: DateTime.now().toUtc(),
          ),
      ].whereType<TaskCustomFieldValueResponse>().toList(growable: false),
    );
    emit(_replaceTask(current, optimistic));
    _suppressRealtimeForLocalMutation();
    final result = await metadata.replaceCustomFieldValues(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: task.id,
      payload: ReplaceTaskCustomFieldValuesPayload(
        values: values,
        expectedVersion: task.version,
      ),
    );
    if (isClosed) return false;
    final latest = state;
    if (latest is! ProjectTasksListReady) return false;
    return result.fold(
      (error) {
        emit(
          _replaceTask(
            latest,
            task,
            errorForTaskId: task.id,
            error: error.message,
          ),
        );
        return false;
      },
      (mutation) {
        emit(
          _replaceTask(
            latest,
            task.copyWith(
              customFields: mutation.data,
              version: mutation.taskVersion,
              updatedAtUtc: mutation.taskUpdatedAtUtc,
            ),
          ),
        );
        return true;
      },
    );
  }

  /// Zaznacza rekord albo zakres pomiędzy aktywnym anchor i rekordem klikniętym.
  void toggleSelection(String taskId, {bool range = false}) {
    final current = state;
    if (current is! ProjectTasksListReady) return;
    // Rozwinięte podzadania są pełnoprawnymi wierszami listy. Nie mogą
    // wyglądać jak zaznaczalne, a następnie znikać z bulk toolbaru tylko
    // dlatego, że ich cache nie należy do płaskiego `tasks` grup głównych.
    final ids = TaskListSnapshot.allLoadedTasks(current)
        .map((task) => task.id)
        .toList();
    if (!ids.contains(taskId)) return;
    emit(
      current.copyWith(
        selectedTaskIds: TaskListSelection.toggle(
          selectedIds: current.selectedTaskIds,
          orderedScopeIds: ids,
          taskId: taskId,
          anchorTaskId: current.selectionAnchorTaskId,
          range: range,
        ),
        selectionAnchorTaskId: taskId,
      ),
    );
  }

  void selectLoadedTasks() {
    final current = state;
    if (current is ProjectTasksListReady) {
      emit(
        current.copyWith(
          selectedTaskIds: TaskListSnapshot.allLoadedTasks(current)
              .map((task) => task.id)
              .toSet(),
        ),
      );
    }
  }

  bool isLoadedGroupSelected(String groupKey) {
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    return TaskListSelection.containsAll(
      current.selectedTaskIds,
      TaskListSnapshot.loadedGroupTaskIds(current, groupKey),
    );
  }

  void setLoadedGroupSelected(String groupKey, {required bool selected}) {
    final current = state;
    if (current is! ProjectTasksListReady) return;
    emit(
      current.copyWith(
        selectedTaskIds: TaskListSelection.setScope(
          selectedIds: current.selectedTaskIds,
          scopeIds: TaskListSnapshot.loadedGroupTaskIds(current, groupKey),
          selected: selected,
        ),
        clearSelectionAnchor: true,
      ),
    );
  }

  bool areLoadedSubtasksSelected(String parentTaskId) {
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    return TaskListSelection.containsAll(
      current.selectedTaskIds,
      TaskListSnapshot.loadedSubtaskIds(current, parentTaskId),
    );
  }

  void setLoadedSubtasksSelected(
    String parentTaskId, {
    required bool selected,
  }) {
    final current = state;
    if (current is! ProjectTasksListReady) return;
    emit(
      current.copyWith(
        selectedTaskIds: TaskListSelection.setScope(
          selectedIds: current.selectedTaskIds,
          scopeIds: TaskListSnapshot.loadedSubtaskIds(current, parentTaskId),
          selected: selected,
        ),
        clearSelectionAnchor: true,
      ),
    );
  }

  void clearSelection() {
    final current = state;
    if (current is ProjectTasksListReady) {
      emit(
        current.copyWith(selectedTaskIds: const {}, clearSelectionAnchor: true),
      );
    }
  }

  /// Wykonuje identyczną, wersjonowaną mutację dla aktualnie zaznaczonych
  /// rekordów. Do czasu wdrożenia tokenu selekcji backend pozostaje to celowo
  /// ograniczone do rekordów obecnych w lokalnym snapshotie listy.
  Future<int> bulkUpdateSelected({
    ProjectTaskStatus? status,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    bool clearDueAtUtc = false,
    List<String>? assigneeIds,
    bool archive = false,
  }) async {
    final initial = state;
    if (initial is! ProjectTasksListReady || initial.selectedTaskIds.isEmpty) {
      return 0;
    }
    final tasks = TaskListSnapshot.allLoadedTasks(initial)
        .where((task) => initial.selectedTaskIds.contains(task.id))
        .toList(growable: false);
    var updatedCount = 0;
    for (final task in tasks) {
      final saved = archive
          ? await archiveLoadedTask(task)
          : assigneeIds != null
          ? await replaceAssigneesForLoadedTask(task, assigneeIds)
          : await updateListItem(
              task: task,
              payload: UpdateTaskListItemPayload(
                status: status,
                priority: priority,
                dueAtUtc: dueAtUtc,
                clearDueAtUtc: clearDueAtUtc,
                expectedVersion: task.version,
              ),
            );
      if (saved) updatedCount++;
    }
    // Każda udana operacja zaktualizowała już lokalny snapshot. Czyszczenie
    // zaznaczenia nie może zamieniać szybkiej akcji bulk w pełny reload listy.
    final latest = state;
    if (!isClosed && latest is ProjectTasksListReady) {
      emit(
        latest.copyWith(
          selectedTaskIds: const {},
          clearSelectionAnchor: true,
        ),
      );
    }
    return updatedCount;
  }

  /// Wykonuje zmianę na całym wyniku aktywnych filtrów przez token backendu.
  /// Klient nie materializuje identyfikatorów niezaładowanych stron.
  Future<int> bulkUpdateEntireResult({
    ProjectTaskStatus? status,
    String? customStatusId,
    bool clearCustomStatus = false,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    bool clearDueAtUtc = false,
    List<String>? assigneeIds,
    bool archive = false,
  }) async {
    final current = state;
    if (current is! ProjectTasksListReady) return 0;
    final loadedTaskIds = TaskListSnapshot.allLoadedTasks(current)
        .map((task) => task.id)
        .toList(growable: false);
    final tokenResult = await repository.createTaskSelectionToken(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: CreateTaskSelectionTokenPayload(
        query: TaskListQuery.fromReady(
          current,
          savedViewId: savedViewId,
        ).selectionTokenPayload(),
      ),
    );
    if (isClosed) return 0;
    return tokenResult.fold((_) => 0, (token) async {
      final result = await repository.bulkUpdateTaskSelection(
        workspaceId: workspaceId,
        projectId: projectId,
        payload: BulkUpdateTaskSelectionPayload(
          selectionToken: token.token,
          status: status,
          customStatusId: customStatusId,
          clearCustomStatus: clearCustomStatus,
          priority: priority,
          dueAtUtc: dueAtUtc,
          clearDueAtUtc: clearDueAtUtc,
          assigneeIds: assigneeIds,
          archive: archive,
          returnTaskIds: loadedTaskIds,
        ),
      );
      if (isClosed) return 0;
      return result.fold((_) => 0, (response) {
        final latest = state;
        if (latest is ProjectTasksListReady) {
          emit(
            TaskListSnapshot.applyBulkMutation(
              latest,
              response.updatedTasks,
              groupBy: groupBy,
              status: status,
              customStatusId: customStatusId,
              clearCustomStatus: clearCustomStatus,
              priority: priority,
              dueAtUtc: dueAtUtc,
              clearDueAtUtc: clearDueAtUtc,
              assigneeIds: assigneeIds,
              archive: archive,
            ),
          );
        }
        return response.updatedCount;
      });
    });
  }

  ProjectTasksListReady _replaceTask(
    ProjectTasksListReady state,
    ProjectTaskListItemResponse replacement, {
    String? errorForTaskId,
    String? error,
  }) => TaskListSnapshot.replaceTask(
    state,
    replacement,
    groupBy: groupBy,
    errorForTaskId: errorForTaskId,
    error: error,
  );

  /// Archiwizuje wyłącznie załadowany rekord i usuwa go z lokalnego snapshotu
  /// po potwierdzeniu serwera. Błąd pozostawia wiersz na miejscu z komunikatem,
  /// dzięki czemu użytkownik nie traci kontekstu. Jest używane przez bulk toolbar
  /// i menu kontekstowe pojedynczego wiersza.
  Future<bool> archiveLoadedTask(ProjectTaskListItemResponse task) async {
    final result = await repository.archiveTask(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: task.id,
      expectedVersion: task.version,
    );
    if (isClosed) return false;
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    return result.fold(
      (error) {
        emit(
          current.copyWith(
            taskErrorsByTaskId: {
              ...current.taskErrorsByTaskId,
              task.id: error.message,
            },
          ),
        );
        return false;
      },
      (_) {
        final sourceIndex = current.groups.indexWhere(
          (group) => group.items.any((item) => item.id == task.id),
        );
        emit(TaskListSnapshot.removeTask(current, task.id));
        // Zadanie może być załadowanym podzadaniem, wtedy nie jest w grupie,
        // lecz znika wyłącznie z cache'u swojej gałęzi powyżej.
        assert(
          sourceIndex >= 0 || task.parentTaskId != null,
          'Aktywne zadanie musi należeć do grupy lub do cache podzadań.',
        );
        return true;
      },
    );
  }

  /// Zastępuje ownera i współpracowników jednego już załadowanego zadania.
  /// Pierwsza osoba jest ownerem, kolejne są współpracownikami — dokładnie jak
  /// w kontrakcie `PUT /assignees`. Odpowiedź podmienia wyłącznie ten wiersz.
  Future<bool> replaceAssigneesForLoadedTask(
    ProjectTaskListItemResponse task,
    List<String> coreUserIds,
  ) async {
    final collaboration = collaborationRepository;
    if (collaboration == null) return false;
    _beginLocalMutation();
    try {
      final result = await collaboration.replaceAssignees(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: task.id,
        coreUserIds: coreUserIds,
        expectedVersion: task.version,
      );
      if (isClosed) return false;
      final current = state;
      if (current is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          emit(
            _replaceTask(
              current,
              task,
              errorForTaskId: task.id,
              error: error.message,
            ),
          );
          return false;
        },
        (mutation) {
          emit(
            _replaceTask(
              current,
              task.copyWith(
                assignees: mutation.data.assignees,
                version: mutation.taskVersion,
                updatedAtUtc: mutation.taskUpdatedAtUtc,
              ),
            ),
          );
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }

  /// Zmienia osobiste przypięcie bez pobierania pełnego detailu. Przypięcie
  /// nie jest wersją domenowego taska, dlatego endpoint nie zwraca nowej
  /// wersji; lokalnie podmieniamy wyłącznie `isPinned` tego wiersza.
  Future<bool> setPinnedForLoadedTask(
    ProjectTaskListItemResponse task,
    bool isPinned,
  ) async {
    final collaboration = collaborationRepository;
    if (collaboration == null) return false;
    _beginLocalMutation();
    try {
      final result = await collaboration.updatePinned(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: task.id,
        isPinned: isPinned,
      );
      if (isClosed) return false;
      final current = state;
      if (current is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          emit(
            _replaceTask(
              current,
              task,
              errorForTaskId: task.id,
              error: error.message,
            ),
          );
          return false;
        },
        (_) {
          emit(_replaceTask(current, task.copyWith(isPinned: isPinned)));
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }

  /// Obserwowanie jest relacją bieżącego użytkownika z zadaniem. Odpowiedź
  /// zwraca nową wersję, więc lokalny licznik i stan „obserwuję” mogą zostać
  /// podmienione bez pobierania szczegółów taska.
  Future<bool> toggleWatchingForLoadedTask(
    ProjectTaskListItemResponse task,
  ) async {
    final collaboration = collaborationRepository;
    if (collaboration == null) return false;
    _beginLocalMutation();
    try {
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
      if (isClosed) return false;
      final current = state;
      if (current is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          emit(
            _replaceTask(
              current,
              task,
              errorForTaskId: task.id,
              error: error.message,
            ),
          );
          return false;
        },
        (mutation) {
          final watching = !task.isWatchedByMe;
          emit(
            _replaceTask(
              current,
              task.copyWith(
                isWatchedByMe: watching,
                watcherCount: watching
                    ? task.watcherCount + 1
                    : (task.watcherCount - 1).clamp(0, task.watcherCount),
                version: mutation.taskVersion,
                updatedAtUtc: mutation.taskUpdatedAtUtc,
              ),
            ),
          );
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }

  /// Atomowo zastępupuje etykiety jednego wiersza. Odpowiedź endpointu zawiera
  /// pełny, znormalizowany zestaw etykiet oraz nową wersję zadania.
  Future<bool> replaceLabelsForLoadedTask(
    ProjectTaskListItemResponse task,
    List<String> labelIds,
  ) async {
    final metadata = metadataRepository;
    if (metadata == null) return false;
    final current = state;
    if (current is! ProjectTasksListReady) return false;
    final liveTask =
        current.tasks.cast<ProjectTaskListItemResponse?>().firstWhere(
          (t) => t?.id == task.id,
          orElse: () => task,
        ) ??
        task;
    _beginLocalMutation();
    try {
      final result = await metadata.replaceLabels(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: liveTask.id,
        payload: ReplaceTaskLabelsPayload(
          labelIds: labelIds,
          expectedVersion: liveTask.version,
        ),
      );
      if (isClosed) return false;
      final latest = state;
      if (latest is! ProjectTasksListReady) return false;
      return await result.fold(
        (error) {
          emit(
            _replaceTask(
              latest,
              liveTask,
              errorForTaskId: liveTask.id,
              error: error.message,
            ),
          );
          return false;
        },
        (mutation) {
          emit(
            _replaceTask(
              latest,
              liveTask.copyWith(
                labels: mutation.data,
                version: mutation.taskVersion,
                updatedAtUtc: mutation.taskUpdatedAtUtc,
              ),
            ),
          );
          return true;
        },
      );
    } finally {
      _endLocalMutation();
    }
  }

  Future<void> _loadSubtasks(
    ProjectTasksListReady current,
    String parentId, {
    required Set<String> expandedTaskIds,
    bool force = false,
    String? cursor,
  }) async {
    if (current.loadingSubtaskParentIds.contains(parentId)) return;
    if (!force &&
        cursor == null &&
        current.subtasksByParentId.containsKey(parentId)) {
      return;
    }
    emit(
      TaskListTreeSnapshot.startLoading(
        current,
        parentId: parentId,
        expandedTaskIds: expandedTaskIds,
      ),
    );
    final result = await repository.listProjectTasks(
      workspaceId: workspaceId,
      projectId: projectId,
      query: TaskListQuery.fromReady(
        current,
        savedViewId: savedViewId,
      ).listPage(cursor: cursor, parentTaskId: parentId),
    );
    if (isClosed) return;
    final latest = state;
    if (latest is! ProjectTasksListReady) return;
    result.fold(
      (error) => emit(
        TaskListTreeSnapshot.loadFailed(
          latest,
          parentId: parentId,
          message: error.message,
        ),
      ),
      (page) => emit(
        TaskListTreeSnapshot.mergePage(
          latest,
          parentId: parentId,
          items: page.items,
          nextCursor: page.nextCursor,
          append: cursor != null,
        ),
      ),
    );
  }
}
