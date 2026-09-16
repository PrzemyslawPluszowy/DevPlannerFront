import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';

part 'wiki_models.freezed.dart';
part 'wiki_models.g.dart';

/// Payload utworzenia strony Wiki.
@freezed
abstract class CreateWikiPagePayload with _$CreateWikiPagePayload {
  /// Definiuje rodzica, tytuł, treść i pozycję strony.
  const factory CreateWikiPagePayload({
    String? parentPageId,
    required String title,
    String? iconEmoji,
    String? coverImageFileId,
    required String contentJson,
    int? position,
  }) = _CreateWikiPagePayload;

  /// Odtwarza payload z JSON.
  factory CreateWikiPagePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateWikiPagePayloadFromJson(json);
}

/// Payload częściowej aktualizacji strony Wiki.
@freezed
abstract class UpdateWikiPagePayload with _$UpdateWikiPagePayload {
  /// Zawiera zmieniane pola i wymaganą wersję strony.
  const factory UpdateWikiPagePayload({
    String? title,
    String? iconEmoji,
    String? coverImageFileId,
    String? contentJson,
    required int expectedVersion,
    @Default(false) bool clearIconEmoji,
    @Default(false) bool clearCoverImage,
  }) = _UpdateWikiPagePayload;

  /// Odtwarza payload z JSON.
  factory UpdateWikiPagePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateWikiPagePayloadFromJson(json);
}

/// Payload przeniesienia strony w drzewie Wiki.
@freezed
abstract class MoveWikiPagePayload with _$MoveWikiPagePayload {
  /// Określa nowego rodzica, pozycję i wersję.
  const factory MoveWikiPagePayload({
    String? parentPageId,
    required int position,
    required int expectedVersion,
  }) = _MoveWikiPagePayload;

  /// Odtwarza payload z JSON.
  factory MoveWikiPagePayload.fromJson(Map<String, dynamic> json) =>
      _$MoveWikiPagePayloadFromJson(json);
}

/// Payload przywrócenia rewizji Wiki.
@freezed
abstract class RestoreWikiPagePayload with _$RestoreWikiPagePayload {
  /// Określa bieżącą wersję wymaganą do przywrócenia.
  const factory RestoreWikiPagePayload({required int expectedVersion}) =
      _RestoreWikiPagePayload;

  /// Odtwarza payload z JSON.
  factory RestoreWikiPagePayload.fromJson(Map<String, dynamic> json) =>
      _$RestoreWikiPagePayloadFromJson(json);
}

/// Płaski węzeł drzewa Wiki.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WikiPageTreeNodeResponse with _$WikiPageTreeNodeResponse {
  /// Zawiera stronę i zagnieżdżone podstrony.
  const factory WikiPageTreeNodeResponse({
    required String id,
    String? parentPageId,
    required String title,
    String? iconEmoji,
    required int position,
    required bool isVerified,
    required List<WikiPageTreeNodeResponse> children,
  }) = _WikiPageTreeNodeResponse;

  /// Odtwarza węzeł z JSON.
  factory WikiPageTreeNodeResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiPageTreeNodeResponseFromJson(json);
}

/// Pełna strona Wiki wraz z treścią.
@freezed
abstract class WikiPageResponse with _$WikiPageResponse {
  /// Zawiera zakres, metadane, treść i wersję biznesową strony.
  const factory WikiPageResponse({
    required String id,
    required String workspaceId,
    String? projectId,
    String? parentPageId,
    required String createdByUserId,
    required String title,
    String? iconEmoji,
    String? coverImageFileId,
    required String contentJson,
    required int position,
    required bool isVerified,
    String? verifiedByUserId,
    DateTime? verifiedAtUtc,
    required int version,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
  }) = _WikiPageResponse;

  /// Odtwarza stronę z JSON.
  factory WikiPageResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiPageResponseFromJson(json);
}

/// Skrót rewizji strony Wiki.
@freezed
abstract class WikiPageRevisionSummaryResponse
    with _$WikiPageRevisionSummaryResponse {
  /// Zawiera metadane snapshotu rewizji.
  const factory WikiPageRevisionSummaryResponse({
    required String id,
    required String pageId,
    required int version,
    required String createdByUserId,
    required String title,
    required String snapshotSha256,
    String? changeSummary,
    required DateTime createdAtUtc,
  }) = _WikiPageRevisionSummaryResponse;

  /// Odtwarza skrót z JSON.
  factory WikiPageRevisionSummaryResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$WikiPageRevisionSummaryResponseFromJson(json);
}

/// Pełna rewizja strony Wiki wraz ze snapshotem treści.
@freezed
abstract class WikiPageRevisionResponse with _$WikiPageRevisionResponse {
  /// Zawiera niezmienny snapshot strony.
  const factory WikiPageRevisionResponse({
    required String id,
    required String pageId,
    required int version,
    required String createdByUserId,
    required String title,
    required String snapshotJson,
    required String snapshotSha256,
    String? changeSummary,
    required DateTime createdAtUtc,
  }) = _WikiPageRevisionResponse;

  /// Odtwarza rewizję z JSON.
  factory WikiPageRevisionResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiPageRevisionResponseFromJson(json);
}

/// Pojedyncza zmiana diffu JSON dwóch rewizji.
@freezed
abstract class WikiRevisionDiffChangeResponse
    with _$WikiRevisionDiffChangeResponse {
  /// Zawiera ścieżkę i wartości przed/po zmianie.
  const factory WikiRevisionDiffChangeResponse({
    required String path,
    required String changeType,
    String? fromJson,

    /// Wartość pola `toJson` z kontraktu diffu. Nazwa Dartowa nie może
    /// kolidować z generowaną metodą serializacji `toJson()` Freezed.
    @JsonKey(name: 'toJson') String? toJsonValue,
  }) = _WikiRevisionDiffChangeResponse;

  /// Odtwarza zmianę z JSON.
  factory WikiRevisionDiffChangeResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiRevisionDiffChangeResponseFromJson(json);
}

/// Wynik porównania dwóch rewizji Wiki.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WikiPageRevisionDiffResponse
    with _$WikiPageRevisionDiffResponse {
  /// Zawiera metadane obu rewizji i listę zmian treści.
  const factory WikiPageRevisionDiffResponse({
    required String pageId,
    required String fromRevisionId,
    required int fromVersion,
    required String fromTitle,
    required DateTime fromCreatedAtUtc,
    required String toRevisionId,
    required int toVersion,
    required String toTitle,
    required DateTime toCreatedAtUtc,
    required bool titleChanged,
    required List<WikiRevisionDiffChangeResponse> contentChanges,
    required bool isIdentical,
  }) = _WikiPageRevisionDiffResponse;

  /// Odtwarza diff z JSON.
  factory WikiPageRevisionDiffResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiPageRevisionDiffResponseFromJson(json);
}

/// Payload konwersji zaznaczenia Wiki do zadania.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ConvertWikiSelectionToTaskPayload
    with _$ConvertWikiSelectionToTaskPayload {
  /// Przekazuje zaznaczenie, opcjonalny blok i dane zadania.
  const factory ConvertWikiSelectionToTaskPayload({
    required String selectionText,
    String? blockId,
    int? textStart,
    int? textEnd,
    String? title,
    String? description,
    @Default(TaskPriority.normal) TaskPriority priority,
    DateTime? dueAtUtc,
    List<String>? checklistItems,
  }) = _ConvertWikiSelectionToTaskPayload;

  /// Odtwarza payload z JSON.
  factory ConvertWikiSelectionToTaskPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$ConvertWikiSelectionToTaskPayloadFromJson(json);
}

/// Minimalna referencja zadania w backlinku Wiki.
@freezed
abstract class WikiProjectTaskReferenceResponse
    with _$WikiProjectTaskReferenceResponse {
  /// Zawiera numer, klucz, tytuł, status i wersję zadania.
  const factory WikiProjectTaskReferenceResponse({
    required String id,
    required int number,
    required String key,
    required String title,
    required String status,
    DateTime? archivedAtUtc,
    required int version,
  }) = _WikiProjectTaskReferenceResponse;

  /// Odtwarza referencję z JSON.
  factory WikiProjectTaskReferenceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$WikiProjectTaskReferenceResponseFromJson(json);
}

/// Backlink strony Wiki do zadania projektu.
@freezed
abstract class WikiPageTaskLinkResponse with _$WikiPageTaskLinkResponse {
  /// Zawiera zaznaczenie i skrót zadania docelowego.
  const factory WikiPageTaskLinkResponse({
    required String id,
    required String pageId,
    required String taskId,
    required String selectionText,
    String? blockId,
    int? textStart,
    int? textEnd,
    required DateTime createdAtUtc,
    required WikiProjectTaskReferenceResponse task,
  }) = _WikiPageTaskLinkResponse;

  /// Odtwarza backlink z JSON.
  factory WikiPageTaskLinkResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiPageTaskLinkResponseFromJson(json);
}

/// Wynik podsumowania strony Wiki przez AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WikiSummarizeResponse with _$WikiSummarizeResponse {
  /// Zawiera podsumowanie, punkty i metadane providera.
  const factory WikiSummarizeResponse({
    required String summary,
    required List<String> keyPoints,
    required String provider,
    String? model,
    required DateTime generatedAtUtc,
  }) = _WikiSummarizeResponse;

  /// Odtwarza wynik z JSON.
  factory WikiSummarizeResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiSummarizeResponseFromJson(json);
}

/// Element działania wyodrębniony przez AI.
@freezed
abstract class WikiActionItemResponse with _$WikiActionItemResponse {
  /// Zawiera tytuł, opis i wskazówkę terminu.
  const factory WikiActionItemResponse({
    required String title,
    String? description,
    String? dueHint,
  }) = _WikiActionItemResponse;

  /// Odtwarza działanie z JSON.
  factory WikiActionItemResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiActionItemResponseFromJson(json);
}

/// Wynik ekstrakcji działań ze strony Wiki.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class WikiActionItemsResponse with _$WikiActionItemsResponse {
  /// Zawiera działania i metadane providera AI.
  const factory WikiActionItemsResponse({
    required List<WikiActionItemResponse> actionItems,
    required String provider,
    String? model,
    required DateTime generatedAtUtc,
  }) = _WikiActionItemsResponse;

  /// Odtwarza wynik z JSON.
  factory WikiActionItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$WikiActionItemsResponseFromJson(json);
}

/// Wynik konwersji zaznaczenia Wiki do zadania i backlinku.
@freezed
abstract class ConvertWikiSelectionToTaskResponse
    with _$ConvertWikiSelectionToTaskResponse {
  /// Zawiera utworzone zadanie oraz zapisany backlink.
  const factory ConvertWikiSelectionToTaskResponse({
    required ProjectTaskResponse task,
    required WikiPageTaskLinkResponse backlink,
  }) = _ConvertWikiSelectionToTaskResponse;

  /// Odtwarza wynik z JSON.
  factory ConvertWikiSelectionToTaskResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ConvertWikiSelectionToTaskResponseFromJson(json);
}
