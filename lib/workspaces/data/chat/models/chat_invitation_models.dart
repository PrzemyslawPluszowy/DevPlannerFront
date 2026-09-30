import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_invitation_models.freezed.dart';
part 'chat_invitation_models.g.dart';

/// Payload utworzenia zaproszenia e-mail do rozmowy.
@freezed
abstract class CreateChatInvitePayload with _$CreateChatInvitePayload {
  /// Przekazuje adres e-mail i czas życia zaproszenia.
  const factory CreateChatInvitePayload({
    required String email,
    @Default(72) int ttlHours,
  }) = _CreateChatInvitePayload;

  /// Odtwarza payload z JSON.
  factory CreateChatInvitePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateChatInvitePayloadFromJson(json);
}

/// Payload akceptacji zaproszenia do rozmowy.
@freezed
abstract class AcceptChatInvitePayload with _$AcceptChatInvitePayload {
  /// Przekazuje jednorazowy token z wiadomości e-mail.
  const factory AcceptChatInvitePayload({required String token}) =
      _AcceptChatInvitePayload;

  /// Odtwarza payload z JSON.
  factory AcceptChatInvitePayload.fromJson(Map<String, dynamic> json) =>
      _$AcceptChatInvitePayloadFromJson(json);
}
