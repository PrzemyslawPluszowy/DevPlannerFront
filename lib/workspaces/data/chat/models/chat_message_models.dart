import 'package:devplanner/workspaces/data/chat/models/chat_attachment_models.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_content_models.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_message_action_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_models.freezed.dart';
part 'chat_message_models.g.dart';

/// Payload wysłania wiadomości Chat.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class SendChatMessagePayload with _$SendChatMessagePayload {
  /// Przekazuje treść, idempotency key i opcjonalną odpowiedź.
  const factory SendChatMessagePayload({
    required String clientMessageId,
    required String text,
    String? deltaJson,
    String? replyToMessageId,
    List<String>? attachmentFileIds,
  }) = _SendChatMessagePayload;

  /// Odtwarza payload z JSON.
  factory SendChatMessagePayload.fromJson(Map<String, dynamic> json) =>
      _$SendChatMessagePayloadFromJson(json);
}

/// Payload edycji wiadomości.
@freezed
abstract class UpdateChatMessagePayload with _$UpdateChatMessagePayload {
  /// Przekazuje nową treść i wersję wiadomości.
  const factory UpdateChatMessagePayload({
    required String text,
    String? deltaJson,
    required int version,
  }) = _UpdateChatMessagePayload;

  /// Odtwarza payload z JSON.
  factory UpdateChatMessagePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateChatMessagePayloadFromJson(json);
}

/// Wiadomość Chat.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatMessageResponse with _$ChatMessageResponse {
  /// Zawiera treść, autora, wersję i opcjonalne linki/reakcje.
  const factory ChatMessageResponse({
    required String id,
    required String conversationId,
    required String authorUserId,
    required String clientMessageId,
    required String text,
    String? deltaJson,
    String? replyToMessageId,
    required String payloadHash,
    required int version,
    required DateTime createdAtUtc,
    required bool isDeleted,
    List<ChatLinkResponse>? links,
    List<ChatReactionSummaryResponse>? reactions,
    List<ChatAttachmentResponse>? attachments,
    String? threadRootMessageId,
    @Default(false) bool isEdited,
    DateTime? deletedAtUtc,
    @Default(0) int deliveredToCount,
    @Default(0) int readByCount,
    Map<String, String>? mentionLabels,
    ChatMessageReplyPreviewResponse? replyPreview,
  }) = _ChatMessageResponse;

  /// Odtwarza wiadomość z JSON.
  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageResponseFromJson(json);
}

/// Ograniczony podgląd autora i treści cytowanej wiadomości.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatMessageReplyPreviewResponse
    with _$ChatMessageReplyPreviewResponse {
  const factory ChatMessageReplyPreviewResponse({
    required String messageId,
    required String authorUserId,
    String? authorLabel,
    required String text,
    required bool isDeleted,
    required bool hasAttachments,
    Map<String, String>? mentionLabels,
  }) = _ChatMessageReplyPreviewResponse;

  factory ChatMessageReplyPreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageReplyPreviewResponseFromJson(json);
}

/// Stan doręczenia wiadomości.
@freezed
abstract class ChatMessageDeliveryResponse with _$ChatMessageDeliveryResponse {
  /// Zawiera odbiorcę, urządzenie i stan doręczenia.
  const factory ChatMessageDeliveryResponse({
    required String messageId,
    required String recipientUserId,
    String? deviceId,
    required ChatMessageDeliveryStatus status,
    required DateTime updatedAtUtc,
    String? lastError,
  }) = _ChatMessageDeliveryResponse;

  /// Odtwarza stan z JSON.
  factory ChatMessageDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDeliveryResponseFromJson(json);
}
