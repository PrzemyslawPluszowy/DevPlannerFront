import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_mutation_models.freezed.dart';
part 'task_mutation_models.g.dart';

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
    required List<String> userIds,
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
