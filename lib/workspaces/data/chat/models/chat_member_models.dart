import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_member_models.freezed.dart';
part 'chat_member_models.g.dart';

/// Payload dodania członków rozmowy.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AddChatMembersPayload with _$AddChatMembersPayload {
  /// Przekazuje UUID lokalnych użytkowników do dodania.
  const factory AddChatMembersPayload({
    List<String>? userIds,
  }) = _AddChatMembersPayload;

  /// Odtwarza payload z JSON.
  factory AddChatMembersPayload.fromJson(Map<String, dynamic> json) =>
      _$AddChatMembersPayloadFromJson(json);
}

/// Payload zmiany roli członka rozmowy.
@freezed
abstract class UpdateChatMemberRolePayload with _$UpdateChatMemberRolePayload {
  /// Ustawia rolę Member, Moderator, Observer albo Owner.
  const factory UpdateChatMemberRolePayload({required String role}) =
      _UpdateChatMemberRolePayload;

  /// Odtwarza payload z JSON.
  factory UpdateChatMemberRolePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateChatMemberRolePayloadFromJson(json);
}

/// Członek rozmowy Chat.
@freezed
abstract class ChatMemberResponse with _$ChatMemberResponse {
  /// Zawiera użytkownika, rolę, czas dołączenia i opcjonalny profil lokalny.
  const factory ChatMemberResponse({
    required String userId,
    required String role,
    required DateTime joinedAtUtc,
    String? login,
    String? displayName,
    String? avatarUrl,
  }) = _ChatMemberResponse;

  /// Odtwarza członka z JSON.
  factory ChatMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMemberResponseFromJson(json);
}

/// Sugestia użytkownika do wzmianki.
@freezed
abstract class ChatMentionSuggestionResponse
    with _$ChatMentionSuggestionResponse {
  /// Zawiera login, nazwę i avatar użytkownika.
  const factory ChatMentionSuggestionResponse({
    required String userId,
    required String login,
    required String displayName,
    String? avatarUrl,
  }) = _ChatMentionSuggestionResponse;

  /// Odtwarza sugestię z JSON.
  factory ChatMentionSuggestionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMentionSuggestionResponseFromJson(json);
}
