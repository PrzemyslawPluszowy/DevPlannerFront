import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_presence_models.freezed.dart';
part 'chat_presence_models.g.dart';

/// Payload ustawienia statusu użytkownika Chat.
@freezed
abstract class UpsertChatUserStatusPayload with _$UpsertChatUserStatusPayload {
  /// Przekazuje emoji, tekst, wygaśnięcie i tryb DND.
  const factory UpsertChatUserStatusPayload({
    String? emoji,
    String? text,
    DateTime? expiresAtUtc,
    @Default(false) bool isDnd,
  }) = _UpsertChatUserStatusPayload;

  /// Odtwarza payload z JSON.
  factory UpsertChatUserStatusPayload.fromJson(Map<String, dynamic> json) =>
      _$UpsertChatUserStatusPayloadFromJson(json);
}

/// Status użytkownika Chat.
@freezed
abstract class ChatUserStatusResponse with _$ChatUserStatusResponse {
  /// Zawiera status, DND i czas aktualizacji.
  const factory ChatUserStatusResponse({
    required String userId,
    String? emoji,
    String? text,
    DateTime? expiresAtUtc,
    required bool isDnd,
    required DateTime updatedAtUtc,
  }) = _ChatUserStatusResponse;

  /// Odtwarza status z JSON.
  factory ChatUserStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatUserStatusResponseFromJson(json);
}
