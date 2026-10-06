import 'package:devplanner/workspaces/data/projects/tasks/models/task_mutation_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_workflow_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_models.freezed.dart';
part 'task_list_models.g.dart';

/// Wykonawca zadania.
@freezed
abstract class TaskAssigneeResponse with _$TaskAssigneeResponse {
  /// Tworzy odpowiedź wykonawcy.
  const factory TaskAssigneeResponse({
    required String userId,
    required bool isPrimary,
    required DateTime createdAtUtc,
  }) = _TaskAssigneeResponse;

  /// Odtwarza wykonawcę z JSON.
  factory TaskAssigneeResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskAssigneeResponseFromJson(json);
}

/// Pozycja checklisty zadania.
@freezed
abstract class TaskChecklistItemResponse with _$TaskChecklistItemResponse {
  /// Tworzy odpowiedź pozycji checklisty.
  const factory TaskChecklistItemResponse({
    required String id,
    required String title,
    required int position,
    required bool isCompleted,
    String? completedByUserId,
    DateTime? completedAtUtc,
    required DateTime updatedAtUtc,
  }) = _TaskChecklistItemResponse;

  /// Odtwarza pozycję checklisty z JSON.
  factory TaskChecklistItemResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskChecklistItemResponseFromJson(json);
}

/// Etykieta projektu przypisana do zadania.
@freezed
abstract class TaskLabelResponse with _$TaskLabelResponse {
  /// Tworzy odpowiedź etykiety.
  const factory TaskLabelResponse({
    required String id,
    required String name,
    required String color,
    required DateTime createdAtUtc,
  }) = _TaskLabelResponse;

  /// Odtwarza etykietę z JSON.
  factory TaskLabelResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskLabelResponseFromJson(json);
}

/// Skrócony rekord zadania do listy.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTaskListItemResponse with _$ProjectTaskListItemResponse {
  /// Tworzy element listy zadań.
  const factory ProjectTaskListItemResponse({
    required String id,
    required int number,
    required String key,
    String? parentTaskId,
    required String title,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    required List<TaskAssigneeResponse> assignees,
    required int checklistCompletedCount,
    required int checklistTotalCount,
    @Default(0) int subtaskCount,
    required DateTime updatedAtUtc,
    required int version,
    @Default(false) bool isPinned,
    String? customStatusId,
    @Default([]) List<TaskCustomFieldValueResponse> customFields,
    DateTime? createdAtUtc,
    String? taskType,
    int? size,
    int? complexity,
    int? risk,
    int? businessValue,
    int? estimatedMinutes,
    int? actualMinutes,
    @Default([]) List<TaskLabelResponse> labels,
    String? customStatusName,
    String? customStatusColor,
    @Default(0) int watcherCount,
    @Default(false) bool isWatchedByMe,
    TaskRecurrenceSummaryResponse? recurrence,
    String? milestoneId,
  }) = _ProjectTaskListItemResponse;

  /// Odtwarza element listy z JSON.
  factory ProjectTaskListItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTaskListItemResponseFromJson(json);
}

/// Jedna sekcja serwerowo pogrupowanej listy Tasks.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTaskListGroupResponse
    with _$ProjectTaskListGroupResponse {
  const factory ProjectTaskListGroupResponse({
    required String key,
    required String displayName,
    String? color,
    required int position,
    required int totalCount,
    required List<ProjectTaskListItemResponse> items,
    String? nextCursor,
  }) = _ProjectTaskListGroupResponse;

  factory ProjectTaskListGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTaskListGroupResponseFromJson(json);
}

/// Snapshot listy, którego grupy, filtry i liczniki są liczone przez backend.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTaskGroupedListResponse
    with _$ProjectTaskGroupedListResponse {
  const factory ProjectTaskGroupedListResponse({
    required int totalCount,
    required TaskSavedViewGroupBy groupBy,
    required List<ProjectTaskListGroupResponse> groups,
  }) = _ProjectTaskGroupedListResponse;

  factory ProjectTaskGroupedListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTaskGroupedListResponseFromJson(json);
}

@freezed
abstract class CreateTaskSelectionTokenPayload
    with _$CreateTaskSelectionTokenPayload {
  const factory CreateTaskSelectionTokenPayload({
    required TaskSelectionQueryPayload query,
  }) = _CreateTaskSelectionTokenPayload;

  factory CreateTaskSelectionTokenPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskSelectionTokenPayloadFromJson(json);
}

@freezed
abstract class TaskSelectionQueryPayload with _$TaskSelectionQueryPayload {
  const factory TaskSelectionQueryPayload({
    String? savedViewId,
    String? status,
    String? priority,
    String? assigneeUserId,
    String? myInvolvement,
    String? search,
    DateTime? dueFromUtc,
    DateTime? dueToUtc,
    @Default(false) bool includeArchived,
    @Default(false) bool pinnedOnly,
    @Default(false) bool unassignedOnly,
  }) = _TaskSelectionQueryPayload;

  factory TaskSelectionQueryPayload.fromJson(Map<String, dynamic> json) =>
      _$TaskSelectionQueryPayloadFromJson(json);
}

@freezed
abstract class TaskSelectionTokenResponse with _$TaskSelectionTokenResponse {
  const factory TaskSelectionTokenResponse({
    required String token,
    required int totalCount,
    required DateTime expiresAtUtc,
  }) = _TaskSelectionTokenResponse;

  factory TaskSelectionTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskSelectionTokenResponseFromJson(json);
}

@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkUpdateTaskSelectionPayload
    with _$BulkUpdateTaskSelectionPayload {
  const factory BulkUpdateTaskSelectionPayload({
    required String selectionToken,
    @JsonKey(includeIfNull: false) List<BulkUpdateTaskItemPayload>? tasks,
    ProjectTaskStatus? status,
    String? customStatusId,
    @Default(false) bool clearCustomStatus,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    @JsonKey(includeIfNull: false) String? calendarTimeZoneId,
    @Default(false) bool clearDueAtUtc,
    List<String>? assigneeIds,
    @Default(false) bool archive,
    @Default(<String>[]) List<String> returnTaskIds,
  }) = _BulkUpdateTaskSelectionPayload;

  factory BulkUpdateTaskSelectionPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkUpdateTaskSelectionPayloadFromJson(json);
}

@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkUpdateTaskSelectionResponse
    with _$BulkUpdateTaskSelectionResponse {
  const factory BulkUpdateTaskSelectionResponse({
    required int updatedCount,
    @Default(<BulkUpdatedTaskVersionResponse>[])
    List<BulkUpdatedTaskVersionResponse> updatedTasks,
  }) = _BulkUpdateTaskSelectionResponse;

  factory BulkUpdateTaskSelectionResponse.fromJson(Map<String, dynamic> json) =>
      _$BulkUpdateTaskSelectionResponseFromJson(json);
}

@freezed
abstract class BulkUpdatedTaskVersionResponse
    with _$BulkUpdatedTaskVersionResponse {
  const factory BulkUpdatedTaskVersionResponse({
    required String taskId,
    required int version,
    required DateTime updatedAtUtc,
  }) = _BulkUpdatedTaskVersionResponse;

  factory BulkUpdatedTaskVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$BulkUpdatedTaskVersionResponseFromJson(json);
}

/// Częściowa mutacja jednej komórki zwartej listy Tasks.
@freezed
abstract class UpdateTaskListItemPayload with _$UpdateTaskListItemPayload {
  const factory UpdateTaskListItemPayload({
    String? title,
    @JsonKey(includeIfNull: false) ProjectTaskStatus? status,
    TaskPriority? priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    @JsonKey(includeIfNull: false) String? calendarTimeZoneId,
    @Default(false) bool clearStartAtUtc,
    @Default(false) bool clearDueAtUtc,
    String? taskType,
    int? size,
    int? complexity,
    int? risk,
    int? businessValue,
    int? estimatedMinutes,
    @Default(false) bool clearSize,
    @Default(false) bool clearComplexity,
    @Default(false) bool clearRisk,
    @Default(false) bool clearBusinessValue,
    @Default(false) bool clearEstimatedMinutes,
    String? milestoneId,
    @Default(false) bool clearMilestone,
    @JsonKey(includeIfNull: false) String? customStatusId,
    required int expectedVersion,
  }) = _UpdateTaskListItemPayload;

  factory UpdateTaskListItemPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskListItemPayloadFromJson(json);
}

/// Ruch pojedynczego rekordu Tasks względem sąsiadów docelowej gałęzi.
@freezed
abstract class MoveProjectTaskPayload with _$MoveProjectTaskPayload {
  const factory MoveProjectTaskPayload({
    required int expectedVersion,
    String? parentTaskId,
    String? previousTaskId,
    String? nextTaskId,
    ProjectTaskStatus? status,
    String? customStatusId,
  }) = _MoveProjectTaskPayload;

  factory MoveProjectTaskPayload.fromJson(Map<String, dynamic> json) =>
      _$MoveProjectTaskPayloadFromJson(json);
}

/// Minimalne potwierdzenie pojedynczego ruchu listy.
@freezed
abstract class MovedProjectTaskResponse with _$MovedProjectTaskResponse {
  const factory MovedProjectTaskResponse({
    required String taskId,
    String? parentTaskId,
    required ProjectTaskStatus status,
    required int position,
    required int version,
    required DateTime updatedAtUtc,
    String? customStatusId,
  }) = _MovedProjectTaskResponse;

  factory MovedProjectTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$MovedProjectTaskResponseFromJson(json);
}

/// Jawne zaznaczenie z wersjami; alternatywa dla tokenu całego wyniku.
@freezed
abstract class BulkUpdateTaskItemPayload with _$BulkUpdateTaskItemPayload {
  const factory BulkUpdateTaskItemPayload({
    required String taskId,
    required int expectedVersion,
  }) = _BulkUpdateTaskItemPayload;

  factory BulkUpdateTaskItemPayload.fromJson(Map<String, dynamic> json) =>
      _$BulkUpdateTaskItemPayloadFromJson(json);
}
