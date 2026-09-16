import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_status_category.dart';

part 'task_models.freezed.dart';
part 'task_models.g.dart';

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
    List<String>? assigneeCoreUserIds,
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

/// Wykonawca zadania.
@freezed
abstract class TaskAssigneeResponse with _$TaskAssigneeResponse {
  /// Tworzy odpowiedź wykonawcy.
  const factory TaskAssigneeResponse({
    required String coreUserId,
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
    String? completedByCoreUserId,
    DateTime? completedAtUtc,
    required DateTime updatedAtUtc,
  }) = _TaskChecklistItemResponse;

  /// Odtwarza pozycję checklisty z JSON.
  factory TaskChecklistItemResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskChecklistItemResponseFromJson(json);
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
    String? assigneeCoreUserId,
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
    ProjectTaskStatus? status,
    String? customStatusId,
    @Default(false) bool clearCustomStatus,
    TaskPriority? priority,
    DateTime? dueAtUtc,
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

/// Pełna odpowiedź zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTaskResponse with _$ProjectTaskResponse {
  /// Tworzy pełny widok zadania.
  const factory ProjectTaskResponse({
    required String id,
    required int number,
    required String key,
    required String workspaceId,
    required String projectId,
    String? parentTaskId,
    required String title,
    String? description,
    String? descriptionDeltaJson,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    required String taskType,
    int? size,
    int? complexity,
    int? risk,
    int? businessValue,
    int? estimatedMinutes,
    int? actualMinutes,
    required int position,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    required String createdByCoreUserId,
    required List<TaskAssigneeResponse> assignees,
    required List<TaskChecklistItemResponse> checklistItems,
    TaskRecurrenceSummaryResponse? recurrence,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    DateTime? archivedAtUtc,
    required int version,
    String? customStatusId,
  }) = _ProjectTaskResponse;

  /// Odtwarza zadanie z JSON.
  factory ProjectTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTaskResponseFromJson(json);
}

/// Odpowiedź mutacji agregatu zadania.
@Freezed(makeCollectionsUnmodifiable: false, genericArgumentFactories: true)
abstract class TaskMutationResponse<T> with _$TaskMutationResponse<T> {
  /// Tworzy wynik mutacji z nową wersją zadania.
  const factory TaskMutationResponse({
    required String taskId,
    required int taskVersion,
    required DateTime taskUpdatedAtUtc,
    required T data,
  }) = _TaskMutationResponse<T>;

  /// Odtwarza wynik mutacji z JSON.
  factory TaskMutationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$TaskMutationResponseFromJson(json, fromJsonT);
}

/// Wersja zadania zwrócona po zmianie kolejności.
@freezed
abstract class ReorderedTaskVersionResponse
    with _$ReorderedTaskVersionResponse {
  /// Tworzy potwierdzenie nowej wersji zadania.
  const factory ReorderedTaskVersionResponse({
    required String taskId,
    required int taskVersion,
    required DateTime taskUpdatedAtUtc,
  }) = _ReorderedTaskVersionResponse;

  /// Odtwarza odpowiedź z JSON.
  factory ReorderedTaskVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$ReorderedTaskVersionResponseFromJson(json);
}

/// Zależność między zadaniami.
@freezed
abstract class TaskDependencyResponse with _$TaskDependencyResponse {
  /// Tworzy odpowiedź zależności.
  const factory TaskDependencyResponse({
    required String id,
    required String sourceTaskId,
    required String targetTaskId,
    required TaskDependencyType type,
    required DateTime createdAtUtc,
    @Default(TaskDependencyKind.finishToStart)
    TaskDependencyKind dependencyKind,
    @Default(0) int lagDays,
  }) = _TaskDependencyResponse;

  /// Odtwarza zależność z JSON.
  factory TaskDependencyResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskDependencyResponseFromJson(json);
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

/// Kryterium akceptacji zadania.
@freezed
abstract class TaskAcceptanceCriterionResponse
    with _$TaskAcceptanceCriterionResponse {
  /// Tworzy odpowiedź kryterium akceptacji.
  const factory TaskAcceptanceCriterionResponse({
    required String id,
    required String text,
    required int position,
    required bool isAccepted,
    String? acceptedByCoreUserId,
    DateTime? acceptedAtUtc,
    required DateTime updatedAtUtc,
  }) = _TaskAcceptanceCriterionResponse;

  /// Odtwarza kryterium z JSON.
  factory TaskAcceptanceCriterionResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskAcceptanceCriterionResponseFromJson(json);
}

/// Obserwator zadania.
@freezed
abstract class TaskWatcherResponse with _$TaskWatcherResponse {
  /// Tworzy odpowiedź obserwatora.
  const factory TaskWatcherResponse({
    required String coreUserId,
    required DateTime createdAtUtc,
  }) = _TaskWatcherResponse;

  /// Odtwarza obserwatora z JSON.
  factory TaskWatcherResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskWatcherResponseFromJson(json);
}

/// Jawne potwierdzenie mutacji bez osobnego DTO danych.
@freezed
abstract class TaskMutationAcknowledgementResponse
    with _$TaskMutationAcknowledgementResponse {
  /// Tworzy potwierdzenie zmiany.
  const factory TaskMutationAcknowledgementResponse({required bool changed}) =
      _TaskMutationAcknowledgementResponse;

  /// Odtwarza potwierdzenie z JSON.
  factory TaskMutationAcknowledgementResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$TaskMutationAcknowledgementResponseFromJson(json);
}

/// Payload dodania kryterium akceptacji.
@freezed
abstract class CreateTaskAcceptanceCriterionPayload
    with _$CreateTaskAcceptanceCriterionPayload {
  /// Tworzy kryterium z kontrolą wersji zadania.
  const factory CreateTaskAcceptanceCriterionPayload({
    required String text,
    required int expectedVersion,
  }) = _CreateTaskAcceptanceCriterionPayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskAcceptanceCriterionPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateTaskAcceptanceCriterionPayloadFromJson(json);
}

/// Payload aktualizacji kryterium akceptacji.
@freezed
abstract class UpdateTaskAcceptanceCriterionPayload
    with _$UpdateTaskAcceptanceCriterionPayload {
  /// Tworzy zmianę kryterium.
  const factory UpdateTaskAcceptanceCriterionPayload({
    required String text,
    required int position,
    required bool isAccepted,
    required int expectedVersion,
  }) = _UpdateTaskAcceptanceCriterionPayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskAcceptanceCriterionPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateTaskAcceptanceCriterionPayloadFromJson(json);
}

/// Osobiste ustawienie przypięcia zadania.
@freezed
abstract class UpdateTaskUserPreferencePayload
    with _$UpdateTaskUserPreferencePayload {
  /// Tworzy zmianę przypięcia zadania.
  const factory UpdateTaskUserPreferencePayload({required bool isPinned}) =
      _UpdateTaskUserPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskUserPreferencePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskUserPreferencePayloadFromJson(json);
}

/// Pełny agregat szczegółów zadania zwracany przez GET.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTaskDetailsResponse with _$ProjectTaskDetailsResponse {
  /// Tworzy agregat szczegółów zadania.
  const factory ProjectTaskDetailsResponse({
    required ProjectTaskResponse task,
    required List<TaskLabelResponse> labels,
    required List<TaskCustomFieldDefinitionValueResponse> customFields,
    required List<TaskAcceptanceCriterionResponse> acceptanceCriteria,
    required List<TaskDependencyDetailsResponse> dependencies,
    required List<TaskWatcherResponse> watchers,
    required bool isWatchedByMe,
    required bool isPinnedByMe,
    required List<ProjectTaskSubtaskSummaryResponse> subtasks,
    required ProjectTaskWorkflowResponse workflow,
    required List<UserReferenceResponse> includedUsers,
  }) = _ProjectTaskDetailsResponse;

  /// Odtwarza szczegóły zadania z JSON.
  factory ProjectTaskDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTaskDetailsResponseFromJson(json);
}

/// Wspólna referencja użytkownika zwracana przy szczegółach zadania.
@freezed
abstract class UserReferenceResponse with _$UserReferenceResponse {
  /// Tworzy referencję użytkownika z katalogu Core.
  const factory UserReferenceResponse({
    required String coreUserId,
    String? displayName,
    String? avatarUrl,
    required bool isActive,
  }) = _UserReferenceResponse;

  /// Odtwarza referencję użytkownika z JSON.
  factory UserReferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$UserReferenceResponseFromJson(json);
}

/// Definicja pola niestandardowego wraz z wartością zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskCustomFieldDefinitionValueResponse
    with _$TaskCustomFieldDefinitionValueResponse {
  /// Tworzy definicję pola i jego aktualną wartość.
  const factory TaskCustomFieldDefinitionValueResponse({
    required String id,
    required String name,
    required TaskCustomFieldType type,
    @JsonKey(name: 'required') required bool isRequired,
    required int position,
    List<String>? options,
    Object? value,
    DateTime? valueUpdatedAtUtc,
  }) = _TaskCustomFieldDefinitionValueResponse;

  /// Odtwarza definicję pola z JSON.
  factory TaskCustomFieldDefinitionValueResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$TaskCustomFieldDefinitionValueResponseFromJson(json);
}

/// Zależność zadania wraz z bezpiecznym podglądem zadania powiązanego.
@freezed
abstract class TaskDependencyDetailsResponse
    with _$TaskDependencyDetailsResponse {
  /// Tworzy szczegóły zależności.
  const factory TaskDependencyDetailsResponse({
    required String id,
    required String sourceTaskId,
    required String targetTaskId,
    required TaskDependencyType type,
    required DateTime createdAtUtc,
    required ProjectTaskReferenceResponse relatedTask,
    @Default(TaskDependencyKind.finishToStart)
    TaskDependencyKind dependencyKind,
    @Default(0) int lagDays,
  }) = _TaskDependencyDetailsResponse;

  /// Odtwarza szczegóły zależności z JSON.
  factory TaskDependencyDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskDependencyDetailsResponseFromJson(json);
}

/// Minimalny podgląd zadania używany w szczegółach zależności.
@freezed
abstract class ProjectTaskReferenceResponse
    with _$ProjectTaskReferenceResponse {
  /// Tworzy referencję zadania.
  const factory ProjectTaskReferenceResponse({
    required String id,
    required int number,
    required String key,
    required String title,
    required ProjectTaskStatus status,
    DateTime? archivedAtUtc,
    required int version,
  }) = _ProjectTaskReferenceResponse;

  /// Odtwarza referencję zadania z JSON.
  factory ProjectTaskReferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTaskReferenceResponseFromJson(json);
}

/// Skrócony widok bezpośredniego podzadania.
@freezed
abstract class ProjectTaskSubtaskSummaryResponse
    with _$ProjectTaskSubtaskSummaryResponse {
  /// Tworzy skrót podzadania.
  const factory ProjectTaskSubtaskSummaryResponse({
    required String id,
    required int number,
    required String key,
    required String title,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? dueAtUtc,
    required int version,
  }) = _ProjectTaskSubtaskSummaryResponse;

  /// Odtwarza skrót podzadania z JSON.
  factory ProjectTaskSubtaskSummaryResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTaskSubtaskSummaryResponseFromJson(json);
}

/// Payload utworzenia zależności.
@freezed
abstract class CreateTaskDependencyPayload with _$CreateTaskDependencyPayload {
  /// Tworzy zależność z kontrolą wersji zadania źródłowego.
  const factory CreateTaskDependencyPayload({
    required String targetTaskId,
    required TaskDependencyType type,
    required int expectedVersion,
    @Default(TaskDependencyKind.finishToStart)
    TaskDependencyKind dependencyKind,
    @Default(0) int lagDays,
  }) = _CreateTaskDependencyPayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskDependencyPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskDependencyPayloadFromJson(json);
}

/// Payload aktualizacji rodzaju Gantta i laga istniejącej zależności.
@freezed
abstract class UpdateTaskDependencyPayload with _$UpdateTaskDependencyPayload {
  /// Tworzy wersjonowaną zmianę parametrów harmonogramowych relacji.
  const factory UpdateTaskDependencyPayload({
    required TaskDependencyKind dependencyKind,
    required int lagDays,
    required int expectedVersion,
  }) = _UpdateTaskDependencyPayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskDependencyPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskDependencyPayloadFromJson(json);
}

/// Payload pełnej listy wykonawców zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateTaskAssigneesPayload with _$UpdateTaskAssigneesPayload {
  /// Tworzy listę wykonawców z kontrolą wersji zadania.
  const factory UpdateTaskAssigneesPayload({
    required List<String> coreUserIds,
    required int expectedVersion,
  }) = _UpdateTaskAssigneesPayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskAssigneesPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskAssigneesPayloadFromJson(json);
}

/// Payload dodania pozycji checklisty.
@freezed
abstract class CreateTaskChecklistItemPayload
    with _$CreateTaskChecklistItemPayload {
  /// Tworzy pozycję checklisty z kontrolą wersji zadania.
  const factory CreateTaskChecklistItemPayload({
    required String title,
    required int expectedVersion,
  }) = _CreateTaskChecklistItemPayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskChecklistItemPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskChecklistItemPayloadFromJson(json);
}

/// Payload aktualizacji pozycji checklisty.
@freezed
abstract class UpdateTaskChecklistItemPayload
    with _$UpdateTaskChecklistItemPayload {
  /// Tworzy zmianę tekstu, pozycji i stanu checklisty.
  const factory UpdateTaskChecklistItemPayload({
    required String title,
    required int position,
    required bool isCompleted,
    required int expectedVersion,
  }) = _UpdateTaskChecklistItemPayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskChecklistItemPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskChecklistItemPayloadFromJson(json);
}

/// Etykieta projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateTaskLabelPayload with _$CreateTaskLabelPayload {
  /// Tworzy nową etykietę projektu.
  const factory CreateTaskLabelPayload({
    required String name,
    required String color,
  }) = _CreateTaskLabelPayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskLabelPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskLabelPayloadFromJson(json);
}

/// Payload aktualizacji etykiety.
@freezed
abstract class UpdateTaskLabelPayload with _$UpdateTaskLabelPayload {
  /// Tworzy nowe dane etykiety.
  const factory UpdateTaskLabelPayload({
    required String name,
    required String color,
  }) = _UpdateTaskLabelPayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskLabelPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskLabelPayloadFromJson(json);
}

/// Payload pełnej listy etykiet zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ReplaceTaskLabelsPayload with _$ReplaceTaskLabelsPayload {
  /// Tworzy listę etykiet z kontrolą wersji zadania.
  const factory ReplaceTaskLabelsPayload({
    required List<String> labelIds,
    required int expectedVersion,
  }) = _ReplaceTaskLabelsPayload;

  /// Odtwarza payload z JSON.
  factory ReplaceTaskLabelsPayload.fromJson(Map<String, dynamic> json) =>
      _$ReplaceTaskLabelsPayloadFromJson(json);
}

/// Payload definicji pola niestandardowego.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateTaskCustomFieldPayload
    with _$CreateTaskCustomFieldPayload {
  /// Tworzy pole niestandardowe projektu.
  const factory CreateTaskCustomFieldPayload({
    required String name,
    required TaskCustomFieldType type,
    @JsonKey(name: 'required') required bool isRequired,
    required int position,
    List<String>? options,
  }) = _CreateTaskCustomFieldPayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskCustomFieldPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskCustomFieldPayloadFromJson(json);
}

/// Payload aktualizacji definicji pola niestandardowego.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateTaskCustomFieldPayload
    with _$UpdateTaskCustomFieldPayload {
  /// Tworzy zmianę definicji pola.
  const factory UpdateTaskCustomFieldPayload({
    required String name,
    @JsonKey(name: 'required') required bool isRequired,
    required int position,
    List<String>? options,
  }) = _UpdateTaskCustomFieldPayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskCustomFieldPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskCustomFieldPayloadFromJson(json);
}

/// Definicja pola niestandardowego projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskCustomFieldResponse with _$TaskCustomFieldResponse {
  /// Tworzy odpowiedź definicji pola.
  const factory TaskCustomFieldResponse({
    required String id,
    required String name,
    required TaskCustomFieldType type,
    @JsonKey(name: 'required') required bool isRequired,
    required int position,
    List<String>? options,
  }) = _TaskCustomFieldResponse;

  /// Odtwarza definicję z JSON.
  factory TaskCustomFieldResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskCustomFieldResponseFromJson(json);
}

/// Payload pełnego zapisu wartości pól niestandardowych zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ReplaceTaskCustomFieldValuesPayload
    with _$ReplaceTaskCustomFieldValuesPayload {
  /// Tworzy mapę wartości pól wraz z oczekiwaną wersją zadania.
  const factory ReplaceTaskCustomFieldValuesPayload({
    required Map<String, dynamic> values,
    required int expectedVersion,
  }) = _ReplaceTaskCustomFieldValuesPayload;

  /// Odtwarza payload z JSON.
  factory ReplaceTaskCustomFieldValuesPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$ReplaceTaskCustomFieldValuesPayloadFromJson(json);
}

/// Zapisana wartość jednego pola niestandardowego zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskCustomFieldValueResponse
    with _$TaskCustomFieldValueResponse {
  /// Tworzy odpowiedź wartości pola.
  const factory TaskCustomFieldValueResponse({
    required String fieldId,
    required Object? value,
    required DateTime updatedAtUtc,
  }) = _TaskCustomFieldValueResponse;

  /// Odtwarza wartość pola z JSON.
  factory TaskCustomFieldValueResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskCustomFieldValueResponseFromJson(json);
}

/// Payload pełnej kolejności zadań jednej gałęzi projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ReorderProjectTasksPayload with _$ReorderProjectTasksPayload {
  /// Tworzy kolejność z kontrolą wersji każdego zadania.
  const factory ReorderProjectTasksPayload({
    required List<String> taskIds,
    String? parentTaskId,
    ProjectTaskStatus? status,
    required Map<String, int> expectedVersions,
  }) = _ReorderProjectTasksPayload;

  /// Odtwarza payload z JSON.
  factory ReorderProjectTasksPayload.fromJson(Map<String, dynamic> json) =>
      _$ReorderProjectTasksPayloadFromJson(json);
}
