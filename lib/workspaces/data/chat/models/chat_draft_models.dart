import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_draft_models.freezed.dart';
part 'chat_draft_models.g.dart';

/// Payload zapisu albo aktualizacji szkicu wiadomości.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpsertChatDraftPayload with _$UpsertChatDraftPayload {
  /// Przekazuje treść, wersję i pliki szkicu.
  const factory UpsertChatDraftPayload({
    String? text,
    String? deltaJson,
    String? replyToMessageId,
    @Default(0) int version,
    List<String>? attachmentStorageFileIds,
  }) = _UpsertChatDraftPayload;

  /// Odtwarza payload z JSON.
  factory UpsertChatDraftPayload.fromJson(Map<String, dynamic> json) =>
      _$UpsertChatDraftPayloadFromJson(json);
}

/// Prywatny szkic wiadomości użytkownika.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatDraftResponse with _$ChatDraftResponse {
  /// Zawiera treść szkicu i jego załączniki.
  const factory ChatDraftResponse({
    required String id,
    required String conversationId,
    String? text,
    String? deltaJson,
    String? replyToMessageId,
    required int version,
    required DateTime updatedAtUtc,
    List<ChatDraftAttachmentResponse>? attachments,
  }) = _ChatDraftResponse;

  /// Odtwarza szkic z JSON.
  factory ChatDraftResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatDraftResponseFromJson(json);
}

/// Załącznik zapisany w szkicu wiadomości.
@freezed
abstract class ChatDraftAttachmentResponse with _$ChatDraftAttachmentResponse {
  /// Zawiera plik i jego kolejność w szkicu.
  const factory ChatDraftAttachmentResponse({
    required String id,
    required String storageFileId,
    required int position,
    required DateTime createdAtUtc,
  }) = _ChatDraftAttachmentResponse;

  /// Odtwarza załącznik szkicu z JSON.
  factory ChatDraftAttachmentResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatDraftAttachmentResponseFromJson(json);
}
