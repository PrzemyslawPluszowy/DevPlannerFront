import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_workflow_models.freezed.dart';
part 'custom_workflow_models.g.dart';

/// Własny status/kolumna workflow projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectCustomStatusResponse with _$ProjectCustomStatusResponse {
  /// Tworzy odpowiedź zgodną z `ProjectCustomStatusResponse`.
  const factory ProjectCustomStatusResponse({
    /// UUID statusu.
    required String id,

    /// UUID projektu.
    required String projectId,

    /// Nazwa statusu.
    required String name,

    /// Kolor HEX kolumny.
    required String colorHex,

    /// Kategoria analityczna statusu.
    required TaskStatusCategory category,

    /// Pozycja statusu od zera.
    required int position,

    /// Limit WIP albo null.
    int? wipLimit,

    /// Czy status jest domyślny dla nowych zadań.
    required bool isDefault,

    /// Liczba zadań w statusie.
    required int taskCount,

    /// Wersja optimistic concurrency.
    required int version,
  }) = _ProjectCustomStatusResponse;

  /// Odtwarza status workflow z JSON.
  factory ProjectCustomStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectCustomStatusResponseFromJson(json);
}

/// Payload utworzenia własnego statusu projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateProjectCustomStatusPayload
    with _$CreateProjectCustomStatusPayload {
  /// Tworzy dane zgodne z `CreateProjectCustomStatusRequest`.
  const factory CreateProjectCustomStatusPayload({
    /// Nazwa statusu.
    required String name,

    /// Kolor HEX kolumny.
    required String colorHex,

    /// Kategoria analityczna.
    required TaskStatusCategory category,

    /// Pozycja od zera albo null.
    int? position,

    /// Limit WIP albo null.
    int? wipLimit,

    /// Czy status jest domyślny.
    @Default(false) bool isDefault,
  }) = _CreateProjectCustomStatusPayload;

  /// Odtwarza payload z JSON.
  factory CreateProjectCustomStatusPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateProjectCustomStatusPayloadFromJson(json);
}

/// Payload aktualizacji własnego statusu projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateProjectCustomStatusPayload
    with _$UpdateProjectCustomStatusPayload {
  /// Tworzy dane zgodne z `UpdateProjectCustomStatusRequest`.
  const factory UpdateProjectCustomStatusPayload({
    /// Nowa nazwa statusu.
    required String name,

    /// Nowy kolor HEX.
    required String colorHex,

    /// Nowa kategoria analityczna.
    required TaskStatusCategory category,

    /// Nowy limit WIP albo null.
    int? wipLimit,

    /// Czy status ma być domyślny.
    required bool isDefault,

    /// Oczekiwana wersja statusu.
    required int expectedVersion,
  }) = _UpdateProjectCustomStatusPayload;

  /// Odtwarza payload z JSON.
  factory UpdateProjectCustomStatusPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateProjectCustomStatusPayloadFromJson(json);
}

/// Payload pełnej kolejności własnych statusów.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ReorderProjectCustomStatusesPayload
    with _$ReorderProjectCustomStatusesPayload {
  /// Tworzy dane zgodne z `ReorderProjectCustomStatusesRequest`.
  const factory ReorderProjectCustomStatusesPayload({
    /// UUID-y statusów w nowej kolejności.
    required List<String> statusIds,
  }) = _ReorderProjectCustomStatusesPayload;

  /// Odtwarza payload z JSON.
  factory ReorderProjectCustomStatusesPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$ReorderProjectCustomStatusesPayloadFromJson(json);
}

/// Payload archiwizacji statusu z docelowym statusem zastępczym.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class DeleteProjectCustomStatusPayload
    with _$DeleteProjectCustomStatusPayload {
  /// Tworzy dane zgodne z `DeleteProjectCustomStatusRequest`.
  const factory DeleteProjectCustomStatusPayload({
    /// UUID statusu, do którego zostaną przeniesione zadania.
    required String fallbackStatusId,

    /// Oczekiwana wersja archiwizowanego statusu.
    required int expectedVersion,
  }) = _DeleteProjectCustomStatusPayload;

  /// Odtwarza payload z JSON.
  factory DeleteProjectCustomStatusPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$DeleteProjectCustomStatusPayloadFromJson(json);
}

/// Payload zastosowania gotowego szablonu workflow.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ApplyWorkflowTemplatePayload
    with _$ApplyWorkflowTemplatePayload {
  /// Tworzy dane zgodne z `ApplyWorkflowTemplateRequest`.
  const factory ApplyWorkflowTemplatePayload({
    /// Klucz szablonu workflow.
    required String templateKey,

    /// Czy zastąpić istniejący workflow.
    @Default(false) bool replaceExisting,
  }) = _ApplyWorkflowTemplatePayload;

  /// Odtwarza payload z JSON.
  factory ApplyWorkflowTemplatePayload.fromJson(Map<String, dynamic> json) =>
      _$ApplyWorkflowTemplatePayloadFromJson(json);
}

/// Skrót gotowego szablonu workflow.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WorkflowTemplateSummary with _$WorkflowTemplateSummary {
  /// Tworzy skrót szablonu workflow.
  const factory WorkflowTemplateSummary({
    /// Stabilny klucz szablonu.
    required String key,

    /// Nazwa szablonu.
    required String name,

    /// Nazwy statusów w szablonie.
    required List<String> statusNames,
  }) = _WorkflowTemplateSummary;

  /// Odtwarza skrót z JSON.
  factory WorkflowTemplateSummary.fromJson(Map<String, dynamic> json) =>
      _$WorkflowTemplateSummaryFromJson(json);
}

/// Bezpieczna odpowiedź pustej mutacji administracyjnej.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AdminMutationResponse with _$AdminMutationResponse {
  /// Tworzy odpowiedź operacji administracyjnej.
  const factory AdminMutationResponse({
    /// Stabilny komunikat operacji.
    String? message,
  }) = _AdminMutationResponse;

  /// Odtwarza odpowiedź z JSON.
  factory AdminMutationResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminMutationResponseFromJson(json);
}
