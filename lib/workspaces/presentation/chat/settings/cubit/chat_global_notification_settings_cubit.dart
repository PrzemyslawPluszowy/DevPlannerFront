import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/models/chat_notification_settings.dart';

/// Właściciel globalnych kanałów powiadomień Chat bieżącego użytkownika.
///
/// Ten cubit nie jest współdzielony z globalnym inboxem ani z preferencją
/// pojedynczej rozmowy. Dzięki temu każdy zapis ma własny lifecycle i nie
/// odświeża niepowiązanych powierzchni UI.
final class ChatGlobalNotificationSettingsCubit
    extends Cubit<ChatGlobalNotificationSettingsState> {
  /// Tworzy właściciela globalnych kanałów Chat.
  ChatGlobalNotificationSettingsCubit(this._repository)
    : super(const ChatGlobalNotificationSettingsLoading());

  final ChatNotificationSettingsRepository _repository;
  int _requestGeneration = 0;

  /// Pobiera aktualne kanały dostarczania Chat dla aktywnej sesji.
  Future<void> load() async {
    final requestGeneration = ++_requestGeneration;
    emit(const ChatGlobalNotificationSettingsLoading());
    final result = await _repository.getGlobalSettings();
    if (isClosed || requestGeneration != _requestGeneration) return;
    result.fold(
      (error) => emit(_stateForError(error)),
      (settings) => emit(ChatGlobalNotificationSettingsReady(settings)),
    );
  }

  /// Zapisuje jeden kanał optymistycznie i cofa snapshot po błędzie.
  Future<bool> updateChannel(
    ChatNotificationChannel channel,
    bool enabled,
  ) async {
    final current = state;
    if (current is! ChatGlobalNotificationSettingsReady || current.isSaving) {
      return false;
    }
    if (ChatGlobalNotificationSettingsMapper.isEnabled(
          current.settings,
          channel,
        ) ==
        enabled) {
      return true;
    }

    final previous = current.settings;
    final requestGeneration = ++_requestGeneration;
    emit(
      ChatGlobalNotificationSettingsReady(
        ChatGlobalNotificationSettingsMapper.withChannel(
          previous,
          channel,
          enabled,
        ),
        isSaving: true,
      ),
    );
    final result = await _repository.updateGlobalSettings(
      ChatGlobalNotificationSettingsCommandFactory.forChannel(channel, enabled),
    );
    if (isClosed || requestGeneration != _requestGeneration) return false;

    return result.fold(
      (error) {
        if (_isAccessRevoked(error)) {
          emit(ChatGlobalNotificationSettingsRevoked(error));
        } else {
          emit(ChatGlobalNotificationSettingsReady(previous, error: error));
        }
        return false;
      },
      (settings) {
        emit(ChatGlobalNotificationSettingsReady(settings));
        return true;
      },
    );
  }

  ChatGlobalNotificationSettingsState _stateForError(ApiError error) =>
      _isAccessRevoked(error)
      ? ChatGlobalNotificationSettingsRevoked(error)
      : ChatGlobalNotificationSettingsFailure(error);

  bool _isAccessRevoked(ApiError error) =>
      error.type == ApiErrorType.unauthorized ||
      error.type == ApiErrorType.forbidden;
}

/// Kanał dostarczania, który użytkownik może zmienić w ustawieniach Chat.
enum ChatNotificationChannel { inApp, email, push, digest }

/// Konstruktor częściowych poleceń globalnych ustawień Chat.
abstract final class ChatGlobalNotificationSettingsCommandFactory {
  /// Zwraca polecenie zmieniające tylko wskazany kanał.
  static UpdateChatNotificationSettingsCommand forChannel(
    ChatNotificationChannel channel,
    bool enabled,
  ) => switch (channel) {
    ChatNotificationChannel.inApp => UpdateChatNotificationSettingsCommand(
      inAppEnabled: enabled,
    ),
    ChatNotificationChannel.email => UpdateChatNotificationSettingsCommand(
      emailEnabled: enabled,
    ),
    ChatNotificationChannel.push => UpdateChatNotificationSettingsCommand(
      pushEnabled: enabled,
    ),
    ChatNotificationChannel.digest => UpdateChatNotificationSettingsCommand(
      digestEnabled: enabled,
    ),
  };
}

/// Stan pobierania i zapisu globalnych ustawień Chat.
sealed class ChatGlobalNotificationSettingsState {
  const ChatGlobalNotificationSettingsState();
}

/// Trwa pierwszy odczyt preferencji Chat.
final class ChatGlobalNotificationSettingsLoading
    extends ChatGlobalNotificationSettingsState {
  const ChatGlobalNotificationSettingsLoading();
}

/// Odczyt kanałów Chat zakończył się błędem, który można ponowić.
final class ChatGlobalNotificationSettingsFailure
    extends ChatGlobalNotificationSettingsState {
  const ChatGlobalNotificationSettingsFailure(this.error);

  final ApiError error;
}

/// Sesja nie może dalej odczytać albo zapisać ustawień Chat.
final class ChatGlobalNotificationSettingsRevoked
    extends ChatGlobalNotificationSettingsState {
  const ChatGlobalNotificationSettingsRevoked(this.error);

  final ApiError error;
}

/// Załadowany snapshot z opcjonalnym zapisem lub błędem zapisu.
final class ChatGlobalNotificationSettingsReady
    extends ChatGlobalNotificationSettingsState {
  const ChatGlobalNotificationSettingsReady(
    this.settings, {
    this.isSaving = false,
    this.error,
  });

  final ChatNotificationSettings settings;
  final bool isSaving;
  final ApiError? error;
}

/// Czyste mapowanie snapshotu domenowego na zmianę pojedynczego kanału.
abstract final class ChatGlobalNotificationSettingsMapper {
  /// Zwraca wartość wybranego kanału dla snapshotu.
  static bool isEnabled(
    ChatNotificationSettings settings,
    ChatNotificationChannel channel,
  ) => switch (channel) {
    ChatNotificationChannel.inApp => settings.inAppEnabled,
    ChatNotificationChannel.email => settings.emailEnabled,
    ChatNotificationChannel.push => settings.pushEnabled,
    ChatNotificationChannel.digest => settings.digestEnabled,
  };

  /// Zwraca nowy snapshot ze zmienionym wyłącznie jednym kanałem.
  static ChatNotificationSettings withChannel(
    ChatNotificationSettings settings,
    ChatNotificationChannel channel,
    bool enabled,
  ) => ChatNotificationSettings(
    coreUserId: settings.coreUserId,
    inAppEnabled: channel == ChatNotificationChannel.inApp
        ? enabled
        : settings.inAppEnabled,
    emailEnabled: channel == ChatNotificationChannel.email
        ? enabled
        : settings.emailEnabled,
    pushEnabled: channel == ChatNotificationChannel.push
        ? enabled
        : settings.pushEnabled,
    digestEnabled: channel == ChatNotificationChannel.digest
        ? enabled
        : settings.digestEnabled,
  );
}
