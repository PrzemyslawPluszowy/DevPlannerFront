import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_action_models.freezed.dart';
part 'chat_message_action_models.g.dart';

/// Payload przekazania wiadomości do innej rozmowy.
@freezed
abstract class ForwardChatMessagePayload with _$ForwardChatMessagePayload {
  /// Wskazuje rozmowę docelową i nowy idempotency key.
  const factory ForwardChatMessagePayload({
    required String targetConversationId,
    required String clientMessageId,
  }) = _ForwardChatMessagePayload;

  /// Odtwarza payload z JSON.
  factory ForwardChatMessagePayload.fromJson(Map<String, dynamic> json) =>
      _$ForwardChatMessagePayloadFromJson(json);
}

/// Rewizja poprzedniej treści wiadomości.
@freezed
abstract class ChatMessageRevisionResponse with _$ChatMessageRevisionResponse {
  /// Zawiera snapshot treści i wersję rewizji.
  const factory ChatMessageRevisionResponse({
    required String id,
    required String messageId,
    required String authorUserId,
    required String editedByUserId,
    required String text,
    String? deltaJson,
    required DateTime createdAtUtc,
    required int version,
    required int newVersion,
  }) = _ChatMessageRevisionResponse;

  /// Odtwarza rewizję z JSON.
  factory ChatMessageRevisionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageRevisionResponseFromJson(json);
}

/// Reakcja emoji w agregacie wiadomości.
@freezed
abstract class ChatReactionSummaryResponse with _$ChatReactionSummaryResponse {
  /// Zawiera emoji, licznik i reakcję bieżącego użytkownika.
  const factory ChatReactionSummaryResponse({
    required String emoji,
    required int count,
    required bool reactedByCurrentUser,
  }) = _ChatReactionSummaryResponse;

  /// Odtwarza agregat z JSON.
  factory ChatReactionSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatReactionSummaryResponseFromJson(json);
}

/// Payload dodania reakcji emoji.
@freezed
abstract class AddChatReactionPayload with _$AddChatReactionPayload {
  /// Przekazuje emoji reakcji.
  const factory AddChatReactionPayload({required String emoji}) =
      _AddChatReactionPayload;

  /// Odtwarza payload z JSON.
  factory AddChatReactionPayload.fromJson(Map<String, dynamic> json) =>
      _$AddChatReactionPayloadFromJson(json);
}

/// Reakcja emoji użytkownika.
@freezed
abstract class ChatReactionResponse with _$ChatReactionResponse {
  /// Zawiera wiadomość, użytkownika, emoji i czas.
  const factory ChatReactionResponse({
    required String id,
    required String messageId,
    required String userId,
    required String emoji,
    required DateTime createdAtUtc,
  }) = _ChatReactionResponse;

  /// Odtwarza reakcję z JSON.
  factory ChatReactionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatReactionResponseFromJson(json);
}

/// Payload wyciszenia rozmowy.
@freezed
abstract class ChatMutePayload with _$ChatMutePayload {
  /// Ustawia czas końca wyciszenia albo null dla wyciszenia bezterminowego.
  const factory ChatMutePayload({DateTime? untilUtc}) = _ChatMutePayload;

  /// Odtwarza payload z JSON.
  factory ChatMutePayload.fromJson(Map<String, dynamic> json) =>
      _$ChatMutePayloadFromJson(json);
}

/// Payload wyciszenia wątku rozmowy.
@freezed
abstract class ChatThreadMutePayload with _$ChatThreadMutePayload {
  /// Ustawia czas końca wyciszenia wątku.
  const factory ChatThreadMutePayload({DateTime? untilUtc}) =
      _ChatThreadMutePayload;

  /// Odtwarza payload z JSON.
  factory ChatThreadMutePayload.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadMutePayloadFromJson(json);
}

/// Zaproszenie e-mail do rozmowy.
/// Payload dodania zakładki do wiadomości.
@freezed
abstract class ChatBookmarkPayload with _$ChatBookmarkPayload {
  /// Ustawia prywatną notatkę zakładki.
  const factory ChatBookmarkPayload({String? note}) = _ChatBookmarkPayload;

  /// Odtwarza payload z JSON.
  factory ChatBookmarkPayload.fromJson(Map<String, dynamic> json) =>
      _$ChatBookmarkPayloadFromJson(json);
}

/// Prywatna zakładka wiadomości.
@freezed
abstract class ChatBookmarkResponse with _$ChatBookmarkResponse {
  /// Zawiera wiadomość, rozmowę, właściciela i notatkę.
  const factory ChatBookmarkResponse({
    required String id,
    required String messageId,
    required String conversationId,
    required String userId,
    String? note,
    required DateTime createdAtUtc,
  }) = _ChatBookmarkResponse;

  /// Odtwarza zakładkę z JSON.
  factory ChatBookmarkResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatBookmarkResponseFromJson(json);
}

/// Przypięta wiadomość rozmowy.
@freezed
abstract class ChatPinnedMessageResponse with _$ChatPinnedMessageResponse {
  /// Zawiera wiadomość, autora przypięcia i czas.
  const factory ChatPinnedMessageResponse({
    required String id,
    required String conversationId,
    required String messageId,
    required String pinnedByUserId,
    required DateTime pinnedAtUtc,
  }) = _ChatPinnedMessageResponse;

  /// Odtwarza przypięcie z JSON.
  factory ChatPinnedMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatPinnedMessageResponseFromJson(json);
}
