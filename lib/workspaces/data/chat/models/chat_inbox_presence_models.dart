import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_inbox_presence_models.freezed.dart';
part 'chat_inbox_presence_models.g.dart';

/// Żądanie bieżącej obecności znanych rozmówców 1:1 skrzynki.
@freezed
abstract class ChatInboxPresenceRequest with _$ChatInboxPresenceRequest {
  const factory ChatInboxPresenceRequest({
    @Default(<String>[]) List<String> userIds,
  }) = _ChatInboxPresenceRequest;

  factory ChatInboxPresenceRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxPresenceRequestFromJson(json);
}

/// Odpowiedź batchowa live presence dla rozmówców 1:1.
@freezed
abstract class ChatInboxPresenceResponse with _$ChatInboxPresenceResponse {
  const factory ChatInboxPresenceResponse({
    @Default(<ChatInboxPresenceUserResponse>[])
    List<ChatInboxPresenceUserResponse> users,
  }) = _ChatInboxPresenceResponse;

  factory ChatInboxPresenceResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxPresenceResponseFromJson(json);
}

/// Bieżący stan lease'u aplikacji użytkownika.
@freezed
abstract class ChatInboxPresenceUserResponse
    with _$ChatInboxPresenceUserResponse {
  const factory ChatInboxPresenceUserResponse({
    required String userId,
    required bool isOnline,
  }) = _ChatInboxPresenceUserResponse;

  factory ChatInboxPresenceUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxPresenceUserResponseFromJson(json);
}
