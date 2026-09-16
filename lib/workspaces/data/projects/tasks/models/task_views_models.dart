import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';

part 'task_views_models.freezed.dart';
part 'task_views_models.g.dart';

/// Pole sortowania zapisanego widoku.
@JsonEnum()
enum TaskSavedViewSortField {
  @JsonValue('Position')
  position,
  @JsonValue('UpdatedAtUtc')
  updatedAtUtc,
  @JsonValue('DueAtUtc')
  dueAtUtc,
  @JsonValue('Priority')
  priority,
  @JsonValue('Title')
  title,
}

/// Kierunek sortowania widoku.
@JsonEnum()
enum TaskSavedViewSortDirection {
  @JsonValue('Ascending')
  ascending,
  @JsonValue('Descending')
  descending,
}

/// Grupowanie zapisanej listy.
@JsonEnum()
enum TaskSavedViewGroupBy {
  @JsonValue('None')
  none,
  @JsonValue('Status')
  status,
  @JsonValue('CustomStatus')
  customStatus,
  @JsonValue('Priority')
  priority,
  @JsonValue('Assignee')
  assignee,
}

/// Kolumna zapisanego widoku.
@JsonEnum()
enum TaskSavedViewColumn {
  @JsonValue('Key')
  key,
  @JsonValue('Title')
  title,
  @JsonValue('Status')
  status,
  @JsonValue('CustomStatus')
  customStatus,
  @JsonValue('Priority')
  priority,
  @JsonValue('Assignees')
  assignees,
  @JsonValue('Owner')
  owner,
  @JsonValue('Collaborators')
  collaborators,
  @JsonValue('Labels')
  labels,
  @JsonValue('Watchers')
  watchers,
  @JsonValue('StartAtUtc')
  startAtUtc,
  @JsonValue('DueAtUtc')
  dueAtUtc,
  @JsonValue('ChecklistProgress')
  checklistProgress,
  @JsonValue('UpdatedAtUtc')
  updatedAtUtc,
  @JsonValue('CreatedAtUtc')
  createdAtUtc,
  @JsonValue('TaskType')
  taskType,
  @JsonValue('Size')
  size,
  @JsonValue('Complexity')
  complexity,
  @JsonValue('Risk')
  risk,
  @JsonValue('BusinessValue')
  businessValue,
  @JsonValue('EstimatedMinutes')
  estimatedMinutes,
  @JsonValue('ActualMinutes')
  actualMinutes,
  @JsonValue('Milestone')
  milestone,
}

/// Typowany filtr zapisanego widoku Tasks.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskSavedViewFilter with _$TaskSavedViewFilter {
  /// Tworzy filtr listy zadań.
  const factory TaskSavedViewFilter({
    List<ProjectTaskStatus>? statuses,
    List<TaskPriority>? priorities,
    List<String>? assigneeCoreUserIds,
    List<String>? labelIds,
    String? parentTaskId,
    TaskInvolvementFilter? myInvolvement,
    DateTime? dueFromUtc,
    DateTime? dueToUtc,
    String? search,
    @Default(false) bool includeArchived,
    @Default(false) bool pinnedOnly,
  }) = _TaskSavedViewFilter;

  /// Odtwarza filtr z JSON.
  factory TaskSavedViewFilter.fromJson(Map<String, dynamic> json) =>
      _$TaskSavedViewFilterFromJson(json);
}

/// Typowana konfiguracja filtra, sortowania i kolumn.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskSavedViewDefinition with _$TaskSavedViewDefinition {
  /// Tworzy definicję widoku.
  const factory TaskSavedViewDefinition({
    required TaskSavedViewFilter filter,
    required TaskSavedViewSortField sortField,
    required TaskSavedViewSortDirection sortDirection,
    required TaskSavedViewGroupBy groupBy,
    required List<TaskSavedViewColumn> columns,
    @Default([]) List<String> customFieldIds,
    List<String>? columnOrder,
  }) = _TaskSavedViewDefinition;

  /// Odtwarza definicję z JSON.
  factory TaskSavedViewDefinition.fromJson(Map<String, dynamic> json) =>
      _$TaskSavedViewDefinitionFromJson(json);
}

/// Payload utworzenia prywatnego widoku.
@freezed
abstract class CreateTaskSavedViewPayload with _$CreateTaskSavedViewPayload {
  /// Tworzy widok Tasks.
  const factory CreateTaskSavedViewPayload({
    required String name,
    required TaskSavedViewDefinition view,
  }) = _CreateTaskSavedViewPayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskSavedViewPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskSavedViewPayloadFromJson(json);
}

/// Payload aktualizacji prywatnego widoku.
@freezed
abstract class UpdateTaskSavedViewPayload with _$UpdateTaskSavedViewPayload {
  /// Tworzy zmianę widoku Tasks.
  const factory UpdateTaskSavedViewPayload({
    required String name,
    required TaskSavedViewDefinition view,
    int? expectedVersion,
  }) = _UpdateTaskSavedViewPayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskSavedViewPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskSavedViewPayloadFromJson(json);
}

/// Zapisany widok Tasks.
@freezed
abstract class TaskSavedViewResponse with _$TaskSavedViewResponse {
  /// Tworzy odpowiedź zapisanego widoku.
  const factory TaskSavedViewResponse({
    required String id,
    required String name,
    required TaskSavedViewDefinition view,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    @Default(1) int version,
  }) = _TaskSavedViewResponse;

  /// Odtwarza widok z JSON.
  factory TaskSavedViewResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskSavedViewResponseFromJson(json);
}

/// Zadanie na przekrojowej liście bieżącego użytkownika.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class MyTaskListItemResponse with _$MyTaskListItemResponse {
  /// Tworzy element listy `me/tasks`.
  const factory MyTaskListItemResponse({
    required String id,
    required int number,
    required String key,
    required String workspaceId,
    required String workspaceName,
    required String projectId,
    required String projectName,
    String? parentTaskId,
    required String title,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    required TaskInvolvementFilter involvement,
    required int checklistCompletedCount,
    required int checklistTotalCount,
    required bool isPinned,
    required DateTime updatedAtUtc,
    required int version,
  }) = _MyTaskListItemResponse;

  /// Odtwarza element z JSON.
  factory MyTaskListItemResponse.fromJson(Map<String, dynamic> json) =>
      _$MyTaskListItemResponseFromJson(json);
}

/// Wynik globalnego wyszukiwania zadań.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class GlobalTaskSearchItemResponse
    with _$GlobalTaskSearchItemResponse {
  /// Tworzy wynik wyszukiwania.
  const factory GlobalTaskSearchItemResponse({
    required String id,
    required int number,
    required String key,
    required String workspaceId,
    required String workspaceName,
    required String projectId,
    required String projectName,
    String? parentTaskId,
    required String title,
    String? descriptionPreview,
    String? titleHighlight,
    String? descriptionHighlight,
    required List<String> matchedLabels,
    required double score,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    required DateTime updatedAtUtc,
    required int version,
  }) = _GlobalTaskSearchItemResponse;

  /// Odtwarza wynik z JSON.
  factory GlobalTaskSearchItemResponse.fromJson(Map<String, dynamic> json) =>
      _$GlobalTaskSearchItemResponseFromJson(json);
}
