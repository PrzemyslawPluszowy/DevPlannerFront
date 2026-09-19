import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';

sealed class ProjectTasksListState {
  const ProjectTasksListState();
}

final class ProjectTasksListLoading extends ProjectTasksListState {
  const ProjectTasksListLoading();
}

final class ProjectTasksListFailure extends ProjectTasksListState {
  const ProjectTasksListFailure(
    this.message, {
    this.type,
    this.statusCode,
    this.backendCode,
    this.apiCode,
    this.traceId,
  });

  final String message;
  final ApiErrorType? type;
  final int? statusCode;
  final int? backendCode;
  final String? apiCode;
  final String? traceId;

  bool get isForbidden => type == ApiErrorType.forbidden || statusCode == 403;
}

final class ProjectTasksListReady extends ProjectTasksListState {
  const ProjectTasksListReady({
    required this.tasks,
    required this.status,
    required this.priority,
    required this.assigneeUserId,
    required this.myInvolvement,
    required this.unassignedOnly,
    required this.nextCursor,
    this.pinnedOnly = false,
    this.groups = const [],
    this.totalCount = 0,
    this.isLoadingMore = false,
    this.moreError,
    this.isRefreshing = false,
    this.filterError,
    this.expandedTaskIds = const {},
    this.subtasksByParentId = const {},
    this.nextSubtaskCursorByParentId = const {},
    this.loadingSubtaskParentIds = const {},
    this.subtaskErrorsByParentId = const {},
    this.taskErrorsByTaskId = const {},
    this.selectedTaskIds = const {},
    this.selectionAnchorTaskId,
  });

  final List<ProjectTaskListItemResponse> tasks;
  final ProjectTaskStatus? status;
  final TaskPriority? priority;
  final String? assigneeUserId;
  final TaskInvolvementFilter? myInvolvement;
  final bool unassignedOnly;
  final bool pinnedOnly;
  final String? nextCursor;
  final List<ProjectTaskListGroupResponse> groups;
  final int totalCount;
  final bool isLoadingMore;
  final String? moreError;
  final bool isRefreshing;

  /// Błąd odczytu nowej kombinacji filtrów. Poprzedni snapshot pozostaje
  /// widoczny, aby 403 nie niszczył scrolla ani rozwiniętych podzadań.
  final String? filterError;
  final Set<String> expandedTaskIds;
  final Map<String, List<ProjectTaskListItemResponse>> subtasksByParentId;
  final Map<String, String?> nextSubtaskCursorByParentId;
  final Set<String> loadingSubtaskParentIds;
  final Map<String, String> subtaskErrorsByParentId;
  final Map<String, String> taskErrorsByTaskId;
  final Set<String> selectedTaskIds;
  final String? selectionAnchorTaskId;

  bool get hasNextPage => nextCursor != null;
  bool get canLoadMore => hasNextPage && !isLoadingMore;

  ProjectTasksListReady copyWith({
    List<ProjectTaskListItemResponse>? tasks,
    ProjectTaskStatus? status,
    TaskPriority? priority,
    String? assigneeUserId,
    TaskInvolvementFilter? myInvolvement,
    bool? unassignedOnly,
    bool? pinnedOnly,
    String? nextCursor,
    List<ProjectTaskListGroupResponse>? groups,
    int? totalCount,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearAssigneeUserId = false,
    bool clearMyInvolvement = false,
    bool clearCursor = false,
    bool? isLoadingMore,
    String? moreError,
    bool clearMoreError = false,
    bool? isRefreshing,
    String? filterError,
    bool clearFilterError = false,
    Set<String>? expandedTaskIds,
    Map<String, List<ProjectTaskListItemResponse>>? subtasksByParentId,
    Map<String, String?>? nextSubtaskCursorByParentId,
    Set<String>? loadingSubtaskParentIds,
    Map<String, String>? subtaskErrorsByParentId,
    Map<String, String>? taskErrorsByTaskId,
    Set<String>? selectedTaskIds,
    String? selectionAnchorTaskId,
    bool clearSelectionAnchor = false,
  }) => ProjectTasksListReady(
    tasks: tasks ?? this.tasks,
    status: clearStatus ? null : status ?? this.status,
    priority: clearPriority ? null : priority ?? this.priority,
    assigneeUserId: clearAssigneeUserId
        ? null
        : assigneeUserId ?? this.assigneeUserId,
    myInvolvement: clearMyInvolvement
        ? null
        : myInvolvement ?? this.myInvolvement,
    unassignedOnly: unassignedOnly ?? this.unassignedOnly,
    pinnedOnly: pinnedOnly ?? this.pinnedOnly,
    nextCursor: clearCursor ? null : nextCursor ?? this.nextCursor,
    groups: groups ?? this.groups,
    totalCount: totalCount ?? this.totalCount,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    moreError: clearMoreError ? null : moreError ?? this.moreError,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    filterError: clearFilterError ? null : filterError ?? this.filterError,
    expandedTaskIds: expandedTaskIds ?? this.expandedTaskIds,
    subtasksByParentId: subtasksByParentId ?? this.subtasksByParentId,
    nextSubtaskCursorByParentId:
        nextSubtaskCursorByParentId ?? this.nextSubtaskCursorByParentId,
    loadingSubtaskParentIds:
        loadingSubtaskParentIds ?? this.loadingSubtaskParentIds,
    subtaskErrorsByParentId:
        subtaskErrorsByParentId ?? this.subtaskErrorsByParentId,
    taskErrorsByTaskId: taskErrorsByTaskId ?? this.taskErrorsByTaskId,
    selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
    selectionAnchorTaskId: clearSelectionAnchor
        ? null
        : selectionAnchorTaskId ?? this.selectionAnchorTaskId,
  );
}
