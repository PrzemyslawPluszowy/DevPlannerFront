import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/whiteboard_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whiteboard_models.freezed.dart';
part 'whiteboard_models.g.dart';

/// Payload utworzenia whiteboardu.
@freezed
abstract class CreateWhiteboardPayload with _$CreateWhiteboardPayload {
  /// Definiuje nazwę, opis i typ tablicy.
  const factory CreateWhiteboardPayload({
    required String name,
    String? description,
    @Default('Canvas') String type,
  }) = _CreateWhiteboardPayload;

  /// Odtwarza payload z JSON.
  factory CreateWhiteboardPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateWhiteboardPayloadFromJson(json);
}

/// Payload aktualizacji metadanych whiteboardu.
@freezed
abstract class UpdateWhiteboardPayload with _$UpdateWhiteboardPayload {
  /// Przekazuje nazwę, opis i wersję.
  const factory UpdateWhiteboardPayload({
    required String name,
    String? description,
    required int expectedVersion,
  }) = _UpdateWhiteboardPayload;

  /// Odtwarza payload z JSON.
  factory UpdateWhiteboardPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateWhiteboardPayloadFromJson(json);
}

/// Payload utworzenia strony whiteboardu.
@freezed
abstract class CreateWhiteboardPagePayload with _$CreateWhiteboardPagePayload {
  /// Definiuje nazwę, orientację i pozycję strony.
  const factory CreateWhiteboardPagePayload({
    required String name,
    @Default('Portrait') String orientation,
    @Default('A4') String pageFormat,
    int? position,
    String? clientOperationId,
  }) = _CreateWhiteboardPagePayload;

  /// Odtwarza payload z JSON.
  factory CreateWhiteboardPagePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateWhiteboardPagePayloadFromJson(json);
}

/// Payload aktualizacji strony whiteboardu.
@freezed
abstract class UpdateWhiteboardPagePayload with _$UpdateWhiteboardPagePayload {
  /// Przekazuje nazwę, orientację i wersję strony.
  const factory UpdateWhiteboardPagePayload({
    required String name,
    required String orientation,
    required int expectedVersion,
  }) = _UpdateWhiteboardPagePayload;

  /// Odtwarza payload z JSON.
  factory UpdateWhiteboardPagePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateWhiteboardPagePayloadFromJson(json);
}

/// Punkt geometrii whiteboardu.
@freezed
abstract class WhiteboardPoint with _$WhiteboardPoint {
  /// Tworzy punkt X/Y.
  const factory WhiteboardPoint({required double x, required double y}) =
      _WhiteboardPoint;

  /// Odtwarza punkt z JSON.
  factory WhiteboardPoint.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardPointFromJson(json);
}

/// Geometria konektora pomiędzy obiektami.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardConnectorGeometry with _$WhiteboardConnectorGeometry {
  /// Przekazuje końce i punkty kontrolne krzywej.
  const factory WhiteboardConnectorGeometry({
    required String sourceObjectId,
    required String targetObjectId,
    String? sourcePort,
    String? targetPort,
    required List<WhiteboardPoint> controlPoints,
    @Default('FilledArrow') String endCap,
  }) = _WhiteboardConnectorGeometry;

  /// Odtwarza geometrię z JSON.
  factory WhiteboardConnectorGeometry.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardConnectorGeometryFromJson(json);
}

/// Payload utworzenia obiektu whiteboardu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateWhiteboardObjectPayload
    with _$CreateWhiteboardObjectPayload {
  /// Przekazuje geometrię, typ i elastyczne dane obiektu.
  const factory CreateWhiteboardObjectPayload({
    required String kind,
    required WhiteboardPoint position,
    required double width,
    required double height,
    required double rotation,
    required Map<String, dynamic> data,
    WhiteboardConnectorGeometry? connector,
    String? pageId,
    String? clientOperationId,
  }) = _CreateWhiteboardObjectPayload;

  /// Odtwarza payload z JSON.
  factory CreateWhiteboardObjectPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateWhiteboardObjectPayloadFromJson(json);
}

/// Payload aktualizacji obiektu whiteboardu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpdateWhiteboardObjectPayload
    with _$UpdateWhiteboardObjectPayload {
  /// Przekazuje nową geometrię, dane i wersję.
  const factory UpdateWhiteboardObjectPayload({
    required WhiteboardPoint position,
    required double width,
    required double height,
    required double rotation,
    required Map<String, dynamic> data,
    WhiteboardConnectorGeometry? connector,
    required int expectedVersion,
  }) = _UpdateWhiteboardObjectPayload;

  /// Odtwarza payload z JSON.
  factory UpdateWhiteboardObjectPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateWhiteboardObjectPayloadFromJson(json);
}

/// Operacja offline queue whiteboardu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardOperation with _$WhiteboardOperation {
  /// Przekazuje typ operacji, obiekt i elastyczny payload.
  const factory WhiteboardOperation({
    required String operationId,
    required String kind,
    String? objectId,
    required Map<String, dynamic> payload,
  }) = _WhiteboardOperation;

  /// Odtwarza operację z JSON.
  factory WhiteboardOperation.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardOperationFromJson(json);
}

/// Payload atomowego batcha operacji whiteboardu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ApplyWhiteboardOperationsPayload
    with _$ApplyWhiteboardOperationsPayload {
  /// Przekazuje wersję bazową i operacje klienta.
  const factory ApplyWhiteboardOperationsPayload({
    required int baseVersion,
    required List<WhiteboardOperation> operations,
  }) = _ApplyWhiteboardOperationsPayload;

  /// Odtwarza payload z JSON.
  factory ApplyWhiteboardOperationsPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$ApplyWhiteboardOperationsPayloadFromJson(json);
}

/// Skrót whiteboardu na liście projektu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardSummaryResponse with _$WhiteboardSummaryResponse {
  /// Zawiera nazwę, typ i wersję whiteboardu.
  const factory WhiteboardSummaryResponse({
    required String id,
    required String projectId,
    required String name,
    String? description,
    required String type,
    required int version,
    required DateTime updatedAtUtc,
    String? taskId,
    Map<String, dynamic>? taskMetadata,
  }) = _WhiteboardSummaryResponse;

  /// Odtwarza skrót z JSON.
  factory WhiteboardSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardSummaryResponseFromJson(json);
}

/// Pełny whiteboard z metadanymi klienta.
@freezed
abstract class WhiteboardResponse with _$WhiteboardResponse {
  /// Zawiera zakres, wersję i cursor zmian.
  const factory WhiteboardResponse({
    required String id,
    required String workspaceId,
    required String projectId,
    required String name,
    String? description,
    required String type,
    required int version,
    String? currentCursor,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
  }) = _WhiteboardResponse;

  /// Odtwarza whiteboard z JSON.
  factory WhiteboardResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardResponseFromJson(json);
}

/// Strona whiteboardu.
@freezed
abstract class WhiteboardPageResponse with _$WhiteboardPageResponse {
  /// Zawiera nazwę, format, pozycję i wersję strony.
  const factory WhiteboardPageResponse({
    required String id,
    required String whiteboardId,
    required String name,
    required String orientation,
    required String pageFormat,
    required int position,
    required int version,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
  }) = _WhiteboardPageResponse;

  /// Odtwarza stronę z JSON.
  factory WhiteboardPageResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardPageResponseFromJson(json);
}

/// Obiekt canvasu lub strony A4.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardObjectResponse with _$WhiteboardObjectResponse {
  /// Zawiera geometrię, dane i wersję obiektu.
  const factory WhiteboardObjectResponse({
    required String id,
    required String whiteboardId,
    String? pageId,
    required String kind,
    required WhiteboardPoint position,
    required double width,
    required double height,
    required double rotation,
    required Map<String, dynamic> data,
    WhiteboardConnectorGeometry? connector,
    required int version,
    required DateTime updatedAtUtc,
    String? taskId,
    Map<String, dynamic>? taskMetadata,
  }) = _WhiteboardObjectResponse;

  /// Odtwarza obiekt z JSON.
  factory WhiteboardObjectResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardObjectResponseFromJson(json);
}

/// Wynik powiązania Sticky Note z zadaniem.
@freezed
abstract class StickyNoteTaskResponse with _$StickyNoteTaskResponse {
  /// Zwraca kartę, zadanie i stan idempotentnego retry.
  const factory StickyNoteTaskResponse({
    required String objectId,
    required String taskId,
    required String title,
    required String status,
    required String priority,
    required bool alreadyLinked,
    required int objectVersion,
    required DateTime updatedAtUtc,
  }) = _StickyNoteTaskResponse;

  /// Odtwarza wynik z JSON.
  factory StickyNoteTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$StickyNoteTaskResponseFromJson(json);
}

/// Payload utworzenia zadania ze Sticky Note.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CreateTaskFromStickyNotePayload
    with _$CreateTaskFromStickyNotePayload {
  /// Opcjonalnie nadpisuje tytuł, opis, priorytet, termin i wykonawców.
  const factory CreateTaskFromStickyNotePayload({
    String? title,
    String? description,
    @Default(TaskPriority.normal) TaskPriority priority,
    DateTime? dueAtUtc,
    List<String>? assigneeUserIds,
  }) = _CreateTaskFromStickyNotePayload;

  /// Odtwarza payload z JSON.
  factory CreateTaskFromStickyNotePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskFromStickyNotePayloadFromJson(json);
}

/// Payload masowej konwersji Sticky Notes.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkCreateTasksFromStickyNotesPayload
    with _$BulkCreateTasksFromStickyNotesPayload {
  /// Przekazuje obiekty oraz wspólne dane nowych zadań.
  const factory BulkCreateTasksFromStickyNotesPayload({
    required List<String> objectIds,
    String? description,
    @Default(TaskPriority.normal) TaskPriority priority,
    DateTime? dueAtUtc,
    List<String>? assigneeUserIds,
  }) = _BulkCreateTasksFromStickyNotesPayload;

  /// Odtwarza payload z JSON.
  factory BulkCreateTasksFromStickyNotesPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$BulkCreateTasksFromStickyNotesPayloadFromJson(json);
}

/// Wynik masowej konwersji Sticky Notes.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class BulkCreateTasksFromStickyNotesResponse
    with _$BulkCreateTasksFromStickyNotesResponse {
  /// Zwraca wyniki w kolejności wejściowej i liczniki.
  const factory BulkCreateTasksFromStickyNotesResponse({
    required List<StickyNoteTaskResponse> items,
    required int createdCount,
    required int alreadyLinkedCount,
  }) = _BulkCreateTasksFromStickyNotesResponse;

  /// Odtwarza wynik z JSON.
  factory BulkCreateTasksFromStickyNotesResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$BulkCreateTasksFromStickyNotesResponseFromJson(json);
}

/// Snapshot whiteboardu do pełnego odtworzenia stanu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardSnapshotResponse with _$WhiteboardSnapshotResponse {
  /// Zwraca metadane, strony, obiekty i cursor resync.
  const factory WhiteboardSnapshotResponse({
    required WhiteboardResponse whiteboard,
    required List<WhiteboardPageResponse> pages,
    required List<WhiteboardObjectResponse> objects,
    String? nextCursor,
    required bool resyncRequired,
  }) = _WhiteboardSnapshotResponse;

  /// Odtwarza snapshot z JSON.
  factory WhiteboardSnapshotResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardSnapshotResponseFromJson(json);
}

/// Zdarzenie logu zmian whiteboardu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardEventResponse with _$WhiteboardEventResponse {
  /// Zawiera stabilne identyfikatory, wersję i payload zdarzenia.
  const factory WhiteboardEventResponse({
    required String eventId,
    required String operationId,
    required int version,
    required String eventType,
    String? pageId,
    String? objectId,
    required Map<String, dynamic> payload,
    required DateTime createdAtUtc,
  }) = _WhiteboardEventResponse;

  /// Odtwarza zdarzenie z JSON.
  factory WhiteboardEventResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardEventResponseFromJson(json);
}

/// Wynik zastosowania operacji whiteboardu.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ApplyWhiteboardOperationsResponse
    with _$ApplyWhiteboardOperationsResponse {
  /// Zwraca nową wersję, cursor i zastosowane operation ID.
  const factory ApplyWhiteboardOperationsResponse({
    required int version,
    String? cursor,
    required List<String> appliedOperationIds,
  }) = _ApplyWhiteboardOperationsResponse;

  /// Odtwarza wynik z JSON.
  factory ApplyWhiteboardOperationsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ApplyWhiteboardOperationsResponseFromJson(json);
}

/// Systemowy szablon whiteboardu.
@freezed
abstract class WhiteboardTemplateResponse with _$WhiteboardTemplateResponse {
  /// Zawiera identyfikator, opis i liczność szablonu.
  const factory WhiteboardTemplateResponse({
    required String id,
    required String name,
    required String description,
    required String type,
    required int pageCount,
    required int objectCount,
  }) = _WhiteboardTemplateResponse;

  /// Odtwarza szablon z JSON.
  factory WhiteboardTemplateResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardTemplateResponseFromJson(json);
}

/// Payload utworzenia whiteboardu z szablonu.
@freezed
abstract class CreateWhiteboardFromTemplatePayload
    with _$CreateWhiteboardFromTemplatePayload {
  /// Przekazuje szablon, nazwę i opcjonalny opis.
  const factory CreateWhiteboardFromTemplatePayload({
    required String templateId,
    required String name,
    String? description,
  }) = _CreateWhiteboardFromTemplatePayload;

  /// Odtwarza payload z JSON.
  factory CreateWhiteboardFromTemplatePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateWhiteboardFromTemplatePayloadFromJson(json);
}

/// Payload duplikowania whiteboardu.
@freezed
abstract class DuplicateWhiteboardPayload with _$DuplicateWhiteboardPayload {
  /// Określa projekt docelowy i nazwę kopii.
  const factory DuplicateWhiteboardPayload({
    String? targetProjectId,
    String? name,
    String? description,
  }) = _DuplicateWhiteboardPayload;

  /// Odtwarza payload z JSON.
  factory DuplicateWhiteboardPayload.fromJson(Map<String, dynamic> json) =>
      _$DuplicateWhiteboardPayloadFromJson(json);
}

/// Payload eksportu whiteboardu.
@freezed
abstract class CreateWhiteboardExportPayload
    with _$CreateWhiteboardExportPayload {
  /// Przekazuje format, zakres, stronę i viewport.
  const factory CreateWhiteboardExportPayload({
    required WhiteboardExportFormat format,
    required WhiteboardExportScope scope,
    String? pageId,
    WhiteboardExportViewport? viewport,
  }) = _CreateWhiteboardExportPayload;

  /// Odtwarza payload z JSON.
  factory CreateWhiteboardExportPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateWhiteboardExportPayloadFromJson(json);
}

/// Viewport eksportu whiteboardu.
@freezed
abstract class WhiteboardExportViewport with _$WhiteboardExportViewport {
  /// Tworzy prostokąt widoku.
  const factory WhiteboardExportViewport({
    required double x,
    required double y,
    required double width,
    required double height,
  }) = _WhiteboardExportViewport;

  /// Odtwarza viewport z JSON.
  factory WhiteboardExportViewport.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardExportViewportFromJson(json);
}

/// Status joba eksportu whiteboardu.
@freezed
abstract class WhiteboardExportResponse with _$WhiteboardExportResponse {
  /// Zwraca status, format i plik wynikowy.
  const factory WhiteboardExportResponse({
    required String id,
    required WhiteboardExportJobStatus status,
    required WhiteboardExportFormat format,
    required WhiteboardExportScope scope,
    String? storageFileId,
    String? failureCode,
    required DateTime createdAtUtc,
    DateTime? completedAtUtc,
  }) = _WhiteboardExportResponse;

  /// Odtwarza status eksportu z JSON.
  factory WhiteboardExportResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardExportResponseFromJson(json);
}

/// Payload grupowania obiektów przez AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardAiClusterPayload with _$WhiteboardAiClusterPayload {
  /// Wskazuje obiekty i opcjonalny cel grupowania.
  const factory WhiteboardAiClusterPayload({
    required List<String> objectIds,
    String? instruction,
  }) = _WhiteboardAiClusterPayload;

  /// Odtwarza payload z JSON.
  factory WhiteboardAiClusterPayload.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardAiClusterPayloadFromJson(json);
}

/// Payload generowania przepływu przez AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardAiGenerateFlowPayload
    with _$WhiteboardAiGenerateFlowPayload {
  /// Przekazuje instrukcję, stronę i obiekty kontekstowe.
  const factory WhiteboardAiGenerateFlowPayload({
    required String instruction,
    String? pageId,
    List<String>? contextObjectIds,
  }) = _WhiteboardAiGenerateFlowPayload;

  /// Odtwarza payload z JSON.
  factory WhiteboardAiGenerateFlowPayload.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardAiGenerateFlowPayloadFromJson(json);
}

/// Grupa obiektów zwrócona przez AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardAiClusterResponse with _$WhiteboardAiClusterResponse {
  /// Zawiera etykietę i UUID obiektów grupy.
  const factory WhiteboardAiClusterResponse({
    required String clusterId,
    required String label,
    required List<String> objectIds,
  }) = _WhiteboardAiClusterResponse;

  /// Odtwarza grupę z JSON.
  factory WhiteboardAiClusterResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardAiClusterResponseFromJson(json);
}

/// Obiekt wygenerowany przez AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardAiGeneratedObjectResponse
    with _$WhiteboardAiGeneratedObjectResponse {
  /// Zawiera geometrię i dane wygenerowanego obiektu.
  const factory WhiteboardAiGeneratedObjectResponse({
    required String id,
    required String clientId,
    required String kind,
    required WhiteboardPoint position,
    required double width,
    required double height,
    required Map<String, dynamic> data,
  }) = _WhiteboardAiGeneratedObjectResponse;

  /// Odtwarza obiekt z JSON.
  factory WhiteboardAiGeneratedObjectResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$WhiteboardAiGeneratedObjectResponseFromJson(json);
}

/// Konektor wygenerowany przez AI.
@freezed
abstract class WhiteboardAiGeneratedConnectorResponse
    with _$WhiteboardAiGeneratedConnectorResponse {
  /// Zawiera referencje końców i opcjonalną etykietę.
  const factory WhiteboardAiGeneratedConnectorResponse({
    required String id,
    required String sourceClientId,
    required String targetClientId,
    String? label,
  }) = _WhiteboardAiGeneratedConnectorResponse;

  /// Odtwarza konektor z JSON.
  factory WhiteboardAiGeneratedConnectorResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$WhiteboardAiGeneratedConnectorResponseFromJson(json);
}

/// Wspólna odpowiedź operacji AI Whiteboard.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WhiteboardAiOperationResponse
    with _$WhiteboardAiOperationResponse {
  /// Zwraca grupy, wygenerowane obiekty, konektory i ostrzeżenia.
  const factory WhiteboardAiOperationResponse({
    required String operationId,
    required String operationType,
    required String provider,
    required bool idempotentReplay,
    required int boardVersion,
    required List<WhiteboardAiClusterResponse> clusters,
    required List<WhiteboardAiGeneratedObjectResponse> objects,
    required List<WhiteboardAiGeneratedConnectorResponse> connectors,
    required List<String> warnings,
  }) = _WhiteboardAiOperationResponse;

  /// Odtwarza wynik AI z JSON.
  factory WhiteboardAiOperationResponse.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardAiOperationResponseFromJson(json);
}
