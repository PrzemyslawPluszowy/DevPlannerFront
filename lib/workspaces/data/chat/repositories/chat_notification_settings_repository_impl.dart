import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/chat/api/chat_api.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/chat_enums.dart'
    as transport;
import 'package:ready_next/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/models/chat_notification_settings.dart';

/// Adapter ustawień dostarczania Chat, osobny od historii i composera rozmowy.
final class ChatNotificationSettingsRepositoryImpl extends ApiRepository
    implements ChatNotificationSettingsRepository {
  /// Tworzy adapter na prywatnym kliencie Chat Workspaces.
  ChatNotificationSettingsRepositoryImpl(ChatApi api) : _api = api;

  final ChatApi _api;

  @override
  Future<Either<ApiError, ChatNotificationSettings>> getGlobalSettings() =>
      guardApiCall(
        () async =>
            _toGlobalSettings(await _api.getUserNotificationPreferences()),
        fallbackMessage: 'Nie udało się pobrać ustawień powiadomień Chat.',
        parsingMessage: 'Backend zwrócił nieprawidłowe ustawienia Chat.',
      );

  @override
  Future<Either<ApiError, ChatNotificationSettings>> updateGlobalSettings(
    UpdateChatNotificationSettingsCommand command,
  ) => guardApiCall(
    () async => _toGlobalSettings(
      await _api.updateUserNotificationPreferences(
        UpdateChatUserNotificationPreferencePayload(
          inAppEnabled: command.inAppEnabled,
          emailEnabled: command.emailEnabled,
          pushEnabled: command.pushEnabled,
          digestEnabled: command.digestEnabled,
        ),
      ),
    ),
    fallbackMessage: 'Nie udało się zapisać ustawień powiadomień Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłowe ustawienia Chat.',
  );

  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  getConversationSetting(String conversationId) => guardApiCall(
    () async => _toConversationSetting(
      await _api.getNotificationPreference(conversationId),
    ),
    fallbackMessage: 'Nie udało się pobrać ustawień rozmowy Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłowe ustawienia rozmowy Chat.',
  );

  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  updateConversationSetting({
    required String conversationId,
    required ChatConversationNotificationMode mode,
  }) => guardApiCall(
    () async => _toConversationSetting(
      await _api.setNotificationPreference(
        conversationId,
        UpdateChatNotificationPreferencePayload(
          preference: _toTransportMode(mode),
        ),
      ),
    ),
    fallbackMessage: 'Nie udało się zapisać ustawień rozmowy Chat.',
    parsingMessage: 'Backend zwrócił nieprawidłowe ustawienia rozmowy Chat.',
  );

  ChatNotificationSettings _toGlobalSettings(
    ChatUserNotificationPreferenceResponse response,
  ) => ChatNotificationSettings(
    coreUserId: response.coreUserId,
    inAppEnabled: response.inAppEnabled,
    emailEnabled: response.emailEnabled,
    pushEnabled: response.pushEnabled,
    digestEnabled: response.digestEnabled,
  );

  ChatConversationNotificationSetting _toConversationSetting(
    ChatNotificationPreferenceResponse response,
  ) => ChatConversationNotificationSetting(
    conversationId: response.conversationId,
    coreUserId: response.coreUserId,
    mode: _fromTransportMode(response.preference),
  );

  ChatConversationNotificationMode _fromTransportMode(
    transport.ChatNotificationPreference value,
  ) => switch (value) {
    transport.ChatNotificationPreference.all =>
      ChatConversationNotificationMode.all,
    transport.ChatNotificationPreference.mentionsOnly =>
      ChatConversationNotificationMode.mentionsOnly,
    transport.ChatNotificationPreference.muted =>
      ChatConversationNotificationMode.muted,
    transport.ChatNotificationPreference.highOnly =>
      ChatConversationNotificationMode.highOnly,
  };

  transport.ChatNotificationPreference _toTransportMode(
    ChatConversationNotificationMode value,
  ) => switch (value) {
    ChatConversationNotificationMode.all =>
      transport.ChatNotificationPreference.all,
    ChatConversationNotificationMode.mentionsOnly =>
      transport.ChatNotificationPreference.mentionsOnly,
    ChatConversationNotificationMode.muted =>
      transport.ChatNotificationPreference.muted,
    ChatConversationNotificationMode.highOnly =>
      transport.ChatNotificationPreference.highOnly,
  };
}
