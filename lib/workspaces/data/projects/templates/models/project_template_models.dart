import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/projects/responses/project_response.dart';

part 'project_template_models.freezed.dart';
part 'project_template_models.g.dart';

/// Payload utworzenia szablonu projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateProjectTemplatePayload
    with _$CreateProjectTemplatePayload {
  /// Tworzy dane zgodne z `CreateProjectTemplateRequest`.
  const factory CreateProjectTemplatePayload({
    /// Nazwa szablonu.
    required String name,
  }) = _CreateProjectTemplatePayload;

  /// Odtwarza payload z JSON.
  factory CreateProjectTemplatePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectTemplatePayloadFromJson(json);
}

/// Payload utworzenia projektu z szablonu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ApplyProjectTemplatePayload with _$ApplyProjectTemplatePayload {
  /// Tworzy dane zgodne z `ApplyProjectTemplateRequest`.
  const factory ApplyProjectTemplatePayload({
    /// Nazwa nowego projektu.
    required String name,
  }) = _ApplyProjectTemplatePayload;

  /// Odtwarza payload z JSON.
  factory ApplyProjectTemplatePayload.fromJson(Map<String, dynamic> json) =>
      _$ApplyProjectTemplatePayloadFromJson(json);
}

/// Payload odświeżenia szablonu z aktualnego projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class RefreshProjectTemplatePayload
    with _$RefreshProjectTemplatePayload {
  /// Tworzy dane zgodne z `RefreshProjectTemplateRequest`.
  const factory RefreshProjectTemplatePayload({
    /// Nowa nazwa szablonu.
    required String name,

    /// Oczekiwana wersja szablonu.
    required int expectedVersion,
  }) = _RefreshProjectTemplatePayload;

  /// Odtwarza payload z JSON.
  factory RefreshProjectTemplatePayload.fromJson(Map<String, dynamic> json) =>
      _$RefreshProjectTemplatePayloadFromJson(json);
}

/// Skrócona odpowiedź szablonu projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTemplateResponse with _$ProjectTemplateResponse {
  /// Tworzy odpowiedź zgodną z `ProjectTemplateResponse`.
  const factory ProjectTemplateResponse({
    /// UUID szablonu.
    required String id,

    /// Nazwa szablonu.
    required String name,

    /// Czas ostatniej aktualizacji.
    required DateTime updatedAtUtc,

    /// Wersja szablonu.
    required int version,
  }) = _ProjectTemplateResponse;

  /// Odtwarza szablon z JSON.
  factory ProjectTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTemplateResponseFromJson(json);
}

/// Mapowanie identyfikatora źródłowego na utworzony identyfikator.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class TemplateIdMappingResponse with _$TemplateIdMappingResponse {
  /// Tworzy mapowanie identyfikatorów.
  const factory TemplateIdMappingResponse({
    /// UUID elementu ze źródłowego szablonu.
    required String sourceId,

    /// UUID nowo utworzonego elementu.
    required String createdId,
  }) = _TemplateIdMappingResponse;

  /// Odtwarza mapowanie z JSON.
  factory TemplateIdMappingResponse.fromJson(Map<String, dynamic> json) =>
      _$TemplateIdMappingResponseFromJson(json);
}

/// Status workflow zapisany w szablonie.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTemplateWorkflowResponse
    with _$ProjectTemplateWorkflowResponse {
  /// Tworzy status workflow.
  const factory ProjectTemplateWorkflowResponse({
    /// Klucz statusu.
    required String status,

    /// Nazwa statusu.
    required String name,

    /// Kolor statusu.
    required String color,

    /// Pozycja statusu.
    required int position,

    /// Czy status początkowy.
    required bool isInitial,

    /// Czy status końcowy.
    required bool isTerminal,
  }) = _ProjectTemplateWorkflowResponse;

  /// Odtwarza status workflow z JSON.
  factory ProjectTemplateWorkflowResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTemplateWorkflowResponseFromJson(json);
}

/// Przejście pomiędzy statusami workflow.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTemplateTransitionResponse
    with _$ProjectTemplateTransitionResponse {
  /// Tworzy przejście workflow.
  const factory ProjectTemplateTransitionResponse({
    /// Status źródłowy.
    required String from,

    /// Status docelowy.
    required String to,
  }) = _ProjectTemplateTransitionResponse;

  /// Odtwarza przejście z JSON.
  factory ProjectTemplateTransitionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTemplateTransitionResponseFromJson(json);
}

/// Definicja elementu konfiguracyjnego szablonu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTemplateDefinitionResponse
    with _$ProjectTemplateDefinitionResponse {
  /// Tworzy definicję elementu szablonu.
  const factory ProjectTemplateDefinitionResponse({
    /// UUID źródłowy.
    required String sourceId,

    /// Nazwa elementu.
    required String name,

    /// Typ elementu.
    required String type,

    /// Kolor albo null.
    String? color,

    /// Czy element jest wymagany.
    @JsonKey(name: 'required') bool? isRequired,

    /// Pozycja albo null.
    int? position,

    /// Opcje pola albo null.
    List<String>? options,
  }) = _ProjectTemplateDefinitionResponse;

  /// Odtwarza definicję z JSON.
  factory ProjectTemplateDefinitionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTemplateDefinitionResponseFromJson(json);
}

/// Wartość pola customowego w zadaniu szablonu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTemplateTaskCustomValueResponse
    with _$ProjectTemplateTaskCustomValueResponse {
  /// Tworzy wartość pola customowego.
  const factory ProjectTemplateTaskCustomValueResponse({
    /// UUID definicji pola ze źródłowego szablonu.
    required String fieldSourceId,

    /// Dowolna wartość JSON pola.
    required Object? value,
  }) = _ProjectTemplateTaskCustomValueResponse;

  /// Odtwarza wartość pola z JSON.
  factory ProjectTemplateTaskCustomValueResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTemplateTaskCustomValueResponseFromJson(json);
}

/// Własna kolumna Kanbanu zapisana w szablonie projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTemplateCustomStatusResponse
    with _$ProjectTemplateCustomStatusResponse {
  /// Tworzy własny status workflow szablonu.
  const factory ProjectTemplateCustomStatusResponse({
    /// UUID statusu w projekcie źródłowym.
    required String sourceId,

    /// Nazwa kolumny.
    required String name,

    /// Kolor HEX kolumny.
    required String color,

    /// Kategoria analityczna statusu.
    required String category,

    /// Pozycja kolumny.
    required int position,

    /// Limit WIP albo null.
    int? wipLimit,

    /// Czy kolumna jest domyślna dla nowych zadań.
    required bool isDefault,
  }) = _ProjectTemplateCustomStatusResponse;

  /// Odtwarza kolumnę szablonu z JSON.
  factory ProjectTemplateCustomStatusResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTemplateCustomStatusResponseFromJson(json);
}

/// Pełny podgląd zadania zapisanego w szablonie.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTemplateTaskResponse with _$ProjectTemplateTaskResponse {
  /// Tworzy zadanie szablonu.
  const factory ProjectTemplateTaskResponse({
    /// UUID źródłowy zadania.
    required String sourceId,

    /// UUID źródłowego zadania nadrzędnego albo null.
    String? parentSourceId,

    /// Tytuł zadania.
    required String title,

    /// Opis albo null.
    String? description,

    /// Quill Delta JSON albo null.
    String? descriptionDeltaJson,

    /// Status zapisany w szablonie.
    required String status,

    /// Priorytet zapisany w szablonie.
    required String priority,

    /// Typ zadania albo null.
    String? taskType,

    /// Rozmiar albo null.
    int? size,

    /// Złożoność albo null.
    int? complexity,

    /// Ryzyko albo null.
    int? risk,

    /// Wartość biznesowa albo null.
    int? businessValue,

    /// Szacowany czas w minutach albo null.
    int? estimatedMinutes,

    /// Początek zadania albo null.
    DateTime? startAtUtc,

    /// Termin zadania albo null.
    DateTime? dueAtUtc,

    /// Pozycja zadania.
    required int position,

    /// Pozycje checklisty.
    required List<String> checklist,

    /// Kryteria akceptacji.
    required List<String> acceptanceCriteria,

    /// UUID-y źródłowe etykiet.
    required List<String> labelSourceIds,

    /// UUID własnego statusu ze źródłowego projektu albo null.
    String? customStatusSourceId,

    /// Wartości pól customowych.
    required List<ProjectTemplateTaskCustomValueResponse> customFieldValues,
  }) = _ProjectTemplateTaskResponse;

  /// Odtwarza zadanie szablonu z JSON.
  factory ProjectTemplateTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectTemplateTaskResponseFromJson(json);
}

/// Pełne szczegóły szablonu projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ProjectTemplateDetailsResponse
    with _$ProjectTemplateDetailsResponse {
  /// Tworzy pełne szczegóły szablonu.
  const factory ProjectTemplateDetailsResponse({
    /// UUID szablonu.
    required String id,

    /// Nazwa szablonu.
    required String name,

    /// Opis albo null.
    String? description,

    /// Ikona albo null.
    String? icon,

    /// Kolor główny albo null.
    String? primaryColor,

    /// Widoczność projektu zapisana jako tekst kontraktu C#.
    required String visibility,

    /// Status projektu zapisany jako tekst kontraktu C#.
    required String status,

    /// Statusy workflow.
    required List<ProjectTemplateWorkflowResponse> workflow,

    /// Przejścia workflow.
    required List<ProjectTemplateTransitionResponse> transitions,

    /// Własne kolumny Kanbanu projektu.
    List<ProjectTemplateCustomStatusResponse>? customStatuses,

    /// Etykiety szablonu.
    required List<ProjectTemplateDefinitionResponse> labels,

    /// Pola customowe szablonu.
    required List<ProjectTemplateDefinitionResponse> customFields,

    /// Zadania szablonu.
    required List<ProjectTemplateTaskResponse> tasks,

    /// Czas aktualizacji.
    required DateTime updatedAtUtc,

    /// Wersja szablonu.
    required int version,
  }) = _ProjectTemplateDetailsResponse;

  /// Odtwarza szczegóły szablonu z JSON.
  factory ProjectTemplateDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ProjectTemplateDetailsResponseFromJson(json);
}

/// Wynik zastosowania szablonu projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ApplyProjectTemplateResponse
    with _$ApplyProjectTemplateResponse {
  /// Tworzy odpowiedź zgodną z `ApplyProjectTemplateResponse`.
  const factory ApplyProjectTemplateResponse({
    /// Utworzony projekt.
    required ProjectResponse project,

    /// Mapowanie zadań źródłowych na nowe.
    required List<TemplateIdMappingResponse> taskIdMappings,

    /// Mapowanie etykiet źródłowych na nowe.
    required List<TemplateIdMappingResponse> labelIdMappings,

    /// Mapowanie pól customowych źródłowych na nowe.
    required List<TemplateIdMappingResponse> customFieldIdMappings,

    /// Mapowanie własnych statusów Kanbanu źródłowych na nowe.
    List<TemplateIdMappingResponse>? customStatusIdMappings,
  }) = _ApplyProjectTemplateResponse;

  /// Odtwarza wynik zastosowania szablonu z JSON.
  factory ApplyProjectTemplateResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ApplyProjectTemplateResponseFromJson(json);
}
