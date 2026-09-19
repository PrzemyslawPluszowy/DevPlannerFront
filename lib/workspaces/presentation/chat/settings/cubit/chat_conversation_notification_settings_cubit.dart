import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Właściciel preferencji powiadomień jednej rozmowy Chat.
///
/// Id rozmowy pozostaje prywatny dla cubita — widget nie składa endpointu ani
/// nie wykonuje żadnego żądania. Stan jest lokalny dla otwartego dialogu.
final class ChatConversationNotificationSettingsCubit
    extends Cubit<ChatConversationNotificationSettingsState> {
  /// Tworzy właściciela preferencji jednej rozmowy.
  ChatConversationNotificationSettingsCubit(
    this._repository,
    this._conversationId,
  ) : super(const ChatConversationNotificationSettingsLoading());

  final ChatNotificationSettingsRepository _repository;
  final String _conversationId;
  int _requestGeneration = 0;

  /// Pobiera skuteczną politykę dostarczania rozmowy.
  Future<void> load() async {
    final requestGeneration = ++_requestGeneration;
    emit(const ChatConversationNotificationSettingsLoading());
    final result = await _repository.getConversationSetting(_conversationId);
    if (isClosed || requestGeneration != _requestGeneration) return;
    result.fold(
      (error) => emit(_stateForError(error)),
      (setting) => emit(ChatConversationNotificationSettingsReady(setting)),
    );
  }

  /// Zapisuje politykę rozmowy optymistycznie; na błędzie przywraca snapshot.
  Future<bool> updateMode(ChatConversationNotificationMode mode) async {
    final current = state;
    if (current is! ChatConversationNotificationSettingsReady ||
        current.isSaving) {
      return false;
    }
    if (current.setting.mode == mode) return true;

    final previous = current.setting;
    final requestGeneration = ++_requestGeneration;
    emit(
      ChatConversationNotificationSettingsReady(
        ChatConversationNotificationSetting(
          conversationId: previous.conversationId,
          userId: previous.userId,
          mode: mode,
        ),
        isSaving: true,
      ),
    );
    final result = await _repository.updateConversationSetting(
      conversationId: _conversationId,
      mode: mode,
    );
    if (isClosed || requestGeneration != _requestGeneration) return false;

    return result.fold(
      (error) {
        if (_isAccessRevoked(error)) {
          emit(ChatConversationNotificationSettingsRevoked(error));
        } else {
          emit(
            ChatConversationNotificationSettingsReady(previous, error: error),
          );
        }
        return false;
      },
      (setting) {
        emit(ChatConversationNotificationSettingsReady(setting));
        return true;
      },
    );
  }

  ChatConversationNotificationSettingsState _stateForError(
    ApiError error,
  ) => _isAccessRevoked(error)
      ? ChatConversationNotificationSettingsRevoked(error)
      : ChatConversationNotificationSettingsFailure(error);

  bool _isAccessRevoked(ApiError error) =>
      error.type == ApiErrorType.unauthorized ||
      error.type == ApiErrorType.forbidden;
}

/// Stan pobierania i zapisu preferencji pojedynczej rozmowy.
sealed class ChatConversationNotificationSettingsState {
  const ChatConversationNotificationSettingsState();
}

/// Trwa pierwszy odczyt ustawienia rozmowy.
final class ChatConversationNotificationSettingsLoading
    extends ChatConversationNotificationSettingsState {
  const ChatConversationNotificationSettingsLoading();
}

/// Odczyt ustawienia rozmowy zakończył się błędem możliwym do ponowienia.
final class ChatConversationNotificationSettingsFailure
    extends ChatConversationNotificationSettingsState {
  const ChatConversationNotificationSettingsFailure(this.error);

  final ApiError error;
}

/// Użytkownik stracił dostęp do ustawienia rozmowy w trakcie operacji.
final class ChatConversationNotificationSettingsRevoked
    extends ChatConversationNotificationSettingsState {
  const ChatConversationNotificationSettingsRevoked(this.error);

  final ApiError error;
}

/// Załadowana polityka z opcjonalnym zapisem lub błędem zapisu.
final class ChatConversationNotificationSettingsReady
    extends ChatConversationNotificationSettingsState {
  const ChatConversationNotificationSettingsReady(
    this.setting, {
    this.isSaving = false,
    this.error,
  });

  final ChatConversationNotificationSetting setting;
  final bool isSaving;
  final ApiError? error;
}
