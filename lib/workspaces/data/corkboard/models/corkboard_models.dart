import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/corkboard_enums.dart';
import 'package:ready_next/workspaces/data/wiki/models/wiki_models.dart';

part 'corkboard_models.freezed.dart';
part 'corkboard_models.g.dart';

/// Payload utworzenia sekcji Corkboardu.
@freezed
abstract class CreateCorkboardSectionPayload
    with _$CreateCorkboardSectionPayload {
  /// Definiuje nazwę i pozycję sekcji.
  const factory CreateCorkboardSectionPayload({
    required String name,
    @Default(0) int position,
  }) = _CreateCorkboardSectionPayload;

  /// Odtwarza payload z JSON.
  factory CreateCorkboardSectionPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateCorkboardSectionPayloadFromJson(json);
}

/// Payload utworzenia karty Corkboardu.
@freezed
abstract class CreateCorkboardCardPayload with _$CreateCorkboardCardPayload {
  /// Definiuje treść, kolor, pozycję i opcjonalną sekcję.
  const factory CreateCorkboardCardPayload({
    required String content,
    required CorkboardCardColor color,
    @Default(0) int position,
    String? sectionId,
  }) = _CreateCorkboardCardPayload;

  /// Odtwarza payload z JSON.
  factory CreateCorkboardCardPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateCorkboardCardPayloadFromJson(json);
}

/// Payload przypięcia istniejącego pliku Storage do karty.
@freezed
abstract class AttachCorkboardFilePayload with _$AttachCorkboardFilePayload {
  /// Wskazuje plik Storage.
  const factory AttachCorkboardFilePayload({required String storageFileId}) =
      _AttachCorkboardFilePayload;

  /// Odtwarza payload z JSON.
  factory AttachCorkboardFilePayload.fromJson(Map<String, dynamic> json) =>
      _$AttachCorkboardFilePayloadFromJson(json);
}

/// Sekcja tematyczna Corkboardu.
@freezed
abstract class CorkboardSectionResponse with _$CorkboardSectionResponse {
  /// Zawiera nazwę, pozycję i wersję sekcji.
  const factory CorkboardSectionResponse({
    required String id,
    required String name,
    required int position,
    required int version,
  }) = _CorkboardSectionResponse;

  /// Odtwarza sekcję z JSON.
  factory CorkboardSectionResponse.fromJson(Map<String, dynamic> json) =>
      _$CorkboardSectionResponseFromJson(json);
}

/// Załącznik karty Corkboardu.
@freezed
abstract class CorkboardAttachmentResponse with _$CorkboardAttachmentResponse {
  /// Zawiera plik i czas przypięcia.
  const factory CorkboardAttachmentResponse({
    required String id,
    required String storageFileId,
    required DateTime attachedAtUtc,
  }) = _CorkboardAttachmentResponse;

  /// Odtwarza załącznik z JSON.
  factory CorkboardAttachmentResponse.fromJson(Map<String, dynamic> json) =>
      _$CorkboardAttachmentResponseFromJson(json);
}

/// Karteczka Corkboardu wraz z załącznikami.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CorkboardCardResponse with _$CorkboardCardResponse {
  /// Zawiera treść, pozycję, stan i powiązania karty.
  const factory CorkboardCardResponse({
    required String id,
    String? sectionId,
    required String content,
    required CorkboardCardColor color,
    required int position,
    required bool isPinned,
    String? conversationId,
    String? convertedToTaskId,
    required int version,
    required List<CorkboardAttachmentResponse> attachments,
  }) = _CorkboardCardResponse;

  /// Odtwarza kartę z JSON.
  factory CorkboardCardResponse.fromJson(Map<String, dynamic> json) =>
      _$CorkboardCardResponseFromJson(json);
}

/// Payload opcjonalnego klastrowania kart przez AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CorkboardAiClusterPayload with _$CorkboardAiClusterPayload {
  /// Wskazuje karty i opcjonalny cel grupowania.
  const factory CorkboardAiClusterPayload({
    List<String>? cardIds,
    String? instruction,
  }) = _CorkboardAiClusterPayload;

  /// Odtwarza payload z JSON.
  factory CorkboardAiClusterPayload.fromJson(Map<String, dynamic> json) =>
      _$CorkboardAiClusterPayloadFromJson(json);
}

/// Payload zawężenia kart do syntezy Wiki.
@freezed
abstract class CorkboardAiSummarizeToWikiPayload
    with _$CorkboardAiSummarizeToWikiPayload {
  /// Opcjonalnie wskazuje sekcję źródłową.
  const factory CorkboardAiSummarizeToWikiPayload({String? sectionId}) =
      _CorkboardAiSummarizeToWikiPayload;

  /// Odtwarza payload z JSON.
  factory CorkboardAiSummarizeToWikiPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CorkboardAiSummarizeToWikiPayloadFromJson(json);
}

/// Grupa kart wskazana przez AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CorkboardAiClusterGroupResponse
    with _$CorkboardAiClusterGroupResponse {
  /// Zawiera sekcję i przypisane karty.
  const factory CorkboardAiClusterGroupResponse({
    required String sectionId,
    required String name,
    required List<String> cardIds,
  }) = _CorkboardAiClusterGroupResponse;

  /// Odtwarza grupę z JSON.
  factory CorkboardAiClusterGroupResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CorkboardAiClusterGroupResponseFromJson(json);
}

/// Wynik klastrowania Corkboardu przez AI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class CorkboardAiClusterResponse with _$CorkboardAiClusterResponse {
  /// Zwraca operację, providera i grupy kart.
  const factory CorkboardAiClusterResponse({
    required String operationId,
    required String operationType,
    required String provider,
    required bool idempotentReplay,
    required List<CorkboardAiClusterGroupResponse> groups,
  }) = _CorkboardAiClusterResponse;

  /// Odtwarza wynik z JSON.
  factory CorkboardAiClusterResponse.fromJson(Map<String, dynamic> json) =>
      _$CorkboardAiClusterResponseFromJson(json);
}

/// Wynik syntezy Corkboardu do strony Wiki.
@freezed
abstract class CorkboardAiSummarizeToWikiResponse
    with _$CorkboardAiSummarizeToWikiResponse {
  /// Zwraca utworzoną stronę Wiki.
  const factory CorkboardAiSummarizeToWikiResponse({
    required String operationId,
    required String operationType,
    required String provider,
    required bool idempotentReplay,
    required WikiPageResponse wikiPage,
  }) = _CorkboardAiSummarizeToWikiResponse;

  /// Odtwarza wynik z JSON.
  factory CorkboardAiSummarizeToWikiResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CorkboardAiSummarizeToWikiResponseFromJson(json);
}

/// Wynik konwersji karty Corkboardu do zadania.
@freezed
abstract class CorkboardAiConvertToTaskResponse
    with _$CorkboardAiConvertToTaskResponse {
  /// Zwraca źródłową kartę i utworzone zadanie.
  const factory CorkboardAiConvertToTaskResponse({
    required String operationId,
    required String operationType,
    required String provider,
    required bool idempotentReplay,
    required String cardId,
    required ProjectTaskResponse task,
  }) = _CorkboardAiConvertToTaskResponse;

  /// Odtwarza wynik z JSON.
  factory CorkboardAiConvertToTaskResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CorkboardAiConvertToTaskResponseFromJson(json);
}
