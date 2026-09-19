import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_templates_models.freezed.dart';
part 'task_templates_models.g.dart';

/// Payload utworzenia szablonu zadania.
@freezed
abstract class CreateTaskTemplatePayload with _$CreateTaskTemplatePayload {
  /// Tworzy szablon na podstawie zadania.
  const factory CreateTaskTemplatePayload({required String name}) =
      _CreateTaskTemplatePayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskTemplatePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskTemplatePayloadFromJson(json);
}

/// Payload zastosowania szablonu w projekcie.
@freezed
abstract class ApplyTaskTemplatePayload with _$ApplyTaskTemplatePayload {
  /// Tworzy zadanie z szablonu.
  const factory ApplyTaskTemplatePayload({
    required String projectId,
    String? parentTaskId,
    String? customStatusId,
    String? titleOverride,
    ProjectTaskStatus? targetStatus,
  }) = _ApplyTaskTemplatePayload;

  /// Odtwarza payload z JSON.
  factory ApplyTaskTemplatePayload.fromJson(Map<String, dynamic> json) =>
      _$ApplyTaskTemplatePayloadFromJson(json);
}

/// Skrócona odpowiedź szablonu zadania.
@freezed
abstract class TaskTemplateResponse with _$TaskTemplateResponse {
  /// Tworzy odpowiedź szablonu.
  const factory TaskTemplateResponse({
    required String id,
    required String workspaceId,
    required String name,
    required DateTime updatedAtUtc,
    required int version,
    @Default(false) bool isDefaultForCurrentUser,
  }) = _TaskTemplateResponse;

  /// Odtwarza szablon z JSON.
  factory TaskTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskTemplateResponseFromJson(json);
}

/// Payload utworzenia kompletnej rozety zadania bez tytułu i opisu zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateTaskTemplateDefinitionPayload
    with _$CreateTaskTemplateDefinitionPayload {
  const factory CreateTaskTemplateDefinitionPayload({
    required String name,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    String? taskType,
    int? size,
    int? complexity,
    int? risk,
    int? businessValue,
    int? estimatedMinutes,
    List<String>? assigneeUserIds,
    List<String>? checklistItems,
    List<String>? acceptanceCriteria,
    List<TaskTemplateLabelResponse>? labels,
    List<TaskTemplateCustomFieldValueResponse>? customFieldValues,
    TaskTemplateCustomStatusResponse? customStatus,
    @JsonKey(includeIfNull: false) String? title,
    @JsonKey(includeIfNull: false) String? description,
    @JsonKey(includeIfNull: false) String? descriptionDeltaJson,
  }) = _CreateTaskTemplateDefinitionPayload;

  factory CreateTaskTemplateDefinitionPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateTaskTemplateDefinitionPayloadFromJson(json);
}

/// Payload ustawienia domyślnego szablonu użytkownika.
@freezed
abstract class SetDefaultTaskTemplatePayload
    with _$SetDefaultTaskTemplatePayload {
  /// Ustawia albo czyści domyślny szablon.
  const factory SetDefaultTaskTemplatePayload({String? taskTemplateId}) =
      _SetDefaultTaskTemplatePayload;

  /// Odtwarza payload z JSON.
  factory SetDefaultTaskTemplatePayload.fromJson(Map<String, dynamic> json) =>
      _$SetDefaultTaskTemplatePayloadFromJson(json);
}

/// Domyślny szablon zadania użytkownika.
@freezed
abstract class DefaultTaskTemplateResponse with _$DefaultTaskTemplateResponse {
  /// Tworzy odpowiedź ustawienia domyślnego szablonu.
  const factory DefaultTaskTemplateResponse({
    String? taskTemplateId,
    DateTime? updatedAtUtc,
  }) = _DefaultTaskTemplateResponse;

  /// Odtwarza odpowiedź z JSON.
  factory DefaultTaskTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$DefaultTaskTemplateResponseFromJson(json);
}

/// Etykieta zapisana w szablonie.
@freezed
abstract class TaskTemplateLabelResponse with _$TaskTemplateLabelResponse {
  /// Tworzy etykietę szablonu.
  const factory TaskTemplateLabelResponse({
    required String name,
    required String color,
  }) = _TaskTemplateLabelResponse;

  /// Odtwarza etykietę z JSON.
  factory TaskTemplateLabelResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskTemplateLabelResponseFromJson(json);
}

/// Wartość pola customowego zapisana w szablonie.
@freezed
abstract class TaskTemplateCustomFieldValueResponse
    with _$TaskTemplateCustomFieldValueResponse {
  /// Tworzy wartość pola szablonu.
  const factory TaskTemplateCustomFieldValueResponse({
    required String fieldName,
    required TaskCustomFieldType fieldType,
    required Object value,
  }) = _TaskTemplateCustomFieldValueResponse;

  /// Odtwarza wartość z JSON.
  factory TaskTemplateCustomFieldValueResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$TaskTemplateCustomFieldValueResponseFromJson(json);
}

/// Własny status Kanbanu zapisany w szablonie zadania.
@freezed
abstract class TaskTemplateCustomStatusResponse
    with _$TaskTemplateCustomStatusResponse {
  /// Tworzy przenośny opis własnego statusu.
  const factory TaskTemplateCustomStatusResponse({
    required String name,
    required TaskStatusCategory category,
  }) = _TaskTemplateCustomStatusResponse;

  /// Odtwarza status z JSON.
  factory TaskTemplateCustomStatusResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$TaskTemplateCustomStatusResponseFromJson(json);
}

/// Pełne szczegóły szablonu zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TaskTemplateDetailsResponse with _$TaskTemplateDetailsResponse {
  /// Tworzy szczegóły szablonu.
  const factory TaskTemplateDetailsResponse({
    required String id,
    required String name,
    String? title,
    String? description,
    String? descriptionDeltaJson,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    String? taskType,
    int? size,
    int? complexity,
    int? risk,
    int? businessValue,
    int? estimatedMinutes,
    required List<String> assigneeUserIds,
    required List<String> checklistItems,
    required List<String> acceptanceCriteria,
    required List<TaskTemplateLabelResponse> labels,
    required List<TaskTemplateCustomFieldValueResponse> customFieldValues,
    TaskTemplateCustomStatusResponse? customStatus,
    required DateTime updatedAtUtc,
    required int version,
  }) = _TaskTemplateDetailsResponse;

  /// Odtwarza szczegóły z JSON.
  factory TaskTemplateDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskTemplateDetailsResponseFromJson(json);
}

/// Payload pełnej aktualizacji szablonu zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateTaskTemplatePayload with _$UpdateTaskTemplatePayload {
  /// Tworzy nowe ustawienia szablonu.
  const factory UpdateTaskTemplatePayload({
    required String name,
    required ProjectTaskStatus status,
    required TaskPriority priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    String? taskType,
    int? size,
    int? complexity,
    int? risk,
    int? businessValue,
    int? estimatedMinutes,
    List<String>? assigneeUserIds,
    List<String>? checklistItems,
    List<String>? acceptanceCriteria,
    List<TaskTemplateLabelResponse>? labels,
    List<TaskTemplateCustomFieldValueResponse>? customFieldValues,
    TaskTemplateCustomStatusResponse? customStatus,
    @Default(false) bool clearCustomStatus,
    required int expectedVersion,
    @JsonKey(includeIfNull: false) String? title,
    @JsonKey(includeIfNull: false) String? description,
    @JsonKey(includeIfNull: false) String? descriptionDeltaJson,
  }) = _UpdateTaskTemplatePayload;

  /// Odtwarza payload z JSON.
  factory UpdateTaskTemplatePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskTemplatePayloadFromJson(json);
}
