import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_notification_models.freezed.dart';
part 'chat_notification_models.g.dart';

/// Globalne preferencje powiadomień Chat.
@freezed
abstract class ChatUserNotificationPreferenceResponse
    with _$ChatUserNotificationPreferenceResponse {
  /// Zawiera preferencje kanałów in-app, e-mail, push i digest.
  const factory ChatUserNotificationPreferenceResponse({
    required String userId,
    required bool inAppEnabled,
    required bool emailEnabled,
    required bool pushEnabled,
    required bool digestEnabled,
  }) = _ChatUserNotificationPreferenceResponse;

  /// Odtwarza preferencje z JSON.
  factory ChatUserNotificationPreferenceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ChatUserNotificationPreferenceResponseFromJson(json);
}

/// Payload aktualizacji globalnych preferencji Chat.
@freezed
abstract class UpdateChatUserNotificationPreferencePayload
    with _$UpdateChatUserNotificationPreferencePayload {
  /// Null pozostawia bieżącą wartość kanału.
  const factory UpdateChatUserNotificationPreferencePayload({
    bool? inAppEnabled,
    bool? emailEnabled,
    bool? pushEnabled,
    bool? digestEnabled,
  }) = _UpdateChatUserNotificationPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateChatUserNotificationPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateChatUserNotificationPreferencePayloadFromJson(json);
}

/// Osobista preferencja powiadomień konkretnej rozmowy.
@freezed
abstract class ChatNotificationPreferenceResponse
    with _$ChatNotificationPreferenceResponse {
  /// Zawiera rozmowę, użytkownika i politykę powiadomień.
  const factory ChatNotificationPreferenceResponse({
    required String conversationId,
    required String userId,
    required ChatNotificationPreference preference,
  }) = _ChatNotificationPreferenceResponse;

  /// Odtwarza preferencję z JSON.
  factory ChatNotificationPreferenceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ChatNotificationPreferenceResponseFromJson(json);
}

/// Payload zmiany osobistej polityki powiadomień rozmowy.
@freezed
abstract class UpdateChatNotificationPreferencePayload
    with _$UpdateChatNotificationPreferencePayload {
  /// Ustawia politykę All, MentionsOnly, HighOnly albo Muted.
  const factory UpdateChatNotificationPreferencePayload({
    required ChatNotificationPreference preference,
  }) = _UpdateChatNotificationPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateChatNotificationPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateChatNotificationPreferencePayloadFromJson(json);
}
