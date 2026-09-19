import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_advanced_models.freezed.dart';
part 'task_advanced_models.g.dart';

/// Payload utworzenia serii cyklicznej zadania.
@freezed
abstract class CreateTaskRecurrencePayload with _$CreateTaskRecurrencePayload {
  /// Tworzy konfigurację serii zgodną z C#.
  const factory CreateTaskRecurrencePayload({
    required TaskRecurrenceMode mode,
    required TaskRecurrenceFrequency frequency,
    required int interval,
    required String timeZoneId,
    DateTime? firstOccurrenceAtUtc,
    required int expectedVersion,
    @Default(ProjectTaskStatus.todo) ProjectTaskStatus occurrenceStatus,
    @Default(true) bool skipIfPreviousOpen,
  }) = _CreateTaskRecurrencePayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskRecurrencePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskRecurrencePayloadFromJson(json);
}

/// Payload aktualizacji serii cyklicznej.
@freezed
abstract class UpdateTaskRecurrencePayload with _$UpdateTaskRecurrencePayload {
  /// Tworzy pełną zmianę konfiguracji serii.
  const factory UpdateTaskRecurrencePayload({
    required TaskRecurrenceMode mode,
    required TaskRecurrenceFrequency frequency,
    required int interval,
    required String timeZoneId,
    DateTime? nextOccurrenceAtUtc,
    required ProjectTaskStatus occurrenceStatus,
    required bool skipIfPreviousOpen,
    required int expectedVersion,
  }) = _UpdateTaskRecurrencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskRecurrencePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskRecurrencePayloadFromJson(json);
}

/// Pełna odpowiedź konfiguracji serii cyklicznej.
@freezed
abstract class TaskRecurrenceResponse with _$TaskRecurrenceResponse {
  /// Tworzy odpowiedź serii.
  const factory TaskRecurrenceResponse({
    required String id,
    required String workspaceId,
    required String projectId,
    required String sourceTaskId,
    required TaskRecurrenceMode mode,
    required TaskRecurrenceFrequency frequency,
    required int interval,
    required String timeZoneId,
    DateTime? nextOccurrenceAtUtc,
    String? lastCompletedTaskId,
    String? lastCreatedTaskId,
    required ProjectTaskStatus occurrenceStatus,
    required bool skipIfPreviousOpen,
    required bool isActive,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required int version,
  }) = _TaskRecurrenceResponse;

  /// Odtwarza serię z JSON.
  factory TaskRecurrenceResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskRecurrenceResponseFromJson(json);
}

/// Element listy reguł cyklicznych w projekcie.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTaskRecurrenceItemResponse
    with _$ProjectTaskRecurrenceItemResponse {
  /// Tworzy element listy reguł cyklicznych.
  const factory ProjectTaskRecurrenceItemResponse({
    required String id,
    required String workspaceId,
    required String projectId,
    required String sourceTaskId,
    required String taskKey,
    required String taskTitle,
    required ProjectTaskStatus taskStatus,
    required TaskPriority priority,
    @Default([]) List<String> assigneeIds,
    required TaskRecurrenceMode mode,
    required TaskRecurrenceFrequency frequency,
    required int interval,
    required String timeZoneId,
    DateTime? nextOccurrenceAtUtc,
    String? lastCompletedTaskId,
    String? lastCreatedTaskId,
    required ProjectTaskStatus occurrenceStatus,
    required bool skipIfPreviousOpen,
    required bool isActive,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required int version,
  }) = _ProjectTaskRecurrenceItemResponse;

  /// Odtwarza model z JSON.
  factory ProjectTaskRecurrenceItemResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTaskRecurrenceItemResponseFromJson(json);
}

/// Wpis historii wykonania cyklu zadania powtarzalnego.
@freezed
abstract class ProjectTaskRecurrenceRunResponse
    with _$ProjectTaskRecurrenceRunResponse {
  /// Tworzy wpis wykonania cyklu.
  const factory ProjectTaskRecurrenceRunResponse({
    required String id,
    required String recurrenceRuleId,
    required String sourceTaskId,
    required String taskKey,
    required String taskTitle,
    required DateTime scheduledAtUtc,
    required DateTime executedAtUtc,
    required TaskRecurrenceRunOutcome outcome,
    String? createdTaskId,
    String? createdTaskKey,
  }) = _ProjectTaskRecurrenceRunResponse;

  /// Odtwarza wpis wykonania z JSON.
  factory ProjectTaskRecurrenceRunResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTaskRecurrenceRunResponseFromJson(json);
}

/// Payload statusu workflow.
@freezed
abstract class UpdateProjectTaskWorkflowStatusPayload
    with _$UpdateProjectTaskWorkflowStatusPayload {
  /// Tworzy konfigurację jednego statusu.
  const factory UpdateProjectTaskWorkflowStatusPayload({
    required ProjectTaskStatus status,
    required String displayName,
    required String color,
    required int position,
    required bool isInitial,
    required bool isTerminal,
    TaskStatusCategory? category,
  }) = _UpdateProjectTaskWorkflowStatusPayload;

  /// Odtwarza status payload z JSON.
  factory UpdateProjectTaskWorkflowStatusPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateProjectTaskWorkflowStatusPayloadFromJson(json);
}

/// Payload pełnej konfiguracji workflow projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateProjectTaskWorkflowPayload
    with _$UpdateProjectTaskWorkflowPayload {
  /// Tworzy pełny workflow z kontrolą wersji.
  const factory UpdateProjectTaskWorkflowPayload({
    required List<UpdateProjectTaskWorkflowStatusPayload> statuses,
    required List<ProjectTaskWorkflowTransitionResponse> transitions,
    required int expectedVersion,
  }) = _UpdateProjectTaskWorkflowPayload;

  /// Odtwarza workflow payload z JSON.
  factory UpdateProjectTaskWorkflowPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateProjectTaskWorkflowPayloadFromJson(json);
}

/// Aktor wpisu historii zadania.
@freezed
abstract class TaskHistoryActorResponse with _$TaskHistoryActorResponse {
  /// Tworzy aktora historii.
  const factory TaskHistoryActorResponse({
    required TaskActorType type,
    String? userId,
  }) = _TaskHistoryActorResponse;

  /// Odtwarza aktora z JSON.
  factory TaskHistoryActorResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskHistoryActorResponseFromJson(json);
}

/// Zmiana pojedynczego pola historii zadania.
@freezed
abstract class TaskHistoryChangeResponse with _$TaskHistoryChangeResponse {
  /// Tworzy zmianę before/after.
  const factory TaskHistoryChangeResponse({
    required String field,
    Object? before,
    Object? after,
  }) = _TaskHistoryChangeResponse;

  /// Odtwarza zmianę z JSON.
  factory TaskHistoryChangeResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskHistoryChangeResponseFromJson(json);
}

/// Niezmienny wpis historii zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskHistoryEventResponse with _$TaskHistoryEventResponse {
  /// Tworzy wpis historii.
  const factory TaskHistoryEventResponse({
    required String eventId,
    required TaskHistoryEventType eventType,
    required String actionLabel,
    required TaskHistoryActorResponse actor,
    required List<TaskHistoryChangeResponse> changes,
    required int taskVersion,
    required String correlationId,
    required DateTime createdAtUtc,
  }) = _TaskHistoryEventResponse;

  /// Odtwarza historię z JSON.
  factory TaskHistoryEventResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskHistoryEventResponseFromJson(json);
}

/// Element timeline zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskTimelineItemResponse with _$TaskTimelineItemResponse {
  /// Tworzy element timeline.
  const factory TaskTimelineItemResponse({
    required String id,
    required int number,
    required String key,
    String? parentTaskId,
    required String title,
    required String taskType,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    int? estimatedMinutes,
    required int position,
    required List<TaskAssigneeResponse> assignees,
    required int checklistCompletedCount,
    required int checklistTotalCount,
    required int version,
  }) = _TaskTimelineItemResponse;

  /// Odtwarza element timeline z JSON.
  factory TaskTimelineItemResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskTimelineItemResponseFromJson(json);
}

/// Zależność pokazana na timeline.
@freezed
abstract class TaskTimelineDependencyResponse
    with _$TaskTimelineDependencyResponse {
  /// Tworzy zależność timeline.
  const factory TaskTimelineDependencyResponse({
    required String id,
    required String sourceTaskId,
    required String targetTaskId,
    required TaskDependencyType type,
  }) = _TaskTimelineDependencyResponse;

  /// Odtwarza zależność z JSON.
  factory TaskTimelineDependencyResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskTimelineDependencyResponseFromJson(json);
}

/// Odpowiedź timeline projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskTimelineResponse with _$TaskTimelineResponse {
  /// Tworzy odpowiedź timeline.
  const factory TaskTimelineResponse({
    required DateTime fromUtc,
    required DateTime toUtc,
    required List<TaskTimelineItemResponse> items,
    required List<TaskTimelineDependencyResponse> dependencies,
    required bool isTruncated,
    String? nextCursor,
  }) = _TaskTimelineResponse;

  /// Odtwarza timeline z JSON.
  factory TaskTimelineResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskTimelineResponseFromJson(json);
}

/// Wpis czasu pracy zadania.
@freezed
abstract class TaskTimeEntryResponse with _$TaskTimeEntryResponse {
  /// Tworzy odpowiedź wpisu czasu.
  const factory TaskTimeEntryResponse({
    required String id,
    required String taskId,
    required String userId,
    required TaskTimeEntryKind kind,
    required DateTime startedAtUtc,
    DateTime? stoppedAtUtc,
    int? durationMinutes,
    String? description,
    required bool isBillable,
    required DateTime createdAtUtc,
    required TaskTimeEntryApprovalStatus approvalStatus,
    String? reviewedByUserId,
    DateTime? reviewedAtUtc,
    String? reviewComment,
    required int version,
  }) = _TaskTimeEntryResponse;

  /// Odtwarza wpis czasu z JSON.
  factory TaskTimeEntryResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskTimeEntryResponseFromJson(json);
}

/// Payload ręcznego wpisu czasu.
@freezed
abstract class CreateTaskTimeEntryPayload with _$CreateTaskTimeEntryPayload {
  /// Tworzy ręczny wpis czasu pracy.
  const factory CreateTaskTimeEntryPayload({
    DateTime? startedAtUtc,
    required int durationMinutes,
    String? description,
    required bool isBillable,
  }) = _CreateTaskTimeEntryPayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskTimeEntryPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskTimeEntryPayloadFromJson(json);
}

/// Payload zatrzymania timera.
@freezed
abstract class StopTaskTimerPayload with _$StopTaskTimerPayload {
  /// Tworzy żądanie zatrzymania timera.
  const factory StopTaskTimerPayload({DateTime? stoppedAtUtc}) =
      _StopTaskTimerPayload;

  /// Odtwarza payload z JSON.
  factory StopTaskTimerPayload.fromJson(Map<String, dynamic> json) =>
      _$StopTaskTimerPayloadFromJson(json);
}

/// Payload przesłania, akceptacji albo odrzucenia wpisu czasu.
@freezed
abstract class TimeEntryWorkflowPayload with _$TimeEntryWorkflowPayload {
  /// Tworzy zmianę statusu wpisu z kontrolą wersji.
  const factory TimeEntryWorkflowPayload({
    required int expectedVersion,
    String? comment,
  }) = _TimeEntryWorkflowPayload;

  /// Odtwarza payload z JSON.
  factory TimeEntryWorkflowPayload.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryWorkflowPayloadFromJson(json);
}
