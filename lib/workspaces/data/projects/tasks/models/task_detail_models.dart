import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_workflow_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_detail_models.freezed.dart';
part 'task_detail_models.g.dart';

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
    required String createdByUserId,
    required List<TaskAssigneeResponse> assignees,
    required List<TaskChecklistItemResponse> checklistItems,
    TaskRecurrenceSummaryResponse? recurrence,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    DateTime? archivedAtUtc,
    required int version,
    String? customStatusId,
    String? milestoneId,
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
    String? acceptedByUserId,
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
    required String userId,
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
    TaskCapabilitiesResponse? capabilities,
    ProjectTaskCustomStatusResponse? customStatus,
  }) = _ProjectTaskDetailsResponse;

  /// Odtwarza szczegóły zadania z JSON.
  factory ProjectTaskDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTaskDetailsResponseFromJson(json);
}

/// Uprawnienia bieżącego użytkownika obliczone przez backend po ACL projektu.
@freezed
abstract class TaskCapabilitiesResponse with _$TaskCapabilitiesResponse {
  const factory TaskCapabilitiesResponse({
    required bool canEdit,
    required bool canArchive,
    required bool canRestore,
  }) = _TaskCapabilitiesResponse;

  factory TaskCapabilitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskCapabilitiesResponseFromJson(json);
}

/// Bieżąca prezentacja własnego statusu zadania.
@freezed
abstract class ProjectTaskCustomStatusResponse
    with _$ProjectTaskCustomStatusResponse {
  const factory ProjectTaskCustomStatusResponse({
    required String id,
    required String name,
    required String color,
    required TaskStatusCategory category,
  }) = _ProjectTaskCustomStatusResponse;

  factory ProjectTaskCustomStatusResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTaskCustomStatusResponseFromJson(json);
}

/// Wspólna referencja użytkownika zwracana przy szczegółach zadania.
@freezed
abstract class UserReferenceResponse with _$UserReferenceResponse {
  /// Tworzy referencję lokalnego użytkownika workspace.
  const factory UserReferenceResponse({
    required String userId,
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
