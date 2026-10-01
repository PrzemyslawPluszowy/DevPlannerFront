import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_workflow_models.freezed.dart';
part 'task_workflow_models.g.dart';

/// Skrócona konfiguracja serii cyklicznej osadzona w odpowiedzi zadania.
@freezed
abstract class TaskRecurrenceSummaryResponse
    with _$TaskRecurrenceSummaryResponse {
  /// Tworzy skrót serii cyklicznej.
  const factory TaskRecurrenceSummaryResponse({
    required String id,
    required String sourceTaskId,
    required TaskRecurrenceMode mode,
    required TaskRecurrenceFrequency frequency,
    required int interval,
    required String timeZoneId,
    DateTime? nextOccurrenceAtUtc,
    required ProjectTaskStatus occurrenceStatus,
    required bool skipIfPreviousOpen,
    required bool isActive,
    required bool isSourceTask,
    required int version,
  }) = _TaskRecurrenceSummaryResponse;

  /// Odtwarza skrót serii z JSON.
  factory TaskRecurrenceSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskRecurrenceSummaryResponseFromJson(json);
}

/// Status workflow projektu.
@freezed
abstract class ProjectTaskWorkflowStatusResponse
    with _$ProjectTaskWorkflowStatusResponse {
  /// Tworzy status workflow.
  const factory ProjectTaskWorkflowStatusResponse({
    required ProjectTaskStatus status,
    required String displayName,
    required String color,
    required int position,
    required bool isInitial,
    required bool isTerminal,
    required TaskStatusCategory category,
  }) = _ProjectTaskWorkflowStatusResponse;

  /// Odtwarza status workflow z JSON.
  factory ProjectTaskWorkflowStatusResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTaskWorkflowStatusResponseFromJson(json);
}

/// Przejście pomiędzy statusami workflow.
@freezed
abstract class ProjectTaskWorkflowTransitionResponse
    with _$ProjectTaskWorkflowTransitionResponse {
  /// Tworzy przejście workflow.
  const factory ProjectTaskWorkflowTransitionResponse({
    required ProjectTaskStatus fromStatus,
    required ProjectTaskStatus toStatus,
  }) = _ProjectTaskWorkflowTransitionResponse;

  /// Odtwarza przejście z JSON.
  factory ProjectTaskWorkflowTransitionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTaskWorkflowTransitionResponseFromJson(json);
}

/// Pełna konfiguracja workflow projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTaskWorkflowResponse with _$ProjectTaskWorkflowResponse {
  /// Tworzy odpowiedź workflow.
  const factory ProjectTaskWorkflowResponse({
    required List<ProjectTaskWorkflowStatusResponse> statuses,
    required List<ProjectTaskWorkflowTransitionResponse> transitions,
    required int version,
  }) = _ProjectTaskWorkflowResponse;

  /// Odtwarza workflow z JSON.
  factory ProjectTaskWorkflowResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTaskWorkflowResponseFromJson(json);
}

/// Payload utworzenia zadania lub jednopoziomowego podzadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateProjectTaskPayload with _$CreateProjectTaskPayload {
  /// Tworzy dane nowego zadania zgodne z `CreateProjectTaskRequest`.
  const factory CreateProjectTaskPayload({
    required String title,
    String? description,
    String? parentTaskId,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    List<String>? assigneeUserIds,
    List<String>? checklistItems,
    String? taskType,
    int? size,
    int? complexity,
    int? risk,
    int? businessValue,
    int? estimatedMinutes,
    int? actualMinutes,
    String? descriptionDeltaJson,
    String? milestoneId,
    ProjectTaskStatus? targetStatus,
    String? customStatusId,
    String? previousTaskId,
    String? nextTaskId,
  }) = _CreateProjectTaskPayload;

  /// Odtwarza payload z JSON.
  factory CreateProjectTaskPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectTaskPayloadFromJson(json);
}

/// Payload szybkiego tworzenia zadania (np. z Kanbana, listy, subtasków)
/// z obsługą domyślnej formatki użytkownika lub wybranego szablonu.
///
/// Wymaga wygenerowanego kontraktu Freezed/JSON w plikach `part` modelu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class QuickCreateProjectTaskPayload
    with _$QuickCreateProjectTaskPayload {
  /// Tworzy payload szybkiego dodawania zadania.
  const factory QuickCreateProjectTaskPayload({
    required String title,
    @JsonKey(includeIfNull: false) String? parentTaskId,
    @JsonKey(includeIfNull: false) String? taskTemplateId,
    @Default(true) bool useDefaultTemplate,
    @JsonKey(includeIfNull: false) ProjectTaskStatus? targetStatus,
    @JsonKey(includeIfNull: false) String? customStatusId,
    @JsonKey(includeIfNull: false) String? previousTaskId,
    @JsonKey(includeIfNull: false) String? nextTaskId,
  }) = _QuickCreateProjectTaskPayload;

  /// Odtwarza payload z JSON.
  factory QuickCreateProjectTaskPayload.fromJson(Map<String, dynamic> json) =>
      _$QuickCreateProjectTaskPayloadFromJson(json);
}

/// Payload aktualizacji zadania z optimistic concurrency.
@freezed
abstract class UpdateProjectTaskPayload with _$UpdateProjectTaskPayload {
  /// Tworzy pełny zestaw edytowalnych danych zadania.
  const factory UpdateProjectTaskPayload({
    required String title,
    String? description,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    required int position,
    required int expectedVersion,
    String? taskType,
    int? size,
    int? complexity,
    int? risk,
    int? businessValue,
    int? estimatedMinutes,
    int? actualMinutes,
    String? descriptionDeltaJson,
    String? milestoneId,
    String? customStatusId,
    @Default(false) bool clearMilestone,
  }) = _UpdateProjectTaskPayload;

  /// Odtwarza payload z JSON.
  factory UpdateProjectTaskPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateProjectTaskPayloadFromJson(json);
}
