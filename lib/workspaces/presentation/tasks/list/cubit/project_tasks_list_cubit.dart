// Mixin host exposes private coordination fields through its internal port.
// They are consumed by the part files, so the analyzer cannot always see the
// cross-part reference.
// ignore_for_file: unused_element

import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/task_list_query.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/task_list_selection.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/task_list_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/task_list_tree_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/task_list_grouping.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/task_recurrence_summary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'project_tasks_list_state.dart';

part 'task_list_realtime_mixin.dart';
part 'task_list_loading_mixin.dart';
part 'task_list_creation_mixin.dart';
part 'task_list_mutation_mixin.dart';
part 'task_list_selection_mixin.dart';
part 'task_list_item_mutation_mixin.dart';
part 'task_list_subtasks_mixin.dart';

/// Kontrakt operacji listy. Cubit pozostaje tylko właścicielem strumienia stanu;
/// cięższe przypadki użycia są zgrupowane w osobnych, testowalnych mixinach.
abstract interface class ProjectTasksListCubitPort {
  ProjectTasksListState get state;
  bool get isClosed;
  void emit(ProjectTasksListState state);
  TasksRepository get repository;
  TaskMetadataRepository? get metadataRepository;
  TaskCollaborationRepository? get collaborationRepository;
  TaskRecurrenceRepository? get recurrenceRepository;
  String get workspaceId;
  String get projectId;
  String? get savedViewId;
  TaskSavedViewGroupBy get groupBy;
  int get _requestSerial;
  set _requestSerial(int value);
  int get _localMutationDepth;
  DateTime? get _realtimeSuppressedUntil;
  set _realtimeSuppressedUntil(DateTime? value);
  Timer? get _deferredRealtimeTimer;
  set _deferredRealtimeTimer(Timer? value);
  bool get _realtimeRefreshPending;
  set _realtimeRefreshPending(bool value);
  List<TaskRealtimeMutation> get _pendingRealtimeMutations;
  Map<String, Future<bool>> get _inFlightListItemUpdates;
  Set<String> get _loadingGroupKeys;
  bool get _rootTaskCreationInFlight;
  set _rootTaskCreationInFlight(bool value);
  bool get _shouldIgnoreRealtime;
  void _beginLocalMutation();
  void _endLocalMutation();
  void _suppressRealtimeForLocalMutation();
  void _scheduleDeferredRealtimeRefresh();
  Future<void> _loadSubtasks(
    ProjectTasksListReady current,
    String parentId, {
    required Set<String> expandedTaskIds,
    bool force = false,
    String? cursor,
  });
  ProjectTasksListReady _replaceTask(
    ProjectTasksListReady state,
    ProjectTaskListItemResponse replacement, {
    String? errorForTaskId,
    String? error,
  });
}

/// Bazowa implementacja wyłącznie po to, aby mixiny operacji miały jawny
/// kontrakt hosta bez wiązania ich z konkretnym Cubitem.
abstract class ProjectTasksListCubitBase extends Cubit<ProjectTasksListState>
    implements ProjectTasksListCubitPort {
  ProjectTasksListCubitBase(super.initialState);
}

/// Wynik utworzenia zadania z listy, zachowujący typowany błąd transportu.
sealed class ProjectTaskCreationResult {
  const ProjectTaskCreationResult();
}

/// Potwierdzone przez backend utworzenie zadania.
final class ProjectTaskCreationSuccess extends ProjectTaskCreationResult {
  const ProjectTaskCreationSuccess();
}

/// Odrzucona próba utworzenia zadania.
final class ProjectTaskCreationFailure extends ProjectTaskCreationResult {
  const ProjectTaskCreationFailure({
    this.error,
    this.reason = ProjectTaskCreationFailureReason.api,
  });

  final ApiError? error;
  final ProjectTaskCreationFailureReason reason;
}

/// Lokalny powód odrzucenia próby przed wysłaniem lub poza gotowym snapshotem.
enum ProjectTaskCreationFailureReason {
  api,
  invalidTitle,
  duplicateSubmission,
  listNotReady,
}

/// Cursorowa lista zadań projektu z filtrami obsługiwanymi przez backend.
final class ProjectTasksListCubit extends ProjectTasksListCubitBase
    with
        TaskListRealtimeMixin,
        TaskListLoadingMixin,
        TaskListCreationMixin,
        TaskListMutationMixin,
        TaskListSelectionMixin,
        TaskListItemMutationMixin,
        TaskListSubtasksMixin {
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

  @override
  final TasksRepository repository;
  @override
  final TaskMetadataRepository? metadataRepository;
  @override
  final TaskCollaborationRepository? collaborationRepository;
  @override
  final TaskRecurrenceRepository? recurrenceRepository;
  @override
  final String workspaceId;
  @override
  final String projectId;
  @override
  final String? savedViewId;
  TaskSavedViewGroupBy _groupBy;

  /// Aktualny sposób grupowania listy zadań.
  @override
  TaskSavedViewGroupBy get groupBy => _groupBy;

  /// Aktualizuje sposób grupowania listy zadań i przeładowuje dane.
  Future<void> updateGroupBy(TaskSavedViewGroupBy newGroupBy) async {
    if (_groupBy == newGroupBy && state is ProjectTasksListReady) return;
    _groupBy = newGroupBy;
    await load();
  }

  @override
  int _requestSerial = 0;
  @override
  int _localMutationDepth = 0;
  @override
  DateTime? _realtimeSuppressedUntil;
  @override
  Timer? _deferredRealtimeTimer;
  @override
  bool _realtimeRefreshPending = false;
  @override
  final List<TaskRealtimeMutation> _pendingRealtimeMutations = [];
  @override
  final Map<String, Future<bool>> _inFlightListItemUpdates = {};
  @override
  final Set<String> _loadingGroupKeys = {};
  @override
  bool _rootTaskCreationInFlight = false;

  @override
  bool get _shouldIgnoreRealtime {
    if (_localMutationDepth > 0) return true;
    final until = _realtimeSuppressedUntil;
    return until != null && until.isAfter(DateTime.now());
  }

  @override
  void _beginLocalMutation() => _localMutationDepth++;

  @override
  void _endLocalMutation() {
    _localMutationDepth = (_localMutationDepth - 1).clamp(0, 1 << 20);
    if (_realtimeRefreshPending) _scheduleDeferredRealtimeRefresh();
  }

  @override
  void _suppressRealtimeForLocalMutation() {
    // Odpowiedź mutacji zawiera już świeży snapshot wiersza. Nie zakładamy
    // sztucznego, dwusekundowego okna ciszy — było ono przyczyną widocznego
    // pełnego przeładowania listy po edycji pojedynczej komórki.
    _realtimeSuppressedUntil = null;
    if (_realtimeRefreshPending) _scheduleDeferredRealtimeRefresh();
  }

  @override
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

  @override
  Future<void> load({
    ProjectTaskStatus? status,
    TaskPriority? priority,
    String? assigneeUserId,
    TaskInvolvementFilter? myInvolvement,
    bool? unassignedOnly,
    bool? pinnedOnly,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearAssigneeUserId = false,
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
    final selectedAssigneeUserId = clearAssigneeUserId
        ? null
        : assigneeUserId ??
              (current is ProjectTasksListReady
                  ? current.assigneeUserId
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
        assigneeUserId: selectedAssigneeUserId,
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
        emit(
          ProjectTasksListFailure(
            error.message,
            type: error.type,
            statusCode: error.statusCode,
            backendCode: error.backendCode,
            apiCode: error.apiCode,
            traceId: error.traceId,
          ),
        );
      },
      (page) => emit(
        ProjectTasksListReady(
          tasks: [for (final group in page.groups) ...group.items],
          status: selectedStatus,
          priority: selectedPriority,
          assigneeUserId: selectedAssigneeUserId,
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

  @override
  Future<void> close() {
    _deferredRealtimeTimer?.cancel();
    _pendingRealtimeMutations.clear();
    return super.close();
  }

  @override
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
}
