import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/notifications/models/chat_notification_settings.dart';

/// Port globalnych i per-rozmowa ustawień dostarczania Chat.
abstract interface class ChatNotificationSettingsRepository {
  /// Pobiera globalne kanały dostarczania Chat bieżącego użytkownika.
  Future<Either<ApiError, ChatNotificationSettings>> getGlobalSettings();

  /// Aktualizuje wyłącznie kanały przekazane w poleceniu.
  Future<Either<ApiError, ChatNotificationSettings>> updateGlobalSettings(
    UpdateChatNotificationSettingsCommand command,
  );

  /// Pobiera politykę dostarczania dla jednej rozmowy.
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  getConversationSetting(String conversationId);

  /// Ustawia politykę dostarczania dla jednej rozmowy.
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  updateConversationSetting({
    required String conversationId,
    required ChatConversationNotificationMode mode,
  });
}
